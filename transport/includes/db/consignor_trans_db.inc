<?php
/**********************************************************************
    Copyright (C) FrontAccounting, LLC.
	Released under the terms of the GNU General Public License, GPL, 
	as published by the Free Software Foundation, either version 3 
	of the License, or (at your option) any later version.
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  
    See the License here <http://www.gnu.org/licenses/gpl-3.0.html>.
***********************************************************************/
//----------------------------------------------------------------------------------------
// Mark changes in consignor_trans_details
//
function update_consignor_trans_version($type, $versions) {

	$sql= 'UPDATE '.TB_PREF. 'consignor_trans SET version=version+1
			WHERE type='.db_escape($type).' AND (';

	foreach ($versions as $trans_no=>$version)
		$where[] = 	'(trans_no='.db_escape($trans_no).' AND version='.$version.')';

		$sql .= implode(' OR ', $where) .')';

	return  db_query($sql, 'Concurrent editing conflict');
}

//----------------------------------------------------------------------------------------
// Gets document header versions for transaction set of type $type
// $trans_no = array(num1, num2,...);
// returns array(num1=>ver1, num2=>ver2...)
//
function get_consignor_trans_version($type, $trans_no) {
	if (!is_array($trans_no))
		$trans_no = array( $trans_no );

	$sql= 'SELECT trans_no, version FROM '.TB_PREF. 'consignor_trans
			WHERE type='.db_escape($type).' AND (';

	foreach ($trans_no as $key=>$trans)
		$trans_no[$key] = 	'trans_no='.db_escape($trans_no[$key]);

	$sql .= implode(' OR ', $trans_no) . ')';

	$res = db_query($sql, 'document version retreival');
	
	$vers = array();
	while($mysql=db_fetch($res)) {
		$vers[$mysql['trans_no']] = $mysql['version'];
	}
	return $vers;
}
//----------------------------------------------------------------------------------------
// $Total, $Tax, $Freight, $discount all in consignor's currency
// date_ is display date (non-sql)
function write_consignor_trans($trans_type, $trans_no, $consignor_no, 
	$date_, $reference, $Total, $discount=0, $Tax=0, $Freight=0, $FreightTax=0,
	$transport_type=0, $order_no=0, $ship_via=0, $due_date="",
	$AllocAmt=0, $rate=0, $dimension_id=0, $dimension2_id=0, $payment_terms=null)
{
	$new = $trans_no==0;
	$curr = get_consignor_currency($consignor_no);
	if ($rate == 0)
		$rate = get_exchange_rate_from_home_currency($curr, $date_);

	$SQLDate = date2sql($date_);
	if ($due_date == "")
		$SQLDueDate = "0000-00-00";
	else
		$SQLDueDate = date2sql($due_date);
	
	if ($trans_type == ST_BANKPAYMENT)
		$Total = -$Total;

    if ($new || !exists_consignor_trans($trans_type, $trans_no))
    {
        if ($new)
        $trans_no = get_next_trans_no($trans_type);

	$sql = "INSERT INTO ".TB_PREF."consignor_trans (
		trans_no, type,
		consignor_no, 
		tran_date, due_date,
		reference, tpe,
		order_, ov_amount, ov_discount,
		ov_gst, ov_freight, ov_freight_tax,
		rate, ship_via, alloc,
		dimension_id, dimension2_id, payment_terms
		) VALUES (".db_escape($trans_no).", ".db_escape($trans_type).",
		".db_escape($consignor_no).", 
		'$SQLDate', '$SQLDueDate', ".db_escape($reference).",
		".db_escape($transport_type).", ".db_escape($order_no).", $Total, ".db_escape($discount).", $Tax,
		".db_escape($Freight).",
		$FreightTax, $rate, ".db_escape($ship_via).", $AllocAmt,
		".db_escape($dimension_id).", ".db_escape($dimension2_id).", "
		.db_escape($payment_terms, true).")";
	} else {	// may be optional argument should stay unchanged ?
	$sql = "UPDATE ".TB_PREF."consignor_trans SET
		consignor_no=".db_escape($consignor_no)." , 
		tran_date='$SQLDate', due_date='$SQLDueDate',
		reference=".db_escape($reference).", tpe=".db_escape($transport_type).", order_=".db_escape($order_no).",
		ov_amount=$Total, ov_discount=".db_escape($discount).", ov_gst=$Tax,
		ov_freight=".db_escape($Freight).", ov_freight_tax=$FreightTax, rate=$rate,
		ship_via=".db_escape($ship_via).", alloc=$AllocAmt,
		dimension_id=".db_escape($dimension_id).", dimension2_id=".db_escape($dimension2_id).",
		payment_terms=".db_escape($payment_terms, true)."
		WHERE trans_no=".db_escape($trans_no)." AND type=".db_escape($trans_type);
	}
	db_query($sql, "The consignor transaction record could not be inserted");

	add_audit_trail($trans_type, $trans_no, $date_, $new ? '': _("Updated."));

	return $trans_no;
}
//----------------------------------------------------------------------------------------

function get_consignor_trans($trans_id, $trans_type)
{
	global $go_debug;

	$sql = "SELECT trans.*,"
		."ov_amount+ov_gst+ov_freight+ov_freight_tax+ov_discount AS Total,"
		."consignor.name AS ConsignorName, consignor.address, "
		."consignor.curr_code, "
		."consignor.tax_id, "
		."com.memo_";

	if ($trans_type == ST_CONSIGNORPAYMENT || $trans_type == ST_BANKDEPOSIT) {
		// it's a payment so also get the bank account
		// Chaitanya : Added bank_act to support Consignor Payment Edit
		$sql .= ",bank_act,".TB_PREF."bank_accounts.bank_name, ".TB_PREF."bank_accounts.bank_account_name,
			".TB_PREF."bank_accounts.account_type AS BankTransType,
			".TB_PREF."bank_accounts.bank_curr_code,
			".TB_PREF."bank_trans.amount as bank_amount";
	}

	if ($trans_type == ST_TRANSPORTINVOICE || $trans_type == ST_CONSIGNORCREDIT || $trans_type == ST_CONSIGNORDELIVERY) {
		// it's an invoice so also get the shipper and transporttype
		$sql .= ", ".TB_PREF."shippers.shipper_name, "
		.TB_PREF."transport_types.transport_type, "
		.TB_PREF."transport_types.tax_included, "
		."branch.*, "
		."consignor.discount, "
		.TB_PREF."tax_groups.name AS tax_group_name, "
		.TB_PREF."tax_groups.id AS tax_group_id ";
	}

	$sql .= " FROM ".TB_PREF."consignor_trans trans
					LEFT JOIN ".TB_PREF."comments com ON trans.type=com.type AND trans.trans_no=com.id
					LEFT JOIN ".TB_PREF."shippers ON ".TB_PREF."shippers.shipper_id=trans.ship_via, 
					".TB_PREF."consignors_master consignor";

	if ($trans_type == ST_CONSIGNORPAYMENT || $trans_type == ST_BANKDEPOSIT) {
		// it's a payment so also get the bank account
		$sql .= ", ".TB_PREF."bank_trans, ".TB_PREF."bank_accounts";
	}

	if ($trans_type == ST_TRANSPORTINVOICE || $trans_type == ST_CONSIGNORCREDIT || $trans_type == ST_CONSIGNORDELIVERY) {
		// it's an invoice so also get the shipper, transporttypes
		$sql .= ", ".TB_PREF."transport_types, "
		.TB_PREF."consignor_branch branch, "
		.TB_PREF."tax_groups ";
	}

	$sql .= " WHERE trans.trans_no=".db_escape($trans_id)."
		AND trans.type=".db_escape($trans_type)."
		AND trans.consignor_no=consignor.consignor_no";

	if ($trans_type == ST_CONSIGNORPAYMENT || $trans_type == ST_BANKDEPOSIT) {
		// it's a payment so also get the bank account
		$sql .= " AND ".TB_PREF."bank_trans.trans_no =".db_escape($trans_id)."
			AND ".TB_PREF."bank_trans.type=$trans_type
			AND ".TB_PREF."bank_trans.amount != 0
			AND ".TB_PREF."bank_accounts.id=".TB_PREF."bank_trans.bank_act ";
	}
	if ($trans_type == ST_TRANSPORTINVOICE || $trans_type == ST_CONSIGNORCREDIT || $trans_type == ST_CONSIGNORDELIVERY) {
		// it's an invoice so also get the shipper
		$sql .= " AND ".TB_PREF."transport_types.id = trans.tpe
			AND branch.branch_code = trans.branch_code
			AND branch.tax_group_id = ".TB_PREF."tax_groups.id ";
	}

	$result = db_query($sql, "Cannot retreive a consignor transaction");

	if (db_num_rows($result) == 0) {
		// can't return nothing
		if($go_debug)
			display_backtrace();
		display_db_error("no consignor trans found for given params", $sql, true);
		exit;
	}
	if (db_num_rows($result) > 1) {
		// can't return multiple
		if($go_debug)
			display_backtrace();
		display_db_error("duplicate consignor transactions found for given params", $sql, true);
		exit;
	}

	$row = db_fetch($result);
	return $row;
}

//----------------------------------------------------------------------------------------

function exists_consignor_trans($type, $type_no)
{
	$sql = "SELECT trans_no FROM ".TB_PREF."consignor_trans WHERE type=".db_escape($type)."
		AND trans_no=".db_escape($type_no);

	$result = db_query($sql, "Cannot retreive a consignor transaction");

	return (db_num_rows($result) > 0);
}

//----------------------------------------------------------------------------------------

// retreives the related transport booking for a given trans

function get_consignor_trans_order($type, $type_no)
{
	$sql = "SELECT order_ FROM ".TB_PREF."consignor_trans WHERE type=".db_escape($type)." AND trans_no=".db_escape($type_no);

	$result = db_query($sql, "The consignor transaction could not be queried");

	$row = db_fetch_row($result);

	return $row[0];
}

//----------------------------------------------------------------------------------------

function get_consignor_details_from_trans($type, $type_no)
{
	$sql = "SELECT ".TB_PREF."consignors_master.name, ".TB_PREF."consignors_master.curr_code, ".TB_PREF."consignor_branch.br_name
		FROM ".TB_PREF."consignors_master,".TB_PREF."consignor_branch,".TB_PREF."consignor_trans
		WHERE ".TB_PREF."consignor_trans.type=".db_escape($type)." AND ".TB_PREF."consignor_trans.trans_no=".db_escape($type_no)."
		AND ".TB_PREF."consignors_master.consignor_no = ".TB_PREF."consignor_trans.consignor_no
		AND	".TB_PREF."consignor_branch.branch_code = ".TB_PREF."consignor_trans.branch_code";

	$result = db_query($sql, "could not get consignor details from trans");
	return db_fetch($result);
}

//----------------------------------------------------------------------------------------

function void_consignor_trans($type, $type_no)
{
	// clear all values and mark as void
	$sql = "UPDATE ".TB_PREF."consignor_trans SET ov_amount=0, ov_discount=0, ov_gst=0, ov_freight=0,
		ov_freight_tax=0, alloc=0, version=version+1 WHERE type=".db_escape($type)." AND trans_no=".db_escape($type_no);

	db_query($sql, "could not void consignor transactions for type=$type and trans_no=$type_no");
}

//----------------------------------------------------------------------------------------

function clear_consignor_trans($type, $type_no)
{
	// Delete
	$sql = "DELETE FROM ".TB_PREF."consignor_trans WHERE type=".db_escape($type)." AND trans_no=".db_escape($type_no);

	db_query($sql, "could not clear consignor transactions for type=$type and trans_no=$type_no");
}
//----------------------------------------------------------------------------------------

function post_void_consignor_trans($type, $type_no)
{
	switch ($type) {
		case ST_TRANSPORTINVOICE :
		case ST_CONSIGNORCREDIT   :
			void_transport_invoice($type, $type_no);
			break;
		case ST_CONSIGNORDELIVERY :
			void_transport_delivery($type, $type_no);
			break;
		case ST_CONSIGNORPAYMENT :
			void_consignor_payment($type, $type_no);
			break;
	}
}

//----------------------------------------------------------------------------------------

function get_sql_for_consignor_inquiry()
{
    $date_after = date2sql($_POST['TransAfterDate']);
    $date_to = date2sql($_POST['TransToDate']);

  	$sql = "SELECT 
  		trans.type, 
		trans.trans_no, 
		trans.order_, 
		trans.reference,
		trans.tran_date, 
		trans.due_date, 
		consignor.name, 
		branch.br_name,
		consignor.curr_code,
		(trans.ov_amount + trans.ov_gst + trans.ov_freight 
			+ trans.ov_freight_tax + trans.ov_discount)	AS TotalAmount, "; 
   	if ($_POST['filterType'] != ALL_TEXT)
		$sql .= "@bal := @bal+(trans.ov_amount + trans.ov_gst + trans.ov_freight + trans.ov_freight_tax + trans.ov_discount), ";

//	else
//		$sql .= "IF(trans.type=".ST_CONSIGNORDELIVERY.",'', IF(trans.type=".ST_TRANSPORTINVOICE." OR trans.type=".ST_BANKPAYMENT.",@bal := @bal+
//			(trans.ov_amount + trans.ov_gst + trans.ov_freight + trans.ov_freight_tax + trans.ov_discount), @bal := @bal-
//			(trans.ov_amount + trans.ov_gst + trans.ov_freight + trans.ov_freight_tax + trans.ov_discount))) , ";
		$sql .= "trans.alloc AS Allocated,
		((trans.type = ".ST_TRANSPORTINVOICE.")
			AND trans.due_date < '" . date2sql(Today()) . "') AS OverDue ,
		Sum(line.quantity-line.qty_done) AS Outstanding
		FROM "
			.TB_PREF."consignor_trans as trans
			LEFT JOIN ".TB_PREF."consignor_trans_details as line
				ON trans.trans_no=line.consignor_trans_no AND trans.type=line.consignor_trans_type,"
			.TB_PREF."consignors_master as consignor, "
			.TB_PREF."consignor_branch as branch
		WHERE consignor.consignor_no = trans.consignor_no
			AND trans.tran_date >= '$date_after'
			AND trans.tran_date <= '$date_to'
			AND trans.branch_code = branch.branch_code";

   	if ($_POST['consignor_id'] != ALL_TEXT)
   		$sql .= " AND trans.consignor_no = ".db_escape($_POST['consignor_id']);

   	if ($_POST['filterType'] != ALL_TEXT)
   	{
   		if ($_POST['filterType'] == '1')
   		{
   			$sql .= " AND (trans.type = ".ST_TRANSPORTINVOICE.") ";
   		}
   		elseif ($_POST['filterType'] == '2')
   		{
   			$sql .= " AND (trans.type = ".ST_TRANSPORTINVOICE.") ";
   		}
   		elseif ($_POST['filterType'] == '3')
   		{
			$sql .= " AND (trans.type = " . ST_CONSIGNORPAYMENT 
					." OR trans.type = ".ST_BANKDEPOSIT." OR trans.type = ".ST_BANKPAYMENT.") ";
   		}
   		elseif ($_POST['filterType'] == '4')
   		{
			$sql .= " AND trans.type = ".ST_CONSIGNORCREDIT." ";
   		}
   		elseif ($_POST['filterType'] == '5')
   		{
			$sql .= " AND trans.type = ".ST_CONSIGNORDELIVERY." ";
   		}

    	if ($_POST['filterType'] == '2')
    	{
    		$today =  date2sql(Today());
    		$sql .= " AND trans.due_date < '$today'
				AND (trans.ov_amount + trans.ov_gst + trans.ov_freight_tax + 
				trans.ov_freight + trans.ov_discount - trans.alloc > 0) ";
    	}
   	}
	$sql .= " GROUP BY trans.trans_no, trans.type";

   	return $sql;
}

function get_sql_for_transport_deliveries_view($selected_consignor, $selected_stock_item=null)
{
	$sql = "SELECT trans.trans_no,
			consignor.name,
			branch.branch_code,
			branch.br_name,
			sorder.deliver_to,
			trans.reference,
			sorder.consignor_ref,
			trans.tran_date,
			trans.due_date,
			(ov_amount+ov_gst+ov_freight+ov_freight_tax) AS DeliveryValue,
			consignor.curr_code,
			Sum(line.quantity-line.qty_done) AS Outstanding,
			Sum(line.qty_done) AS Done
		FROM "
		 .TB_PREF."transport_orders as sorder, "
		 .TB_PREF."consignor_trans as trans, "
		 .TB_PREF."consignor_trans_details as line, "
		 .TB_PREF."consignors_master as consignor, "
		 .TB_PREF."consignor_branch as branch
			WHERE
			sorder.order_no = trans.order_ AND
			trans.consignor_no = consignor.consignor_no
				AND trans.type = ".ST_CONSIGNORDELIVERY."
				AND line.consignor_trans_no = trans.trans_no
				AND line.consignor_trans_type = trans.type
				AND trans.branch_code = branch.branch_code
				AND trans.consignor_no = branch.consignor_no ";

	if ($_POST['OutstandingOnly'] == true) {
		 $sql .= " AND line.qty_done < line.quantity ";
	}

	//figure out the sql required from the inputs available
	if (isset($_POST['DeliveryNumber']) && $_POST['DeliveryNumber'] != "")
	{
		$delivery = "%".$_POST['DeliveryNumber'];
		$sql .= " AND trans.trans_no LIKE ".db_escape($delivery);
		$sql .= " GROUP BY trans.trans_no";
	}
	else
	{
		$sql .= " AND trans.tran_date >= '".date2sql($_POST['DeliveryAfterDate'])."'";
		$sql .= " AND trans.tran_date <= '".date2sql($_POST['DeliveryToDate'])."'";

		if ($selected_consignor != -1)
			$sql .= " AND trans.consignor_no=".db_escape($selected_consignor)." ";

		if (isset($selected_stock_item))
			$sql .= " AND line.stock_id=".db_escape($selected_stock_item)." ";

		if (isset($_POST['StockLocation']) && $_POST['StockLocation'] != ALL_TEXT)
			$sql .= " AND sorder.from_stk_loc = ".db_escape($_POST['StockLocation'])." ";

		$sql .= " GROUP BY trans.trans_no ";

	} //end no delivery number selected
	return $sql;
}
?>
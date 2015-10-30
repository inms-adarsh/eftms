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

function add_consignee_allocation($amount, $trans_type_from, $trans_no_from,
	$trans_type_to, $trans_no_to)
{
	$sql = "INSERT INTO ".TB_PREF."consignee_allocations (
		amt, date_alloc,
		trans_type_from, trans_no_from, trans_no_to, trans_type_to)
		VALUES ($amount, Now(), ".db_escape($trans_type_from).", ".db_escape($trans_no_from).", ".db_escape($trans_no_to)
		.", ".db_escape($trans_type_to).")";

	db_query($sql, "A consignee allocation could not be added to the database");
}

//----------------------------------------------------------------------------------------


function delete_consignee_allocation($trans_id)
{
	$sql = "DELETE FROM ".TB_PREF."consignee_allocations WHERE id = ".db_escape($trans_id);
	return db_query($sql, "The existing allocation $trans_id could not be deleted");
}

//----------------------------------------------------------------------------------------
//	Update consignee trans alloc field according to current status of consignee_allocations
//
function update_consignee_trans_allocation($trans_type, $trans_no)
{
	$sql = "UPDATE `".TB_PREF."consignee_trans` trans,
			(SELECT sum(amt) amt from ".TB_PREF."consignee_allocations
				WHERE (trans_type_to=".db_escape($trans_type)." AND trans_no_to=".db_escape($trans_no).")
				OR (trans_type_from=".db_escape($trans_type)." AND trans_no_from=".db_escape($trans_no).")) allocated
		SET 
			trans.alloc=IFNULL(allocated.amt,0)
		WHERE trans.type=".db_escape($trans_type)." AND trans_no=".db_escape($trans_no);

	db_query($sql, "The consignee transaction record could not be modified for the allocation against it");
}

//-------------------------------------------------------------------------------------------------------------

function void_consignee_allocations($type, $type_no, $date="")
{
	return clear_consignee_alloctions($type, $type_no, $date);
}

//-------------------------------------------------------------------------------------------------------------

function clear_consignee_alloctions($type, $type_no, $date="")
{
	// clear any allocations for this transaction
	$sql = "SELECT * FROM ".TB_PREF."consignee_allocations
		WHERE (trans_type_from=".db_escape($type)." AND trans_no_from=".db_escape($type_no).")
		OR (trans_type_to=".db_escape($type)." AND trans_no_to=".db_escape($type_no).")";
	$result = db_query($sql, "could not void consignee transactions for type=$type and trans_no=$type_no");

	while ($row = db_fetch($result))
	{
		$sql = "UPDATE ".TB_PREF."consignee_trans SET alloc=alloc - " . $row['amt'] . "
			WHERE (type= " . $row['trans_type_from'] . " AND trans_no=" . $row['trans_no_from'] . ")
			OR (type=" . $row['trans_type_to'] . " AND trans_no=" . $row['trans_no_to'] . ")";
		db_query($sql, "could not clear allocation");
		// 2008-09-20 Joe Hunt
		if ($date != "")
			exchange_variation($type, $type_no, $row['trans_type_to'], $row['trans_no_to'], $date,
				$row['amt'], PT_CONSIGNOR, true);
		//////////////////////
	}


	// remove any allocations for this transaction
	$sql = "DELETE FROM ".TB_PREF."consignee_allocations
		WHERE (trans_type_from=".db_escape($type)." AND trans_no_from=".db_escape($type_no).")
		OR (trans_type_to=".db_escape($type)." AND trans_no_to=".db_escape($type_no).")";

	db_query($sql, "could not void consignee transactions for type=$type and trans_no=$type_no");
}
//----------------------------------------------------------------------------------------

function get_alloc_consignee_trans_sql($extra_fields=null, $extra_conditions=null, $extra_tables=null)
{
	$sql = "SELECT
		trans.type,
		trans.trans_no,
		trans.reference,
		trans.tran_date,
		consignee.name AS ConsignorName, 
		consignee.curr_code, 
		ov_amount+ov_gst+ov_freight+ov_freight_tax+ov_discount AS Total,
		trans.alloc,
		trans.due_date,
		consignee.address,
		trans.version,
		trans.consignee_no ";

	if ($extra_fields)
		$sql .= ", $extra_fields ";

	$sql .= " FROM ".TB_PREF."consignee_trans as trans, "
				.TB_PREF."consignees_master as consignee";
	if ($extra_tables)
		$sql .= ",$extra_tables ";

	$sql .= " WHERE trans.consignee_no=consignee.consignee_no";

	if ($extra_conditions)
		$sql .= " AND $extra_conditions ";

	return $sql;
}


//-------------------------------------------------------------------------------------------------------------

function get_allocatable_from_consignee_sql($consignee_id, $settled)
{
	$settled_sql = "";
	if (!$settled)
	{
		$settled_sql = " AND (round(ov_amount+ov_gst+ov_freight+ov_freight_tax-ov_discount-alloc,6) > 0)";
	}
	$consignee_sql = "";
	if ($consignee_id != null)
		$consignee_sql = " AND trans.consignee_no = ".db_escape($consignee_id);

	$sql = get_alloc_trans_sql("round(ov_amount+ov_gst+ov_freight+ov_freight_tax+ov_discount-alloc,6) <= 0 AS settled",
		"(type=".ST_CONSIGNORPAYMENT." OR type=".ST_CONSIGNORCREDIT." OR type=".ST_BANKDEPOSIT.") AND (trans.ov_amount > 0) " . $settled_sql . $consignee_sql);

	return $sql;
}

//-------------------------------------------------------------------------------------------------------------

function get_allocatable_to_consignee_transactions($consignee_id, $trans_no=null, $type=null)
{
	if ($trans_no != null and $type != null)
	{
		$sql = get_alloc_trans_sql("amt", "trans.trans_no = alloc.trans_no_to
			AND trans.type = alloc.trans_type_to
			AND alloc.trans_no_from=".db_escape($trans_no)."
			AND alloc.trans_type_from=".db_escape($type)."
			AND trans.consignee_no=".db_escape($consignee_id),
			"".TB_PREF."consignee_allocations as alloc");
	}
	else
	{
		$sql = get_alloc_trans_sql(null, "round(ov_amount+ov_gst+ov_freight+ov_freight_tax+ov_discount-alloc,6) > 0
			AND trans.type <> " . ST_CONSIGNORPAYMENT . "
			AND trans.type <> " . ST_BANKDEPOSIT . "
			AND trans.type <> " . ST_CONSIGNORCREDIT . "
			AND trans.type <> " . ST_CONSIGNORDELIVERY . "
			AND trans.consignee_no=".db_escape($consignee_id));
	}

	return db_query($sql." ORDER BY trans_no", "Cannot retreive alloc to transactions");
}

//-------------------------------------------------------------------------------------------------------------

function get_allocatable_from_consignee_transactions($consignee_id, $trans_no=null, $type=null)
{
	if ($trans_no != null and $type != null)
	{
		$sql = get_alloc_trans_sql("amt", "trans.trans_no = alloc.trans_no_from
			AND trans.type = alloc.trans_type_from
			AND alloc.trans_no_to=".db_escape($trans_no)."
			AND alloc.trans_type_to=".db_escape($type)."
			AND trans.consignee_no=".db_escape($consignee_id),
			"".TB_PREF."consignee_allocations as alloc");
	}
	else
	{
		$sql = get_alloc_trans_sql(null, "round(ov_amount+ov_gst+ov_freight+ov_freight_tax+ov_discount-alloc,6) > 0
			AND trans.type <> " . ST_CONSIGNORPAYMENT . "
			AND trans.type <> " . ST_BANKDEPOSIT . "
			AND trans.type <> " . ST_CONSIGNORCREDIT . "
			AND trans.type <> " . ST_CONSIGNORDELIVERY . "
			AND trans.consignee_no=".db_escape($consignee_id));
	}

	return db_query($sql." ORDER BY trans_no", "Cannot retreive alloc to transactions");
}

function get_sql_for_consignee_allocation_inquiry($from, $to, $consignee, $filterType, $settled)
{
  	$data_after = date2sql($from);
  	$date_to = date2sql($to);

  	$sql = "SELECT 
  		trans.type,
		trans.trans_no,
		trans.reference,
		trans.order_,
		trans.tran_date,
		trans.due_date,
		consignee.name,
		consignee.curr_code,
    	(trans.ov_amount + trans.ov_gst + trans.ov_freight 
			+ trans.ov_freight_tax + trans.ov_discount)	AS TotalAmount,
		trans.alloc AS Allocated,
		((trans.type = ".ST_TRANSPORTINVOICE.")
			AND trans.due_date < '" . date2sql(Today()) . "') AS OverDue,
		trans.consignee_no
    	FROM "
			.TB_PREF."consignee_trans as trans, "
			.TB_PREF."consignees_master as consignee
    	WHERE consignee.consignee_no = trans.consignee_no
			AND (trans.ov_amount + trans.ov_gst + trans.ov_freight 
				+ trans.ov_freight_tax + trans.ov_discount != 0)
    		AND trans.tran_date >= '$data_after'
    		AND trans.tran_date <= '$date_to'";

   	if ($consignee != ALL_TEXT)
   		$sql .= " AND trans.consignee_no = ".db_escape($consignee);

   	if (isset($filterType) && $filterType != ALL_TEXT)
   	{
   		if ($filterType == '1' || $filterType == '2')
   		{
   			$sql .= " AND trans.type = ".ST_TRANSPORTINVOICE." ";
   		}
   		elseif ($filterType == '3')
   		{
			$sql .= " AND trans.type = " . ST_CONSIGNORPAYMENT;
   		}
   		elseif ($filterType == '4')
   		{
			$sql .= " AND trans.type = ".ST_CONSIGNORCREDIT." ";
   		}

    	if ($filterType == '2')
    	{
    		$today =  date2sql(Today());
    		$sql .= " AND trans.due_date < '$today'
				AND (round(abs(trans.ov_amount + "
				."trans.ov_gst + trans.ov_freight + "
				."trans.ov_freight_tax + trans.ov_discount) - trans.alloc,6) > 0) ";
    	}
   	}
   	else
   	{
	    $sql .= " AND trans.type <> ".ST_CONSIGNORDELIVERY." ";
   	}


   	if (!$settled)
   	{
   		$sql .= " AND (round(abs(trans.ov_amount + trans.ov_gst + "
		."trans.ov_freight + trans.ov_freight_tax + "
		."trans.ov_discount) - trans.alloc,6) != 0) ";
   	}

   	return $sql;
}

function credit_consignee_transport_invoice_allocate($invoice_no, $credit_no, $amount, $date)
{

	$sql = "SELECT ov_freight+ov_gst+ov_amount+ov_freight_tax as total, alloc FROM ".TB_PREF."consignee_trans
		WHERE (`type`=".ST_TRANSPORTINVOICE." AND trans_no=".db_escape($invoice_no).")";
	$result = db_query($sql, "can't retrieve invoice totals");
	$invoice = db_fetch($result);
	$free = $invoice['total'] - $invoice['alloc'];
	
	if ($free < $amount) {
	 // if there is not enough unallocated amount - remove some payment allocations
		$sql = "SELECT * FROM ".TB_PREF."consignee_allocations
			WHERE (trans_type_to=".ST_TRANSPORTINVOICE." AND trans_no_to=".db_escape($invoice_no).")
			AND trans_type_from <> ".ST_CONSIGNORCREDIT;
		$result = db_query($sql, "can't retrieve invoice allocations");

		while(($free < $amount) && ($alloc = db_fetch($result))) {
			$unalloc = min($alloc['amt'], $amount-$free);
			update_consignee_trans_allocation($alloc['trans_type_to'], $alloc['trans_no_to'], 
				-$unalloc);
			update_consignee_trans_allocation($alloc['trans_type_from'], $alloc['trans_no_from'], 
				-$unalloc);

			delete_consignee_allocation($alloc['id']);
			if ($unalloc < $alloc['amt'])
				add_consignee_allocation($alloc['amt']-$unalloc, $alloc['trans_type_from'],
					$alloc['trans_no_from'], ST_TRANSPORTINVOICE, $invoice_no);

			$free += $unalloc;
		}
	}
	if (floatcmp($free, $amount)<0) {
		// this should never happen unless sparse credit notices were allocated to 
		// the invoice, or summarized freight costs on credit notes is more than those on invoice.
		display_error(_("Unsuspected overallocation happened due to sparse credit notes exists for this invoice.
 Check all credit notes allocated to this invoice for summarized freight charges."));
		return false;
	}
	update_consignee_trans_allocation(ST_TRANSPORTINVOICE, $invoice_no, $amount);
	update_consignee_trans_allocation(ST_CONSIGNORCREDIT, $credit_no, $amount);
	add_consignee_allocation($amount, ST_CONSIGNORCREDIT, $credit_no, ST_TRANSPORTINVOICE, $invoice_no);

	exchange_variation(ST_CONSIGNORCREDIT, $credit_no, ST_TRANSPORTINVOICE, $invoice_no, $date,
		$amount, PT_CONSIGNOR);
	return true;
}

?>
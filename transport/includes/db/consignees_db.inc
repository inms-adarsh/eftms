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

function add_consignee($CustName, $consignee_ref, $address, $tax_id, $curr_code, $discount, $pymt_discount, 
	$credit_limit,  $notes)
{
	$sql = "INSERT INTO ".TB_PREF."consignees_master (name, consignee_ref, address, tax_id, curr_code,  discount, 
		pymt_discount,credit_limit,  notes) VALUES ("
		.db_escape($CustName) .", " .db_escape($consignee_ref) .", "
		.db_escape($address) . ", " . db_escape($tax_id) . ","
		.db_escape($curr_code) . ", " . $discount . ", 
		" . $pymt_discount . ", " . $credit_limit 
		 .",  ".db_escape($notes) . ")";

	db_query($sql,"The consignee could not be added");
}

function update_consignee($consignee_id, $CustName, $consignee_ref, $address, $tax_id, $curr_code,
	 $discount, $pymt_discount,
	$credit_limit,  $notes)
{
	$sql = "UPDATE ".TB_PREF."consignees_master SET name=" . db_escape($CustName) . ", 
		consignee_ref=" . db_escape($consignee_ref) . ",
		address=".db_escape($address) . ", 
		tax_id=".db_escape($tax_id) . ", 
		curr_code=".db_escape($curr_code) . ", 
		discount=" . $discount . ", 
		pymt_discount=" . $pymt_discount . ", 
		credit_limit=" . $credit_limit . ", 
		 
		notes=".db_escape($notes) ."
		WHERE consignee_no = ".db_escape($consignee_id);

	db_query($sql,"The consignee could not be updated");
}

function delete_consignee($consignee_id)
{
	begin_transaction();
	delete_entity_contacts('consignee', $consignee_id);

	$sql = "DELETE FROM ".TB_PREF."consignees_master WHERE consignee_no=".db_escape($consignee_id);;
	db_query($sql,"cannot delete consignee");
	commit_transaction();
}

function get_consignee_details($consignee_id, $to=null, $all=true)
{

	if ($to == null)
		$todate = date("Y-m-d");
	else
		$todate = date2sql($to);
	$past1 = get_company_pref('past_due_days');
	$past2 = 2 * $past1;
	// removed - consignee_trans.alloc from all summations
	if ($all)
    	$value = "IFNULL(IF(trans.type=11 OR trans.type=12 OR trans.type=2, -1, 1) 
    		* (trans.ov_amount + trans.ov_gst + trans.ov_freight + trans.ov_freight_tax + trans.ov_discount),0)";
    else		
    	$value = "IFNULL(IF(trans.type=11 OR trans.type=12 OR trans.type=2, -1, 1) 
    		* (trans.ov_amount + trans.ov_gst + trans.ov_freight + trans.ov_freight_tax + trans.ov_discount - 
    		trans.alloc),0)";
	$due = "IF (trans.type=10, trans.due_date, trans.tran_date)";
    $sql = "SELECT ".TB_PREF."consignees_master.name, ".TB_PREF."consignees_master.curr_code, ".TB_PREF."payment_terms.terms,
		".TB_PREF."consignees_master.credit_limit, ".TB_PREF."credit_status.dissallow_invoices, ".TB_PREF."credit_status.reason_description,

		Sum(IFNULL($value,0)) AS Balance,
		Sum(IF ((TO_DAYS('$todate') - TO_DAYS($due)) >= 0,$value,0)) AS Due,
		Sum(IF ((TO_DAYS('$todate') - TO_DAYS($due)) >= $past1,$value,0)) AS Overdue1,
		Sum(IF ((TO_DAYS('$todate') - TO_DAYS($due)) >= $past2,$value,0)) AS Overdue2

		FROM ".TB_PREF."consignees_master
			 LEFT JOIN ".TB_PREF."consignee_trans trans ON 
			 trans.tran_date <= '$todate' AND ".TB_PREF."consignees_master.consignee_no = trans.consignee_no AND trans.type <> 13
,
			 ".TB_PREF."payment_terms,
			 ".TB_PREF."credit_status

		WHERE
			 ".TB_PREF."consignees_master.consignee_no = ".db_escape($consignee_id)." ";
	if (!$all)
		$sql .= "AND ABS(trans.ov_amount + trans.ov_gst + trans.ov_freight + trans.ov_freight_tax + trans.ov_discount - trans.alloc) > ".FLOAT_COMP_DELTA." ";  
	$sql .= "GROUP BY
			  ".TB_PREF."consignees_master.name,
			  ".TB_PREF."payment_terms.terms,
			  ".TB_PREF."payment_terms.days_before_due,
			  ".TB_PREF."payment_terms.day_in_following_month,
			  ".TB_PREF."consignees_master.credit_limit,
			  ".TB_PREF."credit_status.dissallow_invoices,
			  ".TB_PREF."credit_status.reason_description";
    $result = db_query($sql,"The consignee details could not be retrieved");

    $consignee_record = db_fetch($result);

    return $consignee_record;

}


function get_consignee($consignee_id)
{
	$sql = "SELECT * FROM ".TB_PREF."consignees_master WHERE consignee_no=".db_escape($consignee_id);

	$result = db_query($sql, "could not get consignee");

	return db_fetch($result);
}

function get_consignee_name($consignee_id)
{
	$sql = "SELECT name FROM ".TB_PREF."consignees_master WHERE consignee_no=".db_escape($consignee_id);

	$result = db_query($sql, "could not get consignee");

	$row = db_fetch_row($result);

	return $row[0];
}

function get_consignee_habit($consignee_id)
{
	$sql = "SELECT ".TB_PREF."consignees_master.pymt_discount,
		".TB_PREF."credit_status.dissallow_invoices
		FROM ".TB_PREF."consignees_master, ".TB_PREF."credit_status
		WHERE  ".TB_PREF."consignees_master.consignee_no = ".db_escape($consignee_id);

	$result = db_query($sql, "could not query consignees");

	return db_fetch($result);
}

function get_consignee_contacts($consignee_id, $action=null)
{
	$results = array();
	$res = get_crm_persons('consignee', $action, $consignee_id);
	while($contact = db_fetch($res))
	{
		if ($contact['lang'] == 'C') // Fix for improper lang in demo sql files.
			$contact['lang'] = '';
		$results[] = $contact;
	}	
	return $results;
}

function get_current_consignee_credit($consignee_id)
{
	$consigneedet = get_consignee_details($consignee_id);

	return $consigneedet['credit_limit']-$consigneedet['Balance'];

}

function is_new_consignee($id)
{
	$tables = array('consignee_branch', 'consignee_trans', 'recurrent_invoices', 'transport_orders');

	return !key_in_foreign_table($id, $tables, 'consignee_no');
}

function get_consignee_by_ref($reference)
{
	$sql = "SELECT * FROM ".TB_PREF."consignees_master WHERE consignee_ref=".db_escape($reference);

	$result = db_query($sql, "could not get consignee");

	return db_fetch($result);
}

?>
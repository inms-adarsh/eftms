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

function add_vendor($vendor_name,
		$hired_on,$notes,
		 $vendor_ref, $address,
		$curr_code,$payment_terms)
{

$hired_date = date2sql($hired_on);
	$sql = "INSERT INTO ".TB_PREF."vendors_master (vendor_name, hired_on, vendor_ref, address, curr_code, payment_terms, notes) VALUES ("
		.db_escape($vendor_name) .", '$hired_date', 
		 ".db_escape($vendor_ref). ", ". db_escape($address) . ",
		". db_escape($curr_code) . ",". db_escape($payment_terms) . ",". db_escape($notes) . "
		)";

		db_query($sql,"The vendor could not be added");
}

function update_vendor($vendor_id, $vendor_name, 
		$hired_on,$notes,
		$vendor_ref, $address,
		$curr_code,$payment_terms)
{
$hired_date = date2sql($hired_on);
	$sql = "UPDATE ".TB_PREF."vendors_master SET vendor_name=" . db_escape($vendor_name) . ", 
		vendor_ref=" . db_escape($vendor_ref) . ",
		address=".db_escape($address) . ", 
		curr_code=".db_escape($curr_code) . ", 
		payment_terms=".db_escape($payment_terms) . ", 
		notes=".db_escape($notes) .",
		hired_on = '$hired_date'
		WHERE vendor_no = ".db_escape($vendor_id);

	db_query($sql,"The vendor could not be updated");
}

function delete_vendor($vendor_id)
{
	begin_transaction();
	delete_entity_contacts('vendor', $vendor_id);

	$sql = "DELETE FROM ".TB_PREF."vendors_master WHERE vendor_no=".db_escape($vendor_id);;
	db_query($sql,"cannot delete vendor");
	commit_transaction();
}



function get_vendor($vendor_id)
{
	$sql = "SELECT * FROM ".TB_PREF."vendors_master WHERE vendor_no=".db_escape($vendor_id);

	$result = db_query($sql, "could not get vendor");

	return db_fetch($result);
}

function get_vendor_vendor_name($vendor_id)
{
	$sql = "SELECT vendor_name FROM ".TB_PREF."vendors_master WHERE vendor_no=".db_escape($vendor_id);

	$result = db_query($sql, "could not get vendor");

	$row = db_fetch_row($result);

	return $row[0];
}

function get_vendor_habit($vendor_id)
{
	$sql = "SELECT ".TB_PREF."vendors_master.pymt_discount,
		".TB_PREF."credit_status.dissallow_invoices
		FROM ".TB_PREF."vendors_master, ".TB_PREF."credit_status
		WHERE ".TB_PREF."vendors_master.vendor_no = ".db_escape($vendor_id);

	$result = db_query($sql, "could not query vendors");

	return db_fetch($result);
}

function get_vendor_contacts($vendor_id, $action=null)
{
	$results = array();
	$res = get_crm_persons('vendor', $action, $vendor_id);
	while($contact = db_fetch($res))
	{
		if ($contact['lang'] == 'C') // Fix for improper lang in demo sql files.
			$contact['lang'] = '';
		$results[] = $contact;
	}	
	return $results;
}
 
//function get_current_consignor_credit($vendor_id)
//{
//	$custdet = get_vendor_details($vendor_id);
//
//	return $custdet['credit_limit']-$custdet['Balance'];

//} 

function is_new_vendor($id)
{
	
}

function get_vendor_by_ref($reference)
{
	$sql = "SELECT * FROM ".TB_PREF."vendors_master WHERE vendor_ref=".db_escape($reference);

	$result = db_query($sql, "could not get vendor");

	return db_fetch($result);
}

?>
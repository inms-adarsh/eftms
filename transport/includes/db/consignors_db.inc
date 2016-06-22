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

function add_consignor($CustName, $consignor_ref, $address, $location, 
	 $notes, $tin_no,$contact_name,$phone,$email,$curr_code)
{
	$sql = "INSERT INTO ".TB_PREF."consignors_master (name, consignor_ref, address, default_location,
		notes,tin_no,contact_name,phone,email,curr_code) VALUES ("
		.db_escape($CustName) .", " .db_escape($consignor_ref) .", "
		.db_escape($address) . ",  ".db_escape($location) . ",".db_escape($notes) . ", ".db_escape($tin_no).", ".db_escape($contact_name).",".db_escape($phone).",".db_escape($email).",".db_escape($curr_code).")";

	db_query($sql,"The consignor could not be added");
}

function update_consignor($consignor_id, $CustName, $consignor_ref, $address,$location, $notes, $tin_no,$contact_name,$phone,$email,$curr_code)
{
	$sql = "UPDATE ".TB_PREF."consignors_master SET name=" . db_escape($CustName) . ", 
		consignor_ref=" . db_escape($consignor_ref) . ",
		address=".db_escape($address) . ", 
		default_location = ".db_escape($location) .",
		notes=".db_escape($notes) .",
		tin_no = ".db_escape($tin_no).",
		contact_name = ".db_escape($contact_name).",
		phone = ".db_escape($phone).",
		email = ".db_escape($email).",
		curr_code = ".db_escape($curr_code)."
		WHERE consignor_no = ".db_escape($consignor_id);

	db_query($sql,"The consignor could not be updated");
}

function delete_consignor($consignor_id)
{
	begin_transaction();
	delete_entity_contacts('consignor', $consignor_id);

	$sql = "DELETE FROM ".TB_PREF."consignors_master WHERE consignor_no=".db_escape($consignor_id);;
	db_query($sql,"cannot delete consignor");
	commit_transaction();
}

function get_consignor_details($consignor_id, $to=null, $all=true)
{


    $sql = "SELECT ".TB_PREF."consignors_master.name

		FROM ".TB_PREF."consignors_master
			WHERE
			 ".TB_PREF."consignors_master.consignor_no = ".db_escape($consignor_id)." ";
	
	$sql .= "GROUP BY
			  ".TB_PREF."consignors_master.name";
    $result = db_query($sql,"The consignor details could not be retrieved");

    $consignor_record = db_fetch($result);

    return $consignor_record;

}
function get_all_consignors($show_inactive)
{
	$sql = "SELECT cm.name,cm.contact_name,cm.phone,cm.email,cm.address,cm.tin_no,cm.consignor_no FROM ".TB_PREF."consignors_master cm";
	return $sql;
}

function get_consignor($consignor_id)
{
	$sql = "SELECT * FROM ".TB_PREF."consignors_master WHERE consignor_no=".db_escape($consignor_id);

	$result = db_query($sql, "could not get consignor");

	return db_fetch($result);
}

function get_consignor_name($consignor_id)
{
	$sql = "SELECT name FROM ".TB_PREF."consignors_master WHERE consignor_no=".db_escape($consignor_id);

	$result = db_query($sql, "could not get consignor");

	$row = db_fetch_row($result);

	return $row[0];
}

function get_consignor_habit($consignor_id)
{
	$sql = "SELECT a.pymt_discount,
		credit_status.dissallow_invoices
		FROM ".TB_PREF."consignors_master a, ".TB_PREF."credit_status as credit_status
		WHERE  a.consignor_no = ".db_escape($consignor_id) .
                " AND credit_status.id = a.credit_status";
                

	$result = db_query($sql, "could not query consignors");

	return db_fetch($result);
}

function get_consignor_contacts($consignor_id, $action=null)
{
	$results = array();
	$res = get_crm_persons('consignor', $action, $consignor_id);
	while($contact = db_fetch($res))
	{
		if ($contact['lang'] == 'C') // Fix for improper lang in demo sql files.
			$contact['lang'] = '';
		$results[] = $contact;
	}	
	return $results;
}

function get_current_consignor_credit($consignor_id)
{
	$consignordet = get_consignor_details($consignor_id);

	return $consignordet['credit_limit']-$consignordet['Balance'];

}

function is_new_consignor($id)
{
	$tables = array('consignor_trans', 'recurrent_invoices', 'transport_orders');

	return !key_in_foreign_table($id, $tables, 'consignor_no');
}

function get_consignor_by_ref($reference)
{
	$sql = "SELECT * FROM ".TB_PREF."consignors_master WHERE consignor_ref=".db_escape($reference);

	$result = db_query($sql, "could not get consignor");

	return db_fetch($result);
}

?>
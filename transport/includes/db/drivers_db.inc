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

function add_driver($name,$licence_no,$mobile_no, $driver_ref, $address,
		 $notes)
{
	$sql = "INSERT INTO ".TB_PREF."drivers_master (name,licence_no,mobile_no, driver_ref, address, notes) VALUES ("
		.db_escape($name) .",
		" . db_escape($licence_no) . "," . db_escape($mobile_no) . ", ".db_escape($driver_ref). ", ". db_escape($address) . ",
		". db_escape($notes) . "
		)";

		db_query($sql,"The driver could not be added");
}

function update_driver($driver_id, $name, 
		$licence_no,$mobile_no,
		 $driver_ref, $address,
		 $notes)
{

	$sql = "UPDATE ".TB_PREF."drivers_master SET name=" . db_escape($name) . ", 
		driver_ref=" . db_escape($driver_ref) . ",
		address=".db_escape($address) . ", 
		notes=".db_escape($notes) .",
		
		licence_no= " . db_escape($licence_no) . ",
		mobile_no= " . db_escape($mobile_no) . "
		
		WHERE driver_no = ".db_escape($driver_id);

	db_query($sql,"The driver could not be updated");
}

function delete_driver($driver_id)
{
	begin_transaction();
	delete_entity_contacts('driver', $driver_id);

	$sql = "DELETE FROM ".TB_PREF."drivers_master WHERE driver_no=".db_escape($driver_id);;
	db_query($sql,"cannot delete driver");
	commit_transaction();
}


function get_all_drivers($show_inactive)
{
	$sql = "SELECT dm.name,dm.mobile_no,dm.address,dm.licence_no,dm.driver_no FROM ".TB_PREF."drivers_master dm";
	return $sql;
}

function get_driver($driver_id)
{
	$sql = "SELECT * FROM ".TB_PREF."drivers_master WHERE driver_no=".db_escape($driver_id);

	$result = db_query($sql, "could not get driver");

	return db_fetch($result);
}

function get_driver_name($driver_id)
{
	$sql = "SELECT name FROM ".TB_PREF."drivers_master WHERE driver_no=".db_escape($driver_id);

	$result = db_query($sql, "could not get driver");

	$row = db_fetch_row($result);

	return $row[0];
}

function get_driver_habit($driver_id)
{
	$sql = "SELECT ".TB_PREF."drivers_master.pymt_discount,
		".TB_PREF."credit_status.dissallow_invoices
		FROM ".TB_PREF."drivers_master, ".TB_PREF."credit_status
		WHERE  ".TB_PREF."drivers_master.driver_no = ".db_escape($driver_id);

	$result = db_query($sql, "could not query drivers");

	return db_fetch($result);
}

function get_driver_contacts($driver_id, $action=null)
{
	$results = array();
	$res = get_crm_persons('driver', $action, $driver_id);
	while($contact = db_fetch($res))
	{
		if ($contact['lang'] == 'C') // Fix for improper lang in demo sql files.
			$contact['lang'] = '';
		$results[] = $contact;
	}	
	return $results;
}
 
//function get_current_consignor_credit($driver_id)
//{
//	$custdet = get_driver_details($driver_id);
//
//	return $custdet['credit_limit']-$custdet['Balance'];

//} 

function is_new_driver($id)
{
	
}

function get_driver_by_ref($reference)
{
	$sql = "SELECT * FROM ".TB_PREF."drivers_master WHERE driver_ref=".db_escape($reference);

	$result = db_query($sql, "could not get driver");

	return db_fetch($result);
}

?>
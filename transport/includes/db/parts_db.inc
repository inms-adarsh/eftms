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

function add_part($part_name, $part_type_desc, $vendor_ref,
	$part_no, $part_price, $part_price_date, $part_manufacturer)
{
$price_date = date2sql($part_price_date);
	$sql = "INSERT INTO ".TB_PREF."part (part_name, part_type_desc,vendor_ref, part_no,
		part_price, part_price_date, part_manufacturer)
		
		VALUES (".db_escape($part_name) . ", "
		  .db_escape($part_type_desc) . ", "
		  .db_escape($vendor_ref) . ", "
		  .db_escape($part_no) . ", ".
		db_escape($part_price).", '$price_date',"
		.db_escape($part_manufacturer).")";
   	db_query($sql,"The insert of the transport person failed");
}

function update_part($selected_id, $part_name,  $part_type_desc, $vendor_ref,
	$part_no, $part_price, $part_price_date, $part_manufacturer)
{
$price_date = date2sql($part_price_date);
	$sql = "UPDATE ".TB_PREF."part SET part_name=".db_escape($part_name) . ",
		part_type_desc=".db_escape($part_type_desc) . ",
		vendor_ref=".db_escape($vendor_ref) . ",
		part_no=".db_escape($part_no) . ",
		part_price =".db_escape($part_price).",
		part_price_date ='$price_date',
		part_manufacturer =".db_escape($part_manufacturer)."
		WHERE part_code = ".db_escape($selected_id);
   	db_query($sql,"The update of the transport person failed");
}

function delete_part($selected_id)
{
	$sql="DELETE FROM ".TB_PREF."part WHERE part_code=".db_escape($selected_id);
	db_query($sql,"The transport-person could not be deleted");
}

function get_parts($show_inactive)
{
	$sql = "SELECT * FROM ".TB_PREF."part";
	if (!$show_inactive) $sql .= " WHERE !inactive";
	return db_query($sql,"could not get transport persons");
}

function get_part($selected_id)
{
	$sql = "SELECT *  FROM ".TB_PREF."part WHERE part_code=".db_escape($selected_id);

	$result = db_query($sql,"could not get transport person");
	return db_fetch($result);
}

function get_part_name($id)
{
	$sql = "SELECT part_name FROM ".TB_PREF."part WHERE part_code=".db_escape($id);

	$result = db_query($sql, "could not get transport type");

	$row = db_fetch_row($result);
	return $row[0];
}

function add_part_type($description)
{
	$sql = "INSERT INTO ".TB_PREF."part_types (part_description) VALUES (".db_escape($description) . ")";
   	db_query($sql,"The transport part_type could not be added");
}

function update_part_type($selected_id, $description)
{
	$sql = "UPDATE ".TB_PREF."part_types SET part_description=".db_escape($description)." WHERE part_type_code = ".db_escape($selected_id);
   	db_query($sql,"The transport part_type could not be updated");
}

function delete_part_type($selected_id)
{
	$sql="DELETE FROM ".TB_PREF."part_types WHERE part_type_code=".db_escape($selected_id);
	db_query($sql,"could not delete transport part_type");
}

function get_part_types($show_inactive)
{
	$sql = "SELECT * FROM ".TB_PREF."part_types";
	if (!$show_inactive) $sql .= " WHERE !inactive";
	return db_query($sql,"could not get part_types");
}

function get_part_type($selected_id)
{
	$sql = "SELECT * FROM ".TB_PREF."part_types WHERE part_type_code=".db_escape($selected_id);

	$result = db_query($sql,"could not get part_type");
	return db_fetch($result);
}

function get_part_type_name($id)
{
	$sql = "SELECT part_description FROM ".TB_PREF."part_types WHERE part_type_code=".db_escape($id);

	$result = db_query($sql, "could not get transport type");

	$row = db_fetch_row($result);
	return $row[0];
}



?>
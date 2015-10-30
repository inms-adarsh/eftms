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
function add_transport_type($name, $tax_included, $factor)
{
	$sql = "INSERT INTO ".TB_PREF."transport_types (transport_type,tax_included,factor) VALUES (".db_escape($name).","
		.db_escape($tax_included).",".db_escape($factor).")";
	db_query($sql, "could not add transport type");		
}

function update_transport_type($id, $name, $tax_included, $factor)
{

	$sql = "UPDATE ".TB_PREF."transport_types SET transport_type = ".db_escape($name).",
	tax_included =".db_escape($tax_included).", factor=".db_escape($factor)." WHERE id = ".db_escape($id);
	
	db_query($sql, "could not update transport type");			
}

function get_all_transport_types($all=false)
{
	$sql = "SELECT * FROM ".TB_PREF."transport_types";
	if (!$all)
		$sql .= " WHERE !inactive";
	
	return db_query($sql, "could not get all transport types");
} 

function get_transport_type($id)
{
	$sql = "SELECT * FROM ".TB_PREF."transport_types WHERE id=".db_escape($id);
	
	$result = db_query($sql, "could not get transport type");
	
	return db_fetch($result);
}

function get_transport_type_name($id)
{
	$sql = "SELECT transport_type FROM ".TB_PREF."transport_types WHERE id=".db_escape($id);
	
	$result = db_query($sql, "could not get transport type");
	
	$row = db_fetch_row($result);
	return $row[0];
}

function delete_transport_type($id)
{
	$sql="DELETE FROM ".TB_PREF."transport_types WHERE id=".db_escape($id);
	db_query($sql,"The Transport type record could not be deleted");

	$sql ="DELETE FROM ".TB_PREF."prices WHERE transport_type_id=".db_escape($id);
	db_query($sql,"The Transport type prices could not be deleted");
}

?>
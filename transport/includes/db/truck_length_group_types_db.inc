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
function add_truck_length_group_type($id, $name)
{
	$sql = "INSERT INTO ".TB_PREF."truck_length_group_types (id, name)
		VALUES (".db_escape($id).", ".db_escape($name).")";

	return db_query($sql);
}

function update_truck_length_group_type($id, $name, $old_id)
{
	begin_transaction();
	
    $sql = "UPDATE ".TB_PREF."truck_length_group_types SET id=".db_escape($id) .", name=".db_escape($name)." WHERE id = ".db_escape($old_id);

	$ret = db_query($sql, "could not update load group type");
	commit_transaction();
	return $ret;
}

function get_truck_length_group_types($all=false, $class_id=false, $parent=false)
{
	$sql = "SELECT * FROM ".TB_PREF."truck_length_group_types";

	$where = array();
	
	if (!$all)
		$where[] = "!inactive";

	$sql .= " ORDER BY name";

	return db_query($sql, "could not get load group types");
}

function get_truck_length_group_type($id)
{
	$sql = "SELECT * FROM ".TB_PREF."truck_length_group_types WHERE id = ".db_escape($id);

	$result = db_query($sql, "could not get load group type");

	return db_fetch($result);
}

function get_truck_length_group_type_name($id)
{
	$sql = "SELECT name FROM ".TB_PREF."truck_length_group_types WHERE id = ".db_escape($id);

	$result = db_query($sql, "could not get load group type");

	$row = db_fetch_row($result);
	return $row[0];
}

function delete_truck_length_group_type($id)
{
	$sql = "DELETE FROM ".TB_PREF."truck_length_group_types WHERE id = ".db_escape($id);

	db_query($sql, "could not delete load group type");
}

?>
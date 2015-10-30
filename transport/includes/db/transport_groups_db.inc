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

function add_transport_group($description)
{
	$sql = "INSERT INTO ".TB_PREF."groups (description) VALUES (".db_escape($description) . ")";
   	db_query($sql,"The transport group could not be added");
}

function update_transport_group($selected_id, $description)
{
	$sql = "UPDATE ".TB_PREF."groups SET description=".db_escape($description)." WHERE id = ".db_escape($selected_id);
   	db_query($sql,"The transport group could not be updated");
}

function delete_transport_group($selected_id)
{
	$sql="DELETE FROM ".TB_PREF."groups WHERE id=".db_escape($selected_id);
	db_query($sql,"could not delete transport group");
}

function get_transport_groups($show_inactive)
{
	$sql = "SELECT * FROM ".TB_PREF."groups";
	if (!$show_inactive) $sql .= " WHERE !inactive";
	$sql .= " ORDER BY description";
	return db_query($sql,"could not get groups");
}

function get_transport_group($selected_id)
{
	$sql = "SELECT * FROM ".TB_PREF."groups WHERE id=".db_escape($selected_id);

	$result = db_query($sql,"could not get group");
	return db_fetch($result);
}

function get_transport_group_name($group_no)
{
	$sql = "SELECT description FROM ".TB_PREF."groups WHERE id = ".db_escape($group_no);
	$result = db_query($sql, "could not get group");
	$row = db_fetch($result);
	return $row[0];
}

function add_transport_area($description)
{
	$sql = "INSERT INTO ".TB_PREF."areas (description) VALUES (".db_escape($description) . ")";
   	db_query($sql,"The transport area could not be added");
}

function update_transport_area($selected_id, $description)
{
	$sql = "UPDATE ".TB_PREF."areas SET description=".db_escape($description)." WHERE area_code = ".db_escape($selected_id);
   	db_query($sql,"The transport area could not be updated");
}

function delete_transport_area($selected_id)
{
	$sql="DELETE FROM ".TB_PREF."areas WHERE area_code=".db_escape($selected_id);
	db_query($sql,"could not delete transport area");
}

function get_transport_areas($show_inactive)
{
	$sql = "SELECT * FROM ".TB_PREF."areas";
	if (!$show_inactive) $sql .= " WHERE !inactive";
	return db_query($sql,"could not get areas");
}

function get_transport_area($selected_id)
{
	$sql = "SELECT * FROM ".TB_PREF."areas WHERE area_code=".db_escape($selected_id);

	$result = db_query($sql,"could not get area");
	return db_fetch($result);
}

function get_area_name($id)
{
	$sql = "SELECT description FROM ".TB_PREF."areas WHERE area_code=".db_escape($id);

	$result = db_query($sql, "could not get transport type");

	$row = db_fetch_row($result);
	return $row[0];
}

function add_transportman($transportman_name, $transportman_phone, $transportman_fax,
	$transportman_email, $provision, $break_pt, $provision2)
{
	$sql = "INSERT INTO ".TB_PREF."transportman (transportman_name, transportman_phone, transportman_fax, transportman_email,
		provision, break_pt, provision2)
		VALUES (".db_escape($transportman_name) . ", "
		  .db_escape($transportman_phone) . ", "
		  .db_escape($transportman_fax) . ", "
		  .db_escape($transportman_email) . ", ".
		$provision.", ".$break_pt.", "
		.$provision2.")";
   	db_query($sql,"The insert of the transport person failed");
}

function update_transportman($selected_id, $transportman_name, $transportman_phone, $transportman_fax,
	$transportman_email, $provision, $break_pt, $provision2)
{
	$sql = "UPDATE ".TB_PREF."transportman SET transportman_name=".db_escape($transportman_name) . ",
		transportman_phone=".db_escape($transportman_phone) . ",
		transportman_fax=".db_escape($transportman_fax) . ",
		transportman_email=".db_escape($transportman_email) . ",
		provision=".$provision.",
		break_pt=".$break_pt.",
		provision2=".$provision2."
		WHERE transportman_code = ".db_escape($selected_id);
   	db_query($sql,"The update of the transport person failed");
}

function delete_transportman($selected_id)
{
	$sql="DELETE FROM ".TB_PREF."transportman WHERE transportman_code=".db_escape($selected_id);
	db_query($sql,"The transport-person could not be deleted");
}

function get_transportmen($show_inactive)
{
	$sql = "SELECT * FROM ".TB_PREF."transportman";
	if (!$show_inactive) $sql .= " WHERE !inactive";
	return db_query($sql,"could not get transport persons");
}

function get_transportman($selected_id)
{
	$sql = "SELECT *  FROM ".TB_PREF."transportman WHERE transportman_code=".db_escape($selected_id);

	$result = db_query($sql,"could not get transport person");
	return db_fetch($result);
}

function get_transportman_name($id)
{
	$sql = "SELECT transportman_name FROM ".TB_PREF."transportman WHERE transportman_code=".db_escape($id);

	$result = db_query($sql, "could not get transport type");

	$row = db_fetch_row($result);
	return $row[0];
}



?>
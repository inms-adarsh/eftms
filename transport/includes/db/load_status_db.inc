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
function add_load_status($load_status_name, $load_status_type)
{
	$sql = "INSERT INTO ".TB_PREF."load_status (load_status_name, load_status_type)
		VALUES ("
			.db_escape($load_status_name).", ".db_escape($load_status_type).")";

	return db_query($sql);
}

function update_load_status($load_status_code, $load_status_name, $load_status_type)
{
    $sql = "UPDATE ".TB_PREF."load_status SET load_status_name=".db_escape($load_status_name)
    .",load_status_type=".db_escape($load_status_type)."
		 WHERE load_status_code = ".db_escape($load_status_code);

	return db_query($sql);
}

function delete_load_status($code)
{
	$sql = "DELETE FROM ".TB_PREF."load_status WHERE load_status_code=".db_escape($code);

	db_query($sql, "could not delete load status");
}

function get_load_statuses($from=null, $to=null, $type=null)
{
	$sql = "SELECT ".TB_PREF."load_status.*,".TB_PREF."load_status_group_types.name AS AccountTypeName
		FROM ".TB_PREF."load_status,".TB_PREF."load_status_group_types
		WHERE ".TB_PREF."load_status.load_status_type=".TB_PREF."load_status_group_types.id";
	if ($from != null)
		$sql .= " AND ".TB_PREF."load_status.load_status_code >= ".db_escape($from);
	if ($to != null)
		$sql .= " AND ".TB_PREF."load_status.load_status_code <= ".db_escape($to);
	if ($type != null)
		$sql .= " AND load_status_type=".db_escape($type);
	$sql .= " ORDER BY load_status_code";

	return db_query($sql, "could not get load statuss");
}
function get_all_load_status($show_inactive) {
	$sql = "SELECT ls.load_status_name,lsg.name,ls.load_status_code
		FROM ".TB_PREF."load_status ls,".TB_PREF."load_status_group_types lsg WHERE ls.load_status_type=lsg.id";
	return $sql;
}	

function get_load_status($code)
{
	$sql = "SELECT * FROM ".TB_PREF."load_status WHERE load_status_code=".db_escape($code);

	$result = db_query($sql, "could not get load status");
	return db_fetch($result);
}

function get_load_status_name($code)
{
	$sql = "SELECT load_status_name from ".TB_PREF."load_status WHERE load_status_code=".db_escape($code);

	$result = db_query($sql,"could not retreive the load_status name for $code");

	if (db_num_rows($result) == 1)
	{
		$row = db_fetch_row($result);
		return $row[0];
	}

	display_db_error("could not retreive the load_status name for $code", $sql, true);
}

?>
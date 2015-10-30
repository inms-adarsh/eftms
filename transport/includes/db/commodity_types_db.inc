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
function add_commodity_type($commodity_type_name, $commodity_group_type)
{
	$sql = "INSERT INTO ".TB_PREF."commodity_type (commodity_type_name, commodity_group_type)
		VALUES ("
			.db_escape($commodity_type_name).", ".db_escape($commodity_group_type).")";

	return db_query($sql);
}

function update_commodity_type($commodity_type_code, $commodity_type_name, $commodity_group_type)
{
    $sql = "UPDATE ".TB_PREF."commodity_type SET commodity_type_name=".db_escape($commodity_type_name)
    .",commodity_group_type=".db_escape($commodity_group_type)."
		 WHERE commodity_type_code = ".db_escape($commodity_type_code);

	return db_query($sql);
}

function delete_commodity_type($code)
{
	$sql = "DELETE FROM ".TB_PREF."commodity_type WHERE commodity_type_code=".db_escape($code);

	db_query($sql, "could not delete commodity type");
}

function get_commodity_types($from=null, $to=null, $type=null)
{
	$sql = "SELECT ".TB_PREF."commodity_type.*,".TB_PREF."commodity_group_types.name AS CommodityTypeName
		FROM ".TB_PREF."commodity_type,".TB_PREF."commodity_type_group_types
		WHERE ".TB_PREF."commodity_type.commodity_group_type=".TB_PREF."commodity_group_types.id";
	if ($from != null)
		$sql .= " AND ".TB_PREF."commodity_type.commodity_type_code >= ".db_escape($from);
	if ($to != null)
		$sql .= " AND ".TB_PREF."commodity_type.commodity_type_code <= ".db_escape($to);
	if ($type != null)
		$sql .= " AND commodity_group_type=".db_escape($type);
	$sql .= " ORDER BY commodity_type_code";

	return db_query($sql, "could not get commodity types");
}

function get_commodity_type($code)
{
	$sql = "SELECT * FROM ".TB_PREF."commodity_type WHERE commodity_type_code=".db_escape($code);

	$result = db_query($sql, "could not get commodity type");
	return db_fetch($result);
}

function get_commodity_type_name($code)
{
	$sql = "SELECT commodity_type_name from ".TB_PREF."commodity_type WHERE commodity_type_code=".db_escape($code);

	$result = db_query($sql,"could not retreive the commodity_type name for $code");

	if (db_num_rows($result) == 1)
	{
		$row = db_fetch_row($result);
		return $row[0];
	}

	display_db_error("could not retreive the commodity_type name for $code", $sql, true);
}

?>
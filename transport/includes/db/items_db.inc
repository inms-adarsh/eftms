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
function update_transport_item($stock_id, $description, $long_description, $tax_type_id, $units='', $editable)
{
	$sql = "UPDATE ".TB_PREF."transport_items_master SET long_description=".db_escape($long_description).",
		description=".db_escape($description).",
		tax_type_id=".db_escape($tax_type_id).",
		editable=".db_escape($editable);

	if ($units != '')
		$sql .= ", units='$units'";
	$sql .= " WHERE stock_id=".db_escape($stock_id);

	db_query($sql, "The item could not be updated");

	update_transport_item_code(-1, $stock_id, $stock_id, $description, 1, 0);
}

function add_transport_item($description, $long_description, $tax_type_id,$units,  $editable)
{
	$sql = "INSERT INTO ".TB_PREF."transport_items_master (description, long_description, tax_type_id,units, editable)
		VALUES (".db_escape($description).", ".db_escape($long_description).", ".db_escape($tax_type_id).","
		.db_escape($units).", "
		.db_escape($editable).")";

	db_query($sql, "The item could not be added");
	$stock_id = mysql_insert_id();
	add_transport_item_code($stock_id, $stock_id, $description,  1, 0);
}

function delete_transport_item($stock_id)
{
	$sql="DELETE FROM ".TB_PREF."transport_items_master WHERE stock_id=".db_escape($stock_id);
	db_query($sql, "could not delete stock item");
	/*and cascade deletes in prices */
	$sql ="DELETE FROM ".TB_PREF."prices WHERE stock_id=".db_escape($stock_id);
	db_query($sql, "could not delete stock item prices");

}

function update_transport_item_code($id, $item_code, $stock_id, $description,  $qty, $foreign=0)
{
	$sql = "UPDATE ".TB_PREF."transport_item_codes SET
	 	item_code = ".db_escape($item_code).",
	 	stock_id = ".db_escape($stock_id).",
	 	description = ".db_escape($description).",
	 	quantity = ".db_escape($qty).",
	 	is_foreign = ".db_escape($foreign)."
        	WHERE ";
			
	if ($id == -1) // update with unknown $id i.e. from items table editor
	 	$sql .= "item_code = ".db_escape($item_code)
		." AND stock_id = ".db_escape($stock_id);
	else
		$sql .= "id = ".db_escape($id);

	db_query($sql,"an item code could not be updated");
}

function add_transport_item_code($item_code, $stock_id, $description,  $qty, $foreign=0,$category_description=null)
{
if($category_description==null)
{
$category_description='Transportable Items';
}
	$sql = "INSERT INTO ".TB_PREF."transport_item_codes
			(item_code, stock_id, description,  quantity,category_description, is_foreign) 
			VALUES( ".db_escape($item_code).",".db_escape($stock_id).",
	  		".db_escape($description).",".db_escape($qty).",".db_escape($category_description).",".db_escape($foreign).")";

	db_query($sql,"an item code could not be added");
}

function delete_transport_item_code($id)
{
	$sql="DELETE FROM ".TB_PREF."transport_item_codes WHERE id=".db_escape($id);
	db_query($sql,"an item code could not be deleted");
}


function get_all_items($show_inactive)
{
	$sql = "SELECT tm.description,tm.long_description, tm.units,tm.stock_id FROM ".TB_PREF."transport_items_master tm";
	return $sql;
}
function get_transport_item_code($id)
{
	$sql="SELECT * FROM ".TB_PREF."transport_item_codes WHERE id=".db_escape($id);

	$result = db_query($sql,"item code could not be retrieved");

	return db_fetch($result);
}

function get_all_transport_item_codes($stock_id, $foreign=1)
{
	$sql="SELECT i.*, i.category_description as cat_name FROM "
		.TB_PREF."transport_item_codes as i
		WHERE stock_id=".db_escape($stock_id)."
		
		AND i.is_foreign=".db_escape($foreign);

	$result = db_query($sql,"all item codes could not be retrieved");

	return $result;
}

function get_transport_item($stock_id)
{
	$sql = "SELECT ".TB_PREF."transport_items_master.*
		FROM ".TB_PREF."transport_items_master,".TB_PREF."item_tax_types
		WHERE stock_id=".db_escape($stock_id);
	$result = db_query($sql,"an item could not be retreived");

	return db_fetch($result);
}

function get_transport_items()
{
	$sql = "SELECT * FROM ".TB_PREF."transport_items_master";
	return db_query($sql,"items could not be retreived");
}
function get_transport_unit_dec($stock_id)
{
	$sql = "SELECT decimals FROM ".TB_PREF."item_units,	".TB_PREF."transport_items_master
		WHERE abbr=units AND stock_id=".db_escape($stock_id)." LIMIT 1";
	$result = db_query($sql, "could not get unit decimals");

	$row = db_fetch_row($result);
	return $row[0];
}
function get_already_delivered_transportable_items($stock_id, $location, $trans_no)
{
	$sql = "SELECT ".TB_PREF."stock_moves.qty
		FROM ".TB_PREF."stock_moves
		WHERE ".TB_PREF."stock_moves.stock_id = ".db_escape($stock_id)."
		AND ".TB_PREF."stock_moves.loc_code = ".db_escape($location)."
		AND type=".ST_CONSIGNORDELIVERY." AND trans_no=".db_escape($trans_no);
	$result = db_query($sql, "Could not get stock moves");
	$row = db_fetch_row($result);
	return $row[0];
}

//--------------------------------------------------------------------------------------

function get_transport_item_edit_info($stock_id)
{
	$sql = "SELECT material_cost + labour_cost + overhead_cost AS standard_cost, units, decimals
		FROM ".TB_PREF."transport_items_master,".TB_PREF."item_units
		WHERE stock_id=".db_escape($stock_id)
		." AND ".TB_PREF."transport_items_master.units=".TB_PREF."item_units.abbr";
	$result = db_query($sql, "The standard cost cannot be retrieved");

	return db_fetch($result);
}

//--------------------------------------------------------------------------------------

function get_standard_transport_cost($stock_id)
{
	$sql = "SELECT (material_cost + labour_cost + overhead_cost) AS std_cost
		FROM ".TB_PREF."transport_items_master s WHERE stock_id=".db_escape($stock_id);
	$result = db_query($sql, "The standard cost cannot be retrieved");

	$myrow = db_fetch_row($result);

	return $myrow[0];
}

//--------------------------------------------------------------------------------------

function is_transportable_item($stock_id)
{
	$sql = "SELECT stock_id FROM ".TB_PREF."transport_items_master
		WHERE stock_id=".db_escape($stock_id)." AND mb_flag <> 'D'";
	$result = db_query($sql, "Cannot query is inventory item or not");

	return db_num_rows($result) > 0;
}
function delete_transport_item_kit($item_code)
{
	$sql="DELETE FROM ".TB_PREF."transport_item_codes WHERE item_code=".db_escape($item_code);
	db_query($sql,"an item kit could not be deleted");
}

function get_transport_item_kit($item_code)
{
	$sql="SELECT DISTINCT kit.*, item.units, comp.description as comp_name 
		FROM "
		.TB_PREF."transport_item_codes kit,"
		.TB_PREF."transport_item_codes comp
		LEFT JOIN "
		.TB_PREF."transport_items_master item
		ON 
			item.stock_id=comp.item_code
		WHERE
			kit.stock_id=comp.item_code
			AND kit.item_code=".db_escape($item_code);

	$result = db_query($sql,"item kit could not be retrieved");

	return $result;
}

function get_transport_item_code_dflts($stock_id)
{
	$sql = "SELECT units, decimals, description, category_id
		FROM ".TB_PREF."transport_items_master,".TB_PREF."item_units
		WHERE stock_id=".db_escape($stock_id);

	$result = db_query($sql,"item code defaults could not be retrieved");
	return db_fetch($result);
}
//
//	Check if kit contains given item, optionally recursive.
//
function check_transport_item_in_kit($old_id, $kit_code, $item_code, $recurse=false)
{
	$result = get_transport_item_kit($kit_code);
	if ($result != 0)
	{
		while ($myrow = db_fetch($result))
		{
			if ($myrow['id'] == $old_id) 
				continue;
				
			if ($myrow['stock_id'] == $item_code)
			{
				return 1;
			}

			if ($recurse && $myrow['item_code'] != $myrow['stock_id']
				&& check_transport_item_in_kit($old_id, $item_code, $myrow['stock_id'], true))
			{
				return 1;
			}
		}
	}
	return 0;
}

function get_transport_item_kit_props($kit_code)
{
	$sql = "SELECT description, category_description FROM ".TB_PREF."transport_item_codes "
		. " WHERE item_code=".db_escape($kit_code);
	$res = db_query($sql, "kit name query failed");
	return db_fetch($res);
}

function update_transport_item_kit_props($kit_code, $name)
{
	$sql = "UPDATE ".TB_PREF."transport_item_codes SET description="
		. db_escape($name)."
		 WHERE item_code=".db_escape($kit_code);
	db_query($sql, "kit name update failed");
}

function get_kit_where_used($item_code)
{
	$sql = "SELECT item_code, description FROM "
		.TB_PREF."transport_item_codes "
		. " WHERE stock_id=".db_escape($item_code)."
			AND item_code!=".db_escape($item_code);
	return db_query($sql, "where used query failed");
}
?>
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
//----------------------------------------------------------------------------------------

function get_consignor_trans_details($consignor_trans_type, $consignor_trans_no)
{
if (!is_array($consignor_trans_no))
	$consignor_trans_no = array( 0=>$consignor_trans_no );

	$sql = "SELECT ".TB_PREF."consignor_trans_details.*,
		".TB_PREF."consignor_trans_details.unit_price+".TB_PREF."consignor_trans_details.unit_tax AS FullUnitPrice,
		".TB_PREF."consignor_trans_details.description As StockDescription,
		".TB_PREF."transport_items_master.units
		FROM ".TB_PREF."consignor_trans_details, ".TB_PREF."transport_items_master
		WHERE (";

	$tr=array();
	foreach ($consignor_trans_no as $trans_no)
		$tr[] = 'consignor_trans_no='.db_escape($trans_no);

	$sql .= implode(' OR ', $tr);


	$sql.=	") AND consignor_trans_type=".db_escape($consignor_trans_type)."
		AND ".TB_PREF."transport_items_master.stock_id=".TB_PREF."consignor_trans_details.stock_id
		ORDER BY id";
	return db_query($sql, "The consignor transaction detail could not be queried");
}

//----------------------------------------------------------------------------------------

function void_consignor_trans_details($type, $type_no)
{
	$sql = "UPDATE ".TB_PREF."consignor_trans_details SET quantity=0, unit_price=0,
		unit_tax=0, discount_percent=0, standard_cost=0, src_id=0
		WHERE consignor_trans_no=".db_escape($type_no)."
		AND consignor_trans_type=".db_escape($type);

	db_query($sql, "The consignor transaction details could not be voided");

	// clear the stock move items
	void_stock_move($type, $type_no);
}
//----------------------------------------------------------------------------------------

function write_consignor_trans_detail_item($consignor_trans_type, $consignor_trans_no, $stock_id, $description,
	$quantity,$to_units, $unit_price, $unit_tax, $discount_percent, $std_cost, $src_id, $line_id=0)
{
	if ($line_id!=0)
		$sql = "UPDATE ".TB_PREF."consignor_trans_details SET
			stock_id=".db_escape($stock_id).",
			description=".db_escape($description).",
			quantity=$quantity,
			to_units=".db_escape($to_units).",
			unit_price=$unit_price,
			unit_tax=$unit_tax,
			standard_cost=$std_cost,
			src_id=".db_escape($src_id)." WHERE
			id=".db_escape($line_id);
	else
			$sql = "INSERT INTO ".TB_PREF."consignor_trans_details (consignor_trans_no,
				consignor_trans_type, stock_id, description, quantity, to_units,unit_price,
				unit_tax,  standard_cost, src_id)
			VALUES (".db_escape($consignor_trans_no).", ".db_escape($consignor_trans_type).", ".db_escape($stock_id).
			", ".db_escape($description).",
				$quantity, ".db_escape($to_units).", $unit_price, $unit_tax, 
				 $std_cost,".db_escape($src_id).")";

	db_query($sql, "The consignor transaction detail could not be written");
}

?>
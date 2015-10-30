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

function update_vehicle($vehicle_id, $description, $long_description, $category_id, 
	$tax_type_id, $units='', $mb_flag='', $transport_account, $inventory_account, 
	$cogs_account, 	$adjustment_account, $assembly_account, $dimension_id, 
	$dimension2_id, $no_sale, $editable,$vehicle_sr_no,$vehicle_maker_name, 
		$vehicle_model_name,$vehicle_number_plate,$vehicle_color ,
		$vehicle_year, $vehicle_insurer_name,$vehicle_insurer_company,
		$vehicle_insurance_note,$vehicle_insurance_ref, $vehicle_insurance_date, $vehicle_insurance_expiry_date,
		$vehicle_insurance_expiry_date,$vehicle_lic_ref, $vehicle_lic_note, $vehicle_lic_date,
		$vehicle_lic_expiry_date,  $vehicle_purchase_date,
		$vehicle_warranty_date, $vehicle_purchase_note, $vehicle_wt,
		$vehicle_wt_unit, $vehicle_type_id, $vehicle_fuel_type_id,
		$vehicle_fuel_usage_id,$vehicle_odometer_type_id,$vehicle_init_odometer,$vehicle_warranty_odometer)
{
$insurance_date = date2sql($vehicle_insurance_date);
$insurance_expiry_date = date2sql($vehicle_insurance_expiry_date);
$lic_date = date2sql($vehicle_lic_date);
$lic_expiry_date  = date2sql($vehicle_lic_expiry_date);
$purchase_date= date2sql($vehicle_purchase_date);
$warranty_date= date2sql($vehicle_warranty_date);
	$sql = "UPDATE ".TB_PREF."vehicles_master SET long_description=".db_escape($long_description).",
		description=".db_escape($description).",
		category_id=".db_escape($category_id).",
		transport_account=".db_escape($transport_account).",
		inventory_account=".db_escape($inventory_account).",
		cogs_account=".db_escape($cogs_account).",
		adjustment_account=".db_escape($adjustment_account).",
		assembly_account=".db_escape($assembly_account).",
		dimension_id=".db_escape($dimension_id).",
		dimension2_id=".db_escape($dimension2_id).",
		tax_type_id=".db_escape($tax_type_id).",
		no_sale=".db_escape($no_sale).",
		vehicle_init_odometer=".db_escape($vehicle_init_odometer) .",
	vehicle_warranty_odometer=".db_escape($vehicle_warranty_odometer) .",
	vehicle_number_plate=".db_escape($vehicle_number_plate) .",
	vehicle_sr_no=".db_escape($vehicle_sr_no) .",
	vehicle_color=".db_escape($vehicle_color) .",
	vehicle_maker_name=".db_escape($vehicle_maker_name) .",
	vehicle_model_name=".db_escape($vehicle_model_name) .",
	vehicle_year=".db_escape($vehicle_year) .",
	vehicle_insurer_name=".db_escape($vehicle_insurer_name) .",
	vehicle_insurer_company=".db_escape($vehicle_insurer_company) .",
	vehicle_insurance_note=".db_escape($vehicle_insurance_note) .",
	vehicle_insurance_ref=".db_escape($vehicle_insurance_ref) .",
	vehicle_insurance_date='$insurance_date',
	vehicle_insurance_expiry_date='$insurance_expiry_date',
	vehicle_lic_ref=".db_escape($vehicle_lic_ref) .",
	vehicle_lic_note=".db_escape($vehicle_lic_note) .",
	vehicle_lic_date='$lic_date',
	vehicle_lic_expiry_date='$lic_expiry_date',
	
	
	vehicle_purchase_date='$purchase_date',
	vehicle_warranty_date='$warranty_date',
	
	vehicle_purchase_note=".db_escape($vehicle_purchase_note) .",
	vehicle_wt=".db_escape($vehicle_wt) .",
	vehicle_wt_unit=".db_escape($vehicle_wt_unit) .",
	vehicle_type_id=".db_escape($vehicle_type_id) .",
	vehicle_fuel_type_id=".db_escape($vehicle_fuel_type_id) .",
	vehicle_fuel_usage_id=".db_escape($vehicle_fuel_usage_id) .",
	vehicle_odometer_type_id=".db_escape($vehicle_odometer_type_id) .",
		editable=".db_escape($editable);

	if ($units != '')
		$sql .= ", units='$units'";

	if ($mb_flag != '')
		$sql .= ", mb_flag='$mb_flag'";

	$sql .= " WHERE vehicle_id=".db_escape($vehicle_id);

	db_query($sql, "The item could not be updated");

	update_item_code(-1, $vehicle_id, $vehicle_id, $description, $category_id, 1, 0);
}

function add_vehicle($vehicle_id, $description, $long_description, $category_id, 
	$tax_type_id, $units, $mb_flag,	$transport_account, $inventory_account, 
	$cogs_account, $adjustment_account,	$assembly_account, $dimension_id, 
	$dimension2_id, $no_sale, $editable,$vehicle_sr_no,$vehicle_maker_name, 
		$vehicle_model_name,$vehicle_number_plate,$vehicle_color ,
		$vehicle_year, $vehicle_insurer_name,$vehicle_insurer_company,
		$vehicle_insurance_note,$vehicle_insurance_ref, $vehicle_insurance_date, $vehicle_insurance_expiry_date,
		$vehicle_insurance_expiry_date,$vehicle_lic_ref, $vehicle_lic_note, $vehicle_lic_date,
		$vehicle_lic_expiry_date,  $vehicle_purchase_date,
		$vehicle_warranty_date, $vehicle_purchase_note, $vehicle_wt,
		$vehicle_wt_unit, $vehicle_type_id, $vehicle_fuel_type_id,
		$vehicle_fuel_usage_id,$vehicle_odometer_type_id,$vehicle_init_odometer,$vehicle_warranty_odometer,$purchase_flag, $StkLocation)
{
$insurance_date = date2sql($vehicle_insurance_date);
$insurance_expiry_date = date2sql($vehicle_insurance_expiry_date);
$lic_date = date2sql($vehicle_lic_date);
$lic_expiry_date  = date2sql($vehicle_lic_expiry_date);
$purchase_date= date2sql($vehicle_purchase_date);
$warranty_date= date2sql($vehicle_warranty_date);
	$sql = "INSERT INTO ".TB_PREF."vehicles_master (vehicle_id, description, long_description, category_id,
		tax_type_id, units, mb_flag, transport_account, inventory_account, cogs_account,
		adjustment_account, assembly_account, dimension_id, dimension2_id, no_sale, editable,vehicle_init_odometer, vehicle_warranty_odometer, 
	vehicle_number_plate, vehicle_sr_no, vehicle_color, vehicle_maker_name, 
	vehicle_model_name, vehicle_year, vehicle_insurer_name,
	vehicle_insurer_company, vehicle_insurance_note, vehicle_insurance_ref,
	vehicle_insurance_date, vehicle_insurance_expiry_date, vehicle_lic_ref,
	vehicle_lic_note, vehicle_lic_date, vehicle_lic_expiry_date,
	  vehicle_purchase_date,
	vehicle_warranty_date,
	vehicle_purchase_note, vehicle_wt, vehicle_wt_unit, vehicle_type_id, 
	vehicle_fuel_type_id, vehicle_fuel_usage_id, vehicle_odometer_type_id)
		VALUES (".db_escape($vehicle_id).", ".db_escape($description).", ".db_escape($long_description).",
		".db_escape($category_id).", ".db_escape($tax_type_id).", "
		.db_escape($units).", ".db_escape($mb_flag).",
		".db_escape($transport_account).", ".db_escape($inventory_account)
		.", ".db_escape($cogs_account).",".db_escape($adjustment_account)
		.", ".db_escape($assembly_account).", "
		.db_escape($dimension_id).", ".db_escape($dimension2_id).","
		.db_escape($no_sale).","
		.db_escape($editable).",
		".db_escape($vehicle_init_odometer) .",
			".db_escape($vehicle_warranty_odometer) .",
			".db_escape($vehicle_number_plate) .",
			".db_escape($vehicle_sr_no) .",
			".db_escape($vehicle_color) .",
			".db_escape($vehicle_maker_name) .",
			".db_escape($vehicle_model_name) .",
			".db_escape($vehicle_year) .",
			".db_escape($vehicle_insurer_name) .",
			".db_escape($vehicle_insurer_company) .",
			".db_escape($vehicle_insurance_note) .",
			".db_escape($vehicle_insurance_ref) .",
			'$insurance_date',
			'$insurance_expiry_date',
			".db_escape($vehicle_lic_ref) .",
			".db_escape($vehicle_lic_note) .",
			'$lic_date',
			'$lic_expiry_date',
			
			
			'$purchase_date',
			'$warranty_date',
			
			".db_escape($vehicle_purchase_note) .",
			".db_escape($vehicle_wt) .",
			".db_escape($vehicle_wt_unit) .",
			".db_escape($vehicle_type_id) .",
			".db_escape($vehicle_fuel_type_id) .",
			".db_escape($vehicle_fuel_usage_id) .",
			".db_escape($vehicle_odometer_type_id) .")";

	db_query($sql, "The item could not be added");

	$sql = "INSERT INTO ".TB_PREF."loc_stock (loc_code, vehicle_id)
		SELECT ".TB_PREF."locations.loc_code, ".db_escape($vehicle_id)
		." FROM ".TB_PREF."locations";

		if($purchase_flag==1)
		{	
		$sql = "INSERT INTO ".TB_PREF."stock_moves (vehicle_id, loc_code, tran_date, reference, qty, standard_cost) VALUES
			(".db_escape($vehicle_id).",".db_escape($StkLocation).", '$purchase_date', 'auto', 1, 0)";   
		}
	db_query($sql, "The item locstock could not be added");
	
	add_item_code($vehicle_id, $vehicle_id, $description, $category_id, 1, 0);
}


function delete_vehicle($vehicle_id)
{
	$sql="DELETE FROM ".TB_PREF."vehicles_master WHERE vehicle_id=".db_escape($vehicle_id);
	db_query($sql, "could not delete stock item");

	/*and cascade deletes in loc_stock */
	$sql ="DELETE FROM ".TB_PREF."loc_stock WHERE vehicle_id=".db_escape($vehicle_id);
	db_query($sql, "could not delete stock item loc stock");

	/*and cascade deletes in purch_data */
	$sql ="DELETE FROM ".TB_PREF."purch_data WHERE vehicle_id=".db_escape($vehicle_id);
	db_query($sql, "could not delete stock item purch data");

	/*and cascade deletes in prices */
	$sql ="DELETE FROM ".TB_PREF."prices WHERE vehicle_id=".db_escape($vehicle_id);
	db_query($sql, "could not delete stock item prices");

	/*and cascade delete the bill of material if any */
	$sql = "DELETE FROM ".TB_PREF."bom WHERE parent=".db_escape($vehicle_id);
	db_query($sql, "could not delete stock item bom");

	
}

function get_vehicle($vehicle_id)
{
	$sql = "SELECT ".TB_PREF."vehicles_master.*,".TB_PREF."item_tax_types.name AS tax_type_name
		FROM ".TB_PREF."vehicles_master,".TB_PREF."item_tax_types
		WHERE ".TB_PREF."item_tax_types.id=".TB_PREF."vehicles_master.tax_type_id
		AND vehicle_id=".db_escape($vehicle_id);
	$result = db_query($sql,"an item could not be retreived");

	return db_fetch($result);
}

function get_vehicles()
{
	$sql = "SELECT * FROM ".TB_PREF."vehicles_master";
	return db_query($sql,"items could not be retreived");
}

function vehicle_in_foreign_codes($vehicle_id)
{
	$sqls=  array(
	
	"SELECT COUNT(*) FROM "
		.TB_PREF."transport_orders WHERE vehicle_no=".db_escape($vehicle_id) =>
	 _('Cannot delete this item because there are existing bookings for it.')
	);

	$msg = '';

	foreach($sqls as $sql=>$err) {
		$result = db_query($sql, "could not query stock usage");
		$myrow = db_fetch_row($result);
		if ($myrow[0] > 0) 
		{
			$msg = $err; break;
		}
	}
	if ($msg == '') {	

		$kits = get_where_used($vehicle_id);
		$num_kits = db_num_rows($kits);
		if ($num_kits) {
			$msg = _("This item cannot be deleted because some code aliases 
				or foreign codes was entered for it, or there are kits defined 
				using this item as component")
				.':<br>';

			while($num_kits--) {
				$kit = db_fetch($kits);
				$msg .= "'".$kit[0]."'";
				if ($num_kits) $msg .= ',';
			}

		}
	}
	return $msg;
}
?>
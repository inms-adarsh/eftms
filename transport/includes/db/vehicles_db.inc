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

function update_fleet_vehicle($vehicle_id, $description, $long_description,$editable,$vehicle_sr_no,$vehicle_maker_name, 
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

	update_vehicle_code(-1, $vehicle_id, $vehicle_id, $description, 1, 0);
}

function add_fleet_vehicle($description, $long_description,  $editable,$vehicle_sr_no,$vehicle_maker_name, 
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
	$sql = "INSERT INTO ".TB_PREF."vehicles_master (description, long_description,  editable,vehicle_init_odometer, vehicle_warranty_odometer, 
	vehicle_number_plate, vehicle_sr_no, vehicle_color, vehicle_maker_name, 
	vehicle_model_name, vehicle_year, vehicle_insurer_name,
	vehicle_insurer_company, vehicle_insurance_note, vehicle_insurance_ref,
	vehicle_insurance_date, vehicle_insurance_expiry_date, vehicle_lic_ref,
	vehicle_lic_note, vehicle_lic_date, vehicle_lic_expiry_date,
	  vehicle_purchase_date,
	vehicle_warranty_date,
	vehicle_purchase_note, vehicle_wt, vehicle_wt_unit, vehicle_type_id, 
	vehicle_fuel_type_id, vehicle_fuel_usage_id, vehicle_odometer_type_id)
		VALUES (".db_escape($description).", ".db_escape($long_description).","
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
	$vehicle_id = mysql_insert_id();
	$sql = "INSERT INTO ".TB_PREF."loc_stock (loc_code, vehicle_id)
		SELECT ".TB_PREF."locations.loc_code, ".db_escape($vehicle_id)
		." FROM ".TB_PREF."locations";

		if($purchase_flag==1)
		{	
		$sql = "INSERT INTO ".TB_PREF."stock_moves (vehicle_id, loc_code, tran_date, reference, qty, standard_cost) VALUES
			(".db_escape($vehicle_id).",".db_escape($StkLocation).", '$purchase_date', 'auto', 1, 0)";   
		}
	db_query($sql, "The item locstock could not be added");
	
	add_vehicle_code($vehicle_id, $vehicle_id, $description, 1, 0);
}


function delete_fleet_vehicle($vehicle_id)
{
	$sql="DELETE FROM ".TB_PREF."vehicles_master WHERE vehicle_id=".db_escape($vehicle_id);
	db_query($sql, "could not delete stock item");
}

function get_fleet_vehicle($vehicle_id)
{
	$sql = "SELECT ".TB_PREF."vehicles_master.*
		FROM ".TB_PREF."vehicles_master
		WHERE vehicle_id=".db_escape($vehicle_id);
	$result = db_query($sql,"an item could not be retreived");

	return db_fetch($result);
}

function get_fleet_vehicles()
{
	$sql = "SELECT * FROM ".TB_PREF."vehicles_master";
	return db_query($sql,"items could not be retreived");
}

function update_vehicle_code($id, $item_code, $vehicle_id, $description,  $qty, $foreign=0)
{
	$sql = "UPDATE ".TB_PREF."vehicle_codes SET
	 	item_code = ".db_escape($item_code).",
	 	vehicle_id = ".db_escape($vehicle_id).",
	 	description = ".db_escape($description).",
	 	quantity = ".db_escape($qty).",
	 	is_foreign = ".db_escape($foreign)."
        	WHERE ";
			
	if ($id == -1) // update with unknown $id i.e. from items table editor
	 	$sql .= "item_code = ".db_escape($item_code)
		." AND vehicle_id = ".db_escape($vehicle_id);
	else
		$sql .= "id = ".db_escape($id);

	db_query($sql,"an item code could not be updated");
}

function add_vehicle_code($item_code, $vehicle_id, $description,  $qty, $foreign=0)
{
	$sql = "INSERT INTO ".TB_PREF."vehicle_codes
			(item_code, vehicle_id, description,  quantity, is_foreign) 
			VALUES( ".db_escape($item_code).",".db_escape($vehicle_id).",
	  		".db_escape($description).",".db_escape($qty).",".db_escape($foreign).")";

	db_query($sql,"an item code could not be added");
}

function delete_vehicle_code($id)
{
	$sql="DELETE FROM ".TB_PREF."vehicle_codes WHERE id=".db_escape($id);
	db_query($sql,"an item code could not be deleted");
}

function get_vehicle_code($id)
{
	$sql="SELECT * FROM ".TB_PREF."vehicle_codes WHERE id=".db_escape($id);

	$result = db_query($sql,"item code could not be retrieved");

	return db_fetch($result);
}

function get_all_vehicle_codes($vehicle_id, $foreign=1)
{
	$sql="SELECT i.*, c.description as cat_name FROM "
		.TB_PREF."vehicle_codes as i,"
		.TB_PREF."stock_category as c
		WHERE vehicle_id=".db_escape($vehicle_id)."
		AND i.category_id=c.category_id
		AND i.is_foreign=".db_escape($foreign);

	$result = db_query($sql,"all item codes could not be retrieved");

	return $result;
}


function get_vehicle_name($vehicle_id)
{
	$sql = "SELECT name FROM ".TB_PREF."vehicles_master WHERE vehicle_no=".db_escape($vehicle_id);

	$result = db_query($sql, "could not get vehicle");

	$row = db_fetch_row($result);

	return $row[0];
}

function get_vehicle_habit($vehicle_id)
{
	$sql = "SELECT ".TB_PREF."vehicles_master.pymt_discount,
		".TB_PREF."credit_status.dissallow_invoices
		FROM ".TB_PREF."vehicles_master, ".TB_PREF."credit_status
		WHERE ".TB_PREF."vehicles_master.credit_status = ".TB_PREF."credit_status.id
			AND ".TB_PREF."vehicles_master.vehicle_no = ".db_escape($vehicle_id);

	$result = db_query($sql, "could not query vehicles");

	return db_fetch($result);
}

function get_vehicle_contacts($vehicle_id, $action=null)
{
	$results = array();
	$res = get_crm_persons('vehicle', $action, $vehicle_id);
	while($contact = db_fetch($res))
	{
		if ($contact['lang'] == 'C') // Fix for improper lang in demo sql files.
			$contact['lang'] = '';
		$results[] = $contact;
	}	
	return $results;
}
 
//function get_current_consignor_credit($vehicle_id)
//{
//	$custdet = get_vehicle_details($vehicle_id);
//
//	return $custdet['credit_limit']-$custdet['Balance'];

//} 

function is_new_vehicle($id)
{
	
}

function get_vehicle_by_ref($reference)
{
	$sql = "SELECT * FROM ".TB_PREF."vehicles_master WHERE vehicle_ref=".db_escape($reference);

	$result = db_query($sql, "could not get vehicle");

	return db_fetch($result);
}


function add_vehicle_type($description)
{
	$sql = "INSERT INTO ".TB_PREF."vehicle_types (vehicle_description) VALUES (".db_escape($description) . ")";
   	db_query($sql,"The transport vehicle_type could not be added");
}

function update_vehicle_type($selected_id, $description)
{
	$sql = "UPDATE ".TB_PREF."vehicle_types SET vehicle_description=".db_escape($description)." WHERE vehicle_type_code = ".db_escape($selected_id);
   	db_query($sql,"The transport vehicle_type could not be updated");
}

function delete_vehicle_type($selected_id)
{
	$sql="DELETE FROM ".TB_PREF."vehicle_types WHERE vehicle_type_code=".db_escape($selected_id);
	db_query($sql,"could not delete transport vehicle_type");
}

function get_vehicle_types($show_inactive)
{
	$sql = "SELECT * FROM ".TB_PREF."vehicle_types";
	if (!$show_inactive) $sql .= " WHERE !inactive";
	return db_query($sql,"could not get vehicle_types");
}

function get_vehicle_type($selected_id)
{
	$sql = "SELECT * FROM ".TB_PREF."vehicle_types WHERE vehicle_type_code=".db_escape($selected_id);

	$result = db_query($sql,"could not get vehicle_type");
	return db_fetch($result);
}

function get_vehicle_type_name($id)
{
	$sql = "SELECT vehicle_description FROM ".TB_PREF."vehicle_types WHERE vehicle_type_code=".db_escape($id);

	$result = db_query($sql, "could not get transport type");

	$row = db_fetch_row($result);
	return $row[0];
}

function add_fuel_type($description)
{
	$sql = "INSERT INTO ".TB_PREF."fuel_types (fuel_description) VALUES (".db_escape($description) . ")";
   	db_query($sql,"The transport fuel_type could not be added");
}

function update_fuel_type($selected_id, $description)
{
	$sql = "UPDATE ".TB_PREF."fuel_types SET fuel_description=".db_escape($description)." WHERE fuel_type_code = ".db_escape($selected_id);
   	db_query($sql,"The transport fuel_type could not be updated");
}

function delete_fuel_type($selected_id)
{
	$sql="DELETE FROM ".TB_PREF."fuel_types WHERE fuel_type_code=".db_escape($selected_id);
	db_query($sql,"could not delete transport fuel_type");
}

function get_fuel_types($show_inactive)
{
	$sql = "SELECT * FROM ".TB_PREF."fuel_types";
	if (!$show_inactive) $sql .= " WHERE !inactive";
	return db_query($sql,"could not get fuel_types");
}

function get_fuel_type($selected_id)
{
	$sql = "SELECT * FROM ".TB_PREF."fuel_types WHERE fuel_type_code=".db_escape($selected_id);

	$result = db_query($sql,"could not get fuel_type");
	return db_fetch($result);
}

function get_fuel_type_name($id)
{
	$sql = "SELECT fuel_description FROM ".TB_PREF."fuel_types WHERE fuel_type_code=".db_escape($id);

	$result = db_query($sql, "could not get transport type");

	$row = db_fetch_row($result);
	return $row[0];
}

function add_vehicle_weight_type($description)
{
	$sql = "INSERT INTO ".TB_PREF."vehicle_weight_types (vehicle_weight_description) VALUES (".db_escape($description) . ")";
   	db_query($sql,"The transport vehicle_weight_type could not be added");
}

function update_vehicle_weight_type($selected_id, $description)
{
	$sql = "UPDATE ".TB_PREF."vehicle_weight_types SET vehicle_weight_description=".db_escape($description)." WHERE vehicle_weight_type_code = ".db_escape($selected_id);
   	db_query($sql,"The transport vehicle_weight_type could not be updated");
}

function delete_vehicle_weight_type($selected_id)
{
	$sql="DELETE FROM ".TB_PREF."vehicle_weight_types WHERE vehicle_weight_type_code=".db_escape($selected_id);
	db_query($sql,"could not delete transport vehicle_weight_type");
}

function get_vehicle_weight_types($show_inactive)
{
	$sql = "SELECT * FROM ".TB_PREF."vehicle_weight_types";
	if (!$show_inactive) $sql .= " WHERE !inactive";
	return db_query($sql,"could not get vehicle_weight_types");
}

function get_vehicle_weight_type($selected_id)
{
	$sql = "SELECT * FROM ".TB_PREF."vehicle_weight_types WHERE vehicle_weight_type_code=".db_escape($selected_id);

	$result = db_query($sql,"could not get vehicle_weight_type");
	return db_fetch($result);
}

function get_vehicle_weight_type_name($id)
{
	$sql = "SELECT vehicle_weight_description FROM ".TB_PREF."vehicle_weight_types WHERE vehicle_weight_type_code=".db_escape($id);

	$result = db_query($sql, "could not get transport type");

	$row = db_fetch_row($result);
	return $row[0];
}


function add_fuel_weight_type($description)
{
	$sql = "INSERT INTO ".TB_PREF."fuel_weight_types (fuel_weight_description) VALUES (".db_escape($description) . ")";
   	db_query($sql,"The transport fuel_weight_type could not be added");
}

function update_fuel_weight_type($selected_id, $description)
{
	$sql = "UPDATE ".TB_PREF."fuel_weight_types SET fuel_weight_description=".db_escape($description)." WHERE fuel_weight_type_code = ".db_escape($selected_id);
   	db_query($sql,"The transport fuel_weight_type could not be updated");
}

function delete_fuel_weight_type($selected_id)
{
	$sql="DELETE FROM ".TB_PREF."fuel_weight_types WHERE fuel_weight_type_code=".db_escape($selected_id);
	db_query($sql,"could not delete transport fuel_weight_type");
}

function get_fuel_weight_types($show_inactive)
{
	$sql = "SELECT * FROM ".TB_PREF."fuel_weight_types";
	if (!$show_inactive) $sql .= " WHERE !inactive";
	return db_query($sql,"could not get fuel_weight_types");
}

function get_fuel_weight_type($selected_id)
{
	$sql = "SELECT * FROM ".TB_PREF."fuel_weight_types WHERE fuel_weight_type_code=".db_escape($selected_id);

	$result = db_query($sql,"could not get fuel_weight_type");
	return db_fetch($result);
}

function get_fuel_weight_type_name($id)
{
	$sql = "SELECT fuel_weight_description FROM ".TB_PREF."fuel_weight_types WHERE fuel_weight_type_code=".db_escape($id);

	$result = db_query($sql, "could not get transport type");

	$row = db_fetch_row($result);
	return $row[0];
}
function add_odometer_type($description)
{
	$sql = "INSERT INTO ".TB_PREF."odometer_types (odometer_description) VALUES (".db_escape($description) . ")";
   	db_query($sql,"The transport odometer_type could not be added");
}

function update_odometer_type($selected_id, $description)
{
	$sql = "UPDATE ".TB_PREF."odometer_types SET odometer_description=".db_escape($description)." WHERE odometer_type_code = ".db_escape($selected_id);
   	db_query($sql,"The transport odometer_type could not be updated");
}

function delete_odometer_type($selected_id)
{
	$sql="DELETE FROM ".TB_PREF."odometer_types WHERE odometer_type_code=".db_escape($selected_id);
	db_query($sql,"could not delete transport odometer_type");
}

function get_odometer_types($show_inactive)
{
	$sql = "SELECT * FROM ".TB_PREF."odometer_types";
	if (!$show_inactive) $sql .= " WHERE !inactive";
	return db_query($sql,"could not get odometer_types");
}

function get_odometer_type($selected_id)
{
	$sql = "SELECT * FROM ".TB_PREF."odometer_types WHERE odometer_type_code=".db_escape($selected_id);

	$result = db_query($sql,"could not get odometer_type");
	return db_fetch($result);
}

function get_all_vehicles($show_inactive)
{
	$sql = "SELECT vh.vehicle_number_plate,vh.description,vh.vehicle_sr_no,vh.vehicle_maker_name,vh.vehicle_model_name,vh.vehicle_id FROM ".TB_PREF."vehicles_master vh";
	return $sql;
}

function get_odometer_type_name($id)
{
	$sql = "SELECT odometer_description FROM ".TB_PREF."odometer_types WHERE odometer_type_code=".db_escape($id);

	$result = db_query($sql, "could not get transport type");

	$row = db_fetch_row($result);
	return $row[0];
}


function add_vehicle_location_data( $vehicle_id, $location_id,$odometer_reading,
	 $date_of_reading, $driver_id,$log_description,$ref_id,$loc_status)
{
$reading_date = date2sql($date_of_reading);
	
if($loc_status=='Accident')
{
$sql = "INSERT INTO ".TB_PREF."odometer_data ( vehicle_id,location_id, odometer_reading,
		date, driver_id,log_description,category) VALUES (";
	$sql .= db_escape($vehicle_id). ",". db_escape($location_id). ", "
		.db_escape($odometer_reading) . ", '$reading_date', "
		.db_escape($driver_id) . ", "
		.db_escape($log_description) . ", 1)";
		
	db_query($sql,"The supplier purchasing details could not be added");
	$odometer_id = mysql_insert_id();
	$sql = "INSERT INTO ".TB_PREF."accident_data ( vehicle_id,location_id, accident_reading,
		date, driver_id,accident_description,odometer_id) VALUES (";
	$sql .= db_escape($vehicle_id). ", "
		.db_escape($location_id) . ", "
		.db_escape($odometer_reading) . ", '$reading_date', "
		.db_escape($driver_id) . ",".db_escape($log_description) . ",$odometer_id)";

	db_query($sql,"The supplier purchasing details could not be added");
	$last_id = mysql_insert_id();

}
else
{
	$sql = "INSERT INTO ".TB_PREF."odometer_data ( vehicle_id,location_id, odometer_reading,
		date, driver_id,log_description) VALUES (";
	$sql .= db_escape($vehicle_id). ",". db_escape($location_id). ", "
		.db_escape($odometer_reading) . ", '$reading_date', "
		.db_escape($driver_id) . ", "
		.db_escape($log_description) . ")";

	db_query($sql,"The odometer data could not be added");
	$odometer_id = mysql_insert_id();
}
	$sql = "INSERT INTO ".TB_PREF."vehicle_location_data ( vehicle_id,location_id, 
		date, driver_id,log_description,ref_no,odometer_ref,loc_status) VALUES (";
	$sql .= db_escape($vehicle_id). ",". db_escape($location_id). ", '$reading_date', "
		.db_escape($driver_id) . ", "
		.db_escape($log_description) . ", "
		.db_escape($ref_id) . ",
		".db_escape($odometer_id).",
		".db_escape($loc_status).")";
	
	db_query($sql,"The location details could not be added");
	
}

function update_vehicle_location_data($selected_id,$vehicle_id,$location_id, $odometer_reading,$odometer_id,
	 $date_of_reading, $driver_id,$log_description,$ref_id,$loc_status)
{
$reading_date = date2sql($date_of_reading);
	$sql = "UPDATE ".TB_PREF."vehicle_location_data SET 
		
		date='$reading_date',
		driver_id=" . db_escape($driver_id) . ",
		location_id=" . db_escape($location_id) . ",
		loc_status=" . db_escape($loc_status) . ",
		log_description=" . db_escape($log_description) . "
		WHERE vehicle_id=".db_escape($vehicle_id) . " AND
		loc_status_id=".db_escape($selected_id);
		
	db_query($sql,"The location details could not be updated");
	
	$sql = "UPDATE ".TB_PREF."odometer_data SET odometer_reading=" . db_escape($odometer_reading) . ",
		
		date='$reading_date',
		driver_id=" . db_escape($driver_id) . ",
		location_id=" . db_escape($location_id) . ",
		log_description=" . db_escape($log_description) . "
		WHERE odometer_id=".db_escape($odometer_id);
	db_query($sql,"The supplier purchasing details could not be updated");
}
function get_vehicle_location_data($ref_id)
{
    $sql = "SELECT ".TB_PREF."vehicle_location_data.*,".TB_PREF."odometer_data.*,".TB_PREF."odometer_types.odometer_description,".TB_PREF."locations.location_name,".TB_PREF."drivers_master.name,".TB_PREF."vehicles_master.description
		FROM ".TB_PREF."vehicle_location_data 
		left join ".TB_PREF."odometer_data ON ".TB_PREF."vehicle_location_data.odometer_ref=".TB_PREF."odometer_data.odometer_id 
		INNER JOIN ".TB_PREF."vehicles_master
		ON ".TB_PREF."odometer_data.vehicle_id=".TB_PREF."vehicles_master.vehicle_id
		left join ".TB_PREF."odometer_types ON ".TB_PREF."vehicles_master.vehicle_odometer_type_id=".TB_PREF."odometer_types.odometer_type_code
		left join ".TB_PREF."drivers_master ON ".TB_PREF."odometer_data.driver_id=".TB_PREF."drivers_master.driver_no
		left join ".TB_PREF."locations ON ".TB_PREF."odometer_data.location_id=".TB_PREF."locations.loc_code
		WHERE ".TB_PREF."vehicle_location_data.ref_no = ".db_escape($ref_id)." AND ".TB_PREF."vehicle_location_data.odometer_ref=".TB_PREF."odometer_data.odometer_id";
	
	$result = db_query($sql, "The location details for particular load could not be retrieved");

	return $result;
}
function get_vehicle_location_datas($selected_id, $ref_id)
{
	$sql = "SELECT ".TB_PREF."vehicle_location_data.*,".TB_PREF."odometer_data.*,".TB_PREF."odometer_types.odometer_description,".TB_PREF."locations.loc_code,".TB_PREF."drivers_master.name,
	".TB_PREF."vehicles_master.description FROM ".TB_PREF."vehicle_location_data
		left join ".TB_PREF."odometer_data ON ".TB_PREF."vehicle_location_data.odometer_ref=".TB_PREF."odometer_data.odometer_id 
		INNER JOIN ".TB_PREF."vehicles_master ON ".TB_PREF."odometer_data.vehicle_id=".TB_PREF."vehicles_master.vehicle_id
		left join ".TB_PREF."odometer_types ON ".TB_PREF."vehicles_master.vehicle_odometer_type_id=".TB_PREF."odometer_types.odometer_type_code
		left join ".TB_PREF."drivers_master ON ".TB_PREF."odometer_data.driver_id=".TB_PREF."drivers_master.driver_no
		left join ".TB_PREF."locations ON ".TB_PREF."odometer_data.location_id=".TB_PREF."locations.loc_code
		WHERE ".TB_PREF."vehicle_location_data.loc_status_id=".db_escape($selected_id)."
			AND ".TB_PREF."vehicle_location_data.odometer_ref=".TB_PREF."odometer_data.odometer_id";

	$result = db_query($sql, "The supplier purchasing details for the selected supplier and item could not be retrieved");

	return db_fetch($result);
}
function delete_vehicle_location_data($selected_id, $ref_id)
{
$result = get_vehicle_location_datas($selected_id, $ref_id);
	$odometer_id=$result["odometer_id"];
	
	$sql = "DELETE FROM ".TB_PREF."vehicle_location_data WHERE loc_status_id=".db_escape($selected_id)."
		AND ref_no=".db_escape($ref_id);
		db_query($sql,"could not delete purchasing data");
	
	$sql = "DELETE FROM ".TB_PREF."odometer_data WHERE odometer_id=".db_escape($odometer_id);
	db_query($sql,"could not delete purchasing data");
	
	
}
?>
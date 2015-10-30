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

function add_vehicle_odometer_data( $vehicle_id, $location_id,$odometer_reading,
	 $date_of_reading, $driver_id,$log_description)
{
$reading_date = date2sql($date_of_reading);
	$sql = "INSERT INTO ".TB_PREF."odometer_data ( vehicle_id,location_id, odometer_reading,
		date, driver_id,log_description) VALUES (";
	$sql .= db_escape($vehicle_id). ",". db_escape($location_id). ", "
		.db_escape($odometer_reading) . ", '$reading_date', "
		.db_escape($driver_id) . ", "
		.db_escape($log_description) . ")";

	db_query($sql,"The supplier purchasing details could not be added");
}

function update_vehicle_odometer_data($selected_id,$vehicle_id,$location_id, $odometer_reading,
	 $date_of_reading, $driver_id,$log_description)
{
$reading_date = date2sql($date_of_reading);
	$sql = "UPDATE ".TB_PREF."odometer_data SET odometer_reading=" . db_escape($odometer_reading) . ",
		
		date='$reading_date',
		driver_id=" . db_escape($driver_id) . ",
		location_id=" . db_escape($location_id) . ",
		log_description=" . db_escape($log_description) . "
		WHERE vehicle_id=".db_escape($vehicle_id) . " AND
		odometer_id=".db_escape($selected_id);
	db_query($sql,"The supplier purchasing details could not be updated");
}
function add_vehicle_accident_odometer_data($vehicle_id, $location_id,$odometer_reading,
	 $date_of_reading, $driver_id,$log_description,$accident_id,$accident_flag)
{
$reading_date = date2sql($date_of_reading);
	$sql = "INSERT INTO ".TB_PREF."odometer_data ( vehicle_id,location_id, odometer_reading,
		date, driver_id,log_description,accident_id,category) VALUES (";
	$sql .= db_escape($vehicle_id). ",". db_escape($location_id). ", "
		.db_escape($odometer_reading) . ", '$reading_date', "
		.db_escape($driver_id) . ", "
		.db_escape($log_description) . ", "
		.db_escape($accident_id) . ", "
		.db_escape($accident_flag) . ")";

	db_query($sql,"The supplier purchasing details could not be added");
}

function update_vehicle_accident_odometer_data($vehicle_id,$location_id, $odometer_reading,
	 $date_of_reading, $driver_id,$log_description,$accident_id)
{
$reading_date = date2sql($date_of_reading);
	$sql = "UPDATE ".TB_PREF."odometer_data SET odometer_reading=" .db_escape($odometer_reading) . ",
		
		date='$reading_date',
		driver_id=" . db_escape($driver_id) . ",
		location_id=" . db_escape($location_id) . ",
		log_description=" . db_escape($log_description) . "
		WHERE vehicle_id=".db_escape($vehicle_id) . " AND accident_id=".db_escape($accident_id);
	db_query($sql,"The supplier purchasing details could not be updated");
}

function add_vehicle_wo_odometer_data($vehicle_id, $location_id,$odometer_reading,
	 $date_of_reading, $log_description,$wo_id,$wo_flag)
{
$reading_date = date2sql($date_of_reading);
	$sql = "INSERT INTO ".TB_PREF."odometer_data ( vehicle_id,location_id, odometer_reading,
		date, log_description,wo_id,category) VALUES (";
	$sql .= db_escape($vehicle_id). ",". db_escape($location_id). ", "
		.db_escape($odometer_reading) . ", '$reading_date', "
		
		.db_escape($log_description) . ", "
		.db_escape($wo_id) . ", "
		.db_escape($wo_flag) . ")";

	db_query($sql,"The supplier purchasing details could not be added");
}

function update_vehicle_wo_odometer_data($vehicle_id,$location_id, $odometer_reading,
	 $date_of_reading,$log_description,$wo_id)
{
$reading_date = date2sql($date_of_reading);
	$sql = "UPDATE ".TB_PREF."odometer_data SET odometer_reading=" . db_escape($odometer_reading) . ",
		
		date='$reading_date',
		
		location_id=" . db_escape($location_id) . ",
		log_description=" . db_escape($log_description) . "
		WHERE vehicle_id=".db_escape($vehicle_id) . " AND wo_id=".db_escape($wo_id);
	db_query($sql,"The supplier purchasing details could not be updated");
}


function delete_vehicle_odometer_data($selected_id, $vehicle_id)
{
	$sql = "DELETE FROM ".TB_PREF."odometer_data WHERE odometer_id=".db_escape($selected_id)."
		AND vehicle_id=".db_escape($vehicle_id);
	db_query($sql,"could not delete purchasing data");
}

function get_vehicle_odometer_data($vehicle_id)
{
    $sql = "SELECT ".TB_PREF."odometer_data.*,".TB_PREF."odometer_types.odometer_description,".TB_PREF."locations.location_name,".TB_PREF."drivers_master.name,".TB_PREF."vehicles_master.description
		FROM ".TB_PREF."odometer_data INNER JOIN ".TB_PREF."vehicles_master
		ON ".TB_PREF."odometer_data.vehicle_id=".TB_PREF."vehicles_master.vehicle_id
		left join ".TB_PREF."odometer_types ON ".TB_PREF."vehicles_master.vehicle_odometer_type_id=".TB_PREF."odometer_types.odometer_type_code
		left join ".TB_PREF."drivers_master ON ".TB_PREF."odometer_data.driver_id=".TB_PREF."drivers_master.driver_no
		left join ".TB_PREF."locations ON ".TB_PREF."odometer_data.location_id=".TB_PREF."locations.loc_code
		WHERE ".TB_PREF."odometer_data.vehicle_id = ".db_escape($vehicle_id)." ORDER BY ".TB_PREF."odometer_data.odometer_reading desc";
	
	$result = db_query($sql, "The supplier purchasing details for the selected supplier and item could not be retrieved");

	return $result;
}
function get_max_odometer_reading($vehicle_id)
{

    $sql = "SELECT MAX(".TB_PREF."odometer_data.odometer_reading) as max_reading
		FROM ".TB_PREF."odometer_data INNER JOIN ".TB_PREF."vehicles_master
		ON ".TB_PREF."odometer_data.vehicle_id=".TB_PREF."vehicles_master.vehicle_id
		WHERE ".TB_PREF."odometer_data.vehicle_id = ".db_escape($vehicle_id);
	
	$result = db_query($sql, "The supplier purchasing details for the selected supplier and item could not be retrieved");

	return db_fetch($result);
}
function get_vehicle_odometer_datas($selected_id, $vehicle_id)
{
	$sql = "SELECT ".TB_PREF."odometer_data.*,".TB_PREF."odometer_types.odometer_description,".TB_PREF."locations.loc_code,".TB_PREF."drivers_master.name,
	".TB_PREF."vehicles_master.description FROM ".TB_PREF."odometer_data
		INNER JOIN ".TB_PREF."vehicles_master ON ".TB_PREF."odometer_data.vehicle_id=".TB_PREF."vehicles_master.vehicle_id
		left join ".TB_PREF."odometer_types ON ".TB_PREF."vehicles_master.vehicle_odometer_type_id=".TB_PREF."odometer_types.odometer_type_code
		left join ".TB_PREF."drivers_master ON ".TB_PREF."odometer_data.driver_id=".TB_PREF."drivers_master.driver_no
		left join ".TB_PREF."locations ON ".TB_PREF."odometer_data.location_id=".TB_PREF."locations.loc_code
		WHERE ".TB_PREF."odometer_data.odometer_id=".db_escape($selected_id)."
			AND ".TB_PREF."odometer_data.vehicle_id=".db_escape($vehicle_id);

	$result = db_query($sql, "The supplier purchasing details for the selected supplier and item could not be retrieved");

	return db_fetch($result);
}
function get_odometer_reading_unit($vehicle_id)
{
    $sql = "SELECT odometers.odometer_description FROM ".TB_PREF."vehicles_master sm left join ".TB_PREF."odometer_types as odometers on sm.vehicle_odometer_type_id = odometers.odometer_type_code  WHERE sm.vehicle_id = ".db_escape($vehicle_id);

	$result = db_query($sql, "Retreive odometer_type of supplier $vehicle_id");

	return db_fetch($result);;
}

?>
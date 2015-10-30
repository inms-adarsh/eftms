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
$page_security = 'SA_VEHICLE';
$path_to_root = "../..";
include($path_to_root . "/includes/db_pager.inc");
include_once($path_to_root . "/includes/session.inc");
$js = "";
if ($use_popup_windows)
	$js .= get_js_open_window(900, 500);
if ($use_date_picker)
	$js .= get_js_date_picker();
	
page(_($help_context = "Vehicles"), @$_REQUEST['popup'], false, "", $js);

include_once($path_to_root . "/includes/date_functions.inc");
include_once($path_to_root . "/includes/ui.inc");
include_once($path_to_root . "/includes/data_checks.inc");

include_once($path_to_root . "/transport/includes/transport_db.inc");

$user_comp = user_company();
$new_item = $_GET['vehicle_id']=='' || get_post('cancel') || get_post('clone');
//------------------------------------------------------------------------------------

if (isset($_GET['vehicle_id']))
{
	$_POST['NewVehicleID'] = $vehicle_id = $_GET['vehicle_id'];
    clear_data();
	$Ajax->activate('details');
	$Ajax->activate('controls');
}
if (get_post('cancel')) {
	$_POST['NewVehicleID'] = $vehicle_id = $_POST['vehicle_id'] = '';
    clear_data();
	set_focus('vehicle_id');
	$Ajax->activate('_page_body');
}
if (list_updated('category_id') || list_updated('mb_flag')) {
	$Ajax->activate('details');
}
$upload_file = "";
if (isset($_FILES['pic']) && $_FILES['pic']['name'] != '') 
{
	$vehicle_id = $_POST['NewVehicleID'];
	$result = $_FILES['pic']['error'];
 	$upload_file = 'Yes'; //Assume all is well to start off with
	$filename = company_path().'/images';
	if (!file_exists($filename))
	{
		mkdir($filename);
	}	
	$filename .= "/".item_img_name($vehicle_id).".jpg";
	
	//But check for the worst 
	if ((list($width, $height, $type, $attr) = getimagesize($_FILES['pic']['tmp_name'])) !== false)
		$imagetype = $type;
	else
		$imagetype = false;
	//$imagetype = exif_imagetype($_FILES['pic']['tmp_name']);
	if ($imagetype != IMAGETYPE_GIF && $imagetype != IMAGETYPE_JPEG && $imagetype != IMAGETYPE_PNG)
	{	//File type Check
		display_warning( _('Only graphics files can be uploaded'));
		$upload_file ='No';
	}	
	elseif (@strtoupper(substr(trim($_FILES['pic']['name']), @in_array(strlen($_FILES['pic']['name']) - 3)), array('JPG','PNG','GIF')))
	{
		display_warning(_('Only graphics files are supported - a file extension of .jpg, .png or .gif is expected'));
		$upload_file ='No';
	} 
	elseif ( $_FILES['pic']['size'] > ($max_image_size * 1024)) 
	{ //File Size Check
		display_warning(_('The file size is over the maximum allowed. The maximum size allowed in KB is') . ' ' . $max_image_size);
		$upload_file ='No';
	} 
	elseif (file_exists($filename))
	{
		$result = unlink($filename);
		if (!$result) 
		{
			display_error(_('The existing image could not be removed'));
			$upload_file ='No';
		}
	}
	
	if ($upload_file == 'Yes')
	{
		$result  =  move_uploaded_file($_FILES['pic']['tmp_name'], $filename);
	}
	$Ajax->activate('details');
 /* EOF Add Image upload for New Vehicle  - by Ori */
}

check_db_has_stock_categories(_("There are no item categories defined in the system. At least one item category is required to add a item."));

check_db_has_item_tax_types(_("There are no item tax types defined in the system. At least one item tax type is required to add a item."));

function clear_data()
{
	unset($_POST['long_description']);
	unset($_POST['description']);
	unset($_POST['category_id']);
	unset($_POST['tax_type_id']);
	unset($_POST['units']);
	unset($_POST['mb_flag']);
	unset($_POST['NewVehicleID']);
	unset($_POST['dimension_id']);
	unset($_POST['dimension2_id']);
	unset($_POST['no_sale']);
}

//------------------------------------------------------------------------------------

if (isset($_POST['addupdate'])) 
{
	
	$input_error = 0;
	if ($upload_file == 'No')
		$input_error = 1;
	if (strlen($_POST['description']) == 0) 
	{
		$input_error = 1;
		display_error( _('The item name must be entered.'));
		set_focus('description');
	} 
	
	elseif (strstr($_POST['NewVehicleID'], " ") || strstr($_POST['NewVehicleID'],"'") || 
		strstr($_POST['NewVehicleID'], "+") || strstr($_POST['NewVehicleID'], "\"") || 
		strstr($_POST['NewVehicleID'], "&") || strstr($_POST['NewVehicleID'], "\t")) 
	{
		$input_error = 1;
		display_error( _('The item code cannot contain any of the following characters -  & + OR a space OR quotes'));
		set_focus('NewVehicleID');

	}
	elseif ($_POST['NewVehicleID'] && db_num_rows(get_transport_item_kit($_POST['NewVehicleID'])))
	{
		  	$input_error = 1;
      		display_error( _("This vehicle code is already assigned to stock vehicle or sale kit."));
			set_focus('NewVehicleID');
	}

	if ($input_error != 1)
	{
		if (check_value('del_image'))
		{
			$filename = company_path().'/images/'.item_img_name($_POST['NewVehicleID']).".jpg";
			if (file_exists($filename))
				unlink($filename);
		}
		
		if ($_POST['NewVehicleID']) 
		{ /*so its an existing one */
	
			update_fleet_vehicle($_POST['NewVehicleID'], $_POST['description'],
				$_POST['long_description'],  check_value('editable'),$_POST['vehicle_sr_no'],$_POST['vehicle_maker_name'], 
		$_POST['vehicle_model_name'],$_POST['description'],$_POST['vehicle_color'] ,
		$_POST['vehicle_year'], $_POST['vehicle_insurer_name'],$_POST['vehicle_insurer_company'],
		$_POST['vehicle_insurance_note'],$_POST['vehicle_insurance_ref'], $_POST['vehicle_insurance_date'], $_POST['vehicle_insurance_expiry_date'],
		$_POST['vehicle_insurance_expiry_date'],$_POST['vehicle_lic_ref'], $_POST['vehicle_lic_note'], $_POST['vehicle_lic_date'],
		$_POST['vehicle_lic_expiry_date'],  $_POST['vehicle_purchase_date'],
		$_POST['vehicle_warranty_date'], $_POST['vehicle_purchase_note'], $_POST['vehicle_wt'],
		$_POST['vehicle_wt_unit'], $_POST['vehicle_type_id'], $_POST['vehicle_fuel_type_id'],
		$_POST['vehicle_fuel_usage_id'],$_POST['vehicle_odometer_type_id'],$_POST['vehicle_init_odometer'],$_POST['vehicle_warranty_odometer']);
		
		
			update_record_status($_POST['NewVehicleID'], $_POST['inactive'],
				'stock_master', 'vehicle_id');
			update_record_status($_POST['NewVehicleID'], $_POST['inactive'],
				'item_codes', 'item_code');
			meta_forward($path_to_root .'/transport/manage/vehicles.php','updated=Y');
			set_focus('vehicle_id');
			$Ajax->activate('vehicle_id'); // in case of status change
			//display_notification(_("Carrier has been updated."));
		} 
		else 
		{ //it is a NEW part
		
			add_fleet_vehicle($_POST['description'],
				$_POST['long_description'],  check_value('editable'),$_POST['vehicle_sr_no'],$_POST['vehicle_maker_name'], 
		$_POST['vehicle_model_name'],$_POST['description'],$_POST['vehicle_color'] ,
		$_POST['vehicle_year'], $_POST['vehicle_insurer_name'],$_POST['vehicle_insurer_company'],
		$_POST['vehicle_insurance_note'],$_POST['vehicle_insurance_ref'], $_POST['vehicle_insurance_date'], $_POST['vehicle_insurance_expiry_date'],
		$_POST['vehicle_insurance_expiry_date'],$_POST['vehicle_lic_ref'], $_POST['vehicle_lic_note'], $_POST['vehicle_lic_date'],
		$_POST['vehicle_lic_expiry_date'],  $_POST['vehicle_purchase_date'],
		$_POST['vehicle_warranty_date'], $_POST['vehicle_purchase_note'], $_POST['vehicle_wt'],
		$_POST['vehicle_wt_unit'], $_POST['vehicle_type_id'], $_POST['vehicle_fuel_type_id'],
		$_POST['vehicle_fuel_usage_id'],$_POST['vehicle_odometer_type_id'],$_POST['vehicle_init_odometer'],$_POST['vehicle_warranty_odometer'],$_POST['purchase_flag'], $_POST['StkLocation']);
		
		
		
		
		
			//display_notification(_("A new carrier has been added."));
			$_POST['vehicle_id'] = $_POST['NewVehicleID'] = 
			$_POST['description'] = $_POST['long_description'] = '';
			$_POST['no_sale'] = $_POST['editable'] = 0;
			meta_forward($path_to_root .'/transport/manage/vehicles.php','updated=N');
			set_focus('NewVehicleID');
		}
		$Ajax->activate('_page_body');
	}
}

if (get_post('clone')) {
	unset($_POST['vehicle_id']);
	$vehicle_id = '';
	unset($_POST['inactive']);
	set_focus('NewVehicleID');
	$Ajax->activate('_page_body');
}

//------------------------------------------------------------------------------------

function check_usage($vehicle_id, $dispmsg=true)
{
	$msg = vehicle_in_foreign_codes($vehicle_id);

	if ($msg != '')	{
		if($dispmsg) display_error($msg);
		return false;
	}
	return true;
}

//------------------------------------------------------------------------------------

if (isset($_POST['delete']) && strlen($_POST['delete']) > 1) 
{

	if (check_usage($_POST['NewVehicleID'])) {

		$vehicle_id = $_POST['NewVehicleID'];
		delete_fleet_vehicle($vehicle_id);
		$filename = company_path().'/images/'.item_img_name($vehicle_id).".jpg";
		if (file_exists($filename))
			unlink($filename);
		meta_forward($path_to_root .'/transport/manage/vehicles.php','deleted=Y');
		$_POST['vehicle_id'] = '';
		clear_data();
		set_focus('vehicle_id');
		$new_item = true;
		$Ajax->activate('_page_body');
	}
}

function item_settings(&$vehicle_id) 
{
	global $SysPrefs, $path_to_root, $new_item, $pic_height;
		
	//------------------------------------------------------------------------------------
	if ($new_item) 
	{
//		text_row(_("Vehicle Code:"), 'NewVehicleID', null, 21, 20);
	$_POST['curr_code']  = get_company_currency();
						$_POST['vehicle_number_plate'] = '';
		$_POST['vehicle_maker_name'] = '';
		$_POST['vehicle_model_name'] = '';
		$_POST['vehicle_sr_no'] = '';
		$_POST['vehicle_year']  = '';
		$_POST['vehicle_color']  = '';
		$_POST['vehicle_wt']  = '';
		$_POST['vehicle_wt_unit']  = -1;
		$_POST['vehicle_type_id']  = -1;
		$_POST['vehicle_fuel_type_id']  =-1;
		$_POST['vehicle_fuel_usage_id']  = -1;
		$_POST['vehicle_insurer_name']  = '';
		$_POST['vehicle_insurer_company']  = '';
		$_POST['vehicle_insurance_ref']  = '';
		$_POST['vehicle_insurance_note']  = '';
		$_POST['vehicle_insurance_date'] = '';
		$_POST['vehicle_insurance_expiry_date'] = '';
		$_POST['vehicle_purchase_date'] = '';
		$_POST['vehicle_init_odometer'] = '';
		$_POST['vehicle_odometer_type_id'] = -1;
		$_POST['vehicle_warranty_odometer'] = '';
		$_POST['vehicle_purchase_note'] ='';
		$_POST['vehicle_lic_ref'] = '';
		$_POST['vehicle_lic_note'] = '';
		$_POST['vehicle_lic_date'] = '';
		$_POST['vehicle_lic_expiry_date'] = '';
		$_POST['inactive'] = 0;
	} 
	else 
	{ // Must be modifying an existing item
		if (get_post('NewVehicleID') != $_GET['vehicle_id'] || get_post('addupdate')) { // first item display

			$_POST['NewVehicleID'] = $_GET['vehicle_id'];

			$myrow = get_fleet_vehicle($_POST['NewVehicleID']);
			
			$_POST['long_description'] = $myrow["long_description"];
			$_POST['description'] = $myrow["description"];
			$_POST['category_id']  = $myrow["category_id"];
		
			$_POST['units']  = $myrow["units"];
			$_POST['mb_flag']  = $myrow["mb_flag"];
			
		
			$_POST['del_image'] = 0;	
			$_POST['inactive'] = $myrow["inactive"];
			$_POST['editable'] = $myrow["editable"];
			$_POST['vehicle_number_plate'] = $myrow["vehicle_number_plate"];
		$_POST['vehicle_sr_no'] = $myrow["vehicle_sr_no"];
		$_POST['vehicle_maker_name'] = $myrow["vehicle_maker_name"];
		$_POST['vehicle_model_name'] = $myrow["vehicle_model_name"];
		
		$_POST['vehicle_year']  = $myrow["vehicle_year"];
		$_POST['vehicle_color']  = $myrow["vehicle_color"];
		$_POST['vehicle_wt']  = $myrow["vehicle_wt"];
		$_POST['vehicle_wt_unit']  = $myrow["vehicle_wt"];
		$_POST['vehicle_type_id']  = $myrow["vehicle_type_id"];
		$_POST['vehicle_fuel_type_id']  = $myrow["vehicle_fuel_type_id"];
		$_POST['vehicle_fuel_usage_id']  = $myrow["vehicle_fuel_usage_id"];
		$_POST['vehicle_insurer_name']  = $myrow["vehicle_insurer_name"];
		$_POST['vehicle_insurer_company']  = $myrow["vehicle_insurer_company"];
		$_POST['vehicle_insurance_ref']  = $myrow["vehicle_insurance_ref"];
		$_POST['vehicle_insurance_note']  = $myrow["vehicle_insurance_note"];
		$_POST['vehicle_insurance_date'] = sql2date($myrow["vehicle_insurance_date"]);
		$_POST['vehicle_insurance_expiry_date'] = sql2date($myrow["vehicle_insurance_expiry_date"]);
		$_POST['vehicle_purchase_date'] = sql2date($myrow["vehicle_purchase_date"]);
		
		$_POST['vehicle_init_odometer'] = $myrow["vehicle_init_odometer"];
		$_POST['vehicle_odometer_type_id'] = $myrow["vehicle_odometer_type_id"];
		$_POST['vehicle_warranty_odometer'] = $myrow["vehicle_warranty_odometer"];
		$_POST['vehicle_purchase_note'] = $myrow["vehicle_purchase_note"];
		$_POST['vehicle_lic_ref'] = $myrow["vehicle_lic_ref"];
		$_POST['vehicle_lic_note'] = $myrow["vehicle_lic_note"];
		$_POST['vehicle_lic_date'] = sql2date($myrow["vehicle_lic_date"]);
		$_POST['vehicle_lic_expiry_date'] = sql2date($myrow["vehicle_lic_expiry_date"]);
		$_POST['inactive'] = $myrow["inactive"];
		$_POST['vehicle_number_plate'] = $myrow["vehicle_number_plate"];
		$_POST['vehicle_sr_no'] = $myrow["vehicle_sr_no"];
		$_POST['vehicle_maker_name'] = $myrow["vehicle_maker_name"];
		$_POST['vehicle_model_name'] = $myrow["vehicle_model_name"];
		
		$_POST['vehicle_year']  = $myrow["vehicle_year"];
		$_POST['vehicle_color']  = $myrow["vehicle_color"];
		$_POST['vehicle_wt']  = $myrow["vehicle_wt"];
		$_POST['vehicle_wt_unit']  = $myrow["vehicle_wt"];
		$_POST['vehicle_type_id']  = $myrow["vehicle_type_id"];
		$_POST['vehicle_fuel_type_id']  = $myrow["vehicle_fuel_type_id"];
		$_POST['vehicle_fuel_usage_id']  = $myrow["vehicle_fuel_usage_id"];
		$_POST['vehicle_insurer_name']  = $myrow["vehicle_insurer_name"];
		$_POST['vehicle_insurer_company']  = $myrow["vehicle_insurer_company"];
		$_POST['vehicle_insurance_ref']  = $myrow["vehicle_insurance_ref"];
		$_POST['vehicle_insurance_note']  = $myrow["vehicle_insurance_note"];
		$_POST['vehicle_insurance_date'] = sql2date($myrow["vehicle_insurance_date"]);
		$_POST['vehicle_insurance_expiry_date'] = sql2date($myrow["vehicle_insurance_expiry_date"]);
		$_POST['vehicle_purchase_date'] = sql2date($myrow["vehicle_purchase_date"]);
	
		$_POST['vehicle_init_odometer'] = $myrow["vehicle_init_odometer"];
		$_POST['vehicle_odometer_type_id'] = $myrow["vehicle_odometer_type_id"];
		$_POST['vehicle_warranty_odometer'] = $myrow["vehicle_warranty_odometer"];
		$_POST['vehicle_purchase_note'] = $myrow["vehicle_purchase_note"];
		$_POST['vehicle_lic_ref'] = $myrow["vehicle_lic_ref"];
		$_POST['vehicle_lic_note'] = $myrow["vehicle_lic_note"];
		$_POST['vehicle_lic_date'] = sql2date($myrow["vehicle_lic_date"]);
		$_POST['vehicle_lic_expiry_date'] = sql2date($myrow["vehicle_lic_expiry_date"]);
		}
		//label_row(_("Vehicle Code:"),$_POST['NewVehicleID']);
		hidden('NewVehicleID', $_POST['NewVehicleID']);
		set_focus('description');
	}

	text_row(_("Number Plate:"), 'description', null, 52, 200);
	text_row(_("Make:"), 'vehicle_maker_name', $_POST['vehicle_maker_name'], 40, 80);
	
	record_status_list_row(_("Vehicle status:"), 'inactive');
	
	text_row(_('Description:'), 'long_description', null, 52, 200);

	//stock_categories_vehicle_list_row(_("Category:"), 'category_id', null, false, $new_item);

	
    $_POST['editable'] = 0;

	
	$fresh_item = !isset($_POST['NewVehicleID']) || $new_item 
		|| check_usage($_GET['vehicle_id'],false);

	//item_tax_types_list_row(_("Vehicle Tax Type:"), 'tax_type_id', null);
	hidden('tax_type_id', 1);
	hidden('mb_flag', "M");
	//stock_item_types_list_row(_("Item Type:"), 'mb_flag', null, $fresh_item);
	//stock_vehicle_purchase_dtls_list_row(_("Purchase Type:"), 'purchase_flag', null, $fresh_item);
	text_row(_("Mode:"), 'vehicle_model_name', $_POST['vehicle_model_name'], 40, 80);
	vehicle_weight_categories_list_row(_("Vehicle Wt In:"), 'vehicle_wt_unit', $_POST['vehicle_wt_unit']);

	
	//locations_list_row(_("Receive Into:"), 'StkLocation', null, false, false); 


	//textarea_row(_("Purchase Notes:"), 'vehicle_purchase_note', null, 35, 5);
//	en
	
	// Add image upload for New Vehicle  - by Joe
	file_row(_("Image File (.jpg)") . ":", 'pic', 'pic');
	// Add Image upload for New Vehicle  - by Joe
	$stock_img_link = "";
	$check_remove_image = false;
	if (isset($_POST['NewVehicleID']) && file_exists(company_path().'/images/'
		.item_img_name($_POST['NewVehicleID']).".jpg")) 
	{
	 // 31/08/08 - rand() call is necessary here to avoid caching problems. Thanks to Peter D.
		$stock_img_link .= "<img id='item_img' alt = '[".$_POST['NewVehicleID'].".jpg".
			"]' src='".company_path().'/images/'.item_img_name($_POST['NewVehicleID']).
			".jpg?nocache=".rand()."'"." height='$pic_height' border='0'>";
		$check_remove_image = true;
	} 
	else 
	{
		$stock_img_link .= _("No image");
	}

	label_row("&nbsp;", $stock_img_link);
	if ($check_remove_image)
		check_row(_("Delete Image:"), 'del_image');
	//check_row(_("Editable description:"), 'editable');

	hidden('no_sale',1);
	

/*	table_section_title(_("General Details"));

//	text_row(_("Vehicle Number:"), 'vehicle_number_plate', $_POST['vehicle_number_plate'], 40, 80);
	text_row(_("Vehicle Serial No:"), 'vehicle_sr_no', $_POST['vehicle_sr_no'], 40, 80);
	
	small_amount_row(_("Year:"), 'vehicle_year', $_POST['vehicle_year'], null, 0);
	text_row(_("Color:"), 'vehicle_color', $_POST['vehicle_color'], 40, 80);
	amount_row(_("Vehicle Wt:"), 'vehicle_wt', $_POST['vehicle_wt'], null, 0);
	vehicle_weight_categories_list_cells(_("Vehicle Wt In:"), 'vehicle_wt_unit', $_POST['vehicle_wt_unit']);
	
	vehicle_categories_list_row(_("Vehicle Type:"), 'vehicle_type_id', $_POST['vehicle_type_id']);
	//stock_units_list_row(_('Units of Measure:'), 'vehicle_usage_type_id', null, $_POST['vehicle_usage_type_id']);
	fuel_categories_list_row(_("Fuel Type:"), 'vehicle_fuel_type_id', $_POST['vehicle_fuel_type_id']);
	fuel_weight_categories_list_row(_("Fuel Usage In:"), 'vehicle_fuel_usage_id', $_POST['vehicle_fuel_usage_id']);
	
	table_section_title(_("Insurance Details"));
	text_row(_("Insurer:"), 'vehicle_insurer_name', $_POST['vehicle_insurer_name'], 40, 80);
	text_row(_("Insur. Company:"), 'vehicle_insurer_company', $_POST['vehicle_insurer_company'], 40, 80);
	text_row(_("Vehicle Insur. Ref.:"), 'vehicle_insurance_ref', $_POST['vehicle_insurance_ref'], 40, 80);
	textarea_row(_("Notes:"), 'vehicle_insurance_note', null, 35, 5);
	date_row(_("Insurance Date:"), 'vehicle_insurance_date', '', true, 0, 0, 0, null, true);
	date_row(_("Insurance Expiry Date:"), 'vehicle_insurance_expiry_date', '', true, 0, 0, 0, null, true);
	

*/	
	/*
	$dim = get_company_pref('use_dimension');
	if ($dim >= 1)
	{
		table_section_title(_("Dimensions"));

		dimensions_list_row(_("Dimension")." 1", 'dimension_id', null, true, " ", false, 1);
		if ($dim > 1)
			dimensions_list_row(_("Dimension")." 2", 'dimension2_id', null, true, " ", false, 2);
	}
	if ($dim < 1)
		hidden('dimension_id', 0);
	if ($dim < 2)
		hidden('dimension2_id', 0);

	table_section_title(_("GL Accounts"));

	gl_all_accounts_list_row(_("Transport Account:"), 'transport_account', $_POST['transport_account']);

	if (!is_service($_POST['mb_flag'])) 
	{
		gl_all_accounts_list_row(_("Inventory Account:"), 'inventory_account', $_POST['inventory_account']);
		gl_all_accounts_list_row(_("C.O.G.S. Account:"), 'cogs_account', $_POST['cogs_account']);
		gl_all_accounts_list_row(_("Inventory Adjustments Account:"), 'adjustment_account', $_POST['adjustment_account']);
	}
	else 
	{
		gl_all_accounts_list_row(_("C.O.G.S. Account:"), 'cogs_account', $_POST['cogs_account']);
		hidden('inventory_account', $_POST['inventory_account']);
		hidden('adjustment_account', $_POST['adjustment_account']);
	}


	if (is_manufactured($_POST['mb_flag']))
		gl_all_accounts_list_row(_("Vehicle Assembly Costs Account:"), 'assembly_account', $_POST['assembly_account']);
	else
		hidden('assembly_account', $_POST['assembly_account']);
	*///
	//
	
//	vendor_list(_("Vehicle Type:"), 'vendor_id', $_POST['vendor_id']);
//	vendor_list(_("Vehicle Type:"), 'vendor_id', $_POST['vendor_id']);
//vendor_categories_list_row(_("Vendor Type:"), 'vehicle_vendor_id', $_POST['vehicle_vendor_id']);
//small_amount_row(_("Purchase Cost:"), 'vehicle_purchase_price', null, 40, null);
//text_row(_("Health Exam Ref:"), 'health_exam_ref', null, 40, 40);
/*date_row(_("Purchase Date:"), 'vehicle_purchase_date','', true, 0, 0, 0, null, true);
small_amount_row(_("Odometer on purchase:"), 'vehicle_init_odometer', null, null, 0);
small_amount_row(_("Odometer on Warranty Expire:"), 'vehicle_warranty_odometer', null, null, 0);
*/
  //  odometer_categories_list_row(_("Odometer Reading in:"), 'vehicle_odometer_type_id', $_POST['vehicle_odometer_type_id']);
	//date_row(_("Warranty Expire Date:"), 'vehicle_warranty_date','', true, 0, 0, 0, null, true);
	

/*	
	table_section_title(_("Licence Details"));
	text_row(_("Vehicle Licence. Ref.:"), 'vehicle_lic_ref', $_POST['vehicle_lic_ref'], 40, 80);
	textarea_row(_("Notes:"), 'vehicle_lic_note', null, 35, 5);
	date_row(_("Licence Date:"), 'vehicle_lic_date', '', true, 0, 0, 0, null, true);
	date_row(_("Licence Expiry Date:"), 'vehicle_lic_expiry_date', '', true, 0, 0, 0, null, true);
	
*/
	//
	
	

}

//-------------------------------------------------------------------------------------------- 

start_form(true);

if (db_has_vehicles()) 
{
	if (get_post('_show_inactive_update')) {
		$Ajax->activate('vehicle_id');
		set_focus('vehicle_id');
	}
}
else
{
	hidden('vehicle_id', $_GET['vehicle_id']);
}

div_start('details');

$vehicle_id = $_GET['vehicle_id'];
item_settings($vehicle_id); 

div_end();
start_form_section('text-center','controls');

	

		if ($new_item) 
		{
		submit_center('addupdate', _("Insert New Vehicle"), true, '', 'default');
		} 
		else 
		{
		submit_center_first('addupdate', _("Update Vehicle"), '', 
			@$_REQUEST['popup'] ? true : 'default');
		submit_return('select', get_post('vehicle_id'), 
			_("Select this items and return to document entry."), 'default');
		submit('clone', _("Clone This Vehicle"), true, '', true);
		submit('delete', _("Delete This Vehicle"), true, '', true);
		submit_center_last('cancel', _("Cancel"), _("Cancel Edition"), 'cancel');
		}
end_form_section();
hidden('popup', @$_REQUEST['popup']);
end_form();

//------------------------------------------------------------------------------------

end_page(@$_REQUEST['popup']);
?>

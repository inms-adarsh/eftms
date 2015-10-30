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
$_SESSION['page_title'] = _($help_context = "Search All Carriers");
page(_($help_context = "Vehicles"), @$_REQUEST['popup'], false, "", $js);

include_once($path_to_root . "/includes/date_functions.inc");
include_once($path_to_root . "/includes/ui.inc");
include_once($path_to_root . "/includes/data_checks.inc");

include_once($path_to_root . "/transport/includes/transport_db.inc");

$user_comp = user_company();
$new_item = get_post('vehicle_id')=='' || get_post('cancel') || get_post('clone'); 
//------------------------------------------------------------------------------------

if (isset($_GET['updated'])) {
        if($_GET['updated'] == 'N')
        {
             display_notification(_('New Carrier has been added'));
        }
        else {
            display_notification(_('Selected Carrier has been updated'));
        }
}

if (isset($_GET['deleted'])) {
        if($_GET['deleted'] == 'Y')
        {
             display_notification(_('Carrier has been deleted'));
        }
}
if (isset($_GET['vehicle_id']))
{
    $_POST['vehicle_id'] = $_GET['vehicle_id'];
}
$vehicle_id = get_post('vehicle_id');
if (list_updated('vehicle_id')) {
    $_POST['NewVehicleID'] = $vehicle_id = get_post('vehicle_id');
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
    {   //File type Check
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
    elseif ($new_item && db_num_rows(get_transport_item_kit($_POST['NewVehicleID'])))
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
        
        if (!$new_item) 
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
            set_focus('vehicle_id');
            $Ajax->activate('vehicle_id'); // in case of status change
            display_notification(_("Vehicle has been updated."));
        } 
        else 
        { //it is a NEW part
        
            add_fleet_vehicle($_POST['NewVehicleID'],$_POST['description'],
                $_POST['long_description'],  check_value('editable'),$_POST['vehicle_sr_no'],$_POST['vehicle_maker_name'], 
        $_POST['vehicle_model_name'],$_POST['description'],$_POST['vehicle_color'] ,
        $_POST['vehicle_year'], $_POST['vehicle_insurer_name'],$_POST['vehicle_insurer_company'],
        $_POST['vehicle_insurance_note'],$_POST['vehicle_insurance_ref'], $_POST['vehicle_insurance_date'], $_POST['vehicle_insurance_expiry_date'],
        $_POST['vehicle_insurance_expiry_date'],$_POST['vehicle_lic_ref'], $_POST['vehicle_lic_note'], $_POST['vehicle_lic_date'],
        $_POST['vehicle_lic_expiry_date'],  $_POST['vehicle_purchase_date'],
        $_POST['vehicle_warranty_date'], $_POST['vehicle_purchase_note'], $_POST['vehicle_wt'],
        $_POST['vehicle_wt_unit'], $_POST['vehicle_type_id'], $_POST['vehicle_fuel_type_id'],
        $_POST['vehicle_fuel_usage_id'],$_POST['vehicle_odometer_type_id'],$_POST['vehicle_init_odometer'],$_POST['vehicle_warranty_odometer'],$_POST['purchase_flag'], $_POST['StkLocation']);
        
        
        
        
        
            display_notification(_("A new vehicle has been added."));
            $_POST['vehicle_id'] = $_POST['NewVehicleID'] = 
            $_POST['description'] = $_POST['long_description'] = '';
            $_POST['no_sale'] = $_POST['editable'] = 0;
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

    if ($msg != '') {
        if($dispmsg) display_error($msg);
        return false;
    }
    return true;
}

function edit_link($row) 
{
    if (@$_GET['popup'])
        return '';
    return pager_link( _("Edit"),
    "/transport/manage/new_vehicle.php?vehicle_id=" . $row['vehicle_id'], ICON_EDIT);
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
        display_notification(_("Selected item has been deleted."));
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

 
    end_outer_table(1);
    
    div_start('controls');
    if (!isset($_POST['NewVehicleID']) || $new_item) 
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

    div_end();
}

//-------------------------------------------------------------------------------------------- 

start_form(true);


   start_form_section('row page-head');
   
    start_form_section('text-right col-md-5 col-sm-4 col-xs-6 actions');
        anchor_button(_("Add new Carrier"),$path_to_root .'/transport/manage/new_vehicle.php?NewVehicle=Yes','btn btn-primary');
    end_form_section();
    end_form_section();
    $sql = get_all_vehicles($_POST['show_inactive']);
     $cols = array(
        _("Number Plate"),
        _("Description"),
       _("Carrier Serial No"),
        _("Manufacturer"),
        _("Model")
        
    );
    array_append($cols, array(
    array('insert'=>true, 'fun'=>'edit_link')));
    check_cells(_("Show inactive:"), 'show_inactive', null, true);
    if (get_post('_show_inactive_update')) {
        $Ajax->activate('vehicle_id');
        set_focus('vehicle_id');
    }

$table =& new_db_pager('vehicles_tbl', $sql, $cols,null,null,20);
$table->width = "80%";

display_db_pager($table,'vehicles_tbl');


hidden('popup', @$_REQUEST['popup']);
end_form();

//------------------------------------------------------------------------------------

end_page(@$_REQUEST['popup']);
?>

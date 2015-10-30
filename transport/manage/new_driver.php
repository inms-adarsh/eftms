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
$page_security = 'SA_DRIVER';
$path_to_root = "../..";

include_once($path_to_root . "/includes/session.inc");
include_once($path_to_root . "/includes/date_functions.inc");
include_once($path_to_root . "/includes/banking.inc");
include_once($path_to_root . "/includes/ui.inc");
include_once($path_to_root . "/transport/includes/transport_db.inc");
include_once($path_to_root . "/includes/ui/contacts_view.inc");

add_access_extensions();
$js = "";
if ($use_popup_windows)
    $js .= get_js_open_window(900, 500);
if ($use_date_picker)
    $js .= get_js_date_picker();
    
page(_($help_context = "Drivers"), @$_REQUEST['popup'], false, "", $js); 
$selected_id = $_GET['driver_no'];
if (isset($_GET['driver_no'])) 
{
   $selected_id = $_GET['driver_no'];
}


$new_item =  $_GET['driver_no'] == '' || get_post('cancel') || get_post('clone'); 
//------------------------------------------------------------------------------------

if (isset($_GET['driver_no']))
{
   $_POST['driver_id'] = $driver_id = $_GET['driver_no'];
    $Ajax->activate('details');
    $Ajax->activate('controls');
}
if (get_post('cancel')) {
    $_POST['driver_id'] = $driver_id = $_POST['driver_no'] = '';
    $Ajax->activate('_page_body');
}


//--------------------------------------------------------------------------------------------

function can_process()
{
    if (strlen($_POST['name']) == 0) 
    {
        display_error(_("The driver name cannot be empty."));
        set_focus('name');
        return false;
    } 

    if (strlen($_POST['driver_ref']) == 0) 
    {
        display_error(_("The driver short name cannot be empty."));
        set_focus('driver_ref');
        return false;
    } 
    
    

    return true;
}

//--------------------------------------------------------------------------------------------

function handle_submit(&$selected_id)
{
    global $path_to_root, $Ajax, $auto_create_branch;

    if (!can_process())
        return;
        
    if ($_POST['driver_id']) 
    {
        update_driver($_POST['driver_id'],$_POST['name'],$_POST['licence_no'],$_POST['mobile_no'],
        $_POST['driver_ref'],$_POST['address'],
        $_POST['notes']);

        update_record_status($_POST['driver_id'], $_POST['inactive'],
            'drivers_master', 'driver_no');

        $Ajax->activate('driver_id'); // in case of status change
         meta_forward($path_to_root .'/transport/manage/drivers.php','updated=Y');
    } 
    else 
    {   //it is a new driver

        begin_transaction();
        add_driver($_POST['name'],
        $_POST['licence_no'],$_POST['mobile_no'],
         $_POST['driver_ref'],$_POST['address'],
         $_POST['notes']);

        $selected_id = $_POST['driver_id'] = db_insert_id();
         
        commit_transaction();
        meta_forward($path_to_root .'/transport/manage/drivers.php','updated=N');
        
        $Ajax->activate('_page_body');
    }
}
//--------------------------------------------------------------------------------------------

if (isset($_POST['submit'])) 
{
    handle_submit($selected_id);
}
//-------------------------------------------------------------------------------------------- 

if (isset($_POST['delete'])) 
{

    $cancel_delete = 0;

    // PREVENT DELETES IF DEPENDENT RECORDS IN 'driver_trans'

   
        if (key_in_foreign_table($_POST['driver_id'], 'transport_orders', 'driver_no'))
        {
            $cancel_delete = 1;
            display_error(_("Cannot delete the driver record because orders have been created against it."));
        } 
       
     
    if ($cancel_delete == 0) 
    {   //ie not cancelled the delete as a result of above tests
    
        delete_driver($_POST['driver_id']);

        meta_forward($path_to_root .'/transport/manage/drivers.php','deleted=Y');
        unset($_POST['driver_id']);
        $selected_id = '';
        $Ajax->activate('_page_body');
    } //end if Delete Driver
}

function driver_settings($driver_id) 
{
    global $SysPrefs, $path_to_root;
    start_form_section('row page-head');
    start_form_section('col-md-7 col-sm-8 col-xs-6 page-title');
   // page_header_title(_("Add New Driver"));
    end_form_section();
   
    end_form_section();
    if (!$driver_id) 
    {
        if (list_updated('driver_id') || !isset($_POST['name'])) {
            $_POST['name'] = $_POST['driver_ref'] = $_POST['address'] =$_POST['licence_no']  = $_POST['rate']  = '';
            $_POST['curr_code']  = get_company_currency();
            $_POST['credit_status']  = -1;
            $_POST['payment_terms']  = $_POST['notes']  = '';
            $_POST['mobile_no']  = '';
            
        }
    }
    else 
    {
        $myrow = get_driver($driver_id);

        $_POST['name'] = $myrow["name"];
        $_POST['driver_ref'] = $myrow["driver_ref"];
        $_POST['address']  = $myrow["address"];
        $_POST['curr_code']  = $myrow["curr_code"];
        $_POST['licence_no']  = $myrow["licence_no"];
        $_POST['mobile_no']  = $myrow["mobile_no"];
        
        $_POST['notes']  = $myrow["notes"];
        
        $_POST['inactive'] = $myrow["inactive"];
        hidden('driver_id',$driver_id);
    }

    
    text_row(_("Driver Name:"), 'name', $_POST['name'], 40, 80);
    text_row(_("Driver Short Name:"), 'driver_ref', null, 30, 30);
    text_row(_("Driver Mobile No:"), 'mobile_no', null, 30, 30);
    textarea_row(_("Address:"), 'address', $_POST['address'], 35, 5);

    text_row(_("Licence no:"), 'licence_no', null, 40, 40);
    /*small_amount_row(_("Salary:"), 'rate', null, 40, null);
    date_row(_("Driver Birth Date:"), 'driver_birth_date', null, 40, 40);
    date_row(_("Driver Hire Date:"), 'hired_on', null, 40, 40);

    if (!$selected_id) 
    {
        currencies_list_row(_("Payment Currency:"), 'curr_code', $_POST['curr_code']);
    } 
    else 
    {
        label_row(_("Payment Currency:"), $_POST['curr_code']);
        hidden('curr_code', $_POST['curr_code']);               
    }
    */
    if($selected_id)
        record_status_list_row(_("Driver status:"), 'inactive');
    /*payment_terms_list_row(_("Payment Terms:"), 'payment_terms', $_POST['payment_terms']);
text_row(_("Health Exam Ref:"), 'health_exam_ref', null, 40, 40);
date_row(_("Checkup Date:"), 'date_of_checkup', null, 40, 40);*/
    textarea_row(_("General Notes:"), 'notes', null, 35, 5);
    
    
}

//--------------------------------------------------------------------------------------------

 
start_form();



  driver_settings($driver_id); 

 start_form_section('text-center','controls');
    div_start('controls');
  
         if (!$driver_id)
         {
        submit_center('submit', _("Add New Driver"), true, '', 'default');
         } 
         else 
         {
        submit_center_first('submit', _("Update Driver"), 
          _('Update driver data'), @$_REQUEST['popup'] ? true : 'default');
        submit_return('select', $selected_id, _("Select this driver and return to document entry."));
        submit_center_last('delete', _("Delete Driver"), 
          _('Delete driver data if have been never used'), true);
        }
    
   
    end_form_section();
hidden('popup', @$_REQUEST['popup']);
end_form();
end_page(@$_REQUEST['popup']);

?>

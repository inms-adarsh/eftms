<?php
/**********************************************************************
    Copyright (C) Frontload_statusing, LLC.
    Released under the terms of the GNU General Public License, GPL, 
    as published by the Free Software Foundation, either version 3 
    of the License, or (at your option) any later version.
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  
    See the License here <http://www.gnu.org/licenses/gpl-3.0.html>.
***********************************************************************/
$page_security = 'SA_LOADGROUP';
$path_to_root = "../..";

include_once($path_to_root . "/includes/session.inc");
include_once($path_to_root . "/includes/date_functions.inc");
include_once($path_to_root . "/includes/banking.inc");
include_once($path_to_root . "/includes/ui.inc");
include_once($path_to_root . "/transport/includes/transport_db.inc");
include_once($path_to_root . "/includes/ui/contacts_view.inc");
page(_($help_context = "Load Status Group"));


simple_page_mode(false);
 
include_once($path_to_root . "/includes/data_checks.inc");

check_db_has_load_status_groups(_("There are no Load status groups defined. Please define at least one load status group before entering load status."));

//-------------------------------------------------------------------------------------

$new_item =  $_GET['load_status_code'] == '' || get_post('cancel') || get_post('clone'); 
//------------------------------------------------------------------------------------

if (isset($_GET['load_status_code']))
{
    $_POST['load_status_code'] = $selected_load_status = $_GET['load_status_code'];
    $Ajax->activate('details');
    $Ajax->activate('controls');
}
if (get_post('cancel')) {
    $_POST['load_status_code'] = $selected_load_status = $_POST['load_status_code'] = '';
    $Ajax->activate('_page_body');
}



if (isset($_GET['load_status_code']))
{
    $selected_load_status = $_GET['load_status_code'];
}
else
    $selected_load_status = "";
//-------------------------------------------------------------------------------------

if (isset($_POST['add']) || isset($_POST['update'])) 
{

    $input_error = 0;

    if (strlen(trim($_POST['load_status_name'])) == 0) 
    {
        $input_error = 1;
        display_error( _("The load status name cannot be empty."));
        set_focus('load_status_name');
    } 
    
    if ($input_error != 1)
    {
        
        if ($_POST['load_status_code']) 
        {
            if (update_load_status($_POST['load_status_code'], $_POST['load_status_name'], 
                $_POST['load_status_type'])) {
                    $Ajax->activate('load_status_code'); // in case of status change
                //display_notification(_("load status data has been updated."));
                meta_forward($path_to_root .'/transport/manage/load_status.php','updated=Y');
            }
        }
        else 
        {
            if (add_load_status($_POST['load_status_name'], 
                $_POST['load_status_type']))
                {
                    //display_notification(_("New load status has been added."));
                    meta_forward($path_to_root .'/transport/manage/load_status.php','updated=N');
                }
            else
                 display_error(_("load status not added"));
        }
        $Ajax->activate('_page_body');
    }
} 

//-------------------------------------------------------------------------------------

function can_delete($selected_load_status)
{
    if ($selected_load_status == "")
        return false;
    return true;
}

//--------------------------------------------------------------------------------------

if (isset($_POST['delete'])) 
{

    if (can_delete($_POST['selected_load_status']))
    {
        delete_load_status($_POST['selected_load_status']);
        $selected_load_status = $_POST['LoadStatusList'] = '';
        meta_forward($path_to_root .'/transport/manage/load_status.php','deleted=Y');
        unset($_POST['load_status_code']);
        $Ajax->activate('_page_body');
    }
} 

//-------------------------------------------------------------------------------------

start_form();
start_table(TABLESTYLE2);

if ($selected_load_status != "") 
{
    //editing an existing load_status
    $myrow = get_load_status($selected_load_status);

    $_POST['load_status_code'] = $myrow["load_status_code"];
    $_POST['load_status_name']  = $myrow["load_status_name"];
    $_POST['load_status_type'] = $myrow["load_status_type"];
    $_POST['inactive'] = $myrow["inactive"];
    
    
    hidden('load_status_code', $_POST['load_status_code']);
    hidden('selected_load_status', $selected_load_status);
        
   // label_row(_("load_status Code:"), $_POST['load_status_code']);
} 
else
{
    if (!isset($_POST['load_status_code'])) {
        $_POST['load_status_tags'] = array();
        $_POST['load_status_name']  = $_POST['load_status_type'] = '';
        $_POST['inactive'] = 0;
    }
}

text_row_ex(_("Load Status Name:"), 'load_status_name', 60);

load_status_types_list_row(_("Load Status Group:"), 'load_status_type', null);

record_status_list_row(_("Record status:"), 'inactive');
end_table(1);
 start_form_section('text-center','controls');
       
        if ($selected_load_status == "") 
        {
            submit_center('add', _("Add Load Status"), true, '', 'default');
        } 
        else 
        {
            submit_center_first('update', _("Update load_status"), '', 'default');
            submit_center_last('delete', _("Delete load_status"), '',true);
        }
    end_form_section();
end_form();

end_page();

?>

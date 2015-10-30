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
$page_security = 'SA_LOCATION';
$path_to_root = "../..";
include($path_to_root . "/includes/db_pager.inc");
include_once($path_to_root . "/includes/session.inc");
$js = "";
if ($use_popup_windows)
    $js .= get_js_open_window(900, 500);
if ($use_date_picker)
    $js .= get_js_date_picker();
    
page(_($help_context = "locations"), @$_REQUEST['popup'], false, "", $js);

include_once($path_to_root . "/includes/date_functions.inc");
include_once($path_to_root . "/includes/ui.inc");
include_once($path_to_root . "/includes/data_checks.inc");

include_once($path_to_root . "/transport/includes/transport_db.inc");

$user_comp = user_company();
$new_item =  $_GET['location_id'] == '' || get_post('cancel') || get_post('clone'); 
//------------------------------------------------------------------------------------

if (isset($_GET['location_id']))
{
    $_POST['location_id'] = $location_id = $_GET['location_id'];
    clear_data();
    $Ajax->activate('details');
    $Ajax->activate('controls');
}
if (get_post('cancel')) {
    $_POST['location_id'] = $location_id = $_POST['location_id'] = '';
    clear_data();
    set_focus('location_name');
    $Ajax->activate('_page_body');
}

function clear_data()
{
    unset($_POST['long_description']);
    unset($_POST['description']);
    unset($_POST['category_id']);
    unset($_POST['tax_type_id']);
    unset($_POST['units']);
    unset($_POST['mb_flag']);
    unset($_POST['NewStockID']);
    unset($_POST['dimension_id']);
    unset($_POST['dimension2_id']);
    unset($_POST['no_sale']);
}

//------------------------------------------------------------------------------------

if (isset($_POST['addupdate'])) 
{
    
    $input_error = 0;
        /* actions to take once the user has clicked the submit button
    ie the page has called itself with some user input */

    //first off validate inputs sensible
if (strlen($_POST['location_name']) == 0) 
    {
        $input_error = 1;
        display_error( _("The location name must be entered."));        
        set_focus('location_name');
    }

    if ($input_error != 1) 
    {
     if ($_POST['location_id']) 
        {
            update_item_location($_POST['location_id'], $_POST['location_name'], $_POST['delivery_address'],
                $_POST['phone'], $_POST['phone2'], $_POST['fax'], $_POST['email'], $_POST['contact']);  
              meta_forward($path_to_root .'/transport/manage/locations.php','updated=Y');
        } 
        else 
        {
    
        /*selected_id is null cos no item selected on first time round so must be adding a  record must be submitting new entries in the new Location form */
        
            add_item_location($_POST['location_name'], $_POST['delivery_address'], 
                $_POST['phone'], $_POST['phone2'], $_POST['fax'], $_POST['email'], $_POST['contact']);
                  meta_forward($path_to_root .'/transport/manage/locations.php','updated=N');
        }
        $Ajax->activate('_page_body');
     //   $Mode = 'RESET';
    }
}

if (get_post('clone')) {
    unset($_POST['location_id']);
    $stock_id = '';
    unset($_POST['inactive']);
    set_focus('location_name');
    $Ajax->activate('_page_body');
}


function location_settings(&$location_id) 
{
    global $SysPrefs, $path_to_root, $new_item, $pic_height;
  
    //------------------------------------------------------------------------------------
    if ($new_item) 
    {
        $_POST['loc_code'] = '';
        $_POST['location_name']  = '';
        $_POST['delivery_address'] = '';
        $_POST['contact'] = '';
        $_POST['phone'] = '';
        $_POST['phone2'] = '';
        $_POST['fax'] = '';
        $_POST['email'] = '';
   }
    else 
    { // Must be modifying an existing item
         $myrow = get_item_location($_POST['location_id']);
        $_POST['location_id'] = $myrow["loc_code"];
        $_POST['location_name']  = $myrow["location_name"];
        $_POST['delivery_address'] = $myrow["delivery_address"];
        $_POST['contact'] = $myrow["contact"];
        $_POST['phone'] = $myrow["phone"];
        $_POST['phone2'] = $myrow["phone2"];
        $_POST['fax'] = $myrow["fax"];
        $_POST['email'] = $myrow["email"];
     
        hidden("location_id",$location_id);
    }
start_table(TABLESTYLE2);
 
text_row_ex(_("Location Name:"), 'location_name', 50, 50,null,null,null,null,'locality');
text_row_ex(_("Contact for deliveries:"), 'contact', 30, 30);

textarea_row(_("Address:"), 'delivery_address', null, 35, 5,null,null,'address');   

text_row_ex(_("Telephone No:"), 'phone', 32, 30);
text_row_ex(_("Secondary Phone Number:"), 'phone2', 32, 30);
text_row_ex(_("Facsimile No:"), 'fax', 32, 30);
email_row_ex(_("E-mail:"), 'email', 30);
end_table();
}

//-------------------------------------------------------------------------------------------- 

start_form(true);

div_start('details');

$location_id = $_GET['location_id'];
location_settings($location_id); 

div_end();

    start_form_section('text-center','controls');

        if ($new_item) 
        {
        submit_center('addupdate', _("Insert New Location"), true, '', 'default');
        } 
        else 
        {
        submit_center_first('addupdate', _("Update Location"), '', 
            @$_REQUEST['popup'] ? true : 'default');
        submit_return('select', get_post('location_id'), 
            _("Select this items and return to document entry."), 'default');
        submit('clone', _("Clone This Location"), true, '', true);
        submit('delete', _("Delete This Location"), true, '', true);
        submit_center_last('cancel', _("Cancel"), _("Cancel Edition"), 'cancel');
        }
    end_form_section();

hidden('popup', @$_REQUEST['popup']);
end_form();

//------------------------------------------------------------------------------------

end_page(@$_REQUEST['popup']);
?>

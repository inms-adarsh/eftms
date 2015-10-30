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
include($path_to_root . "/includes/db_pager.inc");
include_once($path_to_root . "/includes/session.inc");
include_once($path_to_root . "/includes/date_functions.inc");
include_once($path_to_root . "/includes/banking.inc");
include_once($path_to_root . "/includes/ui.inc");
include_once($path_to_root . "/transport/includes/transport_db.inc");


add_access_extensions();
$js = "";
if ($use_popup_windows)
	$js .= get_js_open_window(900, 500);
if ($use_date_picker)
	$js .= get_js_date_picker();
	
page(_($help_context = "Drivers"), @$_REQUEST['popup'], false, "", $js); 

if (isset($_GET['updated'])) {
        if($_GET['updated'] == 'N')
        {
             display_notification(_('New Driver has been added'));
        }
        else {
            display_notification(_('Selected Driver has been updated'));
        }
}


if (isset($_GET['deleted'])) {
        if($_GET['deleted'] == 'Y')
        {
             display_notification(_('Driver has been deleted'));
        }
}
if (isset($_GET['driver_no'])) 
{
	$_POST['driver_id'] = $_GET['driver_no'];
}

$selected_id = get_post('driver_id','');
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
		
	if ($selected_id) 
	{
		update_driver($_POST['driver_id'],$_POST['name'],$_POST['licence_no'],$_POST['mobile_no'],
		$_POST['driver_ref'],$_POST['address'],
		$_POST['notes']);

		update_record_status($_POST['driver_id'], $_POST['inactive'],
			'drivers_master', 'driver_no');

		$Ajax->activate('driver_id'); // in case of status change
		display_notification(_("Driver has been updated."));
	} 
	else 
	{ 	//it is a new driver

		begin_transaction();
		add_driver($_POST['name'],
		$_POST['licence_no'],$_POST['mobile_no'],
		 $_POST['driver_ref'],$_POST['address'],
		 $_POST['notes']);

		$selected_id = $_POST['driver_id'] = db_insert_id();
         
		commit_transaction();

		display_notification(_("A new driver has been added."));

		
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

	if (key_in_foreign_table($selected_id, 'driver_trans', 'driver_no'))
	{
		$cancel_delete = 1;
		display_error(_("This driver cannot be deleted because there are transactions that refer to it."));
	} 
	else 
	{
		if (key_in_foreign_table($selected_id, 'transport_orders', 'driver_no'))
		{
			$cancel_delete = 1;
			display_error(_("Cannot delete the driver record because orders have been created against it."));
		} 
		else 
		{
			if (key_in_foreign_table($selected_id, 'consignor_branch', 'driver_no'))
			{
				$cancel_delete = 1;
				display_error(_("Cannot delete this driver because there are branch records set up against it."));
				//echo "<br> There are " . $myrow[0] . " branch records relating to this driver";
			}
		}
	}
	
	if ($cancel_delete == 0) 
	{ 	//ie not cancelled the delete as a result of above tests
	
		delete_driver($selected_id);

		display_notification(_("Selected driver has been deleted."));
		unset($_POST['driver_id']);
		$selected_id = '';
		$Ajax->activate('_page_body');
	} //end if Delete Driver
}


function edit_link($row) 
{
    if (@$_GET['popup'])
        return '';
    return pager_link( _("Edit"),
    "/transport/manage/new_driver.php?driver_no=" . $row['driver_no'], ICON_EDIT);
}


//--------------------------------------------------------------------------------------------

 
start_form();

	 start_form_section('row page-head');
   
    start_form_section('text-right col-md-5 col-sm-4 col-xs-6 actions');
        anchor_button(_("Add new Driver"),$path_to_root .'/transport/manage/new_driver.php?NewDriver=Yes','btn btn-primary');
    end_form_section();
    end_form_section();
    $sql = get_all_drivers($_POST['show_inactive']);
    $cols = array(
        _("Name #"),
        _("Mobile") ,
        _("Address"),
        _("Licence")
        
    );
    array_append($cols, array(
    array('insert'=>true, 'fun'=>'edit_link')));
    check_cells(_("Show inactive:"), 'show_inactive', null, true);
    if (get_post('_show_inactive_update')) {
        $Ajax->activate('driver_id');
        set_focus('driver_id');
    }

$table =& new_db_pager('drivers_tbl', $sql, $cols,null,null,20);
$table->width = "80%";

display_db_pager($table,'drivers_tbl');


hidden('popup', @$_REQUEST['popup']);
end_form();
end_page(@$_REQUEST['popup']);

?>

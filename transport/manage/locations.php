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
include($path_to_root . "/includes/session.inc");

$js = "";
if ($use_popup_windows)
	$js .= get_js_open_window(900, 500);
if ($use_date_picker)
	$js .= get_js_date_picker();
	
page(_($help_context = "Locations"), @$_REQUEST['popup'], false, "", $js);

include_once($path_to_root . "/includes/ui.inc");

include_once($path_to_root . "/transport/includes/transport_db.inc");


simple_page_mode(true);

if (isset($_GET['updated'])) {
		if($_GET['updated'] == 'N')
		{
			 display_notification(_('New location has been added'));
		}
		else {
			display_notification(_('Selected location has been updated'));
		}
}
if (isset($_GET['deletedItemFailed'])) {
	if($_SESSION['deletedItemFailed'] != $_GET['deletedItemFailed'])
	{
		$_SESSION['deletedItemFailed'] = $_GET['deletedItemFailed'];
	}
	else
	{
		$currUrl = strtok($_SERVER['PHP_SELF'] , '?');
		$_SESSION['deletedItemFailed'] = '';
		header("Location: $currUrl");
	}
	//header("Location: $currUrl");
 }
if(isset($_GET['deletedLoc']))
{
	if($_SESSION['deletedLoc'] != $_GET['deletedLoc'])
	{
		$_SESSION['deletedLoc'] = $_GET['deletedLoc'];
	}
	else
	{
		$currUrl = strtok($_SERVER['PHP_SELF'] , '?');
		$_SESSION['deletedLoc'] = '';
		header("Location: $currUrl");
	}
}
if($_SESSION['deletedItemFailed'])
{
	display_error(_("Cannot delete this location because it is used by some related records in other tables."));
}

if($_SESSION['deletedLoc'])
{
	display_notification(_('Selected location has been deleted'));
}
function edit_link($row) {
	return button("Edit".$row["branch_code"],_("Edit"), '', ICON_EDIT);
}

function del_link($row) {
	return button("Delete".$row["branch_code"],_("Delete"), '', ICON_DELETE);
}

function select_link($row) {
	return button("Select".$row["branch_code"], $row["branch_code"], '', ICON_ADD, 'selector');
}
if ($Mode=='ADD_ITEM' || $Mode=='UPDATE_ITEM') 
{

	//initialise no input errors assumed initially before we test
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
    	if ($selected_id != -1) 
    	{
    
    		update_item_location($selected_id, $_POST['location_name'], $_POST['delivery_address'],
    			$_POST['phone'], $_POST['phone2'], $_POST['fax'], $_POST['email'], $_POST['contact']);	
			display_notification(_('Selected location has been updated'));
    	} 
    	else 
    	{
    
    	/*selected_id is null cos no item selected on first time round so must be adding a	record must be submitting new entries in the new Location form */
    	
    		add_item_location($_POST['location_name'], $_POST['delivery_address'], 
    		 	$_POST['phone'], $_POST['phone2'], $_POST['fax'], $_POST['email'], $_POST['contact']);
			display_notification(_('New location has been added'));
    	}
		
		$Mode = 'RESET';
	}
} 

function can_delete($selected_id)
{
	if (key_in_foreign_table($selected_id, 'stock_moves', 'loc_code'))
	{
		$errorDelete = "Cannot delete this location because item movements have been created using this location.";
		return false;
	}

	if (key_in_foreign_table($selected_id, 'workorders', 'loc_code'))
	{
		$errorDelete = "Cannot delete this location because it is used by some work orders records.";
		return false;
	}

	if (key_in_foreign_table($selected_id, 'consignor_branch', 'default_location'))
	{
		$errorDelete = "Cannot delete this location because it is used by some branch records as the default location to deliver from.";
		return false;
	}
	
	if (key_in_foreign_table($selected_id, 'bom', 'loc_code'))
	{
		$errorDelete = "Cannot delete this location because it is used by some related records in other tables.";
		return false;
	}
	
	if (key_in_foreign_table($selected_id, 'grn_batch', 'loc_code'))
	{
		$errorDelete = "Cannot delete this location because it is used by some related records in other tables.";
		return false;
	}
	if (key_in_foreign_table($selected_id, 'purch_orders', 'into_stock_location'))
	{
		$errorDelete = "Cannot delete this location because it is used by some related records in other tables.";
		return false;
	}
	if (key_in_foreign_table($selected_id, 'transport_orders', 'from_stk_loc'))
	{
		$errorDelete = "Cannot delete this location because it is used by some related records in other tables.";
		return false;
	}
	if (key_in_foreign_table($selected_id, 'transport_pos', 'pos_location'))
	{
		$errorDelete = "Cannot delete this location because it is used by some related records in other tables.";
		return false;
	}
	return true;
}

//----------------------------------------------------------------------------------

if ($Mode == 'Delete')
{

	if (can_delete($selected_id)) 
	{
		delete_item_location($selected_id);
			$_SESSION['deletedLoc'] = '';
		meta_forward($_SERVER['PHP_SELF'], "deletedLoc=$selected_id");
	} //end if Delete Location
	else {
		$_SESSION['deletedItemFailed'] = '';
		meta_forward($_SERVER['PHP_SELF'], "deletedItemFailed=$selected_id");
	}
}


if ($Mode == 'Edit')
{
	meta_forward($path_to_root .'/transport/manage/new_location.php','location_id=' . $selected_id);
}
if ($Mode == 'RESET')
{
	$selected_id = -1;
	$sav = get_post('show_inactive');
	unset($_POST);
	$_POST['show_inactive'] = $sav;
}

function grid_settings() {

 start_display_table('table datatable table-striped table-bordered','loc');
 $th = array(_("Location Name"), _("Address"), _("Phone"), _("Secondary Phone"), "", "");
 display_table_header($th);
 $k = 0; //row colour counter

 $result = get_item_locations(check_value('show_inactive'));

	while ($myrow = db_fetch($result)) 
	{

		alt_table_row_color($k);
		label_cell($myrow["location_name"]);
		label_cell($myrow["delivery_address"]);
		label_cell($myrow["phone"]);
		label_cell($myrow["phone2"]);
		inactive_control_cell($myrow["loc_code"], $myrow["inactive"], 'locations', 'loc_code');
	 	edit_button_cell("Edit".$myrow["loc_code"], _("Edit"));
	 	delete_button_cell("Delete".$myrow["loc_code"], _("Delete"));
		end_row();
	}

end_display_table();
}
start_form();
 start_form_section('row page-head');
 
    start_form_section('text-right col-md-5 col-sm-4 col-xs-6 actions');
        anchor_button(_("Add new Location"),$path_to_root .'/transport/manage/new_location.php?NewLocation=Yes','btn btn-primary');
    end_form_section();
    end_form_section();
inactive_control_column($th);

grid_settings();
end_form();

end_page();

?>

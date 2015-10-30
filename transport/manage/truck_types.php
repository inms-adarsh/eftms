<?php
/**********************************************************************
    Copyright (C) Fronttruck_typeing, LLC.
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
page(_($help_context = "Truck Type Group"));


simple_page_mode(false);
 
include_once($path_to_root . "/includes/data_checks.inc");

check_db_has_truck_type_groups(_("There are no Truck Type groups defined. Please define at least one Truck Type group before entering Truck Type."));

//-------------------------------------------------------------------------------------

if (isset($_POST['_TruckTypeList_update'])) 
{
	$_POST['selected_truck_type'] = $_POST['TruckTypeList'];
	unset($_POST['truck_type_code']);
}

if (isset($_POST['selected_truck_type']))
{
	$selected_truck_type = $_POST['selected_truck_type'];
} 
elseif (isset($_GET['selected_truck_type']))
{
	$selected_truck_type = $_GET['selected_truck_type'];
}
else
	$selected_truck_type = "";
//-------------------------------------------------------------------------------------

if (isset($_POST['add']) || isset($_POST['update'])) 
{

	$input_error = 0;

	if (strlen(trim($_POST['truck_type_name'])) == 0) 
	{
		$input_error = 1;
		display_error( _("The truck_type name cannot be empty."));
		set_focus('truck_type_name');
	} 
	
	if ($input_error != 1)
	{
		
    	if ($selected_truck_type) 
		{
			if (update_truck_type($_POST['truck_type_code'], $_POST['truck_type_name'], 
				$_POST['truck_group_type'])) {
					$Ajax->activate('truck_type_code'); // in case of status change
				display_notification(_("Truck Type data has been updated."));
			}
		}
    	else 
		{
    		if (add_truck_type($_POST['truck_type_name'], 
				$_POST['truck_group_type']))
				{
					display_notification(_("New truck type has been added."));
				}
			else
                 display_error(_("Truck Type not added"));
		}
		$Ajax->activate('_page_body');
	}
} 

//-------------------------------------------------------------------------------------

function can_delete($selected_truck_type)
{
	if ($selected_truck_type == "")
		return false;
	return true;
}

//--------------------------------------------------------------------------------------

if (isset($_POST['delete'])) 
{

	if (can_delete($selected_truck_type))
	{
		delete_truck_type($selected_truck_type);
		$selected_truck_type = $_POST['TruckTypeList'] = '';
		display_notification(_("Selected truck_type has been deleted"));
		unset($_POST['truck_type_code']);
		$Ajax->activate('_page_body');
	}
} 

//-------------------------------------------------------------------------------------

start_form();

if (db_has_truck_type()) 
{
	start_table(TABLESTYLE_NOBORDER);
	start_row();
    all_truck_type_list_cells(null, 'TruckTypeList', null, false, 
		_('New Truck Type'), true, check_value('show_inactive'));
	check_cells(_("Show inactive:"), 'show_inactive', null, true);
	end_row();
	end_table();
	if (get_post('_show_inactive_update')) {
		$Ajax->activate('TruckTypeList');
		set_focus('TruckTypeList');
	}
}
	
br(1);
start_table(TABLESTYLE2);

if ($selected_truck_type != "") 
{
	//editing an existing truck_type
	$myrow = get_truck_type($selected_truck_type);

	$_POST['truck_type_code'] = $myrow["truck_type_code"];
	$_POST['truck_type_name']	= $myrow["truck_type_name"];
	$_POST['truck_group_type'] = $myrow["truck_group_type"];
 	$_POST['inactive'] = $myrow["inactive"];
 	
 	
	hidden('truck_type_code', $_POST['truck_type_code']);
	hidden('selected_truck_type', $selected_truck_type);
		
	label_row(_("truck_type Code:"), $_POST['truck_type_code']);
} 
else
{
	if (!isset($_POST['truck_type_code'])) {
		$_POST['truck_type_tags'] = array();
		$_POST['truck_type_name']	= $_POST['truck_group_type'] = '';
 		$_POST['inactive'] = 0;
	}
}

text_row_ex(_("Truck Type Name:"), 'truck_type_name', 60);

truck_group_types_list_row(_("Truck Type Group:"), 'truck_group_type', null);

record_status_list_row(_("Record status:"), 'inactive');
end_table(1);

if ($selected_truck_type == "") 
{
	submit_center('add', _("Add Truck Type"), true, '', 'default');
} 
else 
{
    submit_center_first('update', _("Update truck_type"), '', 'default');
    submit_center_last('delete', _("Delete truck_type"), '',true);
}
end_form();

end_page();

?>

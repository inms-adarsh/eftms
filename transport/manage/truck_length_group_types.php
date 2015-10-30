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
$page_security = 'SA_LOADGROUP';
$path_to_root = "../..";

include_once($path_to_root . "/includes/session.inc");
include_once($path_to_root . "/includes/date_functions.inc");
include_once($path_to_root . "/includes/banking.inc");
include_once($path_to_root . "/includes/ui.inc");
include_once($path_to_root . "/transport/includes/transport_db.inc");
include_once($path_to_root . "/includes/ui/contacts_view.inc");
page(_($help_context = "Truck Length Groups"));


simple_page_mode(false);
 
//-----------------------------------------------------------------------------------

function can_process($selected_id) 
{
	if (strlen(trim($_POST['id'])) == 0) 
	{
	    display_error( _("The truck length group id cannot be empty."));
	    set_focus('id');
	    return false;
	}
	if (strlen(trim($_POST['name'])) == 0) 
	{
		display_error( _("The truck length group name cannot be empty."));
		set_focus('name');
		return false;
	}
	$type = get_truck_length_group_type(trim($_POST['id']));
	if ($type && ($type['id'] != $selected_id)) 
	{
		display_error( _("This truck length group id is already in use."));
		set_focus('id');
		return false;
	}

	
	return true;
}

//-----------------------------------------------------------------------------------

if ($Mode=='ADD_ITEM' || $Mode=='UPDATE_ITEM') 
{

	if (can_process($selected_id)) 
	{

    	if ($selected_id != "") 
    	{
    		if (update_truck_length_group_type($_POST['id'], $_POST['name'], $_POST['old_id']))
				display_notification(_('Selected truck length group has been updated'));
    	} 
    	else 
    	{
    		if (add_truck_length_group_type($_POST['id'], $_POST['name'])) {
				display_notification(_('New truck length group has been added'));
			}
    	}
		$Mode = 'RESET';
	}
}

//-----------------------------------------------------------------------------------

function can_delete($type)
{
	if ($type == "")
		return false;

	if (key_in_foreign_table($type, 'truck_length_group', 'truck_length_group_type'))
	{
		display_error(_("Cannot delete this truck length group because GL accounts have been created referring to it."));
		return false;
	}

	return true;
}


//-----------------------------------------------------------------------------------

if ($Mode == 'Delete')
{

	if (can_delete($selected_id))
	{
		delete_truck_length_group_type($selected_id);
		display_notification(_('Selected truck length group has been deleted'));
	}
	$Mode = 'RESET';
}
if ($Mode == 'RESET')
{
 	$selected_id = "";
	$_POST['id']  = $_POST['name']  = '';
	unset($_POST['parent']);
	unset($_POST['class_id']);
}
//-----------------------------------------------------------------------------------

$result = get_truck_length_group_types(check_value('show_inactive'));

start_form();
start_table(TABLESTYLE);
$th = array(_("Group ID"), _("Group Name"));
inactive_control_column($th);
table_header($th);

$k = 0;
while ($myrow = db_fetch($result)) 
{

	alt_table_row_color($k);

	

	label_cell($myrow["id"]);
	label_cell($myrow["name"]);
	inactive_control_cell($myrow["id"], $myrow["inactive"], 'truck_length_group_types', 'id');
	edit_button_cell("Edit".$myrow["id"], _("Edit"));
	delete_button_cell("Delete".$myrow["id"], _("Delete"));
	end_row();
}

inactive_control_row($th);
end_table(1);
//-----------------------------------------------------------------------------------

start_table(TABLESTYLE2);

if ($selected_id != "")
{
	if ($Mode == 'Edit') 
	{
		//editing an existing status code
		$myrow = get_truck_length_group_type($selected_id);
	
		$_POST['id']  = $myrow["id"];
		$_POST['name']  = $myrow["name"];
		hidden('selected_id', $selected_id);
		hidden('old_id', $myrow["id"]);
 	}
 	else
 	{
		hidden('selected_id', $selected_id);
		hidden('old_id', $_POST["old_id"]);
	}	
}
text_row_ex(_("ID:"), 'id', 10);
text_row_ex(_("Name:"), 'name', 50);

end_table(1);

submit_add_or_update_center($selected_id == "", '', 'both');

end_form();

//------------------------------------------------------------------------------------

end_page();

?>

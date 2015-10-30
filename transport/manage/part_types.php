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
$page_security = 'SA_VEHICLE_PART';
$path_to_root = "../..";

include_once($path_to_root . "/includes/session.inc");
include_once($path_to_root . "/includes/date_functions.inc");
include_once($path_to_root . "/includes/banking.inc");
include_once($path_to_root . "/includes/ui.inc");
include_once($path_to_root . "/transport/includes/transport_db.inc");
include_once($path_to_root . "/includes/ui/contacts_view.inc");

add_access_extensions();

simple_page_mode(true);
page(_($help_context = "Part Types"));


if ($Mode=='ADD_ITEM' || $Mode=='UPDATE_ITEM') 
{

	$input_error = 0;

	if (strlen($_POST['part_description']) == 0) 
	{
		$input_error = 1;
		display_error(_("The part_type description cannot be empty."));
		set_focus('description');
	}

	if ($input_error != 1)
	{
    	if ($selected_id != -1) 
    	{
    		update_part_type($selected_id, $_POST['part_description']);
			$note = _('Selected transport part_type has been updated');
    	} 
    	else 
    	{
    		add_part_type($_POST['part_description']);
			$note = _('New transport part_type has been added');
    	}
    
		display_notification($note);    	
		$Mode = 'RESET';
	}
} 

if ($Mode == 'Delete')
{

	$cancel_delete = 0;

	// PREVENT DELETES IF DEPENDENT RECORDS IN 'consignors_master'

	if (key_in_foreign_table($selected_id, 'consignor_branch', 'part_type'))
	{
		$cancel_delete = 1;
		display_error(_("Cannot delete this part_type because consignor branches have been created using this part_type."));
	} 
	if ($cancel_delete == 0) 
	{
		delete_part_type($selected_id);

		display_notification(_('Selected transport part_type has been deleted'));
	} //end if Delete part_type
	$Mode = 'RESET';
} 

if ($Mode == 'RESET')
{
	$selected_id = -1;
	$sav = get_post('show_inactive');
	unset($_POST);
	$_POST['show_inactive'] = $sav;
}

//-------------------------------------------------------------------------------------------------

$result = get_part_types(check_value('show_inactive'));

start_form();
start_table(TABLESTYLE, "width=30%");

$th = array(_("Part Type Name"), "", "");


table_header($th);
$k = 0; 

while ($myrow = db_fetch($result)) 
{
	
	alt_table_row_color($k);
		
	label_cell($myrow["part_description"]);
	
	inactive_control_cell($myrow["part_type_code"], $myrow["inactive"], 'part_types', 'part_type_code');

 	edit_button_cell("Edit".$myrow["part_type_code"], _("Edit"));
 	delete_button_cell("Delete".$myrow["part_type_code"], _("Delete"));
	end_row();
}
	
//inactive_control_row($th);
end_table();
echo '<br>';

//-------------------------------------------------------------------------------------------------

start_table(TABLESTYLE2);

if ($selected_id != -1) 
{
 	if ($Mode == 'Edit') {
		//editing an existing part_type
		$myrow = get_part_type($selected_id);

		$_POST['part_description']  = $myrow["part_description"];
	}
	hidden("selected_id", $selected_id);
} 

text_row_ex(_("Part Type Name:"), 'part_description', 30); 

end_table(1);

submit_add_or_update_center($selected_id == -1, '', 'both');

end_form();

end_page();
?>

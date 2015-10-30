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

include_once($path_to_root . "/includes/session.inc");
include_once($path_to_root . "/includes/date_functions.inc");
include_once($path_to_root . "/includes/banking.inc");
include_once($path_to_root . "/includes/ui.inc");
include_once($path_to_root . "/transport/includes/transport_db.inc");
include_once($path_to_root . "/includes/ui/contacts_view.inc");

add_access_extensions();

simple_page_mode(true);
page(_($help_context = "Parts"));

//------------------------------------------------------------------------------------------------

if ($Mode=='ADD_ITEM' || $Mode=='UPDATE_ITEM') 
{

	//initialise no input errors assumed initially before we test
	$input_error = 0;

	if (strlen($_POST['part_name']) == 0)
	{
		$input_error = 1;
		display_error(_("The transport person name cannot be empty."));
		set_focus('part_name');
	}
	
	if ($input_error != 1)
	{
    	if ($selected_id != -1) 
    	{
    		/*selected_id could also exist if submit had not been clicked this code would not run in this case cos submit is false of course  see the delete code below*/
			update_part($selected_id,$_POST['part_name'], $_POST['part_type_desc'], $_POST['vendor_ref'],
	$_POST['part_no'], $_POST['part_price'], $_POST['part_price_date'], $_POST['part_manufacturer']);
    	}
    	else
    	{
    		/*Selected group is null cos no item selected on first time round so must be adding a record must be submitting new entries in the new Sales-person form */
			add_part($_POST['part_name'], $_POST['part_type_desc'], $_POST['vendor_ref'],
	$_POST['part_no'], $_POST['part_price'], $_POST['part_price_date'], $_POST['part_manufacturer']);
    	}

    	if ($selected_id != -1) 
			display_notification(_('Selected transport person data have been updated'));
		else
			display_notification(_('New transport person data have been added'));
		$Mode = 'RESET';
	}
}
if ($Mode == 'Delete')
{
	//the link to delete a selected record was clicked instead of the submit button

	// PREVENT DELETES IF DEPENDENT RECORDS IN 'consignors_master'

	if (key_in_foreign_table($selected_id, 'consignor_branch', 'part'))
	{
		display_error(_("Cannot delete this transport-person because branches are set up referring to this transport-person - first alter the branches concerned."));
	}
	else
	{
		delete_part($selected_id);
		display_notification(_('Selected transport person data have been deleted'));
	}
	$Mode = 'RESET';
}

if ($Mode == 'RESET')
{
	$selected_id = -1;
	$sav = get_post('show_inactive');
	unset($_POST);
	$_POST['show_inactive'] = $sav;
}
//------------------------------------------------------------------------------------------------

$result = get_parts(check_value('show_inactive'));

start_form();
start_table(TABLESTYLE, "width=60%");
$th = array(_("Name"), _("Part Type"), _("Part Description"), _("Price"), _("Update on"), _("Vendor"), _("Manufacturers"), "", "");
inactive_control_column($th);
table_header($th);

$k = 0;

while ($myrow = db_fetch($result))
{

	alt_table_row_color($k);

    label_cell($myrow["part_name"]);
		label_cell($myrow["part_type_desc"]);
   	label_cell($myrow["part_no"]);
	amount_cell($myrow["part_price"]);
   label_cell($myrow["part_price_date"]);
    label_cell($myrow["vendor_ref"]);
	 label_cell($myrow["part_manufacturer"]);
   
   edit_button_cell("Edit".$myrow["part_code"], _("Edit"));
 	delete_button_cell("Delete".$myrow["part_code"], _("Delete"));
  	end_row();

} //END WHILE LIST LOOP

end_table();
echo '<br>';

//------------------------------------------------------------------------------------------------

$_POST['part_email'] = "";
if ($selected_id != -1) 
{
 	if ($Mode == 'Edit') {
		//editing an existing Sales-person
		$myrow = get_part($selected_id);

		$_POST['part_name'] = $myrow["part_name"];
		$_POST['part_type_desc'] = $myrow["part_type_desc"];
		$_POST['part_no'] = $myrow["part_no"];
		$_POST['part_price'] = $myrow["part_price"];
		$_POST['part_price_date'] = sql2date($myrow["part_price_date"]);
		$_POST['vendor_ref'] = $myrow["vendor_ref"];
		$_POST['part_manufacturer'] = $myrow["part_manufacturer"];
	}
	hidden('selected_id', $selected_id);
} 
$_POST['vendor_ref'] = $myrow["vendor_ref"];
$_POST['part_type_desc'] = $myrow["part_type_desc"];
start_table(TABLESTYLE2);

text_row_ex(_("Part name:"), 'part_name', 30);
part_categories_list_row(_("Part type:"), 'part_type_desc', $_POST['part_type_desc']);
text_row_ex(_("Part Number"), 'part_no', 20);
amount_row(_("Part Price:"), 'part_price', null);
date_row(_("Price Update Date:"), 'part_price_date', null, 40, 40);
vendor_categories_list_row(_("Vendor Type:"), 'vendor_ref', $_POST['vendor_ref']);
text_row_ex(_("Part Manufacturer"), 'part_manufacturer', 50);

end_table(1);

submit_add_or_update_center($selected_id == -1, '', 'both');

end_form();

end_page();

?>

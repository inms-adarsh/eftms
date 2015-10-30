<?php
/**********************************************************************
    Copyright (C) Frontcommodity_typeing, LLC.
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
page(_($help_context = "Commodity Type Group"));


simple_page_mode(false);
 
include_once($path_to_root . "/includes/data_checks.inc");

check_db_has_commodity_type_groups(_("There are no Commodity Type groups defined. Please define at least one Commodity Type group before entering Commodity Type."));

//-------------------------------------------------------------------------------------

if (isset($_POST['_CommodityTypeList_update'])) 
{
	$_POST['selected_commodity_type'] = $_POST['CommodityTypeList'];
	unset($_POST['commodity_type_code']);
}

if (isset($_POST['selected_commodity_type']))
{
	$selected_commodity_type = $_POST['selected_commodity_type'];
} 
elseif (isset($_GET['selected_commodity_type']))
{
	$selected_commodity_type = $_GET['selected_commodity_type'];
}
else
	$selected_commodity_type = "";
//-------------------------------------------------------------------------------------

if (isset($_POST['add']) || isset($_POST['update'])) 
{

	$input_error = 0;

	if (strlen(trim($_POST['commodity_type_name'])) == 0) 
	{
		$input_error = 1;
		display_error( _("The commodity_type name cannot be empty."));
		set_focus('commodity_type_name');
	} 
	
	if ($input_error != 1)
	{
		
    	if ($selected_commodity_type) 
		{
			if (update_commodity_type($_POST['commodity_type_code'], $_POST['commodity_type_name'], 
				$_POST['commodity_group_type'])) {
					$Ajax->activate('commodity_type_code'); // in case of status change
				display_notification(_("Commodity Type data has been updated."));
			}
		}
    	else 
		{
    		if (add_commodity_type($_POST['commodity_type_name'], 
				$_POST['commodity_group_type']))
				{
					display_notification(_("New commodity type has been added."));
				}
			else
                 display_error(_("Commodity Type not added"));
		}
		$Ajax->activate('_page_body');
	}
} 

//-------------------------------------------------------------------------------------

function can_delete($selected_commodity_type)
{
	if ($selected_commodity_type == "")
		return false;
	return true;
}

//--------------------------------------------------------------------------------------

if (isset($_POST['delete'])) 
{

	if (can_delete($selected_commodity_type))
	{
		delete_commodity_type($selected_commodity_type);
		$selected_commodity_type = $_POST['CommodityTypeList'] = '';
		display_notification(_("Selected commodity_type has been deleted"));
		unset($_POST['commodity_type_code']);
		$Ajax->activate('_page_body');
	}
} 

//-------------------------------------------------------------------------------------

start_form();

if (db_has_commodity_type()) 
{
	start_table(TABLESTYLE_NOBORDER);
	start_row();
    all_commodity_type_list_cells(null, 'CommodityTypeList', null, false, 
		_('New Commodity Type'), true, check_value('show_inactive'));
	check_cells(_("Show inactive:"), 'show_inactive', null, true);
	end_row();
	end_table();
	if (get_post('_show_inactive_update')) {
		$Ajax->activate('CommodityTypeList');
		set_focus('CommodityTypeList');
	}
}
	
br(1);
start_table(TABLESTYLE2);

if ($selected_commodity_type != "") 
{
	//editing an existing commodity_type
	$myrow = get_commodity_type($selected_commodity_type);

	$_POST['commodity_type_code'] = $myrow["commodity_type_code"];
	$_POST['commodity_type_name']	= $myrow["commodity_type_name"];
	$_POST['commodity_group_type'] = $myrow["commodity_group_type"];
 	$_POST['inactive'] = $myrow["inactive"];
 	
 	
	hidden('commodity_type_code', $_POST['commodity_type_code']);
	hidden('selected_commodity_type', $selected_commodity_type);
		
	label_row(_("commodity_type Code:"), $_POST['commodity_type_code']);
} 
else
{
	if (!isset($_POST['commodity_type_code'])) {
		$_POST['commodity_type_tags'] = array();
		$_POST['commodity_type_name']	= $_POST['commodity_group_type'] = '';
 		$_POST['inactive'] = 0;
	}
}

text_row_ex(_("Commodity Type Name:"), 'commodity_type_name', 60);

commodity_group_types_list_row(_("Commodity Type Group:"), 'commodity_group_type', null);

record_status_list_row(_("Record status:"), 'inactive');
end_table(1);

if ($selected_commodity_type == "") 
{
	submit_center('add', _("Add Commodity Type"), true, '', 'default');
} 
else 
{
    submit_center_first('update', _("Update commodity_type"), '', 'default');
    submit_center_last('delete', _("Delete commodity_type"), '',true);
}
end_form();

end_page();

?>

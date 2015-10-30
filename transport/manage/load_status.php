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
include($path_to_root . "/includes/db_pager.inc");
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

if (isset($_GET['updated'])) {
        if($_GET['updated'] == 'N')
        {
             display_notification(_('New Status Label has been added'));
        }
        else {
            display_notification(_('Selected Status Label has been updated'));
        }
}

if (isset($_GET['deleted'])) {
        if($_GET['deleted'] == 'Y')
        {
             display_notification(_('Status Label has been deleted'));
        }
}
if (isset($_POST['_LoadStatusList_update'])) 
{
	$_POST['selected_load_status'] = $_POST['LoadStatusList'];
	unset($_POST['load_status_code']);
}

if (isset($_POST['selected_load_status']))
{
	$selected_load_status = $_POST['selected_load_status'];
} 
elseif (isset($_GET['selected_load_status']))
{
	$selected_load_status = $_GET['selected_load_status'];
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
		
    	if ($selected_load_status) 
		{
			if (update_load_status($_POST['load_status_code'], $_POST['load_status_name'], 
				$_POST['load_status_type'])) {
					$Ajax->activate('load_status_code'); // in case of status change
				display_notification(_("load status data has been updated."));
			}
		}
    	else 
		{
    		if (add_load_status($_POST['load_status_name'], 
				$_POST['load_status_type']))
				{
					display_notification(_("New load status has been added."));
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

	if (can_delete($selected_load_status))
	{
		delete_load_status($selected_load_status);
		$selected_load_status = $_POST['LoadStatusList'] = '';
		display_notification(_("Selected load status has been deleted"));
		unset($_POST['load_status_code']);
		$Ajax->activate('_page_body');
	}
} 

function edit_link($row) 
{
    if (@$_GET['popup'])
        return '';
    return pager_link( _("Edit"),
    "/transport/manage/new_load_status.php?load_status_code=" . $row['load_status_code'], ICON_EDIT);
}
//-------------------------------------------------------------------------------------

start_form();


	 start_form_section('row page-head');

    start_form_section('text-right col-md-5 col-sm-4 col-xs-6 actions');
        anchor_button(_("Add new Status Label"),$path_to_root .'/transport/manage/new_load_status.php?NewStatus=Yes','btn btn-primary');
    end_form_section();
    end_form_section();
    $sql = get_all_load_status($_POST['show_inactive']);
     $cols = array(
        _("Status label#"),
        _("Type")       
    );
    array_append($cols, array(
    array('insert'=>true, 'fun'=>'edit_link')));
    check_cells(_("Show inactive:"), 'show_inactive', null, true);
    if (get_post('_show_inactive_update')) {
        $Ajax->activate('stock_id');
        set_focus('stock_id');
    }

$table =& new_db_pager('load_status_tbl', $sql, $cols,null,null,20);
$table->width = "80%";

display_db_pager($table,'load_status_tbl');


end_page();

?>

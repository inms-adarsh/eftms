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
$page_security = 'SA_CONSIGNOR';
$path_to_root = "../..";

include($path_to_root . "/includes/db_pager.inc");
include_once($path_to_root . "/includes/session.inc");
$js = "";
if ($use_popup_windows)
	$js .= get_js_open_window(900, 500);
if ($use_date_picker)
	$js .= get_js_date_picker();
	
page(_($help_context = "Consignors"), @$_REQUEST['popup'], false, "", $js); 

include_once($path_to_root . "/includes/date_functions.inc");
include_once($path_to_root . "/includes/banking.inc");
include_once($path_to_root . "/includes/ui.inc");
include_once($path_to_root . "/includes/ui/contacts_view.inc");

if (isset($_GET['consignor_no'])) 
{
	$_POST['consignor_id'] = $_GET['consignor_no'];
}

if (isset($_GET['updated'])) {
        if($_GET['updated'] == 'N')
        {
             display_notification(_('New Customer has been added'));
        }
        else {
            display_notification(_('Selected Customer has been updated'));
        }
}

if (isset($_GET['deleted'])) {
        if($_GET['deleted'] == 'Y')
        {
             display_notification(_('Customer has been deleted'));
        }
}
$selected_id = get_post('consignor_id','');
//--------------------------------------------------------------------------------------------

function can_process()
{
	if (strlen($_POST['CustName']) == 0) 
	{
		display_error(_("The customer name cannot be empty."));
		set_focus('CustName');
		return false;
	} 

	if (strlen($_POST['contact_name']) == 0) 
	{
		display_error(_("The contact name cannot be empty."));
		set_focus('contact_name');
		return false;
	} 

	if (strlen($_POST['consignor_ref']) == 0) 
	{
		display_error(_("The customer short name cannot be empty."));
		set_focus('consignor_ref');
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
		update_consignor($_POST['consignor_id'], $_POST['CustName'], $_POST['consignor_ref'], $_POST['address'],$_POST['location'],$_POST['notes'],$_POST['tin_no'],$_POST['contact_name'],$_POST['phone'],$_POST['email']);

		update_record_status($_POST['consignor_id'], $_POST['inactive'],
			'consignors_master', 'consignor_no');

		$Ajax->activate('consignor_id'); // in case of status change
		display_notification(_("Customer has been updated."));
	} 
	else 
	{ 	//it is a new consignor

		begin_transaction();
		add_consignor($_POST['CustName'], $_POST['consignor_ref'], $_POST['address'],
			$_POST['location'],$_POST['notes'],$_POST['tin_no'],$_POST['contact_name'],$_POST['phone'],$_POST['email']);

		$selected_id = $_POST['consignor_id'] = db_insert_id();
         
        
			add_crm_person($_POST['CustName'], $_POST['consignor_ref'], '', $_POST['address'], 
				$_POST['phone'], $_POST['phone2'], $_POST['fax'], $_POST['email'], '', '');

			$pers_id = db_insert_id();
	
			add_crm_contact('consignor', 'general', $selected_id, $pers_id);
		commit_transaction();

		display_notification(_("A new customer has been added."));
	
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

	// PREVENT DELETES IF DEPENDENT RECORDS IN 'consignor_trans'

	if (key_in_foreign_table($selected_id, 'consignor_trans', 'consignor_no'))
	{
		$cancel_delete = 1;
		display_error(_("This customer cannot be deleted because there are transactions that refer to it."));
	} 
	else 
	{
		if (key_in_foreign_table($selected_id, 'transport_orders', 'consignor_no'))
		{
			$cancel_delete = 1;
			display_error(_("Cannot delete the customer record because orders have been created against it."));
		} 
		else 
		{
			if (key_in_foreign_table($selected_id,  'consignor_no'))
			{
				$cancel_delete = 1;
				display_error(_("Cannot delete this customer because there are  records set up against it."));
				//echo "<br> There are " . $myrow[0] . " branch records relating to this consignor";
			}
		}
	}
	
	if ($cancel_delete == 0) 
	{ 	//ie not cancelled the delete as a result of above tests
	
		delete_consignor($selected_id);

		display_notification(_("Selected customer has been deleted."));
		unset($_POST['consignor_id']);
		$selected_id = '';
		$Ajax->activate('_page_body');
	} //end if Delete Consignor
}

function edit_link($row) 
{
    if (@$_GET['popup'])
        return '';
    return pager_link( _("Edit"),
    "/transport/manage/new_consignor.php?consignor_no=" . $row['consignor_no'], ICON_EDIT);
}

//--------------------------------------------------------------------------------------------

start_form();


	 start_form_section('row page-head');

    start_form_section('text-right col-md-5 col-sm-4 col-xs-6 actions');
        anchor_button(_("Add new Consignor"),$path_to_root .'/transport/manage/new_consignor.php?NewConsignor=Yes','btn btn-primary');
    end_form_section();
    end_form_section();
    $sql = get_all_consignors($_POST['show_inactive']);
    $cols = array(
        _("Name #"),
        _("Contact Person") ,
        _("Phone"),
        _("Email"),
        _("Address"),
        _("TIN")
    );
    array_append($cols, array(
    array('insert'=>true, 'fun'=>'edit_link')));
    check_cells(_("Show inactive:"), 'show_inactive', null, true);
    if (get_post('_show_inactive_update')) {
        $Ajax->activate('driver_id');
        set_focus('consignor_id');
    }

$table =& new_db_pager('consignor_tbl', $sql, $cols,null,null,20);
$table->width = "80%";

display_db_pager($table,'consignor_tbl');


if (!$selected_id || list_updated('consignor_id'))
	unset($_POST['_tabs_sel']); // force settings tab for new consignor


hidden('popup', @$_REQUEST['popup']);

end_form();
end_page(@$_REQUEST['popup']);

?>

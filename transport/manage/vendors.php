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

$js = "";
if ($use_popup_windows)
	$js .= get_js_open_window(900, 500);
if ($use_date_picker)
	$js .= get_js_date_picker();
	
page(_($help_context = "Customers"), @$_REQUEST['popup'], false, "", $js); 


if (isset($_GET['vendor_no'])) 
{
	$_POST['vendor_id'] = $_GET['vendor_no'];
}

$selected_id = get_post('vendor_id','');
//--------------------------------------------------------------------------------------------

function can_process()
{
	if (strlen($_POST['vendor_name']) == 0) 
	{
		display_error(_("The vendor vendor_name cannot be empty."));
		set_focus('vendor_name');
		return false;
	} 

	if (strlen($_POST['vendor_ref']) == 0) 
	{
		display_error(_("The vendor short vendor_name cannot be empty."));
		set_focus('vendor_ref');
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
		update_vendor($_POST['vendor_id'],$_POST['vendor_name'],
		$_POST['hired_on'],$_POST['notes'],
		 $_POST['vendor_ref'],$_POST['address'],
		$_POST['curr_code'],$_POST['payment_terms']);

		update_record_status($_POST['vendor_id'], $_POST['inactive'],
			'vendors_master', 'vendor_no');

		$Ajax->activate('vendor_id'); // in case of status change
		display_notification(_("Customer has been updated."));
	} 
	else 
	{ 	//it is a new vendor

		begin_transaction();
		add_vendor($_POST['vendor_name'],
		$_POST['hired_on'],$_POST['notes'],
		 $_POST['vendor_ref'],$_POST['address'],
		$_POST['curr_code'],$_POST['payment_terms']);

		$selected_id = $_POST['vendor_id'] = db_insert_id();
         
		commit_transaction();

		display_notification(_("A new vendor has been added."));

		
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

	// PREVENT DELETES IF DEPENDENT RECORDS IN 'vendor_trans'

	if (key_in_foreign_table($selected_id, 'vendor_trans', 'vendor_no'))
	{
		$cancel_delete = 1;
		display_error(_("This vendor cannot be deleted because there are transactions that refer to it."));
	} 
	else 
	{
		if (key_in_foreign_table($selected_id, 'transport_orders', 'vendor_no'))
		{
			$cancel_delete = 1;
			display_error(_("Cannot delete the vendor record because orders have been created against it."));
		} 
		else 
		{
			if (key_in_foreign_table($selected_id, 'consignor_branch', 'vendor_no'))
			{
				$cancel_delete = 1;
				display_error(_("Cannot delete this vendor because there are branch records set up against it."));
				//echo "<br> There are " . $myrow[0] . " branch records relating to this vendor";
			}
		}
	}
	
	if ($cancel_delete == 0) 
	{ 	//ie not cancelled the delete as a result of above tests
	
		delete_vendor($selected_id);

		display_notification(_("Selected vendor has been deleted."));
		unset($_POST['vendor_id']);
		$selected_id = '';
		$Ajax->activate('_page_body');
	} //end if Delete Customer
}

function vendor_settings($selected_id) 
{
	global $SysPrefs, $path_to_root;
	
	if (!$selected_id) 
	{
	 	if (list_updated('vendor_id') || !isset($_POST['vendor_name'])) {
			$_POST['vendor_name'] = $_POST['vendor_ref'] = $_POST['address'] =$_POST['licence_no']  = $_POST['rate']  = '';
			$_POST['curr_code']  = get_company_currency();
			$_POST['credit_status']  = -1;
			$_POST['payment_terms']  = $_POST['notes']  = '';

			
		}
	}
	else 
	{
		$myrow = get_vendor($selected_id);

		$_POST['vendor_name'] = $myrow["vendor_name"];
		$_POST['vendor_ref'] = $myrow["vendor_ref"];
		$_POST['address']  = $myrow["address"];
		$_POST['curr_code']  = $myrow["curr_code"];
	
		$_POST['hired_on']  = sql2date($myrow["hired_on"]);
		$_POST['payment_terms']  = $myrow["payment_terms"];
		$_POST['notes']  = $myrow["notes"];
		$_POST['curr_code'] = $myrow["curr_code"];
		$_POST['inactive'] = $myrow["inactive"];
	}

	start_outer_table(TABLESTYLE2);
	table_section(1);
	table_section_title(_("Name and Address"));

	text_row(_("Vendor Name:"), 'vendor_name', $_POST['vendor_name'], 40, 80);
	text_row(_("Vendor Short Name:"), 'vendor_ref', null, 30, 30);
	textarea_row(_("Address:"), 'address', $_POST['address'], 35, 5);
	date_row(_("Vendor Hire Date:"), 'hired_on', null, 40, 40);

	if (!$selected_id) 
	{
		currencies_list_row(_("Payment Currency:"), 'curr_code', $_POST['curr_code']);
	} 
	else 
	{
		label_row(_("Payment Currency:"), $_POST['curr_code']);
		hidden('curr_code', $_POST['curr_code']);				
	}
	if($selected_id)
		record_status_list_row(_("Vendor status:"), 'inactive');
	
	table_section(2);

	table_section_title(_("Sales"));

	payment_terms_list_row(_("Payment Terms:"), 'payment_terms', $_POST['payment_terms']);
	textarea_row(_("General Notes:"), 'notes', null, 35, 5);
	
	end_outer_table(1);

	div_start('controls');
	if (!$selected_id)
	{
		submit_center('submit', _("Add New Customer"), true, '', 'default');
	} 
	else 
	{
		submit_center_first('submit', _("Update Customer"), 
		  _('Update vendor data'), @$_REQUEST['popup'] ? true : 'default');
		submit_return('select', $selected_id, _("Select this vendor and return to document entry."));
		submit_center_last('delete', _("Delete Customer"), 
		  _('Delete vendor data if have been never used'), true);
	}
	div_end();
}

//--------------------------------------------------------------------------------------------

 
start_form();

if (db_has_vendors()) 
{
	start_table(TABLESTYLE_NOBORDER);
	start_row();
	vendor_list_cells(_("Select a vendor: "), 'vendor_id', null,
		_('New vendor'), true, check_value('show_inactive'));
	check_cells(_("Show inactive:"), 'show_inactive', null, true);
	end_row();
	end_table();

	if (get_post('_show_inactive_update')) {
		$Ajax->activate('vendor_id');
		set_focus('vendor_id');
	}
} 
else 
{
	hidden('vendor_id');
}

if (!$selected_id || list_updated('vendor_id'))
	unset($_POST['_tabs_sel']); // force settings tab for new vendor

tabbed_content_start('tabs', array(
		'settings' => array(_('&General settings'), $selected_id),
		'contacts' => array(_('&Contacts'), $selected_id),
		'accidents' => array(_('&Accidents'), $selected_id),
	));
	
	switch (get_post('_tabs_sel')) {
		default:
		case 'settings':
			vendor_settings($selected_id); 
			break;
		case 'contacts':
			$contacts = new contacts('contacts', $selected_id, 'vendor');
			$contacts->show();
			break;
		case 'accidents':
			$_GET['vendor_id'] = $selected_id;
			$_GET['popup'] = 1;
			include_once($path_to_root."modules/transport/accident_inquiry.php");
			break;
			
	};
br();
tabbed_content_end();

hidden('popup', @$_REQUEST['popup']);
end_form();
end_page(@$_REQUEST['popup']);

?>

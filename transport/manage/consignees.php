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
$page_security = 'SA_CONSIGNEE';
$path_to_root = "../..";
include_once($path_to_root . "/transport/includes/transport_db.inc");
include($path_to_root . "/includes/db_pager.inc");
include_once($path_to_root . "/includes/session.inc");
$js = "";
if ($use_popup_windows)
	$js .= get_js_open_window(900, 500);
if ($use_date_picker)
	$js .= get_js_date_picker();
	
page(_($help_context = "Consignees"), @$_REQUEST['popup'], false, "", $js); 

include_once($path_to_root . "/includes/date_functions.inc");
include_once($path_to_root . "/includes/banking.inc");
include_once($path_to_root . "/includes/ui.inc");
include_once($path_to_root . "/includes/ui/contacts_view.inc");

if (isset($_GET['consignee_no'])) 
{
	$_POST['consignee_id'] = $_GET['consignee_no'];
}

$selected_id = get_post('consignee_id','');
//--------------------------------------------------------------------------------------------

function can_process()
{
	if (strlen($_POST['CustName']) == 0) 
	{
		display_error(_("The consignee name cannot be empty."));
		set_focus('CustName');
		return false;
	} 

	if (strlen($_POST['consignee_ref']) == 0) 
	{
		display_error(_("The consignee short name cannot be empty."));
		set_focus('consignee_ref');
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
		update_consignee($_POST['consignee_id'], $_POST['CustName'], $_POST['consignee_ref'], $_POST['address'],
			$_POST['tax_id'], $_POST['curr_code'], input_num('discount') / 100, input_num('pymt_discount') / 100,
			input_num('credit_limit'),  $_POST['notes']);

		update_record_status($_POST['consignee_id'], $_POST['inactive'],
			'consignees_master', 'consignee_no');

		$Ajax->activate('consignee_id'); // in case of status change
		display_notification(_("Consignee has been updated."));
	} 
	else 
	{ 	//it is a new consignee

		begin_transaction();
		add_consignee($_POST['CustName'], $_POST['consignee_ref'], $_POST['address'],
			$_POST['tax_id'], $_POST['curr_code'], input_num('discount') / 100, input_num('pymt_discount') / 100,
			input_num('credit_limit'), $_POST['notes']);

		$selected_id = $_POST['consignee_id'] = db_insert_id();
         
		if (isset($auto_create_branch) && $auto_create_branch == 1)
		{
        	add_consignee_branch($selected_id, $_POST['CustName'], $_POST['consignee_ref'], $_POST['tin_no'],
                $_POST['address'], $_POST['transportman'], $_POST['area'], $_POST['tax_group_id'], '',
                get_company_pref('default_transport_discount_act'), get_company_pref('consignees_act'), get_company_pref('default_prompt_payment_act'),
                $_POST['location'], $_POST['address'], 0, 0, $_POST['ship_via'], $_POST['notes']);
                
        	$selected_consignee_branch = db_insert_id();
        
			add_crm_person($_POST['CustName'], $_POST['consignee_ref'], '', $_POST['address'], 
				$_POST['phone'], $_POST['phone2'], $_POST['fax'], $_POST['email'], '', '');

			$pers_id = db_insert_id();
			add_crm_contact('consignee_branch', 'general', $selected_consignee_branch, $pers_id);

			add_crm_contact('consignee', 'general', $selected_id, $pers_id);
		}
		commit_transaction();

		display_notification(_("A new consignee has been added."));

		if (isset($auto_create_branch) && $auto_create_branch == 1)
			display_notification(_("A default Branch has been automatically created, please check default Branch values by using link below."));
		
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

	// PREVENT DELETES IF DEPENDENT RECORDS IN 'consignee_trans'

	if (key_in_foreign_table($selected_id, 'consignee_trans', 'consignee_no'))
	{
		$cancel_delete = 1;
		display_error(_("This consignee cannot be deleted because there are transactions that refer to it."));
	} 
	else 
	{
		if (key_in_foreign_table($selected_id, 'transport_orders', 'consignee_no'))
		{
			$cancel_delete = 1;
			display_error(_("Cannot delete the consignee record because orders have been created against it."));
		} 
		else 
		{
			if (key_in_foreign_table($selected_id, 'consignee_branch', 'consignee_no'))
			{
				$cancel_delete = 1;
				display_error(_("Cannot delete this consignee because there are consignee_branch records set up against it."));
				//echo "<br> There are " . $myrow[0] . " consignee_branch records relating to this consignee";
			}
		}
	}
	
	if ($cancel_delete == 0) 
	{ 	//ie not cancelled the delete as a result of above tests
	
		delete_consignee($selected_id);

		display_notification(_("Selected consignee has been deleted."));
		unset($_POST['consignee_id']);
		$selected_id = '';
		$Ajax->activate('_page_body');
	} //end if Delete Consignee
}

function consignee_settings($selected_id) 
{
	global $SysPrefs, $path_to_root, $auto_create_branch;
	
	if (!$selected_id) 
	{
	 	if (list_updated('consignee_id') || !isset($_POST['CustName'])) {
			$_POST['CustName'] = $_POST['consignee_ref'] = $_POST['address'] = $_POST['tax_id']  = '';
			
			$_POST['curr_code']  = get_company_currency();
			$_POST['credit_status']  = -1;
			$_POST['payment_terms']  = $_POST['notes']  = '';

			$_POST['discount']  = $_POST['pymt_discount'] = percent_format(0);
			$_POST['credit_limit']	= price_format($SysPrefs->default_credit_limit());
		}
	}
	else 
	{
		$myrow = get_consignee($selected_id);

		$_POST['CustName'] = $myrow["name"];
		$_POST['consignee_ref'] = $myrow["consignee_ref"];
		$_POST['address']  = $myrow["address"];
		$_POST['tax_id']  = $myrow["tax_id"];
		//$_POST['tin_no']  = $myrow["tin_no"];
	
		
		$_POST['curr_code']  = $myrow["curr_code"];
		$_POST['credit_status']  = $myrow["credit_status"];
		$_POST['payment_terms']  = $myrow["payment_terms"];
		$_POST['discount']  = percent_format($myrow["discount"] * 100);
		$_POST['pymt_discount']  = percent_format($myrow["pymt_discount"] * 100);
		$_POST['credit_limit']	= price_format($myrow["credit_limit"]);
		$_POST['notes']  = $myrow["notes"];
		$_POST['inactive'] = $myrow["inactive"];
	}

	start_outer_table(TABLESTYLE2);
	table_section(1);
	table_section_title(_("Name and Address"));

	text_row(_("Consignee Name:"), 'CustName', $_POST['CustName'], 40, 80);
	text_row(_("Consignee Short Name:"), 'consignee_ref', null, 30, 30);
	textarea_row(_("Address:"), 'address', $_POST['address'], 35, 5);

	text_row(_("GSTNo:"), 'tax_id', null, 40, 40);


	if (!$selected_id || is_new_consignee($selected_id)) 
	{
		currencies_list_row(_("Consignee's Currency:"), 'curr_code', $_POST['curr_code']);
	} 
	else 
	{
		label_row(_("Consignee's Currency:"), $_POST['curr_code']);
		hidden('curr_code', $_POST['curr_code']);				
	}
	//transport_types_list_row(_("Transport Type/Price List:"), 'transport_type', $_POST['transport_type']);

	if($selected_id)
		record_status_list_row(_("Consignee status:"), 'inactive');
	elseif (isset($auto_create_branch) && $auto_create_branch == 1)
	{
		table_section_title(_("Branch"));
		text_row(_("TIN No:"), 'tin_no', null, 40, 40);
		text_row(_("Phone:"), 'phone', null, 32, 30);
		text_row(_("Secondary Phone Number:"), 'phone2', null, 32, 30);
		text_row(_("Fax Number:"), 'fax', null, 32, 30);
		email_row(_("E-mail:"), 'email', null, 35, 55);
		
		transport_persons_list_row( _("Transport Person:"), 'transportman', null);
	}
	table_section(2);

	table_section_title(_("Transport"));

	/*percent_row(_("Discount Percent:"), 'discount', $_POST['discount']);
	percent_row(_("Prompt Payment Discount Percent:"), 'pymt_discount', $_POST['pymt_discount']);*/
	amount_row(_("Credit Limit:"), 'credit_limit', $_POST['credit_limit']);

	/*payment_terms_list_row(_("Payment Terms:"), 'payment_terms', $_POST['payment_terms']);
	credit_status_list_row(_("Credit Status:"), 'credit_status', $_POST['credit_status']); */
	

	if ($selected_id)  {
		start_row();
		echo '<td class="label">'._('Consignee consignee_branches').':</td>';
	  	hyperlink_params_td($path_to_root . "/transport/manage/consignee_branches.php",
			'<b>'. (@$_REQUEST['popup'] ?  _("Select or &Add") : _("&Add or Edit ")).'</b>', 
			"consignee_no=".$selected_id.(@$_REQUEST['popup'] ? '&popup=1':''));
		end_row();
	}

	textarea_row(_("General Notes:"), 'notes', null, 35, 5);
	/*if (!$selected_id && isset($auto_create_branch) && $auto_create_branch == 1)
	{
		table_section_title(_("Branch"));
		locations_list_row(_("Default Inventory Location:"), 'location');
		shippers_list_row(_("Default Shipping Company:"), 'ship_via');
		transport_areas_list_row( _("Transport Area:"), 'area', null);
		tax_groups_list_row(_("Tax Group:"), 'tax_group_id', null);
	}*/
	end_outer_table(1);

	div_start('controls');
	if (!$selected_id)
	{
		submit_center('submit', _("Add New Consignee"), true, '', 'default');
	} 
	else 
	{
		submit_center_first('submit', _("Update Consignee"), 
		  _('Update consignee data'), @$_REQUEST['popup'] ? true : 'default');
		submit_return('select', $selected_id, _("Select this consignee and return to document entry."));
		submit_center_last('delete', _("Delete Consignee"), 
		  _('Delete consignee data if have been never used'), true);
	}
	div_end();
}

//--------------------------------------------------------------------------------------------

check_db_has_transport_types(_("There are no transport types defined. Please define at least one transport type before adding a consignee."));
 
start_form();

if (db_has_consignees()) 
{
	start_table(TABLESTYLE_NOBORDER);
	start_row();
	consignee_list_cells(_("Select a consignee: "), 'consignee_id', null,
		_('New consignee'), true, check_value('show_inactive'));
	check_cells(_("Show inactive:"), 'show_inactive', null, true);
	end_row();
	end_table();

	if (get_post('_show_inactive_update')) {
		$Ajax->activate('consignee_id');
		set_focus('consignee_id');
	}
} 
else 
{
	hidden('consignee_id');
}

if (!$selected_id || list_updated('consignee_id'))
	unset($_POST['_tabs_sel']); // force settings tab for new consignee

tabbed_content_start('tabs', array(
		'settings' => array(_('&General settings'), $selected_id),
		'contacts' => array(_('&Contacts'), $selected_id),
		
	
	));
	
	switch (get_post('_tabs_sel')) {
		default:
		case 'settings':
			consignee_settings($selected_id); 
			break;
		case 'contacts':
			$contacts = new contacts('contacts', $selected_id, 'consignee');
			$contacts->show();
			break;
		
		
	};
br();
tabbed_content_end();

hidden('popup', @$_REQUEST['popup']);
end_form();
end_page(@$_REQUEST['popup']);

?>

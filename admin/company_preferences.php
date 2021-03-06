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
$page_security = 'SA_SETUPCOMPANY';
$path_to_root = "..";
include($path_to_root . "/includes/session.inc");

page(_($help_context = "Company Setup"));

include_once($path_to_root . "/includes/date_functions.inc");
include_once($path_to_root . "/includes/ui.inc");

include_once($path_to_root . "/admin/db/company_db.inc");
//-------------------------------------------------------------------------------------------------

if (isset($_POST['update']) && $_POST['update'] != "")
{

	$input_error = 0;

	if (!check_num('login_tout', 10))
	{
		display_error(_("Login timeout must be positive number not less than 10."));
		set_focus('login_tout');
		$input_error = 1;
	}
	if (strlen($_POST['coy_name'])==0)
	{
		$input_error = 1;
		display_error(_("The company name must be entered."));
		set_focus('coy_name');
	}
	if (isset($_FILES['pic']) && $_FILES['pic']['name'] != '')
	{
		$result = $_FILES['pic']['error'];
		$filename = company_path()."/images";
		if (!file_exists($filename))
		{
			mkdir($filename);
		}
		$filename .= "/".clean_file_name($_FILES['pic']['name']);

		 //But check for the worst
		if (!in_array( substr($filename,-3), array('jpg','JPG','png','PNG')))
		{
			display_error(_('Only jpg and png files are supported - a file extension of .jpg or .png is expected'));
			$input_error = 1;
		}
		elseif ( $_FILES['pic']['size'] > ($max_image_size * 1024))
		{ //File Size Check
			display_error(_('The file size is over the maximum allowed. The maximum size allowed in KB is') . ' ' . $max_image_size);
			$input_error = 1;
		}
		elseif ( $_FILES['pic']['type'] == "text/plain" )
		{  //File type Check
			display_error( _('Only graphics files can be uploaded'));
			$input_error = 1;
		}
		elseif (file_exists($filename))
		{
			$result = unlink($filename);
			if (!$result)
			{
				display_error(_('The existing image could not be removed'));
				$input_error = 1;
			}
		}

		if ($input_error != 1)
		{
			$result  =  move_uploaded_file($_FILES['pic']['tmp_name'], $filename);
			$_POST['coy_logo'] = clean_file_name($_FILES['pic']['name']);
			if(!$result) 
				display_error(_('Error uploading logo file'));
		}
	}
	if (check_value('del_coy_logo'))
	{
		$filename = company_path()."/images/".clean_file_name($_POST['coy_logo']);
		if (file_exists($filename))
		{
			$result = unlink($filename);
			if (!$result)
			{
				display_error(_('The existing image could not be removed'));
				$input_error = 1;
			}
		}
		$_POST['coy_logo'] = "";
	}
	if ($_POST['add_pct'] == "")
		$_POST['add_pct'] = -1;
	if ($_POST['round_to'] <= 0)
		$_POST['round_to'] = 1;
	if ($input_error != 1)
	{
		update_company_prefs(
			get_post( array('coy_name','coy_no','gst_no','tax_prd','tax_last',
				'postal_address','phone', 'fax', 'email', 'coy_logo', 'domicile',
				'use_dimension', 'curr_default', 'f_year', 
				'no_item_list' => 0, 'no_consignor_list' => 0, 
				'no_consignee_list' => 0, 
				'no_supplier_list' =>0, 'base_transport', 
				'time_zone' => 0, 'add_pct', 'round_to', 'login_tout', 'auto_curr_reval',
				'bcc_email'))
		);

		$_SESSION['wa_current_user']->timeout = $_POST['login_tout'];
		display_notification_centered(_("Company setup has been updated."));
	}
	set_focus('coy_name');
	$Ajax->activate('_page_body');
} /* end of if submit */

//---------------------------------------------------------------------------------------------
if (get_company_pref('bcc_email') === null) { // available from 2.3.14, can be not defined on pre-2.4 installations
	set_company_pref('bcc_email', 'setup.company', 'varchar', 100, '');
	refresh_sys_prefs();
}

start_form(true);
$myrow = get_company_prefs();

$_POST['coy_name'] = $myrow["coy_name"];
$_POST['gst_no'] = $myrow["gst_no"];
$_POST['tax_prd'] = $myrow["tax_prd"];
$_POST['tax_last'] = $myrow["tax_last"];
$_POST['coy_no']  = $myrow["coy_no"];
$_POST['postal_address']  = $myrow["postal_address"];
$_POST['phone']  = $myrow["phone"];
$_POST['fax']  = $myrow["fax"];
$_POST['email']  = $myrow["email"];
$_POST['coy_logo']  = $myrow["coy_logo"];
$_POST['domicile']  = $myrow["domicile"];
$_POST['use_dimension']  = $myrow["use_dimension"];
$_POST['base_transport']  = $myrow["base_transport"];
$_POST['no_item_list']  = $myrow["no_item_list"];
$_POST['no_consignor_list']  = $myrow["no_consignor_list"];
$_POST['no_consignee_list']  = $myrow["no_consignee_list"];
$_POST['no_supplier_list']  = $myrow["no_supplier_list"];
$_POST['curr_default']  = $myrow["curr_default"];
$_POST['f_year']  = $myrow["f_year"];
$_POST['time_zone']  = $myrow["time_zone"];
$_POST['version_id']  = $myrow["version_id"];
$_POST['add_pct'] = $myrow['add_pct'];
$_POST['login_tout'] = $myrow['login_tout'];
if ($_POST['add_pct'] == -1)
	$_POST['add_pct'] = "";
$_POST['round_to'] = $myrow['round_to'];	
$_POST['auto_curr_reval'] = $myrow['auto_curr_reval'];	
$_POST['del_coy_logo']  = 0;
$_POST['bcc_email']  = $myrow["bcc_email"];

start_form_section();


text_row_ex(_("Name (to appear on reports):"), 'coy_name', 42, 50);
textarea_row(_("Address:"), 'postal_address', $_POST['postal_address'], 35, 6);
text_row_ex(_("Domicile:"), 'domicile', 25, 55);

text_row_ex(_("Phone Number:"), 'phone', 25, 55);
text_row_ex(_("Fax Number:"), 'fax', 25);
email_row_ex(_("Email Address:"), 'email', 25, 55);

email_row_ex(_("BCC Address for all outgoing mails:"), 'bcc_email', 25, 55);

text_row_ex(_("Official Company Number:"), 'coy_no', 25);
text_row_ex(_("GSTNo:"), 'gst_no', 25);

currencies_list_row(_("Home Currency:"), 'curr_default', $_POST['curr_default']);
fiscalyears_list_row(_("Fiscal Year:"), 'f_year', $_POST['f_year']);
text_row_ex(_("Tax Periods:"), 'tax_prd', 10, 10, '', null, null, _('Months.'));
text_row_ex(_("Tax Last Period:"), 'tax_last', 10, 10, '', null, null, _('Months back.'));


label_row(_("Company Logo:"), $_POST['coy_logo']);
file_row(_("New Company Logo (.jpg)") . ":", 'pic', 'pic');
check_row(_("Delete Company Logo:"), 'del_coy_logo', $_POST['del_coy_logo']);

number_list_row(_("Use Dimensions:"), 'use_dimension', null, 0, 2);
transport_types_list_row(_("Base for auto price calculations:"), 'base_transport', $_POST['base_transport'], false,
    _('No base price list') );
text_row_ex(_("Add Price from Std Cost:"), 'add_pct', 10, 10, '', null, null, "%");
$curr = get_currency($_POST['curr_default']);
text_row_ex(_("Round to nearest:"), 'round_to', 10, 10, '', null, null, $curr['hundreds_name']);


check_row(_("Search Item List"), 'no_item_list', null);
check_row(_("Search Consignor List"), 'no_consignor_list', null);
check_row(_("Search Consignee List"), 'no_consignee_list', null);
check_row(_("Search Vendor List"), 'no_supplier_list', null);
check_row(_("Automatic Revaluation Currency Accounts"), 'auto_curr_reval', $_POST['auto_curr_reval']);
check_row(_("Time Zone on Reports"), 'time_zone', $_POST['time_zone']);
text_row_ex(_("Login Timeout:"), 'login_tout', 10, 10, '', null, null, _('seconds'));
label_row(_("Version Id"), $_POST['version_id']);

end_form_section();

hidden('coy_logo', $_POST['coy_logo']);
submit_center('update', _("Update"), true, '',  'default');

end_form(2);
//-------------------------------------------------------------------------------------------------

end_page();

?>

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
$path_to_root="../..";

include($path_to_root . "/includes/db_pager.inc");
include($path_to_root . "/includes/session.inc");

page(_($help_context = "Consignee Branches"), @$_REQUEST['popup']);

include($path_to_root . "/includes/ui.inc");
include($path_to_root . "/includes/ui/contacts_view.inc");

//-----------------------------------------------------------------------------------------------

check_db_has_consignees(_("There are no consignees defined in the system. Please define a consignee to add consignee consignee_branches."));

simple_page_mode(true);
//-----------------------------------------------------------------------------------------------

if (isset($_GET['consignee_no']))
{
	$_POST['consignee_id'] = strtoupper($_GET['consignee_no']);
}

$_POST['consignee_branch_code'] = $selected_id;

if (isset($_GET['selected_consignee_branch']))
{
	$br = get_consignee_branch($_GET['selected_consignee_branch']);
	$_POST['consignee_id'] = $br['consignee_no'];
	$selected_id = $_POST['consignee_branch_code'] = $br['consignee_branch_code'];
	$Mode = 'Edit';
}
//-----------------------------------------------------------------------------------------------

if ($Mode=='ADD_ITEM' || $Mode=='UPDATE_ITEM')
{

	//initialise no input errors assumed initially before we test
	$input_error = 0;

	if (strlen($_POST['br_name']) == 0)
	{
		$input_error = 1;
		display_error(_("The Branch name cannot be empty."));
		set_focus('br_name');
	}

	if (strlen($_POST['br_ref']) == 0)
	{
		$input_error = 1;
		display_error(_("The Branch short name cannot be empty."));
		set_focus('br_ref');
	}

	if ($input_error != 1)
	{

		begin_transaction();
    	if ($selected_id != -1)
		{
			update_consignee_branch($_POST['consignee_id'], $_POST['consignee_branch_code'], $_POST['br_name'], $_POST['br_ref'],$_POST['tin_no'],
				$_POST['br_address'],  $_POST['br_post_address'], $_POST['disable_trans'], $_POST['notes']);
//			update_record_status($_POST['supplier_id'], $_POST['inactive'],
//				'consignee_branch', 'consignee_branch_code');

			$note =_('Selected consignee consignee_branch has been updated');
  		}
		else
		{
			add_consignee_branch($_POST['consignee_id'], $_POST['br_name'], $_POST['br_ref'],$_POST['tin_no'],
				$_POST['br_address'], 
				$_POST['br_post_address'], 0, $_POST['notes']);
			$selected_id = db_insert_id();

			add_crm_person($_POST['contact_name'], $_POST['contact_name'], '', $_POST['br_post_address'], 
				$_POST['phone'], $_POST['phone2'], $_POST['fax'], $_POST['email'], 
				$_POST['rep_lang'], '');

			add_crm_contact('consignee_branch', 'general', $selected_id, db_insert_id());


			$note = _('New consignee consignee_branch has been added');
		}
		commit_transaction();
		display_notification($note);
//		$Mode = 'RESET';
		if (@$_REQUEST['popup']) {
			set_focus("Select".($_POST['consignee_branch_code'] == -1 ? $selected_id: $_POST['consignee_branch_code']));
		}
	}

}
elseif ($Mode == 'Delete')
{
	//the link to delete a selected record was clicked instead of the submit button

	// PREVENT DELETES IF DEPENDENT RECORDS IN 'consignee_trans'

	if (consignee_branch_in_foreign_table($_POST['consignee_id'], $_POST['consignee_branch_code'], 'consignee_trans'))
	{
		display_error(_("Cannot delete this consignee_branch because consignee transactions have been created to this consignee_branch."));

	}
	else
	{
		if (consignee_branch_in_foreign_table($_POST['consignee_id'], $_POST['consignee_branch_code'], 'transport_orders'))
		{
			display_error(_("Cannot delete this consignee_branch because transport orders exist for it. Purge old transport orders first."));
		}
		else
		{
			delete_consignee_branch($_POST['consignee_id'], $_POST['consignee_branch_code']);
			display_notification(_('Selected consignee consignee_branch has been deleted'));
		}
	} //end ifs to test if the consignee_branch can be deleted
	$Mode = 'RESET';
}

if ($Mode == 'RESET' || get_post('_consignee_id_update'))
{
	$selected_id = -1;
	$consignee_id = $_POST['consignee_id'];
	$inact = get_post('show_inactive');
	unset($_POST);
	$_POST['show_inactive'] = $inact;
	$_POST['consignee_id'] = $consignee_id;
	$Ajax->activate('_page_body');
}

function consignee_branch_email($row) {
	return	'<a href = "mailto:'.$row["email"].'">'.$row["email"].'</a>';
}

function edit_link($row) {
	return button("Edit".$row["consignee_branch_code"],_("Edit"), '', ICON_EDIT);
}

function del_link($row) {
	return button("Delete".$row["consignee_branch_code"],_("Delete"), '', ICON_DELETE);
}

function select_link($row) {
	return button("Select".$row["consignee_branch_code"], $row["consignee_branch_code"], '', ICON_ADD, 'selector');
}

function consignee_branch_settings($selected_id) {
	global $Mode, $num_consignee_branches;

	start_outer_table(TABLESTYLE2);

	table_section(1);

	$_POST['email'] = "";
	if ($selected_id != -1)
	{
	 	if ($Mode == 'Edit' || !isset($_POST['br_name'])) {
			//editing an existing consignee_branch
			$myrow = get_consignee_branch($_POST['consignee_branch_code']);
			set_focus('br_name');
	    	$_POST['consignee_branch_code'] = $myrow["consignee_branch_code"];
		    $_POST['br_name']  = $myrow["br_name"];
		    $_POST['br_ref']  = $myrow["consignee_branch_ref"];
			$_POST['tin_no'] = $myrow["tin_no"];
		    $_POST['br_address']  = $myrow["br_address"];
		    $_POST['br_post_address']  = $myrow["br_post_address"];
//		    $_POST['contact_name'] = $myrow["contact_name"];
		    $_POST['transportman'] =$myrow["transportman"];
		    $_POST['area'] =$myrow["area"];
//		    $_POST['rep_lang'] =$myrow["rep_lang"];
//		    $_POST['phone'] =$myrow["phone"];
//		    $_POST['phone2'] =$myrow["phone2"];
//		    $_POST['fax'] =$myrow["fax"];
//		    $_POST['email'] =$myrow["email"];
		    $_POST['tax_group_id'] = $myrow["tax_group_id"];
		    $_POST['disable_trans'] = $myrow['disable_trans'];
		    $_POST['default_location'] = $myrow["default_location"];
		    $_POST['default_ship_via'] = $myrow['default_ship_via'];
		    $_POST['transport_account'] = $myrow["transport_account"];
		    $_POST['transport_discount_account'] = $myrow['transport_discount_account'];
		    $_POST['receivables_account'] = $myrow['receivables_account'];
		    $_POST['payment_discount_account'] = $myrow['payment_discount_account'];
			$_POST['group_no']  = $myrow["group_no"];
			$_POST['notes']  = $myrow["notes"];

		}
	}
	elseif ($Mode != 'ADD_ITEM')
	{ //end of if $SelectedBranch only do the else when a new record is being entered
		$myrow = get_default_info_for_consignee_branch($_POST['consignee_id']);
//		$_POST['rep_lang'] = $myrow['rep_lang'];
		if(!$num_consignee_branches) {
			$_POST['br_name'] = $myrow["name"];
			$_POST['br_ref'] = $myrow["consignee_ref"];
			$_POST['tin_no'] = $myrow["tin_no"];
			$_POST['contact_name'] = _('Main Branch');
			$_POST['br_address'] = $_POST['br_post_address'] = $myrow["address"];
		}
		$_POST['consignee_branch_code'] = "";
		if (!isset($_POST['transport_account']) || !isset($_POST['transport_discount_account']))
		{
			$company_record = get_company_prefs();

			// We use the Item Transport Account as default!
		    // $_POST['transport_account'] = $company_record["default_transport_act"];
		   
		}

	}
	hidden('popup', @$_REQUEST['popup']);

	table_section_title(_("Name and Contact"));
	text_row(_("Branch Name:"), 'br_name', null, 35, 40);
	text_row(_("Branch Short Name:"), 'br_ref', null, 30, 30);
text_row(_("TIN No:"), 'tin_no', null, 30, 30);
	

	table_section(2);

if($selected_id==-1) {
	table_section_title(_("General contact data"));
	text_row(_("Contact Person:"), 'contact_name', null, 35, 40);
	text_row(_("Phone Number:"), 'phone', null, 32, 30);
	text_row(_("Secondary Phone Number:"), 'phone2', null, 32, 30);
	text_row(_("Fax Number:"), 'fax', null, 32, 30);
	email_row(_("E-mail:"), 'email', null, 35, 55);
	languages_list_row( _("Document Language:"), 'rep_lang', null, _("Consignee default"));
}
	table_section_title(_("Addresses"));
	textarea_row(_("Mailing Address:"), 'br_post_address', null, 35, 4);
	textarea_row(_("Billing Address:"), 'br_address', null, 35, 4);
	textarea_row(_("General Notes:"), 'notes', null, 35, 4);

if($selected_id!=-1)
	yesno_list_row(_("Disable this Branch:"), 'disable_trans', null);

	end_outer_table(1);
	submit_add_or_update_center($selected_id == -1, '', 'both');
}

start_form();

echo "<center>" . _("Select a consignee: ") . "&nbsp;&nbsp;";
echo consignee_list('consignee_id', null, false, true);
echo "</center><br>";

$num_consignee_branches = db_has_consignee_branches($_POST['consignee_id']);

$sql = get_sql_for_consignee_branches();

//------------------------------------------------------------------------------------------------
if ($num_consignee_branches)
{
$cols = array(
	'consignee_branch_code' => 'skip',
	_("Short Name"),
	_("Name"),
	_("Contact"),
	_("Phone No"),
	_("Fax No"),
	_("E-mail") => 'email',
	
	_("Inactive") => 'inactive',
//		array('fun'=>'inactive'),
		' '=> array('insert'=>true, 'fun'=>'select_link'),
		array('insert'=>true, 'fun'=>'edit_link'),
		array('insert'=>true, 'fun'=>'del_link')
	);

	if (!@$_REQUEST['popup']) {
		$cols[' '] = 'skip';
	}
$table =& new_db_pager('consignee_branch_tbl', $sql, $cols, 'consignee_branch');
$table->set_inactive_ctrl('consignee_branch', 'consignee_branch_code');

//$table->width = "85%";
display_db_pager($table);
}
else
	display_note(_("The selected consignee does not have any consignee_branches. Please create at least one consignee_branch."));

tabbed_content_start('tabs', array(
		'settings' => array(_('&General settings'), $selected_id!=-1),
		'contacts' => array(_('&Contacts'), $selected_id!=-1),
//		'orders' => array('S&ales orders', $selected_id!=-1) // not implemented
	));
	
	switch (get_post('_tabs_sel')) {
		default:
		case 'settings':
			consignee_branch_settings($selected_id); 
			break;
		case 'contacts':
			$contacts = new contacts('contacts', $selected_id, 'consignee_branch');
			$contacts->show();
			break;
		case 'orders':
	};
	hidden('consignee_branch_code');
	hidden('selected_id', $selected_id);
br();
tabbed_content_end();


end_form();

end_page(@$_REQUEST['popup']);

?>

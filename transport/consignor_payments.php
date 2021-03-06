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
$page_security = 'SA_TRANSPORTPAYMNT';
$path_to_root = "..";
include_once($path_to_root . "/includes/ui/allocation_cart.inc");
include_once($path_to_root . "/includes/session.inc");
include_once($path_to_root . "/includes/date_functions.inc");
include_once($path_to_root . "/includes/ui.inc");
include_once($path_to_root . "/includes/banking.inc");
include_once($path_to_root . "/includes/data_checks.inc");
include_once($path_to_root . "/transport/includes/transport_db.inc");
include_once($path_to_root . "/reporting/includes/reporting.inc");

$js = "";
if ($use_popup_windows) {
	$js .= get_js_open_window(900, 500);
}
if ($use_date_picker) {
	$js .= get_js_date_picker();
}
add_js_file('payalloc.js');

page(_($help_context = "Consignor Payment Entry"), false, false, "", $js);

//----------------------------------------------------------------------------------------------

check_db_has_consignors(_("There are no consignors defined in the system."));

check_db_has_bank_accounts(_("There are no bank accounts defined in the system."));

//----------------------------------------------------------------------------------------
if (isset($_GET['consignor_id']))
{
	$_POST['consignor_id'] = $_GET['consignor_id'];
}

if (!isset($_POST['bank_account'])) { // first page call
	$_SESSION['alloc'] = new allocation(ST_CONSIGNORPAYMENT, 0, get_post('consignor_id'));

	if (isset($_GET['SInvoice'])) {
		//  get date and supplier
		$inv = get_consignor_trans($_GET['SInvoice'], ST_TRANSPORTINVOICE);
		$dflt_act = get_default_bank_account($inv['curr_code']);
		$_POST['bank_account'] = $dflt_act['id'];
		if($inv) {
			$_SESSION['alloc']->person_id = $_POST['consignor_id'] = $inv['consignor_no'];
			$_SESSION['alloc']->read();
			$_POST['DateBanked'] = sql2date($inv['tran_date']);
			foreach($_SESSION['alloc']->allocs as $line => $trans) {
				if ($trans->type == ST_TRANSPORTINVOICE && $trans->type_no == $_GET['SInvoice']) {
					$un_allocated = $trans->amount - $trans->amount_allocated;
					if ($un_allocated){
						$_SESSION['alloc']->allocs[$line]->current_allocated = $un_allocated;
						$_POST['amount'] = $_POST['amount'.$line] = price_format($un_allocated);
					}
					break;
				}
			}
			unset($inv);
		} else
			display_error(_("Invalid transport invoice number."));
	}
}

if (list_updated('BranchID')) {
	// when branch is selected via external editor also consignor can change
	$br = get_branch(get_post('BranchID'));
	$_POST['consignor_id'] = $br['consignor_no'];
	$_SESSION['alloc']->person_id = $br['consignor_no'];
	$Ajax->activate('consignor_id');
}

if (!isset($_POST['consignor_id'])) {
	$_SESSION['alloc']->person_id = $_POST['consignor_id'] = get_global_consignor(false);
	$_SESSION['alloc']->read();
}
if (!isset($_POST['DateBanked'])) {
	$_POST['DateBanked'] = new_doc_date();
	if (!is_date_in_fiscalyear($_POST['DateBanked'])) {
		$_POST['DateBanked'] = end_fiscalyear();
	}
}


if (isset($_GET['AddedID'])) {
	$payment_no = $_GET['AddedID'];

	display_notification_centered(_("The consignor payment has been successfully entered."));

	submenu_print(_("&Print This Receipt"), ST_CONSIGNORPAYMENT, $payment_no."-".ST_CONSIGNORPAYMENT, 'prtopt');

	submenu_view(_("&View this Consignor Payment"), ST_CONSIGNORPAYMENT, $payment_no);

	submenu_option(_("Enter Another &Consignor Payment"), "/transport/consignor_payments.php");
	submenu_option(_("Enter Other &Deposit"), "/gl/gl_bank.php?NewDeposit=Yes");
	submenu_option(_("Enter Payment to &Vendor"), "/purchasing/supplier_payment.php");
	submenu_option(_("Enter Other &Payment"), "/gl/gl_bank.php?NewPayment=Yes");
	submenu_option(_("Bank Account &Transfer"), "/gl/bank_transfer.php");

	display_note(get_gl_view_str(ST_CONSIGNORPAYMENT, $payment_no, _("&View the GL Journal Entries for this Consignor Payment")));

	display_footer_exit();
}
elseif (isset($_GET['UpdatedID'])) {
	$payment_no = $_GET['UpdatedID'];

	display_notification_centered(_("The consignor payment has been successfully updated."));

	submenu_print(_("&Print This Receipt"), ST_CONSIGNORPAYMENT, $payment_no."-".ST_CONSIGNORPAYMENT, 'prtopt');

	display_note(get_gl_view_str(ST_CONSIGNORPAYMENT, $payment_no, _("&View the GL Journal Entries for this Consignor Payment")));

//	hyperlink_params($path_to_root . "/transport/allocations/consignor_allocate.php", _("&Allocate this Consignor Payment"), "trans_no=$payment_no&trans_type=12");

	hyperlink_no_params($path_to_root . "/transport/inquiry/consignor_inquiry.php?", _("Select Another Consignor Payment for &Edition"));

	hyperlink_no_params($path_to_root . "/transport/consignor_payments.php", _("Enter Another &Consignor Payment"));

	display_footer_exit();
}

//----------------------------------------------------------------------------------------------

function can_process()
{
	global $Refs;

	if (!get_post('consignor_id'))
	{
		display_error(_("There is no consignor selected."));
		set_focus('consignor_id');
		return false;
	} 
	
	if (!get_post('BranchID'))
	{
		display_error(_("This consignor has no branch defined."));
		set_focus('BranchID');
		return false;
	} 
	
	if (!isset($_POST['DateBanked']) || !is_date($_POST['DateBanked'])) {
		display_error(_("The entered date is invalid. Please enter a valid date for the payment."));
		set_focus('DateBanked');
		return false;
	} elseif (!is_date_in_fiscalyear($_POST['DateBanked'])) {
		display_error(_("The entered date is not in fiscal year."));
		set_focus('DateBanked');
		return false;
	}

	if (!$Refs->is_valid($_POST['ref'])) {
		display_error(_("You must enter a reference."));
		set_focus('ref');
		return false;
	}

	//Chaitanya : 13-OCT-2011 - To support Edit feature
	if (isset($_POST['trans_no']) && $_POST['trans_no'] == 0 && (!is_new_reference($_POST['ref'], ST_CONSIGNORPAYMENT))) {
		display_error(_("The entered reference is already in use."));
		set_focus('ref');
		return false;
	}
	//Avoid duplicate reference while modifying
	elseif ($_POST['ref'] != $_POST['old_ref'] && !is_new_reference($_POST['ref'], ST_CONSIGNORPAYMENT))
	{
		display_error( _("The entered reference is already in use."));
		set_focus('ref');
		return false;
	}

	if (!check_num('amount', 0)) {
		display_error(_("The entered amount is invalid or negative and cannot be processed."));
		set_focus('amount');
		return false;
	}

	if (isset($_POST['charge']) && !check_num('charge', 0)) {
		display_error(_("The entered amount is invalid or negative and cannot be processed."));
		set_focus('charge');
		return false;
	}
	if (isset($_POST['charge']) && input_num('charge') > 0) {
		$charge_acct = get_company_pref('bank_charge_act');
		if (get_gl_account($charge_acct) == false) {
			display_error(_("The Bank Charge Account has not been set in System and General GL Setup."));
			set_focus('charge');
			return false;
		}	
	}

//	if (isset($_POST['_ex_rate']) && !check_num('_ex_rate', 0.000001))
//	{
//		display_error(_("The exchange rate must be numeric and greater than zero."));
//		set_focus('_ex_rate');
//		return false;
//	}

	if (@$_POST['discount'] == "") 
	{
		$_POST['discount'] = 0;
	}

	if (!check_num('discount')) {
		display_error(_("The entered discount is not a valid number."));
		set_focus('discount');
		return false;
	}

	//if ((input_num('amount') - input_num('discount') <= 0)) {
	if (input_num('amount') <= 0) {
		display_error(_("The balance of the amount and discount is zero or negative. Please enter valid amounts."));
		set_focus('discount');
		return false;
	}

	if (isset($_POST['bank_amount']) && input_num('bank_amount')<=0)
	{
		display_error(_("The entered payment amount is zero or negative."));
		set_focus('bank_amount');
		return false;
	}

	if (!db_has_currency_rates(get_consignor_currency($_POST['consignor_id']), $_POST['DateBanked'], true))
		return false;

	$_SESSION['alloc']->amount = input_num('amount');

	if (isset($_POST["TotalNumberOfAllocs"]))
		return check_allocations();
	else
		return true;
}

//----------------------------------------------------------------------------------------------

if (isset($_POST['_consignor_id_button'])) {
//	unset($_POST['branch_id']);
	$Ajax->activate('BranchID');
}
//if (isset($_POST['_DateBanked_changed'])) {
//  $Ajax->activate('_ex_rate');
//}

//----------------------------------------------------------------------------------------------

if (get_post('AddPaymentItem') && can_process()) {

	new_doc_date($_POST['DateBanked']);

	$new_pmt = !$_SESSION['alloc']->trans_no;
	//Chaitanya : 13-OCT-2011 - To support Edit feature
	$payment_no = write_consignor_payment($_SESSION['alloc']->trans_no, $_POST['consignor_id'], $_POST['BranchID'],
		$_POST['bank_account'], $_POST['DateBanked'], $_POST['ref'],
		input_num('amount'), input_num('discount'), $_POST['memo_'], 0, input_num('charge'), input_num('bank_amount', input_num('amount')));

	$_SESSION['alloc']->trans_no = $payment_no;
	$_SESSION['alloc']->write();

	unset($_SESSION['alloc']);
	meta_forward($_SERVER['PHP_SELF'], $new_pmt ? "AddedID=$payment_no" : "UpdatedID=$payment_no");
}

//----------------------------------------------------------------------------------------------

function read_consignor_data()
{
	global $Refs;

	$myrow = get_consignor_habit($_POST['consignor_id']);

	$_POST['HoldAccount'] = $myrow["dissallow_invoices"];
	$_POST['pymt_discount'] = $myrow["pymt_discount"];
	//Chaitanya : 13-OCT-2011 - To support Edit feature
	//If page is called first time and New entry fetch the nex reference number
	if (!$_SESSION['alloc']->trans_no && !isset($_POST['charge'])) 
		$_POST['ref'] = $Refs->get_next(ST_CONSIGNORPAYMENT);
}

//----------------------------------------------------------------------------------------------
$new = 1;
$old_ref = 0;

//Chaitanya : 13-OCT-2011 - To support Edit feature
if (isset($_GET['trans_no']) && $_GET['trans_no'] > 0 )
{
	$_POST['trans_no'] = $_GET['trans_no'];

	$new = 0;
	$myrow = get_consignor_trans($_POST['trans_no'], ST_CONSIGNORPAYMENT);
	$_POST['consignor_id'] = $myrow["consignor_no"];
	$_POST['consignor_name'] = $myrow["ConsignorName"];
	$_POST['BranchID'] = $myrow["branch_code"];
	$_POST['bank_account'] = $myrow["bank_act"];
	$_POST['ref'] =  $myrow["reference"];
	$old_ref = $myrow["reference"];
	$charge = get_consignor_bank_charge(ST_CONSIGNORPAYMENT, $_POST['trans_no']);
	$_POST['charge'] =  price_format($charge);
	$_POST['DateBanked'] =  sql2date($myrow['tran_date']);
	$_POST["amount"] = price_format($myrow['Total'] - $myrow['ov_discount']);
	$_POST["bank_amount"] = price_format($myrow['bank_amount']+$charge);
	$_POST["discount"] = price_format($myrow['ov_discount']);
	$_POST["memo_"] = get_comments_string(ST_CONSIGNORPAYMENT,$_POST['trans_no']);

	//Prepare allocation cart 
	if (isset($_POST['trans_no']) && $_POST['trans_no'] > 0 )
		$_SESSION['alloc'] = new allocation(ST_CONSIGNORPAYMENT,$_POST['trans_no']);
	else
	{
		$_SESSION['alloc'] = new allocation(ST_CONSIGNORPAYMENT,0);
		$Ajax->activate('alloc_tbl');
	}
}

//----------------------------------------------------------------------------------------------
$new = !$_SESSION['alloc']->trans_no;
start_form();

	hidden('trans_no');
	hidden('old_ref', $old_ref);

	start_outer_table(TABLESTYLE2, "width=60%", 5);

	table_section(1);

	bank_accounts_list_row(_("Into Bank Account:"), 'bank_account', null, true);

	if ($new)
		consignor_list_row(_("From Consignor:"), 'consignor_id', null, false, true);
	else {
		label_cells(_("From Consignor:"), $_SESSION['alloc']->person_name, "class='label'");
		hidden('consignor_id', $_POST['consignor_id']);
	}

	if (db_consignor_has_branches($_POST['consignor_id'])) {
		consignor_branches_list_row(_("Branch:"), $_POST['consignor_id'], 'BranchID', null, false, true, true);
	} else {
		hidden('BranchID', ANY_NUMERIC);
	}

	if (list_updated('consignor_id') || ($new && list_updated('bank_account'))) {
		$_SESSION['alloc']->set_person($_POST['consignor_id'], PT_CONSIGNOR);
		$_SESSION['alloc']->read();
		$_POST['memo_'] = $_POST['amount'] = $_POST['discount'] = '';
		$Ajax->activate('alloc_tbl');
	}

	read_consignor_data();

	set_global_consignor($_POST['consignor_id']);
	if (isset($_POST['HoldAccount']) && $_POST['HoldAccount'] != 0)	
		display_warning(_("This consignor account is on hold."));
	$display_discount_percent = percent_format($_POST['pymt_discount']*100) . "%";

	table_section(2);

	date_row(_("Date of Deposit:"), 'DateBanked', '', true, 0, 0, 0, null, true);

	ref_row(_("Reference:"), 'ref','' , null, '', ST_CONSIGNORPAYMENT);

	table_section(3);

	$comp_currency = get_company_currency();
	$consignor_currency = $_SESSION['alloc']->set_person($_POST['consignor_id'], PT_CONSIGNOR);
	if (!$consignor_currency)
		$consignor_currency = $comp_currency;
	$_SESSION['alloc']->currency = $bank_currency = get_bank_account_currency($_POST['bank_account']);

	if ($consignor_currency != $bank_currency)
	{
		amount_row(_("Payment Amount:"), 'bank_amount', null, '', $bank_currency);
	}

	amount_row(_("Bank Charge:"), 'charge', null, '', $bank_currency);

	end_outer_table(1);

	div_start('alloc_tbl');
	show_allocatable(false);
	div_end();

	start_table(TABLESTYLE, "width=60%");

	label_row(_("Consignor prompt payment discount :"), $display_discount_percent);

	amount_row(_("Amount of Discount:"), 'discount', null, '', $consignor_currency);

	amount_row(_("Amount:"), 'amount', null, '', $consignor_currency);

	textarea_row(_("Memo:"), 'memo_', null, 22, 4);
	end_table(1);

	if ($new)
		submit_center('AddPaymentItem', _("Add Payment"), true, '', 'default');
	else
		submit_center('AddPaymentItem', _("Update Payment"), true, '', 'default');

	br();

end_form();
end_page();
?>

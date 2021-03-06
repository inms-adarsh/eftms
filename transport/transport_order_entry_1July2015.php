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
//-----------------------------------------------------------------------------
//
//	Entry/Modify Loading Slips
//	Entry/Modify Transport Booking
//	Entry Direct Delivery
//	Entry Direct Invoice
//

$path_to_root = "..";
$page_security = 'SA_TRANSPORTORDER';

include_once($path_to_root . "/transport/includes/cart_class.inc");
include_once($path_to_root . "/includes/session.inc");
include_once($path_to_root . "/transport/includes/transport_ui.inc");
include_once($path_to_root . "/transport/includes/ui/transport_order_ui.inc");
include_once($path_to_root . "/transport/includes/transport_db.inc");
include_once($path_to_root . "/transport/includes/db/transport_types_db.inc");
include_once($path_to_root . "/reporting/includes/reporting.inc");
include_once($path_to_root . "/includes/ui/items_cart.inc");

set_page_security( @$_SESSION['Items']->trans_type,
	array(	ST_TRANSPORTORDER=>'SA_TRANSPORTORDER',
			ST_TRANSPORTQUOTE => 'SA_TRANSPORTQUOTE',
			ST_TRANSPORTBOOKING => 'SA_TRANSPORTQUOTE',
			ST_CONSIGNORDELIVERY => 'SA_TRANSPORTDELIVERY',
			ST_TRANSPORTINVOICE => 'SA_TRANSPORTINVOICE'),
	array(	'NewOrder' => 'SA_TRANSPORTORDER',
			'ModifyOrderNumber' => 'SA_TRANSPORTORDER',
			'AddedID' => 'SA_TRANSPORTORDER',
			'UpdatedID' => 'SA_TRANSPORTORDER',
			'NewQuotation' => 'SA_TRANSPORTQUOTE',
			'ModifyQuotationNumber' => 'SA_TRANSPORTQUOTE',
			'NewQuoteToTransportOrder' => 'SA_TRANSPORTQUOTE',
			'NewBooking' => 'SA_TRANSPORTQUOTE',
			'ModifyBookingNumber' => 'SA_TRANSPORTQUOTE',
			'NewBookingToQuoteOrder' => 'SA_TRANSPORTQUOTE',
			'AddedQU' => 'SA_TRANSPORTQUOTE',
			'UpdatedQU' => 'SA_TRANSPORTQUOTE',
			'AddedBO' => 'SA_TRANSPORTQUOTE',
			'UpdatedBO' => 'SA_TRANSPORTQUOTE',
			'NewDelivery' => 'SA_TRANSPORTDELIVERY',
			'AddedDN' => 'SA_TRANSPORTDELIVERY', 
			'NewInvoice' => 'SA_TRANSPORTINVOICE',
			'AddedDI' => 'SA_TRANSPORTINVOICE'
			)
);

$js = '';
$selected_id = -1;
if ($use_popup_windows) {
	$js .= get_js_open_window(900, 500);
}

if ($use_date_picker) {
	$js .= get_js_date_picker();
}

if (isset($_GET['NewDelivery']) && is_numeric($_GET['NewDelivery'])) {

	$_SESSION['page_title'] = _($help_context = "Direct Transport Delivery");
	create_cart(ST_CONSIGNORDELIVERY, $_GET['NewDelivery']);

} elseif (isset($_GET['NewInvoice']) && is_numeric($_GET['NewInvoice'])) {

	$_SESSION['page_title'] = _($help_context = "Direct Transport Invoice");
	create_cart(ST_TRANSPORTINVOICE, $_GET['NewInvoice']);

} elseif (isset($_GET['ModifyOrderNumber']) && is_numeric($_GET['ModifyOrderNumber'])) {

	$help_context = 'Modifying Bilty';
	$_SESSION['page_title'] = sprintf( _("Modifying Bilty # %d"), $_GET['ModifyOrderNumber']);
	create_cart(ST_TRANSPORTORDER, $_GET['ModifyOrderNumber']);

} elseif (isset($_GET['ModifyQuotationNumber']) && is_numeric($_GET['ModifyQuotationNumber'])) {

	$help_context = 'Modifying Loading Slip';
	$_SESSION['page_title'] = sprintf( _("Modifying Loading Slip # %d"), $_GET['ModifyQuotationNumber']);
	create_cart(ST_TRANSPORTQUOTE, $_GET['ModifyQuotationNumber']);

}
elseif (isset($_GET['ModifyBookingNumber']) && is_numeric($_GET['ModifyBookingNumber'])) {

	$help_context = 'Modifying Transport Booking';
	$_SESSION['page_title'] = sprintf( _("Modifying Transport Booking # %d"), $_GET['ModifyBookingNumber']);
	create_cart(ST_TRANSPORTBOOKING, $_GET['ModifyBookingNumber']);

} elseif (isset($_GET['NewOrder'])) {

	$_SESSION['page_title'] = _($help_context = "New Bilty Entry");
	create_cart(ST_TRANSPORTORDER, 0);
} elseif (isset($_GET['NewQuotation'])) {

	$_SESSION['page_title'] = _($help_context = "New Loading Slip Entry");
	create_cart(ST_TRANSPORTQUOTE, 0);
} elseif (isset($_GET['NewQuoteToTransportOrder'])) {
	$_SESSION['page_title'] = _($help_context = "Bilty Entry");
	create_cart(ST_TRANSPORTQUOTE, $_GET['NewQuoteToTransportOrder']);
}elseif (isset($_GET['NewBooking'])) {
	$_SESSION['page_title'] = _($help_context = "New Transport Booking Entry");
	
	//$ret = $_SESSION['Items']->write(1);
	//meta_forward($_SERVER['PHP_SELF'], "ModifyBookingNumber=$ret");
		create_cart(ST_TRANSPORTBOOKING, 0);
} elseif (isset($_GET['NewBookingToQuoteOrder'])) {
	$_SESSION['page_title'] = _($help_context = "Loading Slip Entry");
	create_cart(ST_TRANSPORTBOOKING, $_GET['NewBookingToQuoteOrder']);
}

page($_SESSION['page_title'], false, false, "", $js);
//-----------------------------------------------------------------------------

if (list_updated('branch_id')) {
	// when branch is selected via external editor also consignor can change
	$br = get_branch(get_post('branch_id'));
	$_POST['consignor_id'] = $br['consignor_no'];
	$Ajax->activate('consignor_id');
}

if (list_updated('consignee_branch')) {
	// when branch is selected via external editor also consignor can change
	$br = get_consignee_branch(get_post('consignee_branch'));
	$_POST['consignee_id'] = $br['consignee_no'];
	$Ajax->activate('consignee_id');
}
if (isset($_GET['AddedID'])) {
	$order_no = $_GET['AddedID'];
	display_notification_centered(sprintf( _("Bilty # %d has been entered."),$order_no));

	submenu_view(_("&View This Bilty"), ST_TRANSPORTORDER, $order_no);

	submenu_print(_("&Print This Bilty"), ST_TRANSPORTORDER, $order_no, 'prtopt');
	submenu_print(_("&Email This Bilty"), ST_TRANSPORTORDER, $order_no, null, 1);
	set_focus('prtopt');
	
	submenu_option(_("Generate &Delivery Against This Bilty"),
		"/transport/consignor_delivery.php?OrderNumber=$order_no");

	//submenu_option(_("Work &Order Entry"),	"/manufacturing/work_order_entry.php?");

	submenu_option(_("Enter a &New Bilty"),	"/transport/transport_order_entry.php?NewOrder=0");

	display_footer_exit();

} elseif (isset($_GET['UpdatedID'])) {
	$order_no = $_GET['UpdatedID'];

	display_notification_centered(sprintf( _("Bilty # %d has been updated."),$order_no));

	submenu_view(_("&View This Bilty"), ST_TRANSPORTORDER, $order_no);

	submenu_print(_("&Print This Bilty"), ST_TRANSPORTORDER, $order_no, 'prtopt');
	submenu_print(_("&Email This Bilty"), ST_TRANSPORTORDER, $order_no, null, 1);
	set_focus('prtopt');

	submenu_option(_("Confirm Bilty Quantities and Make &Delivery"),
		"/transport/consignor_delivery.php?OrderNumber=$order_no");

	submenu_option(_("Select A Different &Bilty"),
		"/transport/inquiry/transport_orders_view.php?OutstandingOnly=1");

	display_footer_exit();

} elseif (isset($_GET['AddedQU'])) {
	$order_no = $_GET['AddedQU'];
	display_notification_centered(sprintf( _("Loading Slip # %d has been entered."),$order_no));

	submenu_view(_("&View This Loading Slip"), ST_TRANSPORTQUOTE, $order_no);

	submenu_print(_("&Print This Loading Slip"), ST_TRANSPORTQUOTE, $order_no, 'prtopt');
	submenu_print(_("&Email This Loading Slip"), ST_TRANSPORTQUOTE, $order_no, null, 1);
	set_focus('prtopt');
	
	submenu_option(_("Generate &Bilty Against This Loading Slip"),
		"/transport/transport_order_entry.php?NewQuoteToTransportOrder=$order_no");

	//submenu_option(_("Loading Slip"),	"/transport/transport_order_entry.php?NewQuotation=0");

	display_footer_exit();

} elseif (isset($_GET['UpdatedQU'])) {
	$order_no = $_GET['UpdatedQU'];

	display_notification_centered(sprintf( _("Loading Slip # %d has been updated."),$order_no));

	submenu_view(_("&View This Loading Slip"), ST_TRANSPORTQUOTE, $order_no);

	submenu_print(_("&Print This Loading Slip"), ST_TRANSPORTQUOTE, $order_no, 'prtopt');
	submenu_print(_("&Email This Loading Slip"), ST_TRANSPORTQUOTE, $order_no, null, 1);
	set_focus('prtopt');

	submenu_option(_("Generate &Bilty Against This Loading Slip"),
		"/transport/transport_order_entry.php?NewQuoteToTransportOrder=$order_no");

	submenu_option(_("Select A Different &Loading Slip"),
		"/transport/inquiry/transport_orders_view.php?type=".ST_TRANSPORTQUOTE);

	display_footer_exit();
} 
elseif (isset($_GET['AddedBO'])) {
	$order_no = $_GET['AddedBO'];
	display_notification_centered(sprintf( _("Booking # %d has been entered."),$order_no));
	
	submenu_view(_("&View This Booking"), ST_TRANSPORTBOOKING, $order_no);

	submenu_print(_("&Print This Booking"), ST_TRANSPORTBOOKING, $order_no, 'prtopt');
	submenu_print(_("&Email This Booking"), ST_TRANSPORTBOOKING, $order_no, null, 1);
	set_focus('prtopt');
	
	submenu_option(_("Generate &Loading Slip Against This Booking"),
		"/transport/transport_order_entry.php?NewBookingToQuoteOrder=$order_no");

	submenu_option(_("Enter a New &Booking"),	"/transport/transport_order_entry.php?NewBooking=0");

	display_footer_exit();

} elseif (isset($_GET['UpdatedBO'])) {
	$order_no = $_GET['UpdatedBO'];

	display_notification_centered(sprintf( _("Booking # %d has been updated."),$order_no));

	submenu_view(_("&View This Booking"), ST_TRANSPORTBOOKING, $order_no);

	submenu_print(_("&Print This Booking"), ST_TRANSPORTBOOKING, $order_no, 'prtopt');
	submenu_print(_("&Email This Booking"), ST_TRANSPORTBOOKING, $order_no, null, 1);
	set_focus('prtopt');

	submenu_option(_("Generate &Loading Slip Against This Booking"),
		"/transport/transport_order_entry.php?NewBookingToQuoteOrder=$order_no");

	submenu_option(_("Select A Different &Booking"),
		"/transport/inquiry/transport_orders_view.php?type=".ST_TRANSPORTBOOKING);

	display_footer_exit();
}elseif (isset($_GET['AddedDN'])) {
	$delivery = $_GET['AddedDN'];

	display_notification_centered(sprintf(_("Delivery # %d has been entered."),$delivery));

	submenu_view(_("&View This Delivery"), ST_CONSIGNORDELIVERY, $delivery);

	submenu_print(_("&Print Delivery Note"), ST_CONSIGNORDELIVERY, $delivery, 'prtopt');
	submenu_print(_("&Email Delivery Note"), ST_CONSIGNORDELIVERY, $delivery, null, 1);
	submenu_print(_("P&rint as Packing Slip"), ST_CONSIGNORDELIVERY, $delivery, 'prtopt', null, 1);
	submenu_print(_("E&mail as Packing Slip"), ST_CONSIGNORDELIVERY, $delivery, null, 1, 1);
	set_focus('prtopt');

	display_note(get_gl_view_str(ST_CONSIGNORDELIVERY, $delivery, _("View the GL Journal Entries for this Dispatch")),0, 1);

	submenu_option(_("Generate &Invoice Against This Delivery"),
		"/transport/consignor_invoice.php?DeliveryNumber=$delivery");

	if ((isset($_GET['Type']) && $_GET['Type'] == 1))
		submenu_option(_("Enter a New Template &Delivery"),
			"/transport/inquiry/transport_orders_view.php?DeliveryTemplates=Yes");
	// else
	//	submenu_option(_("Enter a &New Delivery"), 
	//		"/transport/transport_order_entry.php?NewDelivery=0");

	display_footer_exit();

} elseif (isset($_GET['AddedDI'])) {
	$invoice = $_GET['AddedDI'];

	display_notification_centered(sprintf(_("Invoice # %d has been entered."), $invoice));

	submenu_view(_("&View This Invoice"), ST_TRANSPORTINVOICE, $invoice);

	submenu_print(_("&Print Transport Invoice"), ST_TRANSPORTINVOICE, $invoice."-".ST_TRANSPORTINVOICE, 'prtopt');
	submenu_print(_("&Email Transport Invoice"), ST_TRANSPORTINVOICE, $invoice."-".ST_TRANSPORTINVOICE, null, 1);
	set_focus('prtopt');
	
	$sql = "SELECT trans_type_from, trans_no_from FROM ".TB_PREF."consignor_allocations
			WHERE trans_type_to=".ST_TRANSPORTINVOICE." AND trans_no_to=".db_escape($invoice);
	$result = db_query($sql, "could not retrieve consignor allocation");
	$row = db_fetch($result);
	if ($row !== false)
		submenu_print(_("Print &Receipt"), $row['trans_type_from'], $row['trans_no_from']."-".$row['trans_type_from'], 'prtopt');

	display_note(get_gl_view_str(ST_TRANSPORTINVOICE, $invoice, _("View the GL &Journal Entries for this Invoice")),0, 1);

	if ((isset($_GET['Type']) && $_GET['Type'] == 1))
		submenu_option(_("Enter a &New Template Invoice"), 
			"/transport/inquiry/transport_orders_view.php?InvoiceTemplates=Yes");
	//else
	//	submenu_option(_("Enter a &New Direct Invoice"),
	//		"/transport/transport_order_entry.php?NewInvoice=0");

	submenu_option(_("Add an Attachment"), "/admin/attachments.php?filterType=".ST_TRANSPORTINVOICE."&trans_no=$invoice");

	display_footer_exit();
} else
	check_edit_conflicts();
//-----------------------------------------------------------------------------

function copy_to_cart()
{
	$cart = &$_SESSION['Items'];

	$cart->reference = $_POST['ref'];

	$cart->Comments =  $_POST['Comments'];

	$cart->document_date = $_POST['OrderDate'];

	$newpayment = false;

	if (isset($_POST['payment']) && ($cart->payment != $_POST['payment'])) {
		$cart->payment = $_POST['payment'];
		$cart->payment_terms = get_payment_terms($_POST['payment']);
		$newpayment = true;
	}
	if($_SESSION['Items']->trans_type!=ST_TRANSPORTQUOTE && $_SESSION['Items']->trans_type!=ST_TRANSPORTBOOKING)
	{
		$cart->consignor_tin_no = $_POST['consignor_tin_no'];
		$cart->consignee_tin_no = $_POST['consignee_tin_no'];
		$cart->freight_cost = input_num('ship_cost')+input_num('commission_cost')+input_num('way_cost')+input_num('bilty_charge')+input_num('insc_charge')+input_num('labour_charge');
		$cart->commission_cost = input_num('commission_cost');
		$cart->way_cost = input_num('way_cost');
		$cart->bilty_charge = input_num('bilty_charge');
		$cart->insc_charge = input_num('insc_charge');
		$cart->labour_charge = input_num('labour_charge');
		$cart->ship_cost = input_num('ship_cost');
	//	$cart->service_tax_paid = $_POST['add_service_tax'];
		$cart->consignor_id	= $_POST['consignor_id'];
		$cart->Branch = $_POST['branch_id'];
		$cart->consignee_id	= $_POST['consignee_id'];
		$cart->service_tax_by = $_POST['service_tax_by'];
		$cart->payment_by = $_POST['payment_by'];
	//	$cart->service_tax_paid = $_POST['add_service_tax'];
		$cart->consignee_branch = $_POST['consignee_branch_id'];
		//$cart->transport_type = $_POST['transport_type'];
		$cart->ex_rate = input_num('_ex_rate', null);
		$cart->deliver_to = $_POST['deliver_to'];
		$cart->delivery_address = $_POST['delivery_address'];
		$cart->total_goods_value = input_num('total_goods_value');
		$cart->goods_bill_no = $_POST["goods_bill_no"];
		$cart->ship_via = $_POST['ship_via'];
		$cart->due_date = $_POST['delivery_date'];
	}
	if($_SESSION['Items']->trans_type!=ST_TRANSPORTBOOKING)
	{
		$cart->driver_id =$_POST['driver_id'] ;
		$cart->driver_ref =$_POST['driver_ref'] ;
		$cart->vehicle_id=$_POST['vehicle_id'];

		$cart->loaded_from = $_POST['loaded_from'];
		$cart->loading_address = $_POST['loading_address'];
	}
		
		
		$cart->consignor_ref = $_POST['consignor_ref'];
		
		$cart->phone = $_POST['phone'];
		
	
		//$cart->total_goods_value=$_POST['total_goods_value'];
	$cart->Location = $_POST['Location'];
	$cart->Location_to = $_POST['Location_to'];
	
	if (isset($_POST['email']))
		$cart->email =$_POST['email'];
	else
		$cart->email = '';

}

//-----------------------------------------------------------------------------

function copy_from_cart()
{
	$cart = &$_SESSION['Items'];
	$_POST['ref'] = $cart->reference;
	$_POST['Comments'] = $cart->Comments;

	$_POST['OrderDate'] = $cart->document_date;
	$_POST['delivery_date'] = $cart->due_date;
	$_POST['consignor_ref'] = $cart->consignor_ref;
	$_POST['consignee_ref'] = $cart->consignor_ref;
	$_POST['ship_cost'] = price_format($cart->ship_cost);
	$_POST['commission_cost'] = price_format($cart->commission_cost);
	$_POST['way_cost'] = price_format($cart->way_cost);
	$_POST['insc_charge'] = price_format($cart->insc_charge);
	$_POST['bilty_charge'] = price_format($cart->bilty_charge);
	$_POST['labour_charge'] = price_format($cart->labour_charge);
	$_POST['add_service_tax']= $cart->service_tax_paid;
	$_POST['payment_by']= $cart->payment_by;
	$_POST['service_tax_by']= $cart->service_tax_by;
	$_POST['consignor_tin_no'] = $cart->consignor_tin_no;
		$_POST['consignee_tin_no'] = $cart->consignee_tin_no ;
		$_POST['goods_bill_no'] = $cart->goods_bill_no ;
		$_POST['total_goods_value'] = price_format($cart->total_goods_value);
	$_POST['deliver_to'] = $cart->deliver_to;
	$_POST['delivery_address'] = $cart->delivery_address;
	$_POST['loaded_from'] = $cart->loaded_from;
	$_POST['loading_address'] = $cart->loading_address;
	$_POST['phone'] = $cart->phone;
	$_POST['driver_id'] = $cart->driver_id;
	$_POST['driver_ref'] = $cart->driver_ref;
	$_POST['vehicle_id'] = $cart->vehicle_id;
	$_POST['Location'] = $cart->Location;
	$_POST['Location_to'] = $cart->Location_to;
	
	$_POST['ship_via'] = $cart->ship_via;

	$_POST['consignor_id'] = $cart->consignor_id;

	$_POST['branch_id'] = $cart->Branch;
	$_POST['consignee_id'] = $cart->consignee_id;

	$_POST['consignee_branch_id'] = $cart->consignee_branch;
	
	$_POST['transport_type'] = $cart->transport_type;
	// POS 
	$_POST['payment'] = $cart->payment;
	if ($cart->trans_type!=ST_TRANSPORTORDER && $cart->trans_type!=ST_TRANSPORTQUOTE && $cart->trans_type!= ST_TRANSPORTBOOKING) { // 2008-11-12 Joe Hunt
		$_POST['dimension_id'] = $cart->dimension_id;
		$_POST['dimension2_id'] = $cart->dimension2_id;
	}
	$_POST['cart_id'] = $cart->cart_id;
	$_POST['_ex_rate'] = $cart->ex_rate;
}
//--------------------------------------------------------------------------------

function line_start_focus() {
  global 	$Ajax;

  $Ajax->activate('items_table');
  set_focus('_stock_id_edit');
}

function stop_start_focus() {
  global 	$Ajax;

  $Ajax->activate('load_stops');
}

//--------------------------------------------------------------------------------
function can_process() {
	global $Refs;

	if (!get_post('consignor_id') && $_SESSION['Items']->trans_type!=ST_TRANSPORTQUOTE && $_SESSION['Items']->trans_type!=ST_TRANSPORTBOOKING ) 
	{
		display_error(_("There is no consignor selected."));
		set_focus('consignor_id');
		return false;
	} 
	
	if (!get_post('branch_id') && $_SESSION['Items']->trans_type!=ST_TRANSPORTQUOTE && $_SESSION['Items']->trans_type!=ST_TRANSPORTBOOKING ) 
	{
		display_error(_("This consignor has no branch defined."));
		set_focus('branch_id');
		return false;
	} 
	if (!get_post('consignee_id') && $_SESSION['Items']->trans_type!=ST_TRANSPORTQUOTE && $_SESSION['Items']->trans_type != ST_TRANSPORTBOOKING) 
	{
		display_error(_("There is no consignee selected."));
		set_focus('consignee_id');
		return false;
	} 
	
	if (!get_post('consignee_branch_id') && $_SESSION['Items']->trans_type!=ST_TRANSPORTQUOTE && $_SESSION['Items']->trans_type != ST_TRANSPORTBOOKING) 
	{
		display_error(_("This consignee has no branch defined."));
		set_focus('consignee_branch_id');
		return false;
	} 
	if (get_post('Location') == get_post('Location_to'))
	{
		display_error(_("The locations to transfer from and to must be different."));
		set_focus('Location_to');
		return false;
	} 
	if ($_SESSION['Items']->trans_type != ST_TRANSPORTBOOKING && !get_post('driver_id')) 
	{
		display_error(_("This is no driver selected."));
		set_focus('driver_id');
		return false;
	} 
	if ($_SESSION['Items']->trans_type != ST_TRANSPORTBOOKING && !get_post('driver_ref')) 
	{
		display_error(_("Please enter Contact Number of driver."));
		set_focus('driver_ref');
		return false;
	} 
	 if ($_SESSION['Items']->trans_type != ST_TRANSPORTBOOKING && !get_post('vehicle_id')) 
	 {
		display_error(_("This is no vehicle selected."));
		set_focus('vehicle_id');
		return false;
	} 
	if (!is_date($_POST['OrderDate'])) {
		display_error(_("The entered date is invalid."));
		set_focus('OrderDate');
		return false;
	}
	if ($_SESSION['Items']->trans_type!=ST_TRANSPORTQUOTE && $_SESSION['Items']->trans_type != ST_TRANSPORTBOOKING && !is_date_in_fiscalyear($_POST['OrderDate'])) {
		display_error(_("The entered date is not in fiscal year"));
		set_focus('OrderDate');
		return false;
	}
	if (count($_SESSION['Items']->line_items) == 0 && $_SESSION['Items']->trans_type!=ST_TRANSPORTBOOKING && $_SESSION['Items']->trans_type!=ST_TRANSPORTQUOTE)	{
		display_error(_("You must enter at least one non empty item line."));
		set_focus('AddItem');
		return false;
	}
	
	if (strlen(get_post('deliver_to')) <= 1 && $_SESSION['Items']->trans_type!=ST_TRANSPORTBOOKING && $_SESSION['Items']->trans_type!=ST_TRANSPORTQUOTE) {
		display_error(_("You must enter the person or company to whom delivery should be made to."));
		set_focus('deliver_to');
		return false;
	}


	if (strlen(get_post('delivery_address')) <= 1 && $_SESSION['Items']->trans_type!=ST_TRANSPORTBOOKING && $_SESSION['Items']->trans_type!=ST_TRANSPORTQUOTE) {
			display_error( _("You should enter the street address in the box provided. Orders cannot be accepted without a valid street address."));
			set_focus('delivery_address');
			return false;
	}
	if (strlen(get_post('loaded_from')) <= 1 && $_SESSION['Items']->trans_type!=ST_TRANSPORTBOOKING && $_SESSION['Items']->trans_type!=ST_TRANSPORTORDER) {
		display_error(_("You must enter the person or company from whom loading should be made to."));
		set_focus('loaded_from');
		return false;
	}


	if (strlen(get_post('loading_address')) <= 1 && $_SESSION['Items']->trans_type!=ST_TRANSPORTBOOKING && $_SESSION['Items']->trans_type!=ST_TRANSPORTORDER) {
			display_error( _("You should enter the street address in the box provided. Orders cannot be accepted without a valid street address."));
			set_focus('loading_address');
			return false;
	}
	if (strlen($_POST['consignor_ref']) <= 1) {
			display_error( _("You should enter the Contact Person name of Consignor."));
			set_focus('consignor_ref');
			return false;
	}
	if (strlen($_POST['phone']) <= 1) {
			display_error( _("You should enter the Phone number of Contact Person of Consignor."));
			set_focus('phone');
			return false;
	}
	if ($_SESSION['Items']->payment_terms['cash_sale'] == 0 && $_SESSION['Items']->trans_type!=ST_TRANSPORTQUOTE && $_SESSION['Items']->trans_type!=ST_TRANSPORTBOOKING) {
	

		if ($_POST['ship_cost'] == "")
			$_POST['ship_cost'] = price_format(0);

		if (!check_num('ship_cost',0)) {
			display_error(_("The shipping cost entered is expected to be numeric."));
			set_focus('ship_cost');
			return false;
		}
		if (!is_date($_POST['delivery_date'])) {
			if ($_SESSION['Items']->trans_type==ST_TRANSPORTQUOTE && $_SESSION['Items']->trans_type==ST_TRANSPORTBOOKING)
				display_error(_("The Valid date is invalid."));
			else	
				display_error(_("The delivery date is invalid."));
			set_focus('delivery_date');
			return false;
		}
		//if (date1_greater_date2($_SESSION['Items']->document_date, $_POST['delivery_date'])) {
		if (date1_greater_date2($_POST['OrderDate'], $_POST['delivery_date'])) {
			if ($_SESSION['Items']->trans_type==ST_TRANSPORTQUOTE && $_SESSION['Items']->trans_type==ST_TRANSPORTBOOKING)
				display_error(_("The requested valid date is before the date of the quotation."));
			else	
				display_error(_("The requested delivery date is before the date of the order."));
			set_focus('delivery_date');
			return false;
		}
	}
	else
	{
		if (!db_has_cash_accounts())
		{
			display_error(_("You need to define a cash account for your Transport Point."));
			return false;
		}	
	}	
	if (!$Refs->is_valid($_POST['ref'])) {
		display_error(_("You must enter a reference."));
		set_focus('ref');
		return false;
	}

	
   	if ($_SESSION['Items']->get_items_total() < 0) {
		display_error("Invoice total amount cannot be less than zero.");
		return false;
	}
	return true;
}

//-----------------------------------------------------------------------------

if (isset($_POST['update'])) {
	copy_to_cart();
	$Ajax->activate('items_table');
}

if (isset($_POST['ProcessOrder']) && can_process()) {
	copy_to_cart();
	$modified = ($_SESSION['Items']->trans_no != 0);
	$so_type = $_SESSION['Items']->so_type;

	$ret = $_SESSION['Items']->write(1);
	if ($ret == -1)
	{
		display_error(_("The entered reference is already in use."));
		$ref = get_next_reference($_SESSION['Items']->trans_type);
		if ($ref != $_SESSION['Items']->reference)
		{
			display_error(_("The reference number field has been increased. Please save the document again."));
			$_POST['ref'] = $_SESSION['Items']->reference = $ref;
			$Ajax->activate('ref');
		}	
		set_focus('ref');
	}
	else
	{
		if (count($messages)) { // abort on failure or error messages are lost
			$Ajax->activate('_page_body');
			display_footer_exit();
		}
		$trans_no = key($_SESSION['Items']->trans_no);
		$trans_type = $_SESSION['Items']->trans_type;
		new_doc_date($_SESSION['Items']->document_date);
		processing_end();
		if ($modified) {
			if ($trans_type == ST_TRANSPORTQUOTE)
			meta_forward($_SERVER['PHP_SELF'], "UpdatedQU=$trans_no");
			elseif($trans_type == ST_TRANSPORTBOOKING)
				meta_forward($_SERVER['PHP_SELF'], "UpdatedBO=$trans_no");
			else	
				meta_forward($_SERVER['PHP_SELF'], "UpdatedID=$trans_no");
			
		}
		
		elseif ($trans_type == ST_TRANSPORTORDER) {
			meta_forward($_SERVER['PHP_SELF'], "AddedID=$trans_no");
		} elseif ($trans_type == ST_TRANSPORTQUOTE) {
			meta_forward($_SERVER['PHP_SELF'], "AddedQU=$trans_no");
		} 
		elseif ($trans_type == ST_TRANSPORTBOOKING) {
			meta_forward($_SERVER['PHP_SELF'], "AddedBO=$trans_no");
		} 
		elseif ($trans_type == ST_TRANSPORTINVOICE) {
			meta_forward($_SERVER['PHP_SELF'], "AddedDI=$trans_no&Type=$so_type");
		} else {
			meta_forward($_SERVER['PHP_SELF'], "AddedDN=$trans_no&Type=$so_type");
		}
	}	
}

//--------------------------------------------------------------------------------

function check_item_data()
{
	global $SysPrefs, $allow_negative_prices;
	
	$is_transportable_item = is_transportable_item(get_post('stock_id'));
	if(!get_post('stock_id_text', true)) {
		display_error( _("Item description cannot be empty."));
		set_focus('stock_id_edit');
		return false;
	}
	elseif (!check_num('qty', 0) || !check_num('Disc', 0, 100) && $_SESSION['Items']->trans_type!=ST_TRANSPORTQUOTE && $_SESSION['Items']->trans_type!=ST_TRANSPORTBOOKING ) {
		display_error( _("The item could not be updated because you are attempting to set the quantity ordered to less than 0, or the discount percent to more than 100."));
		set_focus('qty');
		return false;
	} elseif (!check_num('price', 0) && (!$allow_negative_prices || $is_transportable_item) && $_SESSION['Items']->trans_type!=ST_TRANSPORTQUOTE && $_SESSION['Items']->trans_type!=ST_TRANSPORTBOOKING ) {
		display_error( _("Price for inventory item must be entered and can not be less than 0"));
		set_focus('price');
		return false;
	} elseif (isset($_POST['LineNo']) && isset($_SESSION['Items']->line_items[$_POST['LineNo']])
	    && !check_num('qty', $_SESSION['Items']->line_items[$_POST['LineNo']]->qty_done) && $_SESSION['Items']->trans_type!=ST_TRANSPORTQUOTE && $_SESSION['Items']->trans_type!=ST_TRANSPORTBOOKING ) {

		set_focus('qty');
		display_error(_("You attempting to make the quantity ordered a quantity less than has already been delivered. The quantity delivered cannot be modified retrospectively."));
		return false;
	} // Joe Hunt added 2008-09-22 -------------------------

	$cost_home = get_standard_cost(get_post('stock_id')); // Added 2011-03-27 Joe Hunt
	$cost = $cost_home / get_exchange_rate_from_home_currency($_SESSION['Items']->consignor_currency, $_SESSION['Items']->document_date);
	if (input_num('price') < $cost)
	{
		$dec = user_price_dec();
		$curr = $_SESSION['Items']->consignor_currency;
		$price = number_format2(input_num('price'), $dec);
		if ($cost_home == $cost)
			$std_cost = number_format2($cost_home, $dec);
		else
		{
			$price = $curr . " " . $price;
			$std_cost = $curr . " " . number_format2($cost, $dec);
		}
		display_warning(sprintf(_("Price %s is below Standard Cost %s"), $price, $std_cost));
	}	
	return true;
}

//--------------------------------------------------------------------------------

function handle_update_item()
{
	
	if ($_POST['UpdateItem'] != '' && check_item_data()) {
		$_SESSION['Items']->update_cart_item($_POST['LineNo'],
		 input_num('qty'), get_post('to_units'),input_num('price'),
		 input_num('Disc') / 100, $_POST['item_description'] );
	}
	page_modified();
  line_start_focus();
}

//--------------------------------------------------------------------------------

function handle_delete_item($line_no)
{
    if ($_SESSION['Items']->some_already_delivered($line_no) == 0) {
	    $_SESSION['Items']->remove_from_cart($line_no);
    } else {
	display_error(_("This item cannot be deleted because some of it has already been delivered."));
    }
    line_start_focus();
}

//--------------------------------------------------------------------------------

function handle_new_item()
{

	if (!check_item_data()) {
			return;
	}
	
	add_to_order($_SESSION['Items'], get_post('stock_id'), input_num('qty'),get_post('to_units'),
		input_num('price'), input_num('Disc') / 100, get_post('stock_id_text'));

	unset($_POST['_stock_id_edit'], $_POST['stock_id']);
	page_modified();
	line_start_focus();
}
function handle_new_stop()
{

	$_SESSION['Items']->add_load_stop(get_post('loc_code'),1,get_post('stop_contact'),get_post('stop_address'),get_post('stop_date'),get_post('stop_time'));
	page_modified();
	stop_start_focus();
}

//--------------------------------------------------------------------------------

function  handle_cancel_order()
{
	global $path_to_root, $Ajax;


	if ($_SESSION['Items']->trans_type == ST_CONSIGNORDELIVERY) {
		display_notification(_("Direct delivery entry has been cancelled as requested."), 1);
		submenu_option(_("Enter a New Transport Delivery"),	"/transport/transport_order_entry.php?NewDelivery=1");
	} elseif ($_SESSION['Items']->trans_type == ST_TRANSPORTINVOICE) {
		display_notification(_("Direct invoice entry has been cancelled as requested."), 1);
		submenu_option(_("Enter a New Transport Invoice"),	"/transport/transport_order_entry.php?NewInvoice=1");
	} elseif ($_SESSION['Items']->trans_type == ST_TRANSPORTQUOTE)
	{
		delete_transport_order(key($_SESSION['Items']->trans_no), $_SESSION['Items']->trans_type);
		display_notification(_("This loading slip has been cancelled as requested."), 1);
		submenu_option(_("Enter a New Loading Slip"), "/transport/transport_order_entry.php?NewQuotation=Yes");
	}
	elseif ($_SESSION['Items']->trans_type == ST_TRANSPORTBOOKING)
	{
		delete_transport_order(key($_SESSION['Items']->trans_no), $_SESSION['Items']->trans_type);
		display_notification(_("This booking has been cancelled as requested."), 1);
		submenu_option(_("Enter a New Booking"), "/transport/transport_order_entry.php?NewBooking=Yes");
	}
	else { // transport booking
		if ($_SESSION['Items']->trans_no != 0) {
			$order_no = key($_SESSION['Items']->trans_no);
			if (transport_order_has_deliveries($order_no))
			{
				close_transport_order($order_no);
				display_notification(_("Undelivered part of bilty has been cancelled as requested."), 1);
				submenu_option(_("Select Another Bilty for Edition"), "/transport/inquiry/transport_orders_view.php?type=".ST_TRANSPORTORDER);
			} else {
				delete_transport_order(key($_SESSION['Items']->trans_no), $_SESSION['Items']->trans_type);

				display_notification(_("This bilty has been cancelled as requested."), 1);
				//submenu_option(_("Enter a New Bilty"), "/transport/transport_order_entry.php?NewOrder=Yes");
			}
		} else {
			processing_end();
			meta_forward($path_to_root.'/index.php','application=orders');
		}
	}
	$Ajax->activate('_page_body');
	processing_end();
	display_footer_exit();
}

//--------------------------------------------------------------------------------

function create_cart($type, $trans_no)
{ 
	global $Refs;

	if (!$_SESSION['SysPrefs']->db_ok) // create_cart is called before page() where the check is done
		return;

	processing_start();

	if (isset($_GET['NewQuoteToTransportOrder']))
	{
		$trans_no = $_GET['NewQuoteToTransportOrder'];
		$doc = new Cart(ST_TRANSPORTQUOTE, $trans_no, true);
		$doc->Comments = _("Loading Slip") . " # " . $trans_no;
		$_SESSION['Items'] = $doc;
	}	
	elseif (isset($_GET['NewBookingToQuoteOrder']))
	{
		$trans_no = $_GET['NewBookingToQuoteOrder'];
		$doc = new Cart(ST_TRANSPORTBOOKING, $trans_no, true);
		$doc->Comments = _("Transport Booking") . " # " . $trans_no;
		$_SESSION['Items'] = $doc;
	}	
	elseif($type != ST_TRANSPORTORDER && $type != ST_TRANSPORTQUOTE && $type != ST_TRANSPORTBOOKING && $trans_no != 0) { // this is template

		$doc = new Cart(ST_TRANSPORTORDER, array($trans_no));
		$doc->trans_type = $type;
		$doc->trans_no = 0;
		$doc->document_date = new_doc_date();
		if ($type == ST_TRANSPORTINVOICE) {
			$doc->due_date = get_invoice_duedate($doc->payment, $doc->document_date);
			$doc->pos = get_transport_point(user_pos());
		} else
			$doc->due_date = $doc->document_date;
		$doc->reference = $Refs->get_next($doc->trans_type);
		//$doc->Comments='';
		foreach($doc->line_items as $line_no => $line) {
			$doc->line_items[$line_no]->qty_done = 0;
		}
		$_SESSION['Items'] = $doc;
	} else
		$_SESSION['Items'] = new Cart($type, array($trans_no));
	copy_from_cart();
}

//--------------------------------------------------------------------------------

if (isset($_POST['CancelOrder']))
	handle_cancel_order();

$id = find_submit('Delete');
if ($id!=-1)
	handle_delete_item($id);

if (isset($_POST['UpdateItem']))
	handle_update_item();

if (isset($_POST['AddItem']))
	handle_new_item();

if (isset($_POST['CancelItemChanges'])) {
	line_start_focus();
}

if (isset($_POST['CancelStop']))
	handle_cancel_stop();

$id = find_submit('Delete');
if ($id!=-1)
	handle_delete_stop($id);

if (isset($_POST['UpdateStop']))
	handle_update_stop();

if (isset($_POST['AddStop']))
	handle_new_stop();

if (isset($_POST['CancelStopChanges'])) {
	stop_start_focus();
}
//--------------------------------------------------------------------------------

	if ($_SESSION['Items']->trans_type!=ST_TRANSPORTQUOTE && $_SESSION['Items']->trans_type != ST_TRANSPORTBOOKING) 
	{
	check_db_has_transportable_items(_("There are no transportable items defined in the system."));

	check_db_has_consignor_branches(_("There are no consignors, or there are no consignors with branches. Please define consignors and consignor branches."));
	
	check_db_has_consignees(_("There are no consignees, or there are no consignees with branches. Please define consignees and consigeer branches."));
}
if ($_SESSION['Items']->trans_type != ST_TRANSPORTBOOKING) 
	{

	check_db_has_drivers(_("There are no drivers in the system. Please define atleast one."));
}
if ($_SESSION['Items']->trans_type == ST_TRANSPORTINVOICE) {
	$idate = _("Invoice Date:");
	$orderitems = _("Transport Invoice Items");
	$deliverydetails = _("Enter Delivery Details and Confirm Invoice");
	$cancelorder = _("Cancel Invoice");
	$porder = _("Place Invoice");
} elseif ($_SESSION['Items']->trans_type == ST_CONSIGNORDELIVERY) {
	$idate = _("Delivery Date:");
	$orderitems = _("Delivery Note Items");
	$deliverydetails = _("Enter Delivery Details and Confirm Dispatch");
	$cancelorder = _("Cancel Delivery");
	$porder = _("Place Delivery");
} elseif ($_SESSION['Items']->trans_type == ST_TRANSPORTQUOTE) {
	$idate = _("Loading Slip Date:");
	$orderitems = _("Loading Slip Items");
	$deliverydetails = _("Enter Delivery Details and Confirm Quotation");
	$cancelorder = _("Cancel Loading Slip");
	$porder = _("Place Loading Slip");
	$corder = _("Commit Loading Slips Changes");

} elseif ($_SESSION['Items']->trans_type == ST_TRANSPORTBOOKING) {
	$idate = _("Booking Date:");
	$orderitems = _("Transport Booking Items");
	$deliverydetails = _("Enter Delivery Details and Confirm Bookings");
	$cancelorder = _("Cancel Booking");
	$porder = _("Place Booking");
	$corder = _("Commit Booking Changes");
} 
else {
	$idate = _("Bilty Date:");
	$orderitems = _("Bilty Items");
	$deliverydetails = _("Enter Bilty Details and Confirm Order");
	$cancelorder = _("Cancel Bilty");
	$porder = _("Place Bilty");
	$corder = _("Commit Bilty Changes");
}
start_form();

hidden('cart_id');
$consignor_error = display_order_header($_SESSION['Items'],($_SESSION['Items']->any_already_delivered() == 0), $idate);

if ($consignor_error == "") {
	/*start_table(TABLESTYLE, "width=80%", 10);
	echo "<tr><td>";
	display_order_summary($orderitems, $_SESSION['Items'], true);
	echo "</td></tr>";
	echo "<tr><td>";
	display_delivery_details($_SESSION['Items']);
	echo "</td></tr>";
	end_table(1);*/
	/*display_load_basics($_SESSION['Items'],($_SESSION['Items']->any_already_delivered() == 0), $idate); 
		display_consignor_info($_SESSION['Items'],($_SESSION['Items']->any_already_delivered() == 0), $idate); 
		display_consignee_info($_SESSION['Items'],($_SESSION['Items']->any_already_delivered() == 0), $idate); 
		display_bill_to_info($_SESSION['Items'],($_SESSION['Items']->any_already_delivered() == 0), $idate); 
	*/if ($_SESSION['Items']->trans_no == 0) {

		submit_center_first('ProcessOrder', $porder,
		    _('Check entered data and save document'), 'default');
		submit_js_confirm('CancelOrder', _('You are about to void this Document.\nDo you want to continue?'));
	} else {
		if ($_SESSION['Items']->trans_type==ST_TRANSPORTORDER)
			submit_js_confirm('CancelOrder', _('You are about to cancel undelivered part of this order.\nDo you want to continue?'));
		submit_center_first('ProcessOrder', $corder,
		    _('Validate changes and update document'), 'default');
	}

	submit_center_last('CancelOrder', $cancelorder,
	   _('Cancels document entry or removes transport booking when editing an old document'));
} else {
	display_error($consignor_error);
}
tabbed_content_start('tabs', array(
		'basics' => array(_('&Load Basics'), $selected_id),
		'consignor' => array(_('&Consignor Info'), $selected_id),
		'consignee' => array(_('&Consignee Info'), $selected_id),
		'bill' => array(_('&Bill To'), $selected_id),
		'stops' => array(_('&Edit Stops'), $selected_id),
		'route' => array(_('&Route'), $selected_id),
		'scheduled_stop' => array(_('&Scheduled Stops'), $selected_id),
		'carrier_info' => array(_('&Carrier Info'), $selected_id),
		'transactions' => array(_('&Transactions'), $selected_id),
	));
	
	switch (get_post('_tabs_sel')) {
		default:
		case 'basics':
			display_load_basics($_SESSION['Items'],($_SESSION['Items']->any_already_delivered() == 0), $idate); 
			break;
		case 'consignor':
			display_consignor_info($_SESSION['Items'],($_SESSION['Items']->any_already_delivered() == 0), $idate); 
			break;
		case 'consignee':
			display_consignee_info($_SESSION['Items'],($_SESSION['Items']->any_already_delivered() == 0), $idate); 
			break;
		case 'bill':
			display_billing_info($_SESSION['Items'],($_SESSION['Items']->any_already_delivered() == 0), $idate); 
			break;
		case 'transactions':
			display_order_summary($orderitems, $_SESSION['Items'], true);
			break;
		case 'stops':
			display_stop_details($orderitems, $_SESSION['Items'], true);
			break;
		};

end_form();
end_page();
?>
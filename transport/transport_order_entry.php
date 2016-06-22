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

include_once ($path_to_root . "/transport/includes/cart_class.inc");
include_once ($path_to_root . "/includes/session.inc");
include_once ($path_to_root . "/transport/includes/transport_ui.inc");
include_once ($path_to_root . "/transport/includes/ui/transport_order_ui.inc");
include_once ($path_to_root . "/transport/includes/transport_db.inc");
include_once ($path_to_root . "/transport/includes/db/transport_types_db.inc");
include_once ($path_to_root . "/reporting/includes/reporting.inc");
include_once ($path_to_root . "/includes/ui/items_cart.inc");
include_once ($path_to_root . "/includes/ui/consignors_view.inc");

//------------------------------------------------
set_page_security(@$_SESSION['Items'] -> trans_type, array(ST_TRANSPORTORDER => 'SA_TRANSPORTORDER', ST_TRANSPORTQUOTE => 'SA_TRANSPORTQUOTE', ST_TRANSPORTBOOKING => 'SA_TRANSPORTQUOTE', ST_CONSIGNORDELIVERY => 'SA_TRANSPORTDELIVERY', ST_TRANSPORTINVOICE => 'SA_TRANSPORTINVOICE'), array('NewOrder' => 'SA_TRANSPORTORDER', 'ModifyOrderNumber' => 'SA_TRANSPORTORDER', 'AddedID' => 'SA_TRANSPORTORDER', 'UpdatedID' => 'SA_TRANSPORTORDER', 'NewQuotation' => 'SA_TRANSPORTQUOTE', 'ModifyQuotationNumber' => 'SA_TRANSPORTQUOTE', 'NewQuoteToTransportOrder' => 'SA_TRANSPORTQUOTE', 'NewBooking' => 'SA_TRANSPORTQUOTE', 'ModifyBookingNumber' => 'SA_TRANSPORTQUOTE', 'NewBookingToQuoteOrder' => 'SA_TRANSPORTQUOTE', 'AddedQU' => 'SA_TRANSPORTQUOTE', 'UpdatedQU' => 'SA_TRANSPORTQUOTE', 'AddedBO' => 'SA_TRANSPORTQUOTE', 'UpdatedBO' => 'SA_TRANSPORTQUOTE', 'NewDelivery' => 'SA_TRANSPORTDELIVERY', 'AddedDN' => 'SA_TRANSPORTDELIVERY', 'NewInvoice' => 'SA_TRANSPORTINVOICE', 'AddedDI' => 'SA_TRANSPORTINVOICE'));

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
	$_SESSION['page_title'] = sprintf(_("Modifying Bilty # %d"), $_GET['ModifyOrderNumber']);
	create_cart(ST_TRANSPORTORDER, $_GET['ModifyOrderNumber']);

} elseif (isset($_GET['ModifyQuotationNumber']) && is_numeric($_GET['ModifyQuotationNumber'])) {

	$help_context = 'Modifying Loading Slip';
	$_SESSION['page_title'] = sprintf(_("Modifying Loading Slip # %d"), $_GET['ModifyQuotationNumber']);
	create_cart(ST_TRANSPORTQUOTE, $_GET['ModifyQuotationNumber']);

} elseif (isset($_GET['ModifyBookingNumber']) && is_numeric($_GET['ModifyBookingNumber'])) {

	$help_context = 'Modifying Transport Booking';
	$_SESSION['page_title'] = sprintf(_("Modifying Transport Booking # %d"), $_GET['ModifyBookingNumber']);
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
} elseif (isset($_GET['NewBooking'])) {
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

if (isset($_GET['AddedID'])) {
	$order_no = $_GET['AddedID'];
	display_notification_centered(sprintf(_("Bilty # %d has been entered."), $order_no));

	submenu_view(_("&View This Bilty"), ST_TRANSPORTORDER, $order_no);

	submenu_print(_("&Print This Bilty"), ST_TRANSPORTORDER, $order_no, 'prtopt');
	submenu_print(_("&Email This Bilty"), ST_TRANSPORTORDER, $order_no, null, 1);
	set_focus('prtopt');

	submenu_option(_("Generate &Delivery Against This Bilty"), "/transport/consignor_delivery.php?OrderNumber=$order_no");
	submenu_option(_("Modify This Bilty"), "/transport/transport_order_entry.php?ModifyOrderNumber=$order_no");

	//submenu_option(_("Work &Order Entry"),	"/manufacturing/work_order_entry.php?");

	submenu_option(_("Enter a &New Bilty"), "/transport/transport_order_entry.php?NewOrder=0");

	display_footer_exit();

} elseif (isset($_GET['UpdatedID'])) {
	$order_no = $_GET['UpdatedID'];

	display_notification_centered(sprintf(_("Bilty # %d has been updated."), $order_no));

	submenu_view(_("&View This Bilty"), ST_TRANSPORTORDER, $order_no);

	submenu_print(_("&Print This Bilty"), ST_TRANSPORTORDER, $order_no, 'prtopt');
	submenu_print(_("&Email This Bilty"), ST_TRANSPORTORDER, $order_no, null, 1);
	set_focus('prtopt');

	submenu_option(_("Confirm Bilty Quantities and Make &Delivery"), "/transport/consignor_delivery.php?OrderNumber=$order_no");
	submenu_option(_("Modify This Bilty"), "/transport/transport_order_entry.php?ModifyOrderNumber=$order_no");

	submenu_option(_("Select A Different &Bilty"), "/transport/inquiry/transport_orders_view.php?OutstandingOnly=1");

	display_footer_exit();

} elseif (isset($_GET['AddedQU'])) {
	$order_no = $_GET['AddedQU'];
	display_notification_centered(sprintf(_("Loading Slip # %d has been entered."), $order_no));

	submenu_view(_("&View This Loading Slip"), ST_TRANSPORTQUOTE, $order_no);

	submenu_print(_("&Print This Loading Slip"), ST_TRANSPORTQUOTE, $order_no, 'prtopt');
	submenu_print(_("&Email This Loading Slip"), ST_TRANSPORTQUOTE, $order_no, null, 1);
	set_focus('prtopt');

	submenu_option(_("Generate &Bilty Against This Loading Slip"), "/transport/transport_order_entry.php?NewQuoteToTransportOrder=$order_no");

	//submenu_option(_("Loading Slip"),	"/transport/transport_order_entry.php?NewQuotation=0");

	display_footer_exit();

} elseif (isset($_GET['UpdatedQU'])) {
	$order_no = $_GET['UpdatedQU'];

	display_notification_centered(sprintf(_("Loading Slip # %d has been updated."), $order_no));

	submenu_view(_("&View This Loading Slip"), ST_TRANSPORTQUOTE, $order_no);

	submenu_print(_("&Print This Loading Slip"), ST_TRANSPORTQUOTE, $order_no, 'prtopt');
	submenu_print(_("&Email This Loading Slip"), ST_TRANSPORTQUOTE, $order_no, null, 1);
	set_focus('prtopt');

	submenu_option(_("Generate &Bilty Against This Loading Slip"), "/transport/transport_order_entry.php?NewQuoteToTransportOrder=$order_no");

	submenu_option(_("Select A Different &Loading Slip"), "/transport/inquiry/transport_orders_view.php?type=" . ST_TRANSPORTQUOTE);

	display_footer_exit();
} elseif (isset($_GET['AddedBO'])) {
	$order_no = $_GET['AddedBO'];
	display_notification_centered(sprintf(_("Booking # %d has been entered."), $order_no));

	submenu_view(_("&View This Booking"), ST_TRANSPORTBOOKING, $order_no);

	submenu_print(_("&Print This Booking"), ST_TRANSPORTBOOKING, $order_no, 'prtopt');
	submenu_print(_("&Email This Booking"), ST_TRANSPORTBOOKING, $order_no, null, 1);
	set_focus('prtopt');

	submenu_option(_("Generate &Loading Slip Against This Booking"), "/transport/transport_order_entry.php?NewBookingToQuoteOrder=$order_no");

	submenu_option(_("Enter a New &Booking"), "/transport/transport_order_entry.php?NewBooking=0");

	display_footer_exit();

} elseif (isset($_GET['UpdatedBO'])) {
	$order_no = $_GET['UpdatedBO'];

	display_notification_centered(sprintf(_("Booking # %d has been updated."), $order_no));

	submenu_view(_("&View This Booking"), ST_TRANSPORTBOOKING, $order_no);

	submenu_print(_("&Print This Booking"), ST_TRANSPORTBOOKING, $order_no, 'prtopt');
	submenu_print(_("&Email This Booking"), ST_TRANSPORTBOOKING, $order_no, null, 1);
	set_focus('prtopt');

	submenu_option(_("Generate &Loading Slip Against This Booking"), "/transport/transport_order_entry.php?NewBookingToQuoteOrder=$order_no");

	submenu_option(_("Select A Different &Booking"), "/transport/inquiry/transport_orders_view.php?type=" . ST_TRANSPORTBOOKING);

	display_footer_exit();
} elseif (isset($_GET['AddedDN'])) {
	$delivery = $_GET['AddedDN'];

	display_notification_centered(sprintf(_("Delivery # %d has been entered."), $delivery));

	submenu_view(_("&View This Delivery"), ST_CONSIGNORDELIVERY, $delivery);

	submenu_print(_("&Print Delivery Note"), ST_CONSIGNORDELIVERY, $delivery, 'prtopt');
	submenu_print(_("&Email Delivery Note"), ST_CONSIGNORDELIVERY, $delivery, null, 1);
	submenu_print(_("P&rint as Packing Slip"), ST_CONSIGNORDELIVERY, $delivery, 'prtopt', null, 1);
	submenu_print(_("E&mail as Packing Slip"), ST_CONSIGNORDELIVERY, $delivery, null, 1, 1);
	set_focus('prtopt');

	display_note(get_gl_view_str(ST_CONSIGNORDELIVERY, $delivery, _("View the GL Journal Entries for this Dispatch")), 0, 1);

	submenu_option(_("Generate &Invoice Against This Delivery"), "/transport/consignor_invoice.php?DeliveryNumber=$delivery");

	if ((isset($_GET['Type']) && $_GET['Type'] == 1))
		submenu_option(_("Enter a New Template &Delivery"), "/transport/inquiry/transport_orders_view.php?DeliveryTemplates=Yes");
	// else
	//	submenu_option(_("Enter a &New Delivery"),
	//		"/transport/transport_order_entry.php?NewDelivery=0");

	display_footer_exit();

} elseif (isset($_GET['AddedDI'])) {
	$invoice = $_GET['AddedDI'];

	display_notification_centered(sprintf(_("Invoice # %d has been entered."), $invoice));

	submenu_view(_("&View This Invoice"), ST_TRANSPORTINVOICE, $invoice);

	submenu_print(_("&Print Transport Invoice"), ST_TRANSPORTINVOICE, $invoice . "-" . ST_TRANSPORTINVOICE, 'prtopt');
	submenu_print(_("&Email Transport Invoice"), ST_TRANSPORTINVOICE, $invoice . "-" . ST_TRANSPORTINVOICE, null, 1);
	set_focus('prtopt');

	$sql = "SELECT trans_type_from, trans_no_from FROM " . TB_PREF . "consignor_allocations
			WHERE trans_type_to=" . ST_TRANSPORTINVOICE . " AND trans_no_to=" . db_escape($invoice);
	$result = db_query($sql, "could not retrieve consignor allocation");
	$row = db_fetch($result);
	if ($row !== false)
		submenu_print(_("Print &Receipt"), $row['trans_type_from'], $row['trans_no_from'] . "-" . $row['trans_type_from'], 'prtopt');

	display_note(get_gl_view_str(ST_TRANSPORTINVOICE, $invoice, _("View the GL &Journal Entries for this Invoice")), 0, 1);

	if ((isset($_GET['Type']) && $_GET['Type'] == 1))
		submenu_option(_("Enter a &New Template Invoice"), "/transport/inquiry/transport_orders_view.php?InvoiceTemplates=Yes");
	//else
	//	submenu_option(_("Enter a &New Direct Invoice"),
	//		"/transport/transport_order_entry.php?NewInvoice=0");

	submenu_option(_("Add an Attachment"), "/admin/attachments.php?filterType=" . ST_TRANSPORTINVOICE . "&trans_no=$invoice");

	display_footer_exit();
} else
	check_edit_conflicts();
//-----------------------------------------------------------------------------

function copy_to_cart() {
	$cart = &$_SESSION['Items'];

	$cart -> reference = $_POST['ref'];

	$cart -> Comments = $_POST['Comments'];

	$cart -> document_date = $_POST['OrderDate'];

	$newpayment = false;

	if (isset($_POST['payment']) && ($cart -> payment != $_POST['payment'])) {
		$cart -> payment = $_POST['payment'];
		$cart -> payment_terms = get_payment_terms($_POST['payment']);
		$newpayment = true;
	}

	$cart -> consignor_tin_no = $_POST['consignor_tin_no'];
	$cart -> consignee_tin_no = $_POST['consignee_tin_no'];
	$cart -> billing_tin_no = $_POST['billing_tin_no'];
	$cart -> freight_cost = input_num('ship_cost') + input_num('commission_cost') + input_num('way_cost') + input_num('bilty_charge') + input_num('insc_charge') + input_num('labour_charge');
	$cart -> commission_cost = input_num('commission_cost');
	$cart -> way_cost = input_num('way_cost');
	$cart -> bilty_charge = input_num('bilty_charge');
	$cart -> insc_charge = input_num('insc_charge');
	$cart -> labour_charge = input_num('labour_charge');
	$cart -> ship_cost = input_num('ship_cost');
	$cart -> contact_person = $_POST['contact_person'];
	//	$cart->service_tax_paid = $_POST['add_service_tax'];
	$cart -> consignor_id = $_POST['consignor_id'];
	$cart -> consignee_id = $_POST['consignee_id'];
	$cart -> billing_id = $_POST['billing_id'];
	$cart -> service_tax_by = $_POST['service_tax_by'];
	$cart -> payment_by = $_POST['payment_by'];
	//	$cart->service_tax_paid = $_POST['add_service_tax'];
	$cart -> transport_type = $_POST['transport_type'];
	$cart -> ex_rate = input_num('_ex_rate', null);
	$cart -> deliver_to = $_POST['deliver_to'];
	$cart -> delivery_address = $_POST['delivery_address'];
	$cart -> consignee_phone = $_POST['consignee_phone'];
	$cart -> consignee_email = $_POST['consignee_email'];
	$cart -> bill_to = $_POST['bill_to'];
	$cart -> billing_address = $_POST['billing_address'];
	$cart -> billing_phone = $_POST['billing_phone'];
	$cart -> billing_email = $_POST['billing_email'];
	$cart -> total_goods_value = input_num('total_goods_value');
	$cart -> goods_bill_no = $_POST["goods_bill_no"];
	$cart -> ship_via = $_POST['ship_via'];
	$cart -> due_date = $_POST['delivery_date'];

	$cart -> driver_id = $_POST['driver_id'];
	$cart -> driver_ref = $_POST['driver_ref'];
	$cart -> vehicle_id = $_POST['vehicle_id'];

	$cart -> loaded_from = $_POST['loaded_from'];
	$cart -> loading_address = $_POST['loading_address'];

	//$cart->consignor_name = $_POST['consignor_name'];

	$cart -> contact_phone = $_POST['contact_phone'];

	//$cart->total_goods_value=$_POST['total_goods_value'];
	$cart -> Location = $_POST['Location'];
	$cart -> Location_to = $_POST['Location_to'];

	if (isset($_POST['email']))
		$cart -> email = $_POST['email'];
	else
		$cart -> email = '';

	if (isset($_POST['LoadStatusList']))
		$cart -> LoadStatusList = $_POST['LoadStatusList'];
	if (isset($_POST['TruckStatusTypeList']))
		$cart -> TruckStatusTypeList = $_POST['TruckStatusTypeList'];

	$cart -> paid_date = $_SESSION['payment_date'];
	$cart -> deposit_date = $_SESSION['deposit_date'];

}

//-----------------------------------------------------------------------------

function copy_from_cart() {
	$cart = &$_SESSION['Items'];
	$_POST['ref'] = $cart -> reference;
	$_POST['Comments'] = $cart -> Comments;

	$_POST['OrderDate'] = $cart -> document_date;
	$_POST['delivery_date'] = $cart -> due_date;
	$_POST['contact_person'] = $cart -> contact_person;
	$_POST['consignee_ref'] = $cart -> consignor_ref;
	$_POST['ship_cost'] = price_format($cart -> ship_cost);
	$_POST['commission_cost'] = price_format($cart -> commission_cost);
	$_POST['way_cost'] = price_format($cart -> way_cost);
	$_POST['insc_charge'] = price_format($cart -> insc_charge);
	$_POST['bilty_charge'] = price_format($cart -> bilty_charge);
	$_POST['labour_charge'] = price_format($cart -> labour_charge);
	$_POST['add_service_tax'] = $cart -> service_tax_paid;
	$_POST['payment_by'] = $cart -> payment_by;
	$_POST['service_tax_by'] = $cart -> service_tax_by;
	$_POST['consignor_tin_no'] = $cart -> consignor_tin_no;
	$_POST['billing_tin_no'] = $cart -> billing_tin_no;
	$_POST['contact_phone'] = $cart -> contact_phone;
	$_POST['consignee_tin_no'] = $cart -> consignee_tin_no;
	$_POST['goods_bill_no'] = $cart -> goods_bill_no;
	$_POST['total_goods_value'] = price_format($cart -> total_goods_value);
	$_POST['deliver_to'] = $cart -> deliver_to;
	$_POST['delivery_address'] = $cart -> delivery_address;
	$_POST['consignee_phone'] = $cart -> consignee_phone;
	$_POST['consignee_email'] = $cart -> consignee_email;
	$_POST['bill_to'] = $cart -> bill_to;
	$_POST['billing_address'] = $cart -> billing_address;
	$_POST['billing_phone'] = $cart -> billing_phone;
	$_POST['billing_email'] = $cart -> billing_email;
	$_POST['loaded_from'] = $cart -> loaded_from;
	$_POST['loading_address'] = $cart -> loading_address;
	$_POST['phone'] = $cart -> phone;
	$_POST['driver_id'] = $cart -> driver_id;
	$_POST['driver_ref'] = $cart -> driver_ref;
	$_POST['vehicle_id'] = $cart -> vehicle_id;
	$_POST['Location'] = $cart -> Location;
	$_POST['Location_to'] = $cart -> Location_to;
	$_POST['ship_via'] = $cart -> ship_via;

	$_POST['consignor_id'] = $cart -> consignor_id;

	$_POST['consignee_id'] = $cart -> consignee_id;

	$_POST['billing_id'] = $cart -> billing_id;

	$_POST['transport_type'] = $cart -> transport_type;
	// POS
	$_POST['payment'] = $cart -> payment;
	$_POST['cart_id'] = $cart -> cart_id;
	$_POST['_ex_rate'] = $cart -> ex_rate;
	// Prabha added for payment and deposits

	$_POST['LoadStatusList'] = $cart -> LoadStatusList;
	$_POST['TruckStatusTypeList'] = $cart -> TruckStatusTypeList;

	$_POST['payment_date'] = $cart -> document_date;
	$_SESSION['payment_date'] = $cart -> document_date;
	$_POST['deposit_date'] = $cart -> document_date;
	$_SESSION['deposit_date'] = $cart -> document_date;

}

//--------------------------------------------------------------------------------

function line_start_focus() {
	global $Ajax;

	$Ajax -> activate('items_table');
	set_focus('_stock_id_edit');
}

function stop_start_focus() {
	global $Ajax;

	$Ajax -> activate('stops_table');
}

function stop_delivery_start_focus() {
	global $Ajax;

	$Ajax -> activate('stops_delivery_table');
}
//-----------Prabha added to focus on consignor---------------------------------
function consignor_line_start_focus() {
	global $Ajax;

	$Ajax -> activate('consignor_table');
}

//------------------------------------------------------------------------------

//-----------Prabha added to focus on payments and deposits---------------------------------
function payment_line_start_focus() {
	global $Ajax;

	$Ajax -> activate('payment_table');
}

function deposit_line_start_focus() {
	global $Ajax;

	$Ajax -> activate('deposit_table');
}

//------------------------------------------------------------------------------

//--------------------------------------------------------------------------------
function can_process() {
	global $Refs;
	/*
	 if (!get_post('consignor_id') && $_SESSION['Items']->trans_type!=ST_TRANSPORTQUOTE && $_SESSION['Items']->trans_type!=ST_TRANSPORTBOOKING )
	 {
	 display_error(_("There is no consignor selected."));
	 set_focus('consignor_id');
	 return false;
	 }
	 if (!get_post('consignee_id') && $_SESSION['Items']->trans_type!=ST_TRANSPORTQUOTE && $_SESSION['Items']->trans_type != ST_TRANSPORTBOOKING)
	 {
	 display_error(_("There is no consignee selected."));
	 set_focus('consignee_id');
	 return false;
	 }
	 //	if (get_post('Location') == get_post('Location_to'))
	 //	{
	 //		display_error(_("The locations to transfer from and to must be different."));
	 //		set_focus('Location_to');
	 //		return false;
	 //	}
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

	 //	if (strlen($_POST['phone']) <= 1) {
	 //			display_error( _("You should enter the Phone number of Contact Person of Consignor."));
	 //			set_focus('phone');
	 //			return false;
	 //	}
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
	 }*/
	return true;
}

//-----------------------------------------------------------------------------

if (isset($_POST['update'])) {
	copy_to_cart();
	$Ajax -> activate('items_table');
}

if (isset($_POST['ProcessOrder']) && can_process()) {
	copy_to_cart();
	$modified = ($_SESSION['Items'] -> trans_no != 0);
	$so_type = $_SESSION['Items'] -> so_type;
        
	$ret = $_SESSION['Items'] -> write(1);
	if ($ret == -1) {
		display_error(_("The entered reference is already in use."));
		$ref = get_next_reference($_SESSION['Items'] -> trans_type);
		if ($ref != $_SESSION['Items'] -> reference) {
			display_error(_("The reference number field has been increased. Please save the document again."));
			$_POST['ref'] = $_SESSION['Items'] -> reference = $ref;
			$Ajax -> activate('ref');
		}
		set_focus('ref');
	} else {
		if (count($messages)) {// abort on failure or error messages are lost
			$Ajax -> activate('_page_body');
			display_footer_exit();
		}
		$trans_no = key($_SESSION['Items'] -> trans_no);
		$trans_type = $_SESSION['Items'] -> trans_type;
		new_doc_date($_SESSION['Items'] -> document_date);
		processing_end();
		if ($modified) {
			if ($trans_type == ST_TRANSPORTQUOTE)
				meta_forward($_SERVER['PHP_SELF'], "UpdatedQU=$trans_no");
			elseif ($trans_type == ST_TRANSPORTBOOKING)
				meta_forward($_SERVER['PHP_SELF'], "UpdatedBO=$trans_no");
			else
				meta_forward($_SERVER['PHP_SELF'], "UpdatedID=$trans_no");

		} elseif ($trans_type == ST_TRANSPORTORDER) {
			meta_forward($_SERVER['PHP_SELF'], "AddedID=$trans_no");
		} elseif ($trans_type == ST_TRANSPORTQUOTE) {
			meta_forward($_SERVER['PHP_SELF'], "AddedQU=$trans_no");
		} elseif ($trans_type == ST_TRANSPORTBOOKING) {
			meta_forward($_SERVER['PHP_SELF'], "AddedBO=$trans_no");
		} elseif ($trans_type == ST_TRANSPORTINVOICE) {
			meta_forward($_SERVER['PHP_SELF'], "AddedDI=$trans_no&Type=$so_type");
		} else {
			meta_forward($_SERVER['PHP_SELF'], "AddedDN=$trans_no&Type=$so_type");
		}
	}
}

//--------------------------------------------------------------------------------
// ----------------------------Prabha added on 2ndJuldy 2015-------------------------
function check_consignor_data() {
	global $SysPrefs;

	if (!get_post('consignor_code', true)) {
		display_error(_("consignor cannot be empty."));
		set_focus('consignor_code');
		return false;
	}

	if (!get_post('tin_no', true)) {
		display_error(_("Tin no cannot be empty."));
		set_focus('tin_no');
		return false;
	}
	if (!get_post('address', true)) {
		display_error(_("Address cannot be empty."));
		set_focus('address');
		return false;
	}

	return true;
}

//-----------------------------Prabha ended-------------------------------------------
function check_item_data() {
	global $SysPrefs, $allow_negative_prices;

	$is_transportable_item = is_transportable_item(get_post('stock_id'));
	if (!get_post('stock_id_text', true)) {
		display_error(_("Item description cannot be empty."));
		set_focus('stock_id_edit');
		return false;
	} elseif (!check_num('qty', 0)) {
		display_error(_("The item could not be updated because you are attempting to set the quantity ordered to less than 0, or the discount percent to more than 100."));
		set_focus('qty');
		return false;
	} elseif (!check_num('price', 0) && (!$allow_negative_prices || $is_transportable_item) && $_SESSION['Items'] -> trans_type != ST_TRANSPORTQUOTE && $_SESSION['Items'] -> trans_type != ST_TRANSPORTBOOKING) {
		display_error(_("Price for inventory item must be entered and can not be less than 0"));
		set_focus('price');
		return false;
	} elseif (isset($_POST['LineNo']) && isset($_SESSION['Items'] -> line_items[$_POST['LineNo']]) && !check_num('qty', $_SESSION['Items'] -> line_items[$_POST['LineNo']] -> qty_done) && $_SESSION['Items'] -> trans_type != ST_TRANSPORTQUOTE && $_SESSION['Items'] -> trans_type != ST_TRANSPORTBOOKING) {

		set_focus('qty');
		display_error(_("You attempting to make the quantity ordered a quantity less than has already been delivered. The quantity delivered cannot be modified retrospectively."));
		return false;
	}
	// Joe Hunt added 2008-09-22 -------------------------

	$cost_home = get_standard_cost(get_post('stock_id'));
	// Added 2011-03-27 Joe Hunt
	$cost = $cost_home / get_exchange_rate_from_home_currency($_SESSION['Items'] -> consignor_currency, $_SESSION['Items'] -> document_date);
	if (input_num('price') < $cost) {
		$dec = user_price_dec();
		$curr = $_SESSION['Items'] -> consignor_currency;
		$price = number_format2(input_num('price'), $dec);
		if ($cost_home == $cost)
			$std_cost = number_format2($cost_home, $dec);
		else {
			$price = $curr . " " . $price;
			$std_cost = $curr . " " . number_format2($cost, $dec);
		}
		display_warning(sprintf(_("Price %s is below Standard Cost %s"), $price, $std_cost));
	}
	return true;
}

//--------------------------------------------------------------------------------

function handle_update_item() {

	if ($_POST['UpdateItem'] != '' && check_item_data()) {
		$_SESSION['Items'] -> update_cart_item($_POST['LineNo'], input_num('qty'), get_post('to_units'), input_num('price'),get_post('flat_rate'), $_POST['item_description']);
	}
	page_modified();
	line_start_focus();
}

// PRabha added for handling updation of consignor
function handle_update_consignor() {

	if ($_POST['UpdateConsignorItem'] != '') {
		$_SESSION['Items'] -> update_consignor_cart_item($_POST['Consignor_LineNo'], get_post('consignor_no'), get_post('tin_no'), get_post('address'), get_post('phone'), get_post('email'));

	}
	page_modified();
	consignor_line_start_focus();
}

//--------------------------------------------------------------------------------
// prabha added for handlng updation of loadstops
function handle_update_stop() {

	if ($_POST['UpdateStop'] != '') {
		$_SESSION['Items'] -> update_load_stop($_POST['Loadstop_LineNo'], get_post('loc_code'), 1, get_post('stop_contact'), get_post('stop_address'), get_post('stop_city'), get_post('stop_date'), get_post('stop_time'));

	}
	page_modified();
	stop_start_focus();
}
function handle_update_stop_delivery() {

	if ($_POST['UpdateStopDelivery'] != '') {
		$_SESSION['Items'] -> update_load_stop_delivery($_POST['Loadstop_delivery_LineNo'], get_post('delivery_loc_code'), 1, get_post('stop_delivery_contact'), get_post('stop_delivery_address'), get_post('stop_delivery_city'), get_post('stop_delivery_date'), get_post('stop_delivery_time'));

	}
	page_modified();
	stop_delivery_start_focus();
}
//--------------------------------------------------------------------------------------
//Prabha added to handle upation of payment and deposit----------------------------

function handle_update_payment() {

	if ($_POST['Update_Payment_Item'] != '') {
		if (get_post('PaymentPayType') == 0) {
			$var_payee_no = get_post('payment_person_id');
			$var_driver_no = -1;
			//no driver
		} else {
			$var_driver_no = get_post('payment_person_id');
			$var_payee_no = -1;
			//no consignor
		}
		$_SESSION['Items'] -> update_payment($_POST['PaymentIndex'], get_post('PaymentPayType'), $var_payee_no, get_post('payment_PersonDetailID'), $var_driver_no, get_post('payment_code_id'), get_post('payment_amount'), get_post('payment_LineMemo'));

	}
	page_modified();
	payment_line_start_focus();
}

function handle_update_deposit() {

	if ($_POST['Update_Deposit_Item'] != '') {

		if (get_post('DepositPayType') == 0) {
			$var_payee_no = get_post('deposit_person_id');
			$var_driver_no = -1;
			//no driver
		} else {
			$var_driver_no = get_post('deposit_person_id');
			$var_payee_no = -1;
			//no consignor
		}

		$_SESSION['Items'] -> update_deposit($_POST['DepositIndex'], get_post('DepositPayType'), $var_payee_no, get_post('deposit_PersonDetailID'), $var_driver_no, get_post('deposit_code_id'), get_post('deposit_amount'), get_post('deposit_LineMemo'));

	}
	page_modified();
	deposit_line_start_focus();
}

function handle_delete_payment($line_no) {

	$_SESSION['Items'] -> remove_payment($line_no);

	payment_line_start_focus();
}

function handle_delete_deposit($line_no) {

	$_SESSION['Items'] -> remove_deposit($line_no);

	deposit_line_start_focus();
}

//---------------------------------------------------------------------------------
function handle_delete_item($line_no) {
	if ($_SESSION['Items'] -> some_already_delivered($line_no) == 0) {
		$_SESSION['Items'] -> remove_from_cart($line_no);
	} else {
		display_error(_("This item cannot be deleted because some of it has already been delivered."));
	}
	line_start_focus();
}

//--------------------------------------------------------------------------------
//----------Prabha added to handle delete consignor----------------------------------------
function handle_delete_consignor($line_no) {

	$_SESSION['Items'] -> remove_from_consignor_cart($line_no);

	consignor_line_start_focus();
}

//-----------------------------------------------------------------------------------------

//----------- Prabha added to handle delete edit stops------------------------------
function handle_delete_stop($line_no) {

	$_SESSION['Items'] -> remove_load_stop($line_no);

	stop_start_focus();
}
//----------- Prabha added to handle delete edit stops delivery------------------------------
function handle_delete_stop_delivery($line_no) {

	$_SESSION['Items'] -> remove_load_stop_delivery($line_no);

	stop_delivery_start_focus();
}

//----------------------------------------------------------------------
// Prabha added to handle payments and deposits------------------------------------
function handle_new_payment() {

	if (get_post('PaymentPayType') == 0) {
		$var_payee_no = get_post('payment_person_id');
		$var_driver_no = -1;
		//no driver
	} else {
		$var_driver_no = get_post('payment_person_id');
		$var_payee_no = -1;
		//no consignor
	}
	if (!can_add_payment()) {
		return;
	}
	$_SESSION['Items'] -> add_payment(count($_SESSION['Items'] -> gl_payment_items), get_post('PaymentPayType'), $var_payee_no, $var_driver_no, get_post('payment_code_id'), get_post('payment_amount'), get_post('payment_LineMemo'));

	page_modified();
	payment_line_start_focus();
}

function can_add_payment() {
	if (!get_post('payment_person_id')) {
		display_error(_("There is no person selected."));
		set_focus('payment_person_id');
		return false;
	}
	return true;
}

function handle_new_deposit() {

	if (get_post('DepositPayType') == 0) {
		$var_payee_no = get_post('deposit_person_id');
		$var_driver_no = -1;
		//no driver
	} else {
		$var_driver_no = get_post('deposit_person_id');
		$var_payee_no = -1;
		//no consignor
	}
	if (!can_add_deposit()) {
		return;
	}
	$_SESSION['Items'] -> add_deposit(count($_SESSION['Items'] -> gl_deposit_items), get_post('DepositPayType'), $var_payee_no, $var_driver_no, get_post('deposit_code_id'), get_post('deposit_amount'), get_post('deposit_LineMemo'));

	page_modified();
	deposit_line_start_focus();
}

function can_add_deposit() {
	if (!get_post('deposit_person_id')) {
		display_error(_("There is no person selected."));
		set_focus('deposit_person_id');
		return false;
	}
	return true;
}

// ---------------------------------------------------------------------------------
//---------------------Prabha Added on 2nd July to handle new consignor--------------
function handle_new_consignor() {

	if (!check_consignor_data()) {
		return;
	}

	add_to_consignor_order($_SESSION['Items'], get_post('consignor_code'), get_post('consignor_name'), get_post('tin_no'), get_post('address'), get_post('phone'), get_post('email'));

	page_modified();
	consignor_line_start_focus();
}

//-----------------------------------------------------------------------------------
function handle_new_item() {

	if (!check_item_data()) {
		return;
	}

	add_to_order($_SESSION['Items'], get_post('stock_id'), input_num('qty'), get_post('to_units'), input_num('price'),get_post('flat_rate'), get_post('stock_id_text'));

	unset($_POST['_stock_id_edit'], $_POST['stock_id']);
	page_modified();
	line_start_focus();
}

function handle_new_stop() {

	if (!can_add_stop()) {
		return;
	}
        $_SESSION['Items'] -> add_load_stop(count($_SESSION['Items'] -> loadstop_line_items), get_post('loc_code'), 1, get_post('stop_contact'), get_post('stop_address'), get_post('stop_city'), get_post('stop_date'), get_post('stop_time'));

	page_modified();
	stop_start_focus();
}

function can_add_stop() {

	if (!get_post('loc_code')) {
		display_error(_("There is no Location selected."));
		set_focus('loc_code');
		return false;
	}
	return true;
}

function handle_new_stop_delivery() {

    if (!can_add_stop_delivery()) {
		return;
	}
        
	$_SESSION['Items'] -> add_load_stop_delivery(count($_SESSION['Items'] -> loadstop_delivery_line_items), get_post('delivery_loc_code'), 1, get_post('stop_delivery_contact'), get_post('stop_delivery_address'), get_post('stop_delivery_city'), get_post('stop_delivery_date'), get_post('stop_delivery_time'));

	page_modified();
	stop_delivery_start_focus();
}

function can_add_stop_delivery() {

	if (!get_post('delivery_loc_code')) {
		display_error(_("There is no delivery Location selected."));
                set_focus('delivery_loc_code');
		return false;
	}
        
	return true;
}


//--------------------------------------------------------------------------------

function handle_cancel_order() {
	global $path_to_root, $Ajax;

	if ($_SESSION['Items'] -> trans_type == ST_CONSIGNORDELIVERY) {
		display_notification(_("Direct delivery entry has been cancelled as requested."), 1);
		submenu_option(_("Enter a New Transport Delivery"), "/transport/transport_order_entry.php?NewDelivery=1");
	} elseif ($_SESSION['Items'] -> trans_type == ST_TRANSPORTINVOICE) {
		display_notification(_("Direct invoice entry has been cancelled as requested."), 1);
		submenu_option(_("Enter a New Transport Invoice"), "/transport/transport_order_entry.php?NewInvoice=1");
	} elseif ($_SESSION['Items'] -> trans_type == ST_TRANSPORTQUOTE) {
		delete_transport_order(key($_SESSION['Items'] -> trans_no), $_SESSION['Items'] -> trans_type);
		display_notification(_("This loading slip has been cancelled as requested."), 1);
		submenu_option(_("Enter a New Loading Slip"), "/transport/transport_order_entry.php?NewQuotation=Yes");
	} elseif ($_SESSION['Items'] -> trans_type == ST_TRANSPORTBOOKING) {
		delete_transport_order(key($_SESSION['Items'] -> trans_no), $_SESSION['Items'] -> trans_type);
		display_notification(_("This booking has been cancelled as requested."), 1);
		submenu_option(_("Enter a New Booking"), "/transport/transport_order_entry.php?NewBooking=Yes");
	} else {// transport booking
		if ($_SESSION['Items'] -> trans_no != 0) {
			$order_no = key($_SESSION['Items'] -> trans_no);
			if (transport_order_has_deliveries($order_no)) {
				close_transport_order($order_no);
				display_notification(_("Undelivered part of bilty has been cancelled as requested."), 1);
				submenu_option(_("Select Another Bilty for Edition"), "/transport/inquiry/transport_orders_view.php?type=" . ST_TRANSPORTORDER);
			} else {
				delete_transport_order(key($_SESSION['Items'] -> trans_no), $_SESSION['Items'] -> trans_type);

				display_notification(_("This bilty has been cancelled as requested."), 1);
				//submenu_option(_("Enter a New Bilty"), "/transport/transport_order_entry.php?NewOrder=Yes");
			}
		} else {
			processing_end();
			meta_forward($path_to_root . '/index.php', 'application=orders');
		}
	}
	$Ajax -> activate('_page_body');
	processing_end();
	display_footer_exit();
}

//--------------------------------------------------------------------------------

function create_cart($type, $trans_no) {
	global $Refs;

	if (!$_SESSION['SysPrefs'] -> db_ok)// create_cart is called before page() where the check is done
		return;

	processing_start();

	if (isset($_GET['NewQuoteToTransportOrder'])) {

		$trans_no = $_GET['NewQuoteToTransportOrder'];
		$doc = new Cart(ST_TRANSPORTQUOTE, $trans_no, true);
		//	$doc->Comments = _("Loading Slip") . " # " . $trans_no;
		$_SESSION['Items'] = $doc;
	} elseif (isset($_GET['NewBookingToQuoteOrder'])) {

		$trans_no = $_GET['NewBookingToQuoteOrder'];
		$doc = new Cart(ST_TRANSPORTBOOKING, $trans_no, true);
		//$doc->Comments = _("Transport Booking") . " # " . $trans_no;
		$_SESSION['Items'] = $doc;
	} elseif ($type != ST_TRANSPORTORDER && $type != ST_TRANSPORTQUOTE && $type != ST_TRANSPORTBOOKING && $trans_no != 0) {// this is template

		$doc = new Cart(ST_TRANSPORTORDER, array($trans_no));
		$doc -> trans_type = $type;
		$doc -> trans_no = 0;
		$doc -> document_date = new_doc_date();
		if ($type == ST_TRANSPORTINVOICE) {
			$doc -> due_date = get_invoice_duedate($doc -> payment, $doc -> document_date);
			$doc -> pos = get_transport_point(user_pos());
		} else
			$doc -> due_date = $doc -> document_date;
		$doc -> reference = $Refs -> get_next($doc -> trans_type);
		//$doc->Comments='';
		foreach ($doc->line_items as $line_no => $line) {
			$doc -> line_items[$line_no] -> qty_done = 0;
		}
		$_SESSION['Items'] = $doc;
	} else

		$_SESSION['Items'] = new Cart($type, array($trans_no));

	copy_from_cart();
}

//--------------------------------------------------------------------------------

if (isset($_POST['CancelOrder']))
	handle_cancel_order();

$id = find_submit('DeleteItem');
if ($id != -1)
	handle_delete_item($id);

if (isset($_POST['UpdateItem']))
	handle_update_item();

if (isset($_POST['AddItem']))
	handle_new_item();

if (isset($_POST['CancelItemChanges'])) {
	line_start_focus();
}
//--------- Prabha Added on 2nd July 2015 conditions for add,update,cancel and delete

if (isset($_POST['Add_Payment_Item']))
	handle_new_payment();

$id_payment = find_submit('DeletePayment');
if ($id_payment != -1)
	handle_delete_payment($id_payment);

//if (isset($_POST['UpdateStop']))
if (isset($_POST['Update_Payment_Item']))

	handle_update_payment();

if (isset($_POST['Cancel_Payment_Item']))
	payment_line_start_focus();

//Deposit--------------------------------------------
if (isset($_POST['Add_Deposit_Item']))
	handle_new_deposit();

if (isset($_POST['Cancel_Deposit_Item']))
	deposit_line_start_focus();

$id_deposit = find_submit('DeleteDeposit');
if ($id_deposit != -1)
	handle_delete_deposit($id_deposit);

//if (isset($_POST['UpdateStop']))
if (isset($_POST['Update_Deposit_Item']))

	handle_update_deposit();

// Consignor-------------------------------------------------------------
if (isset($_POST['AddConsignorItem']))
	handle_new_consignor();

if (isset($_POST['UpdateConsignorItem']))
	handle_update_consignor();

if (isset($_POST['CancelConsignorItemChanges'])) {
	consignor_line_start_focus();
}
$id_consignor = find_submit('DeleteConsignor');
if ($id_consignor != -1)
	handle_delete_consignor($id_consignor);
//------------------------------ Prabha ended--------------------------------

$id_stop = find_submit('DeleteStop');
if ($id_stop != -1)
	handle_delete_stop($id_stop);

if (isset($_POST['UpdateStop']))
	handle_update_stop();

if (isset($_POST['AddStop']))
	handle_new_stop();

if (isset($_POST['CancelStopChanges'])) {
	stop_start_focus();
}
//--------------------------------------------------------------------------------

// for delivery functionality in editstops tab

$id_stop_delivery = find_submit('DeleteStopDelivery');
if ($id_stop_delivery != -1)
	handle_delete_stop_delivery($id_stop_delivery);

if (isset($_POST['UpdateStopDelivery']))
	handle_update_stop_delivery();

if (isset($_POST['AddStopDelivery']))
	handle_new_stop_delivery();

if (isset($_POST['CancelStopDeliveryChanges'])) {
	stop_delivery_start_focus();
}
//--------------------------------------------------------------------------------

if ($_SESSION['Items'] -> trans_type != ST_TRANSPORTQUOTE && $_SESSION['Items'] -> trans_type != ST_TRANSPORTBOOKING) {
	check_db_has_transportable_items(_("There are no transportable items defined in the system."));

}
if ($_SESSION['Items'] -> trans_type != ST_TRANSPORTBOOKING) {

	check_db_has_drivers(_("There are no drivers in the system. Please define atleast one."));
}
if ($_SESSION['Items'] -> trans_type == ST_TRANSPORTINVOICE) {
	$idate = _("Invoice Date:");
	$orderitems = _("Transport Invoice Items");
	$deliverydetails = _("Enter Delivery Details and Confirm Invoice");
	$cancelorder = _("Cancel Invoice");
	$porder = _("Place Invoice");
} elseif ($_SESSION['Items'] -> trans_type == ST_CONSIGNORDELIVERY) {
	$idate = _("Delivery Date:");
	$orderitems = _("Delivery Note Items");
	$deliverydetails = _("Enter Delivery Details and Confirm Dispatch");
	$cancelorder = _("Cancel Delivery");
	$porder = _("Place Delivery");
} elseif ($_SESSION['Items'] -> trans_type == ST_TRANSPORTQUOTE) {
	$idate = _("Loading Slip Date:");
	$orderitems = _("Loading Slip Items");
	$deliverydetails = _("Enter Delivery Details and Confirm Quotation");
	$cancelorder = _("Cancel Loading Slip");
	$porder = _("Place Loading Slip");
	$corder = _("Commit Loading Slips Changes");

} elseif ($_SESSION['Items'] -> trans_type == ST_TRANSPORTBOOKING) {
	$idate = _("Booking Date:");
	$orderitems = _("Transport Booking Items");
	$deliverydetails = _("Enter Delivery Details and Confirm Bookings");
	$cancelorder = _("Cancel Booking");
	$porder = _("Place Booking");
	$corder = _("Commit Booking Changes");
} else {
	$idate = _("Bilty Date:");
	$orderitems = _("Bilty Items");
	$deliverydetails = _("Enter Bilty Details and Confirm Order");
	$cancelorder = _("Cancel Bilty");
	$porder = _("Place Bilty");
	$corder = _("Commit Bilty Changes");
}
start_form(false, false, "", "", '');

hidden('cart_id');

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
	 */

} else {
	display_error($consignor_error);
}
static_tabs('tabs', 
	array('basics' => array(_('&Load Basics'), $selected_id), 
	'bill' => array(_('&Party Info'), $selected_id), 
	'consignor' => array(_('&Consignor Info'), $selected_id), 
	'consignee' => array(_('&Consignee Info'), $selected_id), 
	/*'stops' => array(_('&Edit Stops'), $selected_id),  
	'Routes' => array(_('&Routes'), $selected_id),*/
	'carrier_info' => array(_('&Carrier Info'), $selected_id), 
	'freight' => array(_('&Freight Calculation'), $selected_id), 
	'pe' => array(_('&Income & Expenses'), $selected_id)));

start_form_section('tab-content');

start_form_section('tab-pane fade active in', 'basics');
$consignor_error = display_order_header($_SESSION['Items'], ($_SESSION['Items'] -> any_already_delivered() == 0), $idate);
display_load_basics($_SESSION['Items'], ($_SESSION['Items'] -> any_already_delivered() == 0), $idate);
echo "<a class='btn btn-primary btnNext' >Next</a>";
end_form_section();

start_form_section('tab-pane fade in', 'bill');
display_billing_info($_SESSION['Items'], ($_SESSION['Items'] -> any_already_delivered() == 0), $idate);
end_form_section();

start_form_section('tab-pane fade in', 'consignor');
display_consignor('Consignor Details', $_SESSION['Items'], true);
end_form_section();

start_form_section('tab-pane fade in', 'consignee');
display_consignee_info($_SESSION['Items'], ($_SESSION['Items'] -> any_already_delivered() == 0), $idate);
end_form_section();
/*
start_form_section('tab-pane fade in', 'stops');
display_stop_details('Pickup Details', $_SESSION['Items'], true);
display_stop_delivery_details('Delivery Details', $_SESSION['Items'], true);
end_form_section();

start_form_section('tab-pane fade in', 'Routes');
display_stop_googlemap_details('Route Details', $_SESSION['Items'], true);
end_form_section();*/

start_form_section('tab-pane fade in', 'carrier_info');
display_carrier_info($_SESSION['Items']);
end_form_section();

start_form_section('tab-pane fade in', 'freight');
display_order_summary($orderitems, $_SESSION['Items'], true);
end_form_section();

start_form_section('tab-pane fade in', 'pe');
display_deposit_details('Income Details', $_SESSION['Items'], true);
display_payment_details('Expense Details', $_SESSION['Items'], true);
end_form_section();

end_form_section();

start_form_section('text-center', 'controls');
if ($_SESSION['Items'] -> trans_no == 0) {

	submit_center_first('ProcessOrder', $porder, _('Check entered data and save document'), 'default');
	submit_js_confirm('CancelOrder', _('You are about to void this Document.\nDo you want to continue?'));
} else {
	if ($_SESSION['Items'] -> trans_type == ST_TRANSPORTORDER)
		submit_js_confirm('CancelOrder', _('You are about to cancel undelivered part of this order.\nDo you want to continue?'));
	submit_center_first('ProcessOrder', $corder, _('Validate changes and update document'), 'default');
}

submit_center_last('CancelOrder', $cancelorder, _('Cancels document entry or removes transport booking when editing an old document'));

end_form_section();

end_form();
end_page();
?>
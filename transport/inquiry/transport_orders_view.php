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
$path_to_root = "../..";

include_once($path_to_root . "/includes/db_pager.inc");
include_once($path_to_root . "/includes/session.inc");
include_once($path_to_root . "/transport/includes/transport_ui.inc");
include_once($path_to_root . "/reporting/includes/reporting.inc");

$page_security = 'SA_TRANSPORTTRANSVIEW';

set_page_security( @$_POST['order_view_mode'],
	array(	'OutstandingOnly' => 'SA_TRANSPORTDELIVERY',
			'InvoiceTemplates' => 'SA_TRANSPORTINVOICE'),
	array(	'OutstandingOnly' => 'SA_TRANSPORTDELIVERY',
			'InvoiceTemplates' => 'SA_TRANSPORTINVOICE')
);

if (get_post('type'))
	$trans_type = $_POST['type'];
elseif (isset($_GET['type']) && $_GET['type'] == ST_TRANSPORTQUOTE)
	$trans_type = ST_TRANSPORTQUOTE;
elseif (isset($_GET['type']) && $_GET['type'] == ST_TRANSPORTBOOKING)
	$trans_type = ST_TRANSPORTBOOKING;
else
	$trans_type = ST_TRANSPORTORDER;

if ($trans_type == ST_TRANSPORTORDER)
{
	if (isset($_GET['OutstandingOnly']) && ($_GET['OutstandingOnly'] == true))
	{
		$_POST['order_view_mode'] = 'OutstandingOnly';
		$_SESSION['page_title'] = _($help_context = "Search Outstanding Bilty");
	}
	elseif (isset($_GET['InvoiceTemplates']) && ($_GET['InvoiceTemplates'] == true))
	{
		$_POST['order_view_mode'] = 'InvoiceTemplates';
		$_SESSION['page_title'] = _($help_context = "Search Template for Invoicing");
	}
	elseif (isset($_GET['DeliveryTemplates']) && ($_GET['DeliveryTemplates'] == true))
	{
		$_POST['order_view_mode'] = 'DeliveryTemplates';
		$_SESSION['page_title'] = _($help_context = "Select Template for Delivery");
	}
	elseif (!isset($_POST['order_view_mode']))
	{
		$_POST['order_view_mode'] = false;
		$_SESSION['page_title'] = _($help_context = "Search All Bilty");
	}
}
elseif ($trans_type == ST_TRANSPORTQUOTE)
{
	$_POST['order_view_mode'] = "Quotations";
	$_SESSION['page_title'] = _($help_context = "Search All Loading Slips");
}
else
{
$_POST['order_view_mode'] = "Bookings";
	$_SESSION['page_title'] = _($help_context = "Search All Bookings");
}
if (!@$_GET['popup'])
{
	$js = "";
	if ($use_popup_windows)
		$js .= get_js_open_window(900, 600);
	if ($use_date_picker)
		$js .= get_js_date_picker();
	page($_SESSION['page_title'], false, false, "", $js);
}

if (isset($_GET['selected_consignor']))
{
	$selected_consignor = $_GET['selected_consignor'];
}
elseif (isset($_POST['selected_consignor']))
{
	$selected_consignor = $_POST['selected_consignor'];
}
else
	$selected_consignor = -1;

	if (isset($_GET['selected_consignee']))
{
	$selected_consignee = $_GET['selected_consignee'];
}
elseif (isset($_POST['selected_consignee']))
{
	$selected_consignee = $_POST['selected_consignee'];
}
else
	$selected_consignee = -1;

//---------------------------------------------------------------------------------------------

if (isset($_POST['SelectStockFromList']) && ($_POST['SelectStockFromList'] != "") &&
	($_POST['SelectStockFromList'] != ALL_TEXT))
{
 	$selected_stock_item = $_POST['SelectStockFromList'];
}
else
{
	unset($selected_stock_item);
}
//---------------------------------------------------------------------------------------------
//	Query format functions
//
function check_overdue($row)
{
	global $trans_type;
	if ($trans_type == ST_TRANSPORTQUOTE)
		return (date1_greater_date2(Today(), sql2date($row['delivery_date'])));
	elseif ($trans_type == ST_TRANSPORTBOOKING)
		return (date1_greater_date2(Today(), sql2date($row['delivery_date'])));
	else
		return ($row['type'] == 0
			&& date1_greater_date2(Today(), sql2date($row['delivery_date']))
			&& ($row['TotDelivered'] < $row['TotQuantity']));
}

function view_link($dummy, $order_no)
{
	global $trans_type;
	return  get_consignor_trans_view_str($trans_type, $order_no);
}

function prt_link($row)
{
	global $trans_type;
	return print_document_link($row['order_no'], _("Print"), true, $trans_type, ICON_PRINT);
}
function add_transfer_link($row)
{
	global $trans_type;
	$ref_no = "ref_no";
	return pager_link( _("Edit Vehicle Location"),
    "/transport/manage/vehicle_transfers.php?$ref_no=" . $row['order_no'], ICON_VIEW);
}
function view_transfer_link($row)
{
	global $trans_type;
	$ref_no = "ref_no";
	return pager_link( _("Edit"),
    "/inventory/vehicle_transfers.php?$ref_no=" . $row['order_no'], ICON_EDIT);
}
function edit_link($row) 
{
	if (@$_GET['popup'])
		return '';
	global $trans_type;
	if($trans_type == ST_TRANSPORTORDER)
	$modify = "ModifyOrderNumber";
	elseif($trans_type == ST_TRANSPORTQUOTE)
	$modify = "ModifyQuotationNumber";
	else
	$modify = "ModifyBookingNumber";
  return pager_link( _("Edit"),
    "/transport/transport_order_entry.php?$modify=" . $row['order_no'], ICON_EDIT);
}

function dispatch_link($row)
{
	global $trans_type;
	if ($trans_type == ST_TRANSPORTORDER)
  		return pager_link( _("Dispatch"),
			"/transport/consignor_delivery.php?OrderNumber=" .$row['order_no'], ICON_DOC);
	elseif ($trans_type == ST_TRANSPORTBOOKING)
  		return pager_link( _("Create Loading Slip"),
			"/transport/transport_order_entry.php?OrderNumber=" .$row['order_no'], ICON_DOC);
	else		
  		return pager_link( _("Create Bilty"),
			"/transport/transport_order_entry.php?OrderNumber=" .$row['order_no'], ICON_DOC);
}

function invoice_link($row)
{
	global $trans_type;
	if ($trans_type == ST_TRANSPORTORDER)
  		return pager_link( _("Invoice"),
			"/transport/transport_order_entry.php?NewInvoice=" .$row["order_no"], ICON_DOC);
	else
		return '';
}

function delivery_link($row)
{
  return pager_link( _("Delivery"),
	"/transport/transport_order_entry.php?NewDelivery=" .$row['order_no'], ICON_DOC);
}

function order_link($row)
{
  return pager_link( _("Generate Bilty"),
	"/transport/transport_order_entry.php?NewQuoteToTransportOrder=" .$row['order_no'], ICON_DOC);
}
function loading_link($row)
{
  return pager_link( _("Transport Loading"),
	"/transport/transport_order_entry.php?NewBookingToQuoteOrder=" .$row['order_no'], ICON_DOC);
}

function tmpl_checkbox($row)
{
	global $trans_type;
	if ($trans_type == ST_TRANSPORTQUOTE || $trans_type == ST_TRANSPORTBOOKING)
		return '';
	if (@$_GET['popup'])
		return '';
	$name = "chgtpl" .$row['order_no'];
	$value = $row['type'] ? 1:0;

// save also in hidden field for testing during 'Update'

 return checkbox(null, $name, $value, true,
 	_('Set this order as a template for direct deliveries/invoices'))
	. hidden('last['.$row['order_no'].']', $value, false);
}
//---------------------------------------------------------------------------------------------
// Update db record if respective checkbox value has changed.
//
function change_tpl_flag($id)
{
	global	$Ajax;
	
  	$sql = "UPDATE ".TB_PREF."transport_orders SET type = !type WHERE order_no=$id";

  	db_query($sql, "Can't change transport booking type");
	$Ajax->activate('orders_tbl');
}

$id = find_submit('_chgtpl');
if ($id != -1)
	change_tpl_flag($id);

if (isset($_POST['Update']) && isset($_POST['last'])) {
	foreach($_POST['last'] as $id => $value)
		if ($value != check_value('chgtpl'.$id))
			change_tpl_flag($id);
}

$show_dates = !in_array($_POST['order_view_mode'], array('OutstandingOnly', 'InvoiceTemplates', 'DeliveryTemplates'));
//---------------------------------------------------------------------------------------------
//	Order range form
//
if (get_post('_OrderNumber_changed') || get_post('_OrderReference_changed')) // enable/disable selection controls
{
	$disable = get_post('OrderNumber') !== '' || get_post('OrderReference') !== '';

  	if ($show_dates) {
			$Ajax->addDisable(true, 'OrdersAfterDate', $disable);
			$Ajax->addDisable(true, 'OrdersToDate', $disable);
	}

	$Ajax->activate('orders_tbl');
}

if (!@$_GET['popup'])
	start_form();

//---------------------------------------------------------------------------------------------
//	Orders inquiry table
//

	start_form_section('row page-head');
	start_form_section('text-right col-md-5 col-sm-4 col-xs-6 actions');
		anchor_button(_("Plan A Load"),$path_to_root .'/transport/transport_order_entry.php?NewOrder=Yes','btn btn-primary');
	end_form_section();
	end_form_section();
$sql = get_sql_for_transport_orders_view($selected_consignor, $trans_type,$_POST['order_view_mode']);

if ($trans_type == ST_TRANSPORTORDER)
	$cols = array(
		_("Bilty #") => array('fun'=>'view_link'),
		_("Ref"),
		_("Customer"),
	/*	_("Consignor") => array('type' => 'consignor_name' , 'ord' => '') ,
		_("Branch"),
				
	*/	_("Contact Person"),
		_("Bilty Date"),
		_("Required By"),
		_("Load Status"),
		_("Carrier Status"),
		_("Delivery From"), 
		_("Delivery To"), 
	/*	_("Bilty Total") => array('type'=>'amount', 'ord'=>''),
		'Type' => 'skip',
		_("Currency") => array('align'=>'center'),*/
	    _("Freight"),
	    _("Income"),
        _("Expenses")
        
	);
elseif ($trans_type == ST_TRANSPORTQUOTE)
	$cols = array(
		_("Load #") => array('fun'=>'view_link'),
		_("Ref"),
				
		_("Contact Person"),
		_("Load Date") => 'date',
		_("Valid until") =>array('type'=>'date', 'ord'=>''),
		_("Delivery From"), 
		_("Delivery To"),
		_("Loaded From"),
		_("Contact No")
		
	);
else
$cols = array(
		_("Booking #") => array('fun'=>'view_link'),
		_("Ref"),
		_("Cust Order Ref"),
		_("Load Date") => 'date',
		_("Valid until") =>array('type'=>'date', 'ord'=>''),
		_("Delivery From"), 
		_("Delivery To"),
		_("Contact No"),
                _("Load Status"),
                _("Total Item Value"),
                _("Total Value"),
                _("Total Payment"),
                _("Total Deposits")
	);
if ($_POST['order_view_mode'] == 'OutstandingOnly') {
	//array_substitute($cols, 4, 1, _("Cust Order Ref"));
	array_append($cols, array(
		array('insert'=>true, 'fun'=>'dispatch_link'),
		array('insert'=>true, 'fun'=>'edit_link')));

} elseif ($_POST['order_view_mode'] == 'InvoiceTemplates') {
	array_substitute($cols, 4, 1, _("Description"));
	array_append($cols, array( array('insert'=>true, 'fun'=>'invoice_link')));

} else if ($_POST['order_view_mode'] == 'DeliveryTemplates') {
	array_substitute($cols, 4, 1, _("Description"));
	array_append($cols, array(
			array('insert'=>true, 'fun'=>'delivery_link'))
	);

} elseif ($trans_type == ST_TRANSPORTQUOTE) {
	 array_append($cols,array(
					array('insert'=>true, 'fun'=>'edit_link'),
					array('insert'=>true, 'fun'=>'order_link')/*,
					array('insert'=>true, 'fun'=>'prt_link')*/));
}
elseif ($trans_type == ST_TRANSPORTBOOKING) {
	 array_append($cols,array(
					array('insert'=>true, 'fun'=>'edit_link'),
					array('insert'=>true, 'fun'=>'loading_link')/*,
					array('insert'=>true, 'fun'=>'prt_link')*/));
}
 elseif ($trans_type == ST_TRANSPORTORDER) {
	 array_append($cols,array(
			_("Tmpl") => array('insert'=>true, 'fun'=>'tmpl_checkbox'),
					array('insert'=>true, 'fun'=>'edit_link')/*,
					array('insert'=>true, 'fun'=>'add_transfer_link')*//*,
					array('insert'=>true, 'fun'=>'view_transfer_link'),
					array('insert'=>true, 'fun'=>'prt_link')*/));
};


$table =& new_db_pager('orders_tbl', $sql, $cols,null,null,20);
/*$table->set_marker('check_overdue', _("Marked items are overdue."));
*/
$table->width = "80%";

display_db_pager($table,'orders_tbl');
submit_center('Update', _("Update"), true, '', null);

if (!@$_GET['popup'])
{
	end_form();
	end_page();
}
?>

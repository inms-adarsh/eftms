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
include_once($path_to_root . "/transport/includes/cart_class.inc");
include_once($path_to_root . "/includes/manufacturing.inc");

//--------------------------------------------------------------------------------
function add_to_order(&$order, $new_item, $new_item_qty,$to_units, $price, $discount, $description='')
{
	// calculate item price to sum of kit element prices factor for 
	// value distribution over all exploded kit items
	 $std_price = get_kit_price($new_item, $order->consignor_currency, 
		$order->transport_type,	$order->price_factor, get_post('OrderDate'), true);

	if ($std_price == 0)
		$price_factor = 0;
	else
		$price_factor = $price/$std_price;

	$kit = get_transport_item_kit($new_item);
	$item_num = db_num_rows($kit);

	while($item = db_fetch($kit)) {
		$std_price = get_kit_price($item['stock_id'], $order->consignor_currency, 
			$order->transport_type,	$order->price_factor, get_post('OrderDate'), true);

		// rounding differences are included in last price item in kit
		$item_num--;
		if ($item_num) {
			$price -= $item['quantity']*$std_price*$price_factor;
			$item_price = $std_price*$price_factor;
		} else {
			if ($item['quantity']) 
				$price = $price/$item['quantity'];
			$item_price = $price;
		}
		$item_price = round($item_price, user_price_dec());

	 if (!$item['is_foreign'] && $item['item_code'] != $item['stock_id'])
	 {	// this is transport kit - recurse 
		add_to_order($order, $item['stock_id'], $new_item_qty*$item['quantity'],$to_units,
			$item_price, $discount);
	 }
	 else
	 {	// stock item record eventually with foreign code

		// check duplicate stock item
		foreach ($order->line_items as $order_item)
		{
			if (strcasecmp($order_item->stock_id, $item['stock_id']) == 0)
			{
				display_warning(_("For Part :").$item['stock_id']. " " 
					. _("This item is already on this document. You have been warned."));
				break;
			}
		}
		
		$order->add_to_cart (count($order->line_items),	$item['stock_id'], 
			$new_item_qty*$item['quantity'],$to_units, $item_price, $discount, 0,0, $description);
	 }
	}

}
//---------------------------------------------------------------------------------

function get_consignor_details_to_order(&$order, $consignor_id, $branch_id)
{
	global $SysPrefs;
	
	$ret_error = "";
$myrow = get_consignor_to_order($consignor_id);

	$name = $myrow['name'];

	if ($myrow['dissallow_invoices'] == 1)
		$ret_error = _("The selected consignor account is currently on hold. Please contact the credit control personnel to discuss.");

	$deliver = $myrow['address']; // in case no branch address use company address

	$order->set_consignor($consignor_id, $name, $myrow['curr_code'], 
		$myrow['discount'], $myrow['payment_terms'], $myrow['pymt_discount']);

	// the transport type determines the price list to be used by default
	$order->set_transport_type($myrow['transporttype'], $myrow['transport_type'], $myrow['tax_included'],
	    $myrow['factor']);

	$order->credit = $myrow['cur_credit'];

	
	$result = get_branch_to_order($consignor_id, $branch_id);

	if (db_num_rows($result) == 0)
	{
		return _("The selected consignor and branch are not valid, or the consignor does not have any branches.");
	}

	$myrow = db_fetch($result);

	// FIX - implement editable contact selector in transport booking 
	$contact = get_branch_contacts($branch_id, 'consignor_order', $consignor_id);
	$order->set_branch($branch_id, $myrow["tax_group_id"],
	$myrow["tax_group_name"],$myrow["tin_no"],$myrow['br_post_address']);

	//$address = trim($myrow["br_post_address"]) != '' ? $myrow["br_post_address"]
	//	: (trim($myrow["br_address"]) != '' ? $myrow["br_address"]:$deliver);

	//$order->set_delivery($myrow["default_ship_via"], $myrow["br_name"],
	//	$address);
	$order->ship_via = $myrow["default_ship_via"];
	if ($order->trans_type == ST_TRANSPORTINVOICE) {
		$order->due_date = get_invoice_duedate($order->payment, $order->document_date);
	}
	elseif ($order->trans_type == ST_TRANSPORTORDER)
		$order->due_date = add_days($order->document_date, $SysPrefs->default_delivery_required_by());
	if($order->payment_terms['cash_sale']) {
		$order->set_location($order->pos["pos_location"], $order->pos["location_name"]);
	} 
	
	return $ret_error;
}



function get_consignee_details_to_order(&$order, $consignee_id, $consignee_branch_id)
{
	global $SysPrefs;
	
	$ret_error = "";

	$myrow = get_consignee_to_order($consignee_id);

	$name = $myrow['consignee_name'];
		if ($myrow['dissallow_invoices'] == 1)
		$ret_error = _("The selected consignee account is currently on hold. Please contact the credit control personnel to discuss.");

	$deliver = $myrow['address']; // in case no consignee_branch address use company address

	$order->set_consignee($consignee_id,$name);

	// the transport type determines the price list to be used by default


	$order->credit = $myrow['cur_credit'];

	
	$result = get_consignee_branch_to_order($consignee_id, $consignee_branch_id);

	if (db_num_rows($result) == 0)
	{
		return _("The selected consignee and consignee_branch are not valid, or the consignee does not have any consignee_branches.");
	}

	$myrow = db_fetch($result);

	// FIX - implement editable contact selector in transport booking 
	$contact = get_consignee_branch_contacts($consignee_branch_id, 'consignee_order', $consignee_id);
	$order->consignee_branch = $consignee_branch_id;
	$order->email = @$contact["email"];
    $order->consignee_tin_no = $myrow["tin_no"];
	$address = $deliver;
	//echo $deliver;
	$order->set_delivery( $myrow["br_name"],
		$address);
	if ($order->trans_type == ST_TRANSPORTINVOICE) {
		$order->due_date = get_invoice_duedate($order->payment, $order->document_date);
	}
	elseif ($order->trans_type == ST_TRANSPORTORDER)
		$order->due_date = add_days($order->document_date, $SysPrefs->default_delivery_required_by());
	
	
	return $ret_error;
}



function get_billing_details_to_order(&$order, $consignee_id, $consignee_branch_id)
{
	global $SysPrefs;
	
	$ret_error = "";

	$myrow = get_consignee_to_order($consignee_id);

	$name = $myrow['consignee_name'];
		if ($myrow['dissallow_invoices'] == 1)
		$ret_error = _("The selected consignee account is currently on hold. Please contact the credit control personnel to discuss.");

	$deliver = $myrow['address']; // in case no consignee_branch address use company address

	$order->set_consignee($consignee_id,$name);

	// the transport type determines the price list to be used by default


	$order->credit = $myrow['cur_credit'];

	
	$result = get_consignee_branch_to_order($consignee_id, $consignee_branch_id);

	if (db_num_rows($result) == 0)
	{
		return _("The selected consignee and consignee_branch are not valid, or the consignee does not have any consignee_branches.");
	}

	$myrow = db_fetch($result);

	// FIX - implement editable contact selector in transport booking 
	$contact = get_consignee_branch_contacts($consignee_branch_id, 'consignee_order', $consignee_id);
	$order->consignee_branch = $consignee_branch_id;
	$order->email = @$contact["email"];
    $order->consignee_tin_no = $myrow["tin_no"];
	$address = $deliver;
	//echo $deliver;
	$order->set_billing( $myrow["br_name"],
		$address);
	if ($order->trans_type == ST_TRANSPORTINVOICE) {
		$order->due_date = get_invoice_duedate($order->payment, $order->document_date);
	}
	elseif ($order->trans_type == ST_TRANSPORTORDER)
		$order->due_date = add_days($order->document_date, $SysPrefs->default_delivery_required_by());
	
	
	return $ret_error;
}

function get_driver_details($order,$driver_ref_id)
{
global $SysPrefs;
	
	$ret_error = "";
	$myrow = get_driver($driver_ref_id);
	//$myrow = db_fetch($result);
	$order->driver_ref = $myrow["mobile_no"];
	return $ret_error;
}

//---------------------------------------------------------------------------------

function display_order_summary($title, &$order, $editable_items=false)
{
	global $SysPrefs,$Ajax;
	
	display_heading($title);

    div_start('items_table');
	start_table(TABLESTYLE, "colspan=7 width=90%");
	$th = array(_("Item Code"), _("Item Description"), _("Quantity"),
		_("Delivered"),
		_("Unit"), $order->tax_included ? _("Rate") : _("Rate"), _("Discount %"), _("Total"), "");

	if ($order->trans_no == 0) {
	unset( $th[3] );
	}

	if (count($order->line_items))
	     $th[]= '';

	table_header($th);

	$total = 0;
	$k = 0;  //row colour counter

	$id = find_submit('Edit');
	$has_marked = false;

	foreach ($order->get_items() as $line_no=>$stock_item)
	{

		$line_total = round($stock_item->qty_dispatched * $stock_item->price * (1 - $stock_item->discount_percent),
		   user_price_dec());

		$qoh_msg = '';
		if (!$editable_items || $id != $line_no)
		{
			

			view_stock_status_cell($stock_item->stock_id);

			//label_cell($stock_item->item_description, "nowrap" );
			label_cell($stock_item->item_description );
			$dec = get_qty_dec($stock_item->stock_id);
			qty_cell($stock_item->qty_dispatched, false, $dec);

			if ($order->trans_no!=0)
				qty_cell($stock_item->qty_done, false, $dec);

			//label_cell($stock_item->units);
			label_cell($stock_item->to_units);
			amount_cell($stock_item->price);

			percent_cell($stock_item->discount_percent * 100);
			amount_cell($line_total);

			if ($editable_items)
			{
				edit_button_cell("Edit$line_no", _("Edit"),
				_('Edit document line'));
				delete_button_cell("Delete$line_no", _("Delete"),
				_('Remove line from document'));
			}
			end_row();
		}
		else
		{
			transport_order_item_controls($order, $k,  $line_no);
		}

		$total += $line_total;
	}

	if ($id==-1 && $editable_items)
		transport_order_item_controls($order, $k);

	$colspan = 6;
	if ($order->trans_no!=0)
		++$colspan;
		
	$_POST['tax_total']=0;
	/*if (get_post('add_service_tax')==1) {
	$tax_total = round($total*10/100, 2);
	$_POST['tax_total'] = $tax_total;
	//$tax_total=$total+$tax;
	//copy_to_cart();
	$order->service_tax = $_POST['tax_total'];
	$Ajax->activate('items_table');
	}
	elseif(get_post('add_service_tax')==2)
	{
	echo "yes";
	//$tax_total = 0;
	$_POST['tax_total'] = 0;
	$order->service_tax = $_POST['tax_total'];
	$Ajax->activate('items_table');
	}
	*/

	
	/*start_row();
	//label_cell('', 'colspan=$colspan align=right');
	label_cell(_("Add Taxes"), "colspan=$colspan align=right");
	//check_cells("",'add_service_tax',null,true,true);
	yes_no_by_list_row(_(""),'add_service_tax');
	label_cell('', 'colspan=2');
	end_row();*/
	$freight_expenses = input_num('ship_cost')+input_num('commission_cost')+input_num('way_cost')+input_num('bilty_charge')+input_num('insc_charge')+input_num('labour_charge');
	$display_sub_total = price_format($total + $order->service_tax);
	label_row(_("Freight"), price_format($total), "colspan=$colspan align=right","align=right", 2);
	//label_row(_("Service Tax"), price_format($order->service_tax), "colspan=$colspan align=right","align=right", 2);
	//label_row(_("Freight + Service Tax"), $display_sub_total, "colspan=$colspan align=right","align=right", 2);
	start_row();
	label_cell(_("Shipping Charge"), "colspan=$colspan align=right");
	small_amount_cells(null, 'ship_cost', price_format(get_post('ship_cost',0)));
	
	
	label_cell('', 'colspan=2');
	end_row();
	start_row();
	label_cell(_("Commission Cost"), "colspan=$colspan align=right");
	small_amount_cells(null, 'commission_cost', price_format(get_post('commission_cost',0)));
	label_cell('', 'colspan=2');
	end_row();
	start_row();
	label_cell(_("Way Cost"), "colspan=$colspan align=right");
	small_amount_cells(null, 'way_cost', price_format(get_post('way_cost',0)));
	label_cell('', 'colspan=2');
	end_row();
	start_row();
	label_cell(_("Bilty Cost"), "colspan=$colspan align=right");
	small_amount_cells(null, 'bilty_charge', price_format(get_post('bilty_charge',0)));
	label_cell('', 'colspan=2');
	end_row();
	start_row();
	label_cell(_("Insurance Cost"), "colspan=$colspan align=right");
	small_amount_cells(null, 'insc_charge', price_format(get_post('insc_charge',0)));
	label_cell('', 'colspan=2');
	end_row();
	start_row();
	label_cell(_("Labour Cost"), "colspan=$colspan align=right");
	small_amount_cells(null, 'labour_charge', price_format(get_post('labour_charge',0)));
	label_cell('', 'colspan=2');
	end_row();
	
	//hidden('freight_cost',$freight_expenses);
	
	//print_r($taxes);
	$tax_total =0;
		$taxes = $order->get_taxes($freight_expenses);
		//print_r($taxes);
	/*if (get_post('add_service_tax')==1) {

		$tax_total = display_edit_tax_items($taxes, $colspan, $order->tax_included, 2);
	}
	*/
	
	$tax_total = display_edit_tax_items($taxes, $colspan, $order->tax_included, 2);

	$display_total = price_format($total + $freight_expenses + $tax_total);
	
	start_row();
	label_cells(_("Amount Total"), $display_total, "colspan=$colspan align=right","align=right");
	submit_cells('update', _("Update"), "colspan=2 align='center'", _("Refresh"), true);
	end_row();

	end_table();
	if ($has_marked) {
		display_note(_("Marked items have insufficient quantities in stock as on day of delivery."), 0, 1, "class='stockmankofg'");
		if ($order->trans_type!=30 && !$SysPrefs->allow_negative_stock())
			display_error(_("The delivery cannot be processed because there is an insufficient quantity for item:")
				. '<br>'. $qoh_msg);
	}
    div_end();
}
function display_load_basics(&$order, $editable, $date_text)
{
	global $Ajax, $SysPrefs;
	start_outer_table(TABLESTYLE, "width=80%");
	table_section(1);
	table_section_title(_("Load Information"));
	if (!isset($_POST['OrderDate']) || $_POST['OrderDate'] == "")
			$_POST['OrderDate'] = $order->document_date;

		date_row($date_text, 'OrderDate', _('Date of order receive'),
			$order->trans_no==0, 0, 0, 0, null, true);
		if (isset($_POST['_OrderDate_changed']) || list_updated('payment')) {
			if (!is_company_currency($order->consignor_currency) 
				&& (get_base_transport_type()>0)) {
					$change_prices = 1;
			}
			$Ajax->activate('_ex_rate');
			if ($order->trans_type == ST_TRANSPORTINVOICE) {
				$_POST['delivery_date'] = get_invoice_duedate(get_post('payment'), get_post('OrderDate'));
			} else 
				$_POST['delivery_date'] = add_days(get_post('OrderDate'), $SysPrefs->default_delivery_required_by());
			$Ajax->activate('items_table');
			$Ajax->activate('delivery_date');
		}
		
	
	ref_row(_("Reference").':', 'ref', _('Reference number unique for this document type'), null, '');
	
	all_load_status_list_row(_("Load Status"), 'LoadStatusList', null, false, 
		null, true, false,true);
	
	table_section(2);
	 all_truck_status_type_list_row(_("Truck Status"), 'TruckStatusTypeList', null, false, 
		null,true,false,true);
	
	table_section_title(_("Reference Details"));
	text_row(_("Contact Person:"), 'consignor_ref', $order->consignor_ref, 25, 25,
		  _('Consignor reference number for this order (if any)'));
	text_row(_("Contact Phone Number:"), 'phone', $order->phone, 25, 25,
		    _('Phone number of ordering person. Defaults to branch phone number'));
	
	end_outer_table();
	br();	
	start_outer_table(TABLESTYLE, "width=80%");
	table_section(1);
	table_section_title("Truck Information");
	all_truck_type_list_row(_("Truck Type"), 'TruckTypeList', null, false, 
		null,true,false,true);
	all_commodity_type_list_row(_("Commodity"), 'CommodityTypeList', null, false, 
		null,true,false,true);
	
	table_section(2);
	all_truck_length_type_list_row(_("Truck Length"), 'TruckLengthTypeList', null, false, 
		null,true,false,true);
	textarea_row(_("Comments:"), "Comments", $order->Comments, 31, 5);
	end_outer_table();

}
function display_consignor_info(&$order, $editable, $date_text)
{
		global $Ajax, $SysPrefs;
	$consignor_error = "";
	
	$change_prices = 0;

	start_outer_table(TABLESTYLE, "width=80%");
	table_section(1);
	table_section_title(_("Consignor Details"));
		consignor_list_row(_("Consignor:"), 'consignor_id', null, false, true, false, true);

		if ($order->consignor_id != get_post('consignor_id', -1))
		{
			// consignor has changed
			$Ajax->activate('branch_id');
  		}
		consignor_branches_list_row(_("Consignor Branch:"),
	  	  $_POST['consignor_id'], 'branch_id', null, false, true, true, true);

		 
	
		if( ($order->consignor_id != get_post('consignor_id', -1)) ||
			($order->Branch != get_post('branch_id', -1)) ||
				list_updated('consignor_id')) 
		{

			if (!isset($_POST['branch_id']) || $_POST['branch_id'] == "")
			{
				// ignore errors on consignor search box call
				if ($_POST['consignor_id'] == '')
					$consignor_error = _("No consignor found for entered text.");
				else
					$consignor_error = _("The selected consignor does not have any branches. Please create at least one branch.");
				unset($_POST['branch_id']);
				$order->Branch = 0;
			} 
			else
			{

				$old_order = (PHP_VERSION<5) ? $order : clone( $order );

				$consignor_error = get_consignor_details_to_order($order, $_POST['consignor_id'], $_POST['branch_id']);
			//	$_POST['Location'] = $order->Location;
				$_POST['consignor_tin_no'] = $order->consignor_tin_no;
				if (!in_array($order->trans_type, array(ST_TRANSPORTQUOTE, ST_TRANSPORTORDER, ST_TRANSPORTBOOKING))
					&& ($order->pos['cash_sale'] != $order->pos['credit_sale'])
					&& (($order->payment_terms['cash_sale'] && !$order->pos['cash_sale']) ||
						(!$order->payment_terms['cash_sale'] && !$order->pos['credit_sale']))) {
							// force payment terms refresh if terms are editable
							// and pos have no permitions for terms selected in consignor record.
							// Terms are set to first terms in allowed category below.
							display_warning(
								sprintf(_("Consignor's payment terms '%s' cannot be selected on this POS"),
									$order->payment_terms['terms']));
							$order->payment = '';
				} elseif (get_post('payment') !== $order->payment) {
					$_POST['payment'] = $order->payment;
					$Ajax->activate('delivery');
					$Ajax->activate('payment');
				} else {
					if ($order->trans_type == ST_TRANSPORTINVOICE)
					{
						$_POST['delivery_date'] = $order->due_date;
						$Ajax->activate('delivery_date');
					}
				//	$Ajax->activate('Location');
				//	$Ajax->activate('deliver_to');
				//	$Ajax->activate('phone');
				//	$Ajax->activate('delivery_address');
				}
				// change prices if necessary
				// what about discount in template case?
				if ($old_order->consignor_currency != $order->consignor_currency) {
					$change_prices = 1;
				}
				if ($old_order->transport_type != $order->transport_type) {
				//  || $old_order->default_discount!=$order->default_discount
					$_POST['transport_type'] = $order->transport_type;
					$Ajax->activate('transport_type');
					$change_prices = 1;
				}

				unset($old_order);
			}
			set_global_consignor($_POST['consignor_id']);
		} // changed branch
		else
		{
			$row = get_consignor_to_order($_POST['consignor_id']);
			if ($row['dissallow_invoices'] == 1)
				$consignor_error = _("The selected consignor account is currently on hold. Please contact the credit control personnel to discuss.");
		}
	
		text_row(_("TIN No:"), 'consignor_tin_no', $order->consignor_tin_no, 25, 25,
			_('Additional identifier for delivery e.g. name of receiving person'));

			label_row(_("Billing Address:"),  $order->branch_address);

	end_outer_table();
	br();
				
}
function display_consignee_info(&$order, $editable, $date_text)
{
		global $Ajax, $SysPrefs;
		$consignee_error = "";
		start_outer_table(TABLESTYLE, "width=80%");
		table_section(1);
		table_section_title(_("Consignee Details"));
		consignor_list_row(_("Consignee:"), 'consignee_id', null, false, true, false, true);

		if ($order->consignee_id != get_post('consignee_id', -1))
		{
			// consignor has changed
			$Ajax->activate('consignee_branch_id');
  		}
		consignor_branches_list_row(_("Consignee Branch:"),
	  	  $_POST['consignee_id'], 'consignee_branch_id', null, false, true, true, true);
	
		  if( ($order->consignor_id != get_post('consignee_id', -1)) ||
			($order->consignee_branch != get_post('consignee_branch_id', -1)) ||
				list_updated('consignee_id')) 
		{

			if (!isset($_POST['consignee_branch_id']) || $_POST['consignee_branch_id'] == "")
			{
				// ignore errors on consignee search box call
				if ($_POST['consignee_id'] == '')
					$consignee_error = _("No consignee found for entered text.");
				else
					$consignee_error = _("The selected consignee does not have any consignee_branches. Please create at least one consignee_branch.");
				unset($_POST['consignee_branch_id']);
				$order->consignee_branch = 0;
			} 
			else
			{

				$old_order = (PHP_VERSION<5) ? $order : clone( $order );

				$consignee_error = get_consignee_details_to_order($order, $_POST['consignee_id'], $_POST['consignee_branch_id']);
			
				$_POST['deliver_to'] = $order->deliver_to;
				$_POST['delivery_address'] = $order->delivery_address;
				//$_POST['phone'] = $order->phone;
				$_POST['delivery_date'] = $order->due_date;
				$_POST['consignee_tin_no'] = $order->consignee_tin_no;
				

				if (!in_array($order->trans_type, array(ST_TRANSPORTQUOTE, ST_TRANSPORTORDER,ST_TRANSPORTBOOKING))
					&& ($order->pos['cash_sale'] != $order->pos['credit_sale'])
					&& (($order->payment_terms['cash_sale'] && !$order->pos['cash_sale']) ||
						(!$order->payment_terms['cash_sale'] && !$order->pos['credit_sale']))) {
							// force payment terms refresh if terms are editable
							// and pos have no permitions for terms selected in consignee record.
							// Terms are set to first terms in allowed category below.
							display_warning(
								sprintf(_("consignee's payment terms '%s' cannot be selected on this POS"),
									$order->payment_terms['terms']));
							$order->payment = '';
				} elseif (get_post('payment') !== $order->payment) {
					$_POST['payment'] = $order->payment;
					$Ajax->activate('delivery');
					$Ajax->activate('payment');
				} else {
					if ($order->trans_type == ST_TRANSPORTINVOICE)
					{
						$_POST['delivery_date'] = $order->due_date;
						$Ajax->activate('delivery_date');
					}
					//$Ajax->activate('Location');
					$Ajax->activate('deliver_to');
					//$Ajax->activate('phone');
					$Ajax->activate('delivery_address');
				}
				
				unset($old_order);
			}
			set_global_consignee($_POST['consignee_id']);
		} // changed consignee_branch
		else
		{
			$row = get_consignee_to_order($_POST['consignee_id']);
			if ($row['dissallow_invoices'] == 1)
				$consignee_error = _("The selected consignee account is currently on hold. Please contact the credit control personnel to discuss.");
		}
		text_row(_("TIN No:"), 'consignee_tin_no', $order->consignee_tin_no, 40, 40,
			_('Additional identifier for delivery e.g. name of receiving person'));
		

		date_row($delname, 'delivery_date',
			$order->trans_type==ST_TRANSPORTORDER ?  _('Enter requested day of delivery') : $order->trans_type==ST_TRANSPORTQUOTE ? _('Enter Valid until Date') : $order->trans_type==ST_TRANSPORTBOOKING ? _('Enter Valid until Date') : '');
		text_row(_("Deliver To:"), 'deliver_to', $order->deliver_to, 40, 40,
			_('Additional identifier for delivery e.g. name of receiving person'));

		textarea_row(_("Delivery Address:"), 'delivery_address', $order->delivery_address, 35, 5,
			_('Delivery address. Default is address of consignee branch'));
		end_outer_table();
}
function display_billing_info(&$order, $editable, $date_text)
{
		global $Ajax, $SysPrefs;
		$consignee_error = "";
		start_outer_table(TABLESTYLE, "width=80%");
		table_section(1);
		table_section_title(_("Billing Details"));
		consignor_list_row(_("Consignee:"), 'consignee_id', null, false, true, false, true);

		if ($order->consignee_id != get_post('consignee_id', -1))
		{
			// consignor has changed
			$Ajax->activate('consignee_branch_id');
  		}
		consignor_branches_list_row(_("Consignee Branch:"),
	  	  $_POST['consignee_id'], 'consignee_branch_id', null, false, true, true, true);
	
		  if( ($order->consignor_id != get_post('consignee_id', -1)) ||
			($order->consignee_branch != get_post('consignee_branch_id', -1)) ||
				list_updated('consignee_id')) 
		{

			if (!isset($_POST['consignee_branch_id']) || $_POST['consignee_branch_id'] == "")
			{
				// ignore errors on consignee search box call
				if ($_POST['consignee_id'] == '')
					$consignee_error = _("No consignee found for entered text.");
				else
					$consignee_error = _("The selected consignee does not have any consignee_branches. Please create at least one consignee_branch.");
				unset($_POST['consignee_branch_id']);
				$order->consignee_branch = 0;
			} 
			else
			{

				$old_order = (PHP_VERSION<5) ? $order : clone( $order );

				$consignee_error = get_billing_details_to_order($order, $_POST['consignee_id'], $_POST['consignee_branch_id']);
			
				$_POST['deliver_to'] = $order->deliver_to;
				$_POST['delivery_address'] = $order->delivery_address;
				//$_POST['phone'] = $order->phone;
				$_POST['delivery_date'] = $order->due_date;
				$_POST['consignee_tin_no'] = $order->consignee_tin_no;
				

				if (!in_array($order->trans_type, array(ST_TRANSPORTQUOTE, ST_TRANSPORTORDER,ST_TRANSPORTBOOKING))
					&& ($order->pos['cash_sale'] != $order->pos['credit_sale'])
					&& (($order->payment_terms['cash_sale'] && !$order->pos['cash_sale']) ||
						(!$order->payment_terms['cash_sale'] && !$order->pos['credit_sale']))) {
							// force payment terms refresh if terms are editable
							// and pos have no permitions for terms selected in consignee record.
							// Terms are set to first terms in allowed category below.
							display_warning(
								sprintf(_("consignee's payment terms '%s' cannot be selected on this POS"),
									$order->payment_terms['terms']));
							$order->payment = '';
				} elseif (get_post('payment') !== $order->payment) {
					$_POST['payment'] = $order->payment;
					$Ajax->activate('delivery');
					$Ajax->activate('payment');
				} else {
					if ($order->trans_type == ST_TRANSPORTINVOICE)
					{
						$_POST['delivery_date'] = $order->due_date;
						$Ajax->activate('delivery_date');
					}
					//$Ajax->activate('Location');
					$Ajax->activate('deliver_to');
					//$Ajax->activate('phone');
					$Ajax->activate('delivery_address');
				}
				
				unset($old_order);
			}
			set_global_consignee($_POST['consignee_id']);
		} // changed consignee_branch
		else
		{
			$row = get_consignee_to_order($_POST['consignee_id']);
			if ($row['dissallow_invoices'] == 1)
				$consignee_error = _("The selected consignee account is currently on hold. Please contact the credit control personnel to discuss.");
		}
		text_row(_("TIN No:"), 'consignee_tin_no', $order->consignee_tin_no, 40, 40,
			_('Additional identifier for delivery e.g. name of receiving person'));
		

		text_row(_("Billing Person:"), 'bill_to', $order->deliver_to, 40, 40,
			_('Additional identifier for delivery e.g. name of receiving person'));

		textarea_row(_("Billing Address:"), 'billing_address', $order->delivery_address, 35, 5,
			_('Delivery address. Default is address of consignee branch'));
		end_outer_table();
}

function display_stop_details($title, &$order, $editable_items=false)
{
	global $path_to_root;

	display_heading($title);
    div_start('load_stops');
	start_table(TABLESTYLE, "width=80%");
	$th = array(_("Select Location"),_("Contact"), _("Address"),_("City"),_("Date"),_("Time"), '');
	if ( count($order->line_items)) $th[] = '';
	table_header($th);
	$subtotal = 0;
	$k = 0;  //row colour counter

	$id = find_submit('Edit');
	foreach ($order->line_items as $line_no=>$stock_item)
	{

		if ($id != $line_no)
		{
    		alt_table_row_color($k);

			delivery_locations_list_row(_("Deliver from Location:"), 'Location', null, false,true,false,true);
	
    		label_cell($stock_item->item_description);
    		//qty_cell($stock_item->quantity, false, get_qty_dec($stock_item->stock_id));
    		//label_cell($stock_item->units);

			edit_button_cell("Edit$line_no", _("Edit"),
				_('Edit document line'));
			delete_button_cell("Delete$line_no", _("Delete"),
				_('Remove line from document'));
    		end_row();
		}
		else
		{
			display_edit_stop_details($order, $line_no);
		}
	}

	if ($id == -1)
		display_edit_stop_details($order);

    end_table();
	div_end();
}

//---------------------------------------------------------------------------------

function display_edit_stop_details(&$order, $line_no=-1)
{
	global $Ajax;
	start_row();

	$id = find_submit('Edit');
	if ($line_no != -1 && $line_no == $id)
	{
		hidden('stock_id', $_POST['stock_id']);
		label_cell($_POST['stock_id']);
		label_cell($order->load_stops[$id]->stop_description);
	    $Ajax->activate('stops_table');
	}
	else
	{
    	delivery_locations_list_cells(null, 'Location', null, false,true,false,true);
    	textarea_cells(null,'stop_address', null, 15, 5);
    	text_cells(null,'stop_contact', null, 11, 50);
    	text_cells(null,'stop_city', null, 35, 50);
    	date_cells(null, 'StopDate', null, 25,100);
    	text_cells(null,'stop_time', null, 25, 50);
    }


	if ($id != -1)
	{
		button_cell('UpdateStop', _("Update"),
				_('Confirm changes'), ICON_UPDATE);
		button_cell('CancelStopChanges', _("Cancel"),
				_('Cancel changes'), ICON_CANCEL);
		hidden('OrderNo', $order_no);

	}
	else
	{
		submit_cells('AddStop', _("Add"), "colspan=2",
		    _('Add new stop to load'), true);
	}

	end_row();
}


// ------------------------------------------------------------------------------

function display_order_header(&$order, $editable, $date_text)
{
	global $Ajax, $SysPrefs;
	$consignee_error = "";
	$consignor_error = "";
	$change_prices = 0;
if (!in_array($order->trans_type, array(ST_TRANSPORTQUOTE, ST_TRANSPORTBOOKING)))
{	
	


	table_section(2);

	
	//consignor_credit_row($_POST['consignor_id'], $order->credit);

	//label_row(_("Consignor Discount:"), ($order->default_discount * 100) . "%");
	payment_by_list_row("Payment By",'payment_by',$_POST['payment_by']);
	service_tax_by_list_row("Service Tax Paid By",'service_tax_by',$_POST['service_tax_by']);
	end_outer_table(1); // outer table
	start_outer_table(TABLESTYLE, "width=80%");
	table_section(1);
	
	if ($order->pos['cash_sale'] || $order->pos['credit_sale']) {
		 // editable payment type 
		if (get_post('payment') !== $order->payment) {
			$order->payment = get_post('payment');
			$order->payment_terms = get_payment_terms($order->payment);
			$order->due_date = get_invoice_duedate($order->payment, $order->document_date);
		
			$Ajax->activate('items_table');
			$Ajax->activate('delivery');
		}
		$paymcat = !$order->pos['cash_sale'] ? PM_CREDIT : 
			(!$order->pos['credit_sale'] ? PM_CASH : PM_ANY);
		// all terms are available for SO
		sale_payment_list_cells(_('Payment:'), 'payment', 
			(in_array($order->trans_type, array(ST_TRANSPORTQUOTE, ST_TRANSPORTORDER, ST_TRANSPORTBOOKING)) 
			? PM_ANY : $paymcat), null);
	} else {
		label_cells(_('Payment:'), $order->payment_terms['terms']);
	}
	
		$str = transport_types_list_row(_("Transport Types List:"), 'transport_type', null, true);
	
	
	if ($order->transport_type != $_POST['transport_type']) {
		$myrow = get_transport_type($_POST['transport_type']);
		$order->set_transport_type($myrow['id'], $myrow['transport_type'],
			$myrow['tax_included'], $myrow['factor']);
		$Ajax->activate('transport_type');
		$change_prices = 1;
	}
	

	table_section(2);

		end_outer_table(2); // outer table

	if ($change_prices != 0) {
		foreach ($order->line_items as $line_no=>$item) {
			$line = &$order->line_items[$line_no];
			$line->price = get_kit_price($line->stock_id, $order->consignor_currency,
				$order->transport_type, $order->price_factor, get_post('OrderDate'));
		//		$line->discount_percent = $order->default_discount;
		}
	    $Ajax->activate('items_table');
	}

}	
else
{
start_outer_table(TABLESTYLE2, "width=80%");
	table_section(1);

		if (!isset($_POST['OrderDate']) || $_POST['OrderDate'] == "")
			$_POST['OrderDate'] = $order->document_date;

		date_row($date_text, 'OrderDate', _('Date of order receive'),
			$order->trans_no==0, 0, 0, 0, null, true);
		if (isset($_POST['_OrderDate_changed']) || list_updated('payment')) {
			if (!is_company_currency($order->consignor_currency) 
				&& (get_base_transport_type()>0)) {
					$change_prices = 1;
			}
			$Ajax->activate('_ex_rate');
			if ($order->trans_type == ST_TRANSPORTINVOICE) {
				$_POST['delivery_date'] = get_invoice_duedate(get_post('payment'), get_post('OrderDate'));
			} else 
				$_POST['delivery_date'] = add_days(get_post('OrderDate'), $SysPrefs->default_delivery_required_by());
			$Ajax->activate('items_table');
			$Ajax->activate('delivery_date');
		}
		
	
	ref_row(_("Reference").':', 'ref', _('Reference number unique for this document type'), null, '');
	end_outer_table(1); // outer table

}
return $consignor_error;
}

//--------------------------------------------------------------------------------

function transport_order_item_controls(&$order, &$rowcounter, $line_no=-1)
{
    global $Ajax;
	alt_table_row_color($rowcounter);

	$id = find_submit('Edit');
	if ($line_no!=-1 && $line_no == $id) // edit old line
	{
		$_POST['stock_id'] = $order->line_items[$id]->stock_id;
		$dec = get_qty_dec($_POST['stock_id']);
		$_POST['qty'] = number_format2($order->line_items[$id]->qty_dispatched, $dec);
		$_POST['price'] = price_format($order->line_items[$id]->price);
		$_POST['Disc'] = percent_format($order->line_items[$id]->discount_percent*100);
		
		//$to_units = $order->line_items[$id]->to_units;
		$_POST['item_description'] = $order->line_items[$id]->item_description;
		hidden('stock_id', $_POST['stock_id']);
		label_cell($_POST['stock_id']);
		if ($order->line_items[$id]->descr_editable)
			text_cells(null,'item_description', null, 45, 150);
		else {
			hidden('item_description', $_POST['item_description']);
			label_cell($_POST['item_description']);
		}
		
		
//		} else {
//			transport_items_list_cells(null,'item_description', null, false, true);
//		}
		//label_cell($order->line_items[$line_no]->item_description, "nowrap");
	    $Ajax->activate('items_table');
	}
	else	// prepare new line
	{
		transport_items_list_cells(null,'stock_id', null, false, true, true);
		if (list_updated('stock_id')) {
			    $Ajax->activate('price');
			    $Ajax->activate('to_units');
			    $Ajax->activate('qty');
			    $Ajax->activate('line_total');
		}

		$item_info = get_item_edit_info($_POST['stock_id']);
		
		$dec = $item_info['decimals'];
		$_POST['qty'] = number_format2(1, $dec);
		$price = get_kit_price($_POST['stock_id'],
			$order->consignor_currency, $order->transport_type,
			$order->price_factor, get_post('OrderDate'));
		$_POST['price'] = price_format($price);
		// default to the consignor's discount %
		$_POST['Disc'] = percent_format($order->default_discount * 100);
	}

	qty_cells(null, 'qty', $_POST['qty'], null, null, $dec);

	if ($order->trans_no!=0) {
		qty_cell($line_no==-1 ? 0 :$order->line_items[$line_no]->qty_done, false, $dec);
	}
	if ($line_no!=-1 && $line_no == $id) // edit old line
	{
	$_POST['to_units'] = $order->line_items[$id]->to_units;
	stock_units_list_cells(null, 'to_units',$_POST['to_units'], true);
	}
	else
	{
	stock_units_list_cells(null, 'to_units',null, true);
	}
	//label_cell($units, '', 'units');

	amount_cells(null, 'price');

	small_amount_cells(null, 'Disc', percent_format($_POST['Disc']), null, null, user_percent_dec());

	$line_total = input_num('qty') * input_num('price') * (1 - input_num('Disc') / 100);

	amount_cell($line_total, false, '','line_total');

	if ($id!=-1)
	{
		button_cell('UpdateItem', _("Update"),
				_('Confirm changes'), ICON_UPDATE);
		button_cell('CancelItemChanges', _("Cancel"),
				_('Cancel changes'), ICON_CANCEL);
		hidden('LineNo', $line_no);
		set_focus('qty');
	}
	else
	{
		submit_cells('AddItem', _("Add Item"), "colspan=2 align='center'",
		    _('Add new item to document'), true);
	}

	end_row();

}

//--------------------------------------------------------------------------------

function display_delivery_details(&$order)
{
	global $Ajax;

	div_start('delivery');	
	
		if ($order->trans_type==ST_TRANSPORTINVOICE)
		{
			$title = _("Delivery Details");
			$delname = _("Due Date").':';
		}
		elseif ($order->trans_type==ST_CONSIGNORDELIVERY)
		{
			$title = _("Invoice Delivery Details");
			$delname = _("Invoice before").':';
		}
		elseif ($order->trans_type==ST_TRANSPORTQUOTE)
		{
			$title = _("Loading Slip Details");
			$delname = _("Valid until").':';
		}
		elseif ($order->trans_type==ST_TRANSPORTBOOKING)
		{
			$title = _("Booking Details");
			$delname = _("Valid until").':';
		}
		else
		{
			$title = _("Bilty Details");
			$delname = _("Required Delivery Date").':';
		}
		if ($order->payment_terms['cash_sale']) {	// Direct payment sale
			display_heading(_('Cash payment'));
		} else {
				display_heading($title);
		}
		start_outer_table(TABLESTYLE2);
		table_section(1);
		//
	
		delivery_locations_list_row(_("Deliver from Location:"), 'Location', null, false,true,false,true);
		
		delivery_locations_list_row(_("Delivery Location:"), 'Location_to', null, false,  true,false,true);
		
if($order->delivery_type!=2)
	{
	
		
		shippers_list_row(_("Shipping Company:"), 'ship_via', $order->ship_via);
		
		table_section_title(_("Consignee Details"));
		

			shippers_list_row(_("Shipping Company:"), 'ship_via', $order->ship_via);
		table_section_title(_("Consignee Details"));
		consignee_list_row(_("Consignee:"), 'consignee_id', null, false, true, true, true);

		if ($order->consignee_id != get_post('consignee_id', -1))
		{
			// consignor has changed
			$Ajax->activate('consignee_branch_id');
  		}
		consignee_branches_list_row(_("Consignee Branch:"),
	  	  $_POST['consignee_id'], 'consignee_branch_id', null, false, true, true, true);
	
		if( ($order->consignee_id != get_post('consignee_id', -1)) ||
			($order->consignee_branch != get_post('consignee_branch_id', -1)) ||
				list_updated('consignee_id')) 
		{

			if (!isset($_POST['consignee_branch_id']) || $_POST['consignee_branch_id'] == "")
			{
				// ignore errors on consignee search box call
				if ($_POST['consignee_id'] == '')
					$consignee_error = _("No consignee found for entered text.");
				else
					$consignee_error = _("The selected consignee does not have any consignee_branches. Please create at least one consignee_branch.");
				unset($_POST['consignee_branch_id']);
				$order->consignee_branch = 0;
			} 
			else
			{

				$old_order = (PHP_VERSION<5) ? $order : clone( $order );

				$consignee_error = get_consignee_details_to_order($order, $_POST['consignee_id'], $_POST['consignee_branch_id']);
			
				$_POST['deliver_to'] = $order->deliver_to;
				$_POST['delivery_address'] = $order->delivery_address;
				//$_POST['phone'] = $order->phone;
				$_POST['delivery_date'] = $order->due_date;
				$_POST['consignee_tin_no'] = $order->consignee_tin_no;
				

				if (!in_array($order->trans_type, array(ST_TRANSPORTQUOTE, ST_TRANSPORTORDER,ST_TRANSPORTBOOKING))
					&& ($order->pos['cash_sale'] != $order->pos['credit_sale'])
					&& (($order->payment_terms['cash_sale'] && !$order->pos['cash_sale']) ||
						(!$order->payment_terms['cash_sale'] && !$order->pos['credit_sale']))) {
							// force payment terms refresh if terms are editable
							// and pos have no permitions for terms selected in consignee record.
							// Terms are set to first terms in allowed category below.
							display_warning(
								sprintf(_("consignee's payment terms '%s' cannot be selected on this POS"),
									$order->payment_terms['terms']));
							$order->payment = '';
				} elseif (get_post('payment') !== $order->payment) {
					$_POST['payment'] = $order->payment;
					$Ajax->activate('delivery');
					$Ajax->activate('payment');
				} else {
					if ($order->trans_type == ST_TRANSPORTINVOICE)
					{
						$_POST['delivery_date'] = $order->due_date;
						$Ajax->activate('delivery_date');
					}
				//	$Ajax->activate('Location');
					$Ajax->activate('deliver_to');
				//	$Ajax->activate('phone');
					$Ajax->activate('delivery_address');
				}
				
				unset($old_order);
			}
			set_global_consignee($_POST['consignee_id']);
		} // changed consignee_branch
		else
		{
			$row = get_consignee_to_order($_POST['consignee_id']);
			if ($row['dissallow_invoices'] == 1)
				$consignee_error = _("The selected consignee account is currently on hold. Please contact the credit control personnel to discuss.");
		}
		text_row(_("TIN No:"), 'consignee_tin_no', $order->consignee_tin_no, 40, 40,
			_('Additional identifier for delivery e.g. name of receiving person'));
	

		date_row($delname, 'delivery_date',
			$order->trans_type==ST_TRANSPORTORDER ?  _('Enter requested day of delivery') : $order->trans_type==ST_TRANSPORTQUOTE ? _('Enter Valid until Date') :$order->trans_type==ST_TRANSPORTBOOKING ? _('Enter Valid until Date') : '');
		if(!in_array($order->trans_type, array(ST_TRANSPORTBOOKING,ST_TRANSPORTQUOTE)))
	
		text_row(_("Deliver To:"), 'deliver_to', $order->deliver_to, 40, 40,
			_('Additional identifier for delivery e.g. name of receiving person'));

		textarea_row(_("Delivery Address:"), 'delivery_address', $order->delivery_address, 35, 5,
			_('Delivery address. Default is address of consignee branch'));
		
	

		table_section_title(_("Driver Details"));
		driver_list_row(_("Driver:"), 'driver_id', null, false, true, false, true);
		$order->driver_id =$_POST['driver_id'] ;
		
		
		if( ($order->driver_id != get_post('driver_id', -1)) ||
				list_updated('driver_id')) 
		{

			if (!isset($_POST['driver_id']) || $_POST['driver_id'] == "")
			{

			// ignore errors on consignee search box call
				if ($_POST['driver_id'] == '')
					$consignee_error = _("No driver found for entered text.");
				else
					$consignee_error = _("The selected driver does not have any number. Please update in the system.");
				unset($_POST['driver_id']);
				$order->driver_ref = 0;
			}
		
		 
			else
			{

				$old_order = (PHP_VERSION<5) ? $order : clone( $order );

				$consignee_error = get_driver_details($order, $_POST['driver_id']);
			
				$_POST['driver_ref'] = $order->driver_ref;
			
					$Ajax->activate('driver_ref');
				
				
				unset($old_order);
			}
		}
		text_row(_("Driver Contact Number:"), 'driver_ref', $order->driver_ref, 25, 25,
		  _('Consignor reference number for this order (if any)'));
	
	table_section_title(_("Vehicle Details"));
		vehicle_list_row(_("Vehicle:"), 'vehicle_id', $order->vehicle_id, false, false, false, true);
		$order->vehicle_id=$_POST['vehicle_id'];
	
	
	table_section_title(_("Goods Details"));
		amount_cells(_("Total Goods Value:"), 'total_goods_value', price_format(get_post('total_goods_value',0)));
		$order->total_goods_value=$_POST['total_goods_value'];
		text_row(_("Goods Bill No"), 'goods_bill_no', $order->goods_bill_no, 40, 40,
			_('Bill No of transported Goods'));
	
		table_section_title(_("Driver Details"));
		driver_list_row(_("Driver:"), 'driver_id', null, false, true, false, true);
		
		if( ($order->driver_id != get_post('driver_id', -1)) ||
				list_updated('driver_id')) 
		{

			if (!isset($_POST['driver_id']) || $_POST['driver_id'] == "")
			{

			// ignore errors on consignee search box call
				if ($_POST['driver_id'] == '')
					$consignee_error = _("No driver found for entered text.");
				else
					$consignee_error = _("The selected driver does not have any number. Please update in the system.");
				unset($_POST['driver_id']);
				$order->driver_ref = 0;
			}
		
		 
			else
			{

				$old_order = (PHP_VERSION<5) ? $order : clone( $order );

				$consignee_error = get_driver_details($order, $_POST['driver_id']);
			
				$_POST['driver_ref'] = $order->driver_ref;
			
					$Ajax->activate('driver_ref');
				
				
				unset($old_order);
			}
		}
			text_row(_("Driver Contact Number:"), 'driver_ref', $order->driver_ref, 25, 25,
		  _('Consignor reference number for this order (if any)'));
		table_section_title(_("Vehicle Details"));
		vehicle_list_row(_("Vehicle:"), 'vehicle_id', $order->vehicle_id, true, false, false, true);
	
	
	
		table_section_title(_("Loading Details"));
		text_row(_("Loaded From:"), 'loaded_from', $order->loaded_from, 40, 40,
			_('Additional identifier for loading e.g. name of receiving person'));

		textarea_row(_("Loading Address:"), 'loading_address', $order->loading_address, 35, 5,
			_('Loading address'));

		if ($order->payment_terms['cash_sale']) 
		
		table_section_title(_("Cash Account Details"));
 
		label_row(_("Cash account:"), $order->pos['bank_account_name']);
		textarea_row(_("Comments:"), "Comments", $order->Comments, 31, 5);
		
		
		hidden('delivery_date', $order->due_date);


		end_outer_table(1);
			
	
	div_end();
}
}
?>
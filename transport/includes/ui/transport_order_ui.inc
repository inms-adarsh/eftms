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
//require_once($path_to_root . "/transport/GoogleMapAPI.class.php");

//--------------------------------------------------------------------------------
// Prabha added for adding payments-----------------------------------------------

function display_payment_details($title, &$order, $editable_items=false)
{
	global $Ajax, $Refs;
	

	$consignor_error = false;
	if ($consignor_error)
	{
		end_form();
		end_page();
		exit;
	}
        
         
display_payment_items(_("Expenses"), $order);
//gl_options_controls($_SESSION['pay_items']);

}


function display_payment_items($title, &$order)
{
	global $path_to_root;



    div_start('payment_table');
	
	form_section_title($title);
	start_display_table('table','id');
    $th = array(_("Type"),_("Customer/driver"),_("Account Code"), _("Account Description"),_("Amount"), _("Memo"), "","");

	//if (count($order->gl_items)) $th[] = '';

	display_table_header($th);
	$k = 0;  //row colour counter

	$id = find_submit('EditPayment');
        
	foreach ($order->gl_payment_items as $line => $item)
	{
            
		if ($id != $line)
		{
                    
    		alt_table_row_color($k);
                        hidden('type',$item->type);
                        
                        label_cell($item->entity_type == 0?'Customer': 'Driver');
                        
                        if ($item->entity_type == 0) //consignor
                        {
                            $var_consignor_row = get_consignor_info($item->consignor_no);
                            $var_consignor = $var_consignor_row['name'];
                            label_cell($var_consignor);
                        }
                        else
                        {
                            $var_driver_row = get_driver_desc($item->driver_no);
                            $var_driver_name = $var_driver_row['driver_name'];
                            label_cell($var_driver_name);
                        }
                        
                        
                        
			label_cell($item->code_id);
			label_cell($item->description);
                        
            $item->amount = user_numeric($item->amount);
			amount_cell($item->amount);
			
                        label_cell($item->line_memo);

			edit_button_cell("EditPayment".$line, _("Edit"),
				_('Edit document line'));
			delete_button_cell("DeletePayment".$line, _("Delete"),
				_('Remove line from document'));
    		end_row();
		}
		else
		{
			payment_edit_item_controls($order,  $line);
		}
	}

	if ($id == -1)
		payment_edit_item_controls($order);

	//if ($order->count_gl_items())
		//label_row(_("Total"), number_format2(abs($order->gl_items_total()), user_price_dec()),"colspan=" . $colspan . " align=right", "align=right",3);

    end_display_table();
	div_end();
}

//---------------------------------------------------------------------------------

function payment_edit_item_controls(&$order,  $Index=null)
{
	global $Ajax;
	//$payment = $order->trans_type == ST_BANKPAYMENT;

        
	start_row();
	$id = find_submit('EditPayment');
	if ($Index != -1 && $Index == $id)
	{
            
                $item = $order->gl_payment_items[$Index];
		
                $_POST['PaymentPayType']= $item->entity_type;
                if ($item->entity_type == 0)
                    $_POST['payment_person_id'] = $item->consignor_no;
                else
                    $_POST['payment_person_id'] = $item->driver_no;
                $_POST['payment_PersonDetailID'] = $item->branch_code;
                
                
                if(isset($_POST['_payment_code_id_update'])) 
		    $Ajax->activate('payment_code_id');
				echo "<td>";
                payment_payee_types_list_cells( null,'PaymentPayType', null, true);
                echo "</td>";
                if (list_updated('PaymentPayType'))
                     {
                        $Ajax->activate('payment_person_id');
                        $Ajax->activate('payment_PersonDetailID');
                     }
                if (list_updated('payment_person_id'))
                        $Ajax->activate('payment_PersonDetailID');
               echo "<td>";      
                consignor_driver_list_cells(null, 'payment_person_id', null, true, true,false,false,$_POST['PaymentPayType']);
                 echo "</td>"; 
               
                
		$_POST['payment_code_id'] = $item->code_id;
		$_POST['payment_amount'] = user_numeric(abs($item->amount));
                
		$_POST['payment_description'] = $item->description;
		$_POST['payment_LineMemo'] = $item->line_memo;
                hidden('payment_type',$item->type);
		hidden('PaymentIndex', $id);
		
		echo gl_all_accounts_list('payment_code_id', null, true, true);
		
	    $Ajax->activate('payment_table');
	}
	else
	{
            	
		$_POST['payment_amount'] = price_format(0);
		$_POST['payment_LineMemo'] = ""; // let memo go to next line Joe Hunt 2010-05-30
                
		if(isset($_POST['_payment_code_id_update'])) 
		    $Ajax->activate('payment_code_id');
				echo "<td>"; 
                payment_payee_types_list_cells( null,'PaymentPayType', null, true);
                echo "</td>"; 
                if (list_updated('PaymentPayType'))
                     {
                        $Ajax->activate('payment_person_id');
                        $Ajax->activate('payment_PersonDetailID');
                     }
                if (list_updated('payment_person_id'))
                        $Ajax->activate('payment_PersonDetailID');
                 echo "<td>";     
                consignor_driver_list_cells(null, 'payment_person_id', null, true, true,false,false,$_POST['PaymentPayType']);
                 echo "</td>";             
                
                $acc = get_branch_accounts($_POST['payment_PersonDetailID']);
                $_POST['payment_code_id'] = $acc['receivables_account'];
                    
		echo gl_all_accounts_list('payment_code_id', null, true, true);
		 
	}
            
                
		amount_cells(null, 'payment_amount');
		 echo "<td>";
        	text_cells_ex(null, 'payment_LineMemo', 35, 255);
         echo "</td>";

	if ($id != -1)
	{
		button_cell('Update_Payment_Item', _("Update"),	_('Confirm changes'), ICON_UPDATE);
		button_cell('Cancel_Payment_Item', _("Cancel"),	_('Cancel changes'), ICON_CANCEL);
 		set_focus('payment_amount');
	}
	else
	{
		submit_cells('Add_Payment_Item', _("Add Item"), "colspan=2",
		    _('Add new item to document'), true);
	}

	end_row();
}




function display_deposit_details($title, &$order, $editable_items=false)
{
	global $Ajax, $Refs;
	

	$consignor_error = false;
	div_start('dep_header');

	
        

	if ($consignor_error)
	{
		end_form();
		end_page();
		exit;
	}
       
        $_SESSION['deposit_date']           = $_POST['deposit_date'];

display_deposit_items(_("Income"), $order);
//gl_options_controls($_SESSION['pay_items']);
}




function display_deposit_items($title, &$order)
{
	global $path_to_root;

	 div_start('deposit_table');
	form_section_title($title);
	start_display_table('table','id');
	

        $th = array(_("Type"),_("Customer/driver"),_("Account Code"), _("Account Description"),_("Amount"), _("Memo"), "");

	if (count($order->gl_deposit_items)) $th[] = '';

	display_table_header($th);
	$k = 0;  //row colour counter

	$id = find_submit('EditDeposit');
        
	foreach ($order->gl_deposit_items as $line => $item)
	{
            
		if ($id != $line)
		{
                    
    		alt_table_row_color($k);
                        hidden('deposit_type',$item->type);
                        
                          label_cell($item->entity_type == 0?'Customer': 'Driver');
                        
                        if ($item->entity_type == 0) //consignor
                        {
                            $var_consignor_row = get_consignor_info($item->consignor_no);
                            $var_consignor = $var_consignor_row['name'];
                            label_cell($var_consignor);
                        }
                        else
                        {
                            $var_driver_row = get_driver_desc($item->driver_no);
                            $var_driver_name = $var_driver_row['driver_name'];
                            label_cell($var_driver_name);
                        }

                        
                        
                        
			label_cell($item->code_id);
			label_cell($item->description);
            $item->amount = user_numeric(($item->amount));
			amount_cell($item->amount);
			
			label_cell($item->line_memo);

			edit_button_cell("EditDeposit".$line, _("Edit"),
				_('Edit document line'));
			delete_button_cell("DeleteDeposit".$line, _("Delete"),
				_('Remove line from document'));
    		end_row();
		}
		else
		{
			deposit_edit_item_controls($order,  $line);
		}
	}

	if ($id == -1)
		deposit_edit_item_controls($order);

	//if ($order->count_gl_items())
		//label_row(_("Total"), number_format2(abs($order->gl_items_total()), user_price_dec()),"colspan=" . $colspan . " align=right", "align=right",3);
    end_display_table();
	div_end();
}

//---------------------------------------------------------------------------------

function deposit_edit_item_controls(&$order,  $Index=null)
{
	global $Ajax;
	//$payment = $order->trans_type == ST_BANKPAYMENT;

        
	start_row();
	$id = find_submit('EditDeposit');
	if ($Index != -1 && $Index == $id)
	{
            
                $item = $order->gl_deposit_items[$Index];
		
                
                   $_POST['DepositPayType']= $item->entity_type;
                if ($item->entity_type == 0)
                    $_POST['deposit_person_id'] = $item->consignor_no;
                else
                    $_POST['deposit_person_id'] = $item->driver_no;
                
                $_POST['deposit_PersonDetailID'] = $item->branch_code;
                
                
                if(isset($_POST['_deposit_code_id_update'])) 
		    $Ajax->activate('deposit_code_id');
				 echo "<td>";  
                payment_payee_types_list_cells( null,'DepositPayType', null, true);
                 echo "</td>";  
                if (list_updated('DepositPayType'))
                     {
                        $Ajax->activate('deposit_person_id');
                        $Ajax->activate('deposit_PersonDetailID');
                     }
                if (list_updated('deposit_person_id'))
                        $Ajax->activate('deposit_PersonDetailID');
                echo "<td>";        	
                consignor_driver_list_cells(null, 'deposit_person_id', null, true, true,false,false,$_POST['DepositPayType']);
                   echo "</td>";    
                
                
		$_POST['deposit_code_id'] = $item->code_id;
		$_POST['deposit_amount'] = user_numeric(($item->amount));
		$_POST['deposit_description'] = $item->description;
		$_POST['deposit_LineMemo'] = $item->line_memo;
                hidden('deposit_type',$item->type);
		hidden('DepositIndex', $id);
		
		echo gl_all_accounts_list('deposit_code_id', null, true, true);
		
	    $Ajax->activate('deposit_table');
	}
	else
	{
            	
		$_POST['deposit_amount'] = price_format(0);
		$_POST['deposit_LineMemo'] = ""; // let memo go to next line Joe Hunt 2010-05-30
                
                
		if(isset($_POST['_deposit_code_id_update'])) {
			    $Ajax->activate('deposit_code_id');
		}
                
                 echo "<td>";  
                payment_payee_types_list_cells( null,'DepositPayType', null, true);
                 echo "</td>";  
                if (list_updated('DepositPayType'))
                     {
                        $Ajax->activate('deposit_person_id');
                        $Ajax->activate('deposit_PersonDetailID');
                     }
                if (list_updated('deposit_person_id'))
                        $Ajax->activate('deposit_PersonDetailID');
                echo "<td>";        
                consignor_driver_list_cells(null, 'deposit_person_id', null, true, true,false,false,$_POST['DepositPayType']);
                  echo "</td>";     
                
                $acc = get_branch_accounts($_POST['deposit_PersonDetailID']);
                $_POST['deposit_code_id'] = $acc['receivables_account'];
              
		echo gl_all_accounts_list('deposit_code_id', null, true, true);
		
	}
	

	amount_cells(null, 'deposit_amount');
	 echo "<td>";
	text_cells_ex(null, 'deposit_LineMemo', 35, 255);
	 echo "</td>";
	if ($id != -1)
	{
		button_cell('Update_Deposit_Item', _("Update"),	_('Confirm changes'), ICON_UPDATE);
		button_cell('Cancel_Deposit_Item', _("Cancel"),	_('Cancel changes'), ICON_CANCEL);
 		set_focus('deposit_amount');
	}
	else
	{
		submit_cells('Add_Deposit_Item', _("Add Item"), "colspan=2",_('Add new item to document'), true);
	}

	end_row();
}

// ------------------------------------------------------------------------------
// Prabha added on July 1st 2015 for adding multiple consignors

function display_consignor($title, &$order, $editable_items=false)
{
	global $SysPrefs,$Ajax;
	div_start('consignor_table');
	form_section_title($title);

	start_display_table('table','id');
	$th = array( _("Customer"), _("Tin No"),_("Address"),_("phone"),_("email"),'');
	//_("Select Location"),_("Contact"), _("Address"),_("Date"),_("hours"),_("minutes"),_("time"), ''

	if ($order->trans_no == 0) {
	unset( $th[6] );
	}

	if (count($order->consignor_line_items))
	     $th[]= '';

	display_table_header($th);

	
	$k = 0;  //row colour counter

	$id = find_submit('EditConsignor');
	$has_marked = false;
//print_r($order);
	foreach ($order->get_consign_items() as $line_no => $stock_item)
	{
		if (!$editable_items || $id != $line_no)
		{

			label_cell($stock_item->consignor_name, "nowrap" );
		                
                        label_cell($stock_item->tin_no);
                        label_cell($stock_item->address);
                         label_cell($stock_item->phone);
                          label_cell($stock_item->email);

			if ($editable_items)
			{
				edit_button_cell("EditConsignor$line_no", _("Edit"),
				_('Edit document line'));
				delete_button_cell("DeleteConsignor$line_no", _("Delete"),
				_('Remove line from document'));
			}
			end_row();
		}
		else
		{

			consignor_item_controls($order, $k,  $line_no);
		}

		
	}

	if ($id==-1 && $editable_items)
        {
            consignor_item_controls($order, $k);
        }
	end_display_table();
	
	div_end();
}

// Prabha ended
//------------Prabha added on 2nd July -----------------------------------
function add_to_consignor_order(&$order, $consignor_no,$consignor_name,$tin_no,$address,$phone,$email)
{
    
		
		$order->add_to_consignor_cart (count($order->consignor_line_items),$consignor_no,$consignor_name,$tin_no,$address,$phone,$email);
                
	

}
//-------Prabha ended---------------------------------------------------------
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

function get_consignor_details_to_order(&$order, $consignor_id)
{
	global $SysPrefs;
	
	$ret_error = "";
	$myrow = get_consignor_to_order($consignor_id);

	$name = $myrow['name'];

	$deliver = $myrow['address']; // in case no branch address use company address
	
	$order->set_consignor($consignor_id, $name,$myrow["tin_no"],$myrow['address'],$myrow['phone'],$myrow['email']);

	return $ret_error;
}



function get_consignee_details_to_order(&$order, $consignee_id)
{
	global $SysPrefs;
	
	$ret_error = "";

	$myrow = get_consignor_to_order($consignee_id);

	$deliver = $myrow['address']; // in case no consignee_branch address use company address

	$order->set_consignee($consignee_id,$name,$myrow['phone'],$myrow['email']);
	$order->consignee_tin_no = $myrow["tin_no"];
	$address = $deliver;
	//echo $deliver;
	$order->set_delivery( $myrow["contact_name"],
		$address);
	
	return $ret_error;
}



function get_billing_details_to_order(&$order, $billing_id)
{
	global $SysPrefs;
	
	$ret_error = "";

	$myrow = get_consignor_to_order($billing_id);


	$deliver = $myrow['address']; // in case no consignee_branch address use company address

	
	// FIX - implement editable contact selector in transport booking 
	$order->email = $myrow["email"];
    $order->billing_tin_no = $myrow["tin_no"];
	$address = $deliver;
	//echo $deliver;
	$order->set_billing($consignee_id,$name, $myrow["contact_name"],
		$address,$myrow['phone'],$myrow['email']);
	
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
	
	
	form_section_title(_("Cash Terms"));
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
		$str = transport_types_list_row(_("Tax:"), 'transport_type', null, true);
	
	
	if ($order->transport_type != $_POST['transport_type']) {
		$myrow = get_transport_type($_POST['transport_type']);
		$order->set_transport_type($myrow['id'], $myrow['transport_type'],
			$myrow['tax_included'], $myrow['factor']);
		$Ajax->activate('transport_type');
		$change_prices = 1;
	}
	
	
	
	//textarea_row(_("Comments:"), "Comments", $order->Comments, 31, 5);
	
			
	


    div_start('items_table');
    
	form_section_title($title);
	start_display_table('table','id');
	$th = array(_("Item Code"), _("Item Description"), _("Quantity"),
		
		_("Unit"), $order->tax_included ? _("Rate") : _("Rate"), _("Discount %"), _("Total"), "","");

	if ($order->trans_no == 0) {
	unset( $th[3] );
	}

	if (count($order->line_items))
	     $th[]= '';

	display_table_header($th);

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

			/*if ($order->trans_no!=0)
				qty_cell($stock_item->qty_done, false, $dec);
*/
			//label_cell($stock_item->units);
			label_cell($stock_item->to_units);
			amount_cell($stock_item->price);

			percent_cell($stock_item->discount_percent * 100);
			amount_cell($line_total);

			if ($editable_items)
			{
				edit_button_cell("EditItem$line_no", _("Edit"),
				_('Edit document line'));
				delete_button_cell("DeleteItem$line_no", _("Delete"),
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
	start_row();
	label_cell(_("Freight"), "colspan=$colspan align=right");
	
	label_cell(price_format($total), '');
	end_row();
	
	//label_row(_("Service Tax"), price_format($order->service_tax), "colspan=$colspan align=right","align=right", 2);
	//label_row(_("Freight + Service Tax"), $display_sub_total, "colspan=$colspan align=right","align=right", 2);
	start_row();
	label_cell(_("Shipping Charge"), "colspan=$colspan align=right");
	amount_cells(null, 'ship_cost', price_format(get_post('ship_cost',0)));
	
	
	label_cell('', 'colspan=2');
	end_row();
	start_row();
	label_cell(_("Commission Cost"), "colspan=$colspan align=right");
	amount_cells(null, 'commission_cost', price_format(get_post('commission_cost',0)));
	label_cell('', 'colspan=2');
	end_row();
	start_row();
	label_cell(_("Way Cost"), "colspan=$colspan align=right");
	amount_cells(null, 'way_cost', price_format(get_post('way_cost',0)));
	label_cell('', 'colspan=2');
	end_row();
	start_row();
	label_cell(_("Bilty Cost"), "colspan=$colspan align=right");
	amount_cells(null, 'bilty_charge', price_format(get_post('bilty_charge',0)));
	label_cell('', 'colspan=2');
	end_row();
	start_row();
	label_cell(_("Insurance Cost"), "colspan=$colspan align=right");
	amount_cells(null, 'insc_charge', price_format(get_post('insc_charge',0)));
	label_cell('', 'colspan=2');
	end_row();
	start_row();
	label_cell(_("Labour Cost"), "colspan=$colspan align=right");
	amount_cells(null, 'labour_charge', price_format(get_post('labour_charge',0)));
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

	label_cell(_("Amount Total"), "colspan=$colspan align=right");
	
	label_cell($display_total, '');
	
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
	
	form_section_title(_("Load Information"));
	
	
	
	all_load_status_list_row(_("Load Status"), 'LoadStatusList', null, false, 
		null, true, false,true);

	text_row(_("Contact Person:"), 'contact_person', $order->contact_person, 25, 25,
		  _('Contact Person for this order (if any)'));
	
	
	
	text_row(_("Contact Phone Number:"), 'contact_phone', $order->contact_phone, 25, 25,
		    _('Phone number of ordering person'));
	 all_truck_status_type_list_row(_("Truck Status"), 'TruckStatusTypeList', null, false, 
		null,true,false,true);
	
	
	br();	
	
/*	table_section(1);
	form_section_title("Truck Information");
	all_truck_type_list_row(_("Truck Type"), 'TruckTypeList', null, false, 
		null,true,false,true);
	all_commodity_type_list_row(_("Commodity"), 'CommodityTypeList', null, false, 
		null,true,false,true);
	*/
	
	delivery_locations_list_row(_("Deliver from Location:"), 'Location', null, false,true,false,true);
	shippers_list_row(_("Shipping Company:"), 'ship_via', $order->ship_via);
		
/*	all_truck_length_type_list_row(_("Truck Length"), 'TruckLengthTypeList', null, false, 
		null,true,false,true);
*/	
	
	
	delivery_locations_list_row(_("Delivery Location:"), 'Location_to', null, false,  true,false,true);
	textarea_row(_("Comments:"), "Comments", $order->Comments, 31, 5);
	
	

}
function display_carrier_info(&$order)
{
	global $Ajax, $SysPrefs;
		form_section_title(_("Vehicle Details"));
		vehicle_list_row(_("Vehicle:"), 'vehicle_id', $order->vehicle_id, true, true, false, true);
		$order->vehicle_id=$_POST['vehicle_id'];
		print_r($order->loadstop_line_items);

		driver_list_row(_("Driver:"), 'driver_id', null, true, true, false, true);
		
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
		  _('Driver Contact number for this order (if any)'));
	
		
		form_section_title(_("Goods Details"));
		amount_row(_("Total Goods Value:"), 'total_goods_value', price_format(get_post('total_goods_value',0)));
		$order->total_goods_value=$_POST['total_goods_value'];
	
		text_row(_("Goods Bill No"), 'goods_bill_no', $order->goods_bill_no, 40, 40,
			_('Bill No of transported Goods'));
		text_row(_("Loaded From:"), 'loaded_from', $order->loaded_from, 40, 40,
			_('Additional identifier for loading e.g. name of receiving person'));
		textarea_row(_("Loading Address:"), 'loading_address', $order->loading_address, 35, 5,
			_('Loading address'));
			
}
function display_consignor_info(&$order, $editable, $date_text)
{
		global $Ajax, $SysPrefs;
	$consignor_error = "";
	
	$change_prices = 0;

	
	table_section(1);
	form_section_title(_("Customer Details"));
		consignor_list_row(_("Customer:"), 'consignor_id', null, true, true, false, true);

		if( ($order->consignor_id != get_post('consignor_id', -1)) ||
				list_updated('consignor_id')) 
		{

				$old_order = (PHP_VERSION<5) ? $order : clone( $order );

				$consignor_error = get_consignor_details_to_order($order, $_POST['consignor_id']);
			//	$_POST['Location'] = $order->Location;
				$_POST['consignor_tin_no'] = $order->consignor_tin_no;
				
				if ($old_order->transport_type != $order->transport_type) {
				//  || $old_order->default_discount!=$order->default_discount
					$_POST['transport_type'] = $order->transport_type;
					$Ajax->activate('transport_type');
					$change_prices = 1;
				}

				unset($old_order);
			
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

	
	br();
				
}
function display_consignee_info(&$order, $editable, $date_text)
{
		global $Ajax, $SysPrefs;
		$consignee_error = "";
		
		form_section_title(_("Consignee Details"));
                print_r($order->loadstop_line_items);
print_r($order->consignor_line_items);
		consignor_list_row(_("Customer:"), 'consignee_id', null, true, true, false, true);
		  if(list_updated('consignee_id')) 
		{

				echo $order->consignee_id;
		
				$old_order = (PHP_VERSION<5) ? $order : clone( $order );

				$consignee_error = get_consignee_details_to_order($order, $_POST['consignee_id']);
			
				$_POST['deliver_to'] = $order->deliver_to;
				$_POST['delivery_address'] = $order->delivery_address;
				//$_POST['phone'] = $order->phone;
				$_POST['consignee_tin_no'] = $order->consignee_tin_no;
				$_POST['consignee_phone'] = $order->consignee_phone;
				$_POST['consignee_email'] = $order->consignee_email;
					//$Ajax->activate('Location');
					$Ajax->activate('deliver_to');
					$Ajax->activate('consignee_phone');
					$Ajax->activate('consignee_email');
					$Ajax->activate('delivery_address');
					$Ajax->activate('consignee_tin_no');
		} // changed consignee_branch

		else
		{
			$row = get_consignee_to_order($_POST['consignee_id']);
			if ($row['dissallow_invoices'] == 1)
				$consignee_error = _("The selected consignee account is currently on hold. Please contact the credit control personnel to discuss.");
		}
		text_row(_("Deliver To:"), 'deliver_to', $order->deliver_to, 40, 40,
			_('Additional identifier for delivery e.g. name of receiving person'));
			text_row(_("Phone Number:"), 'consignee_phone', $order->consignee_phone, 25, 25,
		    _('Phone number of consignee. Defaults to primary phone number'));
		
		text_row(_("TIN No:"), 'consignee_tin_no', $order->consignee_tin_no, 40, 40,
			_('Additional identifier for delivery e.g. name of receiving person'));
		textarea_row(_("Delivery Address:"), 'delivery_address', $order->delivery_address, 35, 5,
			_('Delivery address. Default is address of consignee branch'));
	
	
	email_row(_("Email Address:"), 'consignee_email', $order->consignee_email, 25, 25,
		    _('Email Address of consignee. Defaults to primary email'));
	
		
}
function display_billing_info(&$order, $editable, $date_text)
{
		global $Ajax, $SysPrefs;
		$consignee_error = "";
	
		form_section_title(_("Billing Details"));
		
		consignor_list_row(_("Customer:"), 'billing_id', null, true, true, false, true);
		  if( ($order->billing_id != get_post('billing_id', -1)) ||
				list_updated('billing_id')) 
		{

				$old_order = (PHP_VERSION<5) ? $order : clone( $order );

				$consignee_error = get_billing_details_to_order($order, $_POST['billing_id']);
			
				$_POST['bill_to'] = $order->bill_to;
				$_POST['billing_address'] = $order->billing_address;
				$_POST['billing_phone'] = $order->billing_phone;
				$_POST['billing_email'] = $order->billing_email;
				//$_POST['phone'] = $order->phone;
				
				$_POST['billing_tin_no'] = $order->billing_tin_no;
						$Ajax->activate('bill_to');
					$Ajax->activate('billing_phone');
					$Ajax->activate('billing_email');
					$Ajax->activate('billing_address');
					$Ajax->activate('billing_tin_no');
		
				unset($old_order);
			
		}
		text_row(_("Billing Person:"), 'bill_to', $order->bill_to, 40, 40,
			_('Additional identifier for delivery e.g. name of receiving person'));
		text_row(_("Contact Phone Number:"), 'billing_phone', $order->billing_phone, 25, 25,
		    _('Phone number of billing person. Defaults to primary phone number'));
		
		text_row(_("TIN No:"), 'billing_tin_no', $order->billing_tin_no, 40, 40,
			_('Additional identifier for delivery e.g. name of receiving person'));
		

		textarea_row(_("Billing Address:"), 'billing_address', $order->billing_address, 35, 5,
			_('Delivery address. Default is address of consignee branch'));

	
	
		email_row(_("Contact Email Address:"), 'billing_email', $order->billing_email, 25, 25,
		    _('Email Address of ordering person. Defaults to primary email'));
		
	
}

function display_stop_details($title, &$order, $editable_items=false)
{
	global $path_to_root;
	
	div_start('stops_table');
	
	form_section_title($title);

	start_display_table('table','id');
	$th = array(_("Select Location"),_("Contact"), _("Address"),_("Date"),_("hours"),_("minutes"),_("time"), '');
	if ( count($order->loadstop_line_items)) $th[] = '';
	display_table_header($th);
	
	$k = 0;  //row colour counter

	$id = find_submit('EditLoadstop');
	foreach ($order->loadstop_line_items as $line_no=>$stock_item)
	{
//print_r($stock_item);
		if ($id != $line_no)
		{
    		alt_table_row_color($k);

			            label_cell($stock_item->location_name);
                        label_cell($stock_item->contact);
                        label_cell($stock_item->address);
                       // label_cell($stock_item->city);
                        label_cell($stock_item->date);
                        
                        $var_time = $stock_item->time;
                        
                        $var_min_pos = strpos($var_time, ":");
                        
                        $var_hour = substr($var_time,0,$var_min_pos);
                        $var_min = substr($var_time,$var_min_pos+1,strlen($var_time));
                        label_cell($var_hour);
                        label_cell($var_min);
                        label_cell($var_hour.":".$var_min);
                        
			edit_button_cell("EditLoadstop$line_no", _("Edit"),
				_('Edit document line'));
			delete_button_cell("DeleteStop$line_no", _("Delete"),
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

    end_display_table();
    
	div_end();
}

//---------------------------------------------------------------------------------

function display_edit_stop_details(&$order, $line_no=-1)
{
	global $Ajax;
	start_row();

	$id = find_submit('EditLoadstop');
	if ($line_no != -1 && $line_no == $id)  // edit old line
	{
            //print_r($order->loadstop_line_items[$id]);
              $_POST['loc_code'] = $order->loadstop_line_items[$id]->loc_code;
              $var_location_info = get_location_info($_POST['loc_code']);
              $var_address =$order->loadstop_line_items[$id]->address;
              $var_location_name =$order->loadstop_line_items[$id]->location_name;
              $var_contact =$order->loadstop_line_items[$id]->contact;
              $var_date =$order->loadstop_line_items[$id]->date;
              $var_time =$order->loadstop_line_items[$id]->time;
              
              $var_min_pos = strpos($var_time, ":");
              $var_hour = substr($var_time,0,$var_min_pos);
              $var_min = substr($var_time,$var_min_pos+1,strlen($var_time));
              
		hidden('loc_code', $_POST['loc_code']);
		
		label_cell($var_location_name);
                text_cells("",'stop_contact',$var_contact);
                text_cells(null,'stop_address', $var_address);
             //   text_cells(null,'stop_city', null, 35, 50);
                
                 echo "<td>";
                date_cells(null, 'stop_date', $var_date, 25,25);
                echo "</td>";
                hidden('stop_time',$var_time);
                echo "<td>";
                number_list_cells(null, 'hour', $var_hour, 0, 10, false,true);
                echo "</td>";
                echo "<td>";
                number_list_cells(null, 'min', $var_min, 0, 10, false,true);
                echo "</td>";
                label_cell($var_time);
	    $Ajax->activate('stops_table');
	}
	else
	{
            //Prepare new line
		echo "<td>";
    	delivery_locations_list_cells(null, 'loc_code', null, true,true,true,true);
        echo "</td>";
          if (list_updated('loc_code'))
               {    
                    $Ajax->activate('stop_address');
                    $Ajax->activate('stop_contact');
                  //  $Ajax->activate('stop_city');
                     $var_location_info = get_location_info($_POST['loc_code']);
       				 $var_location_address = $var_location_info['delivery_address'];
       				 $var_location_contact = $var_location_info['contact'];
       
                }

    	text_cells(null,'stop_contact', $var_location_contact, 11, 50);
    
        text_cells(null,'stop_address', $var_location_address, 11, 50);
//  	text_cells(null,'stop_city', null, 35, 50);
    	echo "<td>";
    	date_cells(null, 'stop_date', null);
        echo "</td>";
        echo "<td>";
        number_list_cells(null, 'hour', null, 0, 10, false,true);
        echo "</td>";
        if (list_updated('hour') )
                $Ajax->activate('stop_time');
        echo "<td>";
        number_list_cells(null, 'min', null, 0, 10, false,true);
        echo "</td>";
        if (list_updated('min') )
                $Ajax->activate('stop_time');
        text_cells(null,'stop_time',$_POST['hour'].":".$_POST['min'],25,"",false,"","","readonly"); 
        //text_cells(null,'stop_time',$_POST['hour'].":".$_POST['min'],5,"",false,"",""); 
        
        
    }


	if ($id != -1)
	{
		button_cell('UpdateStop', _("Update"),
				_('Confirm changes'), ICON_UPDATE);
		button_cell('CancelStopChanges', _("Cancel"),
				_('Cancel changes'), ICON_CANCEL);
		hidden('Loadstop_LineNo', $line_no);
                
		set_focus('stop_contact');

	}
	else
	{
		submit_cells('AddStop', _("Add"), "colspan=2",
		    _('Add new stop to load'), true);
	}

	end_row();
}
function display_stop_googlemap_details($title, &$order, $editable_items=false)
{
    
global $path_to_root, $Ajax;

div_start('routes_table');
$Ajax->activate('routes_table');	

form_section_title($title);
$var_loc_code ='';
$var_marker_id = '';

//print_r($_SESSION['Items']->loadstop_line_items);
//print_r($_SESSION['Items']->consignor_line_items);
//print_r($order->loadstop_line_items);
//$stock_item->location_name
//echo'prabha'.$order->loadstop_line_items[0]->location_name;


foreach ($order->loadstop_line_items as $stock_item)
        $var_loc_code = $stock_item->loc_code .",".$var_loc_code ;

foreach ($order->loadstop_delivery_line_items as $stock_item)
        $var_loc_code = $var_loc_code .$stock_item->delivery_loc_code.",";

foreach($order->loadstop_markers_line_items as $stock_item)
        $var_marker_id = $stock_item->id.",".$var_marker_id;


$var_loc_code = rtrim($var_loc_code,",");
$var_marker_id = rtrim($var_marker_id,",");
        
$var_src_path = $path_to_root."/transport/includes/ui/phpsqlinfo_add.php?ord=".$var_loc_code."&ref=".$order->reference."&markers=".$var_marker_id;
    echo "<iframe style=\"width: 800px; height: 800px\" src=".$var_src_path."></iframe>";

//display_error ($var_map_html);
div_end();
}
function display_stop_route_details($title, &$order, $editable_items=false)
{
    global $path_to_root;
    $map = new GoogleMapAPI('map');
    // setup database for geocode caching

   //$map->setDSN('mysql://root@localhost/eftms_16@GEOCODES');
//    // enter YOUR Google Map Key
   $map->setAPIKey('AIzaSyAowQwqi_I-OQHu89UCjJEfYLb7HPeKijI');
   
   $map->addMarkerByAddress("Jaipur","Marker Title", "Marker Description");
    $map->addMarkerByCoords(77.5945627,12.9715987);
   //display_error('hello');
   echo "<head>";
   
      $map->printHeaderJS(); 
     $map->printMapJS(); 
     echo "<style type='text/css'>
      v\:* {
        behavior:url(#default#VML);
      }
    </style>
    </head>
     <body onload=\"onLoad()\">
    <table border=1>
    <tr><td>";
     $map->printMap(); 
     $map->printSidebar(); 
     echo "</td></tr></table>";
    
  


}
// Displaying delivery stop details
function display_stop_delivery_details($title, &$order, $editable_items=false)
{
	global $path_to_root;
	
	div_start('stops_delivery_table');
	
	form_section_title($title);

	start_display_table('table','id');
	$th = array(_("Select Location"),_("Contact"), _("Address"),_("Date"),_("hours"),_("minutes"),_("time"), '');
	if ( count($order->loadstop_delivery_line_items)) $th[] = '';
	display_table_header($th);
	
	$k = 0;  //row colour counter

	$id = find_submit('EditLoadstopDelivery');
	foreach ($order->loadstop_delivery_line_items as $line_no=>$stock_item)
	{

		if ($id != $line_no)
		{
    		alt_table_row_color($k);

                        label_cell($stock_item->delivery_location_name);
                        label_cell($stock_item->delivery_contact);
                        label_cell($stock_item->delivery_address);
                       // label_cell($stock_item->city);
                        label_cell($stock_item->delivery_date);
                        
                        $var_time = $stock_item->delivery_time;
                        
                        $var_min_pos = strpos($var_time, ":");
                        
                        $var_hour = substr($var_time,0,$var_min_pos);
                        $var_min = substr($var_time,$var_min_pos+1,strlen($var_time));
                        label_cell($var_hour);
                        label_cell($var_min);
                        label_cell($var_hour.":".$var_min);
                        
			edit_button_cell("EditLoadstopDelivery$line_no", _("Edit"),
				_('Edit document line'));
			delete_button_cell("DeleteStopDelivery$line_no", _("Delete"),
				_('Remove line from document'));
    		end_row();
		}
		else
		{
			display_edit_stop_delivery_details($order, $line_no);
		}
	}

	if ($id == -1)
		display_edit_stop_delivery_details($order);

    end_display_table();
    
	div_end();
}

//---------------------------------------------------------------------------------

function display_edit_stop_delivery_details(&$order, $line_no=-1)
{
	global $Ajax;
	start_row();

	$id = find_submit('EditLoadstopDelivery');
	if ($line_no != -1 && $line_no == $id)  // edit old line
	{
            
            //print_r($order->loadstop_line_items[$id]);
              $_POST['delivery_loc_code'] = $order->loadstop_delivery_line_items[$id]->delivery_loc_code;
              $var_location_info = get_location_info($_POST['delivery_loc_code']);
            
              $var_address = $order->loadstop_delivery_line_items[$id]->delivery_address;
              $var_location_name =$order->loadstop_delivery_line_items[$id]->delivery_location_name;
              $var_contact =$order->loadstop_delivery_line_items[$id]->delivery_contact;
              $var_date =$order->loadstop_delivery_line_items[$id]->delivery_date;
              $var_time =$order->loadstop_delivery_line_items[$id]->delivery_time;
              
              $var_min_pos = strpos($var_time, ":");
              $var_hour = substr($var_time,0,$var_min_pos);
              $var_min = substr($var_time,$var_min_pos+1,strlen($var_time));
              
		hidden('delivery_loc_code', $_POST['delivery_loc_code']);
		label_cell($var_location_name);
                text_cells("",'stop_delivery_contact',$var_contact);
                text_cells(null,'stop_delivery_address', $var_address);
             //   text_cells(null,'stop_city', null, 35, 50);
                
                 echo "<td>";
                date_cells(null, 'stop_delivery_date', $var_date, 25,25);
                echo "</td>";
                hidden('stop_delivery_time',$var_time);
                echo "<td>";
                number_list_cells(null, 'delivery_hour', $var_hour, 0, 10, false,true);
                echo "</td>";
                echo "<td>";
                number_list_cells(null, 'delivery_min', $var_min, 0, 10, false,true);
                echo "</td>";
                label_cell($var_time);
	    $Ajax->activate('stops_delivery_table');
	}
	else
	{
            //Prepare new line
            
                echo "<td>";
    	delivery_locations_list_cells(null, 'delivery_loc_code', null, true,true,true,true);
        echo "</td>";
          if (list_updated('delivery_loc_code'))
               {    
                    $Ajax->activate('stop_delivery_address');
                    $Ajax->activate('stop_delivery_contact');
                  //  $Ajax->activate('stop_city');
                     $var_location_info = get_location_info($_POST['delivery_loc_code']);
       				 $var_location_address = $var_location_info['delivery_address'];
       				 $var_location_contact = $var_location_info['contact'];
       
                }

        
    	text_cells(null,'stop_delivery_contact', $var_location_contact, 11, 50);
    
        text_cells(null,'stop_delivery_address', $var_location_address, 11, 50);
//  	text_cells(null,'stop_city', null, 35, 50);
    	echo "<td>";
    	date_cells(null, 'stop_delivery_date', null);
        echo "</td>";
        echo "<td>";
        number_list_cells(null, 'delivery_hour', null, 0, 10, false,true);
        echo "</td>";
        if (list_updated('delivery_hour') )
                $Ajax->activate('stop_delivery_time');
        echo "<td>";
        number_list_cells(null, 'delivery_min', null, 0, 10, false,true);
        echo "</td>";
        if (list_updated('delivery_min') )
                $Ajax->activate('stop_delivery_time');
        text_cells(null,'stop_delivery_time',$_POST['delivery_hour'].":".$_POST['delivery_min'],25,"",false,"","","readonly"); 
        //text_cells(null,'stop_time',$_POST['hour'].":".$_POST['min'],5,"",false,"",""); 
        
        
    }


	if ($id != -1)
	{
		button_cell('UpdateStopDelivery', _("Update"),
				_('Confirm changes'), ICON_UPDATE);
		button_cell('CancelStopChangesDelivery', _("Cancel"),
				_('Cancel changes'), ICON_CANCEL);
		hidden('Loadstop_delivery_LineNo', $line_no);
                
		set_focus('stop_delivery_contact');

	}
	else
	{
		submit_cells('AddStopDelivery', _("Add"), "colspan=2",
		    _('Add new stop to load'), true);
	}

	end_row();
}


// ------------------------------------------------------------------------------



// ------------------------------------------------------------------------------


function display_order_header(&$order, $editable, $date_text)
{
	global $Ajax, $SysPrefs;
	$consignee_error = "";
	$consignor_error = "";
	$change_prices = 0;


	

		if (!isset($_POST['OrderDate']) || $_POST['OrderDate'] == "")
			$_POST['OrderDate'] = $order->document_date;

		date_row($date_text, 'OrderDate', _('Date of order receive'),
			$order->trans_no==0, 0, 0, 0, null, true);

	ref_row(_("Reference").':', 'ref', _('Reference number unique for this document type'), null, '');
     // outer table
    date_row(_("Delivery Date"), 'delivery_date',_('Enter requested day of delivery') );
		
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
		

	 // outer table
 // outer table

return $consignor_error;
}

//---------------------------------------------------------------------------------------
// Prabha added for consignor info details on 2nd July2015
function consignor_item_controls(&$order, &$rowcounter, $line_no=-1)
{
    global $Ajax;
	alt_table_row_color($rowcounter);

	$id = find_submit('EditConsignor');
        
	if ($line_no!=-1 && $line_no == $id) // edit old line
	{
            
               $_POST['consignor_code'] = $order->consignor_line_items[$id]->consignor_code;
        	$_POST['consignor_name'] = $order->consignor_line_items[$id]->consignor_name;
                $var_tin_no = $order->consignor_line_items[$id]->tin_no;
                $var_address = $order->consignor_line_items[$id]->address;
                 $var_phone = $order->consignor_line_items[$id]->phone;
                  $var_email = $order->consignor_line_items[$id]->email;
		hidden('consignor_code', $_POST['consignor_code']);
                
			label_cell($_POST['consignor_name']);
                text_cells("",'tin_no',$var_tin_no);
                text_cells(null, 'address', $var_address);
                text_cells("",'phone',$var_phone);
                text_cells("",'email',$var_email);
	    $Ajax->activate('consignor_table');
	}
	else	// prepare new line
	{
            
		echo "<td>";
		consignor_list_cells(null,'consignor_code', null, true, true, false, true);
       	echo "</td>";
		if (list_updated('consignor_code'))
                {
                 //   $Ajax->activate('consignor_branch_code');
                    $Ajax->activate('tin_no');
                    $Ajax->activate('address');
                    $Ajax->activate('phone');
                    $Ajax->activate('email');
                        $var_get_consignor_branch_details = get_consignor_info($_POST['consignor_code']);
                $var_tin_no = $var_get_consignor_branch_details['tin_no'];
                $var_address = $var_get_consignor_branch_details['address'];
          		$var_phone = $var_get_consignor_branch_details['phone'];
          		$var_email = $var_get_consignor_branch_details['email'];

                }
                   text_cells(null, 'tin_no',$var_tin_no);
               
                text_cells(null, 'address', $var_address);
               text_cells(null,'phone',$var_phone);
                text_cells(null,'email',$var_email);
                //  consignor_branches_list_cells(null,$_POST['consignor_code'],'consignor_branch_code',null,false,true,true);
            
	}


	if ($id!=-1)
	{
		button_cell('UpdateConsignorItem', _("Update"),
				_('Confirm changes'), ICON_UPDATE);
		button_cell('CancelConsignorItemChanges', _("Cancel"),
				_('Cancel changes'), ICON_CANCEL);
		hidden('Consignor_LineNo', $line_no);
                
		set_focus('tin_no');
	}
	else
	{
		submit_cells('AddConsignorItem', _("Add Consignor"), "colspan=2 align='center'",
		    _('Add new consignor to document'), true);
	}

	end_row();

}

//------------------------Prabha ended funtion consignor_item_controls-----------------------------------------------------------
function transport_order_item_controls(&$order, &$rowcounter, $line_no=-1)
{
    global $Ajax;
	alt_table_row_color($rowcounter);

	$id = find_submit('EditItem');
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

	/*if ($order->trans_no!=0) {
		qty_cell($line_no==-1 ? 0 :$order->line_items[$line_no]->qty_done, false, $dec);
	}*/
	if ($line_no!=-1 && $line_no == $id) // edit old line
	{
	$_POST['to_units'] = $order->line_items[$id]->to_units;
	echo "<td>";
	stock_units_list_cells(null, 'to_units',$_POST['to_units'], true);
	echo "</td>";
	}
	else
	{
		echo "<td>";
	stock_units_list_cells(null, 'to_units',null, true);
	echo "</td>";
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

		
if($order->delivery_type!=2)
	{
	
		
		
		form_section_title(_("Consignee Details"));
		

			shippers_list_row(_("Shipping Company:"), 'ship_via', $order->ship_via);
		form_section_title(_("Consignee Details"));
		consignee_list_row(_("Customer:"), 'consignee_id', null, false, true, true, true);

		if ($order->consignee_id != get_post('consignee_id', -1))
		{
			// consignor has changed
			$Ajax->activate('consignee_branch_id');
  		}
	
		if( ($order->consignee_id != get_post('consignee_id', -1)) ||
				list_updated('consignee_id')) 
		{


				$old_order = (PHP_VERSION<5) ? $order : clone( $order );

				$consignee_error = get_consignee_details_to_order($order, $_POST['consignee_id']);
			
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
			
			set_global_consignee($_POST['consignee_id']);
		} // changed consignee_branch
		else
		{
			$row = get_consignor_to_order($_POST['consignee_id']);
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
		
	

		form_section_title(_("Driver Details"));
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
	
	form_section_title(_("Vehicle Details"));
		if ($order->payment_terms['cash_sale']) 
		
		form_section_title(_("Cash Account Details"));
 
		label_row(_("Cash account:"), $order->pos['bank_account_name']);
		textarea_row(_("Comments:"), "Comments", $order->Comments, 31, 5);
		
		
		hidden('delivery_date', $order->due_date);


		
			
	
	div_end();
}
}
?>
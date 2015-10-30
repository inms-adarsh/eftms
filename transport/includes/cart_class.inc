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
/* Definition of the cart class
this class can hold all the information for:

i)   a transport booking
ii)  an invoice
iii) a credit note
iv)  a delivery note
*/

include_once($path_to_root . "/inventory/includes/inventory_db.inc");
include_once($path_to_root . "/taxes/tax_calc.inc");

class cart
{
	var $trans_type; // invoice, order, quotation, delivery note ...
	var $trans_no = array();// array (num1=>ver1,..) or 0 for new
	var $so_type = 0;		// for transport booking: simple=0 template=1
	var $cart_id;		// used to detect multi-tab edition conflits
	var $line_items;  //array of objects of class line_details
	var $Location_to;
	var $src_docs = array();	// array of arrays(num1=>ver1,...) or 0 for no src
	var $src_date;			// src document date (for info only)
	var $load_stops;
	var $document_date;
	var $due_date;
	var $transport_type; // set to the consignor's transport type
	var $transport_type_name; // set to consignor's transport type name
	var $tax_included;
	var $TruckStatusTypeList;
	var $consignor_currency; // set to the consignor's currency
	var $default_discount; // set to the consignor's discount %
	var $consignor_name;
	var $consignor_id;
	var $consignee_name;
	var $consignee_id;
	var $consignee_branch;
	var $Branch;
	var $email;
	var $consignor_tin_no;
	var $consignee_tin_no;
	var $consignee_phone;
	var $consignee_email;
	var $deliver_to;
	var $driver_ref;
	var $delivery_address;
	var $goods_bill_no;
	var $phone;
	var $driver_mobile_no;
	var $driver_id; 
	var $vehicle_id;
	var $total_goods_value;
	var $driver_name;
	var $vehicle_number_plate;
	var $contact_person;
	var $consignee_ref;
	var $reference;
	var $Comments;
	var $Location;
	var $location_name;
	var $location_name_to;
	var $loading_address;
	var $loaded_from;
	var $order_no; 		// the original order number
	var $delivery_type;
	var $ship_via;
	var $freight_cost = 0;
	var $ship_cost ;
	var $commission_cost = 0;
	var $way_cost = 0;
	var $bilty_charge = 0;
	var $insc_charge = 0;
	var $labour_charge = 0 ;
	var $tax_group_id;
	var $tax_group_name;
	var $tax_group_array = null; // saves db queries
	var $price_factor;	 // ditto for price calculations
    var $LoadStatusList;
	var	$pos;			// user assigned POS (contains cash accont number/name)
	var $cash_discount;	// not used as of FA 2.1
	var $dimension_id;
	var $dimension2_id;
	var $payment;
	var $payment_terms; // cached payment terms
	var $credit;
	var $ex_rate;
	var $service_tax=0;
	var $service_tax_paid;
	var $service_tax_by;
	var $payment_by;
	var $branch_address;
	var $branch_contact;
	var $branch_phone;
	var $contact_phone;
	var $branch_email;
	var $branch_fax;
	var $bill_to;
	var $billing_address;
	var $billing_tin_no;
	var $billing_id;
	var $billing_name;
	var $billing_phone;
	var $billing_email;
       //Prabha added  variables for payment and deposit
        
        var $paid_from_account;
        var $paid_date;
        var $paid_account_reference;
        
        var $deposit_from_account;
        var $deposit_date;
        var $deposit_account_reference;
        
        
        
        
        
        var $consignor_line_items;  //array of objects of class line_details 
        var $loadstop_line_items;  //array of objects of class line_details 
        var $gl_payment_items; // array of objects of class gl_items
        var $gl_deposit_items; // array of objects of class gl_items
	//-------------------------------------------------------------------------
	//
	//  $trans_no==0 => open new/direct document
	//  $trans_no!=0 && $prep_child==false => update with parent constarints for reedition
	//  $trans_no!=0 && $prep_child==true => prepare for child doc entry
	//
	function Cart($type, $trans_no=0, $prep_child=false) {
		/*Constructor function initialises a new shopping cart */
		$this->line_items = array();
                $this->consignor_line_items = array(); //prabha added on 1stJul2015
                $this->loadstop_line_items = array(); //prabha added on 1stJul2015
                $this->gl_payment_items = array(); //prabha added for payments 
                $this->gl_deposit_items = array(); //prabha added for deposits
		$this->transport_type = "";
		if ($type == ST_TRANSPORTQUOTE)
		{
			$this->trans_type = $type;
		}
		elseif ($type == ST_TRANSPORTBOOKING)
		{
			$this->trans_type = ST_TRANSPORTBOOKING;
		}
		else
		{		
			$this->trans_type = ST_TRANSPORTORDER;
		}
		$this->dimension_id = 0;
		$this->dimension2_id = 0;
		$this->pos = get_transport_point(user_pos());
                
		$this->read($type, $trans_no, $prep_child);
		$this->cart_id = uniqid('');
	}

	/*
		Optional sorting items by stock_id.
	*/
	function _cmp_lines($a, $b)
	{
		return strcmp($a->stock_id, $b->stock_id);
	}

	/*
		Returns items array optionally sorted by item code.
	*/
	function get_items()
	{
		global $sort_transport_items;

		$items = $this->line_items;
		if (@$sort_transport_items)
			uasort($items, array($this, '_cmp_lines'));

		return $items;
	}
        
// Prabha added a function on 2ndJuly
function get_consign_items()
	{
		global $sort_transport_items;

		$items = $this->consignor_line_items;
                
		if (@$sort_transport_items)
			uasort($items, array($this, '_cmp_lines'));

		return $items;
	}
// -------------------- Prabha ended        
	//
	//	Prepare cart to new child document entry, just after initial parent doc read.
	//
	function prepare_child()
	{
		global $Refs;

		$type = get_child_type($this->trans_type);

		$this->trans_type = $type;
		$this->reference = $Refs->get_next($this->trans_type);
		if ($type == ST_CONSIGNORCREDIT)
		    $this->src_date = $this->document_date;

		$this->document_date = new_doc_date();

		for($line_no = 0; $line_no < count($this->line_items); $line_no++) {
			$line = &$this->line_items[$line_no];
			$line->src_id = $line->id; // save src line ids for update
			$line->qty_dispatched = $type == ST_CONSIGNORCREDIT ? '0' : $line->quantity - $line->qty_done;
			$line->qty_old = 0;
		}
		unset($line);
		
		if ($type == ST_CONSIGNORDELIVERY) {
			$this->order_no = key($this->trans_no);
			$consignor = get_consignor($this->consignor_id);
			$consignee = get_consignee($this->consignee_id);
			$this->dimension_id = $consignor['dimension_id'];
			$this->dimension2_id = $consignor['dimension2_id'];
		}
		if ($type == ST_TRANSPORTINVOICE) {
			$this->due_date = get_invoice_duedate($this->payment, $this->document_date);
		}

		$this->src_docs = $this->trans_no;
		$this->trans_no = 0;
	}

	//
	//	Prepares transaction for reedition updating with parent transaction data 
	//
	function set_parent_constraints($sodata, $src_no) {

		$srcdetails = get_transport_parent_lines($this->trans_type, $src_no);
		$src_type = get_parent_type($this->trans_type);

		// calculate & save: qtys on other docs and free qtys on src doc
		$line_no = 0; $src_docs = array();
		// Loop speed optimisation below depends on fact 
		// that child line_items contains subset of parent lines in _the_same_ order !
		while (($line_no < count($this->line_items)) && ($srcline = db_fetch($srcdetails))) {
			$line = &$this->line_items[$line_no];
			$src_docs[] = $src_type == ST_TRANSPORTORDER ?  $srcline['order_no'] : $srcline['consignor_trans_no'];
			if ($srcline['id'] == $line->src_id) {
				if ($this->trans_type == ST_TRANSPORTINVOICE)
					$line->src_no = $srcline['consignor_trans_no'];
				$line->qty_old = $line->qty_dispatched = $line->quantity;
				$line->quantity += $srcline['quantity'] - 
					($src_type==ST_TRANSPORTORDER ? $srcline['qty_sent'] : $srcline['qty_done']); // add free qty on src doc
				$line_no++;
			}
		}

		if ($src_type == ST_TRANSPORTORDER || $src_type == 0) {
			$this->src_docs = array( $sodata['order_no']=>$sodata['version']);
		} else {
			// get src_data from consignor_trans
			$this->src_docs = get_consignor_trans_version($src_type, array_unique($src_docs));
		}
	}
	//-------------------------------------------------------------------------
	// Reading document into cart
	//
	function read($type, $trans_no=0, $prep_child=false) {

		global $SysPrefs, $Refs;

		if (!is_array($trans_no)) $trans_no = array($trans_no);

		if ($trans_no[0]) { // read old transaction
			if ($type == ST_TRANSPORTORDER) { // transport booking || transport quotation
				read_transport_order($trans_no[0], $this, $type);
			} 
			elseif ($type == ST_TRANSPORTQUOTE) { // transport booking || transport quotation
				read_transport_slip($trans_no[0], $this, $type);
			} 
			elseif ($type == ST_TRANSPORTBOOKING) { // transport booking || transport quotation
                            	read_transport_booking($trans_no[0], $this, $type);
			} 
			else {	// other type of transport transaction
					read_transport_trans($type, $trans_no, $this); 
					if ($this->order_no) { // free hand credit notes have no order_no
						$sodata = get_transport_order_header($this->order_no, ST_TRANSPORTORDER);
						$this->contact_person = $sodata["contact_person"];
						$this->consignee_ref = $sodata["consignee_ref"];
					// currently currency is hard linked to consignor account
					//	$this->consignor_currency = $sodata["curr_code"];
						$this->delivery_to = $sodata["deliver_to"];
						$this->delivery_address = $sodata["delivery_address"];
					// child transaction reedition - update with parent info unless it is freehand
					if (!$prep_child) // this is read for view/reedition
						$this->set_parent_constraints($sodata, $trans_no[0]);
					}
			}
			// convert document into child and prepare qtys for entry
			if ($prep_child)
				$this->prepare_child();

		} else { // new document
				$this->trans_type = $type;
				$this->trans_no = 0;
				$this->consignor_currency = get_company_currency();
				// set new transport document defaults here
				if (get_global_consignor() != ALL_TEXT)
				{
					if($this->trans_type != ST_TRANSPORTQUOTE && $this->trans_type != ST_TRANSPORTBOOKING)
					{
				  $this->consignor_id = get_global_consignor();
				  }
				  else
				  {
				  $this->consignor_id = '';
				  }
				 }
				else
				{
				  $this->consignor_id = '';
				 }
				 if (get_global_consignee() != ALL_TEXT)
				 {
				 if($this->trans_type != ST_TRANSPORTQUOTE && $this->trans_type != ST_TRANSPORTBOOKING)
					{
				  $this->consignee_id = get_global_consignee();
				  }
				  else
				  {
				  $this->consignee_id = '';
				  }
				  }
				else
				{
				  $this->consignee_id = '';
				 }
				$this->document_date = new_doc_date();
				if (!is_date_in_fiscalyear($this->document_date))
					$this->document_date = end_fiscalyear();
				$this->reference = $Refs->get_next($this->trans_type);
				
				if ($type == ST_TRANSPORTINVOICE) {
					$this->due_date =
						get_invoice_duedate($this->payment, $this->document_date);
				} else
					$this->due_date =
						add_days($this->document_date, $SysPrefs->default_delivery_required_by());
		}
		$this->credit = get_current_consignor_credit($this->consignor_id);
	}

	//-------------------------------------------------------------------------
	// Writing new/modified transport document to database.
	// Makes parent documents for direct delivery/invoice by recurent call.
	// $policy - 0 or 1:  writeoff/return for IV, back order/cancel for DN
	function write($policy=0) { 
		begin_transaction(); // prevents partial database changes in case of direct delivery/invoice
		
		if ($this->reference != 'auto' && $this->trans_no == 0 && !is_new_reference($this->reference, $this->trans_type))
		{
			commit_transaction();
			return -1;
		}	
		if (count($this->src_docs) == 0 && ($this->trans_type == ST_TRANSPORTINVOICE || $this->trans_type == ST_CONSIGNORDELIVERY)) {
			// this is direct document - first add parent
			$ref = $this->reference;
			$date = $this->document_date;
			$due_date = $this->due_date;
			$dimension_id = $this->dimension_id;
			$dimension2_id = $this->dimension2_id;
			$this->trans_type = get_parent_type($this->trans_type);

			$this->reference = 'auto'; 
			$trans_no = $this->write(1); 

			// re-read parent document converting it to child
			$this->read($this->trans_type, $trans_no, true); 
			$this->document_date = $date;
			$this->reference = $ref;
			$this->due_date = $due_date;
			$this->dimension_id = $dimension_id;
			$this->dimension2_id = $dimension2_id;
		}
		$this->reference = @html_entity_decode($this->reference, ENT_QUOTES);
		$this->Comments = @html_entity_decode($this->Comments, ENT_QUOTES);
		foreach($this->line_items as $lineno => $line) {
			$this->line_items[$lineno]->stock_id = @html_entity_decode($line->stock_id, ENT_QUOTES);
			$this->line_items[$lineno]->item_description = @html_entity_decode($line->item_description, ENT_QUOTES);
		}
		switch($this->trans_type) {
			case ST_TRANSPORTINVOICE:
				$ret = write_transport_invoice($this); break;
			case ST_CONSIGNORCREDIT:
				$ret = write_credit_note($this, $policy); break;
			case ST_CONSIGNORDELIVERY:
				$ret = write_transport_delivery($this, $policy); 
				break;
			case ST_TRANSPORTORDER:
			case ST_TRANSPORTQUOTE:
			case ST_TRANSPORTBOOKING:
				if ($this->trans_no==0)	// new document
					
					$ret = add_transport_order($this);
				else
                                	$ret = update_transport_order($this);
                                
		}

		commit_transaction();

		return $ret;
	}

	function set_consignor($consignor_id, $consignor_name,$tin_no,$branch_address,$phone,$email)
	{
		$this->consignor_name = $consignor_name;
		$this->consignor_id = $consignor_id;
		$this->consignor_tin_no = $tin_no;
		$this->branch_address = $address;
		$this->phone = $phone;
		$this->email = $email;
	}
	function set_consignee($consignee_id, $consignee_name,$consignee_phone,$consignee_email)
	{
		$this->consignee_name = $consignee_name;
		$this->consignee_id = $consignee_id;
		$this->consignee_phone = $consignee_phone;
		$this->consignee_email = $consignee_email;

	
		//$this->credit = get_current_consignor_credit($consignor_id);
	}

	function set_consignee_branch($consignee_branch_id, $phone='', $email='')
	{
		$this->consignee_branch = $consignee_branch_id;
		
	
		
	}

	function set_transport_type($transport_type, $transport_name, $tax_included=0, $factor=0)
	{
	    $this->transport_type = $transport_type;
	    $this->transport_type_name = $transport_name;
	    $this->tax_included = $tax_included;
	    $this->price_factor = $factor;
	}
	function set_driver($driver_id,$driver_name)
	{
	    $this->driver_id = $driver_id;
	    $this->driver_name = $driver_name;
	  
	}
	function set_vehicle($vehicle_id,$vehicle_number_plate)
	{
	    $this->vehicle_id = $vehicle_id;
	    $this->vehicle_number_plate = $vehicle_number_plate;
	  
	}

	function set_location($id, $name)
	{
		$this->Location = $id;
		$this->location_name = $name;
	}

	function set_delivery($destination, $address, $freight_cost=null)
	{
		$this->deliver_to = $destination;
		$this->delivery_address = $address;
		if (isset($freight_cost))
			$this->freight_cost = $freight_cost;
		
	}
	function set_billing($billing_id, $billing_name,$destination, $address,$billing_phone,$billing_email, $freight_cost=null)
	{
		$this->billing_name = $billing_name;
		$this->billing_id = $billing_id;
		
		$this->bill_to = $destination;
		$this->billing_address = $address;
		$this->billing_phone = $billing_phone;
		$this->billing_email = $billing_email;
		if (isset($freight_cost))
			$this->freight_cost = $freight_cost;
		
	}
//prabha added 2July2015 add consignor to the cart
 
        function add_to_consignor_cart($line_no, $consignor_no, $consignor_name,$tin_no, $address,$phone,$email=null,$id=0)
		
	{
	
		$line = new consignor_line_details($consignor_no, $consignor_name,$tin_no, $address,$phone,$email,$id);

		if ($line->valid) {
			$this->consignor_line_items[$line_no] = $line;
			return 1;
		} else
			display_error(_("You have to enter valid stock code or nonempty description"));
		return 0;
	}

        
        
	function add_to_cart($line_no, $stock_id, $qty,$to_units, $price, $disc, $qty_done=0, $standard_cost=0, $description=null, $id=0, $src_no=0,
		$src_id=0)
		
	{
	
		$line = new line_details($stock_id, $qty,$to_units, $price, $disc,
			$qty_done,  $standard_cost, $description, $id, $src_no, $src_id);

		if ($line->valid) {
			$this->line_items[$line_no] = $line;
			return 1;
		} else
			display_error(_("You have to enter valid stock code or nonempty description"));
		return 0;
	}

	function update_cart_item($line_no, $qty, $to_units,$price, $disc, $description="")
	{
		if ($description != "")
			$this->line_items[$line_no]->item_description = $description;
		$this->line_items[$line_no]->quantity = $qty;
		$this->line_items[$line_no]->qty_dispatched = $qty;
		$this->line_items[$line_no]->price = $price;
		$this->line_items[$line_no]->to_units = $to_units;
		
		$this->line_items[$line_no]->discount_percent = $disc;

		print_r($this->line_items);
	}
//-------------- Prabha added to update consignor item------------------------------
function update_consignor_cart_item($line_no, $consignor_no,$tin_no, $address,$phone,$email=null)
	{
    
		$this->consignor_line_items[$line_no]->consignor_no = $consignor_no;
		//$this->consignor_line_items[$line_no]->consignor_name = $consignor_name;
		//$this->consignor_line_items[$line_no]->consignor_branch = $consignor_branch;
		$this->consignor_line_items[$line_no]->tin_no = $tin_no;
		$this->consignor_line_items[$line_no]->address = $address;
		$this->consignor_line_items[$line_no]->phone = $phone;
		$this->consignor_line_items[$line_no]->email = $email;
	}
        
 function remove_from_consignor_cart($line_no)
	{
		array_splice($this->consignor_line_items, $line_no, 1);
	}
//----------------------------------------------------------------------------------
        
	function update_add_cart_item_qty($line_no, $qty)
	{
		$this->line_items[$line_no]->quantity += $qty;
	}

	function remove_from_cart($line_no)
	{
		array_splice($this->line_items, $line_no, 1);

	}

	function clear_items()
	{
		unset($this->line_items);
		$this->line_items = array();
		$this->transport_type = "";
		$this->trans_no = 0;
		$this->consignor_id = $this->order_no = 0;
	}

	function count_items()
	{
		$counter=0;
		foreach ($this->line_items as $line) {
			if ($line->quantity!=$line->qty_done) $counter++;
		}
		return $counter;
	}

	function get_items_total()
	{
		$total = 0;

		foreach ($this->line_items as $ln_itm) {
			$price = $ln_itm->line_price();
			$total += round($ln_itm->quantity * $price * (1 - $ln_itm->discount_percent), 
			   user_price_dec());
		}
		return $total;
	}

	function get_items_total_dispatch()
	{
		$total = 0;

		foreach ($this->line_items as $ln_itm) {
			$price = $ln_itm->line_price();
			$total += round(($ln_itm->qty_dispatched * $price * (1 - $ln_itm->discount_percent)), 
			   user_price_dec());
		}
		return $total;
	}

	function has_items_dispatch()
	{
		foreach ($this->line_items as $ln_itm) {
			if ($ln_itm->qty_dispatched > 0)
				return true;
		}
		return false;
	}

	function any_already_delivered()
	{
		/* Checks if there have been any line item processed */

		foreach ($this->line_items as $stock_item) {
			if ($stock_item->qty_done !=0) {
				return 1;
			}
		}

		return 0;

	}

	function some_already_delivered($line_no)
	{
		/* Checks if there have been deliveries of a specific line item */
		if (isset($this->line_items[$line_no]) &&
			$this->line_items[$line_no]->qty_done != 0) {
			return 1;
		}
		return 0;
	}

	function get_taxes($shipping_cost=null)
	{
		$items = array();
		$prices = array();
		if($shipping_cost==null)
			$shipping_cost = $this->freight_cost;
		

		foreach ($this->line_items as $ln_itm) {
			$items[] = $ln_itm->stock_id;
			$prices[] = round(((
				$this->trans_type==ST_TRANSPORTORDER ? 	$ln_itm->quantity : $ln_itm->qty_dispatched) *
				$ln_itm->line_price()* (1 - $ln_itm->discount_percent)),  user_price_dec());
		}

		$taxes = get_tax_for_transportable_items($items, $prices, $shipping_cost,
		  $this->tax_group_id, $this->tax_included,  $this->tax_group_array);
	//print_r($taxes);
    // Adjustment for swiss franken, we always have 5 rappen = 1/20 franken
    if ($this->consignor_currency == 'CHF') {
			$val = $taxes['1']['Value'];
			$val1 = (floatval((intval(round(($val*20),0)))/20));
			$taxes['1']['Value'] = $val1;
		} 
		return $taxes;
	}


	function get_tax_free_shipping()
	{

		if ($this->tax_included==0)
			return $this->freight_cost;
		else
			return ($this->freight_cost - $this->get_shipping_tax());
	}

	function get_shipping_tax()
	{

		$tax_items = get_shipping_tax_as_array();
		$tax_rate = 0;
		if ($tax_items != null) {
			foreach ($tax_items as $item_tax) {
				$index = $item_tax['tax_type_id'];
				if (isset($this->tax_group_array[$index]['rate'])) {
					$tax_rate += $item_tax['rate'];
				}
			}
		}
		
		if($this->tax_included)
			return round($this->freight_cost*$tax_rate/($tax_rate+100),  user_price_dec());
		else
			return round($this->freight_cost*$tax_rate/100,  user_price_dec());
	}
	/*
		Returns transaction value including all taxes
	*/
	function get_trans_total() {
		
		$total = $this->get_items_total() + $this->freight_cost;

		$dec = user_price_dec();
		if (!$this->tax_included) {
			$total += $this->get_shipping_tax();
			$taxes = $this->get_taxes();
			foreach($taxes as $tax)
				$total += round($tax['Value'], $dec);
		}

		return $total;
	}
        
       
        
        //Prabha added Payment and Deposits functions
        function get_trans_payment()
        {
            $payment_total = 0;
            foreach ($this->gl_payment_items as $ln_itm) 
			$payment_total = $payment_total + $ln_itm->amount;
		
		return $payment_total;
        }
        
         function get_trans_deposit()
        {
                $deposit_total = 0;
            foreach ($this->gl_deposit_items as $ln_itm) 
		$deposit_total = $deposit_total + $ln_itm->amount;
		
		return $deposit_total;
        }
	
         function add_payment($line_no, $entity_type,$consignor_no,$driver_no,$code_id, $amount,$line_memo,$description="",$id=0)
		{
	 
                    $line = new gl_payment_details($entity_type,$consignor_no,$driver_no,
                            $code_id, $amount,$line_memo,$description,$id);
                    $this->gl_payment_items[$line_no] = $line;
                 
               
		return 1;
	
		}
        
        function add_deposit($line_no, 
                $entity_type,$consignor_no,$driver_no,
                $code_id, $amount,$line_memo,$description="",$id=0)
	{
	
                    $line = new gl_deposit_details($entity_type,$consignor_no,$driver_no,
                            $code_id, $amount,$line_memo,$description,$id);
                    $this->gl_deposit_items[$line_no] = $line;
        
		return 1;
	
	}
        function update_payment($line_no, 
                $entity_type,$consignor_no,$branch_code,$driver_no,
                $code_id, $amount,$line_memo,$id=0)
	{
    
                $this->gl_payment_items[$line_no]->entity_type = $entity_type;
                $this->gl_payment_items[$line_no]->consignor_no = $consignor_no;
                $this->gl_payment_items[$line_no]->driver_no = $driver_no;
            
                $this->gl_payment_items[$line_no]->code_id = $code_id;
		$this->gl_payment_items[$line_no]->amount = $amount;
		$this->gl_payment_items[$line_no]->line_memo = $line_memo; 
               
	}
        
        function update_deposit($line_no, 
                $entity_type,$consignor_no,$branch_code,$driver_no,
                $code_id, $amount,$line_memo,$id=0)
	{
            
                $this->gl_deposit_items[$line_no]->entity_type = $entity_type;
                $this->gl_deposit_items[$line_no]->consignor_no = $consignor_no;
                $this->gl_deposit_items[$line_no]->driver_no = $driver_no;
                
    		$this->gl_deposit_items[$line_no]->code_id = $code_id;
		$this->gl_deposit_items[$line_no]->amount = $amount;
		$this->gl_deposit_items[$line_no]->line_memo = $line_memo;
              
	}
        
    function remove_payment($line_no)
	{
        
		array_splice($this->gl_payment_items, $line_no, 1);
        
	}
    function remove_deposit($line_no)
	{
        
            array_splice($this->gl_deposit_items, $line_no, 1);
	}

        //--------------------------------------------------------------------
		// ----------- Prabha added Load Stop functions

        
        function add_load_stop($line_no, $loc_code, $stop_code,$contact=null, $address=null,$city=null,$date=null,$time=null,$id=0)
	{
	
		$line = new load_stop($loc_code,$stop_code, $contact, $address,$city,$date,$time,$id);
        	$this->loadstop_line_items[$line_no] = $line;
		return 1;
	
	}

	
function update_load_stop($line_no, $loc_code,$stop_code, $contact=null, $address=null,$city=null,$date=null,$time=null)
	{
    
		$this->loadstop_line_items[$line_no]->loc_code = $loc_code;
		$this->loadstop_line_items[$line_no]->stop_code = $stop_code;
		$this->loadstop_line_items[$line_no]->contact = $contact;
		$this->loadstop_line_items[$line_no]->address = $address;
                $this->loadstop_line_items[$line_no]->city = $city;
                $this->loadstop_line_items[$line_no]->date = $date;
                $this->loadstop_line_items[$line_no]->time = $time;
	}
        
 function remove_load_stop($line_no)
	{
		array_splice($this->loadstop_line_items, $line_no, 1);
	}

	function count_load_stops()
	{
		return count($this->loadstop_line_items);
	}

	// ------------ common functions

	function clear_stops()
	{
    	unset($this->loadstop_line_items);
		$this->loadstop_line_items = array();

    	unset($this->loadstop_line_items);
		$this->loadstop_line_items = array();

	}
} /* end of class defintion */

class line_details
{
	var $id;
	var $stock_id;
	var $item_description;
	var $units;
	var $mb_flag;
	var $tax_type;
	var $tax_type_name;
	var $src_no;	// number of src doc for this line
	var $src_id;
	var $price;
	var $discount_percent;
	var $to_units;
	var $standard_cost;
	var $descr_editable;

	var $valid; // validation in constructor
	/*
		Line quantity properties in various cart create modes:
		
		view:
		$quantity - quantity on current document
		$qty_done - quantity processed on all child documents
		$qty_dispatched - not used
		$qty_old - not used

		edit:
		$quantity - free parent quantity including this doc (= max allowed quantity)
		$qty_done - qty processed on child documents (= min allowed qty)
		$qty_dispatched - quantity currently selected to process
		$qty_old - quantity processed on this document before reedition 

		new child entry (view parent followed by prepare_child() call):
		$quantity - max allowed quantity (get from parent)
		$qty_done - qty processed on other child documents
		$qty_dispatched - quantity currently selected to process
		$qty_old - 0; not used
	*/
	var $quantity;
	var $qty_done;
	var $qty_dispatched;
	var $qty_old = 0;


	function line_details ($stock_id, $qty,$to_units, $prc, $disc_percent,
		$qty_done, $standard_cost, $description, $id=0, $src_no=0, $src_id=0)
	{
	/* Constructor function to add a new LineDetail object with passed params */
		
		$this->id = $id;
		$this->src_no = $src_no;
		$this->src_id = $src_id;
		$item_row = get_transport_item($stock_id);

		if (!$item_row) 
			return;
			
		$this->mb_flag = $item_row["mb_flag"];
		$this->units = $item_row["units"];
		$this->descr_editable = $item_row["editable"];
		if ($description == null || !$this->descr_editable)
			$this->item_description = $item_row["description"];
		else
			$this->item_description = $description;
		//$this->standard_cost = $item_row["material_cost"] + $item_row["labour_cost"] + $item_row["overhead_cost"];
		//$this->tax_type = $item_row["tax_type_id"];
		//$this->tax_type_name = $item_row["tax_type_name"];
		$this->stock_id = $stock_id;
		$this->quantity = $qty;
		$this->to_units = $to_units;
		$this->qty_dispatched = $qty;
		$this->price = $prc;
		$this->discount_percent = $disc_percent;
		$this->qty_done = $qty_done;
		$this->standard_cost = $standard_cost;
		$this->valid = true;
	}

	// get unit price as stated on document
	function line_price()
	{
		return $this->price;
	}
}
class load_stop
{
        var $id ;
	var $loc_code;
        var $location_name;
	var $contact;
	var $address;
        var $city;
	var $stop_code;
	var $date;
	var $time;

	function load_stop ($loc_code,$stop_code, $contact=null, $address=null,$city=null,$date=null,$time=null,$id=0)
	{
                $this->id = $id;
		$this->loc_code = $loc_code;
                
                 $var_stop_row = get_location_info($loc_code);

		if (!$var_stop_row) 
			return;
                $this->location_name = $var_stop_row['location_name'];
                $this->contact = $contact;
		$this->address = $address;
                $this->city = $city;
		$this->time = $time;
                $this->date = $date;
		$this->stop_code = $stop_code;
			
	}
}


//prabha added on 1July 2015
class consignor_line_details
{
        var $id;
	var $order_no;
	var $consignor_code;
        var $consignor_name;
       var $tin_no;
	var $address;
        var $phone;
        var $email;
        var $valid;

	function consignor_line_details ($consignor_code, $consignor_name,$tin_no=null, $address=null,$phone,$email=null,$id=0)
	{
            
		$this->id = $id;
                $this->consignor_code = $consignor_code;
                
                $var_consignor_row = get_consignor_info($consignor_code);

		if (!$var_consignor_row) 
			return;
                $this->consignor_name = $var_consignor_row['name'];
                
                
                
		$this->tin_no = $tin_no;
		$this->address = $address;
		$this->phone = $phone;
		$this->email = $email;
		
                $this->valid = true;
		
			
	}
}

class gl_payment_details
{
        var $id ;
        var $type;
        var $entity_type;
        var $consignor_no;
       var $driver_no;
        var $code_id;
        var $description;
        var $amount;
        var $line_memo;
	

	function gl_payment_details ($entity_type,$consignor_no,$driver_no,
                                     $code_id, $amount, $line_memo,$description="",$id=0)
	{
            
                $this->id = $id;
				$this->type = 12;
               
                $this->entity_type = $entity_type;
                $this->consignor_no = $consignor_no;
             
                $this->driver_no    = $driver_no;
        
                $this->code_id = $code_id;
                $this->amount = $amount;
				$this->line_memo = $line_memo;
                $var_result = get_chart_name($this->code_id);
                $this->description = $var_result['account_name'];
		
	}
}

class gl_deposit_details
{
        var $id ;
        var $type;
        var $entity_type;
        var $consignor_no;
        var $driver_no;
        var $code_id;
        var $description;
        var $amount;
        var $line_memo;
	

	function gl_deposit_details ($entity_type,$consignor_no,$driver_no,
                                     $code_id, $amount, $line_memo,$description="",$id=0)
	{
            
                $this->id = $id;
		$this->type = 10;
               
                $this->entity_type = $entity_type;
                $this->consignor_no = $consignor_no;
                $this->driver_no    = $driver_no;
                
                $this->code_id = $code_id;
                $this->amount = $amount;
		$this->line_memo = $line_memo;
                $var_result = get_chart_name($this->code_id);
                $this->description = $var_result['account_name'];
		
	}
}

?>

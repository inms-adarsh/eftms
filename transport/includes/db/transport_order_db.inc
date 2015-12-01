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
//----------------------------------------------------------------------------------------
//prabha added a function on 2July2015


function get_location_info($location_code)
{
    
    	$sql = "SELECT * FROM ".TB_PREF."locations
		WHERE loc_code  = ".$location_code."  LIMIT 1";
	$result = db_query($sql, "could not retrieve consignor  details");

	
        $row = db_fetch($result);
        
	return $row;
}

function get_consignor_branch_details($consignor_no)
{
    
	$sql = "SELECT * FROM ".TB_PREF."consignors_master
		WHERE consignor_no = ".$consignor_no." LIMIT 1";
	$result = db_query($sql, "could not retrieve consignor details");

	
        $row = db_fetch($result);
        
	return $row;
}
function get_consignor_info($consignor_no)
{
    
    	$sql = "SELECT * FROM ".TB_PREF."consignors_master
		WHERE consignor_no = ".$consignor_no."  LIMIT 1";
	$result = db_query($sql, "could not retrieve consignor  details");

	
        $row = db_fetch($result);
        
	return $row;
}

//
function add_transport_order(&$order)
{
	global $loc_notification, $path_to_root, $Refs;
	
	begin_transaction();
        
	hook_db_prewrite($order, $order->trans_type);
	$order_no = get_next_trans_no($order->trans_type);
	$del_date = date2sql($order->due_date);
	$order_type = 0; // this is default on new order
	$total = $order->get_trans_total();
      //  $total_goods_value = $order->get_items_total();
        $payment_total = $order->get_trans_payment();
        $deposit_total = $order->get_trans_deposit();
	$sql = "INSERT INTO ".TB_PREF."transport_orders (order_no,Location_to, type,consignee_no,
                        consignor_tin_no,consignee_tin_no,vehicle_no,driver_no,driver_ref, trans_type,  
                        contact_person,consignee_ref, reference, comments, ord_date,
                        order_type, ship_via, deliver_to, delivery_address,consignee_phone,consignee_email, contact_phone,
                        freight_cost,ship_cost,commission_cost,way_cost, labour_charge,insc_charge, bilty_charge, 
                        from_stk_loc, delivery_date,  total,total_goods_value,goods_bill_no,
                        loading_address,loaded_from,payment_by,service_tax_by,add_service_tax,
                        load_status_code,
                        paid_account_ref,
                        total_payment,
                        deposit_account_ref,
                        total_deposit,
                        billing_no,
                        billing_tin_no,
                        bill_to,
                        billing_address,
                        billing_phone,
                        billing_email,
                        truck_status_code
                )
		VALUES (" .db_escape($order_no) . "," .db_escape($order->Location_to) . "," .db_escape($order_type) . ",
			" . db_escape($order->consignee_id) . ",
        		" . db_escape($order->consignor_tin_no) . ",
                	" . db_escape($order->consignee_tin_no) . ",
                        " . db_escape($order->vehicle_id) . ",
                        " . db_escape($order->driver_id) . ",	
                        " . db_escape($order->driver_ref) . ",		
                        " . db_escape($order->trans_type) . ",
			".  db_escape($order->contact_person) .", 
			".  db_escape($order->consignee_ref) .",". 
                            db_escape($order->reference) .",". 
                            db_escape($order->Comments) .",'" . 
                            date2sql($order->document_date) . "', " .
                            db_escape($order->transport_type) . ", " .
                            db_escape($order->ship_via)."," . 
                            db_escape($order->deliver_to) . "," .
                            db_escape($order->delivery_address) . ", " .
                              db_escape($order->consignee_phone).",".
                              db_escape($order->consignee_email).",".
                            db_escape($order->contact_phone) . ", " . 
                            db_escape($order->freight_cost) .", " . 
                            db_escape($order->ship_cost) .", " . 
                            db_escape($order->commission_cost) .", " . 
                            db_escape($order->way_cost) .", " .
                            db_escape($order->labour_charge) .", " .
                            db_escape($order->insc_charge) .", " .
                            db_escape($order->bilty_charge) .", ".
                            db_escape($order->Location) .", " .
                            db_escape($del_date) . "," .
                            db_escape($total). "," .
                            db_escape($order->total_goods_value). ",".
                            db_escape($order->goods_bill_no). ",".
                            db_escape($order->loading_address). ",".
                            db_escape($order->loaded_from). ",".
                            db_escape($order->payment_by). ",".
                            db_escape($order->service_tax_by). ",".
                            db_escape($order->service_tax_paid). ",".
                            db_escape($order->LoadStatusList). ",".
                            db_escape($order->reference). "," .
                            $payment_total .",".
                            db_escape($order->reference). ",".
                            $deposit_total .",".
                            db_escape($order->billing_id).",".
                             db_escape($order->billing_tin_no).",".
                             db_escape($order->bill_to).",".
                             db_escape($order->billing_address).",".
                              db_escape($order->billing_phone).",".
                              db_escape($order->billing_email).",".
                             db_escape($order->TruckStatusTypeList).
							")";

	db_query($sql, "order Cannot be Added");

	$order->trans_no = array($order_no=>0);

	if ($loc_notification == 1)
	{
		include_once($path_to_root . "/inventory/includes/inventory_db.inc");
		$st_ids = array();
		$st_names = array();
		$st_num = array();
		$st_reorder = array();
	}
	foreach ($order->line_items as $line)
	{
		
		$sql = "INSERT INTO ".TB_PREF."transport_order_details (order_no, trans_type, stk_code, description, unit_price, quantity,to_units, discount_percent) VALUES (";
		$sql .= $order_no . ",".$order->trans_type .
				",".db_escape($line->stock_id).", "
				.db_escape($line->item_description).", $line->price,
				$line->quantity,"
				.db_escape($line->to_units).",
				$line->discount_percent)";
		db_query($sql, "order Details Cannot be Added");

	// Now mark quotation line as processed
		if ($order->trans_type == ST_TRANSPORTORDER && $line->src_id)
			update_parent_line(ST_TRANSPORTORDER, $line->src_id, $line->qty_dispatched); // clear all the quote despite all or the part was ordered
	} /* inserted line items into transport booking details */
        
        // Prabha added this code to insert into transport_consignor_details
        
        foreach ($order->consignor_line_items as $line)
	{
		
		$sql = "INSERT INTO ".TB_PREF."transport_consignor_details "
                        . "(order_no, trans_type, consignor_no, tin_no, address,email,phone,"
                        . "created_by, created_date) VALUES (";
		$sql .= $order_no . ",".$order->trans_type .",".
                                        $line->consignor_code.", ".
                                       
                                        db_escape($line->tin_no)."," .
                                        db_escape($line->address). ",".
                                         db_escape($line->email). ",".
                                          db_escape($line->phone). ",".
                                        db_escape($_SESSION['wa_current_user']->loginname).
                                    ", now())";
                display_error("transport_order_db :lie185".$sql);
		db_query($sql, "order consignor Details Cannot be Added");


	} 
        // Prabha added this code to insert into transport_order_stops table
        foreach ($order->loadstop_line_items as $line)
	{
		
		$sql = "INSERT INTO ".TB_PREF."transport_order_stops "
                        . "(order_no, trans_type, pickup_delivery_type,loc_code, contact, address, stop_code,stop_date,stop_time,"
                        . "created_by, created_date) VALUES (";
		$sql .= $order_no . ",".$order->trans_type .",'P',".
                                        db_escape($line->loc_code).", ".
                                        db_escape($line->contact) ."," .
                                        db_escape($line->address)."," . "1 ,".
                                        db_escape(date2sql($line->date)). ",".
                                        db_escape($line->time). ",".
                                        db_escape($_SESSION['wa_current_user']->loginname).
                                    ", now())";
                
		db_query($sql, "order stops Details Cannot be Added");


	}
        
           foreach ($order->loadstop_delivery_line_items as $line)
	{
		
		$sql = "INSERT INTO ".TB_PREF."transport_order_stops "
                        . "(order_no, trans_type, pickup_delivery_type,loc_code, contact, address, stop_code,stop_date,stop_time,"
                        . "created_by, created_date) VALUES (";
		$sql .= $order_no . ",".$order->trans_type .",'D',".
                                        db_escape($line->delivery_loc_code).", ".
                                        db_escape($line->delivery_contact) ."," .
                                        db_escape($line->delivery_address)."," . "1 ,".
                                        db_escape(date2sql($line->delivery_date)). ",".
                                        db_escape($line->delivery_time). ",".
                                        db_escape($_SESSION['wa_current_user']->loginname).
                                    ", now())";
                
		db_query($sql, "order stops Details Cannot be Added");


	}
        // Update markers into transport_order_stops for this order
        $sql = " UPDATE ".TB_PREF."transport_order_markers 
                 SET order_no = ".$order_no .",
                     trans_type = ".$order->trans_type
                . " WHERE order_ref = ".$order->reference;
        db_query($sql, "order stops markers Cannot be Updated");
        // Prabha added this code to insert into transport_order_payments and deposits table
        foreach ($order->gl_payment_items as $line)
	{
                  
		$sql = "INSERT INTO ".TB_PREF."trans_order_payments_deposits "
                        . "(order_no, trans_type, type,
                            entity_type,consignor_no,driver_code,
                            account_code, amount,memo )
                          VALUES (";
		$sql .= $order_no . ",".$order->trans_type .",".
                                        $line->type.", ".
                                        $line->entity_type.", ".
                                        $line->consignor_no.", ".
                                        $line->driver_no.", ".
                                        $line->code_id.", ".
                                        $line->amount.", ".
                                        db_escape($line->line_memo) .")";
                
		db_query($sql, "order  payment Cannot be Added");


	}
        
        // Prabha added this code to insert into transport_order_payments and deposits table
        foreach ($order->gl_deposit_items as $line)
	{
		
		$sql = "INSERT INTO ".TB_PREF."trans_order_payments_deposits "
                        . "(order_no, trans_type, type, 
                             entity_type,consignor_no,driver_code,
                            account_code, amount,memo )
                          VALUES (";
		$sql .= $order_no . ",".$order->trans_type .",".
                                        $line->type.", ".
                                        $line->entity_type.", ".
                                        $line->consignor_no.", ".
                                        $line->driver_no.", ".
                                        $line->code_id.", ".
                                        $line->amount.", ".
                                        db_escape($line->line_memo) .")";
                
		db_query($sql, "order  deposit Cannot be Added");


	}
        //-------------------------------------------------------------------
	add_audit_trail($order->trans_type, $order_no, $order->document_date);
	$Refs->save($order->trans_type, $order_no, $order->reference);

	hook_db_postwrite($order, $order->trans_type);
	commit_transaction();

	if ($loc_notification == 1 && count($st_ids) > 0)
	{
		require_once($path_to_root . "/reporting/includes/class.mail.inc");
		$company = get_company_prefs();
		$mail = new email($company['coy_name'], $company['email']);
		$from = $company['coy_name'] . " <" . $company['email'] . ">";
		$to = $loc['location_name'] . " <" . $loc['email'] . ">";
		$subject = _("Stocks below Re-Order Level at " . $loc['location_name']);
		$msg = "\n";
		for ($i = 0; $i < count($st_ids); $i++)
			$msg .= $st_ids[$i] . " " . $st_names[$i] . ", " . _("Re-Order Level") . ": " . $st_reorder[$i] . ", " . _("Below") . ": " . $st_num[$i] . "\n";
		$msg .= "\n" . _("Please reorder") . "\n\n";
		$msg .= $company['coy_name'];
		$mail->to($to);
		$mail->subject($subject);
		$mail->text($msg);
		$ret = $mail->send();
	}
	return $order_no;
}

//----------------------------------------------------------------------------------------

function delete_transport_order($order_no, $trans_type)
{
	begin_transaction();
	hook_db_prevoid($trans_type, $order_no);

	$sql = "DELETE FROM ".TB_PREF."transport_orders WHERE order_no=" . db_escape($order_no) 
		. " AND trans_type=".db_escape($trans_type);

	db_query($sql, "order Header Delete");

	$sql = "DELETE FROM ".TB_PREF."transport_order_details WHERE order_no =" 
		.db_escape($order_no) . " AND trans_type=".db_escape($trans_type);
	db_query($sql, "order Detail Delete");

        // delete transport_order_consinors
        $sql = "DELETE FROM ".TB_PREF."transport_consignor_details WHERE order_no =" 
		.db_escape($order_no) . " AND trans_type=".db_escape($trans_type);
	db_query($sql, "order consignor Delete");
        
        // delete transport_order_stops
        $sql = "DELETE FROM ".TB_PREF."transport_order_stops WHERE order_no =" 
		.db_escape($order_no) . " AND trans_type=".db_escape($trans_type);
	db_query($sql, "order stops delete");
        
        // delete transport_order_stops
        $sql = "DELETE FROM ".TB_PREF."transport_order_markers WHERE order_no =" 
		.db_escape($order_no) . " AND trans_type=".db_escape($trans_type);
	db_query($sql, "order markers delete");
        
        // delete transport_order_payment_deposits
        $sql = "DELETE FROM ".TB_PREF."trans_order_payments_deposits WHERE order_no =" 
		.db_escape($order_no) . " AND trans_type=".db_escape($trans_type);
	db_query($sql, "order payments and deposits delete");
        
	delete_reference($trans_type, $order_no);

	add_audit_trail($trans_type, $order_no, Today(), _("Deleted."));
	commit_transaction();
}

//----------------------------------------------------------------------------------------
// Mark changes in transport_order_details
//
function update_transport_order_version($order)
{
  foreach ($order as $so_num => $so_ver) {
  $sql= 'UPDATE '.TB_PREF.'transport_orders SET version=version+1 WHERE order_no='. db_escape($so_num).
	' AND version='.$so_ver . " AND trans_type=30";
  db_query($sql, 'Concurrent editing conflict while transport booking update');
  }
}
function update_transport_order_delivery($order)
{
begin_transaction();
 
  $sql= 'UPDATE '.TB_PREF.'transport_orders SET delivery_address=".db_escape($order->delivery_address) WHERE order_no='. db_escape($order->trans_no);
  db_query($sql, 'Concurrent editing conflict while transport booking update');
  commit_transaction();
}


//----------------------------------------------------------------------------------------

function update_transport_order($order)
{
	global $loc_notification, $path_to_root, $Refs;
   	$del_date = date2sql($order->due_date);
	$ord_date = date2sql($order->document_date);
	$order_no =  key($order->trans_no);
	
	$version= current($order->trans_no);
	$total = $order->get_trans_total();
       // $total_goods_value = $order->get_items_total();
        $payment_total = $order->get_trans_payment();
        $deposit_total = $order->get_trans_deposit();
        
	begin_transaction();
	hook_db_prewrite($order, $order->trans_type);

	$sql = "UPDATE ".TB_PREF."transport_orders SET type =".db_escape($order->so_type)." ,
		consignee_no = " . db_escape($order->consignee_id) . ",
		consignee_tin_no = " . db_escape($order->consignee_tin_no) . ",
		consignor_tin_no = " . db_escape($order->consignor_tin_no) . ",
		vehicle_no = " . db_escape($order->vehicle_id) . ",
		driver_no = " . db_escape($order->driver_id) . ",
		driver_ref = " . db_escape($order->driver_ref) . ",
		contact_person = ". db_escape($order->contact_person) .",
		consignee_ref = ". db_escape($order->consignee_ref) .",
		reference = ". db_escape($order->reference) .",
		comments = ". db_escape($order->Comments) .",
		ord_date = " . db_escape($ord_date) . ",
		order_type = " .db_escape($order->transport_type) . ",
		ship_via = " . db_escape($order->ship_via) .",
		deliver_to = " . db_escape($order->deliver_to) . ",
		delivery_address = " . db_escape($order->delivery_address) . ",
		consignee_phone = ".db_escape($order->consignee_phone).",
		consignee_email = ".db_escape($order->consignee_email).",
		contact_phone = " .db_escape($order->contact_phone) . ",
		freight_cost = " .db_escape($order->freight_cost) .",
		ship_cost = " .db_escape($order->ship_cost) .",
		bilty_charge = " .db_escape($order->bilty_charge) .",
		insc_charge = " .db_escape($order->insc_charge) .",
		commission_cost = " .db_escape($order->commission_cost) .",
		labour_charge = " .db_escape($order->labour_charge) .",
		way_cost = " .db_escape($order->way_cost) .",
		from_stk_loc = " .db_escape($order->Location) .",
        Location_to = " .db_escape($order->Location_to) .",
		delivery_date = " .db_escape($del_date). ",
		version = ".($version+1).",
		total = ". db_escape($total) .",
		loaded_from = " .db_escape($order->loaded_from). ",
		loading_address = ". db_escape($order->loading_address) .",
		total_goods_value = ".  db_escape($order->total_goods_value) .",
		goods_bill_no = ". db_escape($order->goods_bill_no) .",
		payment_by = " .db_escape($order->payment_by). ",
		service_tax_by = ". db_escape($order->service_tax_by) .",
		add_service_tax = ". db_escape($order->service_tax_paid) ." ,
		load_status_code = ". db_escape($order->LoadStatusList) ." ,
		truck_status_code = ". db_escape($order->TruckStatusTypeList) ." ,
		billing_no = " .db_escape($order->billing_id). ",
		bill_to = ". db_escape($order->bill_to) .",
		billing_tin_no = ". db_escape($order->billing_tin_no) ." ,
		billing_address = ". db_escape($order->billing_address) ." ,
		billing_phone = ".db_escape($order->billing_phone).",
		billing_email = ".db_escape($order->billing_email).",
                paid_account_ref = ".db_escape($order->reference). ",
                total_payment = ".$payment_total .",
                total_deposit = ". $deposit_total .",    
                deposit_account_ref = ".db_escape($order->reference). "
	 WHERE order_no=" . db_escape($order_no) ."
	 AND trans_type=".$order->trans_type." AND version=".$version;

	db_query($sql, "order Cannot be Updated, this can be concurrent edition conflict");

	$id_tokeep = array();
	foreach ($order->line_items as $line) {
		array_push($id_tokeep , $line->id);
	}
	$id_list = implode(', ', $id_tokeep);
   
	if(! empty($id_list))
        {
            $sql = "DELETE FROM ".TB_PREF."transport_order_details WHERE order_no =" . db_escape($order_no) . " AND trans_type=".$order->trans_type;
            $sql .= " AND id NOT IN ($id_list)";

            db_query($sql, "Old order Cannot be Deleted");
        }
    else {
             $sql = "DELETE FROM ".TB_PREF."transport_order_details WHERE order_no =" . db_escape($order_no) . " AND trans_type=".$order->trans_type;
               db_query($sql, "Old order Cannot be Deleted");
        }
            if ($loc_notification == 1)
            {
		include_once($path_to_root . "/inventory/includes/inventory_db.inc");
		$st_ids = array();
		$st_names = array();
		$st_num = array();
		$st_reorder = array();
            }

            foreach ($order->line_items as $line)
            {
            
		if($line->id) {
			$sql = "UPDATE ".TB_PREF."transport_order_details
						SET description = ".db_escape($line->item_description) . ", 
								unit_price = ".db_escape($line->price) . ",
								quantity = ".db_escape($line->quantity) . ",
								to_units = ".db_escape($line->to_units) . ",
								discount_percent = ".db_escape($line->discount_percent) . "
						WHERE id = {$line->id}";
		}
		else {
		$sql = "INSERT INTO ".TB_PREF."transport_order_details
		 (id, order_no, trans_type, stk_code,  description,to_units, unit_price, quantity,
		  discount_percent, qty_sent)
		 VALUES (";
		$sql .= db_escape($line->id ? $line->id : 0) . ","
		  .$order_no . ",".$order->trans_type.","
		  .db_escape($line->stock_id) . ","
		  .db_escape($line->item_description) . ", "
		   .db_escape($line->to_units) . ",
		  ".db_escape($line->price) . ", "
		  .db_escape($line->quantity) . ", "
		  .db_escape($line->discount_percent) . ", "
		  .db_escape($line->qty_done) ." )";
		}

		db_query($sql, "Old order Cannot be Inserted");
            } /* inserted line items into transport booking details */

        // Prabha added this code to update transport order consignor details
        
        $id_tokeep = array();
	foreach ($order->consignor_line_items as $line) {
		array_push($id_tokeep , $line->id);
	}
	$id_list = implode(', ', $id_tokeep);
	if (! empty($id_list))
        {
            $sql = "DELETE FROM ".TB_PREF."transport_consignor_details WHERE order_no =" . db_escape($order_no) . " AND trans_type=".$order->trans_type;
            $sql .= " AND id NOT IN ($id_list)";
        

            db_query($sql, "Old transport_consignor_details Cannot be Deleted");
        }
             
         else {
             $sql = "DELETE FROM ".TB_PREF."transport_consignor_details WHERE order_no =" . db_escape($order_no) . " AND trans_type=".$order->trans_type;
               db_query($sql, "Old transport_consignor_details Cannot be Deleted");
        }
            foreach ($order->consignor_line_items as $line)
            {
            
		if($line->id) {
			$sql = "UPDATE ".TB_PREF."transport_consignor_details 
						SET consignor_no = ".$line->consignor_code . ", 
                                                    tin_no = ".db_escape($line->tin_no) . ",
						    address = ".db_escape($line->address) . ",
						    phone = ".db_escape($line->phone).",
						    email = ".db_escape($line->email).",
						    update_by = ". db_escape($_SESSION['wa_current_user']->loginname). ", 
                                                    updated_date =     now()	
						WHERE id = {$line->id}";
		}
		else {
		$sql = "INSERT INTO ".TB_PREF."transport_consignor_details
		 (id, order_no, trans_type, consignor_no,phone, tin_no, address,created_by,created_date)
		 VALUES ( ". db_escape($line->id ? $line->id : 0) . ","
                            .$order_no . ",".$order->trans_type.","
                            .$line->consignor_code . ","
                            .db_escape($line->phone) . ",  "
                            .db_escape($line->tin_no) . ",  "
                            .db_escape($line->address) . ", "
                            .db_escape($_SESSION['wa_current_user']->loginname).",
                            now() )";
		}

		db_query($sql, "Old consignor details Cannot be Inserted");
            } /* inserted line items into transport booking details */
        // Prabha added this code to update transport_order_stops
        
        // Prabha added this code to update transport order stop details
        $id_tokeep = array();
	foreach ($order->loadstop_line_items as $line) {
		array_push($id_tokeep , $line->id);
	}
	$id_list = implode(', ', $id_tokeep);
	if (! empty($id_list))
        {
            $sql = "DELETE FROM ".TB_PREF."transport_order_stops WHERE pickup_delivery_type = 'P' AND order_no =" . db_escape($order_no) . " AND trans_type=".$order->trans_type;
            $sql .= " AND id NOT IN ($id_list)";
        
            db_query($sql, "Old transport_order_stops Cannot be Deleted");
        }

         else {
             $sql = "DELETE FROM ".TB_PREF."transport_order_stops WHERE pickup_delivery_type = 'P' AND order_no =" . db_escape($order_no) . " AND trans_type=".$order->trans_type;
               db_query($sql, "Old transport_order_stops Cannot be Deleted");
        }
            foreach ($order->loadstop_line_items as $line)
            {
		if($line->id) {
			$sql = "UPDATE ".TB_PREF."transport_order_stops 
						SET loc_code = ".$line->loc_code . ", 
                                                    pickup_delivery_type = 'P',
                                                    contact = ".db_escape($line->contact) . ",
                                                    stop_code = 1  ,
						    address = ".db_escape($line->address) . ",
                                                    stop_date = ".db_escape(date2sql($line->date)) . ",
                                                    stop_time = ".db_escape($line->time) . ",
						    updated_by = ". db_escape($_SESSION['wa_current_user']->loginname). ", 
                                                    updated_date =     now()	
						WHERE id = {$line->id}";
		}
		else {
		$sql = "INSERT INTO ".TB_PREF."transport_order_stops
		 (id, order_no, trans_type,pickup_delivery_type, loc_code,  contact,stop_code, address,stop_date,stop_time,
                 created_by,created_date)
		 VALUES (";
		$sql .= db_escape($line->id ? $line->id : 0) . ","
		  .$order_no . ",".$order->trans_type.",'P',"
		  .$line->loc_code . ","
		  .db_escape($line->contact) . ", "
                  .$line->loc_code . ","
		  .db_escape($line->address) . ", "
                  .db_escape(date2sql($line->date)) . ", "      
                  .db_escape($line->time) . ", "
                  .db_escape($_SESSION['wa_current_user']->loginname).",
                   now() )";
		}

		db_query($sql, "Old order stops Cannot be Inserted");
	}
        
        // Prabha added this code to update transport order stop details for delivery
        $id_tokeep = array();
	foreach ($order->loadstop_delivery_line_items as $line) {
		array_push($id_tokeep , $line->id);
	}
	$id_list = implode(', ', $id_tokeep);
	if (! empty($id_list))
        {
            $sql = "DELETE FROM ".TB_PREF."transport_order_stops WHERE pickup_delivery_type = 'D' AND order_no =" . db_escape($order_no) . " AND trans_type=".$order->trans_type;
            $sql .= " AND id NOT IN ($id_list)";
        
            db_query($sql, "Old transport_order_stops Cannot be Deleted");
        }

         else {
             $sql = "DELETE FROM ".TB_PREF."transport_order_stops WHERE pickup_delivery_type = 'D' AND order_no =" . db_escape($order_no) . " AND trans_type=".$order->trans_type;
               db_query($sql, "Old transport_order_stops Cannot be Deleted");
        }
            foreach ($order->loadstop_delivery_line_items as $line)
            {
		if($line->id) {
			$sql = "UPDATE ".TB_PREF."transport_order_stops 
						SET loc_code = ".$line->delivery_loc_code . ", 
                                                    pickup_delivery_type = 'D',
                                                    contact = ".db_escape($line->delivery_contact) . ",
                                                    stop_code = 1  ,
						    address = ".db_escape($line->delivery_address) . ",
                                                    stop_date = ".db_escape(date2sql($line->delivery_date)) . ",
                                                    stop_time = ".db_escape($line->delivery_time) . ",
						    updated_by = ". db_escape($_SESSION['wa_current_user']->loginname). ", 
                                                    updated_date =     now()	
						WHERE id = {$line->id}";
		}
		else {
		$sql = "INSERT INTO ".TB_PREF."transport_order_stops
		 (id, order_no, trans_type,pickup_delivery_type, loc_code,  contact,stop_code, address,stop_date,stop_time,
                 created_by,created_date)
		 VALUES (";
		$sql .= db_escape($line->id ? $line->id : 0) . ","
		  .$order_no . ",".$order->trans_type.",'D',"
		  .$line->delivery_loc_code . ","
		  .db_escape($line->delivery_contact) . ",1, "
                  .db_escape($line->delivery_address) . ", "
                  .db_escape(date2sql($line->delivery_date)) . ", "      
                  .db_escape($line->delivery_time) . ", "
                  .db_escape($_SESSION['wa_current_user']->loginname).",
                   now() )";
		}
                
		db_query($sql, "Old order delivery stops Cannot be Inserted");
	}
                // Update markers into transport_order_stops for this order
        $sql = " UPDATE ".TB_PREF."transport_order_markers 
                 SET order_no = ".$order_no .",
                     trans_type = ".$order->trans_type
                . " WHERE order_ref = ".$order->reference;
        db_query($sql, "order stops markers Cannot be Updated");
        
        
        // Prabha added this code to update transport order payment deposits details
            $id_tokeep = array();
            foreach ($order->gl_payment_items as $line) {
		array_push($id_tokeep , $line->id);
            }
        
            $id_list = implode(', ', $id_tokeep);
            if (! empty($id_list))
            {
                $sql = "DELETE FROM ".TB_PREF."trans_order_payments_deposits WHERE order_no =" . db_escape($order_no) . " AND trans_type=".$order->trans_type;
                $sql .= " AND id NOT IN ($id_list) and type = 12";

                db_query($sql, "Old trans_order_payments_deposits Cannot be Deleted");
            }
             else {
             $sql = "DELETE FROM ".TB_PREF."trans_order_payments_deposits WHERE order_no =" . db_escape($order_no) . " AND trans_type=".$order->trans_type ."  and type = 12";
               db_query($sql, "Old trans_order_payments_deposits Cannot be Deleted");
            }
            foreach ($order->gl_payment_items as $line)
            {
                    
		if($line->id) {
			$sql = "UPDATE ".TB_PREF."trans_order_payments_deposits 
						SET 
                                                type = 12,
                                                entity_type = ".$line->entity_type . ", 
                                                consignor_no = ".$line->consignor_no . ", 
                                                driver_code = ".$line->driver_no . ", 
                                                account_code = ".$line->code_id . ", 
                                                amount = ".$line->amount . ",
                                                memo = ".db_escape($line->line_memo) ."
						WHERE id = {$line->id}";
		}
		else {
		$sql = "INSERT INTO ".TB_PREF."trans_order_payments_deposits
		 (id, order_no, trans_type, type,
                  entity_type,consignor_no,driver_code,
                 account_code,amount,memo)
		 VALUES (";
		$sql .= db_escape($line->id ? $line->id : 0) . ","
		  .$order_no . ",".$order->trans_type.",12,".
                 $line->entity_type.", ".
                 $line->consignor_no.", ".
                 $line->driver_no.", ".
		  $line->code_id . ","
                  .$line->amount . ","      
		  .db_escape($line->line_memo) . ")";
		}

		db_query($sql, "Old order Cannot be Inserted");
	}
        
        
        $id_tokeep = array();
	foreach ($order->gl_deposit_items as $line) {
		array_push($id_tokeep , $line->id);
	}
	$id_list = implode(', ', $id_tokeep);
	if (! empty($id_list))
        {
            $sql = "DELETE FROM ".TB_PREF."trans_order_payments_deposits WHERE order_no =" . db_escape($order_no) . " AND trans_type=".$order->trans_type;
            $sql .= " AND id NOT IN ($id_list) and type = 10";

            db_query($sql, "Old trans_order_payments_deposits Cannot be Deleted");
        }
           else {
             $sql = "DELETE FROM ".TB_PREF."trans_order_payments_deposits WHERE order_no =" . db_escape($order_no) . " AND trans_type=".$order->trans_type ."  and type = 10";
               db_query($sql, "Old trans_order_payments_deposits Cannot be Deleted");
            }
        foreach ($order->gl_deposit_items as $line)
	{
		if($line->id) {
			$sql = "UPDATE ".TB_PREF."trans_order_payments_deposits 
						SET 
                                                type = 10,
                                                entity_type = ".$line->entity_type . ", 
                                                consignor_no = ".$line->consignor_no . ", 
                                                 driver_code = ".$line->driver_no . ", 
                                                account_code = ".$line->code_id . ", 
                                                amount = ".$line->amount . ",
                                                 memo = ".db_escape($line->line_memo) ."
						WHERE id = {$line->id}";
		}
		else {
		$sql = "INSERT INTO ".TB_PREF."trans_order_payments_deposits
		 (id, order_no, trans_type, type,entity_type,consignor_no,driver_code,
                 account_code,amount,memo)
		 VALUES (";
		$sql .= db_escape($line->id ? $line->id : 0) . ","
		  .$order_no . ",".$order->trans_type.",10,".
                  $line->entity_type.", ".
                  $line->consignor_no.", ".
                  $line->driver_no.", ".
		          $line->code_id . ","
                  .$line->amount . ","      
		  .db_escape($line->line_memo) . ")";
		}

		db_query($sql, "Old order Cannot be Inserted");
	}

	add_audit_trail($order->trans_type, $order_no, $order->document_date, _("Updated."));
	$Refs->save($order->trans_type, $order_no, $order->reference);

	hook_db_postwrite($order, $order->trans_type);
	commit_transaction();
	if ($loc_notification == 1 && count($st_ids) > 0)
	{
		require_once($path_to_root . "/reporting/includes/class.mail.inc");
		$company = get_company_prefs();
		$mail = new email($company['coy_name'], $company['email']);
		$from = $company['coy_name'] . " <" . $company['email'] . ">";
		$to = $loc['location_name'] . " <" . $loc['email'] . ">";
		$subject = _("Stocks below Re-Order Level at " . $loc['location_name']);
		$msg = "\n";
		for ($i = 0; $i < count($st_ids); $i++)
			$msg .= $st_ids[$i] . " " . $st_names[$i] . ", "
			  . _("Re-Order Level") . ": " . $st_reorder[$i] . ", "
			  . _("Below") . ": " . $st_num[$i] . "\n";
		$msg .= "\n" . _("Please reorder") . "\n\n";
		$msg .= $company['coy_name'];
		$mail->to($to);
		$mail->subject($subject);
		$mail->text($msg);
		$ret = $mail->send();
	}
}

//----------------------------------------------------------------------------------------

function get_transport_order_header($order_no, $trans_type)
{
	$sql = "SELECT sorder.*, 
		   loc.location_name, 
	   locto.location_name as location_name_to,
	   stype.transport_type, 
	   stype.id AS transport_type_id,
       stype.tax_included, 
	   stype.factor, 
 	   ship.shipper_name,
 	   consignor.name   
	FROM ".TB_PREF."transport_orders sorder 
	 	LEFT JOIN ".TB_PREF."shippers ship ON  ship.shipper_id = sorder.ship_via
	 	left join  ".TB_PREF."transport_types stype ON  sorder.order_type=stype.id	
	  left join  ".TB_PREF."consignors_master consignor on consignor.consignor_no = sorder.billing_no
	  left join  ".TB_PREF."locations locto on locto.loc_code = sorder.Location_to
	   left join  ".TB_PREF."locations loc on loc.loc_code = sorder.from_stk_loc
	  
	WHERE sorder.trans_type = " . db_escape($trans_type) ."
		AND sorder.order_no = " . db_escape($order_no )."
              
    ";

	$result = db_query($sql, "order Retreival");

	$num = db_num_rows($result);
	if ($num > 1)
	{
		display_warning("You have duplicate document in database: (type:$trans_type, number:$order_no).");
	}
	else if ($num == 1)
	{
		return db_fetch($result);
	}
	else
		display_warning("Prabha , You have missing or invalid transport document in database (type:$trans_type, number:$order_no).");

}

//----------------------------------------------------------------------------------------

function get_transport_order_details($order_no, $trans_type) {
	$sql = "SELECT id, stk_code, unit_price,to_units, "
		.TB_PREF."transport_order_details.description,"
		.TB_PREF."transport_order_details.quantity,
		  discount_percent,
		  qty_sent as qty_done
	FROM ".TB_PREF."transport_order_details, ".TB_PREF."transport_items_master
	WHERE ".TB_PREF."transport_order_details.stk_code = ".TB_PREF."transport_items_master.stock_id
	AND order_no =" . db_escape($order_no) 
		." AND trans_type = " . db_escape($trans_type) . " ORDER BY id";

	return db_query($sql, "Retreive order Line Items");
}
//----------------------------------------------------------------------------------------

//----------------------- Prabha added this function to get transport consignor details from the table-----------------
function get_transport_consignor_details($order_no, $trans_type) {
	$sql = "SELECT condet.id, condet.consignor_no, consignor_det.name,condet.tin_no,condet.address,condet.email,condet.phone
			FROM ".TB_PREF."transport_consignor_details condet
		left join ".TB_PREF."consignors_master consignor_det on condet.consignor_no = consignor_det.consignor_no
	WHERE  order_no =" . db_escape($order_no) 
		." AND trans_type = " . db_escape($trans_type) . " ORDER BY id";

	return db_query($sql, "Retreive order consignor Items");
}
//-------------------------------------------------------------------------------------------------
//---------------------Prabha added to get chart name from chart master table----------------------

function get_chart_name($code_id) {
	$sql = "SELECT *
			FROM ".TB_PREF."chart_master
	WHERE  account_code =" . db_escape($code_id) ;
		

	$result = db_query($sql, "Retreive payment deposits Items");
        $row = db_fetch($result);
        
	return $row;
}
//--------------------------------------------------------------------------------------------------
//----------------------Prabha added this function to get transport order stops from the table---------------
function get_transport_order_stop_details($order_no, $trans_type) {
	$sql = "SELECT id, loc_code, contact,address,stop_code,stop_date,stop_time,pickup_delivery_type
			FROM ".TB_PREF."transport_order_stops
	WHERE  order_no =" . db_escape($order_no) 
		." AND trans_type = " . db_escape($trans_type) . " ORDER BY id";

	return db_query($sql, "Retreive order stops Items");
}
//----------------------Prabha added this function to get transport order stops from the table---------------
function get_transport_order_marker_details($order_no, $trans_type) {
	$sql = "SELECT id, address,lat,lng,marker_id,order_ref
			FROM ".TB_PREF."transport_order_markers
	WHERE  order_no =" . db_escape($order_no) 
		." AND trans_type = " . db_escape($trans_type) . " ORDER BY id";

	return db_query($sql, "Retreive order stops markers");
}
//----------------------Prabha added this function to get get_transport_order_payment_deposit_details from the table---------------
function get_transport_order_payment_deposit_details($order_no, $trans_type) {
	$sql = "SELECT *
			FROM ".TB_PREF."trans_order_payments_deposits
	WHERE  order_no =" . db_escape($order_no) 
		." AND trans_type = " . db_escape($trans_type) . " ORDER BY id";

	return db_query($sql, "Retreive order order_payment_deposit Items");
}
//-----------------------------------------------------------------------------------------------------------
function get_transport_slip_header($order_no, $trans_type)
{	$sql = "SELECT sorder.*, "
	 
	  
	   ."loc.location_name as location_name,
	   "."locto.location_name as location_name_to
	
	
	FROM ".TB_PREF."transport_orders sorder," 
	  .TB_PREF."locations loc," 
	  .TB_PREF."locations locto
	WHERE loc.loc_code = sorder.from_stk_loc
		AND locto.loc_code = sorder.Location_to
		AND sorder.trans_type = " . db_escape($trans_type) ."
		AND sorder.order_no = " . db_escape($order_no );

	$result = db_query($sql, "order Retreival");

	$num = db_num_rows($result);
	if ($num > 1)
	{
		display_warning("You have duplicate document in database: (type:$trans_type, number:$order_no).");
	}
	else if ($num == 1)
	{
		return db_fetch($result);
	}
	else
		display_warning("Prbaha2 You have missing or invalid transport document in database (type:$trans_type, number:$order_no).");

}

//----------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------

function read_transport_slip($order_no, &$order, $trans_type)
{

	$myrow = get_transport_slip_header($order_no, $trans_type);
	$order->billing_id = $myrow["billing_no"];
	$order->bill_to = $myrow["bill_to"];
	$order->billing_tin_no = $myrow["billing_tin_no"];
	$order->billing_address = $myrow["billing_address"];
	$order->billing_name = $myrow["name"];
	$order->trans_type = $myrow['trans_type'];
	$order->so_type =  $myrow["type"];
	$order->trans_no = array($order_no=> $myrow["version"]);
	$order->set_location($myrow["from_stk_loc"], $myrow["location_name"]);
	$order->driver_ref =  $myrow["driver_ref"];
	$order->set_delivery($myrow["deliver_to"],$myrow["delivery_address"], $myrow["freight_cost"]);
	$order->contact_phone = $myrow["contact_phone"];
	$order->consignor_ref = $myrow["consignor_ref"];
	$order->goods_bill_no = $myrow["goods_bill_no"];
	$order->Location_to = $myrow["Location_to"];
	$order->location_name_to = $myrow["location_name_to"];
	$order->transport_type =$myrow["order_type"];
	$order->payment_by = $myrow["payment_by"];
	$order->service_tax_by =$myrow["service_tax_by"];
	$order->add_service_tax =$myrow["add_service_tax"];
	$order->contact_phone=$myrow["contact_phone"];
	$order->loaded_from = $myrow["loaded_from"];
	$order->loading_address =$myrow["loading_address"];
	$order->reference = $myrow["reference"];
	$order->Comments = $myrow["comments"];
	$order->due_date = sql2date($myrow["delivery_date"]);
	$order->document_date = sql2date($myrow["ord_date"]);
		if($myrow["driver_no"])
	{
	$driver = get_driver_desc($myrow["driver_no"]);
	$order->driver_name=$driver["driver_name"];
	$order->driver_id=$myrow["driver_no"];
	}
	if($myrow["vehicle_no"])
	{
	$driver = get_vehicle_desc($myrow["vehicle_no"]);
	$order->vehicle_number_plate=$driver["vehicle_number_plate"];
	$order->vehicle_id=$myrow["vehicle_no"];
	}
	$result = get_transport_order_details($order_no, $order->trans_type);
	if (db_num_rows($result) > 0)
	{
		$line_no=0;
		while ($myrow = db_fetch($result))
		{
			$order->add_to_cart($line_no,$myrow["stk_code"],$myrow["quantity"],$myrow["to_units"],
				$myrow["unit_price"], $myrow["discount_percent"],
				$myrow["qty_done"], $myrow["standard_cost"], $myrow["description"], $myrow["id"] );
		$line_no++;
		}
	}
//----------- Prabha added to get consignor details from the database-------------------------------
$result = get_transport_consignor_details($order_no, $order->trans_type);
	if (db_num_rows($result) > 0)
	{
		$line_no=0;
		while ($myrow = db_fetch($result))
		{
			$order->add_to_consignor_cart($line_no,$myrow["consignor_no"],"",$myrow["tin_no"],
				$myrow["address"],$myrow["phone"],$myrow["email"],  $myrow["id"] );
		$line_no++;
		}
	}

//---------------------------------------------------------------------------------------        
        
        
//----------- Prabha added to get transport order stop details from the database-------------------------------
$result = get_transport_order_stop_details($order_no, $order->trans_type);
	if (db_num_rows($result) > 0)
	{
		$line_no=0;
		while ($myrow = db_fetch($result))
		{
                    if ($myrow["pickup_delivery_type"] == 'P'){
                        $order->add_load_stop($line_no,$myrow["loc_code"],$myrow["stop_code"],$myrow["contact"],
				$myrow["address"], "",$myrow["stop_date"],$myrow["stop_time"],$myrow["id"] );
                    }
                    else
                    {
                        $order->add_load_stop_delivery($line_no,$myrow["loc_code"],$myrow["stop_code"],$myrow["contact"],
				$myrow["address"], "",$myrow["stop_date"],$myrow["stop_time"],$myrow["id"] );
                    }
		$line_no++;
		}
	}
//----------- Prabha added to get transport order markers details from the database-------------------------------
$result = get_transport_order_markers_details($order_no, $order->trans_type);
	if (db_num_rows($result) > 0)
	{
		$line_no=0;
		while ($myrow = db_fetch($result))
		{
			$order->add_load_markers($line_no,$myrow["id"],$myrow["address"],$myrow["lat"],
				$myrow["lng"], $myrow["marker_id"],$myrow["order_ref"] );
		$line_no++;
		}
	}
//---------------------------------------------------------------------------------------        
// Prabha added to get payment order details from the database
        
        $result = get_transport_order_payment_deposit_details($order_no, $order->trans_type);
	if (db_num_rows($result) > 0)
	{
		$pay_line_no = 0;
                $dep_line_no = 0;
		while ($myrow = db_fetch($result))
		{
   
                        if($myrow["type"] == 10)
                        {
                            $order->add_deposit($dep_line_no,$myrow["account_code"],$myrow["amount"],$myrow["memo"],"",$myrow["id"]);
                            $dep_line_no++;
                        }
                        else
                        {
                            $order->add_payment($pay_line_no,$myrow["account_code"],$myrow["amount"],$myrow["memo"],"",$myrow["id"]);
                            $pay_line_no++;
                        }
		
		}
	}

//---------------------------------------------------------------------------------------        
	return true;
}

function get_transport_booking_header($order_no, $trans_type)
{
	$sql = "SELECT sorder.*, 
	 (SELECT loc.location_name  FROM 0_locations loc WHERE loc.loc_code = sorder.from_stk_loc )  location_name, 
         (SELECT loc.location_name  FROM 0_locations loc WHERE loc.loc_code = sorder.Location_to )   location_name_to 
	  
	FROM ".TB_PREF."transport_orders sorder," 
	  .TB_PREF."locations loc," 
	  .TB_PREF."locations locto
	WHERE  sorder.trans_type = " . db_escape($trans_type) ."
		AND sorder.order_no = " . db_escape($order_no );

	$result = db_query($sql, "order Retreival");

	$num = db_num_rows($result);
	if ($num > 1)
	{
		display_warning("You have duplicate document in database: (type:$trans_type, number:$order_no).");
	}
	else if ($num == 1)
	{
		return db_fetch($result);
	}
//	else
//		display_warning(" You have missing or invalid transport document in database (type:$trans_type, number:$order_no).");

}

//----------------------------------------------------------------------------------------


//----------------------------------------------------------------------------------------

function read_transport_booking($order_no, &$order, $trans_type)
{

	$myrow = get_transport_booking_header($order_no, $trans_type);
	//$myrow = get_transport_order_header($order_no, $trans_type);
        
	$order->trans_type = $myrow['trans_type'];
        
	$order->so_type =  $myrow["type"];
	$order->trans_no = array($order_no=> $myrow["version"]);
	$order->set_location($myrow["from_stk_loc"], $myrow["location_name"]);
	$order->driver_ref =  $myrow["driver_ref"];
	$order->set_delivery($myrow["deliver_to"],$myrow["delivery_address"], $myrow["freight_cost"]);
	$order->contact_phone = $myrow["contact_phone"];
	$order->consignor_ref = $myrow["consignor_ref"];
	$order->Location_to = $myrow["Location_to"];
	$order->location_name_to = $myrow["location_name_to"];
	$order->goods_bill_no = $myrow["goods_bill_no"];
	$order->transport_type =$myrow["order_type"];
	$order->payment_by = $myrow["payment_by"];
	$order->service_tax_by =$myrow["service_tax_by"];
	$order->service_tax_paid =$myrow["add_service_tax"];
	$order->reference = $myrow["reference"];
	$order->Comments = $myrow["comments"];
	$order->due_date = sql2date($myrow["delivery_date"]);
	$order->document_date = sql2date($myrow["ord_date"]);
	$order->contact_phone=$myrow["contact_phone"];
		if($myrow["driver_no"])
	{
	$driver = get_driver_desc($myrow["driver_no"]);
	$order->driver_name=$driver["driver_name"];
	$order->driver_id=$myrow["driver_no"];
	}
	if($myrow["vehicle_no"])
	{
	$driver = get_vehicle_desc($myrow["vehicle_no"]);
	$order->vehicle_number_plate=$driver["vehicle_number_plate"];
	$order->vehicle_id=$myrow["vehicle_no"];
	}
	$result = get_transport_order_details($order_no, $order->trans_type);
	if (db_num_rows($result) > 0)
	{
		$line_no=0;
		while ($myrow = db_fetch($result))
		{
			$order->add_to_cart($line_no,$myrow["stk_code"],$myrow["quantity"],$myrow["to_units"],
				$myrow["unit_price"], $myrow["discount_percent"],
				$myrow["qty_done"], $myrow["standard_cost"], $myrow["description"], $myrow["id"] );
		$line_no++;
		}
	}
//----------- Prabha added to get consignor details from the database-------------------------------
$result = get_transport_consignor_details($order_no, $order->trans_type);
	if (db_num_rows($result) > 0)
	{
		$line_no=0;
		while ($myrow = db_fetch($result))
		{
			$order->add_to_consignor_cart($line_no,$myrow["consignor_no"],"",$myrow["tin_no"],
				$myrow["address"], $myrow["phone"],$myrow["email"], $myrow["id"] );
		$line_no++;
		}
	}

//---------------------------------------------------------------------------------------        
        
        
//----------- Prabha added to get transport order stop details from the database-------------------------------
$result = get_transport_order_stop_details($order_no, $order->trans_type);
	if (db_num_rows($result) > 0)
	{
		$line_no=0;
		while ($myrow = db_fetch($result))
		{
                    if ($myrow["pickup_delivery_type"] == 'P'){
                        $order->add_load_stop($line_no,$myrow["loc_code"],$myrow["stop_code"],$myrow["contact"],
				$myrow["address"], $myrow["stop_date"],$myrow["stop_time"],$myrow["id"] );
                    }
                    else
                    {
                        $order->add_load_stop_delivery($line_no,$myrow["loc_code"],$myrow["stop_code"],$myrow["contact"],
				$myrow["address"], "",$myrow["stop_date"],$myrow["stop_time"],$myrow["id"] );
                    }
		$line_no++;
		}
	}
        //----------- Prabha added to get transport order markers details from the database-------------------------------
$result = get_transport_order_markers_details($order_no, $order->trans_type);
	if (db_num_rows($result) > 0)
	{
		$line_no=0;
		while ($myrow = db_fetch($result))
		{
			$order->add_load_markers($line_no,$myrow["id"],$myrow["address"],$myrow["lat"],
				$myrow["lng"], "",$myrow["marker_id"],$myrow["order_ref"] );
		$line_no++;
		}
	}
//---------------------------------------------------------------------------------------        

$result = get_transport_order_payment_deposit_details($order_no, $order->trans_type);
	if (db_num_rows($result) > 0)
	{
		$pay_line_no = 0;
                $dep_line_no = 0;
		while ($myrow = db_fetch($result))
		{
                        if($myrow["type"] == 10)
                        {
                           
                            $order->add_deposit($dep_line_no,
                                    $myrow["entity_type"],
                                    $myrow["consignor_no"],
                                    $myrow["driver_code"],
                                    $myrow["account_code"],$myrow["amount"],$myrow["memo"],"",$myrow["id"]);
                            $dep_line_no++;
                        }
                        else
                        {
                            $order->add_payment($pay_line_no,
                                     $myrow["entity_type"],
                                    $myrow["consignor_no"],
                                    $myrow["driver_code"],
                                    $myrow["account_code"],$myrow["amount"],$myrow["memo"],"",$myrow["id"]);
                            $pay_line_no++;
                        }
		
		}

	}
        
//---------------------------------------------------------------------------------------        

	return true;
}
function read_transport_order($order_no, &$order, $trans_type)
{

	$myrow = get_transport_order_header($order_no, $trans_type);
	
	$order->trans_type = $myrow['trans_type'];
        $order->trans_type = 30;
	$order->so_type =  $myrow["type"];
	$order->trans_no = array($order_no=> $myrow["version"]);
	$order->billing_id = $myrow["billing_no"];
	$order->bill_to = $myrow["bill_to"];
    $order->contact_person = $myrow["contact_person"];
    $order->billing_phone = $myrow["billing_phone"];
    $order->billing_email = $myrow["billing_email"];
    $order->consignee_phone = $myrow["consignee_phone"];
    $order->consignee_email = $myrow["consignee_email"];
	$order->billing_tin_no = $myrow["billing_tin_no"];
	$order->billing_address = $myrow["billing_address"];
	$order->billing_name = $myrow["name"];
    $order->TruckStatusTypeList = $myrow["truck_status_code"];
	$order->set_consignor($myrow["consignor_no"], $myrow["consignor_name"],
	  $myrow["consignor_currency"], $myrow["consignor_discount"], $myrow["payment_terms"]);

 $order->consignee_id=$myrow["consignee_no"];
 if($myrow["consignee_no"]){
 
	$results = get_consignee_to_order($myrow["consignee_no"]);
	$order->consignee_name=$results["consignee_name"];
 }
 $order->driver_id=$myrow["driver_no"];
 
 $order->vehicle_id=$myrow["vehicle_no"];

$order->consignee_tin_no = $myrow["consignee_tin_no"];
	$order->set_transport_type($myrow["transport_type_id"], $myrow["transport_type"], 
	    $myrow["tax_included"], $myrow["factor"]); // no default price calculations on edit
$order->contact_phone=$myrow["contact_phone"];
	$order->set_location($myrow["from_stk_loc"], $myrow["location_name"]);
	$order->Location_to = $myrow["Location_to"];
	$order->location_name_to = $myrow["location_name_to"];
	
	$order->set_delivery($myrow["deliver_to"],$myrow["delivery_address"], $myrow["freight_cost"]);
	  $order->total_goods_value = $myrow["total_goods_value"];
	$order->commission_cost = $myrow["commission_cost"];
	$order->labour_charge = $myrow["labour_charge"];
	$order->insc_charge = $myrow["insc_charge"];
	$order->ship_cost = $myrow["ship_cost"];
	$order->goods_bill_no = $myrow["goods_bill_no"];
	$order->bilty_charge = $myrow["bilty_charge"];
	$order->way_cost = $myrow["way_cost"];
	$order->consignor_ref = $myrow["consignor_ref"];
	$order->consignee_ref = $myrow["consignee_ref"];
	$order->payment_by = $myrow["payment_by"];
	$order->service_tax_by =$myrow["service_tax_by"];
	$order->service_tax_paid =$myrow["add_service_tax"];
	$order->transport_type =$myrow["order_type"];
	$order->reference = $myrow["reference"];
    $order->LoadStatusList = $myrow['load_status_code'];
    $order->ship_via = $myrow['ship_via'];
	$order->Comments = $myrow["comments"];
	$order->due_date = sql2date($myrow["delivery_date"]);
	$order->document_date = sql2date($myrow["ord_date"]);
	$order->loaded_from = $myrow["loaded_from"];
	$order->loading_address =$myrow["loading_address"];
	if($myrow["driver_no"])
	{
	$driver = get_driver_desc($myrow["driver_no"]);
	$order->driver_name=$driver["driver_name"];
	$order->driver_ref =  $myrow["driver_ref"];
	}
	if($myrow["vehicle_no"])
	{
	$driver = get_vehicle_desc($myrow["vehicle_no"]);
	$order->vehicle_number_plate=$driver["vehicle_number_plate"];
	}
        
	$result = get_transport_order_details($order_no, $order->trans_type);
	if (db_num_rows($result) > 0)
	{
		$line_no=0;
		while ($myrow = db_fetch($result))
		{
			$order->add_to_cart($line_no,$myrow["stk_code"],$myrow["quantity"],$myrow["to_units"],
				$myrow["unit_price"], $myrow["discount_percent"],
				$myrow["qty_done"], 0, $myrow["description"], $myrow["id"] );
		$line_no++;
		}
	}
//----------- Prabha added to get consignor details from the database-------------------------------
$result = get_transport_consignor_details($order_no, $order->trans_type);
	if (db_num_rows($result) > 0)
	{
		$line_no=0;
		while ($myrow = db_fetch($result))
		{
			$order->add_to_consignor_cart($line_no,$myrow["consignor_no"],"",$myrow["tin_no"],
				$myrow["address"],$myrow["phone"],$myrow["email"],  $myrow["id"] );
		$line_no++;
		}
	}

//---------------------------------------------------------------------------------------        
        
        
//----------- Prabha added to get transport order stop details from the database-------------------------------
$result = get_transport_order_stop_details($order_no, $order->trans_type);
	if (db_num_rows($result) > 0)
	{
		$line_no=0;
		while ($myrow = db_fetch($result))
		{
                    if ($myrow["pickup_delivery_type"] == 'P'){
			$order->add_load_stop($line_no,$myrow["loc_code"],$myrow["stop_code"],$myrow["contact"],
				$myrow["address"], $myrow["stop_date"],$myrow["stop_time"],$myrow["id"] );
                    }
                    else
                    {
                        $order->add_load_stop_delivery($line_no,$myrow["loc_code"],$myrow["stop_code"],$myrow["contact"],
				$myrow["address"], "",$myrow["stop_date"],$myrow["stop_time"],$myrow["id"] );
                    }
		$line_no++;
		}
	}
        
        //----------- Prabha added to get transport order markers details from the database-------------------------------
$result = get_transport_order_marker_details($order_no, $order->trans_type);
	if (db_num_rows($result) > 0)
	{
		$line_no=0;
		while ($myrow = db_fetch($result))
		{
			$order->add_load_markers($line_no,$myrow["id"],$myrow["address"],$myrow["lat"],
				$myrow["lng"], $myrow["marker_id"],$myrow["order_ref"] );
		$line_no++;
		}
	}
        
//---------------------------------------------------------------------------------------        

     $result = get_transport_order_payment_deposit_details($order_no, $order->trans_type);
	if (db_num_rows($result) > 0)
	{
		$pay_line_no = 0;
                $dep_line_no = 0;
		while ($myrow = db_fetch($result))
		{
                        if($myrow["type"] == 10)
                        {
                           
                            $order->add_deposit($dep_line_no,
                                    $myrow["entity_type"],
                                    $myrow["consignor_no"],
                                    $myrow["driver_code"],
                                    $myrow["account_code"],$myrow["amount"],$myrow["memo"],"",$myrow["id"]);
                            $dep_line_no++;
                        }
                        else
                        {
                            $order->add_payment($pay_line_no,
                                     $myrow["entity_type"],
                                    $myrow["consignor_no"],
                                    $myrow["driver_code"],
                                    $myrow["account_code"],$myrow["amount"],$myrow["memo"],"",$myrow["id"]);
                            $pay_line_no++;
                        }
		
		}

	}
//---------------------------------------------------------------------------------------        
//print_r($order);
	return true;
}
function get_vehicle_desc($vehicle_no)
{
	$sql = "SELECT stocks.description as vehicle_number_plate FROM ".TB_PREF."vehicles_master stocks WHERE stocks.vehicle_id = " . db_escape($vehicle_no);

	$result = db_query($sql, "order Retreival");

	$num = db_num_rows($result);
	if ($num > 1)
	{
		display_warning("Error in Fething vehicle");
	}
	else if ($num == 1)
	{
		return db_fetch($result);
	}
	else
		display_warning("Error in Fething vehicle");

}
function get_driver_desc($driver_no)
{
		$sql = "SELECT drivers.name as driver_name FROM ".TB_PREF."drivers_master drivers 
	WHERE drivers.driver_no = " . db_escape($driver_no );

	$result = db_query($sql, "order Retreival");

	$num = db_num_rows($result);
	if ($num > 1)
	{
		display_warning("Error in Fething driver");
	}
	else if ($num == 1)
	{
		return db_fetch($result);
	}
	else
		display_warning("Error in Fething driver");
}
//----------------------------------------------------------------------------------------

function transport_order_has_deliveries($order_no)
{
	$sql = "SELECT SUM(qty_sent) FROM ".TB_PREF.
	"transport_order_details WHERE order_no=".db_escape($order_no)
	." AND trans_type=".ST_TRANSPORTORDER;

	$result = db_query($sql, "could not query for transport booking usage");

	$row = db_fetch_row($result);

	if ($row[0] > 0)
		return true;  // 2010-04-21 added check for eventually voided deliveries, Joe Hunt
	$sql = "SELECT order_ FROM ".TB_PREF."consignor_trans WHERE type=".ST_CONSIGNORDELIVERY." AND order_=".db_escape($order_no);
	$result = db_query($sql,"The related delivery notes could not be retreived");
	return (db_num_rows($result) > 0);	
}

//----------------------------------------------------------------------------------------

function close_transport_order($order_no)
{
	// set the quantity of each item to the already sent quantity. this will mark item as closed.
	$sql = "UPDATE ".TB_PREF."transport_order_details
		SET quantity = qty_sent WHERE order_no = ".db_escape($order_no)
		." AND trans_type=".ST_TRANSPORTORDER;

	db_query($sql, "The transport booking detail record could not be updated");
}

//---------------------------------------------------------------------------------------------------------------

function get_invoice_duedate($terms, $invdate)
{
	if (!is_date($invdate))
	{
		return new_doc_date();
	}
	
	$myrow = get_payment_terms($terms);
	
	if (!$myrow)
		return $invdate;

	if ($myrow['day_in_following_month'] > 0)
		$duedate = add_days(end_month($invdate), $myrow['day_in_following_month']);
	else
		$duedate = add_days($invdate, $myrow['days_before_due']);
	return $duedate;
}

function get_consignor_to_order($consignor_id) {

	// Now check to ensure this account is not on hold */
	$sql = "SELECT consignor.name, 
		  consignor.address, 
		  consignor.tin_no,
		  consignor.contact_name,
		  consignor.phone,
		  consignor.email
		 	FROM ".TB_PREF."consignors_master consignor
			WHERE consignor.consignor_no = ".db_escape($consignor_id);

	$result =db_query($sql,"Consignor Record Retreive");
	return 	db_fetch($result);
}


function get_consignee_to_order($consignee_id) {

	// Now check to ensure this account is not on hold */
	$sql = "SELECT consignee.name as consignee_name, 
		  consignee.address as address, 		  
		  stype.tax_included,
		  stype.factor
		FROM ".TB_PREF."consignors_master consignee
		  LEFT JOIN ".TB_PREF."consignee_trans trans ON trans.type!=".ST_CONSIGNORDELIVERY." AND trans.consignee_no = consignee.consignor_no,"
		  .TB_PREF."credit_status, "
		  .TB_PREF."transport_types stype
		WHERE  consignee.consignor_no = ".db_escape($consignee_id)
		." GROUP by consignee.consignor_no";

	$result =db_query($sql,"Consignor Record Retreive");
	
	return 	db_fetch($result);
}


function get_sql_for_transport_orders_view($selected_consignor,$trans_type, $filter)
{
    $sql = "SELECT 
			sorder.order_no,
			sorder.reference,
			consignor.name,
			sorder.contact_person,
			sorder.ord_date,
			sorder.delivery_date,
			load_status.load_status_name as load_status_name,
			truck_status.truck_status_type_name as truck_status_name,
			locations_from.location_name as loc_from,
			locations_to.location_name as loc_to,
			Sum(line.unit_price*line.quantity*(1-line.discount_percent))+freight_cost AS OrderValue,
            sorder.total_deposit,sorder.total_payment, 
			sorder.type
		/*	Sum(line.qty_sent) AS TotDelivered,
			Sum(line.quantity) AS TotQuantity,*/
            
		FROM ".TB_PREF."transport_orders as sorder 
        	left join ".TB_PREF."transport_order_details as line on sorder.order_no = line.order_no
        	left join ".TB_PREF."consignors_master as consignor on sorder.billing_no = consignor.consignor_no
        	left join ".TB_PREF."load_status as load_status on sorder.load_status_code = load_status.load_status_code
        	left join ".TB_PREF."truck_status_type as truck_status on sorder.truck_status_code = truck_status.truck_status_type_code
			left join ".TB_PREF."locations as locations_from on sorder.from_stk_loc = locations_from.loc_code
			left join ".TB_PREF."locations as locations_to on sorder.Location_to = locations_to.loc_code
			WHERE sorder.trans_type = ".db_escape($trans_type)."
		";

        if ($filter=='InvoiceTemplates' || $filter=='DeliveryTemplates')
            $sql .= " AND sorder.type=1";
		
        $sql .= " GROUP BY sorder.order_no,
					sorder.billing_no,
					sorder.ord_date
					";
    
	return $sql;
}

function get_consignor_docs($trans_id, $trans_type)
{
	global $go_debug;

	$sql = "SELECT trans.*,"
		."ov_amount+ov_gst+ov_freight+ov_freight_tax+ov_discount AS Total,"
		."consignor.name AS ConsignorName, consignor.address, "
		."consignor.curr_code, "
		."consignor.tax_id, "
		."com.memo_";

	if ($trans_type == ST_CONSIGNORPAYMENT || $trans_type == ST_BANKDEPOSIT) {
		// it's a payment so also get the bank account
		// Chaitanya : Added bank_act to support Consignor Payment Edit
		$sql .= ",bank_act,".TB_PREF."bank_accounts.bank_name, ".TB_PREF."bank_accounts.bank_account_name,
			".TB_PREF."bank_accounts.account_type AS BankTransType,
			".TB_PREF."bank_accounts.bank_curr_code,
			".TB_PREF."bank_trans.amount as bank_amount";
	}

	if ($trans_type == ST_TRANSPORTINVOICE || $trans_type == ST_CONSIGNORCREDIT || $trans_type == ST_CONSIGNORDELIVERY) {
		// it's an invoice so also get the shipper and transporttype
		$sql .= ", ".TB_PREF."shippers.shipper_name, "
		.TB_PREF."transport_types.transport_type, "
		.TB_PREF."transport_types.tax_included, "
		."branch.*, "
		."consignor.discount, "
		.TB_PREF."tax_groups.name AS tax_group_name, "
		.TB_PREF."tax_groups.id AS tax_group_id ";
	}

	$sql .= " FROM ".TB_PREF."consignor_trans trans
					LEFT JOIN ".TB_PREF."comments com ON trans.type=com.type AND trans.trans_no=com.id
					LEFT JOIN ".TB_PREF."shippers ON ".TB_PREF."shippers.shipper_id=trans.ship_via, 
					".TB_PREF."consignors_master consignor";

	if ($trans_type == ST_CONSIGNORPAYMENT || $trans_type == ST_BANKDEPOSIT) {
		// it's a payment so also get the bank account
		$sql .= ", ".TB_PREF."bank_trans, ".TB_PREF."bank_accounts";
	}

	if ($trans_type == ST_TRANSPORTINVOICE || $trans_type == ST_CONSIGNORCREDIT || $trans_type == ST_CONSIGNORDELIVERY) {
		// it's an invoice so also get the shipper, transporttypes
		$sql .= ", ".TB_PREF."transport_types, "
		.TB_PREF."consignor_branch branch, "
		.TB_PREF."tax_groups ";
	}

	$sql .= " WHERE trans.trans_no=".db_escape($trans_id)."
		AND trans.type=".db_escape($trans_type)."
		AND trans.consignor_no=consignor.consignor_no";

	if ($trans_type == ST_CONSIGNORPAYMENT || $trans_type == ST_BANKDEPOSIT) {
		// it's a payment so also get the bank account
		$sql .= " AND ".TB_PREF."bank_trans.trans_no =".db_escape($trans_id)."
			AND ".TB_PREF."bank_trans.type=$trans_type
			AND ".TB_PREF."bank_trans.amount != 0
			AND ".TB_PREF."bank_accounts.id=".TB_PREF."bank_trans.bank_act ";
	}
	if ($trans_type == ST_TRANSPORTINVOICE || $trans_type == ST_CONSIGNORCREDIT || $trans_type == ST_CONSIGNORDELIVERY) {
		// it's an invoice so also get the shipper
		$sql .= " AND ".TB_PREF."transport_types.id = trans.tpe
			AND branch.branch_code = trans.branch_code
			AND branch.tax_group_id = ".TB_PREF."tax_groups.id ";
	}

	$result = db_query($sql, "Cannot retreive a consignor transaction");

	if (db_num_rows($result) == 0) {
		// can't return nothing
		if($go_debug)
			display_backtrace();
		display_db_error("no consignor trans found for given params", $sql, true);
		exit;
	}
	if (db_num_rows($result) > 1) {
		// can't return multiple
		if($go_debug)
			display_backtrace();
		display_db_error("duplicate consignor transactions found for given params", $sql, true);
		exit;
	}

	$row = db_fetch($result);
	return $row;
}

?>

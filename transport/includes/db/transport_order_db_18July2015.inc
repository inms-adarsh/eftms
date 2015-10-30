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

function get_consignor_branch_details($consignor_no,$consignor_branch)
{
    
	$sql = "SELECT * FROM ".TB_PREF."consignor_branch
		WHERE consignor_no = ".$consignor_no."  AND branch_code = ".$consignor_branch." LIMIT 1";
	$result = db_query($sql, "could not retrieve consignor branch details");

	
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
        $total_goods_value = $order->get_items_total();
        $payment_total = $order->get_trans_payment();
        $deposit_total = $order->get_trans_deposit();
	$sql = "INSERT INTO ".TB_PREF."transport_orders (order_no,Location_to, type,consignee_no,
                        consignor_tin_no,consignee_tin_no,vehicle_no,driver_no,driver_ref, trans_type,  
                        consignor_ref,consignee_ref, reference, comments, ord_date,
                        order_type, ship_via, deliver_to, delivery_address, contact_phone,
                        freight_cost,ship_cost,commission_cost,way_cost, labour_charge,insc_charge, bilty_charge, 
                        from_stk_loc, delivery_date, payment_terms, total,total_goods_value,goods_bill_no,
                        loading_address,loaded_from,payment_by,service_tax_by,add_service_tax,
                        paid_date ,
                        paid_account_ref,
                        total_payment,
                        deposit_date,
                        deposit_account_ref,
                        total_deposit
                )
		VALUES (" .db_escape($order_no) . "," .db_escape($order->Location_to) . "," .db_escape($order_type) . ",
			" . db_escape($order->consignee_id) . ",
        		" . db_escape($order->consignor_tin_no) . ",
                	" . db_escape($order->consignee_tin_no) . ",
                        " . db_escape($order->vehicle_id) . ",
                        " . db_escape($order->driver_id) . ",	
                        " . db_escape($order->driver_ref) . ",		
                        " . db_escape($order->trans_type) . ",
			".  db_escape($order->consignor_ref) .", 
			".  db_escape($order->consignee_ref) .",". 
                            db_escape($order->reference) .",". 
                            db_escape($order->Comments) .",'" . 
                            date2sql($order->document_date) . "', " .
                            db_escape($order->transport_type) . ", " .
                            db_escape($order->ship_via)."," . 
                            db_escape($order->deliver_to) . "," .
                            db_escape($order->delivery_address) . ", " .
                            db_escape($order->phone) . ", " . 
                            db_escape($order->freight_cost) .", " . 
                            db_escape($order->ship_cost) .", " . 
                            db_escape($order->commission_cost) .", " . 
                            db_escape($order->way_cost) .", " .
                            db_escape($order->labour_charge) .", " .
                            db_escape($order->insc_charge) .", " .
                            db_escape($order->bilty_charge) .", ".
                            db_escape($order->Location) .", " .
                            db_escape($del_date) . "," .
                            db_escape($order->payment) . "," .
                            db_escape($total). "," .
                            db_escape($total_goods_value). ",".
                            db_escape($order->goods_bill_no). ",".
                            db_escape($order->loading_address). ",".
                            db_escape($order->loaded_from). ",".
                            db_escape($order->payment_by). ",".
                            db_escape($order->service_tax_by). ",".
                            db_escape($order->service_tax_paid). ",".
                            date2sql($order->paid_date). ",".
                            db_escape($order->reference). "," .
                            $payment_total .",".
                            date2sql($order->deposit_date). ",".
                            db_escape($order->reference). ",".
                            $deposit_total .
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
                        . "(order_no, trans_type, consignor_no, branch_code, tin_no, address,"
                        . "created_by, created_date) VALUES (";
		$sql .= $order_no . ",".$order->trans_type .",".
                                        $line->consignor_code.", ".
                                        $line->consignor_branch_code ."," .
                                        db_escape($line->tin_no)."," .
                                        db_escape($line->address). ",".
                                        db_escape($_SESSION['wa_current_user']->loginname).
                                    ", now())";
		db_query($sql, "order consignor Details Cannot be Added");


	} 
        // Prabha added this code to insert into transport_order_stops table
        foreach ($order->loadstop_line_items as $line)
	{
		
		$sql = "INSERT INTO ".TB_PREF."transport_order_stops "
                        . "(order_no, trans_type, loc_code, contact, address, stop_code,stop_date,stop_time,"
                        . "created_by, created_date) VALUES (";
		$sql .= $order_no . ",".$order->trans_type .",".
                                        $line->loc_code.", ".
                                        db_escape($line->contact) ."," .
                                        db_escape($line->address)."," . "1 ,".
                                        db_escape(date2sql($line->date)). ",".
                                        db_escape($line->time). ",".
                                        db_escape($_SESSION['wa_current_user']->loginname).
                                    ", now())";
                
		db_query($sql, "order stops Details Cannot be Added");


	}
        // Prabha added this code to insert into transport_order_payments and deposits table
        foreach ($order->gl_payment_items as $line)
	{
		
             
                        
		$sql = "INSERT INTO ".TB_PREF."trans_order_payments_deposits "
                        . "(order_no, trans_type, type,
                            entity_type,consignor_no,branch_code,driver_code,
                            account_code, amount,memo )
                          VALUES (";
		$sql .= $order_no . ",".$order->trans_type .",".
                                        $line->type.", ".
                                        $line->entity_type.", ".
                                        $line->consignor_no.", ".
                                        $line->branch_code.", ".
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
                             entity_type,consignor_no,branch_code,driver_code,
                            account_code, amount,memo )
                          VALUES (";
		$sql .= $order_no . ",".$order->trans_type .",".
                                        $line->type.", ".
                                        $line->entity_type.", ".
                                        $line->consignor_no.", ".
                                        $line->branch_code.", ".
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
        $total_goods_value = $order->get_items_total();
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
		consignee_branch_code = " . db_escape($order->consignee_branch) . ",
		consignee_ref = ". db_escape($order->consignee_ref) .",
		reference = ". db_escape($order->reference) .",
		comments = ". db_escape($order->Comments) .",
		ord_date = " . db_escape($ord_date) . ",
		order_type = " .db_escape($order->transport_type) . ",
		ship_via = " . db_escape($order->ship_via) .",
		deliver_to = " . db_escape($order->deliver_to) . ",
		delivery_address = " . db_escape($order->delivery_address) . ",
		contact_phone = " .db_escape($order->phone) . ",
		freight_cost = " .db_escape($order->freight_cost) .",
		ship_cost = " .db_escape($order->ship_cost) .",
		bilty_charge = " .db_escape($order->bilty_charge) .",
		insc_charge = " .db_escape($order->insc_charge) .",
		commission_cost = " .db_escape($order->commission_cost) .",
		labour_charge = " .db_escape($order->labour_charge) .",
		way_cost = " .db_escape($order->way_cost) .",
		from_stk_loc = " .db_escape($order->Location) .",
		delivery_date = " .db_escape($del_date). ",
		version = ".($version+1).",
		payment_terms = " .db_escape($order->payment). ",
		total = ". db_escape($total) .",
		loaded_from = " .db_escape($order->loaded_from). ",
		loading_address = ". db_escape($order->loading_address) .",
		total_goods_value = ". $total_goods_value .",
		goods_bill_no = ". db_escape($order->goods_bill_no) .",
		payment_by = " .db_escape($order->payment_by). ",
		service_tax_by = ". db_escape($order->service_tax_by) .",
		add_service_tax = ". db_escape($order->service_tax_paid) ." ,
                paid_date = ".db_escape($order->paid_date). ",
                paid_account_ref = ".db_escape($order->reference). ",
                total_payment = ".$payment_total .",
                total_deposit = ". $deposit_total .",    
                deposit_date = ".db_escape($order->deposit_date). ",
                deposit_account_ref = ".db_escape($order->reference). "
	 WHERE order_no=" . db_escape($order_no) ."
	 AND trans_type=".$order->trans_type." AND version=".$version;

	db_query($sql, "order Cannot be Updated, this can be concurrent edition conflict");

	$id_tokeep = array();
	foreach ($order->line_items as $line) {
		array_push($id_tokeep , $line->id);
	}
	$id_list = implode(', ', $id_tokeep);
	if(in_array($order->trans_type, array(ST_TRANSPORTINVOICE, ST_CONSIGNORDELIVERY, ST_TRANSPORTORDER,ST_TRANSPORTQUOTE)))
        {
            $sql = "DELETE FROM ".TB_PREF."transport_order_details WHERE order_no =" . db_escape($order_no) . " AND trans_type=".$order->trans_type;
            $sql .= " AND id NOT IN ($id_list)";

            db_query($sql, "Old order Cannot be Deleted");

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
        }        

        // Prabha added this code to update transport order consignor details
        
        $id_tokeep = array();
	foreach ($order->consignor_line_items as $line) {
		array_push($id_tokeep , $line->id);
	}
	$id_list = implode(', ', $id_tokeep);
	
            $sql = "DELETE FROM ".TB_PREF."transport_consignor_details WHERE order_no =" . db_escape($order_no) . " AND trans_type=".$order->trans_type;
            $sql .= " AND id NOT IN ($id_list)";

            db_query($sql, "Old transport_consignor_details Cannot be Deleted");
            foreach ($order->consignor_line_items as $line)
            {
            
		if($line->id) {
			$sql = "UPDATE ".TB_PREF."transport_consignor_details 
						SET consignor_no = ".$line->consignor_code . ", 
                                                    branch_code = ".$line->consignor_branch_code . ",
                                                    tin_no = ".db_escape($line->tin_no) . ",
						    address = ".db_escape($line->address) . ",
						    update_by = ". db_escape($_SESSION['wa_current_user']->loginname). ", 
                                                    updated_date =     now()	
						WHERE id = {$line->id}";
		}
		else {
		$sql = "INSERT INTO ".TB_PREF."transport_consignor_details
		 (id, order_no, trans_type, consignor_no,  branch_code,tin_no, address,created_by,created_date)
		 VALUES ( ". db_escape($line->id ? $line->id : 0) . ","
                            .$order_no . ",".$order->trans_type.","
                            .$line->consignor_code . ","
                            .$line->consignor_branch_code . ", "
                            .db_escape($line->tin_no) . ",  "
                            .db_escape($line->address) . ", "
                            .db_escape($_SESSION['wa_current_user']->loginname).",
                            now() )";
		}

		db_query($sql, "Old order Cannot be Inserted");
            } /* inserted line items into transport booking details */
        // Prabha added this code to update transport_order_stops
        
        // Prabha added this code to update transport order stop details
        $id_tokeep = array();
	foreach ($order->loadstop_line_items as $line) {
		array_push($id_tokeep , $line->id);
	}
	$id_list = implode(', ', $id_tokeep);
	
            $sql = "DELETE FROM ".TB_PREF."transport_order_stops WHERE order_no =" . db_escape($order_no) . " AND trans_type=".$order->trans_type;
            $sql .= " AND id NOT IN ($id_list)";

            db_query($sql, "Old transport_consignor_details Cannot be Deleted");
            foreach ($order->loadstop_line_items as $line)
            {
		if($line->id) {
			$sql = "UPDATE ".TB_PREF."transport_order_stops 
						SET loc_code = ".$line->loc_code . ", 
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
		 (id, order_no, trans_type, loc_code,  contact,stop_code, address,stop_date,stop_time,
                 created_by,created_date)
		 VALUES (";
		$sql .= db_escape($line->id ? $line->id : 0) . ","
		  .$order_no . ",".$order->trans_type.","
		  .$line->loc_code . ","
		  .db_escape($line->contact) . ", "
		  .db_escape($line->address) . ", "
                  .db_escape(date2sql($line->date)) . ", "      
                  .db_escape($line->time) . ", "
                  .db_escape($_SESSION['wa_current_user']->loginname).",
                   now() )";
		}

		db_query($sql, "Old order Cannot be Inserted");
	}
        
        // Prabha added this code to update transport order payment deposits details
            $id_tokeep = array();
            foreach ($order->gl_payment_items as $line) {
		array_push($id_tokeep , $line->id);
            }

            $id_list = implode(', ', $id_tokeep);
            $sql = "DELETE FROM ".TB_PREF."trans_order_payments_deposits WHERE order_no =" . db_escape($order_no) . " AND trans_type=".$order->trans_type;
            $sql .= " AND id NOT IN ($id_list) and type = 12";

            db_query($sql, "Old transport_consignor_details Cannot be Deleted");
        
            foreach ($order->gl_payment_items as $line)
            {
                    
		if($line->id) {
			$sql = "UPDATE ".TB_PREF."trans_order_payments_deposits 
						SET 
                                                type = 12,
                                                entity_type = ".$line->entity_type . ", 
                                                consignor_no = ".$line->consignor_no . ", 
                                                branch_code = ".$line->branch_code . ", 
                                                driver_code = ".$line->driver_no . ", 
                                                account_code = ".$line->code_id . ", 
                                                amount = ".$line->amount . ",
                                                memo = ".db_escape($line->line_memo) ."
						WHERE id = {$line->id}";
		}
		else {
		$sql = "INSERT INTO ".TB_PREF."trans_order_payments_deposits
		 (id, order_no, trans_type, type,
                  entity_type,consignor_no,branch_code,driver_code,
                 account_code,amount,memo)
		 VALUES (";
		$sql .= db_escape($line->id ? $line->id : 0) . ","
		  .$order_no . ",".$order->trans_type.",12,".
                 $line->entity_type.", ".
                 $line->consignor_no.", ".
                 $line->branch_code.", ".
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
	
            $sql = "DELETE FROM ".TB_PREF."trans_order_payments_deposits WHERE order_no =" . db_escape($order_no) . " AND trans_type=".$order->trans_type;
            $sql .= " AND id NOT IN ($id_list) and type = 10";

            db_query($sql, "Old transport_consignor_details Cannot be Deleted");
        foreach ($order->gl_deposit_items as $line)
	{
		if($line->id) {
			$sql = "UPDATE ".TB_PREF."trans_order_payments_deposits 
						SET 
                                                type = 10,
                                                entity_type = ".$line->entity_type . ", 
                                                consignor_no = ".$line->consignor_no . ", 
                                                branch_code = ".$line->branch_code . ", 
                                                driver_code = ".$line->driver_no . ", 
                                                account_code = ".$line->code_id . ", 
                                                amount = ".$line->amount . ",
                                                 memo = ".db_escape($line->line_memo) ."
						WHERE id = {$line->id}";
		}
		else {
		$sql = "INSERT INTO ".TB_PREF."trans_order_payments_deposits
		 (id, order_no, trans_type, type,
                  entity_type,consignor_no,branch_code,driver_code,
                 account_code,amount,memo)
		 VALUES (";
		$sql .= db_escape($line->id ? $line->id : 0) . ","
		  .$order_no . ",".$order->trans_type.",10,".
                  $line->entity_type.", ".
                  $line->consignor_no.", ".
                  $line->branch_code.", ".
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
	  consignor.name as consignor_name, 
	  consignor.curr_code as consignor_currency, 
	  consignor.address as consignor_address, 
	   loc.location_name, 
	   locto.location_name as location_name_to,
	   consignor.discount as consignor_discount, 
	   cons_ord.branch_code as branch_code,
           cons_ord.address, 
	   stype.transport_type, 
	   stype.id AS transport_type_id,
           stype.tax_included, 
	   stype.factor, 
 	   ship.shipper_name, 
           tax_group.name AS tax_group_name , 
	   tax_group.id AS tax_group_id, 
	   consignor.tax_id
	
	FROM ".TB_PREF."transport_orders sorder LEFT JOIN ".TB_PREF."shippers ship ON  ship.shipper_id = sorder.ship_via,"
	  .TB_PREF."consignors_master consignor,"
	  .TB_PREF."transport_types stype, "
	  .TB_PREF."tax_groups tax_group, "
	  .TB_PREF."consignor_branch branch,"
	  .TB_PREF."locations loc," 
	  .TB_PREF."locations locto, "
	  .TB_PREF."transport_consignor_details cons_ord
	WHERE sorder.order_type=stype.id
		AND locto.loc_code = sorder.Location_to
		AND branch.tax_group_id = tax_group.id
			
		AND loc.loc_code = sorder.from_stk_loc
		AND sorder.trans_type = " . db_escape($trans_type) ."
		AND sorder.order_no = " . db_escape($order_no ).
               "AND sorder.order_no =  cons_ord.order_no 
                AND sorder.trans_type = cons_ord.trans_type
                AND cons_ord.consignor_no = consignor.consignor_no
                AND cons_ord.branch_code = branch.branch_code ";

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
	$sql = "SELECT id, consignor_no, branch_code,tin_no,address 
			FROM ".TB_PREF."transport_consignor_details
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
	$sql = "SELECT id, loc_code, contact,address,stop_code,stop_date,stop_time
			FROM ".TB_PREF."transport_order_stops
	WHERE  order_no =" . db_escape($order_no) 
		." AND trans_type = " . db_escape($trans_type) . " ORDER BY id";

	return db_query($sql, "Retreive order stops Items");
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
	$order->trans_type = $myrow['trans_type'];
	$order->so_type =  $myrow["type"];
	$order->trans_no = array($order_no=> $myrow["version"]);
	$order->set_location($myrow["from_stk_loc"], $myrow["location_name"]);
	$order->driver_ref =  $myrow["driver_ref"];
	$order->set_delivery($myrow["deliver_to"],$myrow["delivery_address"], $myrow["freight_cost"]);
	$order->phone = $myrow["contact_phone"];
	$order->consignor_ref = $myrow["consignor_ref"];
	$order->goods_bill_no = $myrow["goods_bill_no"];
	$order->Location_to = $myrow["Location_to"];
	$order->location_name_to = $myrow["location_name_to"];
	$order->transport_type =$myrow["order_type"];
	$order->payment_by = $myrow["payment_by"];
	$order->service_tax_by =$myrow["service_tax_by"];
	$order->add_service_tax =$myrow["add_service_tax"];
	$order->phone=$myrow["contact_phone"];
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
			$order->add_to_consignor_cart($line_no,$myrow["consignor_no"],"",$myrow["branch_code"],"",$myrow["tin_no"],
				$myrow["address"], $myrow["id"] );
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
			$order->add_load_stop($line_no,$myrow["loc_code"],$myrow["stop_code"],$myrow["contact"],
				$myrow["address"], "",$myrow["stop_date"],$myrow["stop_time"],$myrow["id"] );
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
	$order->phone = $myrow["contact_phone"];
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
	$order->phone=$myrow["contact_phone"];
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
			$order->add_to_consignor_cart($line_no,$myrow["consignor_no"],"",$myrow["branch_code"],"",$myrow["tin_no"],
				$myrow["address"], $myrow["id"] );
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
			$order->add_load_stop($line_no,$myrow["loc_code"],$myrow["stop_code"],$myrow["contact"],
				$myrow["address"], "",$myrow["stop_date"],$myrow["stop_time"],$myrow["id"] );
		$line_no++;
		}
	}
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
                                    $myrow["branch_code"],
                                    $myrow["driver_code"],
                                    $myrow["account_code"],$myrow["amount"],$myrow["memo"],"",$myrow["id"]);
                            $dep_line_no++;
                        }
                        else
                        {
                            $order->add_payment($pay_line_no,
                                     $myrow["entity_type"],
                                    $myrow["consignor_no"],
                                    $myrow["branch_code"],
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
        $order->trans_type = 33;
	$order->so_type =  $myrow["type"];
	$order->trans_no = array($order_no=> $myrow["version"]);

	$order->set_consignor($myrow["consignor_no"], $myrow["consignor_name"],
	  $myrow["consignor_currency"], $myrow["consignor_discount"], $myrow["payment_terms"]);

	$order->set_branch($myrow["branch_code"], $myrow["tax_group_id"],
	  $myrow["tax_group_name"],$myrow["consignor_tin_no"],$myrow["address"]);
 $order->consignee_id=$myrow["consignee_no"];
 if($myrow["consignee_no"]){
 
	$results = get_consignee_to_order($myrow["consignee_no"]);
	$order->consignee_name=$results["consignee_name"];
 }
 $order->driver_id=$myrow["driver_no"];
 
 $order->vehicle_id=$myrow["vehicle_no"];

	$order->set_consignee_branch($myrow["consignee_branch_code"], $myrow["contact_phone"],$myrow["contact_email"]);
$order->consignee_tin_no = $myrow["consignee_tin_no"];
	$order->set_transport_type($myrow["transport_type_id"], $myrow["transport_type"], 
	    $myrow["tax_included"], $myrow["factor"]); // no default price calculations on edit
$order->phone=$myrow["contact_phone"];
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
			$order->add_to_consignor_cart($line_no,$myrow["consignor_no"],"",$myrow["branch_code"],"",$myrow["tin_no"],
				$myrow["address"], $myrow["id"] );
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
			$order->add_load_stop($line_no,$myrow["loc_code"],$myrow["stop_code"],$myrow["contact"],
				$myrow["address"], "",$myrow["stop_date"],$myrow["stop_time"],$myrow["id"] );
		$line_no++;
		}
	}

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
		$line_no++;
		}
	}
//---------------------------------------------------------------------------------------        
//print_r($order);
	return true;
}
function get_vehicle_desc($vehicle_no)
{
	$sql = "SELECT stocks.description as vehicle_number_plate FROM ".TB_PREF."vehicles_master stocks WHERE stocks.stock_id = " . db_escape($vehicle_no);

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
		  consignor.address, "
		  .TB_PREF."credit_status.dissallow_invoices, 
		  consignor.transport_type AS transporttype,
		  consignor.dimension_id,
		  consignor.dimension2_id,
		  stype.transport_type,
		  stype.tax_included,
		  stype.factor,
		  consignor.curr_code,
		  consignor.discount,
		  consignor.payment_terms,
		  consignor.pymt_discount,
		  consignor.credit_limit - Sum(IFNULL(IF(trans.type=11 OR trans.type=12 OR trans.type=2,
			-1, 1) * (ov_amount + ov_gst + ov_freight + ov_freight_tax + ov_discount),0)) as cur_credit
		FROM ".TB_PREF."consignors_master consignor
		  LEFT JOIN ".TB_PREF."consignor_trans trans ON trans.type!=".ST_CONSIGNORDELIVERY." AND trans.consignor_no = consignor.consignor_no,"
		  .TB_PREF."credit_status, "
		  .TB_PREF."transport_types stype
		WHERE consignor.transport_type=stype.id
			AND consignor.credit_status=".TB_PREF."credit_status.id
			AND consignor.consignor_no = ".db_escape($consignor_id)
		." GROUP by consignor.consignor_no";

	$result =db_query($sql,"Consignor Record Retreive");
	return 	db_fetch($result);
}

function get_branch_to_order($consignor_id, $branch_id) {

    	// the branch was also selected from the consignor selection so default the delivery details from the consignor branches table consignor_branch. The order process will ask for branch details later anyway
	 	$sql = "SELECT ".TB_PREF."consignor_branch.br_name, "
			.TB_PREF."consignor_branch.br_address, "
			.TB_PREF."consignor_branch.br_post_address, "
			.TB_PREF."consignor_branch.tin_no, "
			." default_location, location_name, default_ship_via, "
			.TB_PREF."tax_groups.name AS tax_group_name, "
			.TB_PREF."tax_groups.id AS tax_group_id
			FROM ".TB_PREF."consignor_branch, "
			  .TB_PREF."tax_groups, "
			  .TB_PREF."locations
			WHERE ".TB_PREF."consignor_branch.tax_group_id = ".TB_PREF."tax_groups.id
				AND ".TB_PREF."locations.loc_code=default_location
				AND ".TB_PREF."consignor_branch.branch_code=".db_escape($branch_id)."
				AND ".TB_PREF."consignor_branch.consignor_no = ".db_escape($consignor_id);

  	    return db_query($sql,"Consignor Branch Record Retreive");
}

function get_consignee_to_order($consignee_id) {

	// Now check to ensure this account is not on hold */
	$sql = "SELECT consignee.name as consignee_name, 
		  consignee.address as address, "
		  .TB_PREF."credit_status.dissallow_invoices, 
		 
		 
		  stype.tax_included,
		  stype.factor,
		  consignee.curr_code,
		  consignee.discount,
		  consignee.payment_terms,
		  consignee.pymt_discount,
		  consignee.credit_limit - Sum(IFNULL(IF(trans.type=11 OR trans.type=12 OR trans.type=2,
			-1, 1) * (ov_amount + ov_gst + ov_freight + ov_freight_tax + ov_discount),0)) as cur_credit
		FROM ".TB_PREF."consignors_master consignee
		  LEFT JOIN ".TB_PREF."consignee_trans trans ON trans.type!=".ST_CONSIGNORDELIVERY." AND trans.consignee_no = consignee.consignor_no,"
		  .TB_PREF."credit_status, "
		  .TB_PREF."transport_types stype
		WHERE  consignee.consignor_no = ".db_escape($consignee_id)
		." GROUP by consignee.consignor_no";

	$result =db_query($sql,"Consignor Record Retreive");
	
	return 	db_fetch($result);
}

function get_consignee_branch_to_order($consignee_id, $consignee_branch_id) {

    	// the consignee_branch was also selected from the consignee selection so default the delivery details from the consignee consignee_branches table consignee_branch. The order process will ask for consignee_branch details later anyway
	 	$sql = "SELECT ".TB_PREF."consignor_branch.br_name, "
			.TB_PREF."consignor_branch.br_address, "
			.TB_PREF."consignor_branch.br_post_address, "
			.TB_PREF."consignor_branch.tin_no
			FROM ".TB_PREF."consignor_branch
			  
			WHERE ".TB_PREF."consignor_branch.branch_code=".db_escape($consignee_branch_id)."
				AND ".TB_PREF."consignor_branch.consignor_no = ".db_escape($consignee_id);

  	    return db_query($sql,"Consignor Branch Record Retreive");
}

function get_sql_for_transport_orders_view($selected_consignor,$trans_type, 
        $trans_no, $filter, 
	$stock_item=null, $from='', $to='', $ref='', $location='', $consignor_id=ALL_TEXT, $Location_to='')
{
    
//if ($trans_type == ST_TRANSPORTORDER)
//{
//    
//	$sql = "SELECT 
//			sorder.order_no,
//			sorder.reference,
//			consignor.name as consignor_name,
//			branch.br_name,
//			
//			".($filter=='InvoiceTemplates' 
//				|| $filter=='DeliveryTemplates' ?
//			 "sorder.comments, " : "sorder.consignor_ref, ")
//			."sorder.ord_date,
//			sorder.delivery_date,
//			sorder.from_stk_loc,
//			sorder.Location_to,
//			Sum(line.unit_price*line.quantity*(1-line.discount_percent))+freight_cost AS OrderValue,
//			sorder.type,
//			consignor.curr_code,
//			
//			Sum(line.qty_sent) AS TotDelivered,
//			Sum(line.quantity) AS TotQuantity
//		FROM ".TB_PREF."transport_orders as sorder, "
//			.TB_PREF."transport_order_details as line,"
//			.TB_PREF."consignors_master as consignor, "
//			
//			.TB_PREF."consignor_branch as branch
//			
//			WHERE sorder.order_no = line.order_no
//			AND sorder.trans_type = line.trans_type
//			AND sorder.trans_type = ".db_escape($trans_type)."
//			AND sorder.consignor_no = consignor.consignor_no
//		
//			AND sorder.branch_code = branch.branch_code
//			AND consignor.consignor_no = branch.consignor_no
//		";
//
//	if (isset($trans_no) && $trans_no != "")
//	{
//		// search orders with number like 
//		$number_like = "%".$trans_no;
//		$sql .= " AND sorder.order_no LIKE ".db_escape($number_like);
////				." GROUP BY sorder.order_no";
//	}
//	elseif ($ref != "")
//	{
//		// search orders with reference like 
//		$number_like = "%".$ref."%";
//		$sql .= " AND sorder.reference LIKE ".db_escape($number_like);
////				." GROUP BY sorder.order_no";
//	}
//	else	// ... or select inquiry constraints
//	{
//		if ($filter!='DeliveryTemplates' && $filter!='InvoiceTemplates' && $filter!='OutstandingOnly')
//		{
//			$date_after = date2sql($from);
//			$date_before = date2sql($to);
//
//			$sql .=  " AND sorder.ord_date >= '$date_after'"
//					." AND sorder.ord_date <= '$date_before'";
//		}
//	}
//		if ($trans_type == ST_TRANSPORTQUOTE || $trans_type == ST_TRANSPORTBOOKING && !check_value('show_all'))
//			$sql .= " AND sorder.delivery_date >= '".date2sql(Today())."' AND line.qty_sent=0"; // show only outstanding, not realized quotes
//
//		if ($selected_consignor != -1)
//			$sql .= " AND sorder.consignor_no=".db_escape($selected_consignor);
//		
//
//		if (isset($stock_item))
//			$sql .= " AND line.stk_code=".db_escape($stock_item);
//
//		if ($location)
//			$sql .= " AND sorder.from_stk_loc = ".db_escape($location);
//if ($Location_to)
//			$sql .= " AND sorder.Location_to = ".db_escape($Location_to);
//		if ($filter=='OutstandingOnly')
//			$sql .= " AND line.qty_sent < line.quantity";
//
//		elseif ($filter=='InvoiceTemplates' || $filter=='DeliveryTemplates')
//			$sql .= " AND sorder.type=1";
//			
//		//Chaiatanya : New Filter
//		if ($consignor_id != ALL_TEXT)
//			$sql .= " AND sorder.consignor_no = ".db_escape($consignor_id);		
//			
//
//		$sql .= " GROUP BY sorder.order_no,
//					sorder.consignor_no,
//					sorder.branch_code,
//					sorder.consignor_ref,
//					
//					sorder.ord_date
//					";
//}
    
if ($trans_type == ST_TRANSPORTORDER)
{
    $trans_type = 33;
    
	$sql = "SELECT 
			sorder.order_no,
			sorder.reference,
			consignor.name as consignor_name,
			branch.br_name,
			
			".($filter=='InvoiceTemplates' 
				|| $filter=='DeliveryTemplates' ?
			 "sorder.comments, " : "consignor.consignor_ref, ")
			."sorder.ord_date,
			sorder.delivery_date,
			sorder.from_stk_loc,
			sorder.Location_to,
			Sum(line.unit_price*line.quantity*(1-line.discount_percent))+freight_cost AS OrderValue,
			sorder.type,
			consignor.curr_code,
			
			Sum(line.qty_sent) AS TotDelivered,
			Sum(line.quantity) AS TotQuantity,
                        sorder.total_payment, sorder.total_deposit
		FROM ".TB_PREF."transport_orders as sorder, "
			.TB_PREF."transport_order_details as line,"
			.TB_PREF."consignors_master as consignor, "
			.TB_PREF."consignor_branch as branch , "
                        .TB_PREF."transport_consignor_details as cons_ord
			
			WHERE sorder.order_no = line.order_no
			AND sorder.trans_type = line.trans_type
                        AND cons_ord.order_no = sorder.order_no
                        AND cons_ord.trans_type = sorder.trans_type
			AND sorder.trans_type = ".db_escape($trans_type)."
			AND cons_ord.consignor_no = consignor.consignor_no
			AND cons_ord.branch_code = branch.branch_code
			AND consignor.consignor_no = branch.consignor_no
		";

	if (isset($trans_no) && $trans_no != "")
	{
		// search orders with number like 
		$number_like = "%".$trans_no;
		$sql .= " AND sorder.order_no LIKE ".db_escape($number_like);
//				." GROUP BY sorder.order_no";
	}
	elseif ($ref != "")
	{
		// search orders with reference like 
		$number_like = "%".$ref."%";
		$sql .= " AND sorder.reference LIKE ".db_escape($number_like);
//				." GROUP BY sorder.order_no";
	}
	else	// ... or select inquiry constraints
	{
		if ($filter!='DeliveryTemplates' && $filter!='InvoiceTemplates' && $filter!='OutstandingOnly')
		{
			$date_after = date2sql($from);
			$date_before = date2sql($to);

			$sql .=  " AND sorder.ord_date >= '$date_after'"
					." AND sorder.ord_date <= '$date_before'";
		}
	}
		if ($trans_type == ST_TRANSPORTQUOTE || $trans_type == ST_TRANSPORTBOOKING && !check_value('show_all'))
			$sql .= " AND sorder.delivery_date >= '".date2sql(Today())."' AND line.qty_sent=0"; // show only outstanding, not realized quotes

		if ($selected_consignor != -1)
			$sql .= " AND cons_ord.consignor_no=".db_escape($selected_consignor);
		

		if (isset($stock_item))
			$sql .= " AND line.stk_code=".db_escape($stock_item);

		if ($location)
			$sql .= " AND sorder.from_stk_loc = ".db_escape($location);
if ($Location_to)
			$sql .= " AND sorder.Location_to = ".db_escape($Location_to);
		if ($filter=='OutstandingOnly')
			$sql .= " AND line.qty_sent < line.quantity";

		elseif ($filter=='InvoiceTemplates' || $filter=='DeliveryTemplates')
			$sql .= " AND sorder.type=1";
			
		//Chaiatanya : New Filter
		if ($consignor_id != ALL_TEXT)
			$sql .= " AND cons_ord.consignor_no = ".db_escape($consignor_id);		
			

		$sql .= " GROUP BY sorder.order_no,
					cons_ord.consignor_no,
					cons_ord.branch_code,
					sorder.ord_date
					";
          
}    
    
elseif($trans_type == ST_TRANSPORTQUOTE)
{

	$sql = "SELECT 
			sorder.order_no,
			sorder.reference,
			
			".($filter=='InvoiceTemplates' 
				|| $filter=='DeliveryTemplates' ?
			 "sorder.comments, " : "sorder.consignor_ref, ")
			."sorder.ord_date,
			sorder.delivery_date,
			sorder.from_stk_loc,
			sorder.Location_to,
			sorder.loaded_from,
			sorder.contact_phone
		FROM ".TB_PREF."transport_orders as sorder
			
			WHERE sorder.trans_type = ".db_escape($trans_type)."	
		";

	if (isset($trans_no) && $trans_no != "")
	{
		// search orders with number like 
		$number_like = "%".$trans_no;
		$sql .= " AND sorder.order_no LIKE ".db_escape($number_like);
//				." GROUP BY sorder.order_no";
	}
	elseif ($ref != "")
	{
		// search orders with reference like 
		$number_like = "%".$ref."%";
		$sql .= " AND sorder.reference LIKE ".db_escape($number_like);
//				." GROUP BY sorder.order_no";
	}
	else	// ... or select inquiry constraints
	{
		if ($filter!='DeliveryTemplates' && $filter!='InvoiceTemplates' && $filter!='OutstandingOnly')
		{
			$date_after = date2sql($from);
			$date_before = date2sql($to);

			$sql .=  " AND sorder.ord_date >= '$date_after'"
					." AND sorder.ord_date <= '$date_before'";
		}
	}
		if ($trans_type == ST_TRANSPORTQUOTE || $trans_type == ST_TRANSPORTBOOKING && !check_value('show_all'))
			$sql .= " AND sorder.delivery_date >= '".date2sql(Today())."'"; // show only outstanding, not realized quotes

		

				if ($location)
			$sql .= " AND sorder.from_stk_loc = ".db_escape($location);
		if ($Location_to)
			$sql .= " AND sorder.Location_to = ".db_escape($Location_to);
		

		elseif ($filter=='InvoiceTemplates' || $filter=='DeliveryTemplates')
			$sql .= " AND sorder.type=1";
		
			

		$sql .= " GROUP BY sorder.order_no,
					sorder.consignor_ref,
					sorder.ord_date
					";
}
elseif($trans_type == ST_TRANSPORTBOOKING)
{

	$sql = "SELECT 
			sorder.order_no,
			sorder.reference,
			
			".($filter=='InvoiceTemplates' 
				|| $filter=='DeliveryTemplates' ?
			 "sorder.comments, " : "sorder.consignor_ref, ")
			."sorder.ord_date,
			sorder.delivery_date,
			sorder.from_stk_loc,
			sorder.Location_to,
			sorder.contact_phone,
                        load1.load_status_name,
                        sorder.total_goods_value,
                        sorder.total,
                        abs(sorder.total_payment), 
                        sorder.total_deposit
		FROM ".TB_PREF."transport_orders as sorder left outer join ".TB_PREF."load_status load1 on
                                sorder.load_status_code = load1.load_status_code
			
			WHERE sorder.trans_type = ".db_escape($trans_type)."	
		";

	if (isset($trans_no) && $trans_no != "")
	{
		// search orders with number like 
		$number_like = "%".$trans_no;
		$sql .= " AND sorder.order_no LIKE ".db_escape($number_like);
//				." GROUP BY sorder.order_no";
	}
	elseif ($ref != "")
	{
		// search orders with reference like 
		$number_like = "%".$ref."%";
		$sql .= " AND sorder.reference LIKE ".db_escape($number_like);
//				." GROUP BY sorder.order_no";
	}
	else	// ... or select inquiry constraints
	{
		if ($filter!='DeliveryTemplates' && $filter!='InvoiceTemplates' && $filter!='OutstandingOnly')
		{
			$date_after = date2sql($from);
			$date_before = date2sql($to);

			$sql .=  " AND sorder.ord_date >= '$date_after'"
					." AND sorder.ord_date <= '$date_before'";
		}
	}
		if ($trans_type == ST_TRANSPORTQUOTE || $trans_type == ST_TRANSPORTBOOKING && !check_value('show_all'))
			$sql .= " AND sorder.delivery_date >= '".date2sql(Today())."'"; // show only outstanding, not realized quotes

		

		

		if ($location)
			$sql .= " AND sorder.from_stk_loc = ".db_escape($location);
		if ($Location_to)
			$sql .= " AND sorder.Location_to = ".db_escape($Location_to);
		

		elseif ($filter=='InvoiceTemplates' || $filter=='DeliveryTemplates')
			$sql .= " AND sorder.type=1";
			
	
			

		$sql .= " GROUP BY sorder.order_no,
					sorder.consignor_ref,
					sorder.ord_date
					";
}
//display_error("sql : ".$sql);
	return $sql;
}
?>

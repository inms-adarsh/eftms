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
// if ($writeoff_acc==0) return goods into $cart->Location
// if src_docs!=0 => credit invoice else credit note
//
function write_credit_note(&$credit_note, $write_off_acc)
{
	global $Refs;

	if (is_array($credit_note->src_docs))
	{
		$docs = array_keys($credit_note->src_docs);
		$credit_invoice = reset($docs);
	}
	else
		$credit_invoice = $credit_note->src_docs;

	$credit_date = $credit_note->document_date;
	$tax_group_id = $credit_note->tax_group_id;

	$trans_no = $credit_note->trans_no;
	if (is_array($trans_no)) {
		$trans_no = key($trans_no);
	}

	$credit_type = $write_off_acc == 0 ? 'Return' : 'WriteOff';

	begin_transaction();
	hook_db_prewrite($credit_note, ST_CONSIGNORCREDIT);

	$company_data = get_company_prefs();
	$branch_data = get_branch_accounts($credit_note->Branch);

	add_new_exchange_rate(get_consignor_currency($credit_note->consignor_id), $credit_date, $credit_note->ex_rate);

	$credit_note_total = $credit_note->get_items_total_dispatch();
	$freight_tax = $credit_note->get_shipping_tax();

	$taxes = $credit_note->get_taxes();

	$tax_total = 0;
	foreach ($taxes as $taxitem) {
		$taxitem['Value'] =  round2($taxitem['Value'], user_price_dec());
		$tax_total += $taxitem['Value'];
	}

	if ($credit_note->tax_included == 0) {
	    $items_added_tax = $tax_total-$freight_tax;
	    $freight_added_tax = $freight_tax;
	} else {
	    $items_added_tax = 0;
	    $freight_added_tax = 0;
	}
	// 2006-06-14. If the Consignor Branch AR Account is set to a Bank Account,
	// the transaction will be settled at once.
	if (is_bank_account($company_data["consignors_act"]))
		$alloc = $credit_note_total + $items_added_tax + $credit_note->freight_cost + $freight_added_tax;
	else
		$alloc = 0;

//	$transport_order=$invoice->order_no;	//?
//    if (is_array($transport_order)) $transport_order = $transport_order[0]; //?
	if (!isset($credit_note->order_no))
		$credit_note->order_no = 0;

	/*Now insert the Credit Note into the consignor_trans table with the allocations as calculated above*/
	// all amounts in consignor's currency
	$credit_no = write_consignor_trans(ST_CONSIGNORCREDIT, $trans_no, $credit_note->consignor_id,
		$credit_note->Branch, $credit_date, $credit_note->reference,
		$credit_note_total, 0, $items_added_tax,
		$credit_note->freight_cost, $freight_added_tax,
		$credit_note->transport_type, $credit_note->order_no, $credit_note->ship_via,
		null, $alloc, 0, $credit_note->dimension_id, $credit_note->dimension2_id,
		$credit_note->payment); 
		// 2008-06-14 extra $alloc, 2008-11-12 dimension_id Joe Hunt

	if ($trans_no==0) {
		$credit_note->trans_no = array($credit_no=>0);
	} else {
		delete_comments(ST_CONSIGNORCREDIT, $credit_no);
		void_consignor_allocations(ST_CONSIGNORCREDIT, $credit_no, $credit_date);
		void_gl_trans(ST_CONSIGNORCREDIT, $credit_no, true);
		void_stock_move(ST_CONSIGNORCREDIT, $credit_no);
		void_trans_tax_details(ST_CONSIGNORCREDIT, $credit_no);
	}
	if ($credit_invoice) {
		update_consignor_trans_version(get_parent_type(ST_CONSIGNORCREDIT), $credit_note->src_docs );

		$total = $credit_note_total + $credit_note->freight_cost + $items_added_tax 
			+ $freight_added_tax;

		if (!credit_transport_invoice_allocate($credit_invoice, $credit_no, $total, $credit_date))
			return false;
	}

	$total = 0;
	foreach ($credit_note->line_items as $credit_line) {

		if ($credit_invoice && $credit_line->qty_dispatched!=$credit_line->qty_old ) {
			update_parent_line(ST_CONSIGNORCREDIT, $credit_line->src_id,($credit_line->qty_dispatched
					-$credit_line->qty_old));
		}

		$line_taxfree_price = get_tax_free_price_for_item($credit_line->stock_id, $credit_line->price,
		  0, $credit_note->tax_included, $credit_note->tax_group_array);

		$line_tax = get_full_price_for_item($credit_line->stock_id, $credit_line->price,
		  0, $credit_note->tax_included, $credit_note->tax_group_array) - $line_taxfree_price;

		write_consignor_trans_detail_item(ST_CONSIGNORCREDIT, $credit_no, $credit_line->stock_id,
			$credit_line->item_description, $credit_line->qty_dispatched,$credit_line->to_units,
			$credit_line->line_price(), $line_tax, $credit_line->discount_percent,
			$credit_line->standard_cost, $credit_line->src_id, $trans_no==0 ? 0:  $credit_line->id);

		add_credit_movements_item($credit_note, $credit_line,
			$credit_type, $line_taxfree_price+$line_tax, $credit_invoice);

		$total += add_gl_trans_credit_costs($credit_note, $credit_line, $credit_no,
		    $credit_date, $credit_type, $write_off_acc, $branch_data);
	} /*end of credit_line loop */

	/*Post credit note transaction to GL credit consignors,
	debit freight re-charged and debit transport */

	if (($credit_note_total + $credit_note->freight_cost) != 0) {

		$total += add_gl_trans_consignor(ST_CONSIGNORCREDIT, $credit_no, $credit_date, $company_data["consignors_act"], 0, 0,
			-($credit_note_total + $credit_note->freight_cost + $items_added_tax + $freight_added_tax),
			$credit_note->consignor_id,
			"The total consignor GL posting for the credit note could not be inserted");
	}

	if ($credit_note->freight_cost != 0) {
		$total += add_gl_trans_consignor(ST_CONSIGNORCREDIT, $credit_no, $credit_date, $company_data["freight_act"], 0, 0,
			$credit_note->get_tax_free_shipping(), $credit_note->consignor_id,
			"The freight GL posting for this credit note could not be inserted");
	}

	foreach ($taxes as $taxitem) {
		if ($taxitem['Net'] != 0) {

			$ex_rate = get_exchange_rate_from_home_currency(get_consignor_currency($credit_note->consignor_id), $credit_note->document_date);
			add_trans_tax_details(ST_CONSIGNORCREDIT, $credit_no, $taxitem['tax_type_id'],
				$taxitem['rate'], $credit_note->tax_included, $taxitem['Value'],
				$taxitem['Net'], $ex_rate,
				$credit_note->document_date, $credit_note->reference);

			$total += add_gl_trans_consignor(ST_CONSIGNORCREDIT, $credit_no, $credit_date, $taxitem['transport_gl_code'], 0, 0,
				$taxitem['Value'], $credit_note->consignor_id,
				"A tax GL posting for this credit note could not be inserted");
		}
	}
	/*Post a balance post if $total != 0 */
	add_gl_balance(ST_CONSIGNORCREDIT, $credit_no, $credit_date, -$total, PT_CONSIGNOR, $credit_note->consignor_id);	

	add_comments(ST_CONSIGNORCREDIT, $credit_no, $credit_date, $credit_note->Comments);

	if ($trans_no == 0) {
		$Refs->save(ST_CONSIGNORCREDIT, $credit_no, $credit_note->reference);
	}
	hook_db_postwrite($credit_note, ST_CONSIGNORCREDIT);
	commit_transaction();

	return $credit_no;
}

//----------------------------------------------------------------------------------------
// Insert a stock movement coming back in to show the credit note and
// 	a reversing stock movement to show the write off
//

function add_credit_movements_item(&$credit_note, &$credit_line,
	$credit_type, $price, $credited_invoice=0)
{

    //Chaitanya : Stamp current cost in stock moves $credit_line does not fetch cost
    $curr_std_cost = get_standard_cost($credit_line->stock_id);

	if ($credit_type == "Return") {

		$reference = "Return ";
		if ($credited_invoice) {
			$reference .= "Ex Inv: " . $credited_invoice;
		}

	} elseif ($credit_type == "WriteOff") {

		$reference = "WriteOff ";
		if ($credited_invoice)
			$reference .= "Ex Inv: " . $credited_invoice;

   	 	add_stock_move_consignor(ST_CONSIGNORCREDIT,  $credit_line->stock_id,
        	key($credit_note->trans_no), $credit_note->Location,
        	$credit_note->document_date, $reference, -$credit_line->qty_dispatched,
        	$curr_std_cost,  0, $price,
        	$credit_line->discount_percent);

	}
    add_stock_move_consignor(ST_CONSIGNORCREDIT,  $credit_line->stock_id,
        key($credit_note->trans_no), $credit_note->Location,
        $credit_note->document_date, $reference, $credit_line->qty_dispatched,
        $curr_std_cost,  0, $price,
        $credit_line->discount_percent);

}

//----------------------------------------------------------------------------------------

function add_gl_trans_credit_costs($order, $order_line, $credit_no, $date_,
	$credit_type, $write_off_gl_code, &$branch_data)
{
	$stock_gl_codes = get_stock_gl_code($order_line->stock_id);
	$company_data = get_company_prefs();
	$consignor = get_consignor($order->consignor_id);
	// 2008-08-01. If there is a Consignor Dimension, then override with this,
	// else take the Item Dimension (if any)
	$dim = ($order->dimension_id != $consignor['dimension_id'] ? $order->dimension_id : 
		($consignor['dimension_id'] != 0 ? $consignor["dimension_id"] : $stock_gl_codes["dimension_id"]));
	$dim2 = ($order->dimension2_id != $consignor['dimension2_id'] ? $order->dimension2_id : 
		($consignor['dimension2_id'] != 0 ? $consignor["dimension2_id"] : $stock_gl_codes["dimension2_id"]));

	$total = 0;
	/* insert gl_trans to credit stock and debit cost of transport at standard cost*/
	$standard_cost = get_standard_cost($order_line->stock_id);
	if ($standard_cost != 0) {
		/*first the cost of transport entry*/

		$total += add_gl_trans_std_cost(ST_CONSIGNORCREDIT, $credit_no, $date_, $company_data["default_cogs_act"],
			$dim, $dim2, "", -($standard_cost * $order_line->qty_dispatched),
			PT_CONSIGNOR, $order->consignor_id,
			"The cost of transport GL posting could not be inserted");

		/*now the stock entry*/
		if ($credit_type == "WriteOff") {
			$stock_entry_account = $write_off_gl_code;
		} else {
			$stock_gl_code = get_stock_gl_code($order_line->stock_id);
			$stock_entry_account = $company_data["default_inventory_act"];
		}

		$total += add_gl_trans_std_cost(ST_CONSIGNORCREDIT, $credit_no, $date_, $stock_entry_account, 0, 0,
			"", ($standard_cost * $order_line->qty_dispatched),
			PT_CONSIGNOR, $order->consignor_id,
			"The stock side (or write off) of the cost of transport GL posting could not be inserted");

	} /* end of if GL and stock integrated and standard cost !=0 */

	if ($order_line->line_price() != 0) {

		$line_taxfree_price =
		get_tax_free_price_for_item($order_line->stock_id, $order_line->price,
		  0, $order->tax_included, $order->tax_group_array);

		$line_tax = get_full_price_for_item($order_line->stock_id, $order_line->price,
		  0, $order->tax_included, $order->tax_group_array) - $line_taxfree_price;


		//Post transport transaction to GL credit transport

		// 2008-06-14. If there is a Branch Transport Account, then override with this,
		// else take the Item Transport Account
		if ($branch_data['transport_account'] != "")
			$transport_account = $company_data["default_inv_transport_act"];
		else
			$transport_account = $company_data["default_inv_transport_act"];
		$total += add_gl_trans_consignor(ST_CONSIGNORCREDIT, $credit_no, $date_, $transport_account, $dim, $dim2,
			($line_taxfree_price * $order_line->qty_dispatched), $order->consignor_id,
			"The credit note GL posting could not be inserted");

		if ($order_line->discount_percent != 0) {

			$total += add_gl_trans_consignor(ST_CONSIGNORCREDIT, $credit_no, $date_, $company_data["default_transport_discount_act"],
				$dim, $dim2, -($line_taxfree_price * $order_line->qty_dispatched * $order_line->discount_percent),
				$order->consignor_id,
				"The credit note discount GL posting could not be inserted");

		} /*end of if discount !=0 */
	} /*if line_price!=0 */
	return $total;
}

?>
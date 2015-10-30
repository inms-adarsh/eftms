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
//	Add or update Transport Invoice
//
function write_transport_invoice(&$invoice)
{
	global $Refs;

	$trans_no = $invoice->trans_no;
	if (is_array($trans_no))
		$trans_no = key($trans_no);

	$date_ = $invoice->document_date;
	$charge_shipping =$invoice->freight_cost;

	begin_transaction();

	hook_db_prewrite($invoice, ST_TRANSPORTINVOICE);
	$company_data = get_company_prefs();

	$branch_data = get_branch_accounts($invoice->Branch);

	$consignor = get_consignor($invoice->consignor_id);

	add_new_exchange_rate($consignor['curr_code'], $date_, $invoice->ex_rate);

	// offer price values without freight costs
	$items_total = $invoice->get_items_total_dispatch();
	$freight_tax = $invoice->get_shipping_tax();

	update_consignor_trans_version(get_parent_type(ST_TRANSPORTINVOICE), $invoice->src_docs);

	$ov_gst = 0;
	$taxes = $invoice->get_taxes(); // all taxes with freight_tax

	foreach ($taxes as $taxitem) {
		$taxitem['Value'] =  round2($taxitem['Value'], user_price_dec());
		$ov_gst +=  $taxitem['Value'];
	}

	if($invoice->tax_included==0) {
	    $items_added_tax = $ov_gst-$freight_tax;
	    $freight_added_tax = $freight_tax;
	} else {
	    $items_added_tax = 0;
	    $freight_added_tax = 0;
	}

	/* Insert/update the consignor_trans */
	$transport_order = $invoice->order_no;
	if (is_array($transport_order))
			$transport_order = $transport_order[0]; // assume all crucial SO data are same for every delivery

 	if ($trans_no != 0) {
         delete_comments(ST_TRANSPORTINVOICE, $trans_no);
         void_gl_trans(ST_TRANSPORTINVOICE, $trans_no, true);
         void_consignor_allocations(ST_TRANSPORTINVOICE, $trans_no); // ?
         void_trans_tax_details(ST_TRANSPORTINVOICE, $trans_no);
    } 
    $invoice_no = write_consignor_trans(ST_TRANSPORTINVOICE, $trans_no, $invoice->consignor_id,
	$invoice->Branch, $date_, $invoice->reference, $items_total, 0,
	$items_added_tax, $invoice->freight_cost, $freight_added_tax,
	$invoice->transport_type, $transport_order, $invoice->ship_via, 
	$invoice->due_date, 0, 0, $invoice->dimension_id, 
	$invoice->dimension2_id, $invoice->payment); 
	// 2008-06-14 extra $alloc, 2008-11-12 added dimension_id Joe Hunt

	if ($trans_no == 0) {
		$invoice->trans_no = array($invoice_no=>0);
	}
	$total = 0;
	foreach ($invoice->line_items as $line_no => $invoice_line) {
		$qty = $invoice_line->qty_dispatched;
		$line_taxfree_price = get_tax_free_price_for_item($invoice_line->stock_id,
			$invoice_line->price * $qty, 0, $invoice->tax_included,
			$invoice->tax_group_array);

		$line_tax = get_full_price_for_item($invoice_line->stock_id,
			$invoice_line->price * $qty, 0, $invoice->tax_included,
			$invoice->tax_group_array) - $line_taxfree_price;

		write_consignor_trans_detail_item(ST_TRANSPORTINVOICE, $invoice_no, $invoice_line->stock_id,
			$invoice_line->item_description, $invoice_line->qty_dispatched,$invoice_line->to_units,
			$invoice_line->line_price(), $qty ? $line_tax/$qty : 0, $invoice_line->discount_percent,
			$invoice_line->standard_cost, $invoice_line->src_id,
			$trans_no ? $invoice_line->id : 0);

		// Update delivery items for the quantity invoiced
		if ($invoice_line->qty_old != $invoice_line->qty_dispatched)
			update_parent_line(ST_TRANSPORTINVOICE, $invoice_line->src_id, ($invoice_line->qty_dispatched-$invoice_line->qty_old));

		if ($invoice_line->qty_dispatched != 0) {
			$stock_gl_code = get_stock_gl_code($invoice_line->stock_id);

			if ($invoice_line->line_price() != 0) {
				//Post transport transaction to GL credit transport

				// 2008-06-14. If there is a Branch Transport Account, then override with this,
				// else take the Item Transport Account
				$transport_account = $company_data["default_inv_transport_act"];
				// 2008-08-01. If there is a Consignor Dimension, then override with this,
				// else take the Item Dimension (if any)
				$dim = ($invoice->dimension_id != $consignor['dimension_id'] ? $invoice->dimension_id : 
					($consignor['dimension_id'] != 0 ? $consignor["dimension_id"] : $stock_gl_code["dimension_id"]));
				$dim2 = ($invoice->dimension2_id != $consignor['dimension2_id'] ? $invoice->dimension2_id : 
					($consignor['dimension2_id'] != 0 ? $consignor["dimension2_id"] : $stock_gl_code["dimension2_id"]));
				$total += add_gl_trans_consignor(ST_TRANSPORTINVOICE, $invoice_no, $date_, $transport_account, $dim, $dim2,
					-$line_taxfree_price ,
					$invoice->consignor_id, "The transport price GL posting could not be inserted");

				if ($invoice_line->discount_percent != 0) {

					$total += add_gl_trans_consignor(ST_TRANSPORTINVOICE, $invoice_no, $date_,
						$company_data["default_transport_discount_act"], $dim, $dim2,
						($line_taxfree_price * $invoice_line->discount_percent),
						$invoice->consignor_id, "The transport discount GL posting could not be inserted");
				} /*end of if discount !=0 */
			}
		} /*quantity dispatched is more than 0 */
	} /*end of delivery_line loop */

	if (($items_total + $charge_shipping) != 0) {
	//echo $branch_data["receivables_account"];
		$total += add_gl_trans_consignor(ST_TRANSPORTINVOICE, $invoice_no, $date_, $company_data["consignors_act"], 0, 0,
			($items_total + $charge_shipping + $items_added_tax + $freight_added_tax),
			$invoice->consignor_id, "The total consignor GL posting could not be inserted");
	}

	if ($charge_shipping != 0) {
		$total += add_gl_trans_consignor(ST_TRANSPORTINVOICE, $invoice_no, $date_, $company_data["freight_act"], 0, 0,
			-$invoice->get_tax_free_shipping(), $invoice->consignor_id,
			"The freight GL posting could not be inserted");
	}
	// post all taxes
	foreach ($taxes as $taxitem) {

		if ($taxitem['Net'] != 0) {
			$ex_rate = get_exchange_rate_from_home_currency(get_consignor_currency($invoice->consignor_id), $date_);
			add_trans_tax_details(ST_TRANSPORTINVOICE, $invoice_no, $taxitem['tax_type_id'],
				$taxitem['rate'], $invoice->tax_included, $taxitem['Value'],
				 $taxitem['Net'], $ex_rate, $date_, $invoice->reference);

			$total += add_gl_trans_consignor(ST_TRANSPORTINVOICE, $invoice_no, $date_, $taxitem['transport_gl_code'], 0, 0,
				(-$taxitem['Value']), $invoice->consignor_id,
				"A tax GL posting could not be inserted");
		}
	}

	/*Post a balance post if $total != 0 */
	add_gl_balance(ST_TRANSPORTINVOICE, $invoice_no, $date_, -$total, PT_CONSIGNOR, $invoice->consignor_id);	

	add_comments(10, $invoice_no, $date_, $invoice->Comments);

	if ($trans_no == 0) {
		$Refs->save(ST_TRANSPORTINVOICE, $invoice_no, $invoice->reference);
		if ($invoice->payment_terms['cash_sale'] && $invoice->pos['pos_account']) {
			$amount = $items_total + $items_added_tax + $invoice->freight_cost 
				+ $freight_added_tax;

			// to use consignors.pmt_discount on cash sale:
			// extend invoice entry page with final amount after discount 
			// and change line below.
			$discount = 0; // $invoice->cash_discount*$amount;
			$pmtno = write_consignor_payment(0, $invoice->consignor_id, 
				$invoice->Branch, $invoice->pos['pos_account'], $date_,
				$Refs->get_next(ST_CONSIGNORPAYMENT), $amount-$discount, $discount,
				_('Cash invoice').' '.$invoice_no);
			add_consignor_allocation($amount, ST_CONSIGNORPAYMENT, $pmtno, ST_TRANSPORTINVOICE, $invoice_no);

			update_consignor_trans_allocation(ST_TRANSPORTINVOICE, $invoice_no, $amount);
			update_consignor_trans_allocation(ST_CONSIGNORPAYMENT, $pmtno, $amount);
		}
	}
	hook_db_postwrite($invoice, ST_TRANSPORTINVOICE);
	commit_transaction();

	return $invoice_no;
}

//--------------------------------------------------------------------------------------------------

function void_transport_invoice($type, $type_no)
{
	begin_transaction();

	hook_db_prevoid($type, $type_no);
	void_bank_trans($type, $type_no, true);
	void_gl_trans($type, $type_no, true);

	// reverse all the changes in parent document(s)

	$parents = get_transport_parent_numbers($type, $type_no);

	if ($parents !== 0) {
		if ($type == ST_TRANSPORTINVOICE && count($parents) == 1 && get_reference(ST_CONSIGNORDELIVERY, $parents[0]) == "auto")
		{
			void_transport_delivery(ST_CONSIGNORDELIVERY, $parents[0], false);
			$date_ = Today();
			add_audit_trail(ST_CONSIGNORDELIVERY, $parents[0], $date_, _("Voided."));
			add_voided_entry(ST_CONSIGNORDELIVERY, $parents[0], $date_, "");
		}
		else
		{
			$srcdetails = get_transport_parent_lines($type, $type_no);
			while ($row = db_fetch($srcdetails)) {
				update_parent_line($type, $row['id'], -$row['quantity']);
			}
		}
	}
	// clear details after they've been reversed in the transport booking
	void_consignor_trans_details($type, $type_no);

	void_stock_move($type, $type_no); // in case of credit note with return

	void_trans_tax_details($type, $type_no);

	void_consignor_allocations($type, $type_no);

	// do this last because other voidings can depend on it - especially voiding
	// DO NOT MOVE THIS ABOVE VOIDING or we can end up with trans with alloc < 0
	void_consignor_trans($type, $type_no);

	commit_transaction();
}

?>
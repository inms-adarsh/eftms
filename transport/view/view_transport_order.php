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
$page_security = 'SA_TRANSPORTTRANSVIEW';
$path_to_root = "../..";
include_once($path_to_root . "/transport/includes/cart_class.inc");

include_once($path_to_root . "/includes/session.inc");
include_once($path_to_root . "/includes/date_functions.inc");

include_once($path_to_root . "/transport/includes/transport_ui.inc");
include_once($path_to_root . "/transport/includes/transport_db.inc");

$js = "";
if ($use_popup_windows)
	$js .= get_js_open_window(900, 600);

if ($_GET['trans_type'] == ST_TRANSPORTQUOTE)
{
	page(_($help_context = "View Loading Slip"), true, false, "", $js);
	display_heading(sprintf(_("Loading Slip #%d"),$_GET['trans_no']));
}	
else
{
	page(_($help_context = "View Transport Bilty"), true, false, "", $js);
	display_heading(sprintf(_("Transport Bilty #%d"),$_GET['trans_no']));
}

if (isset($_SESSION['View']))
{
	unset ($_SESSION['View']);
}

$_SESSION['View'] = new Cart($_GET['trans_type'], $_GET['trans_no']);
$consignor_details = get_transport_consignor_details($_GET['trans_no'], ST_TRANSPORTORDER);

start_table(TABLESTYLE2, "width=95%", 5);

if ($_GET['trans_type'] != ST_TRANSPORTQUOTE && $_GET['trans_type'] != ST_TRANSPORTBOOKING)
{
	echo "<tr valign=top><td>";
	display_heading2(_("Bilty Information"));
	echo "</td><td>";
	display_heading2(_("Deliveries"));
	echo "</td><td>";
	display_heading2(_("Invoices/Credits"));
	echo "</td></tr>";
}	
else if ($_GET['trans_type'] == ST_TRANSPORTBOOKING)
{
	echo "<tr valign=top><td>";
	display_heading2(_("BOoking Information"));
	
}	
echo "<tr valign=top><td>";

start_table(TABLESTYLE, "width=95%");
label_cells(_("Customer"), $_SESSION['View']->billing_name, "class='tableheader2'");
label_cells(_("Customer TIN No."), $_SESSION['View']->billing_tin_no, "class='tableheader2'");
start_row();
label_cells(_("Billing Person"), $_SESSION['View']->bill_to, "class='tableheader2'");
label_cells(_("Billing Address"), $_SESSION['View']->billing_address, "class='tableheader2'");
label_row(_("E-mail"), "<a href='mailto:" . $_SESSION['View']->email . "'>" . $_SESSION['View']->email . "</a>",
	"class='tableheader2'", "colspan=3");
end_row();
start_row();
label_cells(_("Driver."), $_SESSION['View']->driver_name, "class='tableheader2'");
label_cells(_("Vehicle."), $_SESSION['View']->vehicle_number_plate, "class='tableheader2'");
end_row();
start_row();
label_cells(_("Contact Person."), $_SESSION['View']->contact_person, "class='tableheader2'");
label_row(_("Telephone"), $_SESSION['View']->phone, "class='tableheader2'", "colspan=3");
end_row();
start_row();
label_cells(_("Goods Bill No."), $_SESSION['View']->goods_bill_no, "class='tableheader2'");
label_cells(_("Value of Goods."), price_format($_SESSION['View']->total_goods_value), "class='tableheader2'");

end_row();
start_row();
label_cells(_("Ordered On"), $_SESSION['View']->document_date, "class='tableheader2'");
if ($_GET['trans_type'] == ST_TRANSPORTQUOTE)
	label_cells(_("Valid until"), $_SESSION['View']->due_date, "class='tableheader2'");
else
	label_cells(_("Requested Delivery"), $_SESSION['View']->due_date, "class='tableheader2'");
end_row();

label_row(_("Reference"), $_SESSION['View']->reference, "class='tableheader2'", "colspan=3");


label_row(_("Comments"), nl2br($_SESSION['View']->Comments), "class='tableheader2'", "colspan=3");
end_table();

if ($_GET['trans_type'] != ST_TRANSPORTQUOTE)
{
	echo "</td><td valign='top'>";

	start_table(TABLESTYLE);
	display_heading2(_("Delivery Notes"));


	$th = array(_("#"), _("Ref"), _("Date"), _("Total"));
	table_header($th);

	$dn_numbers = array();
	$delivery_total = 0;

	if ($result = get_transport_child_documents(ST_TRANSPORTORDER, $_GET['trans_no'])) {

		$k = 0;
		while ($del_row = db_fetch($result))
		{

			alt_table_row_color($k);
			$dn_numbers[] = $del_row["trans_no"];
			$this_total = $del_row["ov_freight"]+ $del_row["ov_amount"] + $del_row["ov_freight_tax"]  + $del_row["ov_gst"] ;
			$delivery_total += $this_total;

			label_cell(get_consignor_trans_view_str(ST_CONSIGNORDELIVERY, $_GET['trans_no']));
			label_cell($del_row["reference"]);
			label_cell(sql2date($del_row["tran_date"]));
			amount_cell($this_total);
			end_row();
		}
	}

	end_table();
	echo "</td><td valign='top'>";

	start_table(TABLESTYLE);
	display_heading2(_("Transport Invoices"));

	$th = array(_("#"), _("Ref"), _("Date"), _("Total"));
	table_header($th);
	
	$inv_numbers = array();
	$invoices_total = 0;

	if ($result = get_transport_child_documents(ST_TRANSPORTORDER, $_GET['trans_no'])) {

		$k = 0;

		while ($inv_row = db_fetch($result))
		{
			alt_table_row_color($k);

			$this_total = $inv_row["ov_freight"] + $inv_row["ov_freight_tax"]  + $inv_row["ov_gst"] + $inv_row["ov_amount"];
			$invoices_total += $this_total;

			$inv_numbers[] = $inv_row["trans_no"];
			label_cell(get_consignor_trans_view_str(ST_TRANSPORTINVOICE, $_GET['trans_no']));
			label_cell($inv_row["reference"]);
			label_cell(sql2date($inv_row["tran_date"]));
			amount_cell($this_total);
			end_row();
		}
	}
	
	end_table();

		display_heading2(_("Financial Report"));

	start_table(TABLESTYLE);
	$th = array(_("#"), _("Ref"), _("Date"), _("Total"));
	table_header($th);
	
	$credits_total = 0;
	
	if ($result = get_transport_child_documents(ST_TRANSPORTORDER, $_GET['trans_no'])) {
		$k = 0;

		while ($credits_row = db_fetch($result))
		{

			alt_table_row_color($k);

			$this_total = $credits_row["ov_freight"] + $credits_row["ov_freight_tax"]  + $credits_row["ov_gst"] + $credits_row["ov_amount"];
			$credits_total += $this_total;

			label_cell(viewer_link($_GET['trans_no'], "transport/view/view_financial_report.php?trans_no=".$_GET['trans_no']."&trans_type=".ST_TRANSPORTORDER."", 
		'','', false));
			label_cell($credits_row["reference"]);
			label_cell(sql2date($credits_row["tran_date"]));
			amount_cell(-$this_total);
			end_row();

		}

	}

	end_table();

	echo "</td></tr>";

	end_table();
}
echo "<center>";
display_heading2(_("Consignor Details"));
start_table(TABLESTYLE, "width=95%");

if (db_num_rows($consignor_details) > 0)
{
	$th = array(_("Consignor"), _("Tin No"), _("Address"));
	table_header($th);

	$k = 0;	//row colour counter
	$sub_total = 0;
	while ($myrow2 = db_fetch($consignor_details))
	{
		

		label_cell($myrow2["name"]);
		label_cell($myrow2["tin_no"]);
       label_cell($myrow2["address"]);
     
	end_row();
	} //end while there are line items to print out

	
}
else
	display_note(_("There are no consignors on this dispatch."), 1, 2);
end_table();

display_heading2(_("Consignee Details"));
start_table(TABLESTYLE, "width=95%");

if ($_SESSION['View']->consignee_id)
{
	$th = array(_("Consignee"), _("Tin No"),_("Deliver to"), _("Address"));
	table_header($th);

	$k = 0;	//row colour counter
	
		

		label_cell($_SESSION['View']->consignee_name);
		label_cell($_SESSION['View']->consignee_tin_no);
       label_cell($_SESSION['View']->deliver_to);
       label_cell($_SESSION['View']->delivery_address);
     
	end_row();

	
}
else
	display_note(_("There are no consignees on this dispatch."), 1, 2);

end_table();

if ($_SESSION['View']->so_type == 1)
	display_note(_("This Transport Booking is used as a Template."), 0, 0, "class='currentfg'");


display_heading2(_("Line Details"));

start_table(TABLESTYLE, "colspan=9 width=95%");
$th = array(_("Item Code"), _("Item Description"), _("Quantity"), _("Unit"),
	_("Price"), _("Discount"), _("Total"), _("Quantity Delivered"));
table_header($th);

$k = 0;  //row colour counter

foreach ($_SESSION['View']->line_items as $stock_item) {

	$line_total = round2($stock_item->quantity * $stock_item->price * (1 - $stock_item->discount_percent),
	   user_price_dec());

	alt_table_row_color($k);

	label_cell($stock_item->stock_id);
	label_cell($stock_item->item_description);
	$dec = get_qty_dec($stock_item->stock_id);
	qty_cell($stock_item->quantity, false, $dec);
	label_cell($stock_item->to_units);
	amount_cell($stock_item->price);
	amount_cell($stock_item->discount_percent * 100);
	amount_cell($line_total);

	qty_cell($stock_item->qty_done, false, $dec);
	end_row();
}

label_row(_("Shipping + Service Tax"), price_format($_SESSION['View']->freight_cost),
	"align=right colspan=6", "nowrap align=right", 1);

$sub_tot = $_SESSION['View']->get_items_total() + $_SESSION['View']->freight_cost;

$display_sub_tot = price_format($sub_tot);

label_row(_("Sub Total"), $display_sub_tot, "align=right colspan=6",
	"nowrap align=right", 1);

$taxes = $_SESSION['View']->get_taxes();

$tax_total = display_edit_tax_items($taxes, 6, $_SESSION['View']->tax_included,2);

$display_total = price_format($sub_tot + $tax_total);

start_row();
label_cells(_("Amount Total"), $display_total, "colspan=6 align='right'","align='right'");
label_cell('', "colspan=2");
end_row();
end_table(2);

end_page(true, false, false, $_GET['trans_type'], $_GET['trans_no']);

?>

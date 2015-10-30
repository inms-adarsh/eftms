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
include_once($path_to_root . "/includes/session.inc");

include_once($path_to_root . "/transport/includes/transport_ui.inc");

include_once($path_to_root . "/transport/includes/transport_db.inc");
include_once($path_to_root . "/transport/includes/cart_class.inc");


$js = "";
if ($use_popup_windows)
	$js .= get_js_open_window(900, 600);
page(_($help_context = "View Transport Dispatch"), true, false, "", $js);


if (isset($_GET["trans_no"]))
{
	$trans_id = $_GET["trans_no"];
}
elseif (isset($_POST["trans_no"]))
{
	$trans_id = $_POST["trans_no"];
}

// 3 different queries to get the information - what a JOKE !!!!

$myrow = get_transport_order_header($trans_id, ST_TRANSPORTORDER);

$consignor_details = get_transport_consignor_details($trans_id, ST_TRANSPORTORDER);
$_SESSION['View'] = new Cart(ST_TRANSPORTORDER, $trans_id);

$branch = get_branch($myrow["branch_code"]);

$transport_order = get_transport_order_header($trans_id, ST_TRANSPORTORDER);

display_heading(sprintf(_("DISPATCH NOTE #%d"),$trans_id));

echo "<br>";
start_table(TABLESTYLE2, "width=95%");
echo "<tr valign=top><td>"; // outer table

/*Now the consignor charged to details in a sub table*/
start_table(TABLESTYLE, "width=100%");
$th = array(_("Charge To"));
table_header($th);

label_row(null, $myrow["ConsignorName"] . "<br>" . nl2br($myrow["address"]), "nowrap");

end_table();

/*end of the small table showing charge to account details */

echo "</td><td>"; // outer table

/*end of the main table showing the company name and charge to details */

start_table(TABLESTYLE, "width=100%");
$th = array(_("Charge Branch"));
table_header($th);

label_row(null, $branch["br_name"] . "<br>" . nl2br($branch["br_address"]), "nowrap");
end_table();

echo "</td><td>"; // outer table

start_table(TABLESTYLE, "width=100%");
$th = array(_("Delivered To"));
table_header($th);

label_row(null, $transport_order["deliver_to"] . "<br>" . nl2br($transport_order["delivery_address"]),
	"nowrap");
end_table();

echo "</td><td>"; // outer table

start_table(TABLESTYLE, "width=100%");
start_row();
label_cells(_("Reference"), $myrow["reference"], "class='tableheader2'");
label_cells(_("Currency"), $transport_order["consignor_currency"], "class='tableheader2'");
label_cells(_("Our Bilty No"),
	get_consignor_trans_view_str(ST_TRANSPORTORDER,$transport_order["order_no"]), "class='tableheader2'");
end_row();
start_row();
label_cells(_("Consignor Order Ref."), $transport_order["consignor_ref"], "class='tableheader2'");
label_cells(_("Shipping Company"), $myrow["shipper_name"], "class='tableheader2'");
label_cells(_("Transport Type"), $myrow["transport_type"], "class='tableheader2'");
end_row();
start_row();
label_cells(_("Dispatch Date"), sql2date($myrow["tran_date"]), "class='tableheader2'", "nowrap");
label_cells(_("Due Date"), sql2date($myrow["due_date"]), "class='tableheader2'", "nowrap");
end_row();
comments_display_row(ST_CONSIGNORDELIVERY, $trans_id);
end_table();

echo "</td></tr>";
end_table(1); // outer table


$result = get_transport_order_details($trans_id,ST_TRANSPORTORDER);
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
start_table(TABLESTYLE, "width=95%");

if (db_num_rows($result) > 0)
{
	$th = array(_("Item Code"), _("Item Description"), _("Quantity"),
		_("Unit"), _("Price"), _("Discount %"), _("Total"));
	table_header($th);

	$k = 0;	//row colour counter
	$sub_total = 0;
	while ($myrow2 = db_fetch($result))
	{
		if($myrow2['quantity']==0) continue;
		alt_table_row_color($k);

		$value = round2(((1 - $myrow2["discount_percent"]) * $myrow2["unit_price"] * $myrow2["quantity"]),
		   user_price_dec());
		$sub_total += $value;

	    if ($myrow2["discount_percent"] == 0)
	    {
		  	$display_discount = "";
	    }
	    else
	    {
		  	$display_discount = percent_format($myrow2["discount_percent"]*100) . "%";
	    }

		label_cell($myrow2["stock_id"]);
		label_cell($myrow2["StockDescription"]);
        qty_cell($myrow2["quantity"], false, get_qty_dec($myrow2["stock_id"]));
        label_cell($myrow2["units"], "align=right");
        amount_cell($myrow2["unit_price"]);
        label_cell($display_discount, "nowrap align=right");
        amount_cell($value);
	end_row();
	} //end while there are line items to print out
	$display_sub_tot = price_format($sub_total);
	label_row(_("Sub-total"), $display_sub_tot, "colspan=6 align=right",
		"nowrap align=right width=15%");

}
else
	display_note(_("There are no line items on this dispatch."), 1, 2);



$display_freight = price_format($myrow["ov_freight"]);

label_row(_("Shipping"), $display_freight, "colspan=6 align=right", "nowrap align=right");

$tax_items = get_trans_tax_details(ST_CONSIGNORDELIVERY, $trans_id);
display_consignor_trans_tax_details($tax_items, 6);

$display_total = price_format($myrow["ov_freight"]+$myrow["ov_amount"]+$myrow["ov_freight_tax"]+$myrow["ov_gst"]);

label_row(_("TOTAL VALUE"), $display_total, "colspan=6 align=right",
	"nowrap align=right");
end_table(1);

is_voided_display(ST_CONSIGNORDELIVERY, $trans_id, _("This dispatch has been voided."));

end_page(true, false, false, ST_CONSIGNORDELIVERY, $trans_id);

?>
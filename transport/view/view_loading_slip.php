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
	page(_($help_context = "View Temporary Loading Slip"), true, false, "", $js);
	display_heading(sprintf(_("Temporary Loading Slip #%d"),$_GET['trans_no']));
}	
else
{
	page(_($help_context = "View Transport Booking"), true, false, "", $js);
	display_heading(sprintf(_("Transport Booking #%d"),$_GET['trans_no']));
}

if (isset($_SESSION['View']))
{
	unset ($_SESSION['View']);
}

$_SESSION['View'] = new Cart($_GET['trans_type'], $_GET['trans_no']);

start_table(TABLESTYLE2, "width=95%", 5);

if ($_GET['trans_type'] != ST_TRANSPORTQUOTE)
{
	echo "<tr valign=top><td>";
	display_heading2(_("Bilty Information"));
	echo "</td><td>";
	display_heading2(_("Delivery Information"));
	echo "</td><td>";
	display_heading2(_("Invoices/Credits"));
	echo "</td></tr>";
}	

echo "<tr valign=top><td>";

start_table(TABLESTYLE, "width=95%");

start_row();
label_cells(_("Consignor Order Ref."), $_SESSION['View']->consignor_ref, "class='tableheader2'");

end_row();
start_row();
label_cells(_("Driver."), $_SESSION['View']->driver_name, "class='tableheader2'");
label_cells(_("Driver No."), $_SESSION['View']->driver_ref, "class='tableheader2'");
end_row();
start_row();
label_cells(_("Vehicle."), $_SESSION['View']->vehicle_number_plate, "class='tableheader2'");
end_row();
start_row();
label_cells(_("Ordered On"), $_SESSION['View']->document_date, "class='tableheader2'");
if ($_GET['trans_type'] == ST_TRANSPORTQUOTE)
	label_cells(_("Valid until"), $_SESSION['View']->due_date, "class='tableheader2'");
else
	label_cells(_("Requested Delivery"), $_SESSION['View']->due_date, "class='tableheader2'");
end_row();
start_row();

label_cells(_("Loading from"), $_SESSION['View']->loaded_from, "class='tableheader2'");
label_cells(_("Loading Address"), $_SESSION['View']->loading_address, "class='tableheader2'");
end_row();
start_row();

label_cells(_("Deliver From Location"), $_SESSION['View']->location_name, "class='tableheader2'");
label_cells(_("Deliver To Location"), $_SESSION['View']->location_name_to, "class='tableheader2'");
end_row();

start_row();
label_cells(_("Deliver To"), $_SESSION['View']->deliver_to, "class='tableheader2'");
label_cells(_("Delivery Address"), nl2br($_SESSION['View']->delivery_address),
	"class='tableheader2'");

end_row();
label_row(_("Reference"), $_SESSION['View']->reference, "class='tableheader2'", "colspan=3");
label_row(_("Telephone"), $_SESSION['View']->phone, "class='tableheader2'", "colspan=3");
label_row(_("E-mail"), "<a href='mailto:" . $_SESSION['View']->email . "'>" . $_SESSION['View']->email . "</a>",
	"class='tableheader2'", "colspan=3");
label_row(_("Comments"), nl2br($_SESSION['View']->Comments), "class='tableheader2'", "colspan=3");
end_table();


if ($_SESSION['View']->so_type == 1)
	display_note(_("This Transport Booking is used as a Template."), 0, 0, "class='currentfg'");
display_heading2(_("Line Details"));

start_table(TABLESTYLE, "colspan=9 width=95%");
$th = array(_("Item Code"), _("Item Description"), _("Quantity"), _("Unit"));
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
	
	end_row();
}

end_table(2);

end_page(true, false, false, $_GET['trans_type'], $_GET['trans_no']);

?>

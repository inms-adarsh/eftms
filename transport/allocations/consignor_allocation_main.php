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
$page_security = 'SA_TRANSPORTALLOC';
$path_to_root = "../..";
include($path_to_root . "/includes/db_pager.inc");
include_once($path_to_root . "/includes/session.inc");

include_once($path_to_root . "/transport/includes/transport_ui.inc");
include_once($path_to_root . "/transport/includes/transport_db.inc");
$js = "";
if ($use_popup_windows)
	$js .= get_js_open_window(900, 500);
page(_($help_context = "Consignor Allocations"), false, false, "", $js);

//--------------------------------------------------------------------------------

start_form();
	/* show all outstanding receipts and credits to be allocated */

	if (!isset($_POST['consignor_id']))
    	$_POST['consignor_id'] = get_global_consignor();

    echo "<center>" . _("Select a consignor: ") . "&nbsp;&nbsp;";
	echo consignor_list('consignor_id', $_POST['consignor_id'], true, true);
    echo "<br>";
    check(_("Show Settled Items:"), 'ShowSettled', null, true);
	echo "</center><br><br>";

	set_global_consignor($_POST['consignor_id']);

	if (isset($_POST['consignor_id']) && ($_POST['consignor_id'] == ALL_TEXT))
	{
		unset($_POST['consignor_id']);
	}

	/*if (isset($_POST['consignor_id'])) {
		$consignorCurr = get_consignor_currency($_POST['consignor_id']);
		if (!is_company_currency($consignorCurr))
			echo _("Consignor Currency:") . $consignorCurr;
	}*/

	$settled = false;
	if (check_value('ShowSettled'))
		$settled = true;

	$consignor_id = null;
	if (isset($_POST['consignor_id']))
		$consignor_id = $_POST['consignor_id'];

//--------------------------------------------------------------------------------
function systype_name($dummy, $type)
{
	global $systypes_array;

	return $systypes_array[$type];
}

function trans_view($trans)
{
	return get_trans_view_str($trans["type"], $trans["trans_no"]);
}

function alloc_link($row)
{
	return pager_link(_("Allocate"),
		"/transport/allocations/consignor_allocate.php?trans_no="
			.$row["trans_no"] . "&trans_type=" . $row["type"]. "&consignor_no=" . $row["consignor_no"], ICON_ALLOC);
}

function amount_left($row)
{
	return price_format($row["Total"]-$row["alloc"]);
}

function check_settled($row)
{
	return $row['settled'] == 1;
}


$sql = get_allocatable_from_consignor_sql($consignor_id, $settled);

$cols = array(
	_("Transaction Type") => array('fun'=>'systype_name'),
	_("#") => array('fun'=>'trans_view'),
	_("Reference"), 
	_("Date") => array('name'=>'tran_date', 'type'=>'date', 'ord'=>'asc'),
	_("Consignor") => array('ord'=>''),
	_("Currency") => array('align'=>'center'),
	_("Total") => 'amount', 
	_("Left to Allocate") => array('align'=>'right','insert'=>true, 'fun'=>'amount_left'), 
	array('insert'=>true, 'fun'=>'alloc_link')
	);

if (isset($_POST['consignor_id'])) {
	$cols[_("Consignor")] = 'skip';
	$cols[_("Currency")] = 'skip';
}

$table =& new_db_pager('alloc_tbl', $sql, $cols);
$table->set_marker('check_settled', _("Marked items are settled."), 'settledbg', 'settledfg');

$table->width = "75%";

display_db_pager($table);
end_form();

end_page();
?>
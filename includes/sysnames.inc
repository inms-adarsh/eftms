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
//----------------------------------------------------------------------------------
//	FrontAccounting global system names. They have to be stored separate from
//	sys types defines to enable inclusion after every language change
//	(which happens for multilanguage bulk reports)
//
global $systypes_array, $bank_account_types, $bank_transfer_types, 
	$payment_person_types, $payment_payee_types,$wo_types_array, $wo_cost_types, $class_types,
	$quick_actions, $quick_entry_types, $stock_types, $tag_types;

$systypes_array = array (
	ST_JOURNAL => _("Journal Entry"),
	ST_BANKPAYMENT => _("Bank Payment"),
	ST_BANKDEPOSIT => _("Bank Deposit"),
	ST_BANKTRANSFER => _("Funds Transfer"),
	ST_TRANSPORTINVOICE => _("Transport Invoice"),
	ST_CONSIGNORCREDIT => _("Consignor Credit Note"),
	ST_CONSIGNORPAYMENT => _("Consignor Payment"),
	ST_CONSIGNORDELIVERY => _("Delivery Note"),
	ST_LOCTRANSFER => _("Location Transfer"),
	ST_INVADJUST => _("Inventory Adjustment"),
	ST_PURCHORDER => _("Purchase Order"),
	ST_SUPPINVOICE => _("Vendor Invoice"),
	ST_SUPPCREDIT => _("Vendor Credit Note"),
	ST_SUPPAYMENT => _("Vendor Payment"),
	ST_SUPPRECEIVE => _("Purchase Order Delivery"),
	ST_WORKORDER => _("Work Order"),
	ST_MANUISSUE => _("Work Order Issue"),
	ST_MANURECEIVE => _("Work Order Production"),
	ST_TRANSPORTORDER => _("Bilty"),
	ST_TRANSPORTQUOTE => _("Loading Slip"),
	ST_TRANSPORTBOOKING => _("Transport Booking"),
	ST_COSTUPDATE => _("Cost Update"),
	ST_DIMENSION => _("Dimension")
	);

$type_shortcuts = array(
	ST_JOURNAL => _("GJ"), // general journal
	ST_BANKPAYMENT => _("BP"),
	ST_BANKDEPOSIT => _("BD"),
	ST_BANKTRANSFER => _("BT"),
	ST_TRANSPORTINVOICE => _("SI"),
	ST_CONSIGNORCREDIT => _("CN"),
	ST_CONSIGNORPAYMENT => _("CP"),
	ST_CONSIGNORDELIVERY => _("DN"),
	ST_LOCTRANSFER => _("IT"), // inventory transfer
	ST_INVADJUST => _("IA"),
	ST_PURCHORDER => _("PO"),
	ST_SUPPINVOICE => _("PI"), // purchase invoice
	ST_SUPPCREDIT => _("PC"),
	ST_SUPPAYMENT => _("SP"),
	ST_SUPPRECEIVE => _("GRN"),
	ST_WORKORDER => _("WO"),
	ST_MANUISSUE => _("WI"),
	ST_MANURECEIVE => _("WP"),
	ST_TRANSPORTORDER => _("SO"),
	ST_TRANSPORTQUOTE => _("SQ"),
	ST_TRANSPORTBOOKING => _("SB"),
	ST_COSTUPDATE => _("CU"),
	ST_DIMENSION => _("Dim")
);


//----------------------------------------------------------------------------------
//		Bank transaction types
//
$bank_account_types = array (
	BT_TRANSFER => _("Savings Account"),
		_("Chequing Account"),
		_("Credit Account"),
		_("Cash Account")
	);

$bank_transfer_types = array(
	BT_TRANSFER => _("Transfer"),
			_("Cheque"),
			_("Credit"),
			_("Cash")
	);

//----------------------------------------------------------------------------------
//	Payment types
//

$payment_person_types = array (
	PT_MISC => _("Miscellaneous"),
				_("Work Order"),
				_("Customer"),
				_("Consignee"),
				_("Driver"),
				_("Quick Entry")
	);

$payment_payee_types = array (
	PT_MISC => _("Customer"),
		  _("Driver")
	);
//----------------------------------------------------------------------------------
//	Manufacturing types
//
$wo_types_array = array (
	WO_ASSEMBLY => _("Completed Service"),
	
	WO_ADVANCED => _("Advanced Servicing")
	);

$wo_cost_types = array(
	WO_LABOUR => _("Labour Cost"),
	WO_OVERHEAD => _("Overhead Cost"),
);

$freight_terms = array(
	WO_WHOLE => _("Price in whole"),
	WO_UNIT => _("Price per unit"),
);
$payment_by = array(
	WO_CONSIGNOR => _("Consignor"),
	WO_CONSIGNEE => _("Consignee"),
	WO_BROKER => _("Broker"),
);
$yesno = array(
	WO_YES => _("Yes"),
	WO_NO => _("No"),
	
);
$location_status = array(
	LO_ON => _("On the Way"),
	LO_AR => _("Arrived"),
	LO_AC => _("Accident"),
	LO_ST => _("Stop"),
	LO_RP => _("Repairing"),
	LO_FL => _("Fueling"),
	
	
);

//----------------------------------------------------------------------------------
//	GL account classes
//
$class_types = array(
	CL_ASSETS => _("Assets"),
	CL_LIABILITIES => _("Liabilities"),
	CL_EQUITY => _("Equity"),
	CL_INCOME => _("Income"),
	CL_COGS => _("Cost of Goods Sold"),
	CL_EXPENSE => _("Expense"),
);

//----------------------------------------------------------------------------------
//	Quick entry types
//
$quick_actions = array(
	'=' => _('Remainder'), // post current base amount to GL account
	'a' => _('Amount'), // post amount to GL account
	'a+' => _('Amount, increase base'), // post amount to GL account and increase base
	'a-' => _('Amount, reduce base'), // post amount to GL account and reduce base
	'%' => _('% amount of base'),	// store acc*amount% to GL account
	'%+' => _('% amount of base, increase base'),	// ditto & increase base amount
	'%-' => _('% amount of base, reduce base'),	// ditto & reduce base amount
	'T' => _('Taxes added'), // post taxes calculated on base amount
	'T+' => _('Taxes added, increase base'), // ditto & increase base amount
	'T-' => _('Taxes added, reduce base'), // ditto & reduce base amount
	't' => _('Taxes included'), // post taxes calculated on base amount
	't+' => _('Taxes included, increase base'), // ditto & increase base amount
	't-' => _('Taxes included, reduce base') // ditto & reduce base amount
);

$quick_entry_types = array(
	QE_DEPOSIT => _("Bank Deposit"),
	QE_PAYMENT => _("Bank Payment"),
	QE_JOURNAL => _("Journal Entry"),
	QE_SUPPINV => _("Vendor Invoice/Credit")
);

//----------------------------------------------------------------------------------
// Types of stock items
$stock_types = array(
	//'M' => _("Manufactured"),
	'B' => _("Purchased"),
	'D' => _("Service")
);

$time_types = array(
	'1' => _("Year"),
	'2' => _("Month"),
	'3' => _("Day")
);
$purchs_dtls = array(
	'1' => _("Already Available"),
	'2' => _("New Purchase")
	
);
$delivery_dtls = array(
	'1' => _("Immediate Delivery"),
	'2' => _("Later Delivery")
	
);
//----------------------------------------------------------------------------------

$tag_types = array (
	TAG_ACCOUNT   => _("Account"),
	TAG_DIMENSION => _("Dimension")
);

//----------------------------------------------------------------------------------
// crm contacts categories
$sys_crm_cats = array (
	'consignor_branch' => _("Consignor branch"),
	'supplier' => _("Vendor"),
	'shipper' => _("Shipper"),
	'company' => _("Company internal")
);
//----------------------------------------------------------------------------------

$pterm_types = array(
	PTT_PRE => _("Prepayment"),
	PTT_CASH => _("Cash"),
	PTT_DAYS => _("After No. of Days"),
	PTT_FOLLOWING => _("Day In Following Month")
);

//----------------------------------------------------------------------------------
// This month array is for use with the last 3 dateformats. 
$tmonths = array("", _("Jan"),_("Feb"),_("Mar"),_("Apr"),_("May"),_("Jun"),_("Jul"),_("Aug"),_("Sep"),_("Oct"),_("Nov"),_("Dec"));

?>
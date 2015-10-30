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
/*
	Security sections groups various areas on both functionality and privilege levels.
	Often analytic inquires are available only for management, and configuration
	for administration or management staff. This is why we have those three
	section type inside near every FA module.

	Section codes 0-99 are reserved for core FA functionalities.
	Every security section can contain up to 256 different areas.
	External modules can extend security roles system by adding rows to 
	$security_sections and $security_areas using section codes >=100.
	Security areas and sections created by extension modules/plugins
	have dynamically assigned 3-byte integer codes. The highest byte is zero
	for sections/areas defined in this file, and extid+1 for those defined 
	by extensions 
*/
define('SS_SADMIN',	1<<8);	// site admin
define('SS_SETUP',	2<<8);	// company level setup
define('SS_SPEC',	3<<8);	// special administration

define('SS_TRANSPORT_C',11<<8); // configuration
define('SS_TRANSPORT',	12<<8);	// transactions
define('SS_TRANSPORT_A',13<<8); // analytic functions/reports/inquires

define('SS_PURCH_C',21<<8);
define('SS_PURCH',	22<<8);
define('SS_PURCH_A',23<<8);

define('SS_ITEMS_C',31<<8);
define('SS_ITEMS',	32<<8);
define('SS_ITEMS_A',33<<8);

define('SS_MANUF_C',41<<8);
define('SS_MANUF',	42<<8);
define('SS_MANUF_A',43<<8);

define('SS_DIM_C',	51<<8);
define('SS_DIM',	52<<8);
define('SS_DIM_A',	53<<8);

define('SS_GL_C',	61<<8);
define('SS_GL',		62<<8);
define('SS_GL_A',	63<<8);

$security_sections = array(
 SS_SADMIN => _("System administration"),
 SS_SETUP => _("Company setup"),
 SS_SPEC => _("Special maintenance"),
 SS_TRANSPORT_C => _("Transport configuration"),
 SS_TRANSPORT => _("Transport transactions"),
 SS_TRANSPORT_A => _("Transport related reports"),
 SS_PURCH_C => _("Purchase configuration"),
 SS_PURCH => _("Purchase transactions"),
 SS_PURCH_A => _("Purchase analytics"),
 SS_ITEMS_C => _("Inventory configuration"),
 SS_ITEMS => _("Inventory operations"),
 SS_ITEMS_A => _("Inventory analytics"),
 SS_MANUF_C => _("Manufacturing configuration"),
 SS_MANUF => _("Manufacturing transactions"),
 SS_MANUF_A => _("Manufacturing analytics"),
 SS_DIM_C => _("Dimensions configuration"),
 SS_DIM => _("Dimensions"),
 SS_GL_C => _("Banking & GL configuration"),
 SS_GL => _("Banking & GL transactions"),
 SS_GL_A => _("Banking & GL analytics")
);

/*
	This table stores security areas available in FA. 
	Key is area identifier used to check user rights, values are
	codes stored for each role in security_roles table and description used
	in roles editor.

	Set of allowed access areas codes is retrieved during user login from
	security_roles table, and cached in user profile.

	Special value 'SA_OPEN' is used for publicly available pages like login/logout.
*/
$security_areas =array(
//
//	Site administration
//
	'SA_CREATECOMPANY' =>array(SS_SADMIN|1, _("Install/update companies")),
	'SA_CREATELANGUAGE' => array(SS_SADMIN|2, _("Install/update languages")),
	'SA_CREATEMODULES' => array(SS_SADMIN|3, _("Install/upgrade modules")),
	'SA_SOFTWAREUPGRADE' => array(SS_SADMIN|4, _("Software upgrades")),
//
//	Company setup
//
	'SA_SETUPCOMPANY' => array(SS_SETUP|1, _("Company parameters")),
	'SA_SECROLES' => array(SS_SETUP|2, _("Access levels edition")),
	'SA_USERS' => array(SS_SETUP|3, _("Users setup")),
	'SA_POSSETUP' => array(SS_SETUP|4, _("Point of transport definitions")),
	'SA_PRINTERS' => array(SS_SETUP|5, _("Printers configuration")),
	'SA_PRINTPROFILE' => array(SS_SETUP|6, _("Print profiles")),
	'SA_PAYTERMS' => array(SS_SETUP|7, _("Payment terms")),
	'SA_SHIPPING' => array(SS_SETUP|8, _("Shipping ways")),
	'SA_CRSTATUS' => array(SS_SETUP|9, _("Credit status definitions changes")),
	'SA_LOCATION' => array(SS_SETUP|10, _("Locations")),
	'SA_INVENTORYMOVETYPE'  => array(SS_SETUP|11, _("Inventory movement types")),
	'SA_WORKCENTRES' => array(SS_SETUP|12, _("Manufacture work centres")),
	'SA_FORMSETUP' => array(SS_SETUP|13, _("Forms setup")),
	'SA_CRMCATEGORY' => array(SS_SETUP|14, _("Contact categories")),
//
// Special and common functions
//
	'SA_VOIDTRANSACTION' => array(SS_SPEC|1, _("Voiding transactions")),
	'SA_BACKUP' => array(SS_SPEC|2, _("Database backup/restore")),
	'SA_VIEWPRINTTRANSACTION' => array(SS_SPEC|3, _("Common view/print transactions interface")),
	'SA_ATTACHDOCUMENT' => array(SS_SPEC|4, _("Attaching documents")),
	'SA_SETUPDISPLAY' => array(SS_SPEC|5, _("Display preferences")), //???
	'SA_CHGPASSWD' => array(SS_SPEC|6, _("Password changes")), //???

//
// Transport related functionality
//
	'SA_TRANSPORTTYPES' => array(SS_TRANSPORT_C|1, _("Transport types")),
	'SA_TRANSPORTPRICE' => array(SS_TRANSPORT_C|2, _("Transport prices edition")),
	'SA_TRANSPORTMAN' => array(SS_TRANSPORT_C|3, _("Transport staff maintenance")),
	'SA_TRANSPORTAREA' => array(SS_TRANSPORT_C|4, _("Transport areas maintenance")),
	'SA_TRANSPORTGROUP' => array(SS_TRANSPORT_C|5, _("Transport groups changes")),
	'SA_STEMPLATE' => array(SS_TRANSPORT_C|6, _("Transport templates")),
	'SA_SRECURRENT' => array(SS_TRANSPORT_C|7, _("Recurrent invoices definitions")),

	'SA_TRANSPORTTRANSVIEW' => array(SS_TRANSPORT|1,  _("Transport transactions view")),
	'SA_CONSIGNOR' => array(SS_TRANSPORT|2,  _("Transport consignor and branches changes")),
	'SA_TRANSPORTQUOTE' => array(SS_TRANSPORT|10, _("Transport quotations")),
	'SA_TRANSPORTORDER' => array(SS_TRANSPORT|3, _("Transport orders edition")),
	'SA_TRANSPORTDELIVERY' => array(SS_TRANSPORT|4, _("Transport deliveries edition")),
	'SA_TRANSPORTINVOICE' => array(SS_TRANSPORT|5, _("Transport invoices edition")),
	'SA_TRANSPORTCREDITINV' => array(SS_TRANSPORT|6, _("Transport credit notes against invoice")),
	'SA_TRANSPORTCREDIT' => array(SS_TRANSPORT|7, _("Transport freehand credit notes")),
	'SA_TRANSPORTPAYMNT' => array(SS_TRANSPORT|8, _("Consignor payments entry")),
	'SA_TRANSPORTALLOC' => array(SS_TRANSPORT|9, _("Consignor payments allocation")),

	'SA_TRANSPORTANALYTIC' => array(SS_TRANSPORT_A|1, _("Transport analytical reports")),
	'SA_TRANSPORTBULKREP' => array(SS_TRANSPORT_A|2, _("Transport document bulk reports")),
	'SA_PRICEREP' => array(SS_TRANSPORT_A|3, _("Transport prices listing")),
	'SA_TRANSPORTMANREP' => array(SS_TRANSPORT_A|4, _("Transport staff listing")),
	'SA_CONSIGNORBULKREP' => array(SS_TRANSPORT_A|5, _("Consignor bulk listing")),
	'SA_CONSIGNORSTATREP' => array(SS_TRANSPORT_A|6, _("Consignor status report")),
	'SA_CONSIGNORPAYMREP' => array(SS_TRANSPORT_A|7, _("Consignor payments report")),
	'SA_CONSIGNOR' => array(SS_TRANSPORT|2,  _("Consignor and branches changes")),
	'SA_DRIVER' => array(SS_TRANSPORT|11,  _("Driver management")),
	'SA_VEHICLE' => array(SS_TRANSPORT|12,  _("Vehicle management")),
	'SA_VEHICLE_WEIGHT' => array(SS_TRANSPORT|12,  _("Transport vehicle weight units")),
	'SA_VENDOR' => array(SS_TRANSPORT|13,  _("Transport vendor changes")),
	'SA_CONSIGNEE' => array(SS_TRANSPORT|14,  _("Consignee and branches changes")),
	'SA_FUEL_WEIGHT' => array(SS_TRANSPORT|15,  _("Fuel weight units")),
	'SA_VEHICLE_ODO' => array(SS_TRANSPORT|16,  _("Vehicle Odometer Reading")),
	'SA_VEHICLE_ACC' => array(SS_TRANSPORT|16,  _("Vehicle Accident Log")),
	'SA_VEHICLE_PART' => array(SS_TRANSPORT|17,  _("Parts of vehicle")),
	'SA_VEHICLE_TYPE' => array(SS_TRANSPORT|18,  _("Types of carriers")),
	'SA_FUEL_TYPE' => array(SS_TRANSPORT|19,  _("Types of fuel")),
	'SA_ODO_TYPE' => array(SS_TRANSPORT|20,  _("Odometer types")),
	'SA_LOADGROUP' => array(SS_TRANSPORT|2,  _("Load Group Types")),
	
//
// Purchase related functions
//
	'SA_PURCHASEPRICING' => array(SS_PURCH_C|1, _("Purchase price changes")),

	'SA_SUPPTRANSVIEW' => array(SS_PURCH|1, _("Vendor transactions view")),
	'SA_SUPPLIER' => array(SS_PURCH|2, _("Vendors changes")),
	'SA_PURCHASEORDER' => array(SS_PURCH|3, _("Purchase order entry")),
	'SA_GRN' => array(SS_PURCH|4, _("Purchase receive")),
	'SA_SUPPLIERINVOICE' => array(SS_PURCH|5, _("Vendor invoices")),
	'SA_GRNDELETE' => array(SS_PURCH|9, _("Deleting GRN items during invoice entry")),
	'SA_SUPPLIERCREDIT' => array(SS_PURCH|6, _("Vendor credit notes")),
	'SA_SUPPLIERPAYMNT' => array(SS_PURCH|7, _("Vendor payments")),
	'SA_SUPPLIERALLOC' => array(SS_PURCH|8, _("Vendor payments allocations")),

	'SA_SUPPLIERANALYTIC' => array(SS_PURCH_A|1, _("Vendor analytical reports")),
	'SA_SUPPBULKREP' => array(SS_PURCH_A|2, _("Vendor document bulk reports")),
	'SA_SUPPPAYMREP' => array(SS_PURCH_A|3, _("Vendor payments report")),
//
// Inventory 
//
	'SA_ITEM' => array(SS_ITEMS_C|1, _("Stock items add/edit")),
	'SA_TRANSPORTKIT' => array(SS_ITEMS_C|2, _("Transport kits")),
	'SA_ITEMCATEGORY' => array(SS_ITEMS_C|3, _("Item categories")),
	'SA_UOM' => array(SS_ITEMS_C|4, _("Units of measure")),

	'SA_ITEMSSTATVIEW' => array(SS_ITEMS|1, _("Stock status view")),
	'SA_ITEMSTRANSVIEW' => array(SS_ITEMS|2, _("Stock transactions view")),
	'SA_FORITEMCODE' => array(SS_ITEMS|3, _("Foreign item codes entry")),
	'SA_LOCATIONTRANSFER' => array(SS_ITEMS|4, _("Inventory location transfers")),
	'SA_INVENTORYADJUSTMENT' => array(SS_ITEMS|5, _("Inventory adjustments")),

	'SA_REORDER' => array(SS_ITEMS_A|1, _("Reorder levels")),
	'SA_ITEMSANALYTIC' => array(SS_ITEMS_A|2, _("Items analytical reports and inquiries")),
	'SA_ITEMSVALREP' => array(SS_ITEMS_A|3, _("Inventory valuation report")),

//
// Manufacturing module 
//
	'SA_BOM' => array(SS_MANUF_C|1, _("Bill of Materials")),

	'SA_MANUFTRANSVIEW' => array(SS_MANUF|1, _("Manufacturing operations view")),
	'SA_WORKORDERENTRY' => array(SS_MANUF|2, _("Work order entry")),
	'SA_MANUFISSUE' => array(SS_MANUF|3, _("Material issues entry")),
	'SA_MANUFRECEIVE' => array(SS_MANUF|4, _("Final product receive")),
	'SA_MANUFRELEASE' => array(SS_MANUF|5, _("Work order releases")),

	'SA_WORKORDERANALYTIC' => array(SS_MANUF_A|1, _("Work order analytical reports and inquiries")),
	'SA_WORKORDERCOST' => array(SS_MANUF_A|2, _("Manufacturing cost inquiry")),
	'SA_MANUFBULKREP' => array(SS_MANUF_A|3, _("Work order bulk reports")),
	'SA_BOMREP' => array(SS_MANUF_A|4, _("Bill of materials reports")),
//
// Dimensions
//
	'SA_DIMTAGS' => array(SS_DIM_C|1, _("Dimension tags")),

	'SA_DIMTRANSVIEW' => array(SS_DIM|1, _("Dimension view")),

	'SA_DIMENSION' => array(SS_DIM|2, _("Dimension entry")),

	'SA_DIMENSIONREP' => array(SS_DIM|3, _("Dimension reports")),
//
// Banking and General Ledger
//
	'SA_ITEMTAXTYPE' => array(SS_GL_C|1, _("Item tax type definitions")),
	'SA_GLACCOUNT' => array(SS_GL_C|2, _("GL accounts edition")),
	'SA_GLACCOUNTGROUP' => array(SS_GL_C|3, _("GL account groups")),
	'SA_GLACCOUNTCLASS' => array(SS_GL_C|4, _("GL account classes")),
	'SA_QUICKENTRY' => array(SS_GL_C|5, _("Quick GL entry definitions")),
	'SA_CURRENCY' => array(SS_GL_C|6, _("Currencies")),
	'SA_BANKACCOUNT' => array(SS_GL_C|7, _("Bank accounts")),
	'SA_TAXRATES' => array(SS_GL_C|8, _("Tax rates")),
	'SA_TAXGROUPS' => array(SS_GL_C|12, _("Tax groups")),
	'SA_FISCALYEARS' => array(SS_GL_C|9, _("Fiscal years maintenance")),
	'SA_GLSETUP' => array(SS_GL_C|10, _("Company GL setup")),
	'SA_GLACCOUNTTAGS' => array(SS_GL_C|11, _("GL Account tags")),
	'SA_MULTIFISCALYEARS' => array(SS_GL_C|13, _("Allow entry on non closed Fiscal years")),

	'SA_BANKTRANSVIEW' => array(SS_GL|1, _("Bank transactions view")),
	'SA_GLTRANSVIEW' => array(SS_GL|2, _("GL postings view")),
	'SA_EXCHANGERATE' => array(SS_GL|3, _("Exchange rate table changes")),
	'SA_PAYMENT' => array(SS_GL|4, _("Bank payments")),
	'SA_DEPOSIT' => array(SS_GL|5, _("Bank deposits")),
	'SA_BANKTRANSFER' => array(SS_GL|6, _("Bank account transfers")),
	'SA_RECONCILE' => array(SS_GL|7, _("Bank reconciliation")),
	'SA_JOURNALENTRY' => array(SS_GL|8, _("Manual journal entries")),
	'SA_BANKJOURNAL' => array(SS_GL|11, _("Journal entries to bank related accounts")),
	'SA_BUDGETENTRY' => array(SS_GL|9, _("Budget edition")),
	'SA_STANDARDCOST' => array(SS_GL|10, _("Item standard costs")),
	'SA_ACCRUALS' => array(SS_GL|12, _("Revenue / Cost Accruals")),

	'SA_GLANALYTIC' => array(SS_GL_A|1, _("GL analytical reports and inquiries")),
	'SA_TAXREP' => array(SS_GL_A|2, _("Tax reports and inquiries")),
	'SA_BANKREP' => array(SS_GL_A|3, _("Bank reports and inquiries")),
	'SA_GLREP' => array(SS_GL_A|4, _("GL reports and inquiries")),
);
/*
	This function should be called whenever we want to extend core access level system
	with new security areas and/or sections i.e.: 
	. on any page with non-standard security areas
	. in security roles editor
	The call should be placed between session.inc inclusion and page() call.
	Up to 155 security sections and 155 security areas for any extension can be installed.
*/
function add_access_extensions()
{
	global $security_areas, $security_sections, $installed_extensions;

	foreach($installed_extensions as $extid => $ext) {
		$accext = hook_invoke($ext['package'], 'install_access', $dummy);
		if ($accext == null) continue;

		$scode = 100;
		$acode = 100;
		$extsections = $accext[1];
		$extareas = $accext[0];
		$extcode = $extid<<16;
		
		$trans = array();
		foreach($extsections as $code =>$name) {
			$trans[$code] = $scode<<8;
			// reassign section codes
			$security_sections[$trans[$code]|$extcode] = $name;
			$scode++;
		}
		foreach($extareas as $code => $area) {
			$section = $area[0]&0xff00;
			// extension modules:
			// if area belongs to nonstandard section
			// use translated section codes and
			// preserve lower part of area code
			if (isset($trans[$section])) {
				$section = $trans[$section];
			} 
				// otherwise assign next available
				// area code >99
			$area[0] = $extcode | $section | ($acode++);
			$security_areas[$code] = $area;
		}
	}
}
/*
	Helper function to retrieve extension access definitions in isolated environment.
*/
/*
function get_access_extensions($id) {
	global $path_to_root, $installed_extensions;
	
	$ext = $installed_extensions[$id];
	
	$security_sections = $security_areas = array();
	
	if (isset($ext['acc_file']))
		include_once($path_to_root.'/'.$ext['path'].'/'.$ext['acc_file']);

	return array($security_areas, $security_sections);
}
*/
?>
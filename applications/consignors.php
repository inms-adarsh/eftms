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
class consignors_app extends application 
{
	function consignors_app() 
	{
		$this->application("orders", _($this->help_context = "&Transport"),'fa fa-truck');
	
		$this->add_module(_("Transactions"),'');
	
		$this->add_rapp_function(0, _("Load &Status"),
			"transport/inquiry/transport_orders_view.php?type=30", 'SA_TRANSPORTTRANSVIEW', MENU_INQUIRY);
		$this->add_rapp_function(0, _("&Template Delivery"),
			"transport/inquiry/transport_orders_view.php?DeliveryTemplates=Yes", 'SA_TRANSPORTDELIVERY', MENU_TRANSACTION);
	
	

		$this->add_module(_("People"));
		$this->add_lapp_function(1, _("&Customers"),
			"transport/manage/consignors.php?", 'SA_CONSIGNOR', MENU_ENTRY);
			
		$this->add_lapp_function(1, _("&Drivers"),
			"transport/manage/drivers.php?", 'SA_DRIVER', MENU_ENTRY);
		
		$this->add_module(_("General Management"));
		
			$this->add_lapp_function(2, _("&Transportable Items"),
			"transport/manage/items.php?", 'SA_ITEM', MENU_ENTRY);
			$this->add_rapp_function(2, _("&Units of Measure"),
			"inventory/manage/item_units.php?", 'SA_UOM', MENU_MAINTENANCE);
			$this->add_rapp_function(2, _("&Status Labels"),
			"transport/manage/load_status.php?", 'SA_LOADGROUP', MENU_MAINTENANCE);
	
			
			$this->add_module(_("Vehicle Management"));
			$this->add_lapp_function(3, _("&Vehicles"),
			"transport/manage/vehicles.php?", 'SA_VEHICLE', MENU_ENTRY);
				$this->add_rapp_function(3, _("&Locations"),
			"transport/manage/locations.php?", 'SA_LOCATION', MENU_MAINTENANCE);
				$this->add_lapp_function(3, _("Odometer &Reading"),
			"transport/manage/odometer_data.php?", 'SA_VEHICLE_ODO', MENU_MAINTENANCE);
			$this->add_rapp_function(3, _("&Vehicle Accident Log"),
			"transport/manage/accident_data.php?", 'SA_VEHICLE_ACC', MENU_MAINTENANCE,'ICON');
			
		$this->add_extensions();
	}
}


?>
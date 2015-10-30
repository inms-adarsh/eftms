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
$page_security = 'SA_PURCHASEPRICING';
if (!@$_GET['popup'])
	$path_to_root = "../..";
else	
	$path_to_root = "../..";

include_once($path_to_root . "/includes/session.inc");
include_once($path_to_root . "/includes/date_functions.inc");
include_once($path_to_root . "/includes/ui.inc");
include_once($path_to_root . "/includes/manufacturing.inc");
include_once($path_to_root . "/includes/data_checks.inc");

if (!@$_GET['popup'])
	page(_($help_context = "Load location updates"));

check_db_has_vehicles(_("There are no vehicles defined in the system."));
//check_db_has_suppliers(_("There are no suppliers defined in the system."));

//----------------------------------------------------------------------------------------
simple_page_mode(true);
if (isset($_GET['stock_id']))
{
	$_POST['stock_id'] = $_GET['stock_id'];
}
if (isset($_GET['ref_no']))
{
	$_POST['ref_no'] = $_GET['ref_no'];
}

//--------------------------------------------------------------------------------------------------

if ($Mode=='ADD_ITEM' || $Mode=='UPDATE_ITEM')
{

   	$input_error = 0;
   	if ($_POST['stock_id'] == "" || !isset($_POST['stock_id']))
   	{
      	$input_error = 1;
      	display_error( _("There is no vehicle selected."));
		set_focus('stock_id');
   	}
   	elseif (!check_num('odometer_reading', 0))
   	{
      	$input_error = 1;
      	display_error( _("The reading entered was not numeric."));
	set_focus('price');
   	}
	
 	
	if ($input_error == 0)
	{
     	if ($Mode == 'ADD_ITEM') 
       	{
			add_vehicle_location_data ($_POST['stock_id'],$_POST['Location'], input_num('odometer_reading'),
	 $_POST['date_of_reading'], $_POST['driver_id'], $_POST['log_description'],$_POST['ref_no'],$_POST['loc_status']);
    		display_notification(_("This odometer data has been added."));
       	} 
       	else
       	{
       		update_vehicle_location_data($selected_id, $_POST['stock_id'],$_POST['Location'], input_num('odometer_reading'),$_POST['odometer_id'],
	 $_POST['date_of_reading'], $_POST['driver_id'], $_POST['log_description'],$_POST['ref_no'],$_POST['loc_status']);
    	  	display_notification(_("odometer data has been updated."));
       	}
		$Mode = 'RESET';
	}
}

//--------------------------------------------------------------------------------------------------

if ($Mode == 'Delete')
{
	delete_vehicle_location_data($selected_id, $_POST['ref_no']);
	display_notification(_("The odometer entry has been sucessfully deleted."));
	$Mode = 'RESET';
}

if ($Mode == 'RESET')
{
	$selected_id = -1;
}

if (isset($_POST['_selected_id_update']) )
{
	$selected_id = $_POST['selected_id'];
	$Ajax->activate('_page_body');
}

if (list_updated('stock_id')) 
	$Ajax->activate('price_table');
//--------------------------------------------------------------------------------------------------

if (!@$_GET['popup'])
	start_form();

if (!isset($_POST['stock_id']))
	$_POST['stock_id'] = get_global_stock_item();

else
	br(2);

	$result = get_vehicle_location_data($_POST['ref_no']);
  	div_start('price_table');
	
    if (db_num_rows($result) == 0)
    {
    	display_note(_("There is no odometer data set up for the vehicle selected"));
    }
    else
    {
        start_table(TABLESTYLE, "width=65%");

		
		$th = array(_("Vehicle"), _("Location"), _("Date"), _("Odometer Reading"),
			_("Odometer Unit"), _("Logged By"),_("Status"), _("Description"),  "", "");

        table_header($th);

        $k = $j = 0; //row colour counter

        while ($myrow = db_fetch($result))
        {
		
			alt_table_row_color($k);
			
            label_cell($myrow["description"]);
			label_cell($myrow["location_name"]);
			 label_cell($myrow["date"]);
           qty_cell($myrow["odometer_reading"]);
            label_cell($myrow["odometer_description"]);
            label_cell($myrow["name"]);
			 label_cell($myrow["loc_status"]);
           label_cell($myrow["log_description"]);
		 	edit_button_cell("Edit".$myrow['loc_status_id'], _("Edit"));
		 	delete_button_cell("Delete".$myrow['loc_status_id'], _("Delete"));
            end_row();

            $j++;
            If ($j == 12)
            {
            	$j = 1;
        		table_header($th);
            } //end of page full new headings
		
        } //end of while loop

        end_table();
    }
 div_end();


//-----------------------------------------------------------------------------------------------

$dec2 = 0;
if ($Mode =='Edit')
{
	$myrow = get_vehicle_location_datas($selected_id, $_POST['ref_no']);

   // $veh_name = $myrow["description"];
    $_POST['odometer_reading'] = price_decimal_format($myrow["odometer_reading"], $dec2);
	 $_POST['Location'] = $myrow["loc_code"];
    $_POST['name'] = $myrow["name"];
	    $_POST['stock_id'] = $myrow["stock_id"];
    $_POST['odometer_description'] = $myrow["odometer_description"];
    $_POST['description'] = $myrow["description"];
	$_POST['odometer_id'] = $myrow["odometer_id"];
	
	$_POST['date_of_reading'] = sql2date($myrow["date"]);
}

br();
hidden('selected_id', $selected_id);
if (@$_GET['popup'])
{
	hidden('_tabs_sel', get_post('_tabs_sel'));
	hidden('popup', @$_GET['popup']);
}

start_table(TABLESTYLE2);
hidden('ref_no', $_POST['ref_no']);
hidden('odometer_id',$_POST['odometer_id']);

if (!@$_GET['popup'])
{
	echo "<center>" . _("Vehicle:"). "&nbsp;";
	//Chaitanya : All items can be purchased
	echo stock_transport_vehicles_list('stock_id', $_POST['stock_id'], false, true);
	//echo stock_purchasable_items_list('stock_id', $_POST['stock_id'], false, true);
	echo "<hr></center>";
}

locations_list_row(_("Location:"), 'Location', null, false, true);


	//check_cells("",'add_service_tax',null,true,true);

	status_list_row(_("Location status"),'loc_status');

driver_list_row(_("Driver:"), 'driver_id', null, false, true, false, true);
  $_POST['name'] = '';
    $_POST['odometer_description'] = '';
	 $_POST['log_description'] = '';
    $_POST['description'] = '';
	$_POST['date_of_reading'] = '';
$result= get_odometer_reading_unit($_POST['stock_id']);

qty_row(_("Odometer Reading:"), 'odometer_reading', null,null, null, 0);

label_row(_("Odometer Unit:"),  $result["odometer_description"]);
date_row(_("Reading Date:"), 'date_of_reading','', true, 0, 0, 0, null, true);
textarea_row(_("Notes:"), 'log_description', null, 35, 5);
end_table(1);

submit_add_or_update_center($selected_id == -1, '', 'both');

if (!@$_GET['popup'])
{
	end_form();
	end_page(@$_GET['popup'], false, false);
}
?>

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
	$path_to_root = "..";
else	
	$path_to_root = "../..";

include_once($path_to_root . "/includes/session.inc");
include_once($path_to_root . "/includes/date_functions.inc");
include_once($path_to_root . "/includes/ui.inc");
include_once($path_to_root . "/includes/manufacturing.inc");
include_once($path_to_root . "/includes/data_checks.inc");

if (!@$_GET['popup'])
	page(_($help_context = "Vehicle Accident"));

check_db_has_purchasable_items(_("There are vehicles defined in the system."));
//check_db_has_suppliers(_("There are no suppliers defined in the system."));

//----------------------------------------------------------------------------------------
simple_page_mode(true);
if (isset($_GET['vehicle_id']))
{
	$_POST['vehicle_id'] = $_GET['vehicle_id'];
}

//--------------------------------------------------------------------------------------------------

if ($Mode=='ADD_ITEM' || $Mode=='UPDATE_ITEM')
{

   	$input_error = 0;
   	if ($_POST['vehicle_id'] == "" || !isset($_POST['vehicle_id']))
   	{
      	$input_error = 1;
      	display_error( _("There is no vehicle selected."));
		set_focus('vehicle_id');
   	}
   	elseif (!check_num('odometer_reading', 0))
   	{
      	$input_error = 1;
      	display_error( _("The entry entered was not numeric."));
	set_focus('price');
   	}
	
 	
	if ($input_error == 0)
	{
     	if ($Mode == 'ADD_ITEM') 
       	{
			add_vehicle_accident_data ($_POST['vehicle_id'], $_POST['Location'],input_num('odometer_reading'),
	 $_POST['date_of_reading'], $_POST['driver_id'],$_POST['log_description']);
    		display_notification(_("This accident data has been added."));
       	} 
       	else
       	{
       		update_vehicle_accident_data($selected_id, $_POST['vehicle_id'],$_POST['Location'], input_num('odometer_reading'),
	 $_POST['date_of_reading'], $_POST['driver_id'], $_POST['log_description']);
    	  	display_notification(_("Accident data has been updated."));
       	}
		$Mode = 'RESET';
	}
}

//--------------------------------------------------------------------------------------------------

if ($Mode == 'Delete')
{
	delete_vehicle_accident_data($selected_id, $_POST['vehicle_id']);
	display_notification(_("The accident log has been sucessfully deleted."));
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

if (list_updated('vehicle_id')) 
	$Ajax->activate('price_table');
//--------------------------------------------------------------------------------------------------

if (!@$_GET['popup'])
	start_form();

if (!isset($_POST['vehicle_id']))
	$_POST['vehicle_id'] = get_global_stock_item();

if (!@$_GET['popup'])
{
	echo "<center>" . _("Vehicle:"). "&nbsp;";
	//Chaitanya : All items can be purchased
	echo stock_transport_vehicles_list('vehicle_id', $_POST['vehicle_id'], false, true);
	//echo stock_purchasable_items_list('vehicle_id', $_POST['vehicle_id'], false, true);
	echo "<hr></center>";
}
else
	br(2);

set_global_stock_item($_POST['vehicle_id']);

$mb_flag = get_mb_flag($_POST['vehicle_id']);

if ($mb_flag == -1)
{
	display_error(_("Entered item is not defined. Please re-enter."));
	set_focus('vehicle_id');
}
else
{
	$result = get_vehicle_accident_data($_POST['vehicle_id']);
  	div_start('price_table');
	
    if (db_num_rows($result) == 0)
    {
    	display_note(_("There is no accident data set up for the vehicle selected"));
    }
    else
    {
        start_table(TABLESTYLE, "width=65%");

		
	
		$th = array(_("Vehicle"), _("Location"), _("Date"), _("Odometer Reading"),
			_("Odometer Unit"), _("Logged By"), _("Description"), "", "");

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
          label_cell($myrow["log_description"]);
		 	edit_button_cell("Edit".$myrow['accident_id'], _("Edit"));
		 	delete_button_cell("Delete".$myrow['accident_id'], _("Delete"));
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
}

//-----------------------------------------------------------------------------------------------

$dec2 = 0;
if ($Mode =='Edit')
{
	$myrow = get_vehicle_accident_datas($selected_id, $_POST['vehicle_id']);

   // $veh_name = $myrow["description"];
    $_POST['odometer_reading'] = price_decimal_format($myrow["odometer_reading"], $dec2);
  $_POST['Location'] = $myrow["loc_code"];
    $_POST['name'] = $myrow["name"];
    $_POST['odometer_description'] = $myrow["odometer_description"];
    $_POST['description'] = $myrow["description"];
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

locations_list_row(_("Location:"), 'Location', null, false, true);
driver_list_row(_("Driver:"), 'driver_id', null, false, true, false, true);
  $_POST['name'] = '';
    $_POST['odometer_description'] = '';
	 $_POST['log_description'] = '';
    $_POST['description'] = '';
	$_POST['date_of_reading'] = '';
$result= get_odometer_reading_unit($_POST['vehicle_id']);

qty_row(_("Odometer Reading:"), 'odometer_reading', null,null, null, 0);

label_row(_("Odometer Unit:"),  $result["odometer_description"]);
date_row(_("Reading Date:"), 'date_of_reading', '', true, 0, 0, 0, null, true);
textarea_row(_("Notes:"), 'log_description', null, 35, 5);
end_table(1);

submit_add_or_update_center($selected_id == -1, '', 'both');

if (!@$_GET['popup'])
{
	end_form();
	end_page(@$_GET['popup'], false, false);
}
?>

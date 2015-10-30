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
$page_security = 'SA_CONSIGNOR';
$path_to_root = "../..";

include($path_to_root . "/includes/db_pager.inc");
include_once($path_to_root . "/includes/session.inc");
$js = "";
if ($use_popup_windows)
    $js .= get_js_open_window(900, 500);
if ($use_date_picker)
    $js .= get_js_date_picker();
    
page(_($help_context = "Consignors"), @$_REQUEST['popup'], false, "", $js); 

include_once($path_to_root . "/includes/date_functions.inc");
include_once($path_to_root . "/includes/banking.inc");
include_once($path_to_root . "/includes/ui.inc");
include_once($path_to_root . "/includes/ui/contacts_view.inc");

$selected_id = $_GET['consignor_no'];
if (isset($_GET['consignor_no'])) 
{
     $selected_id = $_GET['consignor_no'];
}

$new_item =  $_GET['consignor_no'] == '' || get_post('cancel') || get_post('clone'); 
//------------------------------------------------------------------------------------

if (isset($_GET['consignor_no']))
{
   $_POST['consignor_id'] = $consignor_id = $_GET['consignor_no'];
    $Ajax->activate('details');
    $Ajax->activate('controls');
}
if (get_post('cancel')) {
    $_POST['consignor_id'] = $consignor_id = $_POST['consignor_no'] = '';
    set_focus('CustName');
    $Ajax->activate('_page_body');
}

//--------------------------------------------------------------------------------------------

function can_process()
{
    if (strlen($_POST['CustName']) == 0) 
    {
        display_error(_("The customer name cannot be empty."));
        set_focus('CustName');
        return false;
    } 

    if (strlen($_POST['contact_name']) == 0) 
    {
        display_error(_("The contact name cannot be empty."));
        set_focus('contact_name');
        return false;
    } 

    if (strlen($_POST['consignor_ref']) == 0) 
    {
        display_error(_("The customer short name cannot be empty."));
        set_focus('consignor_ref');
        return false;
    } 
    


    return true;
}

//--------------------------------------------------------------------------------------------

function handle_submit(&$selected_id)
{
    global $path_to_root, $Ajax, $auto_create_branch;

    if (!can_process())
        return;
        
    if ($_POST['consignor_id']) 
    {
        update_consignor($_POST['consignor_id'], $_POST['CustName'], $_POST['consignor_ref'], $_POST['address'],$_POST['location'],$_POST['notes'],$_POST['tin_no'],$_POST['contact_name'],$_POST['phone'],$_POST['email']);

        update_record_status($_POST['consignor_id'], $_POST['inactive'],
            'consignors_master', 'consignor_no');

        $Ajax->activate('consignor_id'); // in case of status change
        meta_forward($path_to_root .'/transport/manage/consignors.php','updated=Y');
    } 
    else 
    {   //it is a new consignor

        begin_transaction();
        add_consignor($_POST['CustName'], $_POST['consignor_ref'], $_POST['address'],
            $_POST['location'],$_POST['notes'],$_POST['tin_no'],$_POST['contact_name'],$_POST['phone'],$_POST['email']);

        $selected_id = $_POST['consignor_id'] = db_insert_id();
         
        
           /* add_crm_person($_POST['CustName'], $_POST['consignor_ref'], '', $_POST['address'], 
                $_POST['phone'], $_POST['phone2'], $_POST['fax'], $_POST['email'], '', '');*/

            $pers_id = db_insert_id();
    
            /*add_crm_contact('consignor', 'general', $selected_id, $pers_id);*/
        commit_transaction();

        meta_forward($path_to_root .'/transport/manage/consignors.php','updated=N');
    
        $Ajax->activate('_page_body');
    }
}
//--------------------------------------------------------------------------------------------

if (isset($_POST['submit'])) 
{
    handle_submit($selected_id);
}
//-------------------------------------------------------------------------------------------- 

if (isset($_POST['delete'])) 
{

    $cancel_delete = 0;

    // PREVENT DELETES IF DEPENDENT RECORDS IN 'consignor_trans'

    if (key_in_foreign_table($selected_id, 'consignor_trans', 'consignor_no'))
    {
        $cancel_delete = 1;
        display_error(_("This customer cannot be deleted because there are transactions that refer to it."));
    } 
    else 
    {
        if (key_in_foreign_table($selected_id, 'transport_orders', 'consignor_no'))
        {
            $cancel_delete = 1;
            display_error(_("Cannot delete the customer record because orders have been created against it."));
        } 
        else 
        {
            if (key_in_foreign_table($selected_id,  'consignor_no'))
            {
                $cancel_delete = 1;
                display_error(_("Cannot delete this customer because there are  records set up against it."));
                //echo "<br> There are " . $myrow[0] . " branch records relating to this consignor";
            }
        }
    }
    
    if ($cancel_delete == 0) 
    {   //ie not cancelled the delete as a result of above tests
    
        delete_consignor($_POST['consignor_id']);

        meta_forward($path_to_root .'/transport/manage/consignors.php','deleted=Y');
        $selected_id = '';
        $Ajax->activate('_page_body');
    } //end if Delete Consignor
}

function consignor_settings($consignor_id) 
{
    global $SysPrefs, $path_to_root, $auto_create_branch;
    
    if (!$consignor_id) 
    {
        if ($consignor_id || !isset($_POST['CustName'])) {
            $_POST['CustName'] = $_POST['consignor_ref'] = $_POST['address']   = '';
        
        }
    }
    else 
    {
        $myrow = get_consignor($consignor_id);

        $_POST['CustName'] = $myrow["name"];
        $_POST['consignor_ref'] = $myrow["consignor_ref"];
        $_POST['address']  = $myrow["address"];
        $_POST['phone']  = $myrow["phone"];
//      $_POST['tax_id']  = $myrow["tax_id"];
        $_POST['tin_no'] = $myrow["tin_no"];
        $_POST['contact_name'] = $myrow["contact_name"];
        $_POST['location'] = $myrow["default_location"];
        $_POST['email'] = $myrow["email"];      
/*      $_POST['transport_type'] = $myrow["transport_type"];
        $_POST['curr_code']  = $myrow["curr_code"];
        $_POST['payment_terms']  = $myrow["payment_terms"];
        $_POST['discount']  = percent_format($myrow["discount"] * 100);
        $_POST['pymt_discount']  = percent_format($myrow["pymt_discount"] * 100);
*/      $_POST['notes']  = $myrow["notes"];
        $_POST['inactive'] = $myrow["inactive"];
        hidden("consignor_id",$consignor_id);
    }

    form_section_title(_("Name and Address"));

    text_row(_("Customer Name:"), 'CustName', $_POST['CustName'], 40, 80,null,null,null,'id=locality');
    text_row(_("Customer Short Name:"), 'consignor_ref', null, 30, 30,null,null,null,'id=short_locality');
    text_row(_("Contact Name:"), 'contact_name', null, 30, 30,null,null,null,'id=contact_name');
    textarea_row(_("Address:"), 'address', $_POST['address'], 35, 5,null,null,'address');
/*
    text_row(_("GSTNo:"), 'tax_id', null, 40, 40);
    

    if (!$selected_id || is_new_consignor($selected_id)) 
    {
        currencies_list_row(_("Consignor's Currency:"), 'curr_code', $_POST['curr_code']);
    } 
    else 
    {
        label_row(_("Consignor's Currency:"), $_POST['curr_code']);
        hidden('curr_code', $_POST['curr_code']);               
    }
    transport_types_list_row(_("Transport Type:"), 'transport_type', $_POST['transport_type']);
*/  
    form_section_title(_("Details"));
    if($selected_id)
    {
        record_status_list_row(_("Customer status:"), 'inactive');
    }
        
        text_row(_("TIN No:"), 'tin_no', null, 40, 40);
        text_row(_("Phone:"), 'phone', null, 32, 30);
      //  text_row(_("Secondary Phone Number:"), 'phone2', null, 32, 30);
      //  text_row(_("Fax Number:"), 'fax', null, 32, 30);
        email_row(_("E-mail:"), 'email', null, 35, 55);
        locations_list_row(_("Default Inventory Location:"), 'location');
        //tax_groups_list_row(_("Tax Group:"), 'tax_group_id', null);
        //transport_persons_list_row( _("Transport Person:"), 'transportman', null);

/*
    table_section_title(_("Transport"));
        if ($selected_id)  {
        start_row();
        echo '<td class="label">'._('Consignee consignor_branches').':</td>';
        hyperlink_params_td($path_to_root . "/transport/manage/consignor_branches.php",
            '<b>'. (@$_REQUEST['popup'] ?  _("Select or &Add") : _("&Add or Edit ")).'</b>', 
            "consignor_no=".$selected_id.(@$_REQUEST['popup'] ? '&popup=1':''));
        end_row();
    }
    
*/  textarea_row(_("General Notes:"), 'notes', null, 35, 5);
    
}

//--------------------------------------------------------------------------------------------

start_form();

consignor_settings($consignor_id); 
 start_form_section('text-center');

div_start('controls');
   
        if (!$consignor_id)
        {
        submit_center('submit', _("Add New Customer"), true, '', 'default');
        } 
        else 
        {
        submit_center_first('submit', _("Update Customer"), 
          _('Update customer data'), @$_REQUEST['popup'] ? true : 'default');
        submit_return('select', $selected_id, _("Select this customer and return to document entry."));
        submit_center_last('delete', _("Delete Customer"), 
          _('Delete customer data if have been never used'), true);
        }   
    div_end();
end_form_section();
hidden('popup', @$_REQUEST['popup']);

end_form();
end_page(@$_REQUEST['popup']);

?>

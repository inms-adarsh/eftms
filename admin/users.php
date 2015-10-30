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
$page_security = 'SA_USERS';
$path_to_root = "..";
include_once($path_to_root . "/includes/session.inc");

page(_($help_context = "Users"));

include_once($path_to_root . "/includes/date_functions.inc");
include_once($path_to_root . "/includes/ui.inc");

include_once($path_to_root . "/admin/db/users_db.inc");

simple_page_mode(true);
//-------------------------------------------------------------------------------------------------
if (isset($_GET['updated'])) {
        if($_GET['updated'] == 'N')
        {
             display_notification(_('New User has been added'));
        }
        else {
            display_notification(_('Selected User has been updated'));
        }
}
if (isset($_GET['deletedUser'])) {
    if($_SESSION['deletedUser'] != $_GET['deletedUser'])
    {
        $_SESSION['deletedUser'] = $_GET['deletedUser'];
    }
    else
    {
        $currUrl = strtok($_SERVER['PHP_SELF'] , '?');
        $_SESSION['deletedUser'] = '';
        header("Location: $currUrl");
    }
    //header("Location: $currUrl");
 }
 if($_SESSION['deletedUser'])
{
    display_error(_("User has been deleted."));
}

//-------------------------------------------------------------------------------------------------

//-------------------------------------------------------------------------------------------------

if ($Mode == 'Delete')
{
	delete_user($selected_id);
    $_SESSION['deletedUser'] = '';
    meta_forward($_SERVER['PHP_SELF'], "deletedUser=$selected_id");
	//$Mode = 'RESET';
}
if ($Mode == 'Edit'  && check_csrf_token())
{
    meta_forward($path_to_root .'/admin/new_user.php','id=' . $selected_id);
}
//-------------------------------------------------------------------------------------------------
if ($Mode == 'RESET')
{
 	$selected_id = -1;
	$sav = get_post('show_inactive');
	unset($_POST);	// clean all input fields
	$_POST['show_inactive'] = $sav;
}

$result = get_users(check_value('show_inactive'));
start_form();
start_form();
 start_form_section('row page-head');
   
    start_form_section('text-right col-md-5 col-sm-4 col-xs-6 actions');
        anchor_button(_("Add new User"),$path_to_root .'/admin/new_user.php?NewUser=Yes','btn btn-primary');
    end_form_section();
    end_form_section();
start_display_table('table datatable table-striped table-bordered','users');

$th = array(_("User login"), _("Full Name"), _("Phone"),
	_("E-mail"), _("Last Visit"), _("Access Level"), "", "");

//inactive_control_column($th);
//table_header($th);	
display_table_header($th);
 
$k = 0; //row colour counter

while ($myrow = db_fetch($result)) 
{

	alt_table_row_color($k);

	$last_visit_date = sql2date($myrow["last_visit_date"]);

	/*The security_headings array is defined in config.php */
	$not_me = strcasecmp($myrow["user_id"], $_SESSION["wa_current_user"]->username);

	label_cell($myrow["user_id"]);
	label_cell($myrow["real_name"]);
	label_cell($myrow["phone"]);
	email_cell($myrow["email"]);
	label_cell($last_visit_date, "nowrap");
	label_cell($myrow["role"]);
	
    if ($not_me)
		inactive_control_cell($myrow["id"], $myrow["inactive"], 'users', 'id');
	elseif (check_value('show_inactive'))
		label_cell('');

	edit_button_cell("Edit".$myrow["id"], _("Edit"));
    if ($not_me)
 		delete_button_cell("Delete".$myrow["id"], _("Delete"));
	else
		label_cell('');
	end_row();

} //END WHILE LIST LOOP

//inactive_control_row($th);
end_display_table(1);
//-------------------------------------------------------------------------------------------------


end_form();
end_page();
?>

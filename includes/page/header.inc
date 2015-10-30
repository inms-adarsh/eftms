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
	If no context is set current page/menu screen is selected.
*/
function help_url($context=null)
{

	global $help_base_url, $help_context, $old_style_help;

	$country = $_SESSION['language']->code;
	$clean = 0;
	
	if ($context!=null)
	{
		$help_page_url = $context;
	}
	elseif (isset($help_context))
	{
		$help_page_url = $help_context;
	} else // main menu
	{
		$app = $_SESSION['sel_app'];
		$help_page_url = $_SESSION['App']->applications[$app]->help_context;
		$clean = 1;
	}

	if (@$old_style_help)
		$help_page_url = _($help_page_url);

	if ($clean)
		$help_page_url = access_string($help_page_url, true);

	return $help_base_url
		.urlencode(strtr(ucwords($help_page_url), array(' '=>'', '/'=>'', '&'=>'And')))
		.'&ctxhelp=1&lang='.$country;
}

function send_scripts()
{
    global $js_static, $js_path, $js_userlib, $path_to_root, $go_debug;

	$js ='';
	foreach($js_static as $jsfile)
	{
	    $fpath = company_path().'/js_cache/'.$jsfile;
	    // compress also static files
	  	if (!file_exists($fpath) || $go_debug)
			cache_js_file($fpath, file_get_contents($js_path.$jsfile));

	  	$js .= '<script language="javascript" type="text/javascript" src="'.
			$fpath . '"></script>';
	}
	foreach($js_userlib as $jsfile)
	{
	  	$js .= '<script language="javascript" type="text/javascript" src="'.
	    	$jsfile . '"></script>';
	}

    echo $js;
}

function page_header($title, $no_menu=false, $is_index=false, $onload="", $js="", $css='')
{
	// titles and screen header
	global $path_to_root, $def_app, $use_popup_windows, $help_base_url, $db_connections;

	if (in_ajax())
		return; // just for speed up

//	$jsext = substr_replace($_SERVER['PHP_SELF'], '.js', -4);

//	if (file_exists($_SERVER['DOCUMENT_ROOT'].$jsext))
//		add_js_ufile($jsext);

	$theme = user_theme();

	if ($help_base_url != null && $use_popup_windows && $js == '')
	{
		if (!function_exists('get_js_open_window'))
		{
			include_once($path_to_root.'/includes/ui/ui_view.inc');
		}
		add_js_source(get_js_open_window(900, 500));
	}
	if ($js!='')
	  add_js_source($js);

	if (!isset($no_menu))
	{
		$no_menu = false;
	}
	if (isset($_SESSION["App"]) && is_object($_SESSION["App"]) && isset($_SESSION["App"]->selected_application) &&
		$_SESSION["App"]->selected_application != "")
		$sel_app = $_SESSION["App"]->selected_application;
	elseif (isset($_SESSION["sel_app"]) && $_SESSION["sel_app"] != "")
		$sel_app = $_SESSION["sel_app"];
	else
		$sel_app = user_startup_tab();
	$_SESSION["sel_app"] = $sel_app;

	// When startup tab for current user was set to already 
	// removed/inactivated extension module select Transport tab as default.
	if (isset($_SESSION["App"]) && is_object($_SESSION["App"]))
		$_SESSION["App"]->selected_application = 
			isset($_SESSION["App"]->applications[$sel_app]) ? $sel_app : 'orders';

	$page_header_args = func_get_args();
	if(isset($db_connections))	// skip before installation
		hook_invoke_all('pre_header', $page_header_args);

	$encoding = $_SESSION['language']->encoding;

	if (!headers_sent()){
		header("Content-type: text/html; charset='$encoding'");
	}
?>

<!DOCTYPE html>
	<html dir=<?php echo $_SESSION['language']->dir; ?>>

	<head profile=\"http://www.w3.org/2005/10/profile\">
	<meta charset="utf-8" />
	<title><?php echo $title; ?></title>
	<meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" name="viewport" />
	<meta http-equiv='Content-type' content='text/html; charset=$encoding'>
	<link href=<?php echo $path_to_root; ?>/themes/<?php echo $theme; ?>/default.css rel='stylesheet' type='text/css'> 
 	<link href=<?php echo $path_to_root; ?>/themes/<?php echo $theme; ?>/images/favicon.PNG rel='icon' type='image/x-icon'>
 	<!-- ================== BEGIN BASE CSS STYLE ================== -->
	<link href="http://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700" rel="stylesheet" />
	<link href=<?php echo $path_to_root; ?>/themes/<?php echo $theme; ?>/assets/plugins/jquery-ui/themes/base/minified/jquery-ui.min.css rel="stylesheet" />
	<link href=<?php echo $path_to_root; ?>/themes/<?php echo $theme; ?>/assets/plugins/bootstrap/css/bootstrap.min.css rel="stylesheet" />
	<link href=<?php echo $path_to_root; ?>/themes/<?php echo $theme; ?>/assets/plugins/font-awesome/css/font-awesome.min.css rel="stylesheet" />
	<link href=<?php echo $path_to_root; ?>/themes/<?php echo $theme; ?>/assets/css/animate.min.css rel="stylesheet" />
	<link href=<?php echo $path_to_root; ?>/themes/<?php echo $theme; ?>/assets/css/style.css rel="stylesheet" />
	<link href=<?php echo $path_to_root; ?>/themes/<?php echo $theme; ?>/assets/css/style-responsive.min.css rel="stylesheet" />
	<link href=<?php echo $path_to_root; ?>/themes/<?php echo $theme; ?>/assets/css/theme/orange.css rel="stylesheet" id="theme" />
	<!-- ================== END BASE CSS STYLE ================== -->
	
	<!-- ================== BEGIN PAGE LEVEL STYLE ================== -->
	<!-- ================== BEGIN PAGE LEVEL STYLE ================== -->
	<link href=<?php echo $path_to_root; ?>/themes/<?php echo $theme; ?>/assets/plugins/DataTables/css/data-table.css rel="stylesheet" />
    <link href=<?php echo $path_to_root; ?>/themes/<?php echo $theme; ?>/assets/plugins/gritter/css/jquery.gritter.css rel="stylesheet" />
	<link href=<?php echo $path_to_root; ?>/themes/<?php echo $theme; ?>/assets/plugins/jquery-jvectormap/jquery-jvectormap-1.2.2.css rel="stylesheet" />
	<link href=<?php echo $path_to_root; ?>/themes/<?php echo $theme; ?>/assets/plugins/bootstrap-datepicker/css/datepicker.css rel="stylesheet" />
	<link href=<?php echo $path_to_root; ?>/themes/<?php echo $theme; ?>/assets/plugins/bootstrap-datepicker/css/datepicker3.css rel="stylesheet" />
    <link href=<?php echo $path_to_root; ?>/themes/<?php echo $theme; ?>/assets/plugins/gritter/css/jquery.gritter.css rel="stylesheet" />
    <link href=<?php echo $path_to_root; ?>/themes/<?php echo $theme; ?>/assets/plugins/bootstrap-select/bootstrap-select.min.css rel="stylesheet" />
    <link href=<?php echo $path_to_root; ?>/themes/<?php echo $theme; ?>/assets/plugins/select2/dist/css/select2.min.css rel="stylesheet" />
	<!-- ================== END PAGE LEVEL STYLE ================== -->
	
	<!-- ================== BEGIN BASE JS ================== -->
	<script src=<?php echo $path_to_root; ?>/themes/<?php echo $theme; ?>/assets/plugins/pace/pace.min.js></script>
	<!-- ================== END BASE JS ================== -->
<script src='https://maps.googleapis.com/maps/api/js?v=3.exp&signed_in=true&libraries=places'></script>
<?php
	if ($css)
		echo '<link href="'.$css.'" rel="stylesheet" type="text/css">';

	send_scripts();

	echo "</head> \n";
	if ($onload == "")
		echo "<body>";
	else
		echo "<body onload=\"$onload\">";
?>
		<!-- begin #page-loader -->
	<div id="page-loader" class="fade in"><span class="spinner"></span></div>
	<!-- end #page-loader -->
	
	<!-- begin #page-container -->
 <?php if (!$no_menu) {   ?>
	<div id="page-container" class="fade page-sidebar-fixed page-header-fixed">
   <?php } else {?>
    <div id="page-container" class="fade page-without-sidebar page-header-fixed">
   <?php } ?>
<?php
	include_once($path_to_root . "/themes/$theme/renderer.php");

    if (!$no_menu)
            {   
?>
	<!-- begin #header -->
		<div id="header" class="header navbar navbar-inverse navbar-default navbar-fixed-top">
			<!-- begin container-fluid -->
			<div class="container-fluid">
				<!-- begin mobile sidebar expand / collapse button -->
				<div class="navbar-header">
					<a class="navbar-brand"><span class="navbar-logo"></span> Color Admin</a>
					<button type="button" class="navbar-toggle" data-click="sidebar-toggled">
						<span class="icon-bar"></span>
						<span class="icon-bar"></span>
						<span class="icon-bar"></span>
					</button>
				</div>
				<!-- end mobile sidebar expand / collapse button -->
				
				<ul class="nav navbar-nav navbar-right">
            
                                  <li class="dropdown">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                        <i class="fa fa-plus"></i> Create New <b class="caret"></b>
                    </a>
                    <ul class="dropdown-menu">
                       <li>
                               <a href=<?php echo $path_to_root?>/transport/transport_order_entry.php?NewOrder=Yes>
                                   <i class="fa fa-barcode"></i>
                                   Load</a>
                           </li>
                        <li>
                            <a href=<?php echo $path_to_root?>/transport/manage/new_consignor.php?NewConsignor=Yes>
                                <i class="fa fa-certificate"></i>
                                Customer</a>
                        </li>
                        <li>
                           <a href=<?php echo $path_to_root?>/transport/manage/new_vehicle.php?NewVehicle=Yes>
                                <i class="fa fa-certificate"></i>
                                Carrier</a>
                        </li>
                        <li>
                            <a href=<?php echo $path_to_root?>/transport/manage/new_driver.php?NewDriver=Yes>
                                <i class="fa fa-tint"></i>
                                Driver</a>
                        </li>
                        <li>
                            <a href=<?php echo $path_to_root?>/admin/new_driver.php?NewUser=Yes>
                            <i class="fa fa-user"></i>
                            User</a>
                        </li>
                    </ul>
                </li>
                                <li class="dropdown">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                        Welcome, <?php echo $_SESSION["wa_current_user"]->name; ?>
                        <b class="caret"></b>
                    </a>
                    <ul class="dropdown-menu">
                        <li>
                            <a href=<?php echo $path_to_root ?>/admin/change_current_user_password.php?selected_id=<?php echo $_SESSION['wa_current_user']->username ?>>
                                <i class="fa fa-lock"></i> Change Password                            </a>
                            <a href="http://localhost/sp/public/index.php/account/change-email">
                                <i class="fa fa-envelope"></i> Change Email Address                            </a>
                        </li>
                        <li class="divider"></li>
                        <li>
                            <a href=<?php echo $path_to_root ?>/access/logout.php>
                                <i class="fa fa-sign-out"></i>
                                Logout                            </a>
                        </li>
                    </ul>
                </li>
                                <li class="dropdown">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                        <i class="fa fa-wrench icon-white"></i> Admin                        <b class="caret"></b>
                    </a>
                    <ul class="dropdown-menu">
                        <li>
                            <a href=<?php echo $path_to_root ?>/transport/inquiry/transport_orders_view.php>
                                <i class="fa fa-credit-card"></i> Loads </a>
                        </li>
                          <li>
                            <a href=<?php echo $path_to_root ?>/transport/manage/consignors.php>
                                <i class="fa fa-credit-card"></i> Customers </a>
                        </li>
                        <li>
                            <a href=<?php echo $path_to_root ?>/transport/manage/vehicles.php>
                                <i class="fa fa-th"></i> Vehicles                            </a>
                        </li>
                          <li>
                            <a href=<?php echo $path_to_root ?>/transport/manage/drivers.php>
                                <i class="fa fa-credit-card"></i> Drivers                            </a>
                        </li>
                         <li>
                            <a href=<?php echo $path_to_root ?>/transport/manage/items.php>
                                <i class="fa fa-check"></i> Items                            </a>
                        </li>
                      
                        <li>
                            <a href=<?php echo $path_to_root ?>/transport/manage/locations.php>
                                <i class="fa fa-globe"></i> Locations                            </a>
                        </li>

                           <li>
                            <a href=<?php echo $path_to_root ?>/transport/manage/load_status.php>
                                <i class="fa fa-list"></i> Status Labels                            </a>
                       
                        </li>                      
                        <li>
                            <a href=<?php echo $path_to_root ?>/admin/users.php>
                                <i class="fa fa-group"></i> Users                            </a>
                        </li>
                        <li>
                            <a href=<?php echo $path_to_root ?>/admin/backups.php>
                                <i class="fa fa-download"></i> Backups                            </a>
                        </li>
                        <li class="divider"></li>
                        <li>
                            <a href=<?php echo $path_to_root ?>/admin/display_prefs.php>
                                <i class="fa fa-cog"></i> Settings                            </a>
                        </li>

                    </ul>
                </li>
                
                        </ul>
				<!-- end header navigation right -->
			</div>
			<!-- end container-fluid -->
		</div>
		<!-- end #header -->

<?php
    }
	$rend = new renderer();
	$rend->menu_header($title, $no_menu, $is_index);
	//include_once($path_to_root . "/transport/inquiry/transport_orders_view.php");
	error_box();
}

?>
<?php
/**********************************************************************
// Creator: Alastair Robertson
// date_:   2013-01-30
// Title:   Dashboard theme renderer
// Free software under GNU GPL
***********************************************************************/
	class renderer
	{
		function get_icon($category)
		{
			global  $path_to_root, $show_menu_category_icons;

			if ($show_menu_category_icons)
				$img = $category == '' ? 'right.gif' : $category.'.png';
			else
				$img = 'right.gif';
			return "<i class='fa fa-square' style='margin-right:8px'></i>";
		}

		function wa_header()
		{

		  page(_($help_context = "Dashboard"), false, true);
		}

		function wa_footer()
		{
			end_page(false, true);
		}

		function menu_header($title, $no_menu, $is_index)
		{
			global $path_to_root, $help_base_url, $db_connections;
            add_access_extensions();
		
			if (!$no_menu)
			{
				
				$applications = $_SESSION['App']->applications;
				$local_path_to_root = $path_to_root;
		
				$sel_app = $_SESSION['sel_app'];
				echo "<script src='http://ajax.googleapis.com/ajax/libs/jquery/2.0.2/jquery.min.js' type='text/javascript'></script>";
	 
		echo "<script src='$path_to_root/themes/fa-boot/js/bootstrap.min.js' type='text/javascript'></script>";
    
		echo "<script src='$path_to_root/themes/fa-boot/js/app.js' type='text/javascript'></script>";
		
	
		echo "<div class='navbar navbar-inverse head'><div class='container'>";
		
			echo "<ul class='nav nav-tabs '>";
				foreach($applications as $app)
				{
                    if ($_SESSION["wa_current_user"]->check_application_access($app))
                    {	  if ($sel_app == $app->id)
                                $sel_application = $app;
                        $acc = access_string($app->name);
						
                        echo "<li class='".($sel_app == $app->id ? 'active' : '')
                            ."' ><a href='$local_path_to_root/index.php?application=".$app->id
                            ."'$acc[1]><i style='margin-right:4px' class='".$app->icon."'></i>" .$acc[0] . "</a></lI>";
                    }
				}
			
			echo " <li class='dropdown'> \n";
			echo " <a class='dropdown-toggle' data-toggle='dropdown' href='javascript:;'>\n";
            echo "   <span class='navbar-profile-label'>". $_SESSION["wa_current_user"]->username ."</span>\n";
            echo "  <i class='fa fa-caret-down'></i>\n";
            echo " </a>\n";
			echo " <ul class='dropdown-menu' role='menu'>\n";

            echo "   <li>\n";
            echo "    <a class='shortcut' href='$path_to_root/admin/display_prefs.php?'>\n";
            echo "       <i class='fa fa-user'></i> \n";
            echo "      " . _("Preferences") . "\n";
            echo "     </a>\n";
            echo "   </li>\n";
			if ($help_base_url != null)
			{
			echo "   <li>\n";
            echo "     <a target = '_blank' onclick=" .'"'."javascript:openWindow(this.href,this.target); return false;".'" '. "href='". help_url()."'>\n";
            echo "       <i class='fa fa-dollar'></i> \n";
            echo "      ". _("Help") ."\n";
            echo "    </a>\n";
            echo "   </li>\n";
			}
            echo "   <li>\n";
            echo "     <a class='shortcut' href='$path_to_root/admin/change_current_user_password.php?selected_id=" . $_SESSION["wa_current_user"]->username . "'>\n";
            echo "      <i class='fa fa-cogs'></i> \n";
            echo "     " . _("Change password") . "\n";
            echo "    </a>\n";
            echo "   </li>\n";

            echo "   <li class='divider'></li>\n";

            echo "   <li>\n";
            echo "     <a class='shortcut' href='$path_to_root/access/logout.php?'>\n";
            echo "       <i class='fa fa-sign-out'></i> \n";
            echo "      " . _("Logout") . "\n";
            echo "     </a>\n";
            echo "   </li>\n";

            echo "  </ul>\n";
			echo "      </li>\n";
            echo "                 </ul></div></div>\n";
          
			$acc = access_string($sel_application->name);
			echo " <div class='wrapper row-offcanvas row-offcanvas-left'>\n";
            echo " <nav class='navbar navbar-default' role='navigation'>\n";
			
			 $indicator = "$path_to_root/themes/".user_theme(). "/images/ajax-loader.gif";
			 echo "<center><img id='ajaxmark' src='$indicator' align='center' style='visibility:hidden;'></center>";
            
			 echo "</nav>";
			
			echo "  <div class='container'>\n";
			
			echo " <div class='box'>\n";
			echo " <div class='box-header'>\n";
			
          
			echo "<i class='".$sel_application->icon."'></i><h3 class='box-title'>$title</h3>";
            echo "            <small>".(user_hints() ? "<span id='hints'></span>" : '')."</small>\n";
       
         	
            echo "    </div>\n";
			echo " <div class='box-body'>\n";
			
			
           
            }
		
			if ($no_menu) {
             
			}
			elseif ($title && !$is_index)
			{
			    // here starts form
			   echo "<div class='dataform'>";
              
			}
			
		}



		function menu_footer($no_menu, $is_index)
		{
			global $version, $allow_demo_mode, $app_title, $power_url,
				$power_by, $path_to_root, $Pagehelp, $Ajax;
			include_once($path_to_root . "/includes/date_functions.inc");
			echo "</div>";
			
			if ($no_menu == false)
			{if ($is_index)
					echo "<table class=bottomBar>\n";
				else
					echo "<table class=bottomBar2>\n";
				echo "<tr>";
				if (isset($_SESSION['wa_current_user'])) {
					$phelp = implode('; ', $Pagehelp);
					echo "<td class=bottomBarCell>" . Today() . " | " . Now() . "</td>\n";
					$Ajax->addUpdate(true, 'hotkeyshelp', $phelp);
					echo "<td id='hotkeyshelp'>".$phelp."</td>";
				}
				echo "</tr></table>\n";
			
			}
		
			if ($no_menu == false)
			{
			
				echo "  </div></div>\n";
					echo "<section class='footer'><a target='_blank' href='$power_url'>$app_title $version - " . _("Theme:") . " " . user_theme() ." - ".show_users_online(). "</a>\n";
			
				echo "<a target='_blank' href='$power_url'>$power_by</a></section>\n";
				echo " <div><!-- /.right-side -->\n";
		
			echo "</div><!-- ./wrapper -->\n";
			
			
				
			}
			
		}

		function display_applications(&$waapp)
		{
			global $path_to_root;

			$selected_app = $waapp->get_selected_application();
			if (!$_SESSION["wa_current_user"]->check_application_access($selected_app))
				return;

			if (method_exists($selected_app, 'render_index'))
			{
				$selected_app->render_index();
				return;
			}

			echo "<div class='module-view-layout'>" ;
			echo "<div class='col-sm-3'>"; 
			echo "<ul class='nav nav-pills nav-stacked'>";
			$j = 0;
			foreach ($selected_app->modules as $module)
			{
        	echo "<li  title='$module->name' data-label='$module->name' data-section-label='$module->name' ".($j==0? "class='menu-item active'" : "class='menu-item'")."><a role='tab' data-toggle='tab' href='#".str_replace(' ', '', $module->name)."'><i class='fa fa-star' style='margin-right:4px'></i><span class='hidden-xs'>$module->name</span></a></li>";
			$j++;
			}
			echo "</ul>";
			echo "</div><div class='col-sm-9 tab-content'>";
			$i = 0;

			foreach ($selected_app->modules as $module)
			{
        		if (!$_SESSION["wa_current_user"]->check_module_access($module))
        			continue;
				// image
				echo "<div id=".str_replace(' ', '', $module->name)." ".($i==0? "class='tab-pane active'" : "class='tab-pane'").">";
				echo "<div class='panel panel-default' data-content-label='$module->name'>";
				echo "<div class='panel-heading'><i class='fa fa-star' style='margin-right:4px'></i>";
				echo $module->name;
				echo "</div>";
				echo "<ul class='list-group'>";
		
				foreach ($module->lappfunctions as $appfunction)
				{
					$img = $this->get_icon($appfunction->category);
					if ($appfunction->label == "")
						echo "&nbsp;";
					elseif ($_SESSION["wa_current_user"]->can_access_page($appfunction->access)) 
					{
							echo "<li class='list-group-item'>
								  <div class='row'>
								  <div class='col-sm-6 list-item-name'><b>
								".$img.menu_link($appfunction->link, $appfunction->label)."
								</b>
								  </div>
								  <div class='col-sm-6 text-muted list-item-description'>
								  
								  </div>
								  </div>
								</li>\n";
					}
					elseif (!$_SESSION["wa_current_user"]->hide_inaccessible_menu_items())
					{
							echo $img.'<span class="inactive">'
								.access_string($appfunction->label, true)
								."</span><br>\n";
					}
				}
				
				if (sizeof($module->rappfunctions) > 0)
				{
				
					foreach ($module->rappfunctions as $appfunction)
					{
						$img = $this->get_icon($appfunction->category);
						if ($appfunction->label == "")
							echo "&nbsp;<br>";
						elseif ($_SESSION["wa_current_user"]->can_access_page($appfunction->access)) 
						{
								echo "<li class='list-group-item'>
								  <div class='row'>
								  <div class='col-sm-6 list-item-name'><b>
								".$img.menu_link($appfunction->link, $appfunction->label)."
								 </b> </div>
								 </div>
								</li>\n";
						}
						elseif (!$_SESSION["wa_current_user"]->hide_inaccessible_menu_items())
						{
								echo $img.'<span class="inactive">'
									.access_string($appfunction->label, true)
									."</span><br>\n";
						}
					}
					
				}

				echo "</ul></div></div>";
				
			
				$i++;
			}
			echo "</div></div>";
  	}
	}

?>
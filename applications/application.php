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

define('MENU_ENTRY', 'menu_entry');
define('MENU_TRANSACTION', 'menu_transaction');
define('MENU_INQUIRY', 'menu_inquiry');
define('MENU_REPORT', 'menu_report');
define('MENU_MAINTENANCE', 'menu_maintenance');
define('MENU_UPDATE', 'menu_update');
define('MENU_SETTINGS', 'menu_settings');
define('MENU_SYSTEM', 'menu_system');

        class menu_item
	{
		var $label;
		var $link;
		var $icon;
		function menu_item($label, $link,$icon='') 
		{
			$this->label = $label;
			$this->link = $link;
			$this->icon = $icon;
		}
	}

	class menu 
	{
		var $title;
		var $items;
		
		function menu($title) 
		{
			$this->title = $title;
			$this->items = array();
		}
		
		function add_item($label, $link,$icon='') 
		{
			$item = new menu_item($label,$link,$icon);
			array_push($this->items,$item);
			return $item;
		}
		
	}

	class app_function 
	{
		var $label;
		var $link;
		var $access;
                var $category;
		var $icon;
		function app_function($label,$link,$access='SA_OPEN',$category='',$icon='')
		{
			$this->label = $label;
			$this->link = $link;
			$this->access = $access;
            $this->category = $category;
			$this->icon = $icon;
		}
	}

	class module 
	{
		var $name;
		var $icon;
		var $lappfunctions;
		var $rappfunctions;
		
		function module($name,$icon = null) 
		{
			$this->name = $name;
			$this->icon = $icon;
			$this->lappfunctions = array();
			$this->rappfunctions = array();
		}
		
		function add_lapp_function($label,$link="",$access='SA_OPEN',$category='',$icon='')
		{
			$appfunction = new app_function($label,$link,$access,$category,$icon);
			//array_push($this->lappfunctions,$appfunction);
			$this->lappfunctions[] = $appfunction;
			return $appfunction;
		}

		function add_rapp_function($label,$link="",$access='SA_OPEN',$category='',$icon='')
		{
			$appfunction = new app_function($label,$link,$access,$category,$icon);
			//array_push($this->rappfunctions,$appfunction);
			$this->rappfunctions[] = $appfunction;
			return $appfunction;
		}
		
		
	}

	class application 
	{
		var $id;
		var $name;
		var $help_context;
		var $modules;
		var $enabled;
		var $icon;
		function application($id, $name,$icon=null,$enabled=true) 
		{
			$this->id = $id;
			$this->name = $name;
			$this->enabled = $enabled;
			$this->modules = array();
			$this->icon = $icon;
		}
		
		function add_module($name, $icon = null) 
		{
			$module = new module($name,$icon);
			//array_push($this->modules,$module);
			$this->modules[] = $module;
			return $module;
		}
		
		function add_lapp_function($level, $label,$link="",$access='SA_OPEN',$category='',$icon='')
		{
			$this->modules[$level]->lappfunctions[] = new app_function($label, $link, $access, $category,$icon);
		}
		
		function add_rapp_function($level, $label,$link="",$access='SA_OPEN',$category='',$icon='')
		{
			$this->modules[$level]->rappfunctions[] = new app_function($label, $link, $access, $category,$icon);
		}
		
		function add_extensions()
		{
			hook_invoke_all('install_options', $this);
		}
		//
		// Helper returning link to report class added by extension module.
		//
		function report_class_url($class)
		{
			global $installed_extensions;

			// TODO : konwencja lub ?
			$classno = 7;
//			if (file_exists($path_to_root.'/'.$mod['path'].'/'.$entry['url']
//					.'/'.'reporting/reports_consignorom.php'))
				return "reporting/reports_main.php?Class=".$class;
//			else
//				return '';
		}
	}


?>
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
include_once($path_to_root . "/includes/banking.inc");
include_once($path_to_root . "/includes/types.inc");
include_once($path_to_root . "/includes/current_user.inc");

$_search_button = "<input %s type='submit' class='combo_submit' style='border:0;background:url($path_to_root/themes/"
	."%s/images/locate.png) no-repeat;%s' aspect='fallback' name='%s' value=' ' title='"._("Set filter")."'> ";

$_select_button = "<input %s type='submit' class='combo_select' style='border:0;background:url($path_to_root/themes/"
	."%s/images/button_ok.png) no-repeat;%s' aspect='fallback' name='%s' value=' ' title='"._("Select")."'> ";

$all_items = ALL_TEXT;

//----------------------------------------------------------------------------
//	Universal sql combo generator
//	$sql must return selector values and selector texts in columns 0 & 1
//	Options are merged with defaults.

function combo_input($name, $selected_id, $sql, $valfield, $namefield,
	$options=null)
{
global $Ajax;

$opts = array(		// default options
	'where'=> array(),		// additional constraints
	'order' => $namefield,	// list sort order
		// special option parameters
	'spec_option'=>false, 	// option text or false
	'spec_id' => 0,		// option id
		// submit on select parameters
	'default' => '', // default value when $_POST is not set
	'multi' => false,	// multiple select
	'select_submit' => false, //submit on select: true/false
	'async' => true,	// select update via ajax (true) vs _page_body reload
		// search box parameters
	'sel_hint' => null,
	'search_box' => false, 	// name or true/false
	'type' => 0,	// type of extended selector:
		// 0 - with (optional) visible search box, search by fragment inside id
		// 1 - with hidden search box, search by option text
		// 2 - with (optional) visible search box, search by fragment at the start of id
		// 3 - TODO reverse: box with hidden selector available via enter; this
		// would be convenient for optional ad hoc adding of new item
	'search_submit' => true, //search submit button: true/false
		// size and max of box tag
	'max' => 50,
	'height' => false,	// number of lines in select box
	'cells' => false,	// combo displayed as 2 <td></td> cells
	'search' => array(), // sql field names to search
	'format' => null, 	 // format functions for regular options
	'disabled' => false,
	'box_hint' => null, // box/selectors hints; null = std see below
	'category' => false, // category column name or false
	'show_inactive' => false, // show inactive records. 
	'editable' => false // false, or length of editable entry field
);
// ------ merge options with defaults ----------
	if($options != null)
		$opts = array_merge($opts, $options);
	if (!is_array($opts['where']))  $opts['where'] = array($opts['where']);

	$search_box = $opts['search_box']===true ? '_'.$name.'_edit' : $opts['search_box'];
	// select content filtered by search field:
	$search_submit = $opts['search_submit']===true ? '_'.$name.'_button' : $opts['search_submit'];
	// select set by select content field
	$search_button = $opts['editable'] ? '_'.$name.'_button' : ($search_box ? $search_submit : false);

	$select_submit =  $opts['select_submit'];
	$spec_id = $opts['spec_id'];
	$spec_option = $opts['spec_option'];
	if ($opts['type'] == 0) {
		$by_id = true;
		$class = 'combo';
	} elseif($opts['type'] == 1) {
		$by_id = false;
		$class = 'combo2';
	} else {
		$by_id = true;
		$class = 'combo3';
	}

	$disabled = $opts['disabled'] ? "disabled" : '';
	$multi = $opts['multi'];
	
	if(!count($opts['search'])) {
		$opts['search'] = array($by_id ? $valfield : $namefield);
	}
	if ($opts['sel_hint'] === null) 
		$opts['sel_hint'] = $by_id || $search_box==false ?
			'' : _('Press Space tab for search pattern entry');

	if ($opts['box_hint'] === null)
		$opts['box_hint'] = $search_box && $search_submit != false ?
			($by_id ? _('Enter code fragment to search or * for all')
			: _('Enter description fragment to search or * for all')) :'';

	if ($selected_id == null) {
		$selected_id = get_post($name, (string)$opts['default']);
	}
	if(!is_array($selected_id))
		$selected_id = array((string)$selected_id); // code is generalized for multiple selection support

	$txt = get_post($search_box);
	$rel = '';
	$limit = '';
	if (isset($_POST['_'.$name.'_update'])) { // select list or search box change
		if ($by_id) $txt = $_POST[$name];

		if (!$opts['async'])
			$Ajax->activate('_page_body');
		else
			$Ajax->activate($name);
	}
	if (isset($_POST[$search_button])) {
		if (!$opts['async'])
			$Ajax->activate('_page_body');
		else
			$Ajax->activate($name);
	}
	if ($search_box) {
		// search related sql modifications

		$rel = "rel='$search_box'"; // set relation to list
		if ($opts['search_submit']) {
			if (isset($_POST[$search_button])) {
				$selected_id = array(); // ignore selected_id while search
				if (!$opts['async'])
					$Ajax->activate('_page_body');
				else
					$Ajax->activate($name);
			}
			if ($txt == '') {
				if ($spec_option === false && $selected_id == array())
					$limit = ' LIMIT 1';
				else
					$opts['where'][] = $valfield . "=". db_escape(get_post($name, $spec_id));
			}
			else
				if ($txt != '*') {

					foreach($opts['search'] as $i=> $s)
						$opts['search'][$i] = $s . " LIKE "
							.db_escape(($class=='combo3' ? '' : '%').$txt.'%');
					$opts['where'][] = '('. implode($opts['search'], ' OR ') . ')';
				}
		}
	}

	// sql completion
	if (count($opts['where'])) {
		$where = strpos($sql, 'WHERE')==false ? ' WHERE ':' AND ';
		$where .= '('. implode($opts['where'], ' AND ') . ')';
		$group_pos = strpos($sql, 'GROUP BY');
		if ($group_pos) {
			$group = substr($sql, $group_pos);
			$sql = substr($sql, 0, $group_pos) . $where.' '.$group;
		} else {
			$sql .= $where;
		}
	}
	if ($opts['order'] != false) {
		if (!is_array($opts['order']))
			$opts['order'] = array($opts['order']);
		$sql .= ' ORDER BY '.implode(',',$opts['order']);
	}

	$sql .= $limit;
	// ------ make selector ----------
	$selector = $first_opt = '';
	$first_id = false;
	$found = false;
	$lastcat = null;
	$edit = false;
//if($name=='stock_id')	display_notification('<pre>'.print_r($_POST, true).'</pre>');
//if($name=='curr_default') display_notification($opts['search_submit']);
	if($result = db_query($sql)) {
		while ($contact_row = db_fetch($result)) {
			$value = $contact_row[0];
			$descr = $opts['format']==null ?  $contact_row[1] :
				call_user_func($opts['format'], $contact_row);
			$sel = '';
 		 	if (get_post($search_button) && ($txt == $value)) {
 		 		$selected_id[] = $value;
 		 	}

 		 	if (in_array((string)$value, $selected_id, true)) {
				$sel = 'selected';
				$found = $value;
				$edit = $opts['editable'] && $contact_row['editable'] 
					&& (@$_POST[$search_box] == $value)
					? $contact_row[1] : false; // get non-formatted description
				if ($edit)
					break;	// selected field is editable - abandon list construction
			}
			// show selected option even if inactive 
			if (!$opts['show_inactive'] && @$contact_row['inactive'] && $sel==='') {
				continue;
			} else 
				$optclass = @$contact_row['inactive'] ? "class='inactive'" : '';

			if ($first_id === false) {
				$first_id = $value;
				$first_opt = $descr;
			}
			$cat = $contact_row[$opts['category']];
			if ($opts['category'] !== false && $cat != $lastcat){
				$selector .= "<optgroup label='".$cat."'>\n";
				$lastcat = $cat;
			}
			$selector .= "<option $sel $optclass value='$value'>$descr</option>\n";
		}
		db_free_result($result);
	}

	// Prepend special option.
	if ($spec_option !== false) { // if special option used - add it
		$first_id = $spec_id;
		$first_opt = $spec_option;
//	}
//	if($first_id !== false) {
		$sel = $found===false ? 'selected' : '';
		$optclass = @$contact_row['inactive'] ? "class='inactive'" : '';
		$selector = "<option $sel value='$first_id'>$first_opt</option>\n"
			. $selector;
	}

	if ($found===false) {
		$selected_id = array($first_id);
	}
	
	$_POST[$name] = $multi ? $selected_id : $selected_id[0];

	$selector = "<select autocomplete='off' ".($multi ? "multiple" : '')
		. ($opts['height']!==false ? ' size="'.$opts['height'].'"' : '')
		. "$disabled name='$name".($multi ? '[]':'')."' class='$class' title='"
		. $opts['sel_hint']."' $rel>".$selector."</select>\n";

	if ($by_id && ($search_box != false || $opts['editable']) ) {
		// on first display show selector list
		if (isset($_POST[$search_box]) && $opts['editable'] && $edit) {
			$selector = "<input type='hidden' name='$name' value='".$_POST[$name]."'>"
			."<input type='text' $disabled name='{$name}_text' id='{$name}_text' size='".
				$opts['editable']."' maxlength='".$opts['max']."' $rel value='$edit'>\n";
				set_focus($name.'_text'); // prevent lost focus
		} else if (get_post($search_submit ? $search_submit : "_{$name}_button"))
			set_focus($name); // prevent lost focus
		if (!$opts['editable'])
	 		$txt = $found;
		$Ajax->addUpdate($name, $search_box, $txt ? $txt : '');
	}

	$Ajax->addUpdate($name, "_{$name}_sel", $selector);

	// span for select list/input field update
	$selector = "<span id='_{$name}_sel'>".$selector."</span>\n";

	 // if selectable or editable list is used - add select button
	if ($select_submit != false || $search_button) {
		global $_select_button;
	// button class selects form reload/ajax selector update
		$selector .= sprintf($_select_button, $disabled, user_theme(),
			(fallback_mode() ? '' : 'display:none;'),
			 '_'.$name.'_update')."\n";
	}
// ------ make combo ----------
	$edit_entry = '';
	if ($search_box != false) {
		$edit_entry = "<input $disabled type='text' name='$search_box' id='$search_box'  maxlength='".$opts['max'].
			"' value='$txt' class='$class' rel='$name' autocomplete='off' title='"
			.$opts['box_hint']."'"
			.(!fallback_mode() && !$by_id ? " style=display:none;":'')
			.">\n";
		if ($search_submit != false || $opts['editable']) {
			global $_search_button;
			$edit_entry .= sprintf($_search_button, $disabled, user_theme(),
				(fallback_mode() ? '' : 'display:none;'),
				$search_submit ? $search_submit : "_{$name}_button")."\n";
		}
	}
	default_focus(($search_box && $by_id) ? $search_box : $name);

	if ($search_box && $opts['cells'])
		$str = ($edit_entry!='' ? "<td>$edit_entry</td>" : '')."<td>$selector</td>";
	else
		$str = $edit_entry.$selector;
	return $str;
}

/*
	Helper function.
	Returns true if selector $name is subject to update.
*/
function list_updated($name)
{
	return isset($_POST['_'.$name.'_update']) || isset($_POST['_'.$name.'_button']);
}
//----------------------------------------------------------------------------------------------
//	Universal array combo generator
//	$items is array of options 'value' => 'description'
//	Options is reduced set of combo_selector options and is merged with defaults.

function array_selector($name, $selected_id, $items, $options=null)
{
	global $Ajax;

$opts = array(		// default options
	'spec_option'=>false, 	// option text or false
	'spec_id' => 0,		// option id
	'select_submit' => false, //submit on select: true/false
	'async' => true,	// select update via ajax (true) vs _page_body reload
	'default' => '', // default value when $_POST is not set
	'multi'=>false,	// multiple select
		// search box parameters
	'height' => false,	// number of lines in select box
	'sel_hint' => null,
	'disabled' => false
);
// ------ merge options with defaults ----------
	if($options != null)
		$opts = array_merge($opts, $options);
	$select_submit =  $opts['select_submit'];
	$spec_id = $opts['spec_id'];
	$spec_option = $opts['spec_option'];
	$disabled = $opts['disabled'] ? "disabled" : '';
	$multi = $opts['multi'];

	if ($selected_id == null) {
		$selected_id = get_post($name, $opts['default']);
	}
	if(!is_array($selected_id))
		$selected_id = array((string)$selected_id); // code is generalized for multiple selection support

	if (isset($_POST[ '_'.$name.'_update'])) {
		if (!$opts['async'])
			$Ajax->activate('_page_body');
		else
			$Ajax->activate($name);
	}

	// ------ make selector ----------
	$selector = $first_opt = '';
	$first_id = false;
	$found = false;
//if($name=='SelectStockFromList') display_error($sql);
		foreach($items as $value=>$descr) {
			$sel = '';
			if (in_array((string)$value, $selected_id, true)) {
				$sel = 'selected';
				$found = $value;
			}
			if ($first_id === false) {
				$first_id = $value;
				$first_opt = $descr;
			}
			$selector .= "<option $sel value='$value'>$descr</option>\n";
		}

	if ($first_id!==false) {
		$sel = ($found===$first_id) || ($found===false && ($spec_option===false)) ? "selected='selected'" : '';
		$selector = sprintf($first_opt, $sel).$selector;
	}
	// Prepend special option.
	if ($spec_option !== false) { // if special option used - add it
		$first_id = $spec_id;
		$first_opt = $spec_option;
		$sel = $found===false ? 'selected' : '';
		$selector = "<option $sel value='$spec_id'>$spec_option</option>\n"
			. $selector;
	}

	if ($found===false) {
		$selected_id = array($first_id);
	}
	$_POST[$name] = $multi ? $selected_id : $selected_id[0];

	$selector = "<select autocomplete='off' ".($multi  ? "multiple" : '')
		. ($opts['height']!==false ? ' size="'.$opts['height'].'"' : '')
		. "$disabled name='$name".($multi ? '[]' : '')."' class='combo' title='"
		. $opts['sel_hint']."'>".$selector."</select>\n";

	$Ajax->addUpdate($name, "_{$name}_sel", $selector);

	$selector = "<span id='_{$name}_sel'>".$selector."</span>\n";

	if ($select_submit != false) { // if submit on change is used - add select button
		global $_select_button;
		$selector .= sprintf($_select_button, $disabled, user_theme(),
			(fallback_mode() ? '' : 'display:none;'),
			 '_'.$name.'_update')."\n";
	}
	default_focus($name);

	return $selector;
}
//----------------------------------------------------------------------------------------------

function _format_add_curr($row)
{
	static $company_currency;

	if ($company_currency == null)
	{
		$company_currency = get_company_currency();
	}
	return $row[1] . ($row[2] == $company_currency ?
		'' : ("&nbsp;-&nbsp;" . $row[2]));
}

function add_edit_combo($type)
{
	global $path_to_root, $popup_editors, $use_icon_for_editkey;

	if (!isset($use_icon_for_editkey) || $use_icon_for_editkey==0)
		return "";
	// Derive theme path
	$theme_path = $path_to_root . '/themes/' . user_theme();

	$key = $popup_editors[$type][1];
	$onclick = "onclick=\"javascript:callEditor($key); return false;\"";
	$img = "<img width='12' height='12' border='0' alt='Add/Edit' title='Add/Edit' src='$theme_path/images/".ICON_EDIT."'>";
	return "<a target = '_blank' href='#' $onclick tabindex='-1'>$img</a>"; 
}

function supplier_list($name, $selected_id=null, $spec_option=false, $submit_on_change=false,
	$all=false, $editkey = false)
{
	global $all_items;

	$sql = "SELECT supplier_id, supp_ref, curr_code, inactive FROM ".TB_PREF."suppliers ";

	$mode = get_company_pref('no_supplier_list');

	if ($editkey)
		set_editor('supplier', $name, $editkey);
		
	$ret = combo_input($name, $selected_id, $sql, 'supplier_id', 'supp_name',
	array(
		'format' => '_format_add_curr',
	    'order' => array('supp_ref'),
		'search_box' => $mode!=0,
		'type' => 1,
		'spec_option' => $spec_option === true ? _("All Vendors") : $spec_option,
		'spec_id' => $all_items,
		'select_submit'=> $submit_on_change,
		'async' => false,
		'sel_hint' => $mode ? _('Press Space tab to filter by name fragment') :
		_('Select supplier'),
		'show_inactive'=>$all
		));
	if ($editkey)
		$ret .= add_edit_combo('supplier');		
	return $ret;
}

function supplier_list_cells($label, $name, $selected_id=null, $all_option=false, 
	$submit_on_change=false, $all=false, $editkey = false)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label><td>\n";
		echo supplier_list($name, $selected_id, $all_option, $submit_on_change, 
		$all, $editkey);
		
}

function supplier_list_row($label, $name, $selected_id=null, $all_option = false, 
	$submit_on_change=false, $all=false, $editkey = false)
{
	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	echo supplier_list($name, $selected_id, $all_option, $submit_on_change,
		$all, $editkey);
	echo "</div></div>\n";
}
//----------------------------------------------------------------------------------------------

function consignor_list($name, $selected_id=null, $spec_option=false, $submit_on_change=false, 
	$show_inactive=false, $editkey = false,$check_branches=false)
{
	global $all_items;

	$sql = "SELECT distinct a.consignor_no, a.name,  a.inactive FROM ".TB_PREF."consignors_master a";


	$mode = get_company_pref('no_consignor_list');

	if ($editkey)
		set_editor('consignor', $name, $editkey);

	$ret = combo_input($name, $selected_id, $sql, 'consignor_no', 'name',
	array(
	   
	    'order' => array('name'),
		'search_box' => $mode!=0,
		'type' => 1,
		
		'spec_option' => $spec_option === true ? _("Select a Customer") : $spec_option,
		'spec_id' => $all_items,
		'select_submit'=> $submit_on_change,
		'async' => false,
		'sel_hint' => $mode ? _('Press Space tab to filter by name fragment; F2 - entry new customer') :
		_('Select consignor'),
		'show_inactive' => $show_inactive
	) );
	if ($editkey)
		$ret .= add_edit_combo('consignor');
	return $ret;
}

function consignor_list_cells($label, $name, $selected_id=null, $all_option=false, 
	$submit_on_change=false, $show_inactive=false, $editkey = false,$withbranch=false)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	
	echo consignor_list($name, $selected_id, $all_option, $submit_on_change,
		$show_inactive, $editkey,$withbranch);
	
}


function consignor_list_row($label, $name, $selected_id=null, $all_option = true, 
	$submit_on_change=false, $show_inactive=false, $editkey = false)
{
	global $path_to_root;

	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	echo consignor_list($name, $selected_id, $all_option, $submit_on_change,
		$show_inactive, $editkey);
	echo "</div></div>\n";
}

//------------------------------------------------------------------------------------------------
// Prabha added for both consignor and driver----------------------------------------------------

function consignor_driver_list($name, $selected_id=null, $spec_option=false, $submit_on_change=false, 
	$show_inactive=false, $editkey = false,$pay_type=0)
{
	global $all_items;

        if ($pay_type == 0)
        {
            $sql = "SELECT distinct a.consignor_no, a.name,  a.inactive FROM ".TB_PREF."consignors_master a";

            
            $mode = get_company_pref('no_consignor_list');

            if ($editkey)
                    set_editor('consignor', $name, $editkey);

            $ret = combo_input($name, $selected_id, $sql, 'consignor_no', 'name',
            array(
                'order' => array('name'),
                    'search_box' => $mode!=0,
                    'type' => 1,

                    'spec_option' => $spec_option === true ? _("Select a Customer") : $spec_option,
                    'spec_id' => $all_items,
                    'select_submit'=> $submit_on_change,
                    'async' => false,
                    'sel_hint' => $mode ? _('Press Space tab to filter by name fragment; F2 - entry new customer') :
                    _('Select consignor'),
                    'show_inactive' => $show_inactive
            ) );
            if ($editkey)
                    $ret .= add_edit_combo('consignor');
        }
        else 
        {
            $sql = "SELECT driver_no, driver_ref, curr_code, inactive FROM ".TB_PREF."drivers_master ";

            if ($editkey)
                set_editor('driver', $name, $editkey);
            
                    $ret = combo_input($name, $selected_id, $sql, 'driver_no', 'driver_ref',
                    array(

                        'order' => array('driver_ref'),

                            'type' => 1,

                            'spec_option' => $spec_option === true ? _("Select a driver") : $spec_option,
                            'spec_id' => $all_items,
                            'select_submit'=> $submit_on_change,
                            'async' => false,

                            'show_inactive' => $show_inactive
                    ) );
                    if ($editkey)
                            $ret .= add_edit_combo('driver');            
        }
	return $ret;
}

function consignor_driver_list_cells($label, $name, $selected_id=null, $all_option=false, 
	$submit_on_change=false, $show_inactive=false, $editkey = false,$pay_type=0)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	
	echo consignor_driver_list($name, $selected_id, $all_option, $submit_on_change,
		$show_inactive, $editkey,$pay_type);
	
}
//------------------------------------------------------------------------------------------------
function consignor_branches_list($consignor_id, $name, $selected_id=null,
	$spec_option = true, $enabled=true, $submit_on_change=false, $editkey = false)
{
	global $all_items;

	$sql = "SELECT branch_code, br_name ,tin_no,br_address FROM ".TB_PREF."consignor_branch
		WHERE consignor_no=" . db_escape($consignor_id)." ";
        
        if ($editkey)
		set_editor('branch', $name, $editkey);

	$where = $enabled ? array("disable_trans = 0") : array();
	$ret = combo_input($name, $selected_id, $sql, 'branch_code', 'br_name',
	array(
		'where' => $where,
		'order' => array('br_name'),
		'spec_option' => $spec_option === true ? _('All branches') : $spec_option,
		'spec_id' => $all_items,
		'select_submit'=> $submit_on_change,
		'sel_hint' => _('Select consignor branch')
	) );
	if ($editkey)
	{
		$ret .= add_edit_combo('branch');
	}	
	return $ret;
}
//------------------------------------------------------------------------------------------------

function consignor_branches_list_cells($label,$consignor_id, $name, $selected_id=null, 
	$all_option = true, $enabled=true, $submit_on_change=false, $editkey = false)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	
        
	echo consignor_branches_list($consignor_id, $name, $selected_id, $all_option, $enabled, 
		$submit_on_change, $editkey);
	
}

function consignor_branches_list_row($label, $consignor_id, $name, $selected_id=null, 
	$all_option = true, $enabled=true, $submit_on_change=false, $editkey = false)
{
	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
        
	consignor_branches_list_cells(null, $consignor_id, $name, $selected_id, 
		$all_option, $enabled, $submit_on_change, $editkey);
	echo "</div></div>";
}

// Prabha added get consignor and driver branches in the list if any
function consignor_driver_branches_list($consignor_id, $name, $selected_id=null,
	$spec_option = true, $enabled=true, $submit_on_change=false, $editkey = false,$pay_type=0)
{
	global $all_items;

        if ($pay_type == 0)
        {
            $sql = "SELECT branch_code, br_name ,tin_no,br_address FROM ".TB_PREF."consignor_branch
                    WHERE consignor_no=" . db_escape($consignor_id)." ";
        }
        else
        {
             $sql = "SELECT 0 as branch_code, 'No Branches for driver' as br_name ";
        }
            if ($editkey)
                    set_editor('branch', $name, $editkey);

            $where = $enabled ? array("disable_trans = 0") : array();
            $ret = combo_input($name, $selected_id, $sql, 'branch_code', 'br_name',
            array(
                    'where' => $where,
                    'order' => array('br_name'),
                    'spec_option' => $spec_option === true ? _('All branches') : $spec_option,
                    'spec_id' => $all_items,
                    'select_submit'=> $submit_on_change,
                    'sel_hint' => _('Select consignor branch')
            ) );
                if ($editkey)
                    $ret .= add_edit_combo('branch');
	
        
	return $ret;
}
//------------------------------------------------------------------------------------------------

function consignor_driver_branches_list_cells($label,$consignor_id, $name, $selected_id=null, 
	$all_option = true, $enabled=true, $submit_on_change=false, $editkey = false,$pay_type=0)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	
        
	echo consignor_driver_branches_list($consignor_id, $name, $selected_id, $all_option, $enabled, 
		$submit_on_change, $editkey,$pay_type);
	
}
function consignee_list($name, $selected_id=null, $spec_option=false, $submit_on_change=false, 
	$show_inactive=false, $editkey = false)
{
	global $all_items;

	$sql = "SELECT consignee_no, consignee_ref, curr_code, inactive FROM ".TB_PREF."consignees_master ";

	$mode = get_company_pref('no_consignee_list');

	if ($editkey)
		set_editor('consignee', $name, $editkey);

	$ret = combo_input($name, $selected_id, $sql, 'consignee_no', 'consignee_ref',
	array(
	    'format' => '_format_add_curr',
	    'order' => array('consignee_ref'),
		'search_box' => $mode!=0,
		'type' => 1,
		
		'spec_option' => $spec_option === true ? _("Select a Customer") : $spec_option,
		'spec_id' => $all_items,
		'select_submit'=> $submit_on_change,
		'async' => false,
		'sel_hint' => $mode ? _('Press Space tab to filter by name fragment; F2 - entry new customer') :
		_('Select consignee'),
		'show_inactive' => $show_inactive
	) );
	if ($editkey)
		$ret .= add_edit_combo('consignee');
	return $ret;
}

function consignee_list_cells($label, $name, $selected_id=null, $all_option=false, 
	$submit_on_change=false, $show_inactive=false, $editkey = false)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	
	echo consignee_list($name, $selected_id, $all_option, $submit_on_change,
		$show_inactive, $editkey);
	
}

function consignee_list_row($label, $name, $selected_id=null, $all_option = false, 
	$submit_on_change=false, $show_inactive=false, $editkey = false)
{
	global $path_to_root;

	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	echo consignee_list($name, $selected_id, $all_option, $submit_on_change,
		$show_inactive, $editkey);
	echo "</div></div>\n";
}

//------------------------------------------------------------------------------------------------

function consignee_branches_list($consignee_id, $name, $selected_id=null,
	$spec_option = true, $enabled=true, $submit_on_change=false, $editkey = false)
{
	global $all_items;

	$sql = "SELECT consignee_branch_code, consignee_branch_ref FROM ".TB_PREF."consignee_branch
		WHERE consignee_no=" . db_escape($consignee_id)." ";

	if ($editkey)
		set_editor('consignee_branch', $name, $editkey);

	$where = $enabled ? array("disable_trans = 0") : array();
	$ret = combo_input($name, $selected_id, $sql, 'consignee_branch_code', 'consignee_branch_ref',
	array(
		'where' => $where,
		'order' => array('consignee_branch_ref'),
		'spec_option' => $spec_option === true ? _('Select a branch') : $spec_option,
		'spec_id' => $all_items,
		'select_submit'=> $submit_on_change,
		'sel_hint' => _('Select consignee branch')
	) );
	if ($editkey)
	{
		$ret .= add_edit_combo('branch');
	}	
	return $ret;
}
//------------------------------------------------------------------------------------------------

function consignee_branches_list_cells($label,$consignee_id, $name, $selected_id=null, 
	$all_option = true, $enabled=true, $submit_on_change=false, $editkey = false)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	
	echo consignee_branches_list($consignee_id, $name, $selected_id, $all_option, $enabled, 
		$submit_on_change, $editkey);
	
}

function consignee_branches_list_row($label, $consignee_id, $name, $selected_id=null, 
	$all_option = true, $enabled=true, $submit_on_change=false, $editkey = false)
{
	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	consignee_branches_list_cells(null, $consignee_id, $name, $selected_id, 
		$all_option, $enabled, $submit_on_change, $editkey);
	echo "</div></div>";
}

//------------------------------------------------------------------------------------------------

function locations_list($name, $selected_id=null, $all_option=false, $submit_on_change=false)
{
	global $all_items;

	$sql = "SELECT loc_code, location_name, inactive FROM ".TB_PREF."locations";
	
return combo_input($name, $selected_id, $sql, 'loc_code', 'location_name',
	array(
		'spec_option' => $all_option === true ? _("Select a Location") : $all_option,
		'spec_id' => $all_items,
		'select_submit'=> $submit_on_change
	) );
}

function locations_list_cells($label, $name, $selected_id=null, $all_option=false, $submit_on_change=false)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	
	echo locations_list($name, $selected_id, $all_option, $submit_on_change);
	
}

function locations_list_row($label, $name, $selected_id=null, $all_option=false, $submit_on_change=false)
{
	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	locations_list_cells(null, $name, $selected_id, $all_option, $submit_on_change);
	echo "</div></div>\n";
}

function status_list($name, $selected_id=null, $all_option=false, $submit_on_change=false)
{
	global $location_status;

return array_selector($name, $selected_id, $location_status, 
		array( 'spec_option'=> _("Select"),
			'spec_id' => -1,'select_submit'=> true, 'async' => false ) );
}

function status_list_cells($label, $name, $selected_id=null, $all_option=false, $submit_on_change=false)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	
	echo status_list($name, $selected_id, $all_option, $submit_on_change);
	
}

function status_list_row($label, $name, $selected_id=null, $all_option=false, $submit_on_change=false)
{
	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	status_list_cells(null, $name, $selected_id, $all_option, $submit_on_change);
	echo "</div></div>\n";
}

function delivery_locations_list($name, $selected_id=null, 
	$all_option = true, $enabled=true, $submit_on_change=false, $editkey = false)
{
	global $all_items;

	$sql = "SELECT loc_code, location_name, inactive FROM ".TB_PREF."locations";
        
	if ($editkey)
		set_editor('location', $name, $editkey);

return combo_input($name, $selected_id, $sql, 'loc_code', 'location_name',
	array(
		'spec_option' => $all_option === true ? _("Select a Location") : $all_option,
		'spec_id' => $all_items,
		'select_submit'=> $submit_on_change
	) );
	if ($editkey)
		$ret .= add_edit_combo('location');	
}
	
function delivery_locations_list_cells($label, $name, $selected_id=null, 
	$all_option = true, $enabled=true, $submit_on_change=false, $editkey = false)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	
	echo delivery_locations_list($name, $selected_id, $all_option, $enabled, 
		$submit_on_change, $editkey);
	
}

function delivery_locations_list_row($label, $name, $selected_id=null, 
	$all_option = true, $enabled=true, $submit_on_change=false, $editkey = false)
{
	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	delivery_locations_list_cells(null, $name, $selected_id, $all_option, $enabled, 
		$submit_on_change, $editkey);
	echo "</div></div>\n";
}

//-----------------------------------------------------------------------------------------------

function currencies_list($name, $selected_id=null, $submit_on_change=false)
{
	$sql = "SELECT curr_abrev, currency, inactive FROM ".TB_PREF."currencies";

// default to the company currency
return combo_input($name, $selected_id, $sql, 'curr_abrev', 'currency',
	array(
		'select_submit'=> $submit_on_change,
		'default' => get_company_currency(),
		'async' => false		
	) );
}

function currencies_list_cells($label, $name, $selected_id=null, $submit_on_change=false)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	
	echo currencies_list($name, $selected_id, $submit_on_change);
	
}

function currencies_list_row($label, $name, $selected_id=null, $submit_on_change=false)
{
	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	currencies_list_cells(null, $name, $selected_id, $submit_on_change);
	echo "</div></div>\n";
}

//---------------------------------------------------------------------------------------------------

function fiscalyears_list($name, $selected_id=null, $submit_on_change=false)
{

	$sql = "SELECT * FROM ".TB_PREF."fiscal_year";

// default to the company current fiscal year

return combo_input($name, $selected_id, $sql, 'id', '',
	array(
		'order' => 'begin',
		'default' => get_company_pref('f_year'),
		'format' => '_format_fiscalyears',
		'select_submit'=> $submit_on_change,
		'async' => false
	) );
}

function _format_fiscalyears($row)
{
	return sql2date($row[1]) . "&nbsp;-&nbsp;" . sql2date($row[2])
	. "&nbsp;&nbsp;" . ($row[3] ? _('Closed') : _('Active')) . "</option>\n";
}

function fiscalyears_list_cells($label, $name, $selected_id=null)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	
	echo fiscalyears_list($name, $selected_id);
	
}

function fiscalyears_list_row($label, $name, $selected_id=null)
{
	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	fiscalyears_list_cells(null, $name, $selected_id);
	echo "</div></div>\n";
}
//------------------------------------------------------------------------------------

function dimensions_list($name, $selected_id=null, $no_option=false, $showname=' ',
	$submit_on_change=false, $showclosed=false, $showtype=1)
{
$sql = "SELECT id, CONCAT(reference,'  ',name) as ref FROM ".TB_PREF."dimensions";

$options = array(
	'order' => 'reference',
	'spec_option'=>$no_option ? $showname : false,
	'spec_id' => 0,
	'select_submit'=> $submit_on_change,
	'async' => false,
	);

	if (!$showclosed)
		$options['where'][] = "closed=0";
	if($showtype)
		$options['where'][] = "type_=".db_escape($showtype);

	return combo_input($name, $selected_id, $sql, 'id', 'ref', $options);
}

function dimensions_list_cells($label, $name, $selected_id=null, $no_option=false, $showname=null,
	$showclosed=false, $showtype=0, $submit_on_change=false)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	
	echo dimensions_list($name, $selected_id, $no_option, $showname, $submit_on_change, $showclosed, $showtype);
	
}

function dimensions_list_row($label, $name, $selected_id=null, $no_option=false, $showname=null,
	$showclosed=false, $showtype=0, $submit_on_change=false)
{
	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	dimensions_list_cells(null, $name, $selected_id, $no_option, $showname,
		$showclosed, $showtype, $submit_on_change);
	echo "</div></div>\n";
}

//---------------------------------------------------------------------------------------------------

function stock_items_list($name, $selected_id=null, $all_option=false, 
	$submit_on_change=false, $opts=array(), $editkey = false)
{
	global $all_items;

	$sql = "SELECT stock_id, s.description, c.description, s.inactive, s.editable
			FROM ".TB_PREF."stock_master s,".TB_PREF."stock_category c WHERE s.category_id=c.category_id";

	if ($editkey)
		set_editor('item', $name, $editkey);

	$ret = combo_input($name, $selected_id, $sql, 'stock_id', 's.description',
	array_merge(
	  array(
		'format' => '_format_stock_items',
		'spec_option' => $all_option===true ?  _("All Items") : $all_option,
		'spec_id' => $all_items,
		'search_box' => true,
		'search' => array("stock_id", "c.description","s.description"),
		'search_submit' => get_company_pref('no_item_list')!=0,
		
		'select_submit'=> $submit_on_change,
		'category' => 2,
		'order' => array('c.description','stock_id')
	  ), $opts) );
	if ($editkey)
		$ret .= add_edit_combo('item');		
	return $ret;
	  
}

function vehicle_stock_list($name, $selected_id=null, $all_option=false, 
	$submit_on_change=false, $opts=array(), $editkey = false)
{
	global $all_items;

	$sql = "SELECT vehicle_id, s.description, c.vehicle_description, s.inactive, s.editable
			FROM ".TB_PREF."vehicles_master s,".TB_PREF."vehicle_types c WHERE s.vehicle_type_id=c.vehicle_type_code";

	if ($editkey)
		set_editor('item', $name, $editkey);

	$ret = combo_input($name, $selected_id, $sql, 'vehicle_id', 's.description',
	array_merge(
	  array(
		'format' => '_format_stock_items',
		'spec_option' => $all_option===true ?  _("All Items") : $all_option,
		'spec_id' => $all_items,
		'search_box' => true,
		'search' => array("vehicle_id", "c.vehicle_description","s.description"),
		'search_submit' => get_company_pref('no_item_list')!=0,
		
		'select_submit'=> $submit_on_change,
		'category' => 2,
		'order' => array('c.vehicle_description','vehicle_id')
	  ), $opts) );
	if ($editkey)
		$ret .= add_edit_combo('item');		
	return $ret;
	  
}

function _format_stock_items($row)
{
	return (user_show_codes() ?  ($row[0] . "&nbsp;-&nbsp;") : "") . $row[1];
}

function stock_items_list_cells($label, $name, $selected_id=null, $all_option=false, 
	$submit_on_change=false, $all=false, $editkey = false)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	echo stock_items_list($name, $selected_id, $all_option, $submit_on_change,
		array('cells'=>true, 'show_inactive'=>$all), $editkey);
}

function stock_items_list_row($label, $name, $selected_id=null, $all_option=false, $submit_on_change=false)
{
	echo "<tr>\n";
	stock_items_list_cells($label, $name, $selected_id, $all_option, $submit_on_change);
	echo "</div>\n";
}


function transport_item_list($name, $selected_id=null, $spec_option=false, $submit_on_change=false, 
	$show_inactive=false, $editkey = false)
{
	global $all_items;

	$sql = "SELECT stock_id,description ,inactive FROM ".TB_PREF."transport_items_master";


	$ret = combo_input($name, $selected_id, $sql, 'stock_id', 'description',
	array(
	  
	    'order' => array('description'),
		
		'type' => 1,
		
		'spec_option' => $spec_option === true ? _("All transport_items") : $spec_option,
		'spec_id' => $all_items,
		'select_submit'=> $submit_on_change,
		'async' => false,
		
		'show_inactive' => $show_inactive
	) );
	if ($editkey)
		$ret .= add_edit_combo('transport_item');
	return $ret;
}

function transport_item_list_cells($label, $name, $selected_id=null, $all_option=false, 
	$submit_on_change=false, $show_inactive=false, $editkey = false)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	echo "<td nowrap>";
	echo transport_item_list($name, $selected_id, $all_option, $submit_on_change,
		$show_inactive, $editkey);
	
}

function transport_item_list_row($label, $name, $selected_id=null, $all_option = false, 
	$submit_on_change=false, $show_inactive=false, $editkey = false)
{
	global $path_to_root;

	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	echo transport_item_list($name, $selected_id, $all_option, $submit_on_change,
		$show_inactive, $editkey);
	echo "</div></div>\n";
}
function component_item_list($name, $selected_id=null, $spec_option=false, $submit_on_change=false, 
	$show_inactive=false, $editkey = false)
{
	global $all_items;

	$sql = "SELECT stock_id,description ,inactive FROM ".TB_PREF."stock_master WHERE category_id=1 ";


	$ret = combo_input($name, $selected_id, $sql, 'stock_id', 'description',
	array(
	  
	    'order' => array('description'),
		
		'type' => 1,
		
		'spec_option' => $spec_option === true ? _("All component_items") : $spec_option,
		'spec_id' => $all_items,
		'select_submit'=> $submit_on_change,
		'async' => false,
		
		'show_inactive' => $show_inactive
	) );
	if ($editkey)
		$ret .= add_edit_combo('component_item');
	return $ret;
}

function component_item_list_cells($label, $name, $selected_id=null, $all_option=false, 
	$submit_on_change=false, $show_inactive=false, $editkey = false)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	echo "<td nowrap>";
	echo component_item_list($name, $selected_id, $all_option, $submit_on_change,
		$show_inactive, $editkey);
	
}

function component_item_list_row($label, $name, $selected_id=null, $all_option = false, 
	$submit_on_change=false, $show_inactive=false, $editkey = false)
{
	global $path_to_root;

	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	echo component_item_list($name, $selected_id, $all_option, $submit_on_change,
		$show_inactive, $editkey);
	echo "</div></div>\n";
}
function material_item_list($name, $selected_id=null, $spec_option=false, $submit_on_change=false, 
	$show_inactive=false, $editkey = false)
{
	global $all_items;

	$sql = "SELECT stock_id,description ,inactive FROM ".TB_PREF."stock_master WHERE category_id=7 ";


	$ret = combo_input($name, $selected_id, $sql, 'stock_id', 'description',
	array(
	  
	    'order' => array('description'),
		
		'type' => 1,
		
		'spec_option' => $spec_option === true ? _("All material_items") : $spec_option,
		'spec_id' => $all_items,
		'select_submit'=> $submit_on_change,
		'async' => false,
		
		'show_inactive' => $show_inactive
	) );
	if ($editkey)
		$ret .= add_edit_combo('material_item');
	return $ret;
}

function material_item_list_cells($label, $name, $selected_id=null, $all_option=false, 
	$submit_on_change=false, $show_inactive=false, $editkey = false)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	echo "<td nowrap>";
	echo material_item_list($name, $selected_id, $all_option, $submit_on_change,
		$show_inactive, $editkey);
	
}

function material_item_list_row($label, $name, $selected_id=null, $all_option = false, 
	$submit_on_change=false, $show_inactive=false, $editkey = false)
{
	global $path_to_root;

	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	echo material_item_list($name, $selected_id, $all_option, $submit_on_change,
		$show_inactive, $editkey);
	echo "</div></div>\n";
}
function stock_categories_transport_list($name, $selected_id=null, $spec_opt=false, $submit_on_change=false)
{
	$sql = "SELECT category_id, description, inactive FROM ".TB_PREF."stock_category where category_id=6";
	return combo_input($name, $selected_id, $sql, 'category_id', 'description',
 	array('order'=>'category_id',
		'spec_option' => $spec_opt,
		'spec_id' => -1,
 		'select_submit'=> $submit_on_change,
 		'async' => true
 	));
}

function stock_categories_transport_list_cells($label, $name, $selected_id=null, $spec_opt=false, $submit_on_change=false)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	
	echo stock_categories_transport_list($name, $selected_id, $spec_opt, $submit_on_change);
	
}

function stock_categories_transport_list_row($label, $name, $selected_id=null, $spec_opt=false, $submit_on_change=false)
{
	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	stock_categories_transport_list_cells(null, $name, $selected_id, $spec_opt, $submit_on_change);
	echo "</div></div>\n";
}
function stock_categories_material_list($name, $selected_id=null, $spec_opt=false, $submit_on_change=false)
{
	$sql = "SELECT category_id, description, inactive FROM ".TB_PREF."stock_category where category_id=7";
	return combo_input($name, $selected_id, $sql, 'category_id', 'description',
 	array('order'=>'category_id',
		'spec_option' => $spec_opt,
		'spec_id' => -1,
 		'select_submit'=> $submit_on_change,
 		'async' => true
 	));
}

function stock_categories_material_list_cells($label, $name, $selected_id=null, $spec_opt=false, $submit_on_change=false)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	
	echo stock_categories_material_list($name, $selected_id, $spec_opt, $submit_on_change);
	
}

function stock_categories_material_list_row($label, $name, $selected_id=null, $spec_opt=false, $submit_on_change=false)
{
	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	stock_categories_material_list_cells(null, $name, $selected_id, $spec_opt, $submit_on_change);
	echo "</div></div>\n";
}

function stock_categories_component_list($name, $selected_id=null, $spec_opt=false, $submit_on_change=false)
{
	$sql = "SELECT category_id, description, inactive FROM ".TB_PREF."stock_category where category_id=1";
	return combo_input($name, $selected_id, $sql, 'category_id', 'description',
 	array('order'=>'category_id',
		'spec_option' => $spec_opt,
		'spec_id' => -1,
 		'select_submit'=> $submit_on_change,
 		'async' => true
 	));
}

function stock_categories_component_list_cells($label, $name, $selected_id=null, $spec_opt=false, $submit_on_change=false)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	
	echo stock_categories_component_list($name, $selected_id, $spec_opt, $submit_on_change);
	
}

function stock_categories_component_list_row($label, $name, $selected_id=null, $spec_opt=false, $submit_on_change=false)
{
	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	stock_categories_component_list_cells(null, $name, $selected_id, $spec_opt, $submit_on_change);
	echo "</div></div>\n";
}

//---------------------------------------------------------------------------------------------------
//
// Select item via foreign code.
//
function transport_items_list($name, $selected_id=null, $all_option=false, 
	$submit_on_change=false, $type='', $opts=array())
{
	global $all_items;
	// all transport codes
	$sql = "SELECT i.item_code, i.description, i.category_description, count(*)>1 as kit,
			 i.inactive, if(count(*)>1, '0', s.editable) as editable
			FROM
			".TB_PREF."transport_items_master s,
			".TB_PREF."transport_item_codes i
			
			WHERE i.stock_id=s.stock_id";

	
	if ($type == 'local')	{ // exclude foreign codes
		$sql .=	" AND !i.is_foreign"; 
	} elseif ($type == 'kits') { // transport kits
		$sql .=	" AND !i.is_foreign AND i.item_code!=i.stock_id";
	}
	$sql .= " AND !i.inactive AND !s.inactive AND !s.no_sale";
	$sql .= " GROUP BY i.item_code";

	return combo_input($name, $selected_id, $sql, 'i.item_code', 'i.category_description',
	array_merge(
	  array(
		'format' => '_format_stock_items',
		'spec_option' => $all_option===true ?  _("All Items") : $all_option,
		'spec_id' => $all_items,
		'search_box' => true,
		'search' => array("i.item_code", "i.category_description", "i.description"),
		'search_submit' => get_company_pref('no_item_list')!=0,
		'size'=>15,
		'select_submit'=> $submit_on_change,
		'category' => 2,
		'order' => array('i.category_description','i.item_code'),
		'editable' => 30,
		'max' => 255
	  ), $opts) );
}

function transport_items_list_cells($label, $name, $selected_id=null, $all_option=false, $submit_on_change=false, $editkey=false)
{
	if ($editkey)
		set_editor('item', $name, $editkey);

	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	echo transport_items_list($name, $selected_id, $all_option, $submit_on_change,
		'', array('cells'=>true));
}

function transport_kits_list($name, $selected_id=null, $all_option=false, $submit_on_change=false)
{
	return transport_items_list($name, $selected_id, $all_option, $submit_on_change,
		'kits', array('cells'=>false, 'editable' => false));
}

function transport_local_items_list_row($label, $name, $selected_id=null, $all_option=false, $submit_on_change=false)
{
	echo "<tr>";
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	
	echo transport_items_list($name, $selected_id, $all_option, $submit_on_change,
		'local', array('cells'=>false, 'editable' => false));
	echo "</td></tr>";
}
//------------------------------------------------------------------------------------

function stock_manufactured_items_list($name, $selected_id=null,
	$all_option=false, $submit_on_change=false)
{
	return stock_items_list($name, $selected_id, $all_option, $submit_on_change,
		array('where'=>array("mb_flag= 'M'")));
}

function stock_manufactured_items_list_cells($label, $name, $selected_id=null,
				$all_option=false, $submit_on_change=false)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	
	echo stock_manufactured_items_list($name, $selected_id, $all_option, $submit_on_change);
	
}

function stock_manufactured_items_list_row($label, $name, $selected_id=null,
		$all_option=false, $submit_on_change=false)
{
	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	stock_manufactured_items_list_cells(null, $name, $selected_id, $all_option, $submit_on_change);
	echo "</div></div>\n";
}
//------------------------------------------------------------------------------------

function stock_component_items_list($name, $parent_stock_id, $selected_id=null,
	$all_option=false, $submit_on_change=false, $editkey = false)
{
	return stock_items_list($name, $selected_id, $all_option, $submit_on_change,
		array('where'=>array("stock_id != ".db_escape($parent_stock_id))), $editkey);
}

function stock_component_items_list_cells($label, $name, $parent_stock_id, 
	$selected_id=null, $all_option=false, $submit_on_change=false, $editkey = false)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	echo stock_items_list($name, $selected_id, $all_option, $submit_on_change,
		array('where'=>array("stock_id != ".db_escape($parent_stock_id)), 'cells'=>true),
		$editkey);
}
//------------------------------------------------------------------------------------

function stock_costable_items_list($name, $selected_id=null,
	$all_option=false, $submit_on_change=false)
{
	return stock_items_list($name, $selected_id, $all_option, $submit_on_change,
		array('where'=>array("mb_flag!='D'")));
}

function stock_costable_items_list_cells($label, $name, $selected_id=null, 
	$all_option=false, $submit_on_change=false)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	echo stock_items_list($name, $selected_id, $all_option, $submit_on_change,
		array('where'=>array("mb_flag!='D'"), 'cells'=>true));
}
function stock_transport_vehicles_list($name, $selected_id=null,
	$all_option=false, $submit_on_change=false)
{
	return vehicle_stock_list($name, $selected_id, $all_option, $submit_on_change);
}
function stock_transport_vehicles_list_cells($label, $name, $selected_id=null, 
	$all_option=false, $submit_on_change=false)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	echo stock_items_list($name, $selected_id, $all_option, $submit_on_change,
		array('where'=>array("c.category_id=5"), 'cells'=>true));
}
function stock_bom_vehicles_list($label, $name, $selected_id=null, 
	$all_option=false, $submit_on_change=false)
{
	return stock_items_list($name, $selected_id, $all_option, $submit_on_change,
		array('where'=>array("c.category_id in(1,7)")));
}
//------------------------------------------------------------------------------------
function stock_purchasable_items_list($name, $selected_id=null,	
	$all_option=false, $submit_on_change=false, $all=false, $editkey=false)
{
	return stock_items_list($name, $selected_id, $all_option, $submit_on_change,
		array('where'=>array("mb_flag!= 'M'"), 
			'show_inactive'=>$all), $editkey);
}
//
//	This helper is used in PO/GRN/PI entry and supports editable descriptions.
//
function stock_purchasable_items_list_cells($label, $name, $selected_id=null,
			$all_option=false, $submit_on_change=false, $editkey=false)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	echo stock_items_list($name, $selected_id, $all_option, $submit_on_change,
		array('where'=>array("mb_flag!= 'M'"), 
			 'editable' => 30,
			 'cells'=>true), $editkey);
}
/*
function stock_purchasable_items_list_row($label, $name, $selected_id=null,
			$all_option=false, $submit_on_change=false, $editkey=false)
{
	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	stock_purchasable_items_list_cells(null, $name, $selected_id=null,
		$all_option, $submit_on_change, $editkey);
	echo "</div></div>\n";
}
*/
//------------------------------------------------------------------------------------

function stock_item_types_list_row($label, $name, $selected_id=null, $enabled=true)
{
	global $stock_types;

	echo "<div class='form-group'>";
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	

	echo array_selector($name, $selected_id, $stock_types, 
		array( 
			'select_submit'=> true, 
			'disabled' => !$enabled) );
	echo "</div>\n";
}
function stock_delivery_list_row($label,$name, $selected_id=null, $spec_option=false, $submit_on_change=false, 
	$show_inactive=false, $editkey = false)
{
	global $delivery_dtls;

	echo "<div class='form-group'>";
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	

	echo array_selector($name, $selected_id, $delivery_dtls, 
		array( 
			 'format' => '_format_add_curr',
	    'order' => array('consignor_ref'),
		
		'type' => 1,
		
		'spec_option' => $spec_option === true ? _("Select a Customer") : $spec_option,
		
		'select_submit'=> $submit_on_change,
		'async' => false,
		
		_('Select customer'),
		'show_inactive' => $show_inactive
			) );
	echo "</div>\n";
}

function stock_time_types_list_row($label, $name, $selected_id=null, $enabled=true)
{
	global $time_types;

	echo "<div class='form-group'>";
	if ($label != null)
	{
		echo "<label class='col-md-3 control-label'>$label</label>\n";
		}
	else 
	{
		echo "<label class='label'></label>\n";
	}
	

	echo array_selector($name, $selected_id, $time_types, 
		array( 
			
			'disabled' => !$enabled) );
	echo "</div>\n";
}

function stock_vehicle_purchase_dtls_list_row($label, $name, $selected_id=null, $enabled=true)
{
	global $purchs_dtls;

	echo "<div class='form-group'>";
	if ($label != null)
	{
		echo "<label class='col-md-3 control-label'>$label</label>\n";
		}
	else 
	{
		echo "<label class='label'></label>\n";
	}
	

	echo array_selector($name, $selected_id, $purchs_dtls, 
		array( 
			
			'disabled' => !$enabled) );
	echo "</div>\n";
}
function stock_units_list_row($label, $name, $value=null, $enabled=true)
{
	$result = get_all_item_units();
	echo "<div class='form-group'>";
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label><div class='col-md-6'>\n";
	

	while($unit = db_fetch($result))
		$units[$unit['abbr']] = $unit['name'];

	echo array_selector($name, $value, $units, array( 'disabled' => !$enabled) );

	echo "</div></div>\n";
}

function stock_units_list_cells($label, $name, $value=null, $enabled=true)
{
	$result = get_all_item_units();

	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	

	while($unit = db_fetch($result))
		$units[$unit['abbr']] = $unit['name'];

	echo array_selector($name, $value, $units, array( 'disabled' => !$enabled) );

	
}


//------------------------------------------------------------------------------------

function tax_types_list($name, $selected_id=null, $none_option=false, $submit_on_change=false)
{
	$sql = "SELECT id, CONCAT(name, ' (',rate,'%)') as name FROM ".TB_PREF."tax_types";

	return combo_input($name, $selected_id, $sql, 'id', 'name',
	array(
		'spec_option' => $none_option,
		'spec_id' => ALL_NUMERIC,
		'select_submit'=> $submit_on_change,
		'async' => false,
	) );
}

function tax_types_list_cells($label, $name, $selected_id=null, $none_option=false,
	$submit_on_change=false)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	
	echo tax_types_list($name, $selected_id, $none_option, $submit_on_change);
	
}

function tax_types_list_row($label, $name, $selected_id=null, $none_option=false,
	$submit_on_change=false)
{
	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	tax_types_list_cells(null, $name, $selected_id, $none_option, $submit_on_change);
	echo "</div></div>\n";
}

//------------------------------------------------------------------------------------

function tax_groups_list($name, $selected_id=null,
	$none_option=false, $submit_on_change=false)
{
	$sql = "SELECT id, name FROM ".TB_PREF."tax_groups";

	return combo_input($name, $selected_id, $sql, 'id', 'name',
	array(
		'order' => 'id',
		'spec_option' => $none_option,
		'spec_id' => ALL_NUMERIC,
		'select_submit'=> $submit_on_change,
		'async' => false,
	) );
}

function tax_groups_list_cells($label, $name, $selected_id=null, $none_option=false, $submit_on_change=false)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	
	echo tax_groups_list($name, $selected_id, $none_option, $submit_on_change);
	
}

function tax_groups_list_row($label, $name, $selected_id=null, $none_option=false, $submit_on_change=false)
{
	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	tax_groups_list_cells(null, $name, $selected_id, $none_option, $submit_on_change);
	echo "</div></div>\n";
}

//------------------------------------------------------------------------------------

function item_tax_types_list($name, $selected_id=null)
{
	$sql ="SELECT id, name FROM ".TB_PREF."item_tax_types";
	return combo_input($name, $selected_id, $sql, 'id', 'name', array('order' => 'id') );
}

function item_tax_types_list_cells($label, $name, $selected_id=null)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	
	echo item_tax_types_list($name, $selected_id);
	
}

function item_tax_types_list_row($label, $name, $selected_id=null)
{
	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	item_tax_types_list_cells(null, $name, $selected_id);
	echo "</div></div>\n";
}

//------------------------------------------------------------------------------------

function shippers_list($name, $selected_id=null)
{
	$sql = "SELECT shipper_id, shipper_name, inactive FROM ".TB_PREF."shippers";
	return combo_input($name, $selected_id, $sql, 'shipper_id', 'shipper_name', 
		array('order'=>array('shipper_name')));
}

function shippers_list_cells($label, $name, $selected_id=null)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	
	echo shippers_list($name, $selected_id);
	
}

function shippers_list_row($label, $name, $selected_id=null)
{
	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	shippers_list_cells(null, $name, $selected_id);
	echo "</div></div>\n";
}

//-------------------------------------------------------------------------------------

function transport_persons_list($name, $selected_id=null, $spec_opt=false)
{
	$sql = "SELECT transportman_code, transportman_name, inactive FROM ".TB_PREF."transportman";
	return combo_input($name, $selected_id, $sql, 'transportman_code', 'transportman_name', 
		array('order'=>array('transportman_name'),
			'spec_option' => $spec_opt,
			'spec_id' => ALL_NUMERIC));
}

function transport_persons_list_cells($label, $name, $selected_id=null, $spec_opt=false)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	
	echo transport_persons_list($name, $selected_id, $spec_opt);
	
}

function transport_persons_list_row($label, $name, $selected_id=null, $spec_opt=false)
{
	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	transport_persons_list_cells(null, $name, $selected_id, $spec_opt);
	echo "</div></div>\n";
}

//------------------------------------------------------------------------------------

function transport_areas_list($name, $selected_id=null)
{
	$sql = "SELECT area_code, description, inactive FROM ".TB_PREF."areas";
	return combo_input($name, $selected_id, $sql, 'area_code', 'description', array());
}

function transport_areas_list_cells($label, $name, $selected_id=null)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	
	echo transport_areas_list($name, $selected_id);
	
}

function transport_areas_list_row($label, $name, $selected_id=null)
{
	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	transport_areas_list_cells(null, $name, $selected_id);
	echo "</div></div>\n";
}

//------------------------------------------------------------------------------------

function transport_groups_list($name, $selected_id=null, $special_option=false)
{
	$sql = "SELECT id, description, inactive FROM ".TB_PREF."groups";
	return combo_input($name, $selected_id, $sql, 'id', 'description', array(
		'spec_option' => $special_option===true ? ' ' : $special_option,
		'order' => 'description', 'spec_id' => 0,
	));
}

function transport_groups_list_cells($label, $name, $selected_id=null, $special_option=false)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	
	echo transport_groups_list($name, $selected_id, $special_option);
	
}

function transport_groups_list_row($label, $name, $selected_id=null, $special_option=false)
{
	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	transport_groups_list_cells(null, $name, $selected_id, $special_option);
	echo "</div></div>\n";
}

//------------------------------------------------------------------------------------

function _format_template_items($row)
{
	return ($row[0] . "&nbsp;- &nbsp;" . _("Amount") . "&nbsp;".$row[1]);
}

function templates_list($name, $selected_id=null, $special_option=false)
{
	$sql = "SELECT sorder.order_no,	Sum(line.unit_price*line.quantity*(1-line.discount_percent)) AS OrderValue
		FROM ".TB_PREF."transport_orders as sorder, ".TB_PREF."transport_order_details as line
		WHERE sorder.order_no = line.order_no AND sorder.type = 1 GROUP BY line.order_no";
	return combo_input($name, $selected_id, $sql, 'order_no', 'OrderValue', array(
		'format' => '_format_template_items',
		'spec_option' => $special_option===true ? ' ' : $special_option,
		'order' => 'order_no', 'spec_id' => 0,
	));
}

function templates_list_cells($label, $name, $selected_id=null, $special_option=false)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	
	echo templates_list($name, $selected_id, $special_option);
	
}

function templates_list_row($label, $name, $selected_id=null, $special_option=false)
{
	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	templates_list_cells(null, $name, $selected_id, $special_option);
	echo "</div></div>\n";
}

//------------------------------------------------------------------------------------

function workorders_list($name, $selected_id=null)
{
	$sql = "SELECT id, wo_ref FROM ".TB_PREF."workorders WHERE closed=0";
	return combo_input($name, $selected_id, $sql, 'id', 'wo_ref', array());
}

function workorders_list_cells($label, $name, $selected_id=null)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	
	echo workorders_list($name, $selected_id);
	
}

function workorders_list_row($label, $name, $selected_id=null)
{
	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	workorders_list_cells(null, $name, $selected_id);
	echo "</div></div>\n";
}

//------------------------------------------------------------------------------------

function payment_terms_list($name, $selected_id=null)
{
	$sql = "SELECT terms_indicator, terms, inactive FROM ".TB_PREF."payment_terms";
	return combo_input($name, $selected_id, $sql, 'terms_indicator', 'terms', array());
}

function payment_terms_list_cells($label, $name, $selected_id=null)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	
	echo payment_terms_list($name, $selected_id);
	
}

function payment_terms_list_row($label, $name, $selected_id=null)
{
	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	payment_terms_list_cells(null, $name, $selected_id);
	echo "</div></div>\n";
}

//------------------------------------------------------------------------------------

function credit_status_list($name, $selected_id=null)
{
	$sql ="SELECT id, reason_description, inactive FROM ".TB_PREF."credit_status";
	return combo_input($name, $selected_id, $sql, 'id', 'reason_description', array());
}

function credit_status_list_cells($label, $name, $selected_id=null)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	
	echo credit_status_list($name, $selected_id);
	
}

function credit_status_list_row($label, $name, $selected_id=null)
{
	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	credit_status_list_cells(null, $name, $selected_id);
	echo "</div></div>\n";
}

//-----------------------------------------------------------------------------------------------

function transport_types_list($name, $selected_id=null, $submit_on_change=false, $special_option=false)
{
	$sql = "SELECT id, transport_type, inactive FROM ".TB_PREF."transport_types";

	return combo_input($name, $selected_id, $sql, 'id', 'transport_type',
	array(
		'spec_option' => $special_option===true ? _("All Transport Types") : $special_option,
		'spec_id' => 0,
		'select_submit'=> $submit_on_change,
	//	  'async' => false,
	) );
}

function transport_types_list_cells($label, $name, $selected_id=null, $submit_on_change=false, $special_option=false)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	
	echo transport_types_list($name, $selected_id, $submit_on_change, $special_option);
	
}

function transport_types_list_row($label, $name, $selected_id=null, $submit_on_change=false, $special_option=false)
{
	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	transport_types_list_cells(null, $name, $selected_id, $submit_on_change, $special_option);
	echo "</div></div>\n";
}

//-----------------------------------------------------------------------------------------------

function movement_types_list($name, $selected_id=null)
{
	$sql = "SELECT id, name FROM ".TB_PREF."movement_types";
	return combo_input($name, $selected_id, $sql, 'id', 'name', array());
}

function movement_types_list_cells($label, $name, $selected_id=null)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	
	echo movement_types_list($name, $selected_id);
	
}

function movement_types_list_row($label, $name, $selected_id=null)
{
	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	movement_types_list_cells(null, $name, $selected_id);
	echo "</div></div>\n";
}

//-----------------------------------------------------------------------------------------------
function _format_date($row)
{
	return sql2date($row['reconciled']);
}

function bank_reconciliation_list($account, $name, $selected_id=null, $submit_on_change=false, $special_option=false)
{
	$sql = "SELECT reconciled, reconciled FROM ".TB_PREF."bank_trans
		WHERE bank_act=".db_escape($account)." AND reconciled IS NOT NULL
		GROUP BY reconciled";
	return combo_input($name, $selected_id, $sql, 'id', 'reconciled',
	array(
		'spec_option' => $special_option,
		'format' => '_format_date',
		'spec_id' => '',
		'select_submit'=> $submit_on_change
	) );
}

function bank_reconciliation_list_cells($label,$account, $name, $selected_id=null, $submit_on_change=false, $special_option=false)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	
	echo bank_reconciliation_list($account, $name, $selected_id, $submit_on_change, $special_option);
	
}
/*
function bank_reconciliation_list_row($label, $account, $name, $selected_id=null, $submit_on_change=false, $special_option=false)
{
	echo "<tr>\n";
	bank_reconciliation_list_cells($label, $account, $name, $selected_id, $submit_on_change, $special_option);
	echo "</div>\n";
}
*/
//-----------------------------------------------------------------------------------------------

function workcenter_list($name, $selected_id=null, $all_option=false)
{
	global $all_items;

	$sql = "SELECT id, name, inactive FROM ".TB_PREF."workcentres";

	return combo_input($name, $selected_id, $sql, 'id', 'name',
	array(
		'spec_option' =>$all_option===true ? _("All Vendors") : $all_option,
		'spec_id' => $all_items,
	) );
}

function workcenter_list_cells($label, $name, $selected_id=null, $all_option=false)
{
	default_focus($name);
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	
	echo workcenter_list($name, $selected_id, $all_option);
	
}

function workcenter_list_row($label, $name, $selected_id=null, $all_option=false)
{
	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	workcenter_list_cells(null, $name, $selected_id, $all_option);
	echo "</div></div>\n";
}

//-----------------------------------------------------------------------------------------------

function bank_accounts_list($name, $selected_id=null, $submit_on_change=false, $spec_option=false)
{
	$sql = "SELECT ".TB_PREF."bank_accounts.id, bank_account_name, bank_curr_code, inactive
		FROM ".TB_PREF."bank_accounts";

	return combo_input($name, $selected_id, $sql, 'id', 'bank_account_name',
	array(
		'format' => '_format_add_curr',
		'select_submit'=> $submit_on_change,
		'spec_option' => $spec_option,
		'spec_id' => '',
		'async' => false
	) );
}

function bank_accounts_list_cells($label, $name, $selected_id=null, $submit_on_change=false)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	
	echo bank_accounts_list($name, $selected_id, $submit_on_change);
	
}

function bank_accounts_list_row($label, $name, $selected_id=null, $submit_on_change=false)
{
	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	bank_accounts_list_cells(null, $name, $selected_id, $submit_on_change);
	echo "</div></div>\n";
}
//-----------------------------------------------------------------------------------------------

function cash_accounts_list_row($label, $name, $selected_id=null, $submit_on_change=false)
{
	$sql = "SELECT ".TB_PREF."bank_accounts.id, bank_account_name, bank_curr_code, inactive
		FROM ".TB_PREF."bank_accounts
		WHERE ".TB_PREF."bank_accounts.account_type=".BT_CASH;

	if ($label != null)
		echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>\n";
	
	echo combo_input($name, $selected_id, $sql, 'id', 'bank_account_name',
	array(
		'format' => '_format_add_curr',
		'select_submit'=> $submit_on_change,
		'async' => true
	) );
	echo "</div></div>\n";
}
//-----------------------------------------------------------------------------------------------

function pos_list_row($label, $name, $selected_id=null, $spec_option=false, $submit_on_change=false)
{
	$sql = "SELECT id, pos_name, inactive FROM ".TB_PREF."transport_pos";

	default_focus($name);
	echo "<div class='form-group'>";
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label><div class='col-md-6'>\n";
	

	echo combo_input($name, $selected_id, $sql, 'id', 'pos_name',
	array(
		'select_submit'=> $submit_on_change,
		'async' => true,
		'spec_option' =>$spec_option,
		'spec_id' => -1,
		'order'=> array('pos_name')
	) );
	echo "</div></div>\n";

}
//-----------------------------------------------------------------------------------------------
// Payment type selector for current user.
//
function sale_payment_list($name, $category, $selected_id=null, $submit_on_change=true)
{
	$sql = "SELECT terms_indicator, terms, inactive FROM ".TB_PREF."payment_terms";
	
	if ($category == PM_CASH) // only cash
			$sql .= " WHERE days_before_due=0 AND day_in_following_month=0";
	if ($category == PM_CREDIT) // only delayed payments
			$sql .= " WHERE days_before_due!=0 OR day_in_following_month!=0";

	return combo_input($name, $selected_id, $sql, 'terms_indicator', 'terms',
	array(
		'select_submit'=> $submit_on_change,
		'async' => true
	) );

}

function sale_payment_list_cells($label, $name, $category, $selected_id=null, $submit_on_change=true)
{
	echo "<div class='form-group'>";
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label><div class='col-md-6'>\n";
	

	echo sale_payment_list($name, $category, $selected_id, $submit_on_change);
	echo "</div></div>\n";
	
}
//-----------------------------------------------------------------------------------------------

function class_list($name, $selected_id=null, $submit_on_change=false)
{
	$sql = "SELECT cid, class_name FROM ".TB_PREF."chart_class";

	return combo_input($name, $selected_id, $sql, 'cid', 'class_name',
	array(
		'select_submit'=> $submit_on_change,
		'async' => false
	) );

}

function class_list_cells($label, $name, $selected_id=null, $submit_on_change=false)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	
	echo class_list($name, $selected_id, $submit_on_change);
	
}

function class_list_row($label, $name, $selected_id=null, $submit_on_change=false)
{
	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	class_list_cells(null, $name, $selected_id, $submit_on_change);
	echo "</div></div>\n";
}

//-----------------------------------------------------------------------------------------------
function stock_categories_list($name, $selected_id=null, $spec_opt=false, $submit_on_change=false)
{
	$sql = "SELECT category_id, description, inactive FROM ".TB_PREF."stock_category";
	return combo_input($name, $selected_id, $sql, 'category_id', 'description',
 	array('order'=>'category_id',
		'spec_option' => $spec_opt,
		'spec_id' => -1,
 		'select_submit'=> $submit_on_change,
 		'async' => true
 	));
}

function stock_categories_list_cells($label, $name, $selected_id=null, $spec_opt=false, $submit_on_change=false)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	
	echo stock_categories_list($name, $selected_id, $spec_opt, $submit_on_change);
	
}

function stock_categories_list_row($label, $name, $selected_id=null, $spec_opt=false, $submit_on_change=false)
{
	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	stock_categories_list_cells(null, $name, $selected_id, $spec_opt, $submit_on_change);
	echo "</div></div>\n";
}
function stock_categories_vehicle_list($name, $selected_id=null, $spec_opt=false, $submit_on_change=false)
{
	$sql = "SELECT category_id, description, inactive FROM ".TB_PREF."vehicle_category";
	return combo_input($name, $selected_id, $sql, 'category_id', 'description',
 	array('order'=>'category_id',
		'spec_option' => $spec_opt,
		'spec_id' => -1,
 		'select_submit'=> $submit_on_change,
 		'async' => true
 	));
}

function stock_categories_vehicle_list_cells($label, $name, $selected_id=null, $spec_opt=false, $submit_on_change=false)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	
	echo stock_categories_vehicle_list($name, $selected_id, $spec_opt, $submit_on_change);
	
}

function stock_categories_vehicle_list_row($label, $name, $selected_id=null, $spec_opt=false, $submit_on_change=false)
{
	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	stock_categories_vehicle_list_cells(null, $name, $selected_id, $spec_opt, $submit_on_change);
	echo "</div></div>\n";
}
//-----------------------------------------------------------------------------------------------

function gl_account_types_list($name, $selected_id=null, $all_option=false, $all=true)
{
	global $all_items;

	$sql = "SELECT id, name FROM ".TB_PREF."chart_types";

	return combo_input($name, $selected_id, $sql, 'id', 'name',
	array(
		'format' => '_format_account',
		'order' => array('class_id', 'id', 'parent'),
		'spec_option' =>$all_option,
		'spec_id' => $all_items
	) );
}

function gl_account_types_list_cells($label, $name, $selected_id=null, $all_option=false, $all=false)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	
	echo gl_account_types_list($name, $selected_id, $all_option, $all);
	
}

function gl_account_types_list_row($label, $name, $selected_id=null, $all_option=false,	$all=false)
{
	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	gl_account_types_list_cells(null, $name, $selected_id, $all_option,
		$all);
	echo "</div></div>\n";
}

//-----------------------------------------------------------------------------------------------

function load_status_types_list($name, $selected_id=null, $all_option=false, $all=true)
{
	global $all_items;

	$sql = "SELECT id, name FROM ".TB_PREF."load_status_group_types";

	return combo_input($name, $selected_id, $sql, 'id', 'name',
	array(
		'format' => '_format_account',
		'order' => array('id', 'name'),
		'spec_option' =>$all_option,
		'spec_id' => $all_items
	) );
}

function load_status_types_list_cells($label, $name, $selected_id=null, $all_option=false, $all=false)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	
	echo load_status_types_list($name, $selected_id, $all_option, $all);
	
}

function load_status_types_list_row($label, $name, $selected_id=null, $all_option=false,	$all=false)
{
	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	load_status_types_list_cells(null, $name, $selected_id, $all_option,
		$all);
	echo "</div></div>\n";
}
//-----------------------------------------------------------------------------------------------

function truck_group_types_list($name, $selected_id=null, $all_option=false, $all=true)
{
	global $all_items;

	$sql = "SELECT id, name FROM ".TB_PREF."truck_group_types";

	return combo_input($name, $selected_id, $sql, 'id', 'name',
	array(
		'format' => '_format_account',
		'order' => array('id', 'name'),
		'spec_option' =>$all_option,
		'spec_id' => $all_items
	) );
}

function truck_group_types_list_cells($label, $name, $selected_id=null, $all_option=false, $all=false)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	
	echo truck_group_types_list($name, $selected_id, $all_option, $all);
	
}

function truck_group_types_list_row($label, $name, $selected_id=null, $all_option=false,	$all=false)
{
	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	truck_group_types_list_cells(null, $name, $selected_id, $all_option,
		$all);
	echo "</div></div>\n";
}
//-----------------------------------------------------------------------------------------------

function commodity_group_types_list($name, $selected_id=null, $all_option=false, $all=true)
{
	global $all_items;

	$sql = "SELECT id, name FROM ".TB_PREF."commodity_group_types";

	return combo_input($name, $selected_id, $sql, 'id', 'name',
	array(
		'format' => '_format_account',
		'order' => array('id', 'name'),
		'spec_option' =>$all_option,
		'spec_id' => $all_items
	) );
}

function commodity_group_types_list_cells($label, $name, $selected_id=null, $all_option=false, $all=false)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	
	echo commodity_group_types_list($name, $selected_id, $all_option, $all);
	
}

function commodity_group_types_list_row($label, $name, $selected_id=null, $all_option=false,	$all=false)
{
	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	commodity_group_types_list_cells(null, $name, $selected_id, $all_option,
		$all);
	echo "</div></div>\n";
}
//-----------------------------------------------------------------------------------------------

function truck_length_group_types_list($name, $selected_id=null, $all_option=false, $all=true)
{
	global $all_items;

	$sql = "SELECT id, name FROM ".TB_PREF."truck_length_group_types";

	return combo_input($name, $selected_id, $sql, 'id', 'name',
	array(
		'format' => '_format_account',
		'order' => array('id', 'name'),
		'spec_option' =>$all_option,
		'spec_id' => $all_items
	) );
}

function truck_length_group_types_list_cells($label, $name, $selected_id=null, $all_option=false, $all=false)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	
	echo truck_length_group_types_list($name, $selected_id, $all_option, $all);
	
}

function truck_length_group_types_list_row($label, $name, $selected_id=null, $all_option=false,	$all=false)
{
	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	truck_length_group_types_list_cells(null, $name, $selected_id, $all_option,
		$all);
	echo "</div></div>\n";
}

//-----------------------------------------------------------------------------------------------

function truck_status_group_types_list($name, $selected_id=null, $all_option=false, $all=true)
{
	global $all_items;

	$sql = "SELECT id, name FROM ".TB_PREF."truck_status_group_types";

	return combo_input($name, $selected_id, $sql, 'id', 'name',
	array(
		'format' => '_format_account',
		'order' => array('id', 'name'),
		'spec_option' =>$all_option,
		'spec_id' => $all_items
	) );
}

function truck_status_group_types_list_cells($label, $name, $selected_id=null, $all_option=false, $all=false)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	
	echo truck_status_group_types_list($name, $selected_id, $all_option, $all);
	
}

function truck_status_group_types_list_row($label, $name, $selected_id=null, $all_option=false,	$all=false)
{
	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	truck_status_group_types_list_cells(null, $name, $selected_id, $all_option,
		$all);
	echo "</div></div>\n";
}

//-----------------------------------------------------------------------------------------------
function gl_all_accounts_list($name, $selected_id=null, $skip_bank_accounts=false,
	$cells=false, $all_option=false, $submit_on_change=false, $all=false)
{
	if ($skip_bank_accounts)
		$sql = "SELECT chart.account_code, chart.account_name, type.name, chart.inactive, type.id
			FROM (".TB_PREF."chart_master chart,".TB_PREF."chart_types type) "
			."LEFT JOIN ".TB_PREF."bank_accounts acc "
			."ON chart.account_code=acc.account_code
				WHERE acc.account_code  IS NULL
			AND chart.account_type=type.id";
	else
		$sql = "SELECT chart.account_code, chart.account_name, type.name, chart.inactive, type.id
			FROM ".TB_PREF."chart_master chart,".TB_PREF."chart_types type
			WHERE chart.account_type=type.id";

	return combo_input($name, $selected_id, $sql, 'chart.account_code', 'chart.account_name',
	array(
		'format' => '_format_account',
		'spec_option' => $all_option===true ?  _("Use Item Transport Accounts") : $all_option,
		'spec_id' => '',
		'type' => 2,
		'order' => array('type.class_id','type.id','account_code'),
		'search_box' => $cells,
			'search_submit' => false,
			'size' => 12,
			'max' => 10,
			'cells' => true,
		'select_submit'=> $submit_on_change,
		'async' => false,
		'category' => 2,
		'show_inactive' => $all
	) );

}

function _format_account($row)
{
		return $row[0] .  "&nbsp;&nbsp;&nbsp;&nbsp;" . $row[1];
}

function gl_all_accounts_list_cells($label, $name, $selected_id=null, 
	$skip_bank_accounts=false, $cells=false, $all_option=false, 
	$submit_on_change=false, $all=false)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	
	echo gl_all_accounts_list($name, $selected_id, 
		$skip_bank_accounts, $cells, $all_option, $submit_on_change, $all);
	
}

function gl_all_accounts_list_row($label, $name, $selected_id=null, 
	$skip_bank_accounts=false, $cells=false, $all_option=false)
{
	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	gl_all_accounts_list_cells(null, $name, $selected_id, 
		$skip_bank_accounts, $cells, $all_option);
	echo "</div></div>\n";
}
//-----------------------------------------------------------------------------------------------
function all_load_status_list($name, $selected_id=null, 
	$cells=false, $all_option=false, $submit_on_change=false, $all=false)
{
		$sql = "SELECT ls.load_status_code, ls.load_status_name, type.name, ls.inactive, type.id
			FROM ".TB_PREF."load_status ls,".TB_PREF."load_status_group_types type
			WHERE ls.load_status_type=type.id";

	return combo_input($name, $selected_id, $sql, 'ls.load_status_code', 'ls.load_status_name',
	array(
		'format' => '_format_load_list',
		'spec_option' => $all_option===true ?  _("Use Load Status") : $all_option,
		'spec_id' => '',
		'type' => 2,
		'order' => array('type.id','load_status_code','load_status_name'),
		'search_box' => $cells,
			'search_submit' => false,
			'size' => 12,
			'max' => 10,
			'cells' => true,
		'select_submit'=> $submit_on_change,
		'async' => false,
		'category' => 2,
		'show_inactive' => $all
	) );

}

function _format_load_list($row)
{
		return $row[1];
}

function all_load_status_list_cells($label, $name, $selected_id=null, 
	 $cells=false, $all_option=false, 
	$submit_on_change=false, $all=false)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";

	echo all_load_status_list($name, $selected_id, 
		 $cells, $all_option, $submit_on_change, $all);

}

function all_load_status_list_row($label, $name, $selected_id=null, 
	 $cells=false, $all_option=false)
{
	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	all_load_status_list_cells(null, $name, $selected_id, 
		 $cells, $all_option);
	echo "</div></div>\n";
}

function yesno_list($name, $selected_id=null, $name_yes="", $name_no="", $submit_on_change=false)
{
	$items = array();
	$items['0'] = strlen($name_no) ? $name_no : _("No");
	$items['1'] = strlen($name_yes) ? $name_yes : _("Yes");

	return array_selector($name, $selected_id, $items, 
		array( 
			'select_submit'=> $submit_on_change,
			'async' => false ) ); // FIX?
}
//-----------------------------------------------------------------------------------------------
function all_truck_type_list($name, $selected_id=null, 
	$cells=false, $all_option=false, $submit_on_change=false, $all=false)
{
		$sql = "SELECT ls.truck_type_code, ls.truck_type_name, type.name, ls.inactive, type.id
			FROM ".TB_PREF."truck_type ls,".TB_PREF."truck_group_types type
			WHERE ls.truck_group_type=type.id";

	return combo_input($name, $selected_id, $sql, 'ls.truck_type_code', 'ls.truck_type_name',
	array(
		'format' => '_format_truck_types',
		'spec_option' => $all_option===true ?  _("Truck types") : $all_option,
		'spec_id' => '',
		'type' => 2,
		'order' => array('type.id','truck_type_code','truck_type_name'),
		'search_box' => $cells,
			'search_submit' => false,
			'size' => 12,
			'max' => 10,
			'cells' => true,
		'select_submit'=> $submit_on_change,
		'async' => false,
		'category' => 2,
		'show_inactive' => $all
	) );

}

function _format_truck_types($row)
{
		return $row[1];
}

function all_truck_type_list_cells($label, $name, $selected_id=null, 
	 $cells=false, $all_option=false, 
	$submit_on_change=false, $all=false)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	
	echo all_truck_type_list($name, $selected_id, 
		 $cells, $all_option, $submit_on_change, $all);
	
}

function all_truck_type_list_row($label, $name, $selected_id=null, 
	 $cells=false, $all_option=false)
{
	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	all_truck_type_list_cells(null, $name, $selected_id, 
		 $cells, $all_option);
	echo "</div></div>\n";
}
//-----------------------------------------------------------------------------------------------
function all_commodity_type_list($name, $selected_id=null, 
	$cells=false, $all_option=false, $submit_on_change=false, $all=false)
{
		$sql = "SELECT ls.commodity_type_code, ls.commodity_type_name, type.name, ls.inactive, type.id
			FROM ".TB_PREF."commodity_type ls,".TB_PREF."commodity_group_types type
			WHERE ls.commodity_group_type=type.id";

	return combo_input($name, $selected_id, $sql, 'ls.commodity_type_code', 'ls.commodity_type_name',
	array(
		'format' => '_format_commodity_types',
		'spec_option' => $all_option===true ?  _("All commodity type") : $all_option,
		'spec_id' => '',
		'type' => 2,
		'order' => array('type.id','commodity_type_code','commodity_type_name'),
		'search_box' => $cells,
			'search_submit' => false,
			'size' => 12,
			'max' => 10,
			'cells' => true,
		'select_submit'=> $submit_on_change,
		'async' => false,
		'category' => 2,
		'show_inactive' => $all
	) );

}

function _format_commodity_types($row)
{
		return $row[1];
}

function all_commodity_type_list_cells($label, $name, $selected_id=null, 
	 $cells=false, $all_option=false, 
	$submit_on_change=false, $all=false)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	
	echo all_commodity_type_list($name, $selected_id, 
		 $cells, $all_option, $submit_on_change, $all);
	
}

function all_commodity_type_list_row($label, $name, $selected_id=null, 
	 $cells=false, $all_option=false)
{
	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	all_commodity_type_list_cells(null, $name, $selected_id, 
		 $cells, $all_option);
	echo "</div></div>\n";
}
//-----------------------------------------------------------------------------------------------
function all_truck_length_type_list($name, $selected_id=null, 
	$cells=false, $all_option=false, $submit_on_change=false, $all=false)
{
		$sql = "SELECT ls.truck_length_type_code, ls.truck_length_type_name, type.name, ls.inactive, type.id
			FROM ".TB_PREF."truck_length_type ls,".TB_PREF."truck_length_group_types type
			WHERE ls.truck_length_group_type=type.id";

	return combo_input($name, $selected_id, $sql, 'ls.truck_length_type_code', 'ls.truck_length_type_name',
	array(
		'format' => '_format_truck_length_types',
		'spec_option' => $all_option===true ?  _("All truck lengths") : $all_option,
		'spec_id' => '',
		'type' => 2,
		'order' => array('type.id','truck_length_type_code','truck_length_type_name'),
		'search_box' => $cells,
			'search_submit' => false,
			'size' => 12,
			'max' => 10,
			'cells' => true,
		'select_submit'=> $submit_on_change,
		'async' => false,
		'category' => 2,
		'show_inactive' => $all
	) );

}

function _format_truck_length_types($row)
{
		return $row[1];
}

function all_truck_length_type_list_cells($label, $name, $selected_id=null, 
	 $cells=false, $all_option=false, 
	$submit_on_change=false, $all=false)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	
	echo all_truck_length_type_list($name, $selected_id, 
		 $cells, $all_option, $submit_on_change, $all);
	
}

function all_truck_length_type_list_row($label, $name, $selected_id=null, 
	 $cells=false, $all_option=false)
{
	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	all_truck_length_type_list_cells(null, $name, $selected_id, 
		 $cells, $all_option);
	echo "</div></div>\n";
}
//-----------------------------------------------------------------------------------------------
function all_truck_status_type_list($name, $selected_id=null, 
	$cells=false, $all_option=false, $submit_on_change=false, $all=false)
{
		$sql = "SELECT ls.truck_status_type_code, ls.truck_status_type_name, type.name, ls.inactive, type.id
			FROM ".TB_PREF."truck_status_type ls,".TB_PREF."truck_status_group_types type
			WHERE ls.truck_status_group_type=type.id";

	return combo_input($name, $selected_id, $sql, 'ls.truck_status_type_code', 'ls.truck_status_type_name',
	array(
		'format' => '_format_truck_status_types',
		'spec_option' => $all_option===true ?  _("Truck Status") : $all_option,
		'spec_id' => '',
		'type' => 2,
		'order' => array('type.id','truck_status_type_code','truck_status_type_name'),
		'search_box' => $cells,
			'search_submit' => false,
			'size' => 12,
			'max' => 10,
			'cells' => true,
		'select_submit'=> $submit_on_change,
		'async' => false,
		'category' => 2,
		'show_inactive' => $all
	) );

}

function _format_truck_status_types($row)
{
		return $row[1];
}

function all_truck_status_type_list_cells($label, $name, $selected_id=null, 
	 $cells=false, $all_option=false, 
	$submit_on_change=false, $all=false)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	
	echo all_truck_status_type_list($name, $selected_id, 
		 $cells, $all_option, $submit_on_change, $all);
	
}

function all_truck_status_type_list_row($label, $name, $selected_id=null, 
	 $cells=false, $all_option=false)
{
	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	all_truck_status_type_list_cells(null, $name, $selected_id, 
		 $cells, $all_option);
	echo "</div></div>\n";
}


function yesno_list_cells($label, $name, $selected_id=null, $name_yes="", $name_no="", $submit_on_change=false)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	
	echo yesno_list($name, $selected_id, $name_yes, $name_no, $submit_on_change);
	
}

function yesno_list_row($label, $name, $selected_id=null, $name_yes="", $name_no="", $submit_on_change=false)
{
	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	yesno_list_cells(null, $name, $selected_id, $name_yes, $name_no, $submit_on_change);
	echo "</div></div>\n";
}

//------------------------------------------------------------------------------------------------

function languages_list($name, $selected_id=null, $all_option=false)
{
	global $installed_languages;

	$items = array();
	if ($all_option)
		$items[''] = $all_option;
	foreach ($installed_languages as $lang)
			$items[$lang['code']] = $lang['name'];
	return array_selector($name, $selected_id, $items);
}

function languages_list_cells($label, $name, $selected_id=null, $all_option=false)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	
	echo languages_list($name, $selected_id, $all_option);
	
}

function languages_list_row($label, $name, $selected_id=null, $all_option=false)
{
	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	languages_list_cells(null, $name, $selected_id, $all_option);
	echo "</div></div>\n";
}

//------------------------------------------------------------------------------------------------

function bank_account_types_list($name, $selected_id=null)
{
	global $bank_account_types;

	return array_selector($name, $selected_id, $bank_account_types);
}

function bank_account_types_list_cells($label, $name, $selected_id=null)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	
	echo bank_account_types_list($name, $selected_id);
	
}

function bank_account_types_list_row($label, $name, $selected_id=null)
{
	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	bank_account_types_list_cells(null, $name, $selected_id);
	echo "</div></div>\n";
}

//------------------------------------------------------------------------------------------------
function payment_person_types_list($name, $selected_id=null, $submit_on_change=false)
{
	global $payment_person_types;

	$items = array();
	foreach ($payment_person_types as $key=>$type)
	{
		if ($key != PT_WORKORDER)
			$items[$key] = $type;
	}		
	return array_selector($name, $selected_id, $items, 
		array( 'select_submit'=> $submit_on_change ) );
}

function payment_person_types_list_cells($label, $name, $selected_id=null, $related=null)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	
	echo payment_person_types_list($name, $selected_id, $related);
	
}

function payment_person_types_list_row($label, $name, $selected_id=null, $related=null)
{
	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	payment_person_types_list_cells(null, $name, $selected_id, $related);
	echo "</div></div>\n";
}


function payment_payee_types_list($name, $selected_id=null, $submit_on_change=true)
{
	global $payment_payee_types;

	$items = array();
	foreach ($payment_payee_types as $key=>$type)
	{
		//if ($key != PT_WORKORDER)
			$items[$key] = $type;
	}		
	return array_selector($name, $selected_id, $items, 
		array( 'select_submit'=> $submit_on_change ) );
}

function payment_payee_types_list_cells($label, $name, $selected_id=null, $related=null)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	
	echo payment_payee_types_list($name, $selected_id, $related);
	
}

function payment_payee_types_list_row($label, $name, $selected_id=null, $related=null)
{
	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	payment_person_types_list_cells(null, $name, $selected_id, $related);
	echo "</div></div>\n";
}


//------------------------------------------------------------------------------------------------

function wo_types_list($name, $selected_id=null)
{
	global $wo_types_array;
	
	return array_selector($name, $selected_id, $wo_types_array, 
		array( 'select_submit'=> true, 'async' => true ) );
}

function wo_types_list_row($label, $name, $selected_id=null)
{
	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>\n";
	echo wo_types_list($name, $selected_id);
	echo "</div></div>\n";
}

function freight_terms_types_list($name, $selected_id=null)
{
	global $freight_terms;
	
	return array_selector($name, $selected_id, $freight_terms, 
		array( 'select_submit'=> true, 'async' => false ) );
}

function freight_terms_types_list_row($label, $name, $selected_id=null)
{
	echo "<td>\n";
	echo freight_terms_types_list($name, $selected_id);
	
}

function payment_by_list($name, $selected_id=null)
{
	global $payment_by;
	
	return array_selector($name, $selected_id, $payment_by, 
		array( 'select_submit'=> false, 'async' => false ) );
}

function payment_by_list_row($label, $name, $selected_id=null)
{
	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>\n";
	echo payment_by_list($name, $selected_id);
	echo "</div></div>\n";
}
function service_tax_by_list($name, $selected_id=null)
{
	global $payment_by;
	
	return array_selector($name, $selected_id, $payment_by, 
		array( 'select_submit'=> false, 'async' => false ) );
}

function service_tax_by_list_row($label, $name, $selected_id=null)
{
	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>\n";
	echo service_tax_by_list($name, $selected_id);
	echo "</div></div>\n";
}
function yes_no_by_list($name, $selected_id=null)
{
	global $yesno;
	
	return array_selector($name, $selected_id, $yesno, 
		array( 'spec_option'=> _("Select"),
			'spec_id' => -1,'select_submit'=> true, 'async' => false ) );
}

function yes_no_by_list_row($label, $name, $selected_id=null)
{
	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>\n";
	echo yes_no_by_list($name, $selected_id);
	echo "</div></div>\n";
}

//------------------------------------------------------------------------------------------------

function dateformats_list_row($label, $name, $value=null)
{
	global $dateformats;

	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>\n";
	echo array_selector( $name, $value, $dateformats );
	echo "</div></div>\n";
}

function dateseps_list_row($label, $name, $value=null)
{
	global $dateseps;

	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>\n";
	echo array_selector( $name, $value, $dateseps );
	echo "</div></div>\n";
}

function thoseps_list_row($label, $name, $value=null)
{
	global $thoseps;

	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>\n";
	echo array_selector( $name, $value, $thoseps );
	echo "</div></div>\n";
}

function decseps_list_row($label, $name, $value=null)
{
	global $decseps;

	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>\n";
	echo array_selector( $name, $value, $decseps );
	echo "</div></div>\n";
}

function themes_list_row($label, $name, $value=null)
{
	global $path_to_root;

	$path = $path_to_root.'/themes/';
	$themes = array();
	$themedir = opendir($path);
	while(false !== ($fname = readdir($themedir)))
	{
		if($fname!='.' && $fname!='..' && $fname!='CVS' && is_dir($path.$fname))
		{
			$themes[$fname] =  $fname;
		}
	}
	ksort($themes);

	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>\n";
	echo array_selector( $name, $value, $themes );
	echo "</div></div>\n";
}

function pagesizes_list_row($label, $name, $value=null)
{
	global $pagesizes;

	$items = array();
	foreach ($pagesizes as $pz)
		$items[$pz] = $pz;

	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>\n";
	echo array_selector( $name, $value, $items );
	echo "</div></div>\n";
}

function systypes_list($name, $value=null, $spec_opt=false, $submit_on_change=false, $exclude=array())
{
	global $systypes_array;

	// emove non-voidable transactions if needed
	$systypes = array_diff_key($systypes_array, array_flip($exclude));
	return array_selector($name, $value, $systypes, 
		array( 
			'spec_option'=> $spec_opt,
			'spec_id' => ALL_NUMERIC,
			'select_submit'=> $submit_on_change,
			'async' => false,
			)
	);
}

function systypes_list_cells($label, $name, $value=null, $submit_on_change=false, $exclude=array())
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	
	echo systypes_list($name, $value, false, $submit_on_change, $exclude);
	
}

function systypes_list_row($label, $name, $value=null, $submit_on_change=false, $exclude=array())
{
	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	systypes_list_cells(null, $name, $value, $submit_on_change, $exclude);
	echo "</div></div>\n";
}

function journal_types_list_cells($label, $name, $value=null, $submit_on_change=false)
{
	global $systypes_array;

	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	

	$items = $systypes_array;

	// exclude quotes, orders and dimensions
	foreach (array(ST_PURCHORDER, ST_TRANSPORTORDER, ST_DIMENSION, ST_TRANSPORTQUOTE,ST_TRANSPORTBOOKING, ST_LOCTRANSFER) as $excl)
			unset($items[$excl]);
	
	echo array_selector($name, $value, $items, 
		array( 
			'spec_option'=> _("All"),
			'spec_id' => -1,
			'select_submit'=> $submit_on_change,
			'async' => false
			)
	);
	
}

function consignor_allocations_list_cells($label, $name, $selected=null)
{
	global $all_items;

	if ($label != null)
		label_cell($label);
	echo "<td>\n";
	$allocs = array( 
		$all_items=>_("All Types"),
		'1'=> _("Transport Invoices"),
		'2'=> _("Overdue Invoices"),
		'3' => _("Payments"),
		'4' => _("Credit Notes"),
		'5' => _("Delivery Notes")
	);
	echo array_selector($name, $selected, $allocs);
	
}

function supp_allocations_list_cell($name, $selected=null)
{
	global $all_items;

	echo "<td>\n";
	$allocs = array( 
		$all_items=>_("All Types"),
		'1'=> _("Invoices"),
		'2'=> _("Overdue Invoices"),
		'3' => _("Payments"),
		'4' => _("Credit Notes"),
		'5' => _("Overdue Credit Notes")
	);
	echo array_selector($name, $selected, $allocs);
	
}

function supp_transactions_list_cell($name, $selected=null)
{
	global $all_items;

	echo "<td>\n";
	$allocs = array( 
		$all_items=>_("All Types"),
		'6'=>_("GRNs"),
		'1'=> _("Invoices"),
		'2'=> _("Overdue Invoices"),
		'3' => _("Payments"),
		'4' => _("Credit Notes"),
		'5' => _("Overdue Credit Notes")
	);

	echo array_selector($name, $selected, $allocs);
	
}

function policy_list_cells($label, $name, $selected=null)
{
	if ($label != null)
		label_cell($label);
	echo "<td>\n";
	echo array_selector($name, $selected, 
				array( '' => _("Automatically put balance on back order"),
			 		'CAN' => _("Cancel any quantites not delivered")) );
	
}

function policy_list_row($label, $name, $selected=null)
{
	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	policy_list_cells(null, $name, $selected);
	echo "</div></div>\n";
}

function credit_type_list_cells($label, $name, $selected=null, $submit_on_change=false)
{
	if ($label != null)
		label_cell($label);
	echo "<td>\n";
	echo array_selector($name, $selected, 
				array( 'Return' => _("Items Returned to Inventory Location"),
			 		'WriteOff' => _("Items Written Off")),
				array( 'select_submit'=> $submit_on_change ) );
	
}

function credit_type_list_row($label, $name, $selected=null, $submit_on_change=false)
{
	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	credit_type_list_cells(null, $name, $selected, $submit_on_change);
	echo "</div></div>\n";
}

function number_list($name, $selected, $from, $to, $no_option=false,$submit_on_change=false)
{
	$items = array();
	for ($i = $from; $i <= $to; $i++)
		$items[$i] = "$i";

	return array_selector($name, $selected, $items,
				array(	'spec_option' => $no_option,
					'spec_id' => ALL_NUMERIC,
                                        'select_submit'=> $submit_on_change ));
}

function number_list_cells($label, $name, $selected, $from, $to, $no_option=false,$submit_on_change=false)
{
	if ($label != null)
		label_cell($label);
	echo number_list($name, $selected, $from, $to, $no_option,$submit_on_change);
	
}

function number_list_row($label, $name, $selected, $from, $to, $no_option=false)
{
	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	echo number_list_cells(null, $name, $selected, $from, $to, $no_option);
	echo "</div></div>\n";
}

function print_profiles_list_row($label, $name, $selected_id=null, $spec_opt=false,
	$submit_on_change=true)
{
	$sql = "SELECT profile FROM ".TB_PREF."print_profiles"
		." GROUP BY profile";
	$result = db_query($sql, 'cannot get all profile names');
	$profiles = array();
	while($myrow=db_fetch($result)) {
		$profiles[$myrow['profile']] = $myrow['profile'];
	}

	echo "<div class='form-group'>";
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label><div class='col-md-6'>\n";
	

	echo array_selector($name, $selected_id, $profiles, 
		array( 'select_submit'=> $submit_on_change,
			'spec_option'=>$spec_opt,
			'spec_id' => ''
		 ));

	echo "</div></div>\n";
}

function printers_list($name, $selected_id=null, $spec_opt=false, $submit_on_change=false)
{
	static $printers; // query only once for page display

	if (!$printers) {
		$sql = "SELECT id, name, description FROM ".TB_PREF."printers";	
		$result = db_query($sql, 'cannot get all printers');
		$printers = array();
		while($myrow=db_fetch($result)) {
			$printers[$myrow['id']] = $myrow['name'].'&nbsp;-&nbsp;'.$myrow['description'];
		}
	}
	return array_selector($name, $selected_id, $printers, 
		array( 'select_submit'=> $submit_on_change,
			'spec_option'=>$spec_opt,
			'spec_id' => ''
		 ));
}

//------------------------------------------------------------------------------------------------

function quick_entries_list($name, $selected_id=null, $type=null, $submit_on_change=false)
{
	$where = false;
	$sql = "SELECT id, description FROM ".TB_PREF."quick_entries";
	if ($type != null)
		$sql .= " WHERE type=$type";

	return combo_input($name, $selected_id, $sql, 'id', 'description',
		array(
			'spec_id' => '',
			'order' => 'description',
			'select_submit'=> $submit_on_change,
			'async' => false
		) );

}

function quick_entries_list_cells($label, $name, $selected_id=null, $type, $submit_on_change=false)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
		
	echo quick_entries_list($name, $selected_id, $type, $submit_on_change);
	echo "</td>";
}

function quick_entries_list_row($label, $name, $selected_id=null, $type, $submit_on_change=false)
{
	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	quick_entries_list_cells(null, $name, $selected_id, $type, $submit_on_change);
	echo "</div></div>\n";
}


function quick_actions_list_row($label, $name, $selected_id=null, $submit_on_change=false)
{
	global $quick_actions;
	
	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	echo array_selector($name, $selected_id, $quick_actions, 
		array( 
			'select_submit'=> $submit_on_change
		) );
	echo "</div></div>\n";
}

function quick_entry_types_list_row($label, $name, $selected_id=null, $submit_on_change=false)
{
	global $quick_entry_types;
		
	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	echo array_selector($name, $selected_id, $quick_entry_types, 
		array( 
			'select_submit'=> $submit_on_change
			) );
	echo "</div></div>\n";
}

function record_status_list_row($label, $name) {
	return yesno_list_row($label, $name, null, 	_('Inactive'), _('Active'));
}

function class_types_list_row($label, $name, $selected_id=null, $submit_on_change=false)
{
	global $class_types;
	
	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	echo array_selector($name, $selected_id, $class_types, 
		array( 
			'select_submit'=> $submit_on_change
		) );
	echo "</div></div>\n";
}

//------------------------------------------------------------------------------------------------

function security_roles_list($name, $selected_id=null, $new_item=false, $submit_on_change=false,
	$show_inactive = false)
{
	global $all_items;

	$sql = "SELECT id, role, inactive FROM ".TB_PREF."security_roles";

return combo_input($name, $selected_id, $sql, 'id', 'description',
	array(
		'spec_option'=>$new_item ? _("New role") : false,
		'spec_id' => '',
		'select_submit'=> $submit_on_change,
		'show_inactive' => $show_inactive
	) );
}

function security_roles_list_cells($label, $name, $selected_id=null, $new_item=false, $submit_on_change=false,
	$show_inactive = false)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	
	echo security_roles_list($name, $selected_id, $new_item, $submit_on_change, $show_inactive);
	
}

function security_roles_list_row($label, $name, $selected_id=null, $new_item=false, $submit_on_change=false,
	$show_inactive = false)
{
	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	security_roles_list_cells(null, $name, $selected_id, $new_item, $submit_on_change, $show_inactive);
	echo "</div></div>\n";
}

function tab_list_row($label, $name, $selected_id=null)
{
	global $installed_extensions;
	
	$tabs = array();
	foreach ($_SESSION['App']->applications as $app) {
		$tabs[$app->id] = access_string($app->name, true);
	}
	echo "<tr>\n";
	echo "<label class='col-md-3 control-label'>$label</label><td>\n";
	echo array_selector($name, $selected_id, $tabs);
	echo "</div></div>\n";
}

//-----------------------------------------------------------------------------------------------

function tag_list($name, $height, $type, $multi=false, $all=false, $spec_opt = false)
{
	// Get tags
	global $path_to_root;
	include_once($path_to_root . "/admin/db/tags_db.inc");
	$results = get_tags($type, $all);

	while ($tag = db_fetch($results))
		$tags[$tag['id']] = $tag['name'];
	
	if (!isset($tags)) {
		$tags[''] = $all ? _("No tags defined.") : _("No active tags defined.");
		$spec_opt = false;
	}
	return array_selector($name, null, $tags,
		array(
			'multi' => $multi,
			'height' => $height,
			'spec_option'=> $spec_opt,
			'spec_id' => -1,
		) );
}

function tag_list_cells($label, $name, $height, $type, $mult=false, $all=false, $spec_opt = false)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	echo "<td>\n";
	echo tag_list($name, $height, $type, $mult, $all, $spec_opt);
	
	
}

function tag_list_row($label, $name, $height, $type, $mult=false, $all=false, $spec_opt = false)
{
	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	tag_list_cells(null, $name, $height, $type, $mult, $all, $spec_opt);
	echo "</div></div>\n";	
}

//---------------------------------------------------------------------------------------------
//	List of sets of active extensions 
//
function extset_list($name, $value=null, $submit_on_change=false)
{
	global $db_connections;

	$items = array();
	foreach ($db_connections as $comp)
		$items[] = sprintf(_("Activated for '%s'"), $comp['name']);
	return array_selector( $name, $value, $items,
		array(
			'spec_option'=> _("Available and/or installed"),
			'spec_id' => -1,
			'select_submit'=> $submit_on_change,
			'async' => true
		));
}

function crm_category_types_list($name, $selected_id=null, $filter=array(), $submit_on_change=true)
{

	$sql = "SELECT id, name, type, inactive FROM ".TB_PREF."crm_categories";

	$multi = false;
	$groups = false;
	$where = array();
	if (@$filter['class']) {
		$where[] = 'type='.db_escape($filter['class']);
	} else
		$groups = 'type';
	if (@$filter['subclass']) $where[] = 'action='.db_escape($filter['subclass']);
	if (@$filter['entity']) $where[] = 'entity_id='.db_escape($filter['entity']);
	if (@$filter['multi']) { // contact category selector for person
		$multi = true;
	}

	return combo_input($name, $selected_id, $sql, 'id', 'name',
	 	array(
	 		'multi' => $multi,
	 		'height' => $multi ? 5:1,
			'category' => $groups,
	 		'select_submit'=> $submit_on_change,
 			'async' => true,
 			'where' => $where
	 	));
}

function crm_category_types_list_row($label, $name, $selected_id=null, $filter=array(), $submit_on_change=true)
{
	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	echo crm_category_types_list($name, $selected_id, $filter, $submit_on_change);
	echo "</div></div>\n";
}

function payment_type_list_row($label, $name, $selected_id=null, $submit_on_change=false)
{
	global $pterm_types;
	
	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	echo array_selector($name, $selected_id, $pterm_types, 
		array( 
			'select_submit'=> $submit_on_change
		) );
	echo "</div></div>\n";
}

function coa_list_row($label, $name, $value=null)
{
	global $path_to_root, $installed_extensions;

	$path = $path_to_root.'/sql/';
	$coas = array();
	$sqldir = opendir($path);
	while (false !== ($fname = readdir($sqldir)))
	{
		if (is_file($path.$fname) && substr($fname,-4)=='.sql' && @($fname[2] == '_'))
		{
			$ext = array_search_value($fname, $installed_extensions, 'sql');
			if ($ext!=null) {
				$descr = $ext['name'];
			} elseif ($fname == 'en_US-new.sql') { // two standard COAs
				$descr = _("Standard new company American COA (4 digit)");
			} elseif ($fname == 'en_US-demo.sql') {
				$descr = _("Standard American COA (4 digit) with demo data");
			} else
				$descr = $fname;

			$coas[$fname] =  $descr;
		}
	}
	ksort($coas);

	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>\n";
	echo array_selector( $name, $value, $coas );
	echo "</div></div>\n";
}

function payment_services($name)
{
	global $payment_services;

	$services = array_combine(array_keys($payment_services), array_keys($payment_services));

	return array_selector($name, null, $services, array(
			'spec_option'=> _("No payment Link"),
			'spec_id' => '',
		));
}
//----------------------------------------------------------------------------------------------

function driver_list($name, $selected_id=null, $spec_option=false, $submit_on_change=false, 
	$show_inactive=false, $editkey = false)
{
	global $all_items;

	$sql = "SELECT driver_no, driver_ref, curr_code, inactive FROM ".TB_PREF."drivers_master ";

	

if ($editkey)
		set_editor('driver', $name, $editkey);
	$ret = combo_input($name, $selected_id, $sql, 'driver_no', 'driver_ref',
	array(
	   
	    'order' => array('driver_ref'),
		
		'type' => 1,
		
		'spec_option' => $spec_option === true ? _("Select a driver") : $spec_option,
		'spec_id' => $all_items,
		'select_submit'=> $submit_on_change,
		'async' => false,
		
		'show_inactive' => $show_inactive
	) );
	if ($editkey)
		$ret .= add_edit_combo('driver');
	return $ret;
}

function driver_list_cells($label, $name, $selected_id=null, $all_option=false, 
	$submit_on_change=false, $show_inactive=false, $editkey = false)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	
	echo driver_list($name, $selected_id, $all_option, $submit_on_change,
		$show_inactive, $editkey);
	
}

function driver_list_row($label, $name, $selected_id=null, $all_option = false, 
	$submit_on_change=false, $show_inactive=false, $editkey = false)
{
	global $path_to_root;

	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	echo driver_list($name, $selected_id, $all_option, $submit_on_change,
		$show_inactive, $editkey);
	echo "</div></div>\n";
}

//------------------------------------------------------------------------------------------------

function driver_branches_list($driver_id, $name, $selected_id=null,
	$spec_option = true, $enabled=true, $submit_on_change=false, $editkey = false)
{
	global $all_items;

	$sql = "SELECT branch_code, branch_ref FROM ".TB_PREF."consignor_branch
		WHERE driver_no=" . db_escape($driver_id)." ";

	if ($editkey)
		set_editor('branch', $name, $editkey);

	$where = $enabled ? array("disable_trans = 0") : array();
	$ret = combo_input($name, $selected_id, $sql, 'branch_code', 'branch_ref',
	array(
		'where' => $where,
		'order' => array('branch_ref'),
		'spec_option' => $spec_option === true ? _('All branches') : $spec_option,
		'spec_id' => $all_items,
		'select_submit'=> $submit_on_change,
		'sel_hint' => _('Select driver branch')
	) );
	if ($editkey)
	{
		$ret .= add_edit_combo('branch');
	}	
	return $ret;
}
//------------------------------------------------------------------------------------------------

function driver_branches_list_cells($label,$driver_id, $name, $selected_id=null, 
	$all_option = true, $enabled=true, $submit_on_change=false, $editkey = false)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	
	echo driver_branches_list($driver_id, $name, $selected_id, $all_option, $enabled, 
		$submit_on_change, $editkey);
	
}

function driver_branches_list_row($label, $driver_id, $name, $selected_id=null, 
	$all_option = true, $enabled=true, $submit_on_change=false, $editkey = false)
{
	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	driver_branches_list_cells(null, $driver_id, $name, $selected_id, 
		$all_option, $enabled, $submit_on_change, $editkey);
	echo "</div>";
}

function db_has_drivers()
{
	return check_empty_result("SELECT COUNT(*) FROM ".TB_PREF."drivers_master");
}

function check_db_has_drivers($msg)
{
	global $path_to_root;
    if (!db_has_drivers()) 
    {
    	display_error($msg, true);
    	end_page();
    	exit;	
    }	
}


function vendor_list($name, $selected_id=null, $spec_option=false, $submit_on_change=false, 
	$show_inactive=false, $editkey = false)
{
	global $all_items;

	$sql = "SELECT vendor_no, vendor_ref, curr_code, inactive FROM ".TB_PREF."vendors_master ";

	$ret = combo_input($name, $selected_id, $sql, 'vendor_no', 'vendor_ref',
	array(
	    'format' => '_format_add_curr',
	    'order' => array('vendor_ref'),
		
		'type' => 1,
		
		'spec_option' => $spec_option === true ? _("All vendors") : $spec_option,
		'spec_id' => $all_items,
		'select_submit'=> $submit_on_change,
		'async' => false,
		
		'show_inactive' => $show_inactive
	) );
	if ($editkey)
		$ret .= add_edit_combo('vendor');
	return $ret;
}

function vendor_list_cells($label, $name, $selected_id=null, $all_option=false, 
	$submit_on_change=false, $show_inactive=false, $editkey = false)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	
	echo vendor_list($name, $selected_id, $all_option, $submit_on_change,
		$show_inactive, $editkey);
	
}

function vendor_list_row($label, $name, $selected_id=null, $all_option = false, 
	$submit_on_change=false, $show_inactive=false, $editkey = false)
{
	global $path_to_root;

	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	echo vendor_list($name, $selected_id, $all_option, $submit_on_change,
		$show_inactive, $editkey);
	echo "</div></div>\n";
}

//------------------------------------------------------------------------------------------------

function vendor_branches_list($vendor_id, $name, $selected_id=null,
	$spec_option = true, $enabled=true, $submit_on_change=false, $editkey = false)
{
	global $all_items;

	$sql = "SELECT branch_code, branch_ref FROM ".TB_PREF."consignor_branch
		WHERE vendor_no=" . db_escape($vendor_id)." ";

	if ($editkey)
		set_editor('branch', $name, $editkey);

	$where = $enabled ? array("disable_trans = 0") : array();
	$ret = combo_input($name, $selected_id, $sql, 'branch_code', 'branch_ref',
	array(
		'where' => $where,
		'order' => array('branch_ref'),
		'spec_option' => $spec_option === true ? _('All branches') : $spec_option,
		'spec_id' => $all_items,
		'select_submit'=> $submit_on_change,
		'sel_hint' => _('Select vendor branch')
	) );
	if ($editkey)
	{
		$ret .= add_edit_combo('branch');
	}	
	return $ret;
}
//------------------------------------------------------------------------------------------------

function vendor_branches_list_cells($label,$vendor_id, $name, $selected_id=null, 
	$all_option = true, $enabled=true, $submit_on_change=false, $editkey = false)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	
	echo vendor_branches_list($vendor_id, $name, $selected_id, $all_option, $enabled, 
		$submit_on_change, $editkey);
	
}

function vendor_branches_list_row($label, $vendor_id, $name, $selected_id=null, 
	$all_option = true, $enabled=true, $submit_on_change=false, $editkey = false)
{
	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	vendor_branches_list_cells(null, $vendor_id, $name, $selected_id, 
		$all_option, $enabled, $submit_on_change, $editkey);
	echo "</div>";
}

function db_has_vendors()
{
	return check_empty_result("SELECT COUNT(*) FROM ".TB_PREF."vendors_master");
}

function check_db_has_vendors($msg)
{
	global $path_to_root;
    if (!db_has_vendors()) 
    {
    	display_error($msg, true);
    	end_page();
    	exit;	
    }	
}
//--------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------------

function vehicle_list($name, $selected_id=null, $spec_option=false, $submit_on_change=false, 
	$show_inactive=false, $editkey = false)
{
	global $all_items;

	$sql = "SELECT vehicle_id,description ,inactive FROM ".TB_PREF."vehicles_master ";

if ($editkey)
		set_editor('vehicle', $name, $editkey);
	$ret = combo_input($name, $selected_id, $sql, 'vehicle_id', 'description',
	array(
	  
	    'order' => array('description'),
		
		'type' => 1,
		
		'spec_option' => $spec_option === true ? _("Select a vehicle") : $spec_option,
		'spec_id' => $all_items,
		'select_submit'=> $submit_on_change,
		'async' => false,
		
		'show_inactive' => $show_inactive
	) );
	if ($editkey)
		$ret .= add_edit_combo('vehicle');
	return $ret;
}

function vehicle_list_cells($label, $name, $selected_id=null, $all_option=false, 
	$submit_on_change=false, $show_inactive=false, $editkey = false)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	
	echo vehicle_list($name, $selected_id, $all_option, $submit_on_change,
		$show_inactive, $editkey);
	
}

function vehicle_list_row($label, $name, $selected_id=null, $all_option = false, 
	$submit_on_change=false, $show_inactive=false, $editkey = false)
{
	global $path_to_root;

	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	echo vehicle_list($name, $selected_id, $all_option, $submit_on_change,
		$show_inactive, $editkey);
	echo "</div></div>\n";
}
function vehicle_list_to_display($name, $selected_id=null, $spec_option=true, $submit_on_change=false, 
	$show_inactive=false, $editkey = false)
{
	global $all_items;

	$sql = "SELECT vehicle_id,description ,inactive FROM ".TB_PREF."vehicles_master ";


	$ret = combo_input($name, $selected_id, $sql, 'vehicle_id', 'description',
	array(
	  
	    'order' => array('description'),
		'format' => '_format_stock_items',
		'spec_option' => $spec_option===true ?  _("All Items") : $spec_option,
		'spec_id' => $all_items,
		'search_box' => true,
		
		'select_submit'=> $submit_on_change,
		'type' => 1,
		
		'spec_id' => $all_items,
		'select_submit'=> $submit_on_change,
		'async' => false,
		
		'show_inactive' => $show_inactive
	) );
	if ($editkey)
		$ret .= add_edit_combo('vehicle');
	return $ret;
}

function vehicle_list_to_display_cells($label, $name, $selected_id=null, $all_option=false, 
	$submit_on_change=false, $show_inactive=false, $editkey = false)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	
	echo vehicle_list_to_display($name, $selected_id, $all_option, $submit_on_change,
		$show_inactive, $editkey);
	
}

function vehicle_list_to_display_row($label, $name, $selected_id=null, $all_option = false, 
	$submit_on_change=false, $show_inactive=false, $editkey = false)
{
	global $path_to_root;

	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	echo vehicle_list_to_display($name, $selected_id, $all_option, $submit_on_change,
		$show_inactive, $editkey);
	echo "</div></div>\n";
}


//------------------------------------------------------------------------------------------------

function vehicle_branches_list($vehicle_id, $name, $selected_id=null,
	$spec_option = true, $enabled=true, $submit_on_change=false, $editkey = false)
{
	global $all_items;

	$sql = "SELECT branch_code, branch_ref FROM ".TB_PREF."consignor_branch
		WHERE vehicle_no=" . db_escape($vehicle_id)." ";

	if ($editkey)
		set_editor('branch', $name, $editkey);

	$where = $enabled ? array("disable_trans = 0") : array();
	$ret = combo_input($name, $selected_id, $sql, 'branch_code', 'branch_ref',
	array(
		'where' => $where,
		'order' => array('branch_ref'),
		'spec_option' => $spec_option === true ? _('All branches') : $spec_option,
		'spec_id' => $all_items,
		'select_submit'=> $submit_on_change,
		'sel_hint' => _('Select vehicle branch')
	) );
	if ($editkey)
	{
		$ret .= add_edit_combo('branch');
	}	
	return $ret;
}
//------------------------------------------------------------------------------------------------

function vehicle_branches_list_cells($label,$vehicle_id, $name, $selected_id=null, 
	$all_option = true, $enabled=true, $submit_on_change=false, $editkey = false)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	
	echo vehicle_branches_list($vehicle_id, $name, $selected_id, $all_option, $enabled, 
		$submit_on_change, $editkey);
	
}

function vehicle_branches_list_row($label, $vehicle_id, $name, $selected_id=null, 
	$all_option = true, $enabled=true, $submit_on_change=false, $editkey = false)
{
	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	vehicle_branches_list_cells(null, $vehicle_id, $name, $selected_id, 
		$all_option, $enabled, $submit_on_change, $editkey);
	echo "</div>";
}

function db_has_vehicles()
{
	return check_empty_result("SELECT COUNT(*) FROM ".TB_PREF."vehicles_master");
}

function check_db_has_vehicles($msg)
{
	global $path_to_root;
    if (!db_has_vehicles()) 
    {
    	display_error($msg, true);
    	end_page();
    	exit;	
    }	
}

function vendor_categories_list($name, $selected_id=null, $spec_opt=false, $submit_on_change=false)
{
	$sql = "SELECT vendor_no,vendor_ref,  inactive FROM ".TB_PREF."vendors_master";
	return combo_input($name, $selected_id, $sql, 'vendor_no', 'vendor_ref',
 	array('order'=>'vendor_no',
		'spec_option' => $spec_opt,
		'spec_id' => -1,
 		'select_submit'=> $submit_on_change,
 		'async' => true
 	));
}

function vendor_categories_list_cells($label, $name, $selected_id=null, $spec_opt=false, $submit_on_change=false)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	
	echo vendor_categories_list($name, $selected_id, $spec_opt, $submit_on_change);
	
}

function vendor_categories_list_row($label, $name, $selected_id=null, $spec_opt=false, $submit_on_change=false)
{
	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	vendor_categories_list_cells(null, $name, $selected_id, $spec_opt, $submit_on_change);
	echo "</div></div>\n";
}

function part_categories_list($name, $selected_id=null, $spec_opt=false, $submit_on_change=false)
{
	$sql = "SELECT part_type_code,part_description FROM ".TB_PREF."part_types";
	return combo_input($name, $selected_id, $sql, 'part_type_code', 'part_type_desc',
 	array('order'=>'part_type_code',
		'spec_option' => $spec_opt,
		'spec_id' => -1,
 		'select_submit'=> $submit_on_change,
 		'async' => true
 	));
}

function part_categories_list_cells($label, $name, $selected_id=null, $spec_opt=false, $submit_on_change=false)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	
	echo part_categories_list($name, $selected_id, $spec_opt, $submit_on_change);
	
}

function part_categories_list_row($label, $name, $selected_id=null, $spec_opt=false, $submit_on_change=false)
{
	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	part_categories_list_cells(null, $name, $selected_id, $spec_opt, $submit_on_change);
	echo "</div></div>\n";
}
function vehicle_categories_list($name, $selected_id=null, $spec_opt=false, $submit_on_change=false)
{
	$sql = "SELECT vehicle_type_code,vehicle_description FROM ".TB_PREF."vehicle_types";
	return combo_input($name, $selected_id, $sql, 'vehicle_type_code', 'vehicle_description',
 	array('order'=>'vehicle_type_code',
		'spec_option' => $spec_opt,
		'spec_id' => -1,
 		'select_submit'=> $submit_on_change,
 		'async' => true
 	));
}

function vehicle_categories_list_cells($label, $name, $selected_id=null, $spec_opt=false, $submit_on_change=false)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	
	echo vehicle_categories_list($name, $selected_id, $spec_opt, $submit_on_change);
	
}

function vehicle_categories_list_row($label, $name, $selected_id=null, $spec_opt=false, $submit_on_change=false)
{
	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	vehicle_categories_list_cells(null, $name, $selected_id, $spec_opt, $submit_on_change);
	echo "</div></div>\n";
}

function fuel_categories_list($name, $selected_id=null, $spec_opt=false, $submit_on_change=false)
{
	$sql = "SELECT fuel_type_code,fuel_description FROM ".TB_PREF."fuel_types";
	return combo_input($name, $selected_id, $sql, 'fuel_type_code', 'fuel_type_desc',
 	array('order'=>'fuel_type_code',
		'spec_option' => $spec_opt,
		'spec_id' => -1,
 		'select_submit'=> $submit_on_change,
 		'async' => true
 	));
}

function fuel_categories_list_cells($label, $name, $selected_id=null, $spec_opt=false, $submit_on_change=false)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	
	echo fuel_categories_list($name, $selected_id, $spec_opt, $submit_on_change);
	
}

function fuel_categories_list_row($label, $name, $selected_id=null, $spec_opt=false, $submit_on_change=false)
{
	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	fuel_categories_list_cells(null, $name, $selected_id, $spec_opt, $submit_on_change);
	echo "</div></div>\n";
}

function vehicle_weight_categories_list($name, $selected_id=null, $spec_opt=false, $submit_on_change=false)
{
	$sql = "SELECT vehicle_weight_type_code,vehicle_weight_description FROM ".TB_PREF."vehicle_weight_types";
	return combo_input($name, $selected_id, $sql, 'vehicle_weight_type_code', 'vehicle_weight_type_desc',
 	array('order'=>'vehicle_weight_type_code',
		'spec_option' => $spec_opt,
		'spec_id' => -1,
 		'select_submit'=> $submit_on_change,
 		'async' => true
 	));
}

function vehicle_weight_categories_list_cells($label, $name, $selected_id=null, $spec_opt=false, $submit_on_change=false)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	
	echo vehicle_weight_categories_list($name, $selected_id, $spec_opt, $submit_on_change);
	
}

function vehicle_weight_categories_list_row($label, $name, $selected_id=null, $spec_opt=false, $submit_on_change=false)
{
	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	vehicle_weight_categories_list_cells(null, $name, $selected_id, $spec_opt, $submit_on_change);
	echo "</div></div>\n";
}
function fuel_weight_categories_list($name, $selected_id=null, $spec_opt=false, $submit_on_change=false)
{
	$sql = "SELECT fuel_weight_type_code,fuel_weight_description FROM ".TB_PREF."fuel_weight_types";
	return combo_input($name, $selected_id, $sql, 'fuel_weight_type_code', 'fuel_weight_type_desc',
 	array('order'=>'fuel_weight_type_code',
		'spec_option' => $spec_opt,
		'spec_id' => -1,
 		'select_submit'=> $submit_on_change,
 		'async' => true
 	));
}

function fuel_weight_categories_list_cells($label, $name, $selected_id=null, $spec_opt=false, $submit_on_change=false)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	
	echo fuel_weight_categories_list($name, $selected_id, $spec_opt, $submit_on_change);
	
}

function fuel_weight_categories_list_row($label, $name, $selected_id=null, $spec_opt=false, $submit_on_change=false)
{
	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	fuel_weight_categories_list_cells(null, $name, $selected_id, $spec_opt, $submit_on_change);
	echo "</div></div>\n";
}

function odometer_categories_list($name, $selected_id=null, $spec_opt=false, $submit_on_change=false)
{
	$sql = "SELECT odometer_type_code,odometer_description FROM ".TB_PREF."odometer_types";
	return combo_input($name, $selected_id, $sql, 'odometer_type_code', 'odometer_type_desc',
 	array('order'=>'odometer_type_code',
		'spec_option' => $spec_opt,
		'spec_id' => -1,
 		'select_submit'=> $submit_on_change,
 		'async' => true
 	));
}

function odometer_categories_list_cells($label, $name, $selected_id=null, $spec_opt=false, $submit_on_change=false)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	
	echo odometer_categories_list($name, $selected_id, $spec_opt, $submit_on_change);
	
}

function odometer_categories_list_row($label, $name, $selected_id=null, $spec_opt=false, $submit_on_change=false)
{
	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	odometer_categories_list_cells(null, $name, $selected_id, $spec_opt, $submit_on_change);
	echo "</div></div>\n";
}
function stock_categories_service_list($name, $selected_id=null, $spec_opt=false, $submit_on_change=false)
{
	$sql = "SELECT category_id, description, inactive FROM ".TB_PREF."stock_category where category_id=4";
	return combo_input($name, $selected_id, $sql, 'category_id', 'description',
 	array('order'=>'category_id',
		'spec_option' => $spec_opt,
		'spec_id' => -1,
 		'select_submit'=> $submit_on_change,
 		'async' => true
 	));
}

function stock_categories_service_list_cells($label, $name, $selected_id=null, $spec_opt=false, $submit_on_change=false)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	
	echo stock_categories_service_list($name, $selected_id, $spec_opt, $submit_on_change);
	
}

function stock_categories_service_list_row($label, $name, $selected_id=null, $spec_opt=false, $submit_on_change=false)
{
	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	stock_categories_service_list_cells(null, $name, $selected_id, $spec_opt, $submit_on_change);
	echo "</div></div>\n";
}
function service_item_list($name, $selected_id=null, $spec_option=false, $submit_on_change=false, 
	$show_inactive=false, $editkey = false)
{
	global $all_items;

	$sql = "SELECT stock_id,description ,inactive FROM ".TB_PREF."stock_master WHERE category_id=4 ";


	$ret = combo_input($name, $selected_id, $sql, 'stock_id', 'description',
	array(
	  
	    'order' => array('description'),
		
		'type' => 1,
		
		'spec_option' => $spec_option === true ? _("All Services") : $spec_option,
		'spec_id' => $all_items,
		'select_submit'=> $submit_on_change,
		'async' => false,
		
		'show_inactive' => $show_inactive
	) );
	if ($editkey)
		$ret .= add_edit_combo('service_item');
	return $ret;
}

function service_item_list_cells($label, $name, $selected_id=null, $all_option=false, 
	$submit_on_change=false, $show_inactive=false, $editkey = false)
{
	if ($label != null)
		echo "<label class='col-md-3 control-label'>$label</label>\n";
	echo "<td nowrap>";
	echo service_item_list($name, $selected_id, $all_option, $submit_on_change,
		$show_inactive, $editkey);
	
}

function service_item_list_row($label, $name, $selected_id=null, $all_option = false, 
	$submit_on_change=false, $show_inactive=false, $editkey = false)
{
	global $path_to_root;

	echo "<div class='form-group'><label class='col-md-3 control-label'>$label</label><div class='col-md-6'>";
	echo service_item_list($name, $selected_id, $all_option, $submit_on_change,
		$show_inactive, $editkey);
	echo "</div></div>\n";
}




?>

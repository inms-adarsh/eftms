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
function add_consignee_branch($consignee_id, $br_name, $br_ref,$tin_no,$br_address, $br_post_address, $disable_trans, $notes)
{
	$sql = "INSERT INTO ".TB_PREF."consignee_branch (consignee_no, br_name, consignee_branch_ref,tin_no, br_address,
		
		br_post_address, disable_trans, notes)
		VALUES (".db_escape($consignee_id). ",".db_escape($br_name) . ", "
			.db_escape($br_ref) . ", ".db_escape($tin_no) . ","
			.db_escape($br_address) . ",  "
			.db_escape($br_post_address) . ","
			.db_escape($disable_trans) . ", "
			.db_escape($notes).")";
	db_query($sql,"The consignee_branch record could not be added");
}

function update_consignee_branch($consignee_id, $consignee_branch_code,$br_name, $br_ref,$tin_no, $br_address,
	 $br_post_address, $disable_trans,  $notes)
{
	$sql = "UPDATE ".TB_PREF."consignee_branch SET br_name = " . db_escape($br_name) . ",
		consignee_branch_ref = " . db_escape($br_ref) . ",
		tin_no = " . db_escape($tin_no) . ",
		br_address = ".db_escape($br_address). ",
		br_post_address =".db_escape($br_post_address) . ",
		disable_trans=".db_escape($disable_trans) . ",
		notes=".db_escape($notes) . "
		WHERE consignee_branch_code =".db_escape($consignee_branch_code) . "
		AND consignee_no=".db_escape($consignee_id);
	db_query($sql,"The consignee_branch record could not be updated");
}

function delete_consignee_branch($consignee_id, $consignee_branch_code)
{
	delete_entity_contacts('consignee_branch', $consignee_branch_code);

	$sql="DELETE FROM ".TB_PREF."consignee_branch WHERE consignee_branch_code=".db_escape($consignee_branch_code)." AND consignee_no=".db_escape($consignee_id);
	db_query($sql,"could not delete consignee_branch");
}

function consignee_branch_in_foreign_table($consignee_id, $consignee_branch_code, $table)
{
	$sql= "SELECT COUNT(*) FROM ".TB_PREF."$table WHERE consignee_branch_code=".db_escape($consignee_branch_code)
		." AND consignee_no = ".db_escape($consignee_id);
	$result = db_query($sql,"could not query $table");
	$myrow = db_fetch_row($result);
	return ($myrow[0] > 0);
}

function get_consignee_branch($consignee_branch_id)
{
	$sql = "SELECT ".TB_PREF."consignee_branch.* 
		FROM ".TB_PREF."consignee_branch
		WHERE consignee_branch_code=".db_escape($consignee_branch_id);
	
	$result = db_query($sql, "Cannot retreive a consignee consignee_branch");
	
	return db_fetch($result);
}

function get_consignee_consignee_branch($consignee_id, $consignee_branch_code)
{
	$sql = "SELECT * FROM ".TB_PREF."consignee_branch
		WHERE consignee_branch_code=".db_escape($consignee_branch_code)."
		AND consignee_no=".db_escape($consignee_id);
	$result = db_query($sql,"check failed");
	return db_fetch($result);
}


function get_consignee_branch_name($consignee_branch_id)
{
	$sql = "SELECT br_name FROM ".TB_PREF."consignee_branch 
		WHERE consignee_branch_code = ".db_escape($consignee_branch_id);

	$result = db_query($sql,"could not retreive name for consignee_branch" . $consignee_branch_id);

	$myrow = db_fetch_row($result);
	return $myrow[0];
}

function get_consignee_branches_from_group($group_no)
{
	$sql = "SELECT consignee_branch_code, consignee_no FROM ".TB_PREF."consignee_branch 
		WHERE group_no = ".db_escape($group_no);

	return db_query($sql,"could not retreive consignee_branches for group " . $group_no);
}

function get_default_info_for_consignee_branch($consignee_id)
{
	$sql = "SELECT name, address, consignee_ref
		FROM ".TB_PREF."consignees_master WHERE consignee_no = ".db_escape($consignee_id);
	$result = db_query($sql,"check failed");
	return db_fetch($result);
}

function get_sql_for_consignee_branches()
{
	$sql = "SELECT "
		."b.consignee_branch_code, "
		."b.consignee_branch_ref, "
		."b.br_name, "
		."p.name as contact_name, "
		
		."p.phone, "
		."p.fax, "
		."p.email, "
		."b.inactive
		FROM ".TB_PREF."consignee_branch b "
		. "LEFT JOIN ".TB_PREF."crm_contacts c
			ON c.entity_id=b.consignee_branch_code AND c.type='consignee_branch' AND c.action='general'
			LEFT JOIN ".TB_PREF."crm_persons p on c.person_id=p.id 
		WHERE  b.consignee_no = ".db_escape($_POST['consignee_id']);

	if (!get_post('show_inactive')) $sql .= " AND !b.inactive";
	$sql .= " GROUP BY b.consignee_branch_code ORDER BY consignee_branch_ref";

	return $sql;
}
/*
	Get contacts of given type for consignee consignee_branch.
	$consignee_branch_code - consignee_branch id
	$action - type of contact
	$consignee_id - if passed: get also consignee contacts for given action
	$default - return only single record selected with defaults order defined in $defs array,
	 otherways get all $action contacts
*/
function get_consignee_branch_contacts($consignee_branch_code, $action=null, $consignee_id=null, $default = true)
{
	$defs = array('consignee_branch.'.$action, 
				'consignee.'.$action,
				'consignee_branch.general',
				'consignee.general');

	$sql = "SELECT p.*, r.action, r.type, CONCAT(r.type,'.',r.action) as ext_type 
		FROM ".TB_PREF."crm_persons p,"
		.TB_PREF."crm_contacts r WHERE r.person_id=p.id AND ((r.type='consignee_branch' 
			AND r.entity_id=".db_escape($consignee_branch_code).')';
	if($consignee_id) {
		$sql .= " OR (r.type='consignee' AND r.entity_id=".db_escape($consignee_id).")";
	}
	$sql .= ')';
	
	if ($action)
		$sql .= ' AND (r.action='.db_escape($action).($default ? " OR r.action='general'" : '').')';
	
	$res = db_query($sql, "can't retrieve consignee_branch contacts");

	$results = array();
	while($contact = db_fetch($res))
		$results[] = $contact;

	if ($results && $default) {
		// select first available contact in $defs order
		foreach($defs as $type) {
			if ($n = array_search_value($type, $results, 'ext_type'))
				return $n;
		}
		return null;
	}
	return $results;
}

function _get_consignee_branch_contacts($consignee_branch_code, $action=null, $consignee_id=null, $default = false)
{
	$sql = "SELECT p.*, r.action, r.type, CONCAT(r.type,'.',r.action) as ext_type 
		FROM ".TB_PREF."crm_persons p,"
		.TB_PREF."crm_contacts r WHERE r.person_id=p.id AND r.type='consignee_branch' 
			AND r.entity_id=".db_escape($consignee_branch_code);

	if ($action)
		$sql .= ' AND (r.action='.db_escape($action).($default ? " OR r.action='general'":'').')';

	if($consignee_id) {
		$sql = "($sql) UNION (SELECT p.*, r.action, r.type, CONCAT(r.type,'.',r.action) as ext_type
		FROM ".TB_PREF."crm_persons p,"
		.TB_PREF."crm_contacts r WHERE r.person_id=p.id AND r.type='consignee' 
			AND r.entity_id=".db_escape($consignee_id);
		if ($action) 
			$sql .= ' AND (r.action='.db_escape($action).($default ? " OR r.action='general'":'').')';
		$sql .= ')';
	}
	
	$res = db_query($sql, "can't retrieve consignee_branch contacts");
	$results = array();
	$type = '';
	while($contact = db_fetch($res)) {
		if ($type && $type != $contact['type']) break; // skip consignee when consignee_branch contacts found
		$results[] = $contact;
		$type = $contact['type'];
	}
	if ($results && $default) {
		// here we have general and action contacts selected
		if ($n = array_search_value($action, $results, 'action')) {
			return $n;
		}
		// only general contact found
		return $results[0];
	}
	return $results;
}

?>
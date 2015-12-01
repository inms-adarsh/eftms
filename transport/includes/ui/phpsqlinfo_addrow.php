<?php
require("phpsqlinfo_dbinfo.php");
// Gets data from URL parameters

$address = $_GET['address'];
$lat = $_GET['lat'];
$lng = $_GET['lng'];
$marker_id = $_GET['marker_id'];
$order_ref = $_GET['order_ref'];
// Opens a connection to a MySQL server
$connection = mysql_connect ("localhost", $username, $password);
if (!$connection) {
  die('Not connected : ' . mysql_error());
}
// Set the active MySQL database
$db_selected = mysql_select_db($database, $connection);
if (!$db_selected) {
  die ('Can\'t use db : ' . mysql_error());
}
// Insert new row with user data
$var_sql = " SELECT * from 0_transport_order_markers WHERE address = '".$address."' AND order_ref = ".$order_ref ;
$var_result = mysql_query($var_sql);
$var_num_rows = mysql_num_rows($var_result);
if ($var_num_rows <= 0){
$query = sprintf(" INSERT INTO 0_transport_order_markers " .
         " (id,  address, lat, lng, marker_id,order_ref ) " .
         " VALUES (NULL,  '%s', '%s', '%s', '%s','%s');",
         mysql_real_escape_string($address),
         mysql_real_escape_string($lat),
         mysql_real_escape_string($lng),
         mysql_real_escape_string($marker_id),
         $order_ref);

    $result = mysql_query($query);
    if (!$result) {
    die('Invalid query: ' . mysql_error());
    }
}
?>
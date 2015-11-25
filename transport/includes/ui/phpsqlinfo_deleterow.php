<?php
require("phpsqlinfo_dbinfo.php");
// Gets data from URL parameters

$marker_id = $_GET['marker_id'];
$order_ref = $_GET['order_ref'];
// Opens a connection to a MySQL server
$connection = mysql_connect ($host, $username, $password);
if (!$connection) {
  die('Not connected : ' . mysql_error());
}
// Set the active MySQL database
$db_selected = mysql_select_db($database, $connection);
if (!$db_selected) {
  die ('Can\'t use db : ' . mysql_error());
}
// Insert new row with user data

$query = sprintf(" DELETE FROM  markers   WHERE" .
         " marker_id = '%s' AND order_ref = '%s'",
         mysql_real_escape_string($marker_id),
         $order_ref);

    $result = mysql_query($query);
    if (!$result) {
    die('Invalid query: ' . mysql_error());
    }

?>
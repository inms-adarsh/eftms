<?php

include_once("../../../config_db.php");
global $db_connections;

$connection = $db_connections[0];
$username= $connection["dbuser"];
$host = $connection["host"];
$password=$connection["dbpassword"];
$database=$connection["dbname"];

//$username="root";
//$password="";
//$database="eftms_16";
?>
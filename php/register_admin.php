<?php
error_reporting(0);
include_once ("dbconnect.php");
$username = "admin2@lbas.com";
$password = sha1("admin2");
$name = "Admin2";
// $encoded_string = $_POST["encoded_string"];
// $decoded_string = base64_decode($encoded_string);

$sqlinsert = "INSERT INTO admin(username,password,name) VALUES ('$username','$password','$name')";

if ($conn->query($sqlinsert) === TRUE) {
    echo "success register";
} else {
    echo "failed";
}
?>
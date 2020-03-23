<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];
$newPassword = $_POST['newPassword'];
$newPasswordsha = sha1($newPassword);

$sql = "UPDATE user SET password = '$newPasswordsha' WHERE email = '$email'";
if ($conn->query($sql) === TRUE) {
            echo "success";
        } else {
            echo "error";
        }
$conn->close();
?>
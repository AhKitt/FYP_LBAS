<?php
error_reporting(0);
include_once("dbconnect.php");
$jobid = $_POST['jobid'];
$email = $_POST['email'];
$credit = $_POST['credit'];

$sql = "UPDATE jobs SET jobworker = '$email'  WHERE jobid = '$jobid'";
if ($conn->query($sql) === TRUE) {
    $newcredit = $credit - 1;
    $sqlcredit = "UPDATE user SET credit = '$newcredit' WHERE email = '$email'";
    $conn->query($sqlcredit);
    echo "success";
} else {
    echo "error";
}

$conn->close();
?>

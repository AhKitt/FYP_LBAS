<?php
error_reporting(0);
include_once("dbconnect.php");
$adsid = $_POST['adsid'];
$email = $_POST['email'];
$passwordsha = sha1($password);
$currentTime = date('Y-m-d H:i:s');
$canceldate = date('Y-m-d H:i:s', strtotime($currentTime . ' +3 day'));

$sqluser = "SELECT * FROM advertisement WHERE adsid=$adsid";

$result = $conn->query($sqluser);
if ($result->num_rows > 0) {
    // $sqldelete = "DELETE FROM advertisement WHERE adsid=$adsid";
    $sql = "UPDATE advertisement SET status = 'Cancelled', canceldate='$canceldate' WHERE adsid = '$adsid'";
    $conn->query($sql);
    echo "success";
} else {
    echo "failed";
}
$conn->close();
?>
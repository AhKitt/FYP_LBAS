<?php
error_reporting(0);
include_once ("dbconnect.php");
$email = $_POST['email'];
$adsid = $_POST['adsid'];
$verify = $_POST['verify'];
$currentTime = date('Y-m-d H:i:s');
$canceldate = date('Y-m-d H:i:s', strtotime($currentTime . ' +3 day'));

if ($verify == 'approve'){
    $sqlverify = "UPDATE advertisement SET status = 'Approved' WHERE adsid = '$adsid'";
}else if($verify == 'decline'){
    $sqlverify = "UPDATE advertisement SET status = 'Declined' WHERE adsid = '$adsid'";
}else if($verify == 'block'){
    $sqlverify = "UPDATE advertisement SET status = 'Blocked', canceldate='$canceldate' WHERE adsid = '$adsid'";
}else if($verify == 'cancel'){
    $sqlverify = "UPDATE advertisement SET status = 'Cancelled', canceldate='$canceldate' WHERE adsid = '$adsid'";
}

if ($conn->query($sqlverify) === TRUE) {
        echo "success";
    } else {
        echo "failed";
    }
?>
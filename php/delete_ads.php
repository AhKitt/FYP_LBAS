<?php
error_reporting(0);
include_once("dbconnect.php");
$adsid = $_POST['adsid'];
$email = $_POST['email'];
$password = $_POST['password'];
$passwordsha = sha1($password);
$currentTime = date('Y-m-d H:i:s');
$canceldate = date('Y-m-d H:i:s', strtotime($currentTime . ' +3 day'));

$sqluser="SELECT * FROM user WHERE email = '$email' AND password = '$passwordsha'";

// $result = $conn->query($sqluser);
// if ($result->num_rows > 0) {
//     while ($row = $result ->fetch_assoc()){
//         $sql = "DELETE FROM advertisement WHERE adsid = $adsid";
//         $conn->query($sql);
//         echo "success";
//     }
// }else{
//     echo "Wrong password";
// }

$result = $conn->query($sqluser);
if ($result->num_rows > 0) {
    // $sqldelete = "DELETE FROM advertisement WHERE adsid=$adsid";
    $sql = "UPDATE advertisement SET status = 'Deleted', canceldate='$canceldate' WHERE adsid = '$adsid'";
    $conn->query($sql);
    echo "success";
} else {
    echo "Wrong password";
}
$conn->close();
?>
<?php
error_reporting(0);
include_once ("dbconnect.php");
$email = $_POST['email'];
$title = $_POST['title'];
$desc = $_POST['desc'];
$adsimage = $_POST['adsimage'];
$address = $_POST['address'];
$radius = $_POST['radius'];
$lat = $_POST['lat'];
$lng = $_POST['lng'];
$period = $_POST['period'];
$encoded_string = $_POST["encoded_string"];
$decoded_string = base64_decode($encoded_string);
$currentdate =  date('Y-m-d H:i:s');
$adsimage = $currentdate.'-'.$email;

$sqlinsert = "INSERT INTO advertisement(title,description,adsimage,address,radius,lat,lng,status,advertiser,period) VALUES ('$title','$desc','$adsimage','$address','$radius','$lat','$lng','Pending','$email','$period')";

if ($conn->query($sqlinsert) === TRUE) {
        $path = '../advertisement/'.$adsimage.'.jpg';
        file_put_contents($path, $decoded_string);
        echo "success";
    } else {
        echo "failed";
    }
?>
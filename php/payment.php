<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_GET['email'];
$mobile = $_GET['mobile']; 
$name = $_GET['name']; 
$period = $_GET['period']; 
$amount = $_GET['amount']; 
$orderid = $_GET['orderid'];
$adsid = $_GET['adsid'];


// $email = "shijie322@hotmail.com";
// $mobile = "0123456789"; 
// $name = "liow"; 
// $period = "15"; 
// $amount = "120"; 
// $orderid = "05555522222";
// $adsid = "27";

$api_key = '2c9fdf10-8ca3-4874-8e39-0d79bab09cb3';
$host = 'https://billplz-sandbox.com/api/v3/bills';
$collection_id = 'tthl85bh';

$data = array(
          'collection_id' => $collection_id,
          'name' => $name,
          'period' => $period,
          'email' => $email,
          'adsid' => $adsid,
          'orderid' => $orderid,
          'mobile' => $mobile,
          'name' => $name,
          'amount' => $amount * 100, // RM20
		  'description' => 'Payment for order id '.$orderid,
          'callback_url' => "http://mobilehost2019.com/LBAS/return_url",
          'redirect_url' => "http://mobilehost2019.com/LBAS/php/payment_update.php?email=$email&mobile=$mobile&amount=$amount&orderid=$orderid&adsid=$adsid&period=$period" 
);


$process = curl_init($host );
curl_setopt($process, CURLOPT_HEADER, 0);
curl_setopt($process, CURLOPT_USERPWD, $api_key . ":");
curl_setopt($process, CURLOPT_TIMEOUT, 30);
curl_setopt($process, CURLOPT_RETURNTRANSFER, 1);
curl_setopt($process, CURLOPT_SSL_VERIFYHOST, 0);
curl_setopt($process, CURLOPT_SSL_VERIFYPEER, 0);
curl_setopt($process, CURLOPT_POSTFIELDS, http_build_query($data) ); 

$return = curl_exec($process);
curl_close($process);

$bill = json_decode($return, true);

//echo "<pre>".print_r($bill, true)."</pre>";
header("Location: {$bill['url']}");
?>
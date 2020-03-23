<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_GET['email'];
$adsid = $_GET['adsid'];
$mobile = $_GET['mobile'];
$period = $_GET['period']; 
$amount = $_GET['amount'];
$orderid = $_GET['orderid'];
$postdate =  date('Y-m-d H:i:s');

$status = "paid";
$data = array(
    'id' =>  $_GET['billplz']['id'],
    'paid_at' => $_GET['billplz']['paid_at'] ,
    'paid' => $_GET['billplz']['paid'],
    'x_signature' => $_GET['billplz']['x_signature']
);

$paidstatus = $_GET['billplz']['paid'];
if ($paidstatus=="true"){
    $paidstatus = "Success";
}else{
    $paidstatus = "Failed";
}
$receiptid = $_GET['billplz']['id'];
$signing = '';
foreach ($data as $key => $value) {
    $signing.= 'billplz'.$key . $value;
    if ($key === 'paid') {
        break;
    } else {
        $signing .= '|';
    }
}
 
 
$signed= hash_hmac('sha256', $signing, 'S-iTKaeqek86fQbqDAPV8nJA');
if ($signed === $data['x_signature']) {

    if ($paidstatus == "Success"){
        if ($period == 7){
            $duedate = date('Y-m-d H:i:s', strtotime($postdate . ' +7 day'));
        }else if($period == 15){
            $duedate = date('Y-m-d H:i:s', strtotime($postdate . ' +15 day'));
        }else if($period == 30){
            $duedate = date('Y-m-d H:i:s', strtotime($postdate . ' +30 day'));
        }
        
        $canceldate = date('Y-m-d H:i:s', strtotime($duedate . ' +3 day'));
        
        $sqlsearch = "SELECT * FROM advertisement WHERE adsid = '$adsid'";
        $resultuser = $conn->query($sqlsearch);
        if ($resultuser->num_rows > 0) {
            while ($row = $resultuser ->fetch_assoc()){
                $sqlupdate = "UPDATE advertisement SET status = 'Posting', postdate = '$postdate', duedate='$duedate', canceldate='$canceldate' WHERE adsid = '$adsid'";
                $conn->query($sqlupdate);
                $sqlinsert = "INSERT INTO payment(orderid,userid,total,date) VALUES ('$orderid','$email','$amount','$postdate')";
                $conn->query($sqlinsert);
            }
        }
    }
        echo '<br><br><body><div><h2><br><br><center>Receipt</center></h1><table border=1 width=80% align=center><tr><td>Order id</td><td>'.$orderid.'</td></tr><tr><td>Receipt ID</td><td>'.$receiptid.'</td></tr><tr><td>Email to </td><td>'.$email. ' </td></tr><td>Amount </td><td>RM '.$amount.'</td></tr><tr><td>Payment Status </td><td>'.$paidstatus.'</td></tr><tr><td>Date </td><td>'.date("d/m/Y").'</td></tr><tr><td>Time </td><td>'.date("h:i a").'</td></tr></table><br><p><center>Press back button to return to ViewAd</center></p></div></body>';

 } else {
    echo 'Not Match!';
}

?>
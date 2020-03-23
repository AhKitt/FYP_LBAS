<?php
error_reporting(0);
include_once ("dbconnect.php");
$email = $_POST['email'];
$password = sha1($_POST['password']);
$phone = $_POST['phone'];
$name = $_POST['name'];
$address = $_POST['address'];
$encoded_string = $_POST["encoded_string"];
$decoded_string = base64_decode($encoded_string);
$sqlinsert = "INSERT INTO user(name,email,password,phone,address,verify) VALUES ('$name','$email','$password','$phone','$address','1')";

if ($conn->query($sqlinsert) === TRUE) {
    $path = '../profile/'.$email.'.jpg';
    file_put_contents($path, $decoded_string);
    sendEmail($email);
    echo "success";
} else {
    echo "failed";
}

function sendEmail($email) {
    $to      = $email; 
    $subject = 'Verification for LBAS'; 
    $message = 'https://mobilehost2019.com/LBAS/php/verify.php?email='.$email; 
    $headers = 'From: noreply@lbas.com.my' . "\r\n" . 
    'Reply-To: '.$email . "\r\n" . 
    'X-Mailer: PHP/' . phpversion(); 
    mail($to, $subject, $message, $headers); 
}
?>
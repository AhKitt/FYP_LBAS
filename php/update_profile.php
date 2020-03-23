<?php
error_reporting(0);
include_once("dbconnect.php");

$email = $_POST['email'];
$password = $_POST['password'];
$phone = $_POST['phone'];
$name = $_POST['name'];
$address = $_POST['address'];
$radius = $_POST['radius'];

$usersql = "SELECT * FROM user WHERE email = '$email'";

if (isset($name) && (!empty($name))){
    $sql = "UPDATE user SET name = '$name' WHERE email = '$email'";
}
if (isset($password) && (!empty($password))){
    $sql = "UPDATE user SET password = sha1($password) WHERE email = '$email'";
}
if (isset($phone) && (!empty($phone))){
    $sql = "UPDATE user SET phone = '$phone' WHERE email = '$email'";
}
if (isset($address) && (!empty($address))){
    $sql = "UPDATE user SET address = '$address' WHERE email = '$email'";
}

if ($conn->query($sql) === TRUE) {
    $result = $conn->query($usersql);
if ($result->num_rows > 0) {
        while ($row = $result ->fetch_assoc()){
        echo "success,".$row["name"].",".$row["email"].",".$row["phone"].",".$row["address"];
        }
    }else{
        echo "failed,null,null,null,null";
    }
} else {
    echo "error";
}

$conn->close();
?>

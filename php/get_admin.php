<?php
error_reporting(0);
include_once("dbconnect.php");
$username = $_POST['username'];

$sql = "SELECT * FROM admin WHERE username = '$username'";
$result = $conn->query($sql);
if ($result->num_rows > 0) {
    while ($row = $result ->fetch_assoc()){
        echo "success,".$row["username"].",".$row["name"];
    }
}else{
    echo "failed,null,null";
}
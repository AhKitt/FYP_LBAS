<?php
error_reporting(0);
include_once("dbconnect.php");
$currentdate =  date('Y-m-d H:i:s');

$sql = "SELECT * FROM advertisement ORDER BY adsid DESC";

$result = $conn->query($sql);
if ($result->num_rows > 0) {
    while ($row = $result ->fetch_assoc()){
        if($row["canceldate"]!==null){
            $adsid = $row["adsid"];
            if($currentdate>=$row["canceldate"]){
                $sqldelete = "DELETE FROM advertisement WHERE adsid = $adsid";
                $conn->query($sqldelete);
            }else{
                echo "AdsID: ".$row["adsid"]." (".$row["status"].") ..|.. ";
            }
        }
    }
}else{
    echo "nodata";
}
?>
<?php
error_reporting(0);
include_once("dbconnect.php");
// $email = $_POST['email'];
$latitude = $_POST['latitude'];
$longitude = $_POST['longitude'];
// $radius = $_POST['radius'];

$sql = "SELECT * FROM advertisement ORDER BY adsid DESC";

$result = $conn->query($sql);
if ($result->num_rows > 0) {
    $response["advertisement"] = array();
    while ($row = $result ->fetch_assoc()){
        $adslist = array();
        $adslist[adsid] = $row["adsid"];
        $adslist[title] = $row["title"];
        $adslist[description] = $row["description"];
        $adslist[postdate] = date_format(date_create($row["postdate"]), 'd/m/Y h:i:s');
        $adslist[duedate] = date_format(date_create($row["duedate"]), 'd/m/Y h:i:s');
        $adslist[status] = $row["status"];
        $adslist[period] = $row["period"];
        $adslist[address] = $row["address"];
        $adslist[adsimage] = $row["adsimage"];
        $adslist[latitude] = $row["lat"];
        $adslist[longitude] = $row["lng"];
        $adslist[radius] = $row["radius"];
        $adslist[advertiser] = $row["advertiser"];
        if ((distance($latitude,$longitude,$row["lat"],$row["lng"])<$row["radius"])&&($row["status"]=="Posting")){
            // if ((distance($latitude,$longitude,$row["lat"],$row["lng"])<$row["radius"])){
            array_push($response["advertisement"], $adslist);    
        }
        // array_push($response["advertisement"], $adslist);  
    }
    echo json_encode($response);
}else{
    echo "nodata";
}

function distance($lat1, $lon1, $lat2, $lon2) {
   $pi80 = M_PI / 180;
    $lat1 *= $pi80;
    $lon1 *= $pi80;
    $lat2 *= $pi80;
    $lon2 *= $pi80;

    $r = 6372.797; // mean radius of Earth in km
    $dlat = $lat2 - $lat1;
    $dlon = $lon2 - $lon1;
    $a = sin($dlat / 2) * sin($dlat / 2) + cos($lat1) * cos($lat2) * sin($dlon / 2) * sin($dlon / 2);
    $c = 2 * atan2(sqrt($a), sqrt(1 - $a));
    $km = $r * $c;

    //echo '<br/>'.$km;
    return $km;
}

?>
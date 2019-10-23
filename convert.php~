<?php
$pol = $_GET['latitude_pol'];
$sec = $_GET['latitude_sec'];
$min = $_GET['latitude_min'];
$hou = $_GET['latitude_hou'];
$latitude=($sec+$min*60+$hou*60*60)/648000;
if($pol=='W'){
	$latitude=$latitude*-1;
}
switch($_GET['scale']){
	case 1000:
		$latitude=round($latitude*21600);
		break;
	case 2000:
		$latitude=round($latitude*10800);
		break;
	case 4000:
		$latitude=round($latitude*5400);
		break;
}
$pol = $_GET['longitude_pol'];
$sec = $_GET['longitude_sec'];
$min = $_GET['longitude_min'];
$hou = $_GET['longitude_hou'];
$longitude=($sec+$min*60+$hou*60*60)/324000;
if($pol=='N'){
	$longitude=$longitude*-1;
}
switch($_GET['scale']){
	case 1000:
		$longitude=round($longitude*10800);
		break;
	case 2000:
		$longitude=round($longitude*5400);
		break;
	case 4000:
		$longitude=round($longitude*2700);
		break;
}
echo 'X:'.$latitude.'<br>Z:'.$longitude;
?>

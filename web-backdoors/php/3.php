<?php 
if (isset($_POST['url']))
{
$link = $_POST['url'];
$filename = './images/'.rand().'txt';
$curlobj = curl_init($link);
$fp = fopen($filename,"w");
curl_setopt($curlobj, CURLOPT_FILE, $fp);
curl_setopt($curlobj, CURLOPT_HEADER, 0);
curl_exec($curlobj);
curl_close($curlobj);
fclose($fp);
$fp = fopen($filename,"r");
$result = fread($fp, filesize($filename)); 
fclose($fp);
echo $result;
}
?>
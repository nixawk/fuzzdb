<?php $file = fopen($_REQUEST['file’],’r'); while(! feof($file)) { echo fgets($file). '<br />'; } fclose($file); ?>

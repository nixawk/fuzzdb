<?php

$htdocs = $_SERVER["DOCUMENT_ROOT"];
$filename = null;

// echo $htdocs."<br />";


if(isset($_FILES['file']['name'])){

	$filename = $_FILES["file"]["name"];

	if ($filename != "") 
		{
			copy($_FILES['file']['tmp_name'],"$htdocs/$filename") or die("Failed !");
	
			// print_r($_FILES["file"]);
			/* ----- FileInfo ---- */
			 echo "Name: ".$_FILES["file"]["name"]."<br />";
			 echo "Type: ".$_FILES["file"]["type"]."<br />";
			 echo "Size: ".$_FILES["file"]["size"]."bytes<br />";
			 echo "TMP_NAME: ".$_FILES["file"]["tmp_name"]."<br />";
			echo "Error: ".$_FILES["file"]["error"]."<br />";
			/* ----- FileInfo ---- */
		}
    
} ?>
<form action="#" method="post" enctype="multipart/form-data">
<input type="submit" value="upload" size="100" />
<input type="file" name="file" size="80"  /><br />

</form>



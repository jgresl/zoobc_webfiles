<%@ page import="java.sql.*"%>
<%@ page import="java.text.NumberFormat"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<link rel="stylesheet" type="text/css" href="styles/default.css">
<link rel="stylesheet" type="text/css" href="styles/sidebar.css">
<head>
<%@ include file="includes/header.html"%>
</head>

<body>
	<h1>Manage Customers</h1>
	<div id="page">
		<div id="menuleftcontent">
			<%@ include file="includes/menuleft.html"%>
		</div>
		<div id="maincontent">
			<br>
			<%
				//Note: Forces loading of SQL Server driver
				try { // Load driver class
					Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
				} catch (java.lang.ClassNotFoundException e) {
					out.println("ClassNotFoundException: " + e);
				}

				// Make connection
				String url = "jdbc:sqlserver://sql04.ok.ubc.ca:1433;DatabaseName=db_jgresl;";
				String uid = "jgresl";
				String pw = "29164977";

				// Useful code for formatting currency values:
				NumberFormat currFormat = NumberFormat.getCurrencyInstance();

				try (Connection con = DriverManager.getConnection(url, uid, pw)) {

					// Write query to retrieve user information
					String sql = "SELECT user_ID, userEmail, userPassword, isAdmin, firstName, lastName, phoneNumber, address, country, stateProvince, zipPostal, city, streetName, streetNumber, aptNumber FROM UserAccount WHERE user_ID = ?;";
					PreparedStatement pstmt = con.prepareStatement(sql);
					pstmt.setInt(1, 1);
					ResultSet rst = pstmt.executeQuery();
								
					// Populate credit card profile
					if(rst.next()) {
					out.print("<table>");
					
					
					out.print("</table>");
					}
				}
			%>
		</div>
	</div>
</body>
</html>
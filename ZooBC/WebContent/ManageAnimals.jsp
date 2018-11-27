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
	<h1>Manage Animals</h1>
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
					String sql = "SELECT animal_ID, animalName, animalClass, animalType, animalSize, animalDiet, animalOrigin, animalPrice, description, animalImage FROM Animal WHERE animal_ID = ?;";
					PreparedStatement pstmt = con.prepareStatement(sql);
					pstmt.setInt(1, 1);
					ResultSet rst = pstmt.executeQuery();
								
					// Populate animal information
					if(rst.next()) {
					out.print("<table>");
					out.print("<tr><td col width=\"175\" align=\"right\">Name:</td><td><input type=\"text\" name=\"animalname\" size=\"30\" value=\"" + rst.getString("animalName") + "\"></td></tr>");
					out.print("<tr><td col width=\"175\" align=\"right\">Classification:</td><td><input type=\"text\" name=\"animalclass\" size=\"30\" value=\"" + rst.getString("animalClass") + "\"></td></tr>");
					out.print("<tr><td col width=\"175\" align=\"right\">Type:</td><td><input type=\"text\" name=\"animaltype\" size=\"30\" value=\"" + rst.getString("animalType") + "\"></td></tr>");
					out.print("<tr><td col width=\"175\" align=\"right\">Size:</td><td><input type=\"text\" name=\"animalsize\" size=\"30\" value=\"" + rst.getString("animalSize") + "\"></td></tr>");
					out.print("<tr><td col width=\"175\" align=\"right\">Diet:</td><td><input type=\"text\" name=\"animaldiet\" size=\"30\" value=\"" + rst.getString("animalDiet") + "\"></td></tr>");
					out.print("<tr><td col width=\"175\" align=\"right\">Origin:</td><td><input type=\"text\" name=\"animalorigin\" size=\"30\" value=\"" + rst.getString("animalOrigin") + "\"></td></tr>");
				    out.print("<tr><td col width=\"175\" align=\"right\" valign=\"top\">Description:</td><td><textarea form =\"textareadescription\" name=\"animaldesc\" cols=\"45\" rows=\"5\" wrap=\"hard\"> value=\"" + rst.getString("description") + "</textarea></td><td valign=\"bottom\"><form method=\"get\" id=\"textareadescription\"><input type=\"submit\" value =\"Save Animal\"/></form></td></tr>");
					out.print("</table>");
					

					}
				}
			%>
		</div>
	</div>
</body>
</html>
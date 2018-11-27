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
	<h1>Account Profile</h1>
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
					
					//Determine user type
					String usertype;
					if (true)
						usertype = "Administrator";
					else
						usertype = "Customer";
					
					// Populate user profile
					if(rst.next()) {
					out.print("<table>");
					out.print("<tr><td col width=\"175\" align=\"right\">Email:</td><td><font color=\"teal\">" + rst.getString("userEmail") + "</td></tr>");
					out.print("<tr><td align=\"right\">User type:</td><td><font color=\"teal\">" + usertype + "</td></tr>");
					out.print("</table><br><br>");
					
					out.print("<table>");
					out.print("<tr><td col width=\"175\" align=\"right\">Old password:</td><td><input type=\"password\" name=\"oldpass\" size=\"15\" value=\"" + "" + "\"></td></tr>");
					out.print("<tr><td align=\"right\">New Password:</td><td><input type=\"password\" name=\"newpass\" size=\"15\" value=\"" + "" + "\"></td></tr>");
					out.print("<tr><td align=\"right\">Confirm New Password:</td><td><input type=\"password\" name=\"confirmnewpass\" size=\"15\" value=\"" + "" + "\"></td><td><input type=\"submit\" name=\"updatepass\" value=\"Update Password\"></td></tr>");
					out.print("</table><br><br>");
					
					out.print("<table>");
					out.print("<tr><td col width=\"175\" align=\"right\">First name:</td><td><input type=\"text\" name=\"firstname\" size=\"15\" value=\"" + rst.getString("firstName") + "\"></td></tr>");
					out.print("<tr><td align=\"right\">Last name:</td><td><input type=\"text\" name=\"lastname\" size=\"15\" value=\"" + rst.getString("lastName") + "\"></td></tr>");
					out.print("<tr><td align=\"right\">Phone number:</td><td><input type=\"text\" name=\"phone\" size=\"15\" value=\"" + rst.getString("phoneNumber") + "\"></td><td><input type=\"submit\" name=\"updatecontact\" value=\"Update Contact\"></td></tr>");
					out.print("</table><br><br>");
					
					out.print("<table>");
					out.print("<tr><td col width=\"175\" align=\"right\">Apt number:</td><td><input type=\"text\" name=\"apt\" size=\"15\" value=\"" + rst.getString("aptNumber") + "\"></td></tr>");
					out.print("<tr><td align=\"right\">Building number:</td><td><input type=\"text\" name=\"buildingnumber:\" size=\"15\" value=\"" + rst.getString("streetNumber") + "\"></td></tr>");
					out.print("<tr><td align=\"right\">Street name:</td><td><input type=\"text\" name=\"streetname\" size=\"15\" value=\"" + rst.getString("streetName") + "\"></td></tr>");
					out.print("<tr><td align=\"right\">City</td><td><input type=\"text\" name=\"buildingnumber:\" size=\"15\" value=\"" + rst.getString("city") + "\"></td></tr>");
					out.print("<tr><td align=\"right\">Zip/Postal:</td><td><input type=\"text\" name=\"buildingnumber:\" size=\"15\" value=\"" + rst.getString("zipPostal") + "\"></td></tr>");
					out.print("<tr><td align=\"right\">State/Province:</td><td><input type=\"text\" name=\"buildingnumber:\" size=\"15\" value=\"" + rst.getString("stateProvince") + "\"></td></tr>");
					out.print("<tr><td align=\"right\">Country:</td><td><input type=\"text\" name=\"buildingnumber:\" size=\"15\" value=\"" + rst.getString("country") + "\"></td><td><input type=\"submit\" name=\"updateaddress\" value=\"Update Address\"></td></tr>");
					out.print("</table>");
					}
				}
			%>
		</div>
	</div>
</body>
</html>
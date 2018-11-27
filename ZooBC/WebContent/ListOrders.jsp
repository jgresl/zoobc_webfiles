<%@ page import="java.sql.*"%>
<%@ page import="java.text.NumberFormat"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<link rel="stylesheet" type="text/css" href="styles/default.css">
<head>
<%@ include file="includes/header.html" %>
</head>
<body>

	<h1>Order List</h1>

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
		// out.println(currFormat.format(5.0));  // Prints $5.00

		try (Connection con = DriverManager.getConnection(url, uid, pw)) {

			// Write query to retrieve all order headers
			String sql = "SELECT orderId, Orders.customerId, Customer.cName, totalAmount FROM Orders JOIN Customer on Customer.customerId = Orders.customerId";
			PreparedStatement pstmt = con.prepareStatement(sql);
			ResultSet rst = pstmt.executeQuery();

			while (rst.next()) {
				// For each order in the ResultSet print out the order header information
				out.println(
						"<table border = 1><tr><th col width=\"100\" align=\"left\"><font color=\"b60009\">Order Id</th><th col width=\"100\" align=\"left\"><font color=\"b60009\">Customer Id</th><th col width=\"200\" align=\"left\"><font color=\"b60009\">Customer Name</th><th col width=\"100\" align=\"right\"><font color=\"b60009\">Total Amount</th>");

				out.print("<tr>");

				out.print("<td>");
				out.print(rst.getInt("orderId"));
				out.print("</td>");

				out.print("<td>");
				out.print(rst.getInt("customerId"));
				out.print("</td>");

				out.print("<td>");
				out.print(rst.getString("cName"));
				out.print("</td>");

				out.print("<td>");
				out.print(currFormat.format(rst.getDouble("totalAmount")));
				out.print("</td>");

				out.print("</tr></table>");

				// Write a query to retrieve the products in the order
				//   - Use a PreparedStatement as will repeat this query many times
				String sql2 = "SELECT productId, quantity, price FROM OrderedProduct WHERE orderId = ?";
				PreparedStatement pstmt2 = con.prepareStatement(sql2);
				pstmt2.setInt(1, rst.getInt("orderId"));
				ResultSet rst2 = pstmt2.executeQuery();

				// For each product in the order write out product information
				out.println(
						"<tr align=\"right\"><table><th col width=\"210\" align=\"left\"></th><th col width=\"100\" align=\"left\"><font color=\"darkorange\"><i><u>Product Id</th><th col width=\"100\" align=\"left\"><font color=\"darkorange\"><i><u>Quantity</th><th col width=\"100\" align=\"left\"><font color=\"darkorange\"><i><u>Price</th></td></tr>");
				
				while (rst2.next()) {
					out.print("<tr>");
					

					out.print("<td>");
					out.print("</td>");
					
					out.print("<td><font color=\"grey\"><i>");
					out.print(rst2.getInt("productId"));
					out.print("</td>");

					out.print("<td><font color=\"grey\"><i>");
					out.print(rst2.getInt("quantity"));
					out.print("</td>");

					out.print("<td><font color=\"grey\"><i>");
					out.print(currFormat.format(rst2.getDouble("price")));
					out.print("</td>");

					out.print("</tr>");
				}
				out.print("</tr><tr></table><br><br>");
			}
		} catch (SQLException ex) {
			System.out.println(ex);
		}
	%>
</body>
</html>
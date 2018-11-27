<%@ page import="java.sql.*,java.net.URLEncoder"%>
<%@ page import="java.text.NumberFormat"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<link rel="stylesheet" type="text/css" href="styles/default.css">
<head>
<%@ include file="includes/header.html" %>
</head>
<body>
	<h2>Search for animals by name. Filter animals by classification, type, size, and price:</h2>

	<form method="get" action="listprod.jsp">
		<p align="left">
			<input type="text" name="name"size="35"></input>
			&nbsp&nbsp&nbsp&nbsp&nbsp 
			<select size="1" name="classification">
				<option>All Classifications</option>
				<option>Amphibians</option>
				<option>Birds</option>
				<option>Fish</option>
				<option>Mammals</option>
				<option>Reptiles</option>
			</select>
			&nbsp&nbsp&nbsp&nbsp&nbsp 
			<select size="1" name="type">
				<option>All Types</option>
				<option>Frogs</option>
				<option>Bears</option>
				<option>AJAX?</option>
				<option>SELECT SQL?</option>
			</select>
			&nbsp&nbsp&nbsp&nbsp&nbsp 
			<select size="1" name="size">
				<option>All Sizes</option>
				<option>Tiny</option>
				<option>Small</option>
				<option>Medium</option>
				<option>Large</option>
				<option>Giant</option>
			</select>
			&nbsp&nbsp&nbsp&nbsp&nbsp 
			<select size="1" name="price">
				<option>All Prices</option>
				<option>Less than $5000</option>
				<option>Less than $1000</option>
				<option>Less than $500</option>
				<option>Less than $100</option>
			</select>
			&nbsp&nbsp&nbsp&nbsp&nbsp 
			<input type="submit" value="Submit"></input>
			&nbsp
			<input type="reset" value="Reset"></input>
		</p>
	</form>

	<%		// Get classification to search for
			String classification = request.getParameter("classification");
			if (classification == null || classification.equals("All Classifications"))
			classification = "%";
			
			// Get classification to search for
			String type = request.getParameter("type");
			if (type == null || type.equals("All Types"))
			type = "%";
						
			// Get size to search for
			String size = request.getParameter("size");
			if (size == null || size.equals("All Sizes"))
			size = "%";
					
			// Get price to search for
			String price = request.getParameter("price");
			if (price == null || price.equals("All Prices"))
				price = "100000";
			else if(price.equals("Less than $5000"))
				price = "5000";
			else if(price.equals("Less than $1000"))
				price = "1000";
			else if(price.equals("Less than $500"))
				price = "500";
			else if(price.equals("Less than $100"))
				price = "100";
			
		// Get product name to search for
		String name = request.getParameter("name");
		if (name == null)
			name = "%";

		//Note: Forces loading of SQL Server driver
		try { // Load driver class
			Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
		} catch (java.lang.ClassNotFoundException e) {
			out.println("ClassNotFoundException: " + e);
		}

		// Make the connection
		String url = "jdbc:sqlserver://sql04.ok.ubc.ca:1433;DatabaseName=db_jgresl;";
		String uid = "jgresl";
		String pw = "29164977";

		// Useful code for formatting currency values:
		NumberFormat currFormat = NumberFormat.getCurrencyInstance();

		try (Connection con = DriverManager.getConnection(url, uid, pw)) {

			// Write query to retrieve all order headers
			String sql = "SELECT animal_ID, animalName, animalClass, animalType, animalSize, animalPrice FROM Animal WHERE animalClass LIKE ? AND animalType LIKE ? AND animalSize LIKE ? AND animalPrice < ? AND animalName LIKE ?";
			PreparedStatement pstmt = con.prepareStatement(sql);
			pstmt.setString(1, classification);
			pstmt.setString(2, type);
			pstmt.setString(3, size);
			pstmt.setString(4, price);
			pstmt.setString(5, "%" + name + "%");
			ResultSet rst = pstmt.executeQuery();

			// Determine what header title to print
			String resultString;
			if (classification == "%" && size == "%" && price == "100000" && name == "%")
				resultString = "All Animals";
			else {
				String parameterName = request.getParameter("name") == "" ? "All Names" : request.getParameter("name");
				resultString = "Animals with [<font color=\"teal\">Name: </font>" + parameterName + "<font color=\"teal\">&nbsp&nbsp&nbsp&nbspClassification: </font>" + request.getParameter("classification") + "<font color=\"teal\">&nbsp&nbsp&nbsp&nbspType: </font>" + request.getParameter("type") + "<font color=\"teal\">&nbsp&nbsp&nbsp&nbspSize: </font>" + request.getParameter("size") + "<font color=\"teal\">&nbsp&nbsp&nbsp&nbspPrice: </font>" + request.getParameter("price") + "]";
			}
			out.println(resultString + "<br><br>");

			// Print out the ResultSet
			out.println("<br><table><tr>"
					+ "<th col width=\"125\"></th>"
					+ "<th col width=\"175\" align=\"left\">	<font color=\"teal\">Name  			&nbsp&nbsp <img src=\"images/arrows.png\"></th>"
					+ "<th col width=\"175\" align=\"left\">	<font color=\"teal\">Classification &nbsp&nbsp <img src=\"images/arrows.png\"></th>"
					+ "<th col width=\"150\" align=\"left\">	<font color=\"teal\">Type  			&nbsp&nbsp <img src=\"images/arrows.png\"></th>"
					+ "<th col width=\"125\" align=\"left\">	<font color=\"teal\">Size  			&nbsp&nbsp <img src=\"images/arrows.png\"></th>"
					+ "<th col width=\"100\" align=\"left\">	<font color=\"teal\">Price  		&nbsp&nbsp <img src=\"images/arrows.png\"></th>"
					+ "</tr>");

			while (rst.next()) {
				out.print("<tr>");

				// For each animal create a link of the form addcart.jsp
				out.print("<td><a href = \"AddCart.jsp?" + 
					"id=" + rst.getInt("animal_ID") + 
					"&class=" + rst.getString("animalClass") +
					"&type=" + rst.getString("animalType") +
					"&size=" + rst.getString("animalSize") + 
					"&price=" + rst.getDouble("animalPrice") +
					"&name=" + rst.getString("animalName") + 
					"\">Add to Cart</a></td>");

				// Print search results
				out.print("<td>" + rst.getString("animalName") + "</td>");
				out.print("<td>" + rst.getString("animalClass") + "</td>");
				out.print("<td>" + rst.getString("animalType") + "</td>");
				out.print("<td>" + rst.getString("animalSize") + "</td>");
				out.print("<td align=\"left\">" + currFormat.format(rst.getDouble("animalPrice")) + "</td>");
				out.println("</tr>");
			}
			out.println("</table>");

			// Close connection through try-with-resources

		} catch (SQLException ex) {
			System.out.println(ex);
		}
	%>

</body>
</html>
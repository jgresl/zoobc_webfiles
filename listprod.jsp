<%@ page import="java.sql.*,java.net.URLEncoder"%>
<%@ page import="java.text.NumberFormat"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<style>
* {
	font-family: Calibri;
	font-weight: bold
}
</style>
<head>
<link rel="icon" href="favicon.ico" type="image/x-icon"/>
<link rel="shortcut icon" href="favicon.ico" type="image/x-icon"/>
<title>ZooBC</title>
<img src="zoobc.png">
</head>
<hr>
<body>


	<h2>Browse Products By Category and Search by Product Name:</h2>

	<form method="get" action="listprod.jsp">
		<p align="left">
			<select size="1" name="categoryName">
				<option>All</option>
				<option>Beverages</option>
				<option>Condiments</option>
				<option>Confections</option>
				<option>Dairy Products</option>
				<option>Grains/Cereals</option>
				<option>Meat/Poultry</option>
				<option>Produce</option>
				<option>Seafood</option>

				<input type="text" name="productName" size="30">
			</select><input type="submit" value="Submit"><input type="reset"
				value="Reset">
		</p>
	</form>

	<%
		// Get product name to search for
		String name = request.getParameter("productName");
		if (name == null)
			name = '%' + "";

		// Get category name to search for
		String category = request.getParameter("categoryName");
		if (category == null || category.equals("All"))
			category = '%' + "";

		//Note: Forces loading of SQL Server driver
		try { // Load driver class
			Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
		} catch (java.lang.ClassNotFoundException e) {
			out.println("ClassNotFoundException: " + e);
		}

		// Variable name now contains the search string the user entered
		// Use it to build a query and print out the resultset.  Make sure to use PreparedStatement!

		// Make the connection
		String url = "jdbc:sqlserver://sql04.ok.ubc.ca:1433;DatabaseName=db_jgresl;";
		String uid = "jgresl";
		String pw = "29164977";

		// Useful code for formatting currency values:
		NumberFormat currFormat = NumberFormat.getCurrencyInstance();

		try (Connection con = DriverManager.getConnection(url, uid, pw)) {

			// Write query to retrieve all order headers
			String sql = "SELECT productId, productName, categoryName, price FROM Product WHERE productName LIKE ? AND categoryName LIKE ?";
			PreparedStatement pstmt = con.prepareStatement(sql);
			pstmt.setString(1, "%" + name + "%");
			pstmt.setString(2, category);
			ResultSet rst = pstmt.executeQuery();

			// Determine what header title to print
			String resultString;
			if (category == '%' + "" && (name == "%" || name == ""))
				resultString = "All Products";
			else if (category.length() > 3 && name == "")
				resultString = "Products in category '" + category + "'";
			else if (category.length() > 3 && name != "")
				resultString = "Products in category '" + category + "' containing '" + name + "'";
			else
				resultString = "All Products containing '" + name + "'";

			// Print out the ResultSet
			out.println("<h1>" + resultString + "</h1>");
			out.println(
					"<table ><tr><th col width=\"150\"></th><th col width=\"300\" align=\"left\"><font color=\"b60009\">Product Name&nbsp&nbsp&nbsp&nbsp&nbsp<img src=\"arrows.png\"></th><th col width=\"200\" align=\"left\"><font color=\"b60009\">Category&nbsp&nbsp&nbsp&nbsp&nbsp<img src=\"arrows.png\"></th><th align=\"left\"><font color=\"b60009\">Price&nbsp&nbsp&nbsp&nbsp&nbsp<img src=\"arrows.png\"></th></tr>");

			while (rst.next()) {
				out.print("<tr><i>");

				// For each product create a link of the form addcart.jsp?id=<productId>&name=<productName>&price=<productPrice>
				// Note: As some product names contain special characters, need to encode URL parameter for product name like this: URLEncoder.encode(productName, "Windows-1252")
				out.print("<td>");
				out.print("<a href = \"addcart.jsp?id=" + rst.getInt("productId") + "&name="
						+ URLEncoder.encode(rst.getString("productName"), "Windows-1252") + "&price="
						+ rst.getDouble("price") + "\">Add to Cart</a>");
				out.print("</td>");

				out.print("<td>");
				out.print(rst.getString("productName"));
				out.print("</td>");

				out.print("<td>");
				out.print(rst.getString("categoryName"));
				out.print("</td>");

				out.print("<td align=\"left\">");
				out.print(currFormat.format(rst.getDouble("price")));
				out.print("</td>");

				out.println("</i></tr>");
			}

			// Close connection through try-with-resources

		} catch (SQLException ex) {
			System.out.println(ex);
		}
	%>

</body>
</html>
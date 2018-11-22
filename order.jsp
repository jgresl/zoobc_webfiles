<%@ page import="java.sql.*"%>
<%@ page import="java.text.NumberFormat"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Map"%>
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
<title>ZooBC</title>
<img src="zoobc.png">
</head>
<hr>
<body>

	<%
		// Get customer id
		String custId = request.getParameter("customerId");
		// Get customer password
		String passwd = request.getParameter("password");
		@SuppressWarnings({ "unchecked" })
		HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

		// Useful code for formatting currency values:
		NumberFormat currFormat = NumberFormat.getCurrencyInstance();

		// Make connection
		String url = "jdbc:sqlserver://sql04.ok.ubc.ca:1433;DatabaseName=db_jgresl;";
		String uid = "jgresl";
		String pw = "29164977";

		try (Connection con = DriverManager.getConnection(url, uid, pw)) {

			// Determine if valid customer id was entered
			String sql6 = "SELECT COUNT(customerId) as countId FROM Customer WHERE customerId = ?";
			PreparedStatement pstmt6 = con.prepareStatement(sql6);
			pstmt6.setInt(1, Integer.parseInt(custId));
			ResultSet rst6 = pstmt6.executeQuery();
			rst6.next();
			
			// Determine if valid password was entered
 			String sql7 = "SELECT password FROM Customer WHERE customerId = ?";
			PreparedStatement pstmt7 = con.prepareStatement(sql7);
			pstmt7.setInt(1, Integer.parseInt(custId));
			ResultSet rst7 = pstmt7.executeQuery();
			rst7.next();

			// Determine if there are products in the shopping cart
			// If either are not true, display an error message
			if (rst6.getInt("countId") == 0) {
				out.println("<h1>Invalid customer id. Go back to the previous page and try again</h1>");
			// +5 marks - for validating a customer's password when they try to place an order.
 			} else if (!passwd.equals(rst7.getString("password"))) {	
				out.println("<h1>Invalid password. Go back to the previous page and try again</h1>");
			} else  {
				// Save order information to database
				String sql = "INSERT INTO Orders (customerId) VALUES (?)";
				PreparedStatement pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
				pstmt.setInt(1, Integer.parseInt(custId));
				pstmt.executeUpdate();
				ResultSet keys = pstmt.getGeneratedKeys();
				keys.next();
				int orderId = keys.getInt(1);

				Double totalAmount = 0.0;
				// Each entry in the HashMap is an ArrayList with item 0-id, 1-name, 2-quantity, 3-price
				Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
				while (iterator.hasNext()) {
					Map.Entry<String, ArrayList<Object>> entry = iterator.next();
					ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
					String productId = (String) product.get(0);
					String price = (String) product.get(2);
					double pr = Double.parseDouble(price);
					int qty = ((Integer) product.get(3)).intValue();

					// Insert each item into OrderedProduct table using OrderId from previous INSERT
					String sql2 = "INSERT INTO OrderedProduct VALUES (?,?,?,?)";
					PreparedStatement pstmt2 = con.prepareStatement(sql2);
					pstmt2.setInt(1, orderId);
					pstmt2.setInt(2, Integer.parseInt(productId));
					pstmt2.setInt(3, qty);
					pstmt2.setDouble(4, pr);
					pstmt2.executeUpdate();
					totalAmount += qty * pr;
				}

				// Update total amount for order record
				String sql3 = "UPDATE Orders SET totalAmount = ? WHERE orderId = ?";
				PreparedStatement pstmt3 = con.prepareStatement(sql3);
				pstmt3.setDouble(1, totalAmount);
				pstmt3.setInt(2, orderId);
				pstmt3.executeUpdate();

				// Determine customer name
				String sql4 = "SELECT cname FROM Customer WHERE customerId = ?";
				PreparedStatement pstmt4 = con.prepareStatement(sql4);
				pstmt4.setInt(1, Integer.parseInt(custId));
				ResultSet rst4 = pstmt4.executeQuery();
				rst4.next();

				// Retrieve order summary
				String sql5 = "SELECT OrderedProduct.productId, productName, quantity, OrderedProduct.price, quantity * OrderedProduct.price AS subtotal FROM OrderedProduct JOIN Product on Product.productID = OrderedProduct.productId WHERE orderId = ?";
				PreparedStatement pstmt5 = con.prepareStatement(sql5);
				pstmt5.setInt(1, orderId);
				ResultSet rst5 = pstmt5.executeQuery();

				// Print out order summary
				out.println("<h1>Your Order Summary</h1>");

				// Product Details (Table)
				out.print("<table><tr><th col width=\"100\" align=\"left\"><font color=\"b60009\">Product Id</th><th col width=\"300\" align=\"left\"><font color=\"b60009\">Product Name</th><th col width=\"75\" align=\"left\"><font color=\"b60009\">Quantity</th>");
				out.println("<th col width=\"100\" align=\"right\"><font color=\"b60009\">Price</th><th col width=\"100\" align=\"right\"><font color=\"b60009\">Subtotal</th></tr>");
				while (rst5.next()) {
					out.println("<tr><td>" + rst5.getInt("productId") + "</td><td>" + rst5.getString("productName")
							+ "</td><td>" + rst5.getInt("quantity") + "</td><td align=\"right\">"
							+ currFormat.format(rst5.getDouble("price")) + "</td><td align=\"right\">"
							+ currFormat.format(rst5.getDouble("subtotal")) + "</td></tr>");
				}
				out.println("<tr><td colspan=\"4\" align=\"right\"><b><font color=\"b60009\">Order Total</b></td>"
						+"<td align=\"right\"><font color=\"b60009\">"+currFormat.format(totalAmount)+"</td></tr>");
				out.println("</table>");

				// Order Details
				out.println("<br>Your order has been processed and your groceries will be shipped to you immediately...");
				out.println("<br><br>Thank you <font color=\"darkorange\">" + rst4.getString("cname") + "</font>");
				out.println("<br>Order Reference:   <font color=\"darkorange\">" + orderId + "</font>");
				out.println("<br>Customer Id:   <font color=\"darkorange\">" + custId + "</font>");
				
				// Clear cart
				productList.clear();
			}
		} catch (SQLException ex) {
			System.out.println(ex);
		}
	%>
</BODY>
</HTML>
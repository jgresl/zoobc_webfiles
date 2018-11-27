<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.text.NumberFormat"%>
<%@ page import="java.util.Map"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<link rel="stylesheet" type="text/css" href="styles/default.css">
<head>
<%@ include file="includes/header.html" %>
</head>
<body>
	<%
		// Get the current list of products
		@SuppressWarnings({ "unchecked" })
		HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session
				.getAttribute("productList");

		if (productList == null) {
			out.println("<H1>Your shopping cart is empty!</H1>");
			productList = new HashMap<String, ArrayList<Object>>();
		} else {
			NumberFormat currFormat = NumberFormat.getCurrencyInstance();

			out.println("<script>");
			out.println("function update(newid, newqty)");
			out.println("{");
			out.println("window.location=\"ShowCart.jsp?update=\"+newid+\"&newqty=\"+newqty");
			out.println("}");
			out.println("</script>");
			out.println("<form name=\"form1\">");

			// Get new parameters for update
			try {
				String id = request.getParameter("update");
				String qty = request.getParameter("newqty");
				ArrayList<Object> product = (ArrayList<Object>) productList.get(id);
				product.set(3, new Integer(qty));
			} catch (Exception ex) {
			}

			try {
				String id = request.getParameter("delete");
				productList.remove(id);
			} catch (Exception ex) {
			}

			out.println("<h1>Your Shopping Cart</h1>");
			out.print(
					"<table><tr><th col width=\"100\" align=\"left\"><font color=\"teal\">Product Id</th>" +
					"<th col width=\"200\" align=\"left\"><font color=\"teal\">Product Name</th>" +
					"<th col width=\"125\" align=\"left\"><font color=\"teal\">Quantity</th>" +
					"<th col width=\"100\" align=\"right\"><font color=\"teal\">Price</th>" +
					"<th col width=\"100\" align=\"right\"><font color=\"teal\">Subtotal</th></tr>");

			double total = 0;
			int row = 1;
			Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
			while (iterator.hasNext()) {
				Map.Entry<String, ArrayList<Object>> entry = iterator.next();
				ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
				if (product.size() < 4) {
					out.println("Expected product with four entries. Got: " + product);
					continue;
				}

				out.print("<tr><td>" + product.get(0) + "</td>");
				out.print("<td>" + product.get(1) + "</td>");
				out.print("<td><input type=\"text\" name=\"newqty" + row + "\" size=\"3\" value=\"" + product.get(3) + "\">&nbsp;<input type=button OnClick=\"update(" + product.get(0) + ", document.form1.newqty" + row + ".value)\" value=\"Update\"></td>");

				Object price = product.get(2);
				Object itemqty = product.get(3);
				double pr = 0;
				int qty = 0;

				try {
					pr = Double.parseDouble(price.toString());
				} catch (Exception e) {
					out.println("Invalid price for product: " + product.get(0) + " price: " + price);
				}
				try {
					qty = Integer.parseInt(itemqty.toString());
				} catch (Exception e) {
					out.println("Invalid quantity for product: " + product.get(0) + " quantity: " + qty);
				}

				out.print("<td align=\"right\">" + currFormat.format(pr) + "</td>");
				out.print("<td align=\"right\">" + currFormat.format(pr * qty) + "</td><td>&nbsp;&nbsp;&nbsp;&nbsp;<a href=\"ShowCart.jsp?delete=" + product.get(0) + "\">Remove Item from Cart</a></td></tr>");
						

				total = total + pr * qty;
				row += 1;
			}
			out.println("<tr><td colspan=\"4\" align=\"right\"><b><font color=\"teal\">Order Total</b></td><td align=\"right\"><font color=\"teal\">" + currFormat.format(total) + "</td></tr>");
			out.println("</table>");

			out.println("<h2><a href=\"Checkout.jsp\">Check Out</a></h2>");
		}
	%>
	<h2>
		<a href="ShopAnimals.jsp">Continue Shopping</a>
	</h2>
	</form>
</body>
</html>


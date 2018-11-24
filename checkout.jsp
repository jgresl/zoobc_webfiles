<html>
<style>
* {
	font-family: Calibri;
	font-weight: bold
}

a:link, a:active, a:visited {
	color: navy;
	text-decoration: none;
}

a:hover {
	color: teal;
	text-decoration: none;
	white-space:nowrap;
}
</style>
<head>
<link rel="icon" href="favicon.ico" type="image/x-icon" />
<link rel="shortcut icon" href="favicon.ico" type="image/x-icon" />
<title>ZooBC - Home</title>

<table width="100%">
	<tr>
		<th align="left"><a href=zoobc.html><img src="zoobc.png"></th>
		<th col width="200" align="right"><a href=zoobc.html><h2>HOME</h2></a></th>
		<th col width="200" align="right"><a href=listprod.jsp><h2>ANIMALS</h2></a></th>
		<th col width="200" align="right"><a href=zoobc.html><h2>REGISTER</h2></a></th>
		<th col width="200" align="right"><a href=checkout.jsp><h2>SIGN IN</h2></a></th>
		<th col width="300" align="right"><a href=showcart.jsp><h2>SHOPPING CART</h2></a></th>
	</tr>
</table>
</head>
<hr size=10 color="navy">
<body>

<h1>Enter your customer id and password to complete the transaction:</h1>

<form method="get" action="order.jsp">
<table>
<tr><td>Customer ID:</td><td><input type="text" name="customerId" size="20"></td></tr>
<tr><td>Password:</td><td><input type="password" name="password" size="20"></td></tr>
<tr><td><input type="submit" value="Submit"></td><td><input type="reset" value="Reset"></td></tr>
</table>
</form>

</body>
</html>
<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<!DOCTYPE html>
<html>
<head>
<title>YOUR NAME Grocery</title>
</head>
<body>

<h1>Search for the products you want to buy:</h1>

<form method="get" action="listprod.jsp">
<input type="text" name="productName" size="50">
<input type="submit" value="Submit"><input type="reset" value="Reset"> (Leave blank for all products)
</form>


<% // Get product name to search for
String name = request.getParameter("productName");
		
//Note: Forces loading of SQL Server driver
try
{	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}
catch (java.lang.ClassNotFoundException e)
{
	out.println("ClassNotFoundException: " +e);
}

// Variable name now contains the search string the user entered
// Use it to build a query and print out the resultset.  Make sure to use PreparedStatement!


getConnectionForOrders();
if (name == null) name = "";


// out.println(currFormat.format(5.0);	// Prints $5.00

try {
	String sql = "SELECT productId, productName, productPrice, productImageURL FROM product " +
		"WHERE productName LIKE ?";
	PreparedStatement p = con.prepareStatement(sql)	;
	p.setString(1, "%" + name + "%");
	ResultSet r = p.executeQuery();
	//href = addcart.jsp?id=productId&name=productName&price=productPrice
	if (name != "")
		{out.println("<h2>Product's containing '" + name + "' </h2>");}
	out.println("<table><tr><th></th><th>Product Name</th><th>Price</th></tr>");

	NumberFormat currFormat = NumberFormat.getCurrencyInstance();

	while(r.next()){
		String productId = r.getString("productId");
		String productName = r.getString("productName");
		String productName1 = r.getString("productName").replace(' ','+');
		Double productPrice = r.getDouble("productPrice");
		String productImage = r.getString("productImageURL");
		out.println("<tr><td><a href = addcart.jsp?id=" + productId + "&name=" + productName1 + "&price=" + productPrice +"> Add to Cart </a></td>"
		+ "<td><a href = product.jsp?id=" + productId + "&name=" + productName1 + "&price=" + productPrice + "&image=" + productImage + ">" + productName + "</a>" + "</td><td>" + currFormat.format(productPrice) + "</td></tr>");

	}

	out.println("</table>");
	con.close();
} catch (Exception e) 
{
	out.println(e);	
}



// Print out the ResultSet

// For each product create a link of the form
// addcart.jsp?id=productId&name=productName&price=productPrice

// Close connection

// Useful code for formatting currency values:
// NumberFormat currFormat = NumberFormat.getCurrencyInstance();
// out.println(currFormat.format(5.0);	// Prints $5.00
%>

</body>
</html>
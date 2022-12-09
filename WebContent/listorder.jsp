<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>
<!DOCTYPE html>
<html>
<head>
<title>YOUR NAME Grocery Order List</title>
</head>
<body>

<h1>Order List</h1>

<%
//Note: Forces loading of SQL Server driver

try
{	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}
catch (java.lang.ClassNotFoundException e)
{
	out.println("ClassNotFoundException: " +e);
}

// Useful code for formatting currency values:
NumberFormat currFormat = NumberFormat.getCurrencyInstance();
// out.println(currFormat.format(5.0);  // Prints $5.00

// Make connection
try {
getConnectionForOrders(); //from jdbc.jsp (I added it)

// Write query to retrieve all order summary records
String SQL = "SELECT orderId, ordersummary.customerId, firstName, lastName, totalAmount FROM ordersummary JOIN customer ON ordersummary.customerId = customer.customerId";

PreparedStatement pstmt = con.prepareStatement(SQL);
ResultSet result = pstmt.executeQuery();


out.println("<table border=\"1\" style=\"background-color:black; color: cyan;\">");
out.println("<tr><th>Order Id</th><th>Customer Id</th><th>Customer Name</th><th>Total Amount</th></tr>");
// For each order in the ResultSet
while (result.next()) {
	// Print out the order summary information
	out.println("<style=\"background-color:black; color: cyan;\">");
	out.println("<tr><td>" + result.getString("orderId") + "</td><td>"+result.getString("customerId") + "</td><td>"+result.getString("firstName")+ " " + result.getString("lastName") + "</td><td>"+currFormat.format(result.getDouble("totalAmount")) + "</td></tr>");
	// Write a query to retrieve the products in the order
	//   - Use a PreparedStatement as will repeat this query many times
	String SQL2 = "SELECT orderproduct.productId, quantity, price " + 
	 "FROM orderproduct JOIN product ON orderproduct.productId = product.productId WHERE orderId = ?";
    PreparedStatement pstmt2 = con.prepareStatement(SQL2);
	pstmt2.setInt(1,result.getInt("orderId"));
    ResultSet productsResult = pstmt2.executeQuery();

	out.println("<tr align=\"right\"><td colspan=\"4\"><table border=\"1\" style=\"background-color:black; color: lime;\">");
	out.println("<tr><th>Product Id</th><th>Quantity</th><th>Price</th></tr>");
	// For each product in the order
	while (productsResult.next()) {
		// Write out product information 
		out.println("<tr><td>" + productsResult.getString("productId") + "</td><td>"+productsResult.getString("quantity") + "</td><td>"+currFormat.format(productsResult.getDouble("price")) + "</td></tr>");
	
	}
	out.println("</table");
}  
out.println("</table");
	
	


/*
<table border="1" style="background-color:green">
<caption>This is my table caption.</caption>
<tr><th>Tag</th><th>Purpose</th></tr>
<tr><td>table</td><td>Start and end entire table</td></tr>
<tr><td>tr</td><td>Start and end each row</td></tr>
<tr><td>th</td><td>Special column header formatting</td></tr>
<tr><td>td</td><td>Start and end each data cell</td></tr>
<tr><td colspan="2">COLSPAN has cell span multiple columns</td></tr>
<tr><td rowspan="2">ROWSPAN</td><td>ROWSPAN spans rows</td></tr>
</table>
*/
// Close connection
closeConnection();
} catch (Exception e) {
    out.print(e);
}  
			
	

%>

</body>
</html>


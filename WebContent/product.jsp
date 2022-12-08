<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>Ray's Grocery - Product Information</title>
<link href="css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<%@ include file="header.jsp" %>

<%
// Get product name to search for
// TODO: Retrieve and display info for the product
// String productId = request.getParameter("id");
String id = request.getParameter("id");
String name = request.getParameter("name");
String price = request.getParameter("price");
String image = request.getParameter("image");

getConnectionForOrders();

try {
    String sql = "SELECT productName, productPrice, productImageURL FROM product WHERE productId = ?";
    PreparedStatement pstmt = con.prepareStatement(sql);
    pstmt.setString(1, id);
    ResultSet rst = pstmt.executeQuery();

    while(rst.next()) {
        out.println("<h2>" + rst.getString(1) + "</h2>");
        out.println("<img src=" + rst.getString(3) + ">");
        out.println("<img src=\"displayImage.jsp?id=\"" + id + "><br>");
        out.println("<tr><td><b>ID</b></td><td> " + id + "</td></tr><br>");
        out.println("<tr><td><b>Price</b></td><td> $" + rst.getString(2) + "</td></tr><br>");
        out.println("<h3><a href = addcart.jsp?id=" + id + "&name=" + rst.getString(1) + "&price=" + rst.getString(2) +"> Add to Cart </a></h3>");
        out.println("<h3><a href=listprod.jsp> Continue Shopping </a></h3>");
    }
} catch(Exception e) {
    out.println(e);
}

request.setAttribute("id", id);

// TODO: If there is a productImageURL, display using IMG tag
		
// TODO: Retrieve any image stored directly in database. Note: Call displayImage.jsp with product id as parameter.
		
// TODO: Add links to Add to Cart and Continue Shopping
%>
</body>
</html>

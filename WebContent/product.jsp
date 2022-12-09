<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>Super Cool Bookstore - Product Information</title>
<link href="css/bootstrap.min.css" rel="stylesheet">
<link href="css/div.css" rel="stylesheet">
</head>
<body>
<%@ include file="header.jsp" %>

<%

// Get product name to search for
// TODO: Retrieve and display info for the product
// String productId = request.getParameter("id");
String id = request.getParameter("id");
String name = request.getParameter("productName");
String price = request.getParameter("price");
String image = request.getParameter("image");

getConnectionForOrders();

try {
    String sql = "SELECT productName, productPrice, productImageURL, productDesc FROM product WHERE productId = ?";
    PreparedStatement pstmt = con.prepareStatement(sql);
    pstmt.setString(1, id);
    ResultSet rst = pstmt.executeQuery();

    while(rst.next()) {
        String productName1 = rst.getString("productName").replace(' ','+');
        out.println("<h2>" + rst.getString(1) + "</h2>");
        out.println("<img src=" + rst.getString(3) + ">");
        out.println("<img src=\"displayImage.jsp?id=\"" + id + "><br>");
        out.println("<tr><td><b>ID</b></td><td> " + id + "</td></tr><br>");
        out.println("<tr><td><b>Price</b></td><td> $" + rst.getString(2) + "</td></tr><br>");
        out.println("<tr><td><div><b>Description: </b>"+ rst.getString(4) + "</div></td></tr>");
        out.println("<h3><a href = addcart.jsp?id=" + id + "&name=" + productName1 + "&price=" + rst.getDouble(2) +"> Add to Cart </a></h3>");
        out.println("<h3><a href=listprod.jsp> Continue Shopping </a></h3>");
        out.println("<h3><a href=review.jsp?id=" + id +" > Leave a Review </a></h3>");
       
    }

    String reviews = "SELECT reviewRating, reviewDate, reviewComment FROM review";
    PreparedStatement p = con.prepareStatement(reviews);
    ResultSet r = p.executeQuery();

    out.println("<h3> Reviews</h3>");
    out.println("<table border=\"1\" style=\"background-color:black; color: cyan;\">");
    out.println("<tr><th>Rating</th><th>Date</th><th>Comment</th></tr>");

    while(r.next()){
        out.println("<style=\"background-color:black; color: cyan;\">");
        out.println("<tr><td>" + r.getInt("reviewRating") + "</td><td>"+ r.getDate("reviewDate") + "</td><td>" + r.getString("reviewComment") + "</td></tr>");
    }
    out.println("</table>");
} catch(Exception e) {
    out.println(e);
}


// TODO: If there is a productImageURL, display using IMG tag
		
// TODO: Retrieve any image stored directly in database. Note: Call displayImage.jsp with product id as parameter.
		
// TODO: Add links to Add to Cart and Continue Shopping
%>
</body>
</html>


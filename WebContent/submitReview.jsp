<%@ page language="java" import="java.io.*,java.sql.*"%>
<%@ include file="jdbc.jsp" %>

<%

try{
    getConnectionForOrders();
    session = request.getSession(true);

    int j = 0;
    int id = Integer.valueOf((String)request.getParameter("id"));   
    int rating = Integer.valueOf(request.getParameter("rating"));
    String userName = (String) session.getAttribute("authenticatedUser");
    String name = request.getParameter("name");
    String price = request.getParameter("price");
    String image = request.getParameter("image");

    String custid = "SELECT customerId FROM customer WHERE userid = ?";
    PreparedStatement pstmt = con.prepareStatement(custid);
    pstmt.setString(1, userName);
    ResultSet rs = pstmt.executeQuery();
    int customerId = 0;
    while(rs.next()){
        customerId = rs.getInt("customerId");
    
    }

    String sql = "SELECT COUNT(*) AS a FROM review WHERE customerId = ? AND productId = ?";
    PreparedStatement p = con.prepareStatement(sql);
    p.setInt(1, customerId);
    p.setInt(2, id);
    ResultSet r = p.executeQuery();

    while(r.next())
        j = r.getInt("a");

    if (j == 0) {

        String rComment = "N/A";
        if (request.getParameter("comment") == null){
            rComment = "N/A";
        } else {
            rComment = request.getParameter("comment");
        }


        String input = "INSERT INTO review (reviewRating, reviewDate, customerId, productId, reviewComment) VALUES (?, ?, ?, ?, ?)";
        PreparedStatement i = con.prepareStatement(input);
        i.setInt(1, rating);
        i.setDate(2, java.sql.Date.valueOf(java.time.LocalDate.now()));
        i.setInt(3, customerId);
        i.setInt(4, id);
        i.setString(5, rComment);
        i.execute();

        out.println("Review has been successfully submitted");
        out.println("<br><a href = index.jsp> Back to Home Page</a>");
    }  else {
        out.println("You have already left a review for this product");      
        out.println("<br><a href = product.jsp?id=" + id + "&name=" + name + "&price=" + price + "&image=" + image + "> Back to Product Page </a>");
}
}
catch (Exception e){
    out.println(e);
}


%>
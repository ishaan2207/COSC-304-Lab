<%@ page language="java" import="java.io.*,java.sql.*"%>
<%@ include file="jdbc.jsp" %>


<%

try{
getConnectionForOrders();
session = request.getSession(true);
boolean
int id = Integer.valueOf((String)request.getParameter("id"));   
int rating = Integer.valueOf(request.getParameter("rating"));
String userName = (String) session.getAttribute("authenticatedUser");

String rComment = "N/A";
if (request.getParameter("comment") == null){
    rComment = "N/A";
} else {
    rComment = request.getParameter("comment");
}

String custid = "SELECT customerId FROM customer WHERE userid = ?";
PreparedStatement pstmt = con.prepareStatement(custid);
pstmt.setString(1, userName);
ResultSet rs = pstmt.executeQuery();
int customerId = 0;
while(rs.next()){
    customerId = rs.getInt("customerId");
 
}

String input = "INSERT INTO review (reviewRating, reviewDate, customerId, productId, reviewComment) VALUES (?, ?, ?, ?, ?)";
PreparedStatement i = con.prepareStatement(input);
i.setInt(1, rating);
i.setDate(2, java.sql.Date.valueOf(java.time.LocalDate.now()));
i.setInt(3, customerId);
i.setInt(4, id);
i.setString(5, rComment);
i.execute();
}
catch (Exception e){
    out.println(e);
}

%>
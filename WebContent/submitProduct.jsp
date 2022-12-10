<%@ page language="java" import="java.io.*,java.sql.*"%>
<%@ include file="jdbc.jsp" %>

<%
try {

    getConnectionForOrders();
    session = request.getSession(true);


    String name = (String)request.getParameter("name");
    Double price = Double.valueOf((String)request.getParameter("price"));
    String desc = (String)request.getParameter("description");
    int catId = Integer.valueOf((String)request.getParameter("categoryId"));
    int authId = Integer.valueOf((String)request.getParameter("authorId"));

    String sql = "INSERT product(productName, categoryId, authorId, productDesc, productPrice) VALUES (?, ?, ?, ?, ?)";
    PreparedStatement p = con.prepareStatement(sql);
    p.setString(1, name);
    p.setInt(2, catId);
    p.setInt(3, authId);
    p.setString(4, desc);
    p.setDouble(5, price);

    p.execute();

    out.println("Product submitted successfully");
            out.println("<br><a href = admin.jsp> Back to Product Page </a>");


} catch (Exception e){
    out.println(e);
}

%>
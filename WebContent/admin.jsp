<!DOCTYPE html>
<html>
<head>
<title>Administrator Page</title>
</head>
<body>
<%@ include file="auth.jsp" %>
<%@ include file="jdbc.jsp" %>
<%
// TODO: Include files auth.jsp and jdbc.jsp



%>
<%
out.println("<h3>Administrator Sales Report By Day</h3>");

getConnectionForOrders();
try {
    out.println("<table border = \"1\">");

    // TODO: Write SQL query that prints out total order amount by day
    String sql = "SELECT CAST(orderDate AS DATE) as d, SUM(totalAmount) as T FROM ordersummary GROUP BY CAST(orderDate AS DATE) ORDER BY CAST(orderDate AS DATE) DESC";
    PreparedStatement p = con.prepareStatement(sql);
    ResultSet r = p.executeQuery();
    out.println("<tr><th> Order Date </th><th> Total Amount </th></tr>");
    while(r.next()){
      out.println(
         "<tr><td>" +  r.getString("d") + "</td><td>" + r.getDouble("T") + "</td></tr>"
        );
    }

    out.println("<h3><a href=addProduct.jsp > Add a New Product </a></h3>");


closeConnection();
} catch (Exception e) {
    out.println(e);
}
%>

</body>
</html>
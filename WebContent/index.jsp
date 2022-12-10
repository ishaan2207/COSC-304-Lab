<!DOCTYPE html>
<html>
<head>
        <title>Super Cool Bookstore Main Page</title>
</head>
<body>
<h1 align="center">Welcome to Super Cool Bookstore</h1>

<h2 align="center"><a href="listprod.jsp">Begin Shopping</a></h2>

<h2 align="center"><a href="listorder.jsp">List All Orders</a></h2>

<h2 align="center"><a href="customer.jsp">Customer Info</a></h2>

<h2 align="center"><a href="admin.jsp">Administrators</a></h2>


<%@ page import="java.lang.String"%>

<%


session = request.getSession(true);


// TODO: Display user name that is logged in (or nothing if not logged in)
String name = (String) session.getAttribute("authenticatedUser");
if(name != null){
        out.println("<h2 align=\"center\"><a href=\"logout.jsp\">Log out</a></h2>");
        out.println("<h3 align = \"center\"> Signed in as: " + name + "</h3>");
} else {
        out.println("<h2 align=\"center\"><a href=\"login.jsp\">Login</a></h2>");
}
%>
</body>
</head>
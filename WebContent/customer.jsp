<!DOCTYPE html>
<html>
<head>
<title>Customer Page</title>
</head>
<body>
<%@ include file="header.jsp" %>

<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>


<%
    out.println("<font face=\"Century Gothic\" size=\"2\">");
    
    if (session.getAttribute("customerEditMessage") != null) //after sucessful edit
	out.println("<p>"+session.getAttribute("customerEditMessage").toString()+"</p>");
    session.removeAttribute("customerEditMessage");

    String sql = "";
    // Print Customer information
    getConnectionForOrders();
	session = request.getSession(true);
	int mycustId = getCustIdFromAuthUser(session);
    String userName = (String) session.getAttribute("authenticatedUser");

	if (mycustId == 69420) { //probably change this so it does the below code if logged in as admin 
        try{
            sql = "SELECT customerId, firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid FROM customer";
            PreparedStatement p = con.prepareStatement(sql);
            ResultSet rst = p.executeQuery();
            out.println("<table border=\"1\">");
            while (rst.next()) {
                out.println("<table border=\"1\"><tr><th>" + "Id" + "</th><td>" + rst.getInt("customerId") + "</td></tr>");
                out.println("<tr><th>" + "First Name" + "</th><td>" + rst.getString("firstName") + "</td></tr>");
                out.println("<tr><th>" + "Last Name" + "</th><td>" + rst.getString("lastName") + "</td></tr>");
                out.println("<tr><th>" + "Email" + "</th><td>" + rst.getString("email") + "</td></tr>");
                out.println("<tr><th>" + "Phone" + "</th><td>" + rst.getString("phonenum") + "</td></tr>");
                out.println("<tr><th>" + "Address" + "</th><td>" + rst.getString("address") + "</td></tr>");
                out.println("<tr><th>" + "City" + "</th><td>" + rst.getString("city") + "</td></tr>");
                out.println("<tr><th>" + "State" + "</th><td>" + rst.getString("state") + "</td></tr>");
                out.println("<tr><th>" + "Postal Code" + "</th><td>" + rst.getString("postalCode") + "</td></tr>");
                out.println("<tr><th>" + "Country" + "</th><td>" + rst.getString("country") + "</td></tr>");
                out.println("<tr><th>" + "User id" + "</th><td>" + rst.getString("userid") + "</td></tr>");
                out.println("</table>");
            }
            out.println("</table>");
            }catch(Exception e){
                out.println(e);
        }
    } else {
        try{
            sql = "SELECT customerId, firstName, lastName, email, phonenum, address, city, state, postalCode, country FROM customer " +
            "WHERE userid = ?";
            PreparedStatement p = con.prepareStatement(sql);
            p.setString(1, userName);
            //con.commit();
            ResultSet rst = p.executeQuery();
            rst.next();
            out.println("<table border=\"1\"><tr><th>" + "Id" + "</th><td>" + rst.getInt("customerId") + "</td></tr>");
            out.println("<tr><th>" + "First Name" + "</th><td>" + rst.getString("firstName") + "</td></tr>");
            out.println("<tr><th>" + "Last Name" + "</th><td>" + rst.getString("lastName") + "</td></tr>");
            out.println("<tr><th>" + "Email" + "</th><td>" + rst.getString("email") + "</td></tr>");
            out.println("<tr><th>" + "Phone" + "</th><td>" + rst.getString("phonenum") + "</td></tr>");
            out.println("<tr><th>" + "Address" + "</th><td>" + rst.getString("address") + "</td></tr>");
            out.println("<tr><th>" + "City" + "</th><td>" + rst.getString("city") + "</td></tr>");
            out.println("<tr><th>" + "State" + "</th><td>" + rst.getString("state") + "</td></tr>");
            out.println("<tr><th>" + "Postal Code" + "</th><td>" + rst.getString("postalCode") + "</td></tr>");
            out.println("<tr><th>" + "Country" + "</th><td>" + rst.getString("country") + "</td></tr>");
            out.println("<tr><th>" + "User id" + "</th><td>" + userName + "</td></tr>");
            out.println("</table>");
            }catch(Exception e){
                out.println(e);
        }
    }
    // Make sure to close connection
    closeConnection();
%>
<form action="customerEdit.jsp">
    <button type="submit" id="edit-button">Edit</button>
</form>
</div>
</body>
</html>
<!DOCTYPE html>
<html>
<head>
<title>Customer Page</title>
</head>
<body>
<%@ include file="header.jsp" %>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>

<form name="MyForm" method=post action="validateEditCustomer.jsp">
<%
    String sql = "";
    // Print Customer information
    getConnectionForOrders();
	session = request.getSession(true);
	int mycustId = getCustIdFromAuthUser(session);
    String userName = (String) session.getAttribute("authenticatedUser");
    out.println("<font face=\"Century Gothic\" size=\"2\">");

	if (mycustId == 69420) { //probably change this so it does the below code if logged in as admin 
        out.println("<p>You must be logged in to edit a customer!</p>");
    } else {
        try{
            sql = "SELECT customerId, firstName, lastName, email, phonenum, address, city, state, postalCode, country, password FROM customer " +
            "WHERE userid = ?";
            PreparedStatement p = con.prepareStatement(sql);
            p.setString(1, userName);
            ResultSet rst = p.executeQuery();
            rst.next();
            out.println("<table border=\"1\"><tr><th>" + "Id" + "</th><td>" + rst.getInt("customerId") + "</td></tr>");
            out.println("<tr><th>" + "First Name" + "</th><td><input type=\"text\" name=\"firstName\"  size=20 maxlength=20 value = \"" + rst.getString("firstName") + "\"></td></tr>");
            out.println("<tr><th>" + "Last Name" + "</th><td><input type=\"text\" name=\"lastName\"  size=20 maxlength=20 value = \"" + rst.getString("lastName") + "\"></td></tr>");
            out.println("<tr><th>" + "Email" + "</th><td><input type=\"text\" name=\"email\"  size=20 maxlength=20 value = \"" + rst.getString("email") + "\"></td></tr>");
            out.println("<tr><th>" + "Phone" + "</th><td><input type=\"text\" name=\"phonenum\"  size=20 maxlength=20 value = \"" + rst.getString("phonenum") + "\"></td></tr>");
            out.println("<tr><th>" + "Address" + "</th><td><input type=\"text\" name=\"address\"  size=20 maxlength=20 value = \"" + rst.getString("address") + "\"></td></tr>");
            out.println("<tr><th>" + "City" + "</th><td><input type=\"text\" name=\"city\"  size=20 maxlength=20 value = \"" + rst.getString("city") + "\"></td></tr>");
            out.println("<tr><th>" + "State" + "</th><td><input type=\"text\" name=\"state\"  size=20 maxlength=20 value = \"" + rst.getString("state") + "\"></td></tr>");
            out.println("<tr><th>" + "Postal Code" + "</th><td><input type=\"text\" name=\"postalCode\"  size=20 maxlength=20 value = \"" + rst.getString("postalCode") + "\"></td></tr>");
            out.println("<tr><th>" + "Country" + "</th><td><input type=\"text\" name=\"country\"  size=20 maxlength=20 value = \"" + rst.getString("country") + "\"></td></tr>");
            out.println("<tr><th>" + "User id" + "</th><td><input type=\"text\" name=\"username\"  size=20 maxlength=20 value = \"" + userName + "\"></td></tr>");
             out.println("<tr><th>" + "Password " + "</th><td><input type=\"text\" name=\"password\"  size=20 maxlength=20 value = \"" + rst.getString("password") + "\"></td></tr>");
            out.println("</table>");
            }catch(Exception e){
                out.println(e);
        }
    if (session.getAttribute("customerEditMessage") != null) //after unsucessful edit
	out.println("<p>"+session.getAttribute("customerEditMessage").toString()+"</p>");
    session.removeAttribute("customerEditMessage");
    }
    // Make sure to close connection
    closeConnection();
%>

<input class="submit" type="submit" name="Submit4" value="Done">
</form>


</div>
</body>
</html>
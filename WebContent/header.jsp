<H1 align="center"><font face="cursive" color="#3399FF"><a href="index.jsp">Supercool Bookstore</a></font></H1>      
<%
String username = (String) session.getAttribute("authenticatedUser");
if(username != null){
        out.println("<h4> Signed in as: " + username + "</h4>");
}
%>
<hr>

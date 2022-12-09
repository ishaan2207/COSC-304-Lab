<H1 align="center"><font face="cursive" color="#3399FF"><a href="index.jsp">Supercool Bookstore</a></font></H1>      
<%
String userName = (String) session.getAttribute("authenticatedUser");
if(userName != null){
        out.println("<h4> Signed in as: " + userName + "</h4>");
}
%>
<hr>

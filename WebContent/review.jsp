<%@ page import="java.util.HashMap" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>
<%@ include file="auth.jsp" %>

<html>
<head>
<title>Supercool Bookstore - Leave a Review</title>

<link href="css/star.css" rel="starFormat">
</head>
<body>
<%@ include file="header.jsp" %>

<%
    session = request.getSession(true);
    String userName = (String) session.getAttribute("authenticatedUser");
    int id2 = Integer.valueOf(request.getParameter("id"));
    out.println("<br>");
    out.println("<form name=\"MyForm\" method=post action=\"submitReview.jsp?id=" + id2 + "\">");
%>

<br>
<div align="left"><font face="Arial, Helvetica, sans-serif" size="4"> Rating from 1-5:</font></div></td>
<input type="Content" name="rating" size=5 maxlength="1"></td>
<div align="left"><font face="Arial, Helvetica, sans-serif" size="4"> Comment:</font></div></td>
<input type="Content" name="comment" size=100 maxlength="1000"></td>

<br/>
<br/>
<input class="submit" type="submit" name="SubmitReview" value="Submit Review">
</form>
</div>

</body>
</html>


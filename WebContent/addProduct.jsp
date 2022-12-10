<%@ page import="java.util.HashMap" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>
<%@ include file="auth.jsp" %>
<font face="Century Gothic" size="3">
<html>
<head>
<title>Supercool Bookstore - Add a Product</title>

<link href="css/star.css" rel="starFormat">
</head>
<body>
<%@ include file="header.jsp" %>

<%
    session = request.getSession(true);
    String userName = (String) session.getAttribute("authenticatedUser");
    out.println("<br>");
    
%>

<br>
<form name="MyForm" method=post action="submitProduct.jsp">
<table style="display:inline">
<tr>
<div align="left"><font face="Century Gothic" size="4"> Product Name</font></div></td>
<input type="Content" name="name" size=5 maxlength=1000></td>
</tr>
<tr>
<div align="left"><font face="Century Gothic" size="4"> Price </font></div></td>
<input type="number" step="0.01" name="price" size=100 max="99" min="0"></td>
</tr>
<tr>
<div align="left"><font face="Arial, Helvetica, sans-serif" size="4"> Description </font></div></td>
<input type="Content" name="description" size=100 maxlength=1000></td>
</tr>
<tr>
<div align="left"><font face="Arial, Helvetica, sans-serif" size="4"> Category Id </font></div></td>
<input type="number" name="categoryId" size=100></td>
</tr>
<tr>
<div align="left"><font face="Arial, Helvetica, sans-serif" size="4"> Author Id </font></div></td>
<input type="number" name="authorId" size=100></td>
</tr>
<br/>
<br/>
<input class="submit" type="submit" name="submitProduct" value="Submit Product">
</form>
</div>



</body>
</html>


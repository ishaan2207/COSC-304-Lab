<%@ include file="header.jsp" %>
<!DOCTYPE html>
<html>
<head>
<title>Login Screen</title>
</head>
<body>

<div style="margin:0 auto;text-align:center;display:inline">

<h3>Create New Account</h3>

<%
// Print prior error register message if present
if (session.getAttribute("registerMessage") != null)
	out.println("<p>"+session.getAttribute("registerMessage").toString()+"</p>");
%>
<br>
<form name="MyForm" method=post action="validateRegister.jsp">
<table style="display:inline">
<tr>
	<td><div align="right"><font face="Century Gothic" size="2">Username:</font></div></td>
	<td><input type="text" name="username"  size=20 maxlength=20></td>
	<td><div align="right"><font face="Century Gothic" size="2">Password:</font></div></td>
	<td><input type="password" name="password" size=20 maxlength="20"></td>
</tr>
<tr>
	<td><div align="right"><font face="Century Gothic" size="2">First Name:</font></div></td>
	<td><input type="text" name="firstName"  size=20 maxlength=20></td>
	<td><div align="right"><font face="Century Gothic" size="2">Last Name:</font></div></td>
	<td><input type="text" name="lastName" size=20 maxlength="20"></td>
</tr>
<tr>
	<td><div align="right"><font face="Century Gothic" size="2">Email:</font></div></td>
	<td><input type="text" name="email"  size=20 maxlength=20></td>
	<td><div align="right"><font face="Century Gothic" size="2">Phone Number:</font></div></td>
	<td><input type="text" name="phonenum" size=20 maxlength="20"></td>
</tr>
<tr>
	<td><div align="right"><font face="Century Gothic" size="2">Address:</font></div></td>
	<td><input type="text" name="address"  size=20 maxlength=20></td>
	<td><div align="right"><font face="Century Gothic" size="2">City:</font></div></td>
	<td><input type="text" name="city" size=20 maxlength="20"></td>
</tr>
<tr>
	<td><div align="right"><font face="Century Gothic" size="2">State:</font></div></td>
	<td><input type="text" name="state"  size=20 maxlength=20></td>
	<td><div align="right"><font face="Century Gothic" size="2">Postal Code:</font></div></td>
	<td><input type="text" name="postalCode" size=20 maxlength="20"></td>
</tr>
<tr>
	<td><div align="right"><font face="Century Gothic" size="2">Country:</font></div></td>
	<td><input type="text" name="country"  size=20 maxlength=20></td>
</tr>
</table>
<br/>
<input class="submit" type="submit" name="Submit3" value="Create Account">
</form>

</div>

</body>
</html>


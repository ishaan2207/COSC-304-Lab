<%@ page language="java" import="java.io.*,java.sql.*"%>
<%@ include file="jdbc.jsp" %>
<%
	//String authenticatedUser = null;
	session = request.getSession(true);
	session.removeAttribute("registerMessage");
	boolean success = true;
	try
	{
		success = validateRegister(out,request,session);
		
	}
	catch(IOException e)
	{	System.err.println(e); }

	if(success)
		response.sendRedirect("login.jsp");		// Successful login
	else
		response.sendRedirect("register.jsp");		// Failed login - redirect back to login page with a message  --%>
%>


<%!
	boolean validateRegister(JspWriter out,HttpServletRequest request, HttpSession session) throws IOException
	{
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		String firstName = request.getParameter("firstName");
		String lastName = request.getParameter("lastName");
		String email = request.getParameter("email");
		String phonenum = request.getParameter("phonenum");
		String address = request.getParameter("address");
		String city = request.getParameter("city");
		String state = request.getParameter("state");
		String postalCode = request.getParameter("postalCode");
		String country = request.getParameter("country");

		if(username == null || password == null|| firstName == null|| lastName == null|| email == null|| phonenum == null|| address == null|| city == null|| state == null|| postalCode == null|| country == null) {
				session.setAttribute("registerMessage","All fields must be filled. Please try again");
				return false;
		}
		if((username.length() == 0) || (password.length() == 0)|| (firstName.length() == 0)|| (lastName.length() == 0)|| (email.length() == 0)|| (phonenum.length() == 0)|| (city.length() == 0)|| (state.length() == 0)|| (postalCode.length() == 0)|| (country.length() == 0)|| (address.length() == 0)) {
				session.setAttribute("registerMessage","All fields must be filled. Please try again");
				return false;
		}
		try 
		{

			getConnectionForOrders();
			String q = "SELECT userid FROM customer WHERE userid = ?";
			PreparedStatement p = con.prepareStatement(q);
			p.setString(1, username);
			ResultSet r = p.executeQuery();
			boolean alreadyInUse = false;
			while (r.next()) {
				if (r.getString("userid").equals(username))
					alreadyInUse = true;
			}		
			if (alreadyInUse) {
				session.setAttribute("registerMessage","Username already in use. Please try again");
				return false;
			} else {
				/*
				CREATE TABLE customer ( just leaving here for reference
					customerId          INT IDENTITY,
					firstName           VARCHAR(40),
					lastName            VARCHAR(40),
					email               VARCHAR(50),
					phonenum            VARCHAR(20),
					address             VARCHAR(50),
					city                VARCHAR(40),
					state               VARCHAR(20),
					postalCode          VARCHAR(20),
					country             VARCHAR(40),
					userid              VARCHAR(20),
					password            VARCHAR(30),
					PRIMARY KEY (customerId)
				);
				*/
				String sqlMakeUser = "INSERT INTO (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
				PreparedStatement pMakeUser = con.prepareStatement(sqlMakeUser);
				pMakeUser.setString(1,firstName);
				pMakeUser.setString(2,lastName);
				pMakeUser.setString(3,email);
				pMakeUser.setString(4,phonenum);
				pMakeUser.setString(5,address);
				pMakeUser.setString(6,city);
				pMakeUser.setString(7,state);
				pMakeUser.setString(8,postalCode);
				pMakeUser.setString(9,country);
				pMakeUser.setString(10,username);
				pMakeUser.setString(11,password);
				pMakeUser.execute();
			}
		} 
		catch (Exception ex) {
			out.println(ex);
		}
			
		session.setAttribute("registerMessage","Register of user " + username + " succesful! You may now login");
		return true;
	}
%>
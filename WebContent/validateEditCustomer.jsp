<%@ page language="java" import="java.io.*,java.sql.*"%>
<%@ include file="jdbc.jsp" %>
<%
	//String authenticatedUser = null;
	session = request.getSession(true);
	boolean success = true;
	try
	{
		success = validateEditCustomer(out,request,session);
		
	}
	catch(IOException e)
	{	System.err.println(e); }
	
	if(success)
		response.sendRedirect("customer.jsp");		// Successful login
	else
		response.sendRedirect("customerEdit.jsp");		// Failed login - redirect back to login page with a message  --%>
%>


<%!
	boolean validateEditCustomer(JspWriter out,HttpServletRequest request, HttpSession session) throws IOException
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
		boolean changedUsername = false;


		if(username == null || password == null|| firstName == null|| lastName == null|| email == null|| phonenum == null|| address == null|| city == null|| state == null|| postalCode == null|| country == null) {
				session.setAttribute("customerEditMessage","All fields must be filled. Please try again");
				return false;
		}
		if((username.length() == 0) || (password.length() == 0)|| (firstName.length() == 0)|| (lastName.length() == 0)|| (email.length() == 0)|| (phonenum.length() == 0)|| (city.length() == 0)|| (state.length() == 0)|| (postalCode.length() == 0)|| (country.length() == 0)|| (address.length() == 0)) {
				session.setAttribute("customerEditMessage","All fields must be filled. Please try again");
				return false;
		}
		try 
		{

			getConnectionForOrders();
			//make sure no one has the same username
			int mycustId = getCustIdFromAuthUser(session);
			String q = "SELECT userid FROM customer WHERE userid = ? AND customerId != ?";
			PreparedStatement p = con.prepareStatement(q);
			p.setString(1, username);
			p.setString(2, Integer.toString(mycustId));
			ResultSet r = p.executeQuery();
			boolean alreadyInUse = false;
			while (r.next()) {
				if (r.getString("userid").equals(username))
					alreadyInUse = true;
			}		
			if (alreadyInUse) {
				session.setAttribute("customerEditMessage","Username already in use. Please try again");
				return false;
			} else {
				//log the user out if they changed their username
				String oldUserName = (String) session.getAttribute("authenticatedUser");
				if (!oldUserName.equals(username)) {
					changedUsername = true;
				}
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
				String sqlMakeUser = "UPDATE customer SET firstName = ?, lastName = ?, email = ?, phonenum = ?, address = ?, city = ?, state = ?, postalCode = ?, country = ?, userid = ?, password = ? WHERE customerId = ?";
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
				pMakeUser.setString(12,Integer.toString(mycustId));
				pMakeUser.execute();

			}
		} 
		catch (Exception ex) {
			out.println(ex);
		}
		
		if (changedUsername) { //log user out
		session.setAttribute("authenticatedUser",null);
		session.setAttribute("customerEditMessage","Changes to " + username + "'s account saved! You will need to log in again.");
		} else {
		session.setAttribute("customerEditMessage","Changes to " + username + "'s account saved!");
		}
		return true;
	}
%>
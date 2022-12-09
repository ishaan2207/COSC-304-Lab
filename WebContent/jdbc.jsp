<!--
A JSP file that encapsulates database connections.

Public methods:
- public void getConnection() throws SQLException
- public void closeConnection() throws SQLException  
-->

<%@ page import="java.sql.*"%>

<%!
	// User id, password, and server information
	private String url = "jdbc:sqlserver://cosc304_sqlserver:1433;TrustServerCertificate=True";
	private String urlOrders = "jdbc:sqlserver://cosc304_sqlserver:1433;databaseName=orders;TrustServerCertificate=True";
	private String uid = "sa";
	private String pw = "304#sa#pw";

	// Connection
	private Connection con = null;
%>

<%!
	public void getConnection() throws SQLException 
	{
		try
		{	// Load driver class
			Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
		}
		catch (java.lang.ClassNotFoundException e)
		{
			throw new SQLException("ClassNotFoundException: " +e);
		}
	
		con = DriverManager.getConnection(url, uid, pw);
	}
   
public void getConnectionForOrders() throws SQLException 
	{
		try
		{	// Load driver class
			Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
		}
		catch (java.lang.ClassNotFoundException e)
		{
			throw new SQLException("ClassNotFoundException: " +e);
		}
	
		con = DriverManager.getConnection(urlOrders, uid, pw);
	}

	public void closeConnection() throws SQLException 
	{
		if (con != null)
			con.close();
		con = null;
	}

	public int getCustIdFromAuthUser(HttpSession session) throws SQLException {
		getConnectionForOrders();
		String userName = (String) session.getAttribute("authenticatedUser");
		String custid = "SELECT customerId FROM customer WHERE userid = ?";
		PreparedStatement pstmt = con.prepareStatement(custid);
		pstmt.setString(1, userName);
		ResultSet rs = pstmt.executeQuery();
		int customerId = 69420; // recieving a custId of 69420 means no user was logged in
		while(rs.next()){
			customerId = rs.getInt("customerId");
		
		}
		return customerId;
	}
%>
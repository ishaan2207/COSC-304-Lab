<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Date" %>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>Super Cool Bookstore Shipment Processing</title>
</head>
<body>
        
<%@ include file="header.jsp" %>

<%
	getConnectionForOrders();
	// Get order id
	String ordId = request.getParameter("orderId");
          
	// Check if valid order id
	boolean isValid = false;
	String sqlvalidorder = "SELECT orderId FROM ordersummary WHERE orderId = ?";
    PreparedStatement pstmt = con.prepareStatement(sqlvalidorder);
    pstmt.setInt(1, Integer.parseInt(ordId));
    ResultSet rst = pstmt.executeQuery();
	while(rst.next()) {
		if (rst.getString("orderId").equals(String.valueOf(ordId))) { //rst should return null if there was no matches, which will leave isValid false
			isValid = true;
		}
	}

	if (!isValid) {
		out.println("<h1>Error. Invalid orderId</h1>");
	} else {
		// Start a transaction (turn-off auto-commit)
		con.setAutoCommit(false);

		// Retrieve all items in order with given id
		String sqlProdsInOrder = "SELECT productId, quantity FROM orderproduct WHERE orderId= ?";
   		PreparedStatement pstmt2 = con.prepareStatement(sqlProdsInOrder);
   		pstmt2.setInt(1, Integer.parseInt(ordId));
		ResultSet RstProds = pstmt2.executeQuery();

		// Create a new shipment record.
		/*shipmentId          INT IDENTITY,
   		 shipmentDate        DATETIME,   
    	 shipmentDesc        VARCHAR(100),   
   		 warehouseId         INT, */
		//shipmentId is an identity, so we don't have to insert it and it should automatically update
		String sqlInsertship = "INSERT INTO shipment (shipmentDate, shipmentDesc, warehouseId) VALUES (?, ?, ?)";
   		PreparedStatement pstmtInsertship = con.prepareStatement(sqlInsertship);
		pstmtInsertship.setDate(1, java.sql.Date.valueOf(java.time.LocalDate.now()));
   		pstmtInsertship.setString(2, "a wacky crazy shipment");
		pstmtInsertship.setInt(3,1);
		pstmtInsertship.execute();

		// For each item verify sufficient quantity available in warehouse 1.
		boolean hasAllItems = true;
		while (RstProds.next()) {
			String pid = RstProds.getString("productId");
			String quant = RstProds.getString("quantity");
			String sqlVerifyQuant = "SELECT productId, quantity FROM productinventory WHERE productId = ? and quantity >= ?";
   			PreparedStatement pstmtVerifyQuant = con.prepareStatement(sqlVerifyQuant);
   			pstmtVerifyQuant.setString(1, pid);
			pstmtVerifyQuant.setString(2, quant);
			ResultSet RstVerifyQuant = pstmtVerifyQuant.executeQuery();
			boolean isValidQuant = false;
			while(RstVerifyQuant.next()) {//RstVerifyQuant should return null if there was no matches, which will leave isValidQuant false
				if (RstVerifyQuant.getString("productId").equals(String.valueOf(pid))) { 
					isValidQuant = true;
				}
			}
			if (!isValidQuant) {
				hasAllItems = false;
				out.println("<h2>Shipment Not Placed - Insufficient stock for: </h2>");
				out.println("<h2>Requested item id: " + pid + ". Requested Quantity: " + quant + "</h2>");
			}
		}
		
		// If any item does not have sufficient inventory, cancel transaction and rollback. Otherwise, update inventory for each item.
		if (hasAllItems) {
			RstProds = pstmt2.executeQuery(); //refresh resultset
			while (RstProds.next()) {
				String pid = RstProds.getString("productId");
				String quant = RstProds.getString("quantity");
				String sqlUpdateQuant = "UPDATE productinventory SET quantity = quantity - ? WHERE productId = ?";
   				PreparedStatement pstmtUpdateQuant = con.prepareStatement(sqlUpdateQuant);
   				pstmtUpdateQuant.setString(1, quant);
				pstmtUpdateQuant.setString(2, pid);
				pstmtUpdateQuant.execute();
				//get warehouse quantity
				String sqlSelectQuant = "SELECT quantity FROM productinventory WHERE productId = ?";
   				PreparedStatement pstmtSelectQuant = con.prepareStatement(sqlSelectQuant);
				pstmtSelectQuant.setString(1, pid);
				ResultSet RstSelectQuant = pstmtSelectQuant.executeQuery();
				RstSelectQuant.next();
				out.println("<h2>Ordered product id: " + pid + ". Order Quantity: " + quant + ". Warehouse Old Quantity: " + (RstSelectQuant.getInt("quantity") + Integer.parseInt(quant)) + ". Warehouse New Quantity: " + RstSelectQuant.getInt("quantity") + "</h2>");
			}
			con.commit();
			out.println("<h1>Succesfully shipped order.</h1>");
		} else{
			con.rollback();
		}
		// Auto-commit should be turned back on
		con.setAutoCommit(true);
	}
	closeConnection();
%>                       				

<h2><a href="index.jsp">Back to Main Page</a></h2>

</body>
</html>

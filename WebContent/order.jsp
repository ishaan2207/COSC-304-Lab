<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>
<!DOCTYPE html>
<html>
<head>
<title>YOUR NAME Grocery Order Processing</title>
</head>
<body>

<% 
// Get customer id
String custId = request.getParameter("customerId");
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

// Determine if valid customer id was entered
boolean validId = true;
int refnum = 0;
NumberFormat currFormat = NumberFormat.getCurrencyInstance();
try{
	
	int cid = Integer.parseInt(custId);
    
        getConnectionForOrders();
    
        String sql = "SELECT customerId FROM customer WHERE customerId = ?";
        PreparedStatement pstmt = con.prepareStatement(sql);
        pstmt.setInt(1, cid);
        ResultSet rst = pstmt.executeQuery();
        if(!rst.next()) {
            validId = false;
            out.println("<h1>Not added Valid ID</h1><br>");
            out.println("<h1>Your Shopping Cart is Empty!</h1>");
        }
    

	if(validId){
		String sql3 = "SELECT product.productId, orderId, price, quantity, productName FROM orderproduct JOIN product "
		+ "ON orderproduct.productId = product.productId";
		String sql4 = "SELECT firstName, lastName FROM customer WHERE customerId = ?";
		PreparedStatement pstmt4 = con.prepareStatement(sql4);
		pstmt4.setString(1, custId);
		ResultSet rst3 = pstmt4.executeQuery();
		String name = "";
		while(rst3.next()){
		 name = rst3.getString("firstName") + " " + rst3.getString("lastName");
		}

	
		
		
		
		PreparedStatement pstmt2 = con.prepareStatement(sql3, Statement.RETURN_GENERATED_KEYS);
		PreparedStatement pstmt3 = con.prepareStatement(sql3);
		pstmt2.executeQuery();
		ResultSet rst2 = pstmt3.executeQuery();
		ResultSet keys = pstmt2.getGeneratedKeys();

	
		String sq = "SELECT orderId FROM ordersummary";
		PreparedStatement sqa = con.prepareStatement(sq);
		ResultSet poop = sqa.executeQuery();
		keys.next();
		int orderId = keys.getInt(1);
		while(poop.next()){
		 orderId++;
		}
		orderId++;
		
	
		
		
		
		out.println("<h1>Your Order Summary</h1>");
		out.println("<table><tr><th>Product Id</th><th>Product Name</th><th>Quantity</th><th>Price</th><th>Subtotal</th></tr>");
		double total = 0;
		int i = 0;
		int j = 0;
		Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
		Iterator<Map.Entry<String, ArrayList<Object>>> iterator2 = productList.entrySet().iterator();
		String[] pname = new String[28];
		
    String sql1 = "SELECT address, city, state, postalCode, country FROM customer WHERE customerId = ?";
    PreparedStatement pstmt1 = con.prepareStatement(sql1);
    pstmt1.setInt(1, cid);
    ResultSet rst1 = pstmt1.executeQuery();
    String[] info = new String[5];
    int k = 0;
    while(rst1.next()) {
        info[k] = rst1.getString(k+1);
        k++;
    }
	while (iterator2.hasNext())
	{ 
		
		//String[] productName = new String[20];
		Map.Entry<String, ArrayList<Object>> entry2 = iterator2.next();
		ArrayList<Object> product2 = (ArrayList<Object>) entry2.getValue();
		String productId = (String) product2.get(0);
        String price = (String) product2.get(2);
		double pr = Double.parseDouble(price);
		int qty = ( (Integer)product2.get(3)).intValue();
		total = total + pr*qty;
		
            
	}

		
       // String sql2 = "UPDATE orderSummary SET orderDate = ?, totalAmount = ?, shiptoAddress = ?, shiptoCity = ?, shiptoPostalCode = ?, shiptoCountry = ?, customerId = ?" +
        //     " WHERE orderId = ?";
		String sql2 = "INSERT INTO orderSummary VALUES(?, null, ?, ?, ?, ?, ?, ?)";
        PreparedStatement pstmt5 = con.prepareStatement(sql2);
       // orderId, totalAmount, info[0], info[1], info[2], info[3], info[4], custId
	   
		java.sql.Date sqlDate = new java.sql.Date(System.currentTimeMillis()); 
        pstmt5.setInt(1, orderId);
		//pstmt5.setObject(2, new java.sql.Date(sqlDate.getTime()));
		//pstmt5.setDouble(2, 2);
        pstmt5.setDouble(2, total);
        pstmt5.setString(3, info[0]);
        pstmt5.setString(4, info[1]);
        pstmt5.setString(5, info[2]);
        pstmt5.setString(6, info[3]);
        pstmt5.setString(7, custId);
		//pstmt5.setInt(8, orderId);
        pstmt5.execute();
		
		String up = "UPDATE orderSummary SET totalAmount = ? WHERE orderId = ?";
		PreparedStatement upd = con.prepareStatement(up);
		upd.setDouble(1, total);
		upd.setInt(2, orderId);
		upd.execute();
		

		while(rst2.next()){
			pname[i] = rst2.getString("productName");
			i++;
		}
		//int orderIdInc = 0;
		while (iterator.hasNext())
	{ 
		
		//String[] productName = new String[20];
		Map.Entry<String, ArrayList<Object>> entry = iterator.next();
		ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
		String productId = (String) product.get(0);
        String price = (String) product.get(2);
		double pr = Double.parseDouble(price);
		int qty = ( (Integer)product.get(3)).intValue();
		String pls = "INSERT INTO orderproduct(orderId, productId, quantity, price) VALUES" + 
		"(?, ?, ?, ?)";
		//String pls = "UPDATE orderproduct SET productId = ?, quantity = ?, price = ? WHERE orderId = ?";
		PreparedStatement pls2 = con.prepareStatement(pls);
		//keys.last();
		pls2.setInt(1, orderId);
		pls2.setString(2, productId);
		pls2.setInt(3, qty);
		pls2.setDouble(4, pr);
		
		pls2.execute();
		out.println("<tr><td>" + productId + "</td><td>" + pname[j]+ "</td><td>" + qty + "</td><td>"
		+ currFormat.format(pr) + "</td><td>" + currFormat.format(pr*qty) + "</td></tr>");
		//total = total + pr*qty;
		j++;
		
            
	}
		
	
	
	out.println("<tr><td></td><td></td><td></td><td><b>Order Total: </b></td><td>" + currFormat.format(total) + "</td></tr></table>");
	out.println("<h1>Order completed. Will be shipped soon...</h1>");
	out.println("<h1>Your order reference number is: " + orderId);
	out.println("<h1>Shipping to Customer: " + cid + " Name: " + name);
	out.println("</h1>");
	session.setAttribute("productList", null);
	}
}catch(Exception e) {
	out.println("<h1>Not a Valid ID</h1><br>");
    out.println("<h1>Your Shopping Cart is Empty!</h1>");
	out.print(e);
}



// Determine if there are products in the shopping cart
// If either are not true, display an error message

// Make connection

// Save order information to database


	/*
	// Use retrieval of auto-generated keys.
	PreparedStatement pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);			
	ResultSet keys = pstmt.getGeneratedKeys();
	keys.next();
	int orderId = keys.getInt(1);
	*/

// Insert each item into OrderProduct table using OrderId from previous INSERT

// Update total amount for order record

// Here is the code to traverse through a HashMap
// Each entry in the HashMap is an ArrayList with item 0-id, 1-name, 2-quantity, 3-price

/*
	Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
	while (iterator.hasNext())
	{ 
		Map.Entry<String, ArrayList<Object>> entry = iterator.next();
		ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
		String productId = (String) product.get(0);
        String price = (String) product.get(2);
		double pr = Double.parseDouble(price);
		int qty = ( (Integer)product.get(3)).intValue();
            ...
	}
*/

// Print out order summary

// Clear cart if order placed successfully
%>
</BODY>
</HTML>
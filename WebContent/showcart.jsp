<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Map" %>
<%@ include file="jdbc.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="header.jsp" %>
<font face="Century Gothic" size="2">
<!DOCTYPE html>
<html>
<head>
<title>Your Shopping Cart</title>
</head>
<body>

<%

getConnectionForOrders();
// Get the current list of products
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

if (productList == null)
{	out.println("<H1>Your shopping cart is empty!</H1>");
	productList = new HashMap<String, ArrayList<Object>>();
}
else
{
	NumberFormat currFormat = NumberFormat.getCurrencyInstance();

	out.println("<h1>Your Shopping Cart</h1>");
	out.print("<table><tr><th>Product Id</th><th>Product Name</th><th>Quantity</th>");
	out.println("<th>Price</th><th>Subtotal</th></tr>");

	boolean hasAllItems = true;
	double total =0;
	Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
	while (iterator.hasNext()) 
	{	Map.Entry<String, ArrayList<Object>> entry = iterator.next();
		ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
		if (product.size() < 4)
		{
			out.println("Expected product with four entries. Got: "+product);
			continue;
		}
		
		out.print("<tr><td>"+product.get(0)+"</td>");
		out.print("<td>"+product.get(1)+"</td>");
		String productName1 = product.get(1).toString().replace(' ','+');
		out.print("<td align=\"center\">"+product.get(3)+" <a style=\"text-decoration:none;background-color:lime\" href = addcart.jsp?id=" + product.get(0) + "&name=" + productName1 + "&price=" + product.get(2) +"> ＋ </a> <a style=\"text-decoration:none;background-color:red\" style=\"font-weight:bold\" href = addcart.jsp?id=" + product.get(0) + "&name=" + "-"+ productName1 + "&price=" + product.get(2) +"> &nbsp−&nbsp </a></td>");
        
		Object price = product.get(2);
		Object itemqty = product.get(3);
		double pr = 0;
		int qty = 0;
		
		try
		{
			pr = Double.parseDouble(price.toString());
		}
		catch (Exception e)
		{
			out.println("Invalid price for product: "+product.get(0)+" price: "+price);
		}
		try
		{
			qty = Integer.parseInt(itemqty.toString());
		}
		catch (Exception e)
		{
			out.println("Invalid quantity for product: "+product.get(0)+" quantity: "+qty);
		}		

		out.print("<td align=\"right\">"+currFormat.format(pr)+"</td>");
		out.print("<td align=\"right\">"+currFormat.format(pr*qty)+"</td>");

		// verify sufficient quantity available in warehouse 1.
		String sqlVerifyQuant = "SELECT productId, quantity FROM productinventory WHERE productId = ? and quantity >= ?";
   		PreparedStatement pstmtVerifyQuant = con.prepareStatement(sqlVerifyQuant);
   		pstmtVerifyQuant.setString(1, product.get(0).toString());
		pstmtVerifyQuant.setString(2, String.valueOf(qty));
		ResultSet RstVerifyQuant = pstmtVerifyQuant.executeQuery();
		boolean isValidQuant = false;
		while(RstVerifyQuant.next()) {//RstVerifyQuant should return null if there was no matches, which will leave isValidQuant false
			if (RstVerifyQuant.getString("productId").equals(product.get(0).toString())) { 
				isValidQuant = true;
			}
		}
		if (!isValidQuant) {
			hasAllItems = false;
			out.print("<td style=\"color:red\">Insufficient stock</td>");
		}
		out.print("</tr>");

		out.println("</tr>");
		total = total +pr*qty;
	}
	out.println("<tr><td colspan=\"4\" align=\"right\"><b>Order Total</b></td>"
			+"<td align=\"right\">"+currFormat.format(total)+"</td></tr>");
	out.println("</table>");
	
	//don't show checkout button if any item as insufficient stock
	if (hasAllItems)
		out.println("<h2><a href=\"checkout.jsp\">Check Out</a></h2>");
}
%>
<h2><a href="listprod.jsp">Continue Shopping</a></h2>
</body>
</html> 


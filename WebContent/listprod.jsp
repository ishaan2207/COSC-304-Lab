<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>SuperCool Bookstore</title>
<link href="css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<%@ include file="header.jsp" %>


<%
// colors for different item categories
HashMap<String,String> colors = new HashMap<String,String>();		// This may be done dynamically as well, a little tricky...
colors.put("Biography", "#465F9E");
colors.put("Children's", "#FC6A03");
colors.put("Fantasy", "#C080FB");
colors.put("Conspiracy", "#000000");
colors.put("Mystery", "#6600CC");
colors.put("Non-Fiction", "#55A5B3");
colors.put("Poetry", "#FFD300");
colors.put("Romance", "#850101");
// alternate color scheme
HashMap<String,String> c2 = new HashMap<String,String>();
c2.put("Anonymous", "#000000");
c2.put("Lucas Dark", "#EDC9FF");
c2.put("Cornelius Implorium", "#F6CFF3");
c2.put("Bella Jacobs", "#FED4E7");
c2.put("Mike Jeffress", "#F8C6C3");
c2.put("B.E. Kind", "#F2B79F");
c2.put("Ace Monteque", "#ECB784");
c2.put("Susie Saltwater", "#006994");
c2.put("Jim Scuttleson", "#E5B769");
c2.put("Genevieve Serene", "#DFC24F");
c2.put("Biggles Tall", "#D8CC34");
c2.put("Greg Vartin", "#DCD146");
c2.put("Sir Woof", "#B86D29");

%>
<h2>Browse Products By Category and/or Author and Search by Product Name:</h2>


  



 <form id = "form1" method="get" action="listprod.jsp">
  <p align="left">
  <select size="1" name="categoryName">
  <option>All</option>
  <option>Biography</option>
  <option>Children's</option>
  <option>Fantasy</option>
  <option>Conspiracy</option>
  <option>Mystery</option>
  <option>Non-Fiction</option>
  <option>Poetry</option>
  <option>Romance</option>       
  </select>
  <form id = "form2" method="get" action="listprod.jsp">
 <select size="1" name="authorName">
 <option>All</option>
  <option>Anonymous</option>
  <option>Lucas Dark</option>
  <option>Cornelius Implorium</option>
  <option>Bella Jacobs</option>
  <option>Mike Jeffress</option>
  <option>B.E. Kind</option>
  <option>Ace Monteque</option>
  <option>Susie Saltwater</option>
  <option>Jim Scuttleson</option>
  <option>Genevieve Serene</option>
  <option>Biggles Tall</option>
  <option>Greg Vartin</option>
  <option>Sir Woof</option>
  </select>
  <input type="text" name="productName" size="50">
  <input type="submit" value="Submit"><input type="reset" value="Reset"></p>
</form>
<%

// Get product name to search for
String name = request.getParameter("productName");
String category = request.getParameter("categoryName");
String author = request.getParameter("authorName");
session = request.getSession(true);
int custId = getCustIdFromAuthUser(session);

boolean hasNameParam = name != null && !name.equals("");
boolean hasCategoryParam = category != null && !category.equals("") && !category.equals("All");
boolean hasAuthParam = author != null && !author.equals("") && !author.equals("All");
String filter = "", sql = "";



if(hasNameParam && hasCategoryParam && hasAuthParam)
{
	filter = "<h3>Products containing '"+name+"' in category: '"+category+"' by author: '"+author+"'</h3>";
	name = '%'+name+'%';
	sql = "SELECT productId, productName, productPrice, categoryName, authorName FROM Author A JOIN Product P ON A.authorId = P.authorId JOIN Category C ON C.categoryId = P.categoryId WHERE productName LIKE ? AND categoryName = ? AND authorName = ?";
}

else if(hasNameParam && hasCategoryParam)
{
	filter = "<h3>Products containing '"+name+"' in category: '"+category+"'</h3>";
	name = '%'+name+'%';
	sql = "SELECT productId, productName, productPrice, categoryName, authorName FROM Author A JOIN Product P ON A.authorId = P.authorId JOIN Category C ON C.categoryId = P.categoryId WHERE productName LIKE ? AND categoryName = ?";
}
else if(hasNameParam && hasAuthParam)
{
	filter = "<h3>Products containing '"+name+"' by author: '"+author+"'</h3>";
	name = '%'+name+'%';
	sql = "SELECT productId, productName, productPrice, categoryName, authorName FROM Author A JOIN Product P ON A.authorId = P.authorId JOIN Category C ON C.categoryId = P.categoryId WHERE productName LIKE ? AND authorName = ?";
}
else if(hasCategoryParam && hasAuthParam)
{
	filter = "<h3>Products in category: '"+category+"' by author: '"+author+"'</h3>";
	sql = "SELECT productId, productName, productPrice, categoryName, authorName FROM Author A JOIN Product P ON A.authorId = P.authorId JOIN Category C ON C.categoryId = P.categoryId WHERE categoryName = ? AND authorName = ?";
}
else if (hasNameParam)
{
	filter = "<h3>Products containing '"+name+"'</h3>";
	name = '%'+name+'%';
	sql = "SELECT productId, productName, productPrice, categoryName, authorName FROM Author A JOIN Product P ON A.authorId = P.authorId JOIN Category C ON C.categoryId = P.categoryId WHERE productName LIKE ?";
}
else if (hasCategoryParam)
{
	filter = "<h3>Products in category: '"+category+"'</h3>";
	sql = "SELECT productId, productName, productPrice, categoryName, authorName FROM Author A JOIN Product P ON A.authorId = P.authorId JOIN Category C ON C.categoryId = P.categoryId WHERE categoryName = ?";
}
else if(hasAuthParam)
{
	filter ="<h3>Products by author: '"+author+"'</h3>";
	sql = "SELECT productId, productName, productPrice, categoryName, authorName FROM Author A JOIN Product P ON A.authorId = P.authorId JOIN Category C ON C.categoryId = P.categoryId WHERE authorName = ?";
}
else
{
	filter = "<h3>All Products</h3>";
	sql = "SELECT productId, productName, productPrice, categoryName, authorName FROM Author A JOIN Product P ON A.authorId = P.authorId JOIN Category C ON C.categoryId = P.categoryId";
}


String sql2 = "SELECT P.productId, productName, productPrice, categoryName, authorName FROM ordersummary OS JOIN orderproduct OP ON OS.orderId = OP.orderId JOIN product P ON P.productId = OP.productId JOIN author A ON A.authorId = P.authorId JOIN category C ON C.categoryId = P.categoryId WHERE customerId = ?";


NumberFormat currFormat = NumberFormat.getCurrencyInstance();

try{
	getConnection();
	Statement stmt2 = con.createStatement(); 			
	stmt2.execute("USE orders");
	
	PreparedStatement pstmt2 = con.prepareStatement(sql2);
	pstmt2.setInt(1, custId);
	ResultSet rst2 = pstmt2.executeQuery();	
	if(rst2.next() == false){
	
	}else{
		do{
	out.println("<h3>Recommended Products</h3>");
	out.print("<font face=\"Century Gothic\" size=\"2\"><table class=\"table\" border=\"1\"><tr><th class=\"col-md-1\"></th><th>Product Name</th>");
	out.println("<th>Category</th><th>Author</th><th>Price</th></tr>");
		int id = rst2.getInt(1);
		out.print("<td class=\"col-md-1\"><a href=\"addcart.jsp?id=" + id + "&name=" + rst2.getString(2)
				+ "&price=" + rst2.getDouble(3) + "\">Add to Cart</a></td>");

		String itemCategory = rst2.getString(4);
		String authorCat = rst2.getString(5);
		String color = (String) colors.get(itemCategory);
		if (color == null)
			color = "#FFFFFF";

		out.println("<td><a href=\"product.jsp?id="+id+"\"<font color=\"" + color + "\">" + rst2.getString(2) + "</font></td>"
				+ "<td><font color=\"" + color + "\">" + itemCategory + "</font></td>"
				+"<td><font color=\"" + color + "\">" + authorCat + "</font></td>"
				+ "<td><font color=\"" + color + "\">" + currFormat.format(rst2.getDouble(3))
				+ "</font></td></tr>");
		}while(rst2.next());
	
	
	
}
out.println("</table></font>");
	Statement stmt = con.createStatement(); 			
	stmt.execute("USE orders");
	PreparedStatement pstmt = con.prepareStatement(sql);
		if (hasNameParam)
	{
		pstmt.setString(1, name);	
		if (hasCategoryParam)
		{
			pstmt.setString(2, category);
			if(hasAuthParam)
			{
				pstmt.setString(3, author);
			}
			
		}
		else if(hasAuthParam)
		{
			pstmt.setString(2, author);
		}
	}
	else if (hasCategoryParam)
	{
		pstmt.setString(1, category);
		if(hasAuthParam)
		{
			pstmt.setString(2, author);
		}

	}
	else if (hasAuthParam)
	{
		pstmt.setString(1, author);
	}
	ResultSet rst = pstmt.executeQuery();
	
	
	out.println(filter);
	out.print("<font face=\"Century Gothic\" size=\"2\"><table class=\"table\" border=\"1\"><tr><th class=\"col-md-1\"></th><th>Product Name</th>");
	out.println("<th>Category</th><th>Author</th><th>Price</th></tr>");
	while (rst.next()) 
	{
		int id = rst.getInt(1);
		out.print("<td class=\"col-md-1\"><a href=\"addcart.jsp?id=" + id + "&name=" + rst.getString(2)
				+ "&price=" + rst.getDouble(3) + "\">Add to Cart</a></td>");

		String itemCategory = rst.getString(4);
		String authorCat = rst.getString(5);
		String color = (String) colors.get(itemCategory);
		if (color == null)
			color = "#FFFFFF";

		out.println("<td><a href=\"product.jsp?id="+id+"\"<font color=\"" + color + "\">" + rst.getString(2) + "</font></td>"
				+ "<td><font color=\"" + color + "\">" + itemCategory + "</font></td>"
				+"<td><font color=\"" + color + "\">" + authorCat + "</font></td>"
				+ "<td><font color=\"" + color + "\">" + currFormat.format(rst.getDouble(3))
				+ "</font></td></tr>");
	}
	out.println("</table></font>");
	closeConnection();
}
catch(SQLException ex){
	out.println(ex);
}




%>

</body>
</html>
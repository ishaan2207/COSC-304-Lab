<%
	boolean c = (Boolean) session.getAttribute("check");

    String id = request.getParameter("id"); 
    String name = request.getParameter("name");
    String price = request.getParameter("price");
    String image = request.getParameter("image");

	if (c)
	{
		String loginMessage = "You have already left a review for this product";      
		response.sendRedirect("product.jsp?id=" + id + "&name=" + name + "&price=" + price + "&image=" + image);
	}
%>
<%@ page language="java" import="java.io.*,java.sql.*"%>
<%@ include file="jdbc.jsp" %>

<%

boolean move = false;
session = request.getSession(true);
int id = Integer.valueOf((String)request.getParameter("id"));  
String name = request.getParameter("name");
String price = request.getParameter("price");
String image = request.getParameter("image");


try {
    move = checkReview(out, request, session);
} catch (Exception e){
    System.err.println(e);
}

if(move)
    response.sendRedirect("review.jsp?id=" + id);
else
    response.sendRedirect("product.jsp?id=" + productId + "&name=" + productName1 + "&price=" + productPrice + "&image=" + productImage);

%>

<%!

boolean checkReview(JspWriter out, HttpServletRequest request, HttpSession session) throws IOException{
    int id = Integer.valueOf((String)request.getParameter("id"));  
    String username = (String) session.getAttribute("authenticatedUser");
    String customerId;
    boolean check = false;

    try{
        getConnectionForOrders();

        String custid = "SELECT customerId FROM customer WHERE userid = ?";
        PreparedStatement pstmt = con.prepareStatement(custid);
        pstmt.setString(1, username);
        ResultSet rs = pstmt.executeQuery();
        int customerId = 0;
        while(rs.next()){
         customerId = rs.getInt("customerId");
 
        }

        String sql = "SELECT COUNT(*) AS all FROM review WHERE customerId = ? AND productId = ?";
        PreparedStatement p = con.prepareStatement(sql);
        p.setInt(1, customerId);
        p.setInt(2, id);
        ResultSet r = p.executeQuery();

        if(next()){
            check = true; //there is a review already
        } else check = false; //no review

        session.setAttribute("check", check);

        return check;
    }


}

%>
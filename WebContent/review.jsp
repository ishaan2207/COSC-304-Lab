<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.LocalDateTime" %>

<html>
<head>
<title>Supercool Bookstore - Leave a Review</title>

<link href="css/star.css" rel="starFormat">
</head>
<body>
<%@ include file="header.jsp" %>

<%
    session = request.getSession(true);
    String userName = (String) session.getAttribute("authenticatedUser");
%>

<br>
    <h2>Star Rating</h2>
     <div class="rate">
    <input type="radio" id="star5" name="rate" value="5" />
    <label for="star5" title="text">5 stars</label>
    <input type="radio" id="star4" name="rate" value="4" />
    <label for="star4" title="text">4 stars</label>
    <input type="radio" id="star3" name="rate" value="3" />
    <label for="star3" title="text">3 stars</label>
    <input type="radio" id="star2" name="rate" value="2" />
    <label for="star2" title="text">2 stars</label>
    <input type="radio" id="star1" name="rate" value="1" />
    <label for="star1" title="text">1 star</label>
  </div>

<form name="MyForm" method=post action="validateLogin.jsp">
<br>
<div align="left"><font face="Arial, Helvetica, sans-serif" size="4"> Comment:</font></div></td>
<input type="Content" name="comment" size=100 maxlength="1000"></td>

<br/>
<br/>
<input class="submit" type="submit" name="SubmitReview" value="Submit Review">
</form>
</div>
<%
try {
int rating = 0;

out.println(request.getParameter("star" + 1));

for(int i = 1; i < 6; i++){
    if(request.getParameter("star" + i)){
        rating = i;
    }
}

String rComment = request.getParameter("comment");

String sql = "SELECT reviewId FROM review";
PreparedStatement f = con.prepareStatement(sql);
ResultSet r = f.executeQuery();

int id = 0;

while(r.next()){
    int temp = r.getInt("reviewId");
    if (temp < id){
        id = temp++;
    }
}

 LocalDateTime now = LocalDateTime.now();  

String custid = "SELECT customerId FROM customer WHERE userid = ?";
PreparedStatement pstmt = con.prepareStatement(custid);
pstmt.setString(1, userName);
ResultSet rs = pstmt.executeQuery();
int customerId;

while(rs.next()){
    customerId = rs.getInt("customerId");
}

int prodId = (int)request.getAttribute("id");


} catch (Exception e)
{
    out.println(e);
}



%>
</body>
</html>


<%@ page import="utils.StringUtils" %>
<%@ page import="controller.database.DatabaseController" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.RegisterModel" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String contextPath = request.getContextPath();
	DatabaseController dbController = new DatabaseController();
	String cookieUsername = null;
	Cookie[] cookies = request.getCookies();
	if(cookies != null){
		for(Cookie cookie: cookies){
			if(cookie.getName().equals(StringUtils.USER)){
				cookieUsername = cookie.getValue();
			}
		}
	}
	
	RegisterModel user = (RegisterModel) dbController.getAllUserInfo(cookieUsername);
	String userFullName = user.getFirstName()+" "+user.getLastName();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Profile | E-commerce Website</title>
    <link rel="stylesheet" href="<%=contextPath%>/stylesheets/OrderHistory.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"/>
    <style>
	    .table-data{
		    width: 80%;
		    margin: 80px auto;
		    overflow-y: auto;
		    background: #fff;
		    border-radius: 8px;
		}
    
    </style>
</head>
<body>

<!-- Side Menu Bar  -->
<section id="menu">
    <div class="logo">
        <h2><%= userFullName %></h2>
    </div>
    <div class="menu-links">
        <ul>
            <li>
            	<a href="<%=contextPath%>/pages/MyProfile.jsp"><i class="fa-solid fa-user-tie"></i>Basic Information</a>
         	</li>
         	<li>
             	<a href="<%=contextPath%>/pages/UserPassword.jsp"><i class="fa-solid fa-key"></i>Password</a>
         	</li>
         	<li>
				<a href="<%=contextPath%>/pages/OrderHistory.jsp"><i class="fas fa-dollar-sign"></i>Order History</a>
			</li>
            <hr class="underline">
            <li class="logout">
                <form action="<%=contextPath%>/logoutUser" method="post" class="user-links" id="form">
                    <i class="fa-solid fa-right-from-bracket"></i>
                    <input type="submit" value="Log out" class="logout-btn">
                </form>
            </li>
        </ul>
    </div>
</section>
    
<!-- Body Content -->
<section id="body-content">
    <div class="nav-section">
        <div class="profile">
            <%if(user.getImageUrlFromPart() != null && !user.getImageUrlFromPart().isEmpty()){ %>
           		<img src="<%=contextPath%>/resources/user/<%= user.getImageUrlFromPart()%>" alt="user-pic" class="user-pic">
           	<% } else {%>                 
         		<img src="<%=contextPath%>/images/user.png" alt="user-pic" class="user-pic">
           	<% } %>
        </div>
    </div>
    <div class="table-data">
        <h3 class="table-title">Orders History</h3>
        <table width="100%">
            <thead>
                <tr>
                    <td>Order ID</td>
                    <td>Order Date</td>
                    <td>Customer Name</td>
                    <td>Product Name</td>
                    <td>Total Amount</td>
                    <td>Payment Method</td>
                    <td>Order Status</td>
                </tr>
            </thead>
            <tbody>
            	<% 
		            ResultSet rs = dbController.getOrderHistroy(cookieUsername);
		            while (rs.next()) {
		        %>
                <tr>
                    <td class="order-id">
                        <h5><%= rs.getInt("OrderID") %></h5>
                    </td>
                    <td class="order-date">
                        <h5><%= rs.getDate("Order_Date").toLocalDate() %></h5>
                    </td>
                    <td class="customer-name">
                        <h5><%= rs.getString("First_Name") %><%=" "%><%= rs.getString("Last_Name") %></h5>
                    </td>
                    <td class="product-name">
                    	<h5><%= rs.getString("Product_Name") %></h5>
                    </td>
                    <td class="total-amount">
                        <h5><%= rs.getBigDecimal("Grand_Total_Amount").doubleValue() %></h5>
                    </td>
                    <td class="payment-type">
                        <h5><%= rs.getString("Payment_Type") %></h5>
                    </td>
                    <td class="status">
                        <h5><%= rs.getString("Order_Status") %></h5>
                    </td>
                </tr>
                <%} %>
            </tbody>
        </table>
    </div>
</section>
</body>
</html>

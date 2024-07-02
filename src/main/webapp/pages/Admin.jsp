<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="controller.database.DatabaseController" %>
<%@ page import="utils.StringUtils" %>
<%@ page import="model.RegisterModel" %>
<%@ page import="java.sql.ResultSet" %>
<%
	String contextPath = request.getContextPath();
	DatabaseController dbController = new DatabaseController();
	int totalUsers = dbController.getAllUser();
	int totalProducts = dbController.getTotalProducts();
	double totalRevenue = dbController.getTotalRevenue();
	int newOrders = dbController.getNewOrders();
	
	String cookieUsername = null;
	Cookie[] cookies = request.getCookies();
	if(cookies != null){
		for(Cookie cookie: cookies){
			if(cookie.getName().equals(StringUtils.USER)){
				cookieUsername = cookie.getValue();
				break;
			}
			if(cookie.getName().equals(StringUtils.ADMIN)){
				cookieUsername = cookie.getValue();
				break;
			}
		}
	}
	RegisterModel user = new RegisterModel();
	if(cookieUsername != null && !cookieUsername.equals("bikash200@gmail.com")){
		user = (RegisterModel) dbController.getAllUserInfo(cookieUsername);
	}
	
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Panel | E-commerce Website</title>
    <link rel="stylesheet" href="<%=contextPath%>/stylesheets/Admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"/>
    <style>
    .message-container {
	    position: absolute;
	    top: 0;
	    left: 50%;
	    transform: translate(-50%, -50%);
	    display: flex; 
	    align-items: center; 
	    justify-content: space-between;
	    width: 400px;
	    text-align: center;
	    padding: 10px 15px;
	    border-radius: 5px;
	    margin-top: 30px;
	}
	.message-container.error {
	    background-color: #ff6347;
	    border: 1px solid #f5c6cb;
	    color: white;
	}
	
	.message-container.success {
	    background-color: #d4edda;
	    border: 1px solid #c3e6cb;
	    color: #155724;
	}
	.message-container p {
	    margin-right: 20px;
	}
	.close-btn {
	    cursor: pointer;
	    font-size: 16px;
	    margin-left: 10px; 
	}
	
	.close-btn:hover {
	    font-size: 20px;
	}
	.change-btn{
		border-radius: 40px; 
		padding: 5px 10px; 
		width: 100px; 
		background: #007bff;
	}
    </style>
<body>
    
<!-- Side Menu Bar  -->
<section id="menu">
    <div class="logo">
        <img src="<%=contextPath%>/images/logo.png" alt="logo">
        <h2>Makshad</h2>
    </div>
    <div class="menu-links">
        <div class="item">
            <a href="#"><i class="fa-solid fa-gauge"></i>Dashboard</a>
        </div>
        <div class="item">
            <a href="#" class="sub-links"><i class="fas fa-shopping-bag"></i>Product<i class="fas fa-angle-right dropdown"></i></a>
            <div class="sub-menu">
            	<% if(cookieUsername != null && cookieUsername.equals("bikash200@gmail.com")) { %>
           	 		<a href="<%=contextPath%>/pages/AddProduct.jsp" class="sub-btn">Add New Product</a>
        		<% } %>
       			<a href="<%=contextPath%>/pages/ViewProduct.jsp" class="sub-btn">View Product</a>
            </div>
        </div>
        <div class="item">
            <a href="<%=contextPath%>/pages/UserManagement.jsp"><i class="fa-solid fa-users"></i>User Management</a>
        </div>
        <hr>
        <div class="item logout">
            <form action="<%=contextPath%>/logoutUser" method="post">
                <i class="fa-solid fa-right-from-bracket "></i>
                <input type="submit" value="Log Out" class="logout-btn">
            </form>
        </div>
    </div>
</section>

<!-- Body Section -->
<section id="body-content">
    <div class="nav-section">
        <div class="profile">
            <i class="fa-solid fa-bell"></i>
            <%if(cookieUsername != null && !cookieUsername.equals("bikash200@gmail.com")) {%>
            	<%if(user.getImageUrlFromPart() != null && !user.getImageUrlFromPart().isEmpty()){ %>
               		<img src="<%=contextPath%>/resources/user/<%= user.getImageUrlFromPart()%>" alt="user-pic">
               	<% } else {%>                 
            		<img src="<%=contextPath%>/images/user.png" alt="user-pic">
              	<% } %>
            <% } else { %>
        		<img src="<%=contextPath%>/images/user.png" alt="admin-pic">
            <% } %>
        </div>
        <% String errorMessage = (String) request.getAttribute(StringUtils.ERROR_MESSAGE);
		if (errorMessage != null && !errorMessage.isEmpty()) {%>
		    <div class="message-container error">
		        <p><%= errorMessage %></p>
		        <span class="close-btn" onclick="hideMessage(this)"><i class="fa-solid fa-x"></i></span>
		    </div>
		<%}%>
		
		<% String successMessage = (String) request.getAttribute(StringUtils.SUCCESS_MESSAGE);
		if (successMessage != null && !successMessage.isEmpty()) {%>
		    <div class="message-container success">
		        <p><%= successMessage %></p>
		        <span class="close-btn" onclick="hideMessage(this)"><i class="fa-solid fa-check"></i></span>
		    </div>
		<%}%>   
    </div>

    <h3 class="title">Dashboard</h3>
    
    <div class="box">

        <!-- Users Section -->
        <div class="box-content">
            <i class="fa-solid fa-users"></i>
            <div class="text">
                <h3><%= totalUsers%></h3>
                <span>Total Users</span>
            </div>
        </div>

        <!-- Orders Section -->
        <div class="box-content">
            <i class="fa-solid fa-cart-shopping"></i>
            <div class="text">
                <h3><%= newOrders %></h3>
                <span>Total Orders</span>
            </div>
        </div>

        <!-- Sales Section -->
        <div class="box-content">
            <i class="fa-solid fa-dollar-sign"></i>
            <div class="text">
                <h3><%= totalRevenue%></h3>
                <span>Total Sales</span>
            </div>
        </div>

        <!-- Prodcuts Section -->
        <div class="box-content">
            <i class="fas fa-shopping-bag"></i>
            <div class="text">
                <h3><%= totalProducts %></h3>
                <span>Total Products</span>
            </div>
        </div> 

        <!-- Feedback Section -->
        <div class="box-content">
            <i class="fa-solid fa-comment"></i>
            <div class="text">
                <h3>1,000</h3>
                <span>Feedback</span>
            </div>
        </div>                
    </div>

    <!-- Recent Orders Section -->
    
    <div class="table-data">
        <h3 class="table-title">Total Orders</h3>
        <table width="100%">
            <thead>
                <tr>
                    <td>Order ID</td>
                    <td>Customer Name</td>
                    <td>Discount Amount</td>
                    <td>Total Amount</td>
                    <td>Order Date</td>
                    <td>Order Status</td>
                </tr>
            </thead>
            <tbody>
            	<% 
		            ResultSet rs = dbController.getTotalOrders();
		            while (rs.next()) {
		        %>
                <tr>
                    <td class="order-id">
                        <%= rs.getString("OrderID") %>
                    </td>
                    <td class="customer-name">
                        <%= rs.getString("First_Name") %> <%= rs.getString("Last_Name") %>
                    </td>
                    <td class="discount-amount">
                        <%= rs.getString("Discount_Amount") %>
                    </td>
                    <td class="total-amount">
                        <%= rs.getString("Grand_Total_Amount") %>
                    </td>
                    <td class="order-date">
                        <%= rs.getString("Order_Date") %>
                    </td>
                    <td class="delivered">
                        <p class="delivered-text"><%= rs.getString("Order_Status") %></p>
                        <form action="<%=contextPath%>/updateOrderStatus" method="post"class="change-form">
                        	<input type="hidden" name="orderID" value="<%= rs.getString("OrderID") %>">
                            <select name="change-status" id="change-status" style="display: none;">
                                <option value="Pending">Pending</option>
                                <option value="Processing">Processing</option>
                                <option value="Cancelled">Cancelled</option>
                                <option value="Delivered">Delivered</option>
                            </select>
                            <% if(cookieUsername != null && cookieUsername.equals("bikash200@gmail.com")) {%>
	                            <button type="button" class="change-btn">Change</button>
	                            <button type="submit" class="save-btn" style="display: none;">Save</button>
                            <%} %>
                        </form>
                    </td>
                </tr>
                <%} %>
            </tbody>
        </table>
    </div>
</section>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        var subLinks = document.querySelectorAll('.sub-links');
            subLinks.forEach(function(subLink) {
            subLink.addEventListener('click', function() {
                var subMenu = this.nextElementSibling;
                    if (subMenu.style.maxHeight) {
                    subMenu.style.maxHeight = null;
                } else {
                    subMenu.style.maxHeight = subMenu.scrollHeight + "px";
                }
            });
        });
    });

    document.addEventListener("DOMContentLoaded", function() {
        var changeBtns = document.querySelectorAll(".change-btn");
        var saveBtns = document.querySelectorAll(".save-btn");
        var deliveredTexts = document.querySelectorAll(".delivered .delivered-text");
        var statusSelects = document.querySelectorAll("#change-status");

        changeBtns.forEach(function(changeBtn, index) {
            changeBtn.addEventListener("click", function(event) {
                changeBtn.style.display = "none";
                saveBtns[index].style.display = "inline-block";
                deliveredTexts[index].style.display = "none";
                statusSelects[index].style.display = "inline-block";

                var currentStatus = deliveredTexts[index].textContent.trim();

                Array.from(statusSelects[index].options).forEach(function(option) {
                    if (option.value === currentStatus) {
                        option.selected = true;
                    }
                });

                event.preventDefault();
            });
        });
    });
    
    function hideMessage(element) {
	    element.parentNode.style.display = "none";
	}
</script>

    
</body>
</html>
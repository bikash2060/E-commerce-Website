<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="controller.database.DatabaseController" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.ProductModel" %>
<%@ page import="model.RegisterModel" %>
<%@ page import="utils.StringUtils" %>
<%
	DatabaseController dbController = new DatabaseController();
	String contextPath = request.getContextPath();
	ArrayList<ProductModel> products = dbController.getAllProductInfo();
	
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
	if(!cookieUsername.equals("bikash200@gmail.com")){
		user = (RegisterModel) dbController.getAllUserInfo(cookieUsername);
	}

%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Panel | E-commerce Website</title>
    <link rel="stylesheet" href="<%=contextPath%>/stylesheets/ViewProduct.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"/>
    <style>
    	.message-container {
		    position: absolute;
		    top: 12%;
		    left: 50%;
		    transform: translate(-50%, -50%);
		    display: flex; 
		    align-items: center; 
		    justify-content: space-between;
		    width: 300px;
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
            <a href="<%=contextPath%>/pages/Admin.jsp"><i class="fa-solid fa-gauge"></i>Dashboard</a>
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
    </div>

    <h3 class="title">Total Products</h3>
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
    <div class="product-table">
        <table class="table" id="cart-table">
            <thead>
                <tr>
                    <td class="image">Image</td>
                    <td class="name">Product Name</td>
                    <td class="price">Price</td>
                    <td class="quantity">Quantity</td>
                    <td class="brand">Brand</td>
                    <% if(cookieUsername != null && cookieUsername.equals("bikash200@gmail.com")) {%>
                    <td class="delete"></td>
                   	<%} %>
                </tr>
            </thead>
            <tbody>
            <% for(ProductModel product: products){ %>
                <tr>
                    <td class="image">
                        <img src="<%=contextPath%>/resources/product/<%= product.getImageUrlFromPart()%>">
                    </td>
                    <td class="name">
                        <p><%= product.getProductName() %></p>
                    </td>
                    <td class="price">
                        <p><%= product.getUnitPrice() %></p>
                    </td>
                    <td class="quantity">
                        <p><%= product.getStockQuantity() %></p>
                    </td>
                    <td class="brand">
                        <p><%=  product.getBrandName()%></p>
                    </td>
                    <% if(cookieUsername != null && cookieUsername.equals("bikash200@gmail.com")) {%>
	                    <td class="delete">
	                        <form action="<%=contextPath%>/productDetails" method="get" class="delete-form">
	                       		<input type="hidden" name="productId" value="<%= product.getProductID()%>">
	                       		<input type="hidden" name="productName" value="<%= product.getProductName() %>">
	                    		<input type="hidden" name="unitPrice" value="<%= product.getUnitPrice() %>">
	                    		<input type="hidden" name="quantity" value="<%= product.getStockQuantity() %>">
	                    		<input type="hidden" name="brand" value="<%= product.getBrandName() %>">
	                    		<input type="hidden" name="description" value= "<%= product.getDescription() %>">
	                    		<input type="hidden" name="productImage" value="<%= product.getImageUrlFromPart()%>">
	                            <button type="submit" class="edit-btn">Edit</button>
	                        </form>
	                        <form action="<%=contextPath%>/removeItems" method="post" class="delete-form">
	                       		<input type="hidden" name="productId" value="<%= product.getProductID()%>">
	                            <button type="submit" class="delete-btn">Delete</button>
	                        </form>
	                    </td>
	                  <%} %>
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
    function hideMessage(element) {
	    element.parentNode.style.display = "none";
	}
</script>
</body>
</html>
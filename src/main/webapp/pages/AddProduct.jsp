<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="utils.StringUtils" %>

<%
	String contextPath = request.getContextPath();
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
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Panel | E-commerce Website</title>
    <link rel="stylesheet" href="<%=contextPath%>/stylesheets/AddProduct.css">
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
                <a href="<%=contextPath%>/pages/AddProduct.jsp" class="sub-btn">Add New Product</a>
                <a href="<%=contextPath%>/pages/ViewProduct.jsp" class="sub-btn">View Product</a>
            </div>
        </div>
        <div class="item">
            <a href="<%=contextPath%>/pages/UserManagement.jsp"><i class="fa-solid fa-users"></i></i>User Management</a>
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
            <img src="<%= contextPath%>/images/user.png" alt="admin-pic">
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
    <form action="<%=contextPath%>/addNewProduct" method="post" id="product-form" enctype="multipart/form-data">
        <h3 class="title">Add New Product</h3>	
        <div class="form-group">
		    <label for="product-name">Product Name:</label>
		    <input type="text" id="product-name" name="product-name" value="<%= (request.getParameter("product-name") != null) ? request.getParameter("product-name") : "" %>">
		</div>
		<div class="form-group">
		    <label for="description">Description:</label>
		    <textarea id="description" name="description"><%= (request.getParameter("description") != null) ? request.getParameter("description") : "" %></textarea>
		</div>
		<div class="form-group">
		    <label for="unit-price">Unit Price:</label>
		    <input type="number" id="unit-price" name="unit-price" value="<%= (request.getParameter("unit-price") != null) ? request.getParameter("unit-price") : "" %>">
		</div>
		<div class="form-group">
		    <label for="quantity">Quantity:</label>
		    <input type="number" id="quantity" name="quantity" value="<%= (request.getParameter("quantity") != null) ? request.getParameter("quantity") : "" %>">
		</div>
		<div class="form-group">
		    <label for="category">Category:</label>
		    <select id="category" name="category">
		        <option value="IOS" <%= (request.getParameter("category") != null && request.getParameter("category").equals("IOS")) ? "selected" : "" %>>IOS</option>
		        <option value="Android" <%= (request.getParameter("category") != null && request.getParameter("category").equals("Android")) ? "selected" : "" %>>Android</option>
		    </select>
		</div>
		<div class="form-group">
		    <label for="images">Images:</label>
		    <input type="file" id="images" name="image" multiple accept="image/*">
		</div>
		<div class="form-group">
		    <label for="brand">Brand:</label>
		    <select id="brand" name="brand">
		        <option value="Apple" <%= (request.getParameter("brand") != null && request.getParameter("brand").equals("Apple")) ? "selected" : "" %>>Apple</option>
		        <option value="Android" <%= (request.getParameter("brand") != null && request.getParameter("brand").equals("Android")) ? "selected" : "" %>>Android</option>
		        <option value="Redmi" <%= (request.getParameter("brand") != null && request.getParameter("brand").equals("Redmi")) ? "selected" : "" %>>Redmi</option>
		        <option value="Asus" <%= (request.getParameter("brand") != null && request.getParameter("brand").equals("Asus")) ? "selected" : "" %>>Asus</option>
		        <option value="Samsung" <%= (request.getParameter("brand") != null && request.getParameter("brand").equals("Samsung")) ? "selected" : "" %>>Samsung</option>
		        <option value="Oneplus" <%= (request.getParameter("brand") != null && request.getParameter("brand").equals("Oneplus")) ? "selected" : "" %>>OnePlus</option>
    		</select>
		</div>
        <button type="submit">Add Product</button>
    </form>
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
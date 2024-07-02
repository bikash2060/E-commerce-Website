<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="model.ProductModel" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="utils.StringUtils" %>

<%
    String contextPath = request.getContextPath();
	ProductModel products = (ProductModel) session.getAttribute("productInfo");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Panel | E-commerce Website</title>
    <link rel="stylesheet" href="<%=contextPath%>/stylesheets/ProductDetails.css">
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
    </style>
</head>
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
            <img src="<%=contextPath%>/images/user.png" alt="admin-pic">
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
    
    <div class="product-details">
        <h3 class="title">Product Details</h3>
        <form action="<%= contextPath%>/updateProduct" method="post" enctype="multipart/form-data" id="form">
    		<div class="row">
		        <div id="product">
		            <img src="<%= contextPath %>/resources/product/<%= products.getImageUrlFromPart() %>" class="product-pic" style="width: 80px; height: 80px; object-fit: cover; border-radius: none; background: none;">
		            <input type="file" name="image" id="image">
		            <input type="hidden" name="category" value="<%= products.getCategoryID() %>">
		            <label for="image" id="upload-btn"><i class="fa-solid fa-camera" style="margin-top: 65px; margin-left: 10px;"></i></label>
		        </div>
    		</div>
		    <div class="row">
		        <label for="product-name">Product Name:</label>
		        <input type="hidden" name="productID" value="<%= products.getProductID() %>">
		        <input type="text" id="product-name" name="product-name" value="<%= (request.getParameter("product-name") != null) ? request.getParameter("product-name") : products.getProductName() %>">
		    </div>
		    <div class="row">
		        <label for="product-description">Product Description:</label>
		        <textarea id="product-description" name="product-description" style="line-height: 1.5; height: 150px;"><%= (request.getParameter("product-description") != null) ? request.getParameter("product-description") : products.getDescription() %></textarea>
		    </div>
		    <div class="row">
		        <label for="stock-quantity">Stock Quantity:</label>
		        <input type="number" id="stock-quantity" name="stock-quantity" value="<%= (request.getParameter("stock-quantity") != null) ? request.getParameter("stock-quantity") : products.getStockQuantity() %>">
		    </div>
		    <div class="row">
		        <label for="price">Price:</label>
		        <input type="number" id="price" name="price" value="<%= (request.getParameter("price") != null) ? request.getParameter("price") : products.getUnitPrice() %>">
		    </div>
		    <div class="row">
		        <label for="brand">Brand:</label>
		        <input type="text" id="brand" name="brand" value="<%= (request.getParameter("brand") != null) ? request.getParameter("brand") : products.getBrandName() %>" readonly>
		    </div>
		    <div class="row">
		        <button type="submit">Save Changes</button>
		    </div>
		</form>

    </div>text
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

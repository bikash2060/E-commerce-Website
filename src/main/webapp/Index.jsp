<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="javax.servlet.http.HttpServletRequest"%>
<%@ page import="utils.StringUtils" %>
<%@ page import="controller.database.DatabaseController" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.RegisterModel" %>
<%@ page import="model.ProductModel" %>
<%@ page import="model.CartProductModel" %>
<%@ page import="java.util.Random" %>
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
	
	ArrayList<CartProductModel> cartItems = dbController.getCartItems(cookieUsername);
	int cartItemCount = cartItems.size();
	
	Map<String, List<ProductModel>> productsMap = dbController.getAllProducts();
    List<ProductModel> firstEightProducts = productsMap.get("firstEight");
    List<ProductModel> remainingProducts = productsMap.get("remaining");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Home | E-commerce Website</title>
    <link rel="stylesheet" href="<%=contextPath%>/stylesheets/Index.css">
    <link rel="stylesheet" href="<%=contextPath%>/stylesheets/Footer.css">
    <link rel="stylesheet" href="<%=contextPath%>/stylesheets/Header.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"/>
	<style>
        .side-links .cart-count {
            position: absolute;
            font-size: 12px;
            top: 19%;
            right: 4%;
            background-color: #28a745; 
   			color: white;
            border-radius: 50%;
            padding: 3px 5px;
        }
        .product .btn{
			background: #8bc34a;
			cursor: pointer;
		    text-decoration: none;
		    color: black;
		    padding: 5px 10px;
		    border: none;
		    border-radius: 25px;
		    transition: 0.3s;
		}
		.product .btn:hover{
		    color: white;
		    background: #4caf50;
		}
		.product .row-1 .col-1 img{
		    width: 150px;
		    height: 150px;
		    object-fit: contain;
		    display: block;
		    margin: auto;
		}
		.product-section .product .row-1{
		    margin-top: 30px;
		    margin-bottom: 30px;
		    display: flex;
		    align-items: center;
		}
		.product-section .product .row-1 .col-1{
		    flex-basis: 25%;
		    width: 400px;
		    background-color: #f7f8f9;
		    margin-right: 20px;
		    padding: 20px;
		    box-shadow: 5px 5px 5px -5px rgba(0,0,0,.2);
		    border: solid #fff 10px;
		    transition: 0.6s;
		}
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
		form .logout-btn{
			text-decoration: none;
		    color: black;
		    transition: 0.3s;
		    font-size: 14px;
		    border: none;
		    outline: none;
		    background: none;
		    cursor: pointer;
		}
		form .logout-btn:hover{
		    color: rgb(63, 38, 14);
		    text-decoration: underline;
		}
    	</style>

</head>
<body>

<!-- Header Section -->
<div class="navbar-section">
    <div class="container">
        <nav>
            <div class="logo-section">
                <a href="<%=contextPath%>/Index.jsp">
                    <img src="<%=contextPath%>/images/logo.png" alt="logo" class="logo">
                </a>
            </div>
            <div class="nav-links">
                <ul>
                    <li><a href="<%=contextPath%>/Index.jsp" class="current">HOME</a></li>
                    <li><a href="<%=contextPath %>/pages/Shop.jsp">SHOP</a></li>
                    <li><a href="<%=contextPath%>/pages/Contact.jsp">CONTACT</a></li>
                </ul>
            </div>
            <div class="side-links">
            	<%if (cookieUsername != null && !cookieUsername.isEmpty()) { %>
                	<a href="<%=contextPath%>/pages/Cart.jsp"><i class="fa-solid fa-cart-shopping"></i></a>
               		<span class="cart-count"><%=cartItemCount%></span>
                <%} else { %>
                	<a href="<%=contextPath%>/pages/Login.jsp"><i class="fa-solid fa-cart-shopping"></i></a>
                <%} %>
                 <%if (cookieUsername != null && !cookieUsername.isEmpty()){ %>
                 	<%if(user.getImageUrlFromPart() != null && !user.getImageUrlFromPart().isEmpty()){ %>
                 		<img src="<%=contextPath%>/resources/user/<%= user.getImageUrlFromPart()%>" alt="user-pic" class="user-pic" onclick="toggleMenu()">
                 	<% } else {%>                 
	             		<img src="<%=contextPath%>/images/user.png" alt="user-pic" class="user-pic" onclick="toggleMenu()">
                	<% } %>
                <%} else { %>
                	<i class="fa-solid fa-user" onclick="toggleMenu()"></i>
                <%}%>
            </div>

            <div class="dropdown-menu-links" id="dropdown-menu-links">           
                <div class="dropdown-menu">
                <%if (cookieUsername != null && !cookieUsername.isEmpty()){%>
                    <div class="user-info"> 
                    <%if(user.getImageUrlFromPart() != null && !user.getImageUrlFromPart().isEmpty()){ %>
               			<img src="<%=contextPath%>/resources/user/<%= user.getImageUrlFromPart()%>" alt="user-pic" class="user-pic" onclick="toggleMenu()">
               		<% } else {%>                 
             			<img src="<%=contextPath%>/images/user.png" alt="user-pic" class="user-pic" onclick="toggleMenu()">
               		<% } %>                      
                    <h3><%= userFullName %></h3>
                    </div>
                    <hr>

                    <a href="<%=contextPath%>/pages/MyProfile.jsp" class="user-links" target="_blank">
                        <i class="fa-solid fa-user"></i>    
                        <p>My Profile</p>
                        <span>></span>                    
                    </a>
                    <form action="<%=contextPath%>/logoutUser" method="post" class="user-links" id="form">
                        <i class="fa-solid fa-right-from-bracket"></i>
                        <input type="submit" value="Log out">
                        <span>></span>
                    </form>
               	<%} else { %>
                    <a href="<%=contextPath%>/pages/Login.jsp" class="user-links">
                        <i class="fa-solid fa-right-from-bracket"></i>    
                        <p>Log in</p>
                        <span>></span>                    
                    </a>
                    
                    <a href="<%=contextPath%>/pages/Register.jsp" class="user-links">
                        <i class="fa-solid fa-right-from-bracket"></i>    
                        <p>Sign up</p>
                        <span>></span>                    
                    </a>
				<% } %>                 
                </div>
            </div>
        </nav>
    </div>
</div>

<!-- Body Section -->
 <div class="body-content">
    <div class="container">
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
        <div class="text-content">
            <div class="text">
                <p class="text-1">Sale 20% Off<br>On Everything</p>
                <p class="text-2"> With competitive prices and reliable brands, find the perfect<br> smartphone to match your lifestyle and needs, all in one <br>convenient place.</p>
            </div>
            <div class="button">
                <a href="<%=contextPath%>/pages/Shop.jsp">Shop Now →</a>
            </div>
        </div>
        <div class="background-image">
            <img src="<%=contextPath%>/images/Iphone 11.png" alt="Background Image">
        </div>
    </div>
</div>

<!-- Mid-body Section -->
<div class="mid-body-content">
    <div class="container">
        <div class="text">
            <p>Reason To Choose Us</p>
            <p style="border: 2px solid red; width: 200px; margin-left: 500px; margin-top: 3px;"></p>
        </div>
        <div class="boxes">
            <div class="box-1">
                <p class="icon"><span>🚚</span></p>
                <p class="main-text">Fast Delivery</p>
                <p class="body-text">Experience lightning fast delivery to your doorstep, guaranteed.</p>
            </div>
            <div class="box-2">
                <p class="icon"><span>🆓</span></p>
                <p class="main-text">Free Shipping</p>
                <p class="body-text">Enjoy complimentary shipping on all orders.</p>
            </div>
            <div class="box-3">
                <p class="icon"><span>🎖️</span></p>
                <p class="main-text">Top Branded</p>
                <p class="body-text">Discover our selection of top-branded products.</p>
            </div>
        </div>
    </div>
</div>

<!-- Offer Section -->
<div class="offer-section">
    <div class="container">
        <div class="image">
            <img src="<%=contextPath%>/images/S24 Ultra.png" alt="S24 ultra">
        </div>
        <div class="text">
            <p class="text-1">#Product of the Year</p>
            <h1 class="heading-1">Samsung Galaxy S24 Ultra</h1>
            <p class="description">The S24 Ultra pushes the boundaries of smartphone innovation with its cutting-edge features and unparralled performance. With its sleek design, advanced capabilities, and intuitive user experience, it redefines what's possible in the world of smartphones.</p>
        </div>
    </div>
</div>

<!-- Main Products Section -->
<div class="product-section">
    <div class="container">
        <div class="text">
            <p>Our Featured Products</p>
            <p style="border: 2px solid red; width: 150px; margin-left: 520px;"></p>
        </div>
        <div class="product">
            <div class="row-1">
    			<%
    				int productCount = 0;
    				if (firstEightProducts != null) {
        				for (ProductModel product : firstEightProducts) {
            				if (productCount % 4 == 0 && productCount != 0) { %>
                				</div><div class="row-1">
            				<% }%>
            <div class="col-1">
                <img src="<%=contextPath%>/resources/product/<%= product.getImageUrlFromPart()%>" alt="product-image">
                <h2 class="phone-name"><%= product.getProductName() %></h2><br>
                <span style="display: inline-block; font-size: 20px; margin-bottom: 10px;">₹</span>
                <b style="display: inline-block; line-height: 25px; color: red; font-size: 19px;"><%= " " + product.getUnitPrice() %></b><br>
                <strong style="display: inline-block; margin-bottom: 12px;">Stock:</strong>
                <span style="display: inline-block; margin-bottom: 12px;"><%= product.getStockQuantity() %></span><br>
                <div class="star-rating" style="margin-bottom: 20px">
                    <%
                    Random random = new Random();
                    int rating = random.nextInt(3) + 2;
                    for (int a = 0; a < rating; a++) {
                    %>
                    <span class="fa fa-star checked" style="color: red;"></span>
                    <%
                    }
                    for (int a = rating; a < 5; a++) {
                    %>
                    <span class="fa-regular fa-star"></span>
                    <%
                    }
                    %>
                </div>
                <% if (cookieUsername != null && !cookieUsername.isEmpty()) { %>
                <form action="<%= contextPath %>/addProducts" method="post">
                    <input type="hidden" name="productId" value="<%= product.getProductID()%>">
                    <input type="hidden" name="unitPrice" value="<%= product.getUnitPrice() %>">
                    <input type="hidden" name="productName" value="<%= product.getProductName()%>">
                    <input type="hidden" name="productImage" value="<%= product.getImageUrlFromPart()%>">
                    <button type="submit" class="btn">Add to cart &#8594;</button>
                </form>
                <% } else { %>
                <a href="<%= contextPath%>/pages/Login.jsp" class="btn">Add to cart &#8594;</a>
                <% } %>
            </div>
            <%productCount++;
        	}
    		}
    		%>
		</div>
        </div>
        <div class="button">
            <a href="<%=contextPath%>/pages/Shop.jsp">View All Products</a>
        </div>
    </div>
</div>

<!-- Brand Section -->
<div class="brand-content">
    <div class="container">
        <p class="title">Supported By:</p>
        <div class="row">
            <div class="brands">
                <a href="https://www.apple.com/" target="_blank">
                <img src="<%=contextPath%>/images/apple logo.png">
                </a>
            </div>
            <div class="brands">
                <a href="https://www.mi.com/global/" target="_blank">
                <img src="<%=contextPath%>/images/MI.png">
                </a>
            </div>
            <div class="brands">
                <a href="https://www.oneplus.com/us/store/phone" target="_blank">
                <img src="<%=contextPath%>/images/Oneplus.png" style="height: 150px;">
                </a>
            </div>
            <div class="brands">
                <a href="https://www.samsung.com/in/" target="_blank">
                <img src="<%=contextPath%>/images/Samsung.png" style="height: 150px;">
                </a>
            </div>
        </div>
    </div>
</div>

<!-- Customer's Testimonial Section-->
<div class="customer-testimonial">
    <div class="container">
        <h2 class="heading">Customer's Testimonial</h2>
        <p style="border: 2px solid red; width: 100px; margin-left: 540px;"></p>
        <div class="content">
            <span class="customer-image"></span>
            <p class="customer-name">Sandesh Shrestha</p>
            <span style="margin-top: 10px; color: rgb(131, 131, 131); font-weight: bold;">Customer</span>
            <p class="feedback">
                Shopping on this mobile e-commerce website was a breeze!<br> The interface was intuitive, and I found exactly what I was looking for quickly.
            </p>
        </div>
    </div>
</div>

<!-- Footer Section -->
<div class="footer-content">
    <div class="container">
        <div class="contact-info">
            <p class="company-name">MAKSHAD<sup style="color: red; font-weight: 0; font-style: italic;">NP</sup></p>
            <p class="address"><i class="fa-solid fa-location-dot fa-lg"></i> Kamalpokhari, Kathmandu, Nepal</p>
            <p class="phone-number"><i class="fa-solid fa-phone fa-lg"></i> +977 0845029</p>
            <p class="email-address"><i class="fa-solid fa-envelope fa-lg"></i> makshad@gmail.com</p>
        </div>
        <div class="links">
            <p class="menu">MENU</p>
            <ul>
                <li>
                    <a href="<%=contextPath%>/Index.jsp">HOME</a>
                </li>
                <li>
                    <a href="<%=contextPath%>/pages/Shop.jsp">SHOP</a>
                </li>
                <li>
                    <a href="<%=contextPath%>/pages/Contact.jsp">CONTACT</a>
                </li>
            </ul>
        </div>
        <div class="accounts">
            <p class="account">USEFUL LINKS</p>
            <ul>
                <li>
                    <% if(cookieUsername != null && !cookieUsername.isEmpty()) { %>
                    	<a href="<%= contextPath%>/pages/MyProfile.jsp" target="_blank">ACCOUNT</a>
                    <%} else { %>
                    	<a href="<%= contextPath %>/pages/Login.jsp">ACCOUNT</a>
                    <% } %>
                </li>
                <li>
                	<% if(cookieUsername != null && !cookieUsername.isEmpty()) { %>
                    	<form action="<%=contextPath%>/logoutUser" method="post" class="user-links" id="form">
	                        <input type="submit" value="LOG OUT" class="logout-btn">
                    	</form>
                    <% } else { %>
                    	<a href="<%=contextPath%>/pages/Login.jsp">LOG IN</a>
                    <% } %>
                </li>
                <li>
                	<%if (cookieUsername != null && !cookieUsername.isEmpty()) { %>
                    	<a href="<%=contextPath%>/pages/Cart.jsp">VIEW CART</a>
                    <%} else { %>
                    	<a href="<%=contextPath %>/pages/Login.jsp">VIEW CART</a>
                    <% } %>
                </li>
            </ul>
        </div>
        <div class="follow-us">
            <p class="get-in">GET IN TOUCH</p>
            <p class="sub">Subscribe us to get offers<br>information in your email.</p>
            <form id="subscribeForm" action="#">
			    <input type="email" id="emailInput" name="emailaddress" placeholder="Enter Your Mail" required>
			    <input type="submit" id="subscribeButton" value="Subscribe">  
			</form>
        </div>
    </div>
</div>  
<script>
	let dropdown = document.getElementById("dropdown-menu-links");
	
	function toggleMenu(){
	    dropdown.classList.toggle("open-menu");
	
	}
	function hideMessage(element) {
	    element.parentNode.style.display = "none";
	}
	
	const form = document.getElementById('subscribeForm');
    const subscribeButton = document.getElementById('subscribeButton');

    form.addEventListener('submit', function(event) {
        event.preventDefault();
        const email = document.getElementById('emailInput').value;
        if (email.trim() !== '') {
            alert('Thank you for subscribing us!');
        } else {
            alert('Please enter your email address');
        }
    });
</script>
</body>
</html> 
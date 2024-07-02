<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="utils.StringUtils" %>
<%@ page import="controller.database.DatabaseController" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.RegisterModel" %>
<%@ page import="model.CartProductModel" %>
<%@ page import="model.CartModel"%>
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
	
	CartModel userCart = dbController.getCartModelInfo(cookieUsername);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shop | E-commerce Website</title>
    <link rel="stylesheet" href="<%=contextPath%>/stylesheets/Cart.css">
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
        .EmptyCart {
		  	display: flex;
		  	flex-direction: column;
		  	align-items: center;
		}
		.empty-card-image{
			height: 500px;
		}
		.cart-btn {
			display: inline-block;
	  		padding: 10px 20px;
		  	background-color: #007bff; 
		  	color: #fff; 
		  	text-decoration: none;
		  	border-radius: 5px;
		 	border: none;
		  	cursor: pointer;
		  	width: 100px;
		  	text-align: center;
		  	transition: background-color 0.3s ease;
		}
		.cart-btn:hover {
		  background-color: #0056b3; 
		}
        
    </style>
</head>
<body> 

<!-- Navbar Section -->
<div class="navbar-section">
    <div class="container">
        <nav>
            <div class="logo-section">
                <a href="#">
                    <img src="<%=contextPath%>/images/logo.png" alt="logo" class="logo">
                </a>
            </div>
            <div class="nav-links">
                <ul>
                    <li><a href="<%=contextPath%>/Index.jsp">HOME</a></li>
                    <li><a href="<%=contextPath %>/pages/Shop.jsp" class="current">SHOP</a></li>
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
                <span class="cart-count"><%=cartItemCount%></span>
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
 <div class="body-section">
    <div class="container">
        <h2>Cart</h2>
        <div class="short-links">
            <i class="fa-solid fa-house"></i>
            <a href="../Index.html">Home</a>
            <p style="color: rgb(142, 122, 122); font-weight: bold; margin-right: 7px; margin-top: 3px;">></p>
            <span>Cart</span>
        </div>
    </div>
 </div>

  <!-- Cart-Product Section -->
 <div class="cart-section">
     <div class="container">
        <%if(cartItems == null || cartItems.isEmpty()) {%>
        	<div class="EmptyCart">
        		<img src="<%= contextPath %>/images/demo.jpg" alt="product-pic" class="empty-card-image">
        		<a href="<%=contextPath %>/pages/Shop.jsp" class="cart-btn">Buy Now</a>
    		</div>
        <%} else { %>
        <h3 class="title">Shopping Cart</h3>
        <div class="product-table">
            <table class="table" id="cart-table">
                <thead>
                    <tr>
                        <td class="image">Image</td>
                        <td class="name">Product Name</td>
                        <td class="price">Price</td>
                        <td class="quantity">Quantity</td>
                        <td class="total">Total</td>
                        <td class="delete"></td>
                    </tr>
                </thead>
                <tbody>
                <% for(CartProductModel items: cartItems){ %>
                    <tr>
                        <td class="image">
               				<img src="<%= contextPath %>/resources/product/<%= items.getImagePath()%>" alt="product-pic">
                        </td>
                        <td class="name">
                            <p><%= items.getProductName() %></p>
                        </td>
                        <td class="price">
                            <p>$<%= " " + items.getPrice() %></p>
                        </td>
                        <td class="quantity">
			    			<form id="quantityForm" action="<%=contextPath%>/updateQuantity" method="post">
						        <input type="hidden" id="quantity" name="quantity" value="<%= items.getQuantity() %>">
						        <input type="hidden" id="price" name="price" value="<%= items.getPrice() %>">
   						        <input type="hidden" id="productID" name="productID" value="<%= items.getProductID() %>">
						        <div class="button">
						            <button type="button" class="quantity-btn" onclick="updateQuantity(this, '-')"><b>-</b></button>
						            <span><%= items.getQuantity() %></span>
						            <button type="button" class="quantity-btn" onclick="updateQuantity(this, '+')"
						            <% if (items.getQuantity() >= items.getStockQuantity()) { %>disabled<% } %>><b>+</b></button>
						        </div>
						    </form>
						</td>

                        <td class="total">
                            <p><%= items.getLineTotal() %></p>
                        </td>
                        <td class="delete">
                            <form action="<%= contextPath %>/deleteProduct" method="post" class="delete-form">
                            	<input type="hidden" name="productId" value="<%= items.getProductID() %>">
                                <button type="submit" class="delete-btn" id="remove-btn">Remove</button>
                            </form>
                        </td>
                    </tr>               	
                <%} %>
                </tbody>
            </table>
        </div>
        <div class="cart-container"
        style="
        margin-top: 20px;
	    display: flex;
	    justify-content: space-between;        
        ">
        	<div class="shop-more">
	        	<a href="<%= contextPath%>/pages/Shop.jsp" style="
	        	background-color: #007bff;
	        	display: inline-block;
			    color: #ffffff;
			    border: none;
			    padding: 8px 16px;
			    cursor: pointer;
			    border-radius: 4px;
			    font-size: 14px;
			    font-weight: bold;
			    text-decoration: none;
	        	"> &#8592; Shop More</a>
        	</div>
            <div class="cart-table">
                    <h3 class="title">Cart Summary</h3>
                    <hr class="line">
                    <div class="details">
                        <div class="row">
                            <p class="sub-total">Subtotal(<%= userCart.getTotalQuantity()%>)</p>
                            <p class="sub-total-amount"style="font-size: 19px;"><span style=" font-size: 20px;">₹</span><%= " "+userCart.getTotalAmount()%></p>
                        </div>
                        <div class="row">
                            <p class="sub-total">Tax Rate</p>
                            <p class="sub-total-amount"style="font-size: 19px;">0%</p>
                        </div>
                        <hr class="line">
                        <div class="row">
                            <p class="sub-total">Grand Amount</p>
                            <p class="sub-total-amount"><span style=" font-size: 20px;">₹ </span><%= userCart.getTotalAmount()%></p>
                        </div>
                    </div>
				<a href="<%= contextPath%>/pages/MyOrder.jsp" class="checkout-button">Checkout</a>
           	</div>
        </div>
       <%} %>
    </div>
 </div>

<!-- Footer Section  -->
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
                     <a href="Index.html">HOME</a>
                 </li>
                 <li>
                     <a href="Pages/Shop.html">SHOP</a>
                 </li>
                 <li>
                     <a href="Pages/Contact.html">CONTACT</a>
                 </li>
             </ul>
         </div>
         <div class="accounts">
             <p class="account">USEFUL LINKS</p>
             <ul>
                 <li>
                     <a href="#">ACCOUNT</a>
                 </li>
                 <li>
                     <a href="Pages/Login.html">LOG IN</a>
                 </li>
                 <li>
                     <a href="#">VIEW CART</a>
                 </li>
             </ul>
         </div>
         <div class="follow-us">
             <p class="get-in">GET IN TOUCH</p>
             <p class="sub">Subscribe us to get offers<br>information in your email.</p>
             <form action="#">
                 <input type="email" name="emailaddress" placeholder="Enter Your Mail" required>
                 <input type="submit" value="Subscribe">  
             </form>
         </div>
     </div>
 </div>


<script>
    
	function updateQuantity(button, operation) {
	    var form = button.closest("form");
	    var quantityInput = form.querySelector("#quantity");
	    var span = form.querySelector("span");
	    var currentQuantity = parseInt(span.textContent);
	
	    if (operation === '-' && currentQuantity > 1) {
	        currentQuantity--;
	    } else if (operation === '+') {
	        currentQuantity++;
	    }
	
	    span.textContent = currentQuantity;
	    quantityInput.value = currentQuantity;
	
	    form.submit();
	}
	let dropdown = document.getElementById("dropdown-menu-links");
	
	function toggleMenu(){
	    dropdown.classList.toggle("open-menu");
	
	}

</script>
</body>
</html>
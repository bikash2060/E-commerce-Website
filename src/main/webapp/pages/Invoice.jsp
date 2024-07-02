<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="utils.StringUtils" %>
<%@ page import="controller.database.DatabaseController" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.RegisterModel" %>
<%@ page import="model.CartProductModel" %>
<%@ page import="model.CartModel"%>
<%@ page import="utils.GenerateDiscountAmount" %>
<%@ page import="utils.InvoiceIDGenerator" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="model.OrdersLineModel" %>
<%@ page import="model.OrdersModel" %>
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
	
	OrdersModel orderDetails = dbController.getOrderDetails(cookieUsername);
	
	ArrayList<OrdersLineModel> ordersLine = dbController.getOrdersLine(cookieUsername);
	
	CartModel userCart = dbController.getCartModelInfo(cookieUsername);
	
	double totalAmount = userCart.getTotalAmount();
	int discountPercentage = GenerateDiscountAmount.calculateDiscountPercentage();
	double discountAmount = GenerateDiscountAmount.calculateDiscountAmount(totalAmount, discountPercentage);
	double grandAmount = totalAmount - discountAmount;
	
	int invoiceID = InvoiceIDGenerator.generateUniqueInvoiceID();
	LocalDate invoiceDate = LocalDate.now();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Invoice | E-commerce Website</title>
    <link rel="stylesheet" href="<%=contextPath%>/stylesheets/Invoice.css">
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
    </style>
</head>
<body>
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
<!-- Body Content -->
<div class="body-section">
    <div class="container">
        <h2>Invoice</h2>
        <div class="short-links">
            <i class="fa-solid fa-house"></i>
            <a href="../Index.html">Home</a>
            <p style="color: rgb(142, 122, 122); font-weight: bold; margin-right: 7px; margin-top: 3px;">></p>
            <span>Invoice</span>
        </div>
    </div>
 </div>

<!-- Invoice Section -->
<div class="invoice">
    <div class="container">
    	<div class="success-message">
            <i class="fas fa-check-circle"></i>
            <p>Your order has been placed successfully !</p>
        </div>
        <div class="top-section">
            <div class="logo">
                <img src="<%=contextPath%>/images/logo.png" alt="logo" class="company-logo">
                <h2>Makshad</h2>
            </div>
            <div class="company-details">
                <p class="name">Makshad Suppliers</p>
                <p class="address">Kamalpokhari, Kathmandu, Nepal</p>
                <p class="email">makshad@gmail.com</p>
            </div>
        </div>
        <div class="header-section">
            <div class="customer-details">
                <p>Name:<%=" "+userFullName %></p>
                <p>Phone Number:<%=" "+user.getPhoneNumber() %></p>
                <p>Address:<%=" "+orderDetails.getShippingAddress() %></p>
            </div>
            <div class="invoice-details">
                <p>Invoice ID:<%=" "+orderDetails.getOrderID() %></p>
                <p>Invoice Date:<%=" "+invoiceDate %></p>
                <p>Tax Free</p>
            </div>
        </div>
        <hr>
        <div class="products-details">
            <table>
                <thead>
                    <tr>
                        <td>ProductID</td>
                        <td>Product Name</td>
                        <td>Unit Price</td>
                        <td>Quantity</td>
                        <td>Total</td>
                    </tr>
                </thead>
                <tbody>
                <% for(OrdersLineModel items: ordersLine){ %>
                    <tr>
                        <td><%= items.getProductID() %></td>
                        <td><%= items.getProductName() %></td>
                        <td><%= items.getUnitPrice() %></td>
                        <td><%= items.getOrderQuantity() %></td>
                        <td><%= items.getLineTotal() %></td>
                    </tr>
                 <%} %>
                </tbody>
                <tfoot>
                    <tr>
                        <td colspan="4" style="text-align: right;">Total Amount:</td>
                        <td><%=" "+orderDetails.getTotalAmount() %></td>
                    </tr>
                    <tr>
                        <td colspan="4" style="text-align: right;">Discount Amount:</td>
                        <td><%=" "+orderDetails.getDiscountAmount() %></td>
                    </tr>
                    <tr>
                        <td colspan="4" style="text-align: right;">Grand Total Amount:</td>
                        <td><%=" "+orderDetails.getGrandTotalAmount() %></td>
                    </tr>
                </tfoot>
            </table>
        </div>
        <div class="other-information">
            <p>Payment Status:<b><%=" "+orderDetails.getPaymentType() %></b></p>
            <p><i class="fa-regular fa-face-smile"></i></i>Enjoy hassle-free returns within 7 days of purchase</p>
        </div>
        <hr>
        <div class="appreciation-message">
            <div class="message">
                <p class="msg">Thank You For Choosing Us</p>
                <p class="terms">Terms and Conditions:</p>
                <p class="promo">Buy More and Make Us Rich</p>
            </div>
            <div class="signature">
                <p class="owner">Bikash Bhattarai</p>
                <p class="text">Owner</p>
                <i class="fa-solid fa-signature"></i>
            </div>
        </div>
    </div>
</div>

<!-- Buy More Section -->
<div class="buy-more">
    <div class="container">
        <p>Wanna buy more?</p>
        <a href="<%=contextPath%>/pages/Shop.jsp">Explore</a>
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
    let dropdown = document.getElementById("dropdown-menu-links");

    function toggleMenu(){
        dropdown.classList.toggle("open-class");

    }
</script>
</body>
</html>
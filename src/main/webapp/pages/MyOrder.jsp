<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="utils.StringUtils" %>
<%@ page import="controller.database.DatabaseController" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.RegisterModel" %>
<%@ page import="model.CartProductModel" %>
<%@ page import="model.CartModel"%>
<%@ page import="utils.GenerateDiscountAmount" %>
<%@ page import="java.time.LocalDate" %>
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
	
	double totalAmount = userCart.getTotalAmount();
	int discountPercentage = GenerateDiscountAmount.calculateDiscountPercentage();
	double discountAmount = GenerateDiscountAmount.calculateDiscountAmount(totalAmount, discountPercentage);
	double grandAmount = totalAmount - discountAmount;
	
	LocalDate orderDate = LocalDate.now();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Order | E-commerce Website</title>
    <link rel="stylesheet" href="<%=contextPath%>/stylesheets/MyOrder.css">
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
        .message-container {
		    position: absolute;
		    top: 17%;
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
                <a href="<%=contextPath%>/pages/Cart.jsp"><i class="fa-solid fa-cart-shopping"></i></a>
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
        <h2>Order</h2>
        <div class="short-links">
            <i class="fa-solid fa-house"></i>
            <a href="../Index.html">Home</a>
            <p style="color: rgb(142, 122, 122); font-weight: bold; margin-right: 7px; margin-top: 3px;">></p>
            <span>Order</span>
        </div>
    </div>
 </div>

<!-- Order Body Section -->
    <div class="order-body-section">
        <div class="container">
            <div class="title">
                <h3>Order Summary</h3>
                <% String errorMessage = (String) request.getAttribute(StringUtils.ERROR_MESSAGE);
				if (errorMessage != null && !errorMessage.isEmpty()) {%>
				    <div class="message-container error">
				        <p><%= errorMessage %></p>
				        <span class="close-btn" onclick="hideMessage(this)"><i class="fa-solid fa-x"></i></span>
				    </div>
				<%}%>
                <div class="user-details">
                    <%if(user.getImageUrlFromPart() != null && !user.getImageUrlFromPart().isEmpty()){ %>
                 		<img src="<%=contextPath%>/resources/user/<%= user.getImageUrlFromPart()%>" alt="user-pic" class="user-pic" onclick="toggleMenu()">
                 	<% } else {%>                 
	             		<img src="<%=contextPath%>/images/user.png" alt="user-pic" class="user-pic" onclick="toggleMenu()">
                	<% } %>
                    <p><%= user.getFirstName()%><br><%= user.getLastName() %></p>
                </div>
            </div>
            <div class="main-title">
                <h3 class="customer">Customer Details:</h3>
                <h3 class="order">Order Details:</h3>
            </div>
            <div class="form-section">
                <form action="<%=contextPath%>/orderConfirm" method="post">
                    <div class="mid-container">
                        <div class="left-col">
                            <div class="row">
                                <label for="fullName">Name</label>
                                <input type="text" name="fullName" id="fullName" value="<%= userFullName%>" readonly>
                            </div>
                            <div class="row">
                                <label for="phoneNumber">Phone Number</label>
                                <input type="text" name="phoneNumber" id="phoneNumber" value="<%= user.getPhoneNumber()%>" readonly>
                            </div>
                            <div class="row">
                                <label for="address">Address</label>
                                <input type="text" name="address" id="address" value="<%= user.getAddress() %>" readonly>
                            </div>
                            <div class="row">
                                <label for="shipppingAddress">Shipping Address<span class="required">*</span></label>
                                <input type="text" name="shippingAddress" id="shipppingAddress" placeholder="Enter shipping address"
                                value="<%= (request.getParameter("shippingAddress") != null) ? request.getParameter("shippingAddress") : "" %>">
                            </div>
                            <div class="order-date">
                                <h3>Ordered Date:</h3>
                                <p><%= orderDate %></p>
                            </div>
                        </div>
                        
                        <div class="right-col">
                            <div class="table-wrapper">
                                <table>
                                    <tbody class="product-data">
                                    <% for(CartProductModel items: cartItems){ %>
                                        <tr class="row-data">
                                            <td class="product-name"><%= items.getProductName() %><br>
                                                <span class="quantity">Quantity:<%=" "+ items.getQuantity() %></span>
                                            </td>
                                            <td class="price"><%= items.getLineTotal() %></td>
                                        </tr>
                                    <% } %> 
                                    </tbody>
                                </table>
                            </div>
                            <div class="total-amount">
                                <div class="row">
                                    <p class="net-amount">Total Amount:</p>
                                    <p class="amount"><%= userCart.getTotalAmount()%></p>
                                </div>
                            </div>
                            <div class="payment-type">
                                <i class="fas fa-credit-card"></i>
                                <div class="checkbox-wrapper">
                                    <input type="radio" value="Online" name="payment" id="online">
                                    <label for="online">Online</label>
                                </div>
                                <div class="checkbox-wrapper">
                                    <input type="radio" value="Cash on Delivery" name="payment" id="Cash on Delivery">
                                    <label for="Cash on Delivery">Cash on Delivery</label>
                                </div>
                            </div>
                            <div class="payment-amount">
                            	<div class="row">
                                    <p class="discount">Discount Rate:</p>
                                    <p class="discount-amount"><%= discountPercentage+"%" %></p>
                                </div>
                                <div class="row">
                                    <p class="discount">Discount Amount:</p>
                                    <p class="discount-amount"><%= discountAmount %></p>
                                </div>
                                <div class="row">
                                    <p class="grand">Grand Total Amount:</p>
                                    <p class="grand-amount"><%= grandAmount %></p>
                                </div>
                            </div>   
                            <div class="submit-button">
                            	<input type="hidden" name="netAmount" value = "<%= totalAmount %>">
                            	<input type="hidden" name="discountAmount" value = "<%= discountAmount %>">
                            	<input type="hidden" name="totalAmount" value = "<%= grandAmount %>">
                                <input type="submit" value="PLACE ORDER">
                            </div>                     
                        </div>
                    </div>
                </form>
            </div>
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

<script type="text/javascript">
	let dropdown = document.getElementById("dropdown-menu-links");
	
	function toggleMenu(){
	    dropdown.classList.toggle("open-menu");
	
	}
	
	function hideMessage(element) {
	    element.parentNode.style.display = "none";
	}
</script>
</body>
</html>
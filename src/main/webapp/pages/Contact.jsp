<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="utils.StringUtils" %>
<%@ page import="utils.StringUtils" %>
<%@ page import="controller.database.DatabaseController" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.RegisterModel" %>
<%@ page import="model.CartProductModel" %>
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
	ArrayList<CartProductModel> cartItems = dbController.getCartItems(cookieUsername);
	int cartItemCount = cartItems.size();
	
	RegisterModel user = (RegisterModel) dbController.getAllUserInfo(cookieUsername);
	String userFullName = user.getFirstName()+" "+user.getLastName();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact | E-commerce Website</title>
    <link rel="stylesheet" href="<%=contextPath%>/stylesheets/Contact.css">
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
                    <li><a href="<%=contextPath%>/Index.jsp">HOME</a></li>
					<li><a href="<%=contextPath %>/pages/Shop.jsp">SHOP</a></li>
                    <li><a href="<%=contextPath%>/pages/Contact.jsp" class="current">CONTACT</a></li>
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

<!-- Body Content -->
<div class="body-section">
    <div class="container">
        <h2>Contact</h2>
        <div class="short-links">
            <i class="fa-solid fa-house"></i>
            <a href="<%=contextPath%>/Index.jsp">Home</a>
            <p style="color: rgb(142, 122, 122); font-weight: bold; margin-right: 7px; margin-top: 3px;">></p>
            <span>Contact</span>
        </div>
    </div>
 </div>

<!-- Contact Section -->
<div class="contact-section">
    <div class="container">
        <div class="col-1">
            <div class="contact-info">
                <h4>CONTACT INFO</h4>
                <ul>
                    <li>
                        <h6>
                            <i class="fa-solid fa-location-dot"></i>
                            Address
                        </h6>
                        <p>Kamalpokhari, Kathmandu, Nepal</p>
                    </li>
                    <li>
                        <h6>
                            <i class="fa-solid fa-phone"></i>
                            Phone
                        </h6>
                        <p>+977 0845029 | 0841929</p>
                    </li>
                    <li>
                        <h6>
                            <i class="fa-solid fa-envelope"></i>
                            Support
                        </h6>
                        <p>makshad@gmail.com</p>
                    </li>
                    <li>
                        <h6>Follow us:</h6><br>
                        <div class="social-media">
                            <i class="fa-brands fa-facebook fa-lg"></i>
                            <i class="fa-brands fa-x-twitter fa-lg"></i>
                            <i class="fa-brands fa-instagram fa-lg"></i>
                            <i class="fa-brands fa-linkedin fa-lg"></i>
                        </div>
                    </li>
                </ul>       
            </div>
            <div class="form-container">
                <h4>Send Message</h4>
                <form action="#">
                    <input type="text" placeholder="Name" required><br>
                    <input type="text" placeholder="Email" required><br>
                    <input type="text" placeholder="Phone Number" required ><br>
                    <textarea placeholder="Message" required></textarea>
                    <input type="submit" value="Send Message" class="btn">
                </form>
            </div>
        </div>
        <div class="col-2">
            <img src="<%=contextPath%>/images/Google Map.png" alt="google map">
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


<script type="text/javascript" src="<%=contextPath%>/javascript/Toggle.js"></script>
<script>
	let dropdown = document.getElementById("dropdown-menu-links");
	
	function toggleMenu(){
	    dropdown.classList.toggle("open-menu");
	
	}
	
</script>

</body>
</html>
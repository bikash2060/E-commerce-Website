<%@ page import="utils.StringUtils" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String contextPath = request.getContextPath();
	String cookieUsername = null;
	Cookie[] cookies = request.getCookies();
	if(cookies != null){
		for(Cookie cookie: cookies){
			if(cookie.getName().equals(StringUtils.USER)){
				cookieUsername = cookie.getValue();
			}
		}
	}
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register | E-commerce Website</title>
    <link rel="stylesheet" href="<%=contextPath%>/stylesheets/Register.css">
	<link rel="stylesheet" href="<%=contextPath%>/stylesheets/Footer.css">
    <link rel="stylesheet" href="<%=contextPath%>/stylesheets/Header.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"/>
    <style>
    .message-container {
	    transform: translate(-50%, -50%);
	    display: flex; 
	    align-items: center; 
	    justify-content: space-between;
	    width: 300px;
	    text-align: center;
	    padding: 10px 15px;
	    border-radius: 5px;
	    margin-left: 165px;
	    margin-top: 40px;
	}
	.message-container.error {
	    background-color: #ff6347;
	    border: 1px solid #f5c6cb;
	    color: white;
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
                    <li><a href="<%=contextPath%>/pages/Contact.jsp">CONTACT</a></li>
                </ul>
            </div>
            <div class="side-links">
                <%if (cookieUsername != null && !cookieUsername.isEmpty()) { %>
                	<a href="<%=contextPath%>/pages/Cart.jsp"><i class="fa-solid fa-cart-shopping"></i></a>
                <%} else { %>
                	<a href="<%=contextPath%>/pages/Login.jsp"><i class="fa-solid fa-cart-shopping"></i></a>
                <%} %>
               	<i class="fa-solid fa-user" onclick="toggleMenu()"></i>
            </div>

            <div class="dropdown-menu-links" id="dropdown-menu-links">           
                <div class="dropdown-menu">
                <%if (cookieUsername != null && !cookieUsername.isEmpty()){%>
                    <div class="user-info">                    
               		 	<img src="<%=contextPath%>/Images/Home page/Other Images/customer1.jpg" alt="user-pic" class="user-pic" onclick="toggleMenu()">
                        <h3><%= cookieUsername %></h3>
                    </div>
                    <hr>

                    <a href="<%=contextPath%>/pages/UserDetailed.jsp" class="user-links">
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
        <h2>Register</h2>
        <div class="short-links">
            <i class="fa-solid fa-house"></i>
            <a href="<%=contextPath%>/Index.jsp">Home</a>
            <p style="color: rgb(142, 122, 122); font-weight: bold; margin-right: 7px; margin-top: 3px;">></p>
            <span>Register</span>
        </div>
    </div>
 </div>

<!-- Form Section -->
<div class="register-account">
    <div class="container">
        <div class="image-col">
            <img src="<%=contextPath%>/images/Register.png" alt="image">
        </div>
        <div class="form-col">
            <h4>Sign up</h4>
			<% String errorMessage = (String) request.getAttribute(StringUtils.ERROR_MESSAGE);
			if (errorMessage != null && !errorMessage.isEmpty()) {%>
			    <div class="message-container error">
			        <p><%= errorMessage %></p>
			        <span class="close-btn" onclick="hideMessage(this)"><i class="fa-solid fa-x"></i></span>
			    </div>
			<%}%>	
            <form action="<%=contextPath%>/registerUser" method="post">
                <div class="row">
                    <div class="col">
                        <label for="firstName">First Name:</label><br>                        
                        <input type="text" name="firstName" id="firstName" value="<%= (request.getParameter("firstName") != null) ? request.getParameter("firstName") : "" %>">
                    </div>
                    <div class="col-2">
                        <label for="lastName">Last Name:</label><br>
                        <input type="text" name="lastName" id="lastName" value="<%= (request.getParameter("lastName") != null) ? request.getParameter("lastName") : "" %>">
                    </div>
                </div>
                <div class="row">
                    <div class="col">
                        <label for="username">Username:</label><br>                        
                        <input type="text" name="username" id="username" value="<%= (request.getParameter("username") != null) ? request.getParameter("username") : "" %>">
                    </div>
                    <div class="col-2">
                        <label for="gender">Gender:</label><br>
                        <select id="gender" name="gender">
                            <option value="Male" <%= ("Male".equals(request.getParameter("gender"))) ? "selected" : "" %>>Male</option>
                            <option value="Female" <%= ("Female".equals(request.getParameter("gender"))) ? "selected" : "" %>>Female</option>
                            <option value="Other" <%= ("Other".equals(request.getParameter("gender"))) ? "selected" : "" %>>Other</option>
                        </select>
                    </div>
                </div>
                <div class="row">
                    <div class="col">
                        <label for="emailAddress">Email Address:</label><br>                        
                        <input type="text" name="emailAddress" id="emailAddress" placeholder="domain@gmail.com" value="<%= (request.getParameter("emailAddress") != null) ? request.getParameter("emailAddress") : "" %>">
                    </div>
                    <div class="col-2">
                        <label for="dob">Date of Birth:</label><br>
                        <input type="date" name="dob" id="dob" value="<%= (request.getParameter("dob") != null) ? request.getParameter("dob") : "" %>">
                    </div>
                </div>
                <div class="row">
                    <div class="col">
                        <label for="shippingAddress">Address:</label><br>                        
                        <input type="text" name="shippingAddress" id="shippingAddress" value="<%= (request.getParameter("shippingAddress") != null) ? request.getParameter("shippingAddress") : "" %>">
                    </div>
                    <div class="col-2">
                        <label for="joinedDate">Creation Date:</label><br>
                        <input type="date" name="joinedDate" id="joinedDate" value="<%= (request.getParameter("joinedDate") != null) ? request.getParameter("joinedDate") : "" %>">
                    </div>
                </div>
                <div class="row">
                    <div class="col">
                        <label for="password">Password:</label><br>                        
                        <input type="password" name="password" id="password" value="<%= (request.getParameter("password") != null) ? request.getParameter("password") : "" %>">
                    </div>
                    <div class="col-2">
                        <label for="confirmPassword">Confirm Password:</label><br>
                        <input type="password" name="confirmPassword" id="confirmPassword" value="<%= (request.getParameter("confirmPassword") != null) ? request.getParameter("confirmPassword") : "" %>">
                    </div>
                </div>
                <div class="row">
                    <div class="col">
                        <label for="phoneNumber">Phone Number:</label><br>                        
                        <input type="text" name="phoneNumber" id="phoneNumber" value="<%= (request.getParameter("phoneNumber") != null) ? request.getParameter("phoneNumber") : "" %>">
                    </div>
                </div>
                <input type="submit" value="Create">
                <input type="reset" value="Reset" onclick="resetForm()">
            </form>
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

<script type="text/javascript" src="<%=contextPath%>/javascript/ClearForm.js"></script>
<script>
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
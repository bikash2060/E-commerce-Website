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
    <title>Login | E-commerce Website</title>
    <link rel="stylesheet" href="<%=contextPath%>/stylesheets/Login.css">
	<link rel="stylesheet" href="<%=contextPath%>/stylesheets/Footer.css">
    <link rel="stylesheet" href="<%=contextPath%>/stylesheets/Header.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"/>
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


<!-- Body Content -->
<div class="body-section">
    <div class="container">
        <h2 class="body-title">Log In</h2>
        <div class="short-links">
            <i class="fa-solid fa-house"></i>
            <a href="<%=contextPath%>/Index.jsp">Home</a>
            <p style="color: rgb(142, 122, 122); font-weight: bold; margin-right: 7px; margin-top: 3px;">></p>
            <span>Log In</span>
        </div>
    </div>
 </div>

<!-- Login Form -->
<div class="login-section">
    <div class="container">
        <div class="login-box">
            <h2 class="heading">Login</h2>
            <%
			String errorMessage = (String) request.getAttribute(StringUtils.ERROR_MESSAGE);
			if (errorMessage != null && !errorMessage.isEmpty()) {
			%>
				<p class="error-message" id="errorMessage">
					<%= errorMessage %>
					<span class="close-button" onclick="closeErrorMessage()">&times;</span>
				</p>
			<%
			}
			%>
            <form action="<%=contextPath%>/loginUser" method="post" id="form">
                <div class="row">
                    <div class="col">
                        <label for="username"><b>Username:</b></label> 
                        <input type="text" class="username" id="username" name="username" value="<%= (request.getParameter("username") != null) ? request.getParameter("username") : "" %>">
                        <span id="username-error"></span>
                    </div>
                </div>
                <div class="row">
                    <div class="col">
                        <label for="password"><b>Password:</b></label> 
                        <input type="password" id="password" id="password" name="password">
                        <span id="password-error"></span>
                    </div>
                </div>
                <div class="checkbox">
                    <input type="checkbox" class="checkbox" onclick="myFunction()">
                    <label for="checkbox">Show Password</label>
                </div>
                <br>
                <input type="submit" value="Login" class="login"> <br> <br>
                <div class="createAccount">
                    <p>Don't have account? <a href="<%=contextPath%>/pages/Register.jsp">Create new account </a></p>
                </div>
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

<script type="text/javascript" src="<%=contextPath%>/javascript/Password.js"></script>
<script>
	let dropdown = document.getElementById("dropdown-menu-links");
	
	function toggleMenu(){
	    dropdown.classList.toggle("open-menu");
	
	}
	
	function closeErrorMessage() {
        var errorMessage = document.getElementById("errorMessage");
        errorMessage.style.display = "none";
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
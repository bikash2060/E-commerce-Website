<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="utils.StringUtils" %>
<%@ page import="controller.database.DatabaseController" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.RegisterModel" %>
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
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Profile | E-commerce Website</title>
    <link rel="stylesheet" href="<%=contextPath%>/stylesheets/UserDetailed.css">
    <link rel="stylesheet" href="<%=contextPath%>/stylesheets/UserPassword.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"/>
</head>
<body>

<!-- Side Menu Bar  -->
<section id="menu">
	<div class="logo">
	    <h2><%= userFullName %></h2>
	</div>
    <div class="menu-links">
        <ul>
            <li>                    
                <a href="<%=contextPath%>/pages/MyProfile.jsp"><i class="fa-solid fa-user-tie"></i>Basic Information</a>                
			</li>
            <li>
                
                <a href="<%=contextPath%>/pages/UserPassword.jsp"><i class="fa-solid fa-key"></i>Password</a>
            </li>
            <li>
				<a href="<%=contextPath%>/pages/OrderHistory.jsp"><i class="fas fa-dollar-sign"></i>Order History</a>
			</li>
            <hr class="underline">
            <li class="logout">
                <form action="<%=contextPath%>/logoutUser" method="post" class="user-links" id="form">
                    <i class="fa-solid fa-right-from-bracket"></i>
                    <input type="submit" value="Log out" class="logout-btn">
                </form>
            </li>

        </ul>
    </div>
</section>
    
    <!-- Body Content -->
<section id="body-content">
	<div class="nav-section">
		<div class="profile">
			<%if(user.getImageUrlFromPart() != null && !user.getImageUrlFromPart().isEmpty()){ %>
				<img src="<%=contextPath%>/resources/user/<%= user.getImageUrlFromPart()%>" alt="user-pic" class="user-pic">
			<% } else {%>                 
            	<img src="<%=contextPath%>/images/user.png" alt="user-pic" class="user-pic">
			<% } %>
		</div>
	</div>
        
	<div class="change-password">
		<h3 class="title">Change Password</h3>
        <%
			String errorMessage = (String) request.getAttribute(StringUtils.ERROR_MESSAGE);
			if (errorMessage != null && !errorMessage.isEmpty()) {%>
				<p class="error-message" id="errorMessage" style="width: 100%;">
					<%= errorMessage %>
					<span class="close-button" onclick="closeErrorMessage()">&times;</span>
				</p>
		<% } %>
		<%
		String successMessage = (String) request.getAttribute(StringUtils.SUCCESS_MESSAGE);
		if (successMessage != null && !successMessage.isEmpty()) {%>
			<p class="success-message" id="successMessage" style="width: 100%;">
    			<%= successMessage %>
    			<span class="close-button" onclick="closeSuccessMessage()">&times;</span>
			</p>				
		<% } %>
		<form id="userForm" action="<%=contextPath%>/userPassword" method="post"> 
			<div class="row">
				<div class="col col-1" id="col-1">
	                <label for="oldPassword">Old Password:</label>
	                <input type="password" name="oldPassword" id="oldPassword">
                </div>
				<div class="col col-2" id="col-2">
	                <label for="newPassword">New Password:</label>
	                <input type="password" name="newPassword" id="newPassword">
				</div>
                <div class="col col-3" id="col-3">
	                <label for="confirmPassword">Confirm Password:</label>
	                <input type="password" name="confirmPassword" id="confirmPassword">
				</div>
			</div>
			<div class="button-container">
				<input type="submit" id="saveChangesBtn" value="Save Changes" onclick="icon()">
			</div>
		</form>
      </div>
</section>
<script>    
    function closeSuccessMessage() {
     var successMessage = document.getElementById("successMessage");
     var oldIcon = document.getElementById("col-1");
     var newIcon = document.getElementById("col-2");
     var conIcon = document.getElementById("col-2");

     successMessage.style.display = "none";
     
 	}
 
	 function closeErrorMessage() {
	     var errorMessage = document.getElementById("errorMessage");
	     errorMessage.style.display = "none";
	 }

</script>
    
</body>
</html>
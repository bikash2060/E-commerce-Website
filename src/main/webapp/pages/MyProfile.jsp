<%@ page import="utils.StringUtils" %>
<%@ page import="controller.database.DatabaseController" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.RegisterModel" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
    
	<div class="form">
        <form action="<%=contextPath%>/userUpdate" method="post" enctype="multipart/form-data">
            <div class="row">
                <div id="user">
                     <%if(user.getImageUrlFromPart() != null && !user.getImageUrlFromPart().isEmpty()){ %>
           				<img src="<%=contextPath%>/resources/user/<%= user.getImageUrlFromPart()%>" alt="user-pic" class="user-pic">
           			<% } else {%>                 
         				<img src="<%=contextPath%>/images/user.png" alt="user-pic" class="user-pic">
           			<% } %>
                    <input type="file" name="image" id="image">
                    <label for="image" id="upload-btn"><i class="fa-solid fa-camera"></i></label>
                </div>
                <div id="username">
                    <h2><%=user.getFirstName() +" "+ user.getLastName() %></h2>
                </div>
            </div>
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
				<%
				String successMessage = (String) request.getAttribute(StringUtils.SUCCESS_MESSAGE);
				if (successMessage != null && !successMessage.isEmpty()) {
				%>
				<p class="success-message" id="successMessage">
								<%= successMessage %>
								<span class="close-button" onclick="closeSuccessMessage()">&times;</span>
				</p>				
				<%
				}
				%>
	            <div class="row">
	                <div class="col">
	                    <label for="firstName">First Name:</label>
	                    <input type="text" name="firstName" id="firstName" value="<%= (request.getParameter("firstName") != null) ? request.getParameter("firstName") : user.getFirstName() %>">
	                </div>
	                <div class="col">
	                    <label for="lastName">Last Name:</label>
	                    <input type="text" name="lastName" id="lastName" value="<%= (request.getParameter("lastName") != null) ? request.getParameter("lastName") : user.getLastName() %>">
	                </div>
	            </div>
	            <div class="row">
	                <div class="col">
	                    <label for="dob">Birth Date:</label>
	                    <input type="date" name="dob" id="dob" value="<%= user.getDOB() %>" readonly>
	                </div>
	                <div class="col">
	                    <label for="joinedDate">Registered Date:</label>
	                    <input type="date" name="joinedDate" id="joinedDate" value="<%= user.getJoinedDate() %>" readonly>
	                </div>
	            </div>
	            <div class="row">
	                <div class="col">
	                    <label for="emailAddress">Email Address:</label>
	                    <input type="text" name="emailAddress" id="emailAddress" value="<%= (request.getParameter("emailAddress") != null) ? request.getParameter("emailAddress") : user.getEmailAddress() %>">
	                </div>
	                <div class="col">
	                    <label for="address">Address:</label>
	                    <input type="text" name="shippingAddress" id="shippingAddress" value="<%= (request.getParameter("shippingAddress") != null) ? request.getParameter("shippingAddress") : user.getAddress() %>">
	                </div>
	            </div>
	            <div class="row">
	                <div class="col">
	                    <label for="phoneNumber">Phone Number:</label>
	                    <input type="text" name="phoneNumber" id="phoneNumber" value="<%= (request.getParameter("phoneNumber") != null) ? request.getParameter("phoneNumber") : user.getPhoneNumber() %>">
	                </div>
	                <div class="col">
	                    <label for="gender">Gender:</label><br>
	                    <select id="gender" name="gender" disabled>
	                        <option value="Male" <%= user.getGender().equals("Male") ? "selected" : "" %>>Male</option>
					        <option value="Female" <%= user.getGender().equals("Female") ? "selected" : "" %>>Female</option>
					        <option value="Other" <%= user.getGender().equals("Other") ? "selected" : "" %>>Other</option>
	                    </select>
	                </div>
	            </div>
	            <div class="row">
	                <div class="col">
	                    <label for="username">Username:</label>
	                    <input type="text" name="username" id="username" value="<%= user.getUsername()%>" readonly>
	                </div>
	            </div>        
	            <div class="row">
	            	<div class="col">
	                 <input type="submit" id="saveChangesBtn" value="Save Changes">
	            	</div>
	            </div>
        	</form>
  		</div>
</section>
<script>
	function closeSuccessMessage() {
		var successMessage = document.getElementById("successMessage");
		var errorMessage = document.getElementById("errorMessage");
		successMessage.style.display = "none";
		errorMessage.style.display = "none";
 	}
 
	function closeErrorMessage() {
		var errorMessage = document.getElementById("errorMessage");
     	errorMessage.style.display = "none";
 }
</script>
</body>
</html>
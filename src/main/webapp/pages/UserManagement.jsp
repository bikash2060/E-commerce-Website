<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="model.RegisterModel" %>
<%@ page import="controller.database.DatabaseController" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="utils.StringUtils" %>
<%
	String contextPath = request.getContextPath();
	DatabaseController dbController = new DatabaseController();
	ArrayList<RegisterModel> user = dbController.getAllUserDetails();
	
	int totalUsers = dbController.getAllUser();
	int totalProducts = dbController.getTotalProducts();
	double totalRevenue = dbController.getTotalRevenue();
	int newOrders = dbController.getNewOrders();
	
	String cookieUsername = null;
	Cookie[] cookies = request.getCookies();
	if(cookies != null){
		for(Cookie cookie: cookies){
			if(cookie.getName().equals(StringUtils.USER)){
				cookieUsername = cookie.getValue();
				break;
			}
			if(cookie.getName().equals(StringUtils.ADMIN)){
				cookieUsername = cookie.getValue();
				break;
			}
		}
	}
	RegisterModel users = new RegisterModel();
	if(!cookieUsername.equals("bikash200@gmail.com")){
		users = (RegisterModel) dbController.getAllUserInfo(cookieUsername);
	}
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Panel | E-commerce Website</title>
    <link rel="stylesheet" href="<%=contextPath%>/stylesheets/UserManagement.css">
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
                <% if(cookieUsername != null && cookieUsername.equals("bikash200@gmail.com")) { %>
           	 		<a href="<%=contextPath%>/pages/AddProduct.jsp" class="sub-btn">Add New Product</a>
        		<% } %>
                <a href="<%=contextPath%>/pages/ViewProduct.jsp" class="sub-btn">View Product</a>
            </div>
        </div>
        <div class="item">
            <a href="<%=contextPath%>/pages/UserManagement.jsp"><i class="fa-solid fa-users"></i>User Management</a>
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
            <%if(cookieUsername != null && cookieUsername.equals("bikash200@gmail.com")) {%>
            	<%if(users.getImageUrlFromPart() != null && !users.getImageUrlFromPart().isEmpty()){ %>
               		<img src="<%=contextPath%>/resources/user/<%= users.getImageUrlFromPart()%>" alt="user-pic">
               	<% } else {%>                 
            		<img src="<%=contextPath%>/images/user.png" alt="user-pic">
              	<% } %>
            <% } else { %>
        		<img src="<%=contextPath%>/images/user.png" alt="admin-pic">
            <% } %>
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
    <div class="user-table">
        <table class="table" id="user-table">
            <thead>
                <tr>
                    <td class="image">Image</td>
                    <td class="first-name">First Name</td>
                    <td class="last-name">Last Name</td>
                    <td class="address">Address</td>
                    <td class="gender">Gender</td>
                    <td class="email address">Email Address</td>
                    <td class="privilege">Privilege</td>
                </tr>
            </thead>
            <tbody>
            <% for (RegisterModel individualUser: user) { %>
                <tr>
                    <td class="image">
                    <%if(individualUser.getImageUrlFromPart() != null && !individualUser.getImageUrlFromPart().isEmpty()){ %>
                 		<img src="<%=contextPath%>/resources/user/<%= individualUser.getImageUrlFromPart()%>" alt="user-pic" class="user-pic">
                 	<% } else {%>                 
	             		<img src="<%=contextPath%>/images/user.png" alt="user-pic" class="user-pic">
                	<% } %>
                    </td>
                    <td class="first-name">
                        <p><%= individualUser.getFirstName() %></p>
                    </td>
                    <td class="last-name">
                        <p><%= individualUser.getLastName() %></p>
                    </td>

                    <td class="addredd">
                        <p><%= individualUser.getAddress() %></p>
                    </td>
                    <td class="gender">
                        <p><%= individualUser.getGender() %></p>
                    </td>
                    <td class="email-address">
                        <p><%= individualUser.getEmailAddress() %></p>
                    </td>
                    <td class="privilege">
                        <p class="privilege-text"><%= individualUser.getPrivilegeType() %></p>
                        <% if(cookieUsername != null && cookieUsername.equals("bikash200@gmail.com")) {%>
	                        <form action="<%=contextPath%>/userPrivilege" method="post" class="change-form">
	                            <select name="Privilege" id="privilege-option" style="display: none;">
	                                <option value="User">User</option>
	                                <option value="Admin">Admin</option>
	                            </select>
	                            <button type="button" class="change-btn">Change</button>
	                            <input type="hidden" name="username" value="<%= individualUser.getUsername()%>">
	                            <button type="submit" class="save-btn" style="display: none;">Save</button>
	                        </form>
	                    <% } %>
                    </td>
                </tr>  
                <% } %>          
            </tbody>
        </table>
    </div>
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


    document.addEventListener("DOMContentLoaded", function() {
        var changeBtns = document.querySelectorAll(".change-btn");
        var saveBtns = document.querySelectorAll(".save-btn");
        var privilegeTexts = document.querySelectorAll(".privilege-text");
        var privilegeSelects = document.querySelectorAll("#privilege-option");

        changeBtns.forEach(function(changeBtn, index) {
            changeBtn.addEventListener("click", function(event) {
                changeBtn.style.display = "none";
                saveBtns[index].style.display = "inline-block";
                privilegeTexts[index].style.display = "none";
                privilegeSelects[index].style.display = "inline-block";

                var currentPrivilege = privilegeTexts[index].textContent.trim();

                Array.from(privilegeSelects[index].options).forEach(function(option) {
                    if (option.value === currentPrivilege) {
                        option.selected = true;
                    }
                });

                event.preventDefault();
            });
        });
    });


    function hideMessage(element) {
	    element.parentNode.style.display = "none";
	}
</script>
</body>
</html>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.List" %>
<%@page import="utils.ShowLessWord"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="utils.StringUtils" %>
<%@ page import="utils.ShowLessWord" %>
<%@ page import="controller.database.DatabaseController" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.RegisterModel" %>
<%@ page import="model.ProductModel" %>
<%@ page import="java.util.Random" %>
<%@ page import="model.CartProductModel" %>
<%
	String contextPath = request.getContextPath();
	DatabaseController dbController = new DatabaseController();
	
	Map<String, List<ProductModel>> productsMap = dbController.getAllProducts();
    List<ProductModel> firstEightProducts = productsMap.get("firstEight");
    List<ProductModel> remainingProducts = productsMap.get("remaining");


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
    <title>Shop | E-commerce Website</title>
    <link rel="stylesheet" href="<%=contextPath%>/stylesheets/Shop.css">
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
        .button-group {
        	display: inline-block;
	    }
	    .button-group button {
	        display: inline-block;
	        margin-right: 5px;
	        background-color: #f0f0f0;
	        border: 1px solid #ccc;
	        padding: 5px 10px;
	        cursor: pointer;
	    }
	    .button-group button:hover {
	        background-color: #e0e0e0;
	    }
	    .filter-buttons {
   			text-align: center; 
		}
		.filter-buttons button {
		    background-color: #f0f0f0; 
		    border: none;
		    color: black; 
		    padding: 10px 20px; 
		    text-align: center; 
		    text-decoration: none; 
		    display: inline-block; 
		    font-size: 16px; 
		    cursor: pointer; 
		    margin-right: 10px; 
		}

		.filter-buttons button:last-child {
		    margin-right: 0;
		}
		
		.filter-buttons button:hover {
		    background-color: #45a049; 
		    color: white;
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
		.message-container {
		    position: absolute;
		    top: 25%;
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
                    <li><a href="<%=contextPath %>/pages/Shop.jsp" class="current">SHOP</a>
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
 <div class="body-section">
    <div class="container">
        <h2>Shop</h2>
        <div class="short-links">
            <i class="fa-solid fa-house"></i>
            <a href="<%=contextPath%>/Index.jsp">Home</a>
            <p style="color: rgb(142, 122, 122); font-weight: bold; margin-right: 7px; margin-top: 3px;">></p>
            <span>Shop</span>
        </div>
    </div>
 </div> 

<!-- Search-bar section -->
<div class="search-section">
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
        <div class="filter-section">
            <div class="search-bar">
                <form action="">
                    <input type="search" name="search" placeholder="Search....">
                    <input type="submit" value="&#x1F50D;">
                </form>
            </div>
            <div class="catrgory-bar">
                <form id="sortForm" action="<%=contextPath%>/filterProduct" method="get">
				    <label>Sort by Price:</label>
				    <div class="button-group">
				        <button type="submit" name="sort" value="Low to High">Low to High</button>
				        <button type="submit" name="sort" value="High to Low">High to Low</button>
				    </div>
				    <input type="hidden" name="sort" id="selectedSort">
				</form>
            </div>
        </div>
    </div>
</div>

<!-- Products Section -->
<div class="product-section">
    <div class="container">
        <div class="card">
            <div class="category-card">
            <form id="sortForm" action="<%=contextPath%>/filterProduct" method="get">
                <h4>Filter Price</h4>
                <div class="sub-category">
                    <ul>
                        <li>
                            <input type="checkbox" value="0 - 50000" name="filterPrice">
                            <p>0 - 50000</p>
                        </li>
                        <li>
                            <input type="checkbox" value="50000 - 80000" name="filterPrice">
                            <p>50000 - 80000</p>
                        </li>
                        <li>
                            <input type="checkbox" value="80000 - 100000" name="filterPrice">
                            <p>80000 - 100000</p>
                        </li>
                        <li>
                            <input type="checkbox" value="100000 - 150000" name="filterPrice">
                            <p>100000 - 150000</p>
                        </li>
                        <li>
                            <input type="checkbox" value="150000 - 200000" name="filterPrice">
                            <p>150000 - 200000</p>
                        </li>
                        <li>
                            <input type="checkbox" value="200000+" name="filterPrice">
                            <p>200000+</p>
                        </li>
                    </ul>
                </div>
                <h4>Category</h4>
                <div class="sub-category">
                    <ul>
                        <li>
                            <input type="checkbox" value="IOS" name="category">
                            <p>IOS</p>
                        </li>
                        <li>
                            <input type="checkbox" value="android" name="category">
                            <p>Android</p>
                        </li>
                    </ul>
                </div>
	            <div class="filter-buttons">
				    <button type="submit">Apply Filters</button>
				    <button type="reset">Reset Filters</button>
				</div> 
			</form>       
            </div>    
        	<div class="product-card">
		    	<div class="product">
        			<div class="row-1">
			            <% 
			                int maxItemsPerPage = 9; 
			                int totalPages = (int) Math.ceil((double) remainingProducts.size() / maxItemsPerPage);
			                int currentPage = 1;
			                String pageParam = request.getParameter("page");
			                if (pageParam != null) {
			                    currentPage = Integer.parseInt(pageParam);
			                }
			
			                int startIndex = (currentPage - 1) * maxItemsPerPage;
			                int endIndex = Math.min(startIndex + maxItemsPerPage, remainingProducts.size());
			
			                for (int i = startIndex; i < endIndex; i++) {
			                    ProductModel product = remainingProducts.get(i);
			            %>
	            		<div class="col-1">
			                <img src="<%=contextPath%>/resources/product/<%= product.getImageUrlFromPart()%>" alt="product-image">
			                <h2 class="phone-name"><%= product.getProductName() %></h2><br>               
			                <span style="display: inline-block; font-size: 20px; margin-bottom: 10px;">₹</span> 
			                <b style="display: inline-block; line-height: 25px; color: red; font-size: 19px;"><%= " "+product.getUnitPrice() %></b><br>
			                <strong style="display: inline-block; margin-bottom: 12px;">Stock:</strong>
			                <span style="display: inline-block; margin-bottom: 12px;" ><%= product.getStockQuantity() %></span><br>
			                <div class="star-rating" style="margin-bottom: 20px">
							    <% 
							        Random random = new Random();
							        int rating = random.nextInt(3) + 2; 
							        for(int a = 0; a < rating; a++) { %>
							            <span class="fa fa-star checked" style="color: red;"></span>
							    <% } %>
							    <% for(int a = rating; a < 5; a++) { %>
							            <span class="fa-regular fa-star"></span>
							    <% } %>
							</div>
					      	<%if (cookieUsername != null && !cookieUsername.isEmpty()) { %>
                        		<form action="<%= contextPath %>/addProduct" method="post">
		                    		<input type="hidden" name="productId" value="<%= product.getProductID()%>">
	                        		<input type="hidden" name="unitPrice" value="<%= product.getUnitPrice() %>">
	                        		<input type="hidden" name="productName" value="<%= product.getProductName()%>">
	                        		<input type="hidden" name="productImage" value="<%= product.getImageUrlFromPart()%>">
	                    			<button type="submit" class="btn">Add to cart &#8594;</button>
		                		</form>
                           	<%} else { %>
                           		<a href="<%= contextPath%>/pages/Login.jsp" class="btn">Add to cart &#8594;</a>
                           	<%} %>
						</div>
			            <% 
		                	if ((i + 1) % 3 == 0 && i != endIndex - 1) {
			            %>
        				</div>
			        <div class="row-1">
			            <% 
			                    }
			                } 
			            %>
			        </div>
    			</div>
			</div>	
        </div>        
	    <div class="page-btn">
		    <% for (int i = 1; i <= totalPages; i++) { %>
		        <a href="?page=<%= i %>" class="page-button"><%= i %></a>
		    <% } %>
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
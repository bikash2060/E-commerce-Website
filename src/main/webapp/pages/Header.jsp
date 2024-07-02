<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Header | E-commerce Website</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/Header.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"/>
</head>
<body>

<!-- Navbar Section -->
    <div class="navbar-section">
        <div class="container">
            <div class="nav-bar">
                <div class="logo-section">
                    <a href="#">
                        <img src="${pageContext.request.contextPath}/Images/Home page/Other Images/logo.png" alt="logo">
                    </a>
                </div>
                <div class="nav-links">
                    <div class="main-links">
                        <ul>
                            <li>
                                <a href="#" class="current">HOME</a>
                            </li>
                            <li>
                                <a href="#">SHOP</a>
                            </li>
                            <li>
                                <a href="#">CONTACT</a>
                            </li>
                        </ul>
                    </div>
                    <div class="cart-section">
                        <ul>
                            <li>
                                <a  href="#">
                                    <i class="fa-solid fa-cart-shopping fa-xl"></i>                                                            
                                </a>
                            </li>
                            <li>
                                <a href="#" class="login-icon" >
                                    <i class="fa-solid fa-user fa-user"></i>
                                </a>                                
                            </li>
                        </ul>
                    </div>
                </div>                
            </div>
        </div>
    </div>
</body>
</html>
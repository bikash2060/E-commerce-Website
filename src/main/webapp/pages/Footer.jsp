<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Footer | E-commerce Website</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/Footer.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"/>
</head>
<body>
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
                        <a href="index.html">HOME</a>
                    </li>
                    <li>
                        <a href="#">SHOP</a>
                    </li>
                    <li>
                        <a href="#">CONTACT</a>
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
                        <a href="#">LOG IN</a>
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
</body>
</html>
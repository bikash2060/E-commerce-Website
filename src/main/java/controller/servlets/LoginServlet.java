package controller.servlets;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import controller.database.DatabaseController;
import model.AdminModel;
import model.LoginModel;
import utils.RegistrationValidation;
import utils.StringUtils;

@WebServlet(asyncSupported = true, urlPatterns = {StringUtils.LOGIN_SERVLET})
public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	DatabaseController dbController = new DatabaseController();
       
    public LoginServlet() {
        super();
    }

    /*
     * This method handles the login process when login form data is submitted via an HTTP POST request.
     * It retrieves the username and password from the request parameters, validates.
     * It determines whether it's an admin or user login based on the username format, fetches login information from the database.
     * It sets session attributes and cookies for successful logins, and forwards the request to different pages with appropriate messages.
    */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String username = request.getParameter(StringUtils.USERNAME);
		String password = request.getParameter(StringUtils.PASSWORD);
		
		if((username == null || username.isEmpty()) || (password == null || password.isEmpty())) {
			request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.EMPTY_FIELD_ERROR_MESSAGE);
			request.getRequestDispatcher(StringUtils.LOGIN_URL).forward(request, response);
			return;
		}
		int result;
		if(RegistrationValidation.isValidEmail(username)) {
			AdminModel admin = new AdminModel(username, password);
			result = dbController.getAdminInfo(admin);
		}
		else{
			LoginModel registeredUser = new LoginModel(username, password);		
			result = dbController.getUserInfo(registeredUser);
		}
		switch(result) {
			case 1 -> {
			    HttpSession userSession = request.getSession();
			    userSession.setAttribute(StringUtils.USER, username);
			    userSession.setMaxInactiveInterval(60*30);
			    
			    String privilegeType = dbController.getPrivilege(username);
			    Cookie userCookie = new Cookie(StringUtils.USER, username);
			    userCookie.setMaxAge(60*30);
			    response.addCookie(userCookie);
			    request.setAttribute(StringUtils.SUCCESS_MESSAGE, StringUtils.SUCCESS_LOGIN_MESSAGE);
	
			    if (RegistrationValidation.isValidEmail(username) || "Admin".equals(privilegeType)) {
			        response.sendRedirect(request.getContextPath() + StringUtils.ADMIN_URL);
			    } else {
			        response.sendRedirect(request.getContextPath() + StringUtils.INDEX_URL);
			    }
			    break;
			}

			case 2 -> {
				request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.PASSWORD_NOT_MATCHED_MESSAGE);
				request.getRequestDispatcher(StringUtils.LOGIN_URL).forward(request, response);			
				break;
			}
			case -1 -> {
				request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.SERVER_ERROR_MESSAGE);
				request.getRequestDispatcher(StringUtils.LOGIN_URL).forward(request, response);	
				break;
			}
			case -2 -> {
				request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.ACCOUNT_NOT_FOUND_MESSAGE);
				request.getRequestDispatcher(StringUtils.LOGIN_URL).forward(request, response);		
				break;
			}
			default -> {
				request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.SERVER_ERROR_MESSAGE);
				request.getRequestDispatcher(StringUtils.LOGIN_URL).forward(request, response);
				break;
			}
		}
			
	}
}

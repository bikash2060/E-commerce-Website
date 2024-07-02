package controller.servlets;

import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import controller.database.DatabaseController;
import utils.RegistrationValidation;
import utils.StringUtils;

@WebServlet(asyncSupported = true, urlPatterns = {StringUtils.USER_PASSWORD_SERVLET})
public class UserPasswordServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	DatabaseController dbController = new DatabaseController();
       
    public UserPasswordServlet() {
        super();
    }

    /*
     * This method handles the POST request for updating user password.
     * It validates the input fields and checks if the old password matches the one stored in the database.
     * If the input is valid and the old password matches, it updates the user's password in the database.
     * It forwards the request to the user password page with appropriate messages based on the result.
    */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession userSession = request.getSession(false);
		String sessionValue = (String) userSession.getAttribute(StringUtils.USER);
		
		String oldPassword = request.getParameter(StringUtils.OLD_PASSWORD);
		String newPassword = request.getParameter(StringUtils.NEW_PASSWORD);
		String confirmPassword = request.getParameter(StringUtils.CONFIRM_PASSWORD);
		
		if((oldPassword == null || oldPassword.isEmpty()) || (newPassword == null || newPassword.isEmpty()) || 
		   (confirmPassword == null || confirmPassword.isEmpty())){
			request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.EMPTY_FIELD_ERROR_MESSAGE);
			request.getRequestDispatcher(StringUtils.USER_PASSWORD_URL).forward(request, response);
			return;
		}
		try {
	        if (!dbController.checkOldPassword(sessionValue,  oldPassword)) {
	            request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.OLD_PASSWORD_ERROR_MESSAGE);
	            request.getRequestDispatcher(StringUtils.USER_PASSWORD_URL).forward(request, response);
	            return;
	        }
	    } 
		catch (SQLException | ClassNotFoundException e) {
	        e.printStackTrace();
	    }
		
		if(!RegistrationValidation.isValidPassword(newPassword)) {
			request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.PASSWORD_ERROR_MESSAGE);
			request.getRequestDispatcher(StringUtils.USER_PASSWORD_URL).forward(request, response);
			return;
		}	
		
		if(newPassword.equals(confirmPassword)) {
			int result = dbController.updatePassword(sessionValue, newPassword);
			switch(result) {
				case 1 -> {
					request.setAttribute(StringUtils.SUCCESS_MESSAGE, StringUtils.PASSWORD_UPDATED_SUCCESSFULLY_MESSAGE);
					request.getRequestDispatcher(StringUtils.USER_PASSWORD_URL).forward(request, response);	
				}
				case 0 -> {
					request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.UPDATED_ERROR_MESSAGE);
					request.getRequestDispatcher(StringUtils.USER_PASSWORD_URL).forward(request, response);			
				}
				case -1 -> {
					request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.SERVER_ERROR_MESSAGE);
					request.getRequestDispatcher(StringUtils.USER_PASSWORD_URL).forward(request, response);			
				}
				default -> {
					request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.SERVER_ERROR_MESSAGE);
					request.getRequestDispatcher(StringUtils.USER_PASSWORD_URL).forward(request, response);
				}
			}			
		}
		else {
			request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.CONFIRMPASSWORD_ERROR_MESSAGE);
			request.getRequestDispatcher(StringUtils.USER_PASSWORD_URL).forward(request, response);
		}
	}
}

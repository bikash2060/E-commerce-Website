package controller.servlets;

import java.io.IOException;
import java.time.LocalDate;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import controller.database.DatabaseController;
import utils.RegistrationValidation;
import utils.StringUtils;
import model.RegisterModel;


@WebServlet(asyncSupported = true, urlPatterns = StringUtils.REGISTER_SERVLET)
public class RegisterServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	DatabaseController dbController = new DatabaseController();
    
    public RegisterServlet() {
        super();
    }
	
    /*
     * This method handles the user registration process when registration form data is submitted via an HTTP POST request.
     * It retrieves user input from request parameters, validates input fields, creates a new RegisterModel object. 
     * It forwards the request to different pages or redirects the user to the login page with appropriate error or 
     * success messages based on the registration result.
    */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String firstName = request.getParameter(StringUtils.FIRST_NAME);
		String lastName = request.getParameter(StringUtils.LAST_NAME);
		String gender = request.getParameter(StringUtils.GENDER);
		String emailAddress = request.getParameter(StringUtils.EMAIL_ADDRESS);
		String DOB = request.getParameter(StringUtils.DOB);
		String joinedDate = request.getParameter(StringUtils.JOINED_DATE);
		String address = request.getParameter(StringUtils.ADDRESS);
		String username = request.getParameter(StringUtils.USERNAME);
		String password = request.getParameter(StringUtils.PASSWORD);
		String phoneNumber = request.getParameter(StringUtils.PHONE_NUMBER);
		String confirmPassword = request.getParameter(StringUtils.CONFIRM_PASSWORD);
				
		if((firstName == null || firstName.isEmpty())|| (lastName == null || lastName.isEmpty()) || (emailAddress == null || 
		emailAddress.isEmpty()) || (DOB == null || DOB.isEmpty()) || (joinedDate == null || joinedDate.isEmpty())|| 
		(address == null || address.isEmpty()) || (username == null || username.isEmpty()) || 
		(phoneNumber == null || phoneNumber.isEmpty()) || (confirmPassword == null || confirmPassword.isEmpty())) {
			request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.EMPTY_FIELD_ERROR_MESSAGE);
			request.getRequestDispatcher(StringUtils.REGISTER_URL).forward(request, response);
			return;
		}
		
		if(!RegistrationValidation.isValidEmail(emailAddress)) {
			request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.EMAIL_ADDRESS_ERROR_MESSAGE);
			request.getRequestDispatcher(StringUtils.REGISTER_URL).forward(request, response);
			return;
		}
		if(!RegistrationValidation.isValidFirstName(firstName)) {
			request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.FIRST_NAME_ERROR_MESSAGE);
			request.getRequestDispatcher(StringUtils.REGISTER_URL).forward(request, response);
			return;
		}
		if(!RegistrationValidation.isValidLastName(lastName)) {
			request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.LAST_NAME_ERROR_MESSAGE);
			request.getRequestDispatcher(StringUtils.REGISTER_URL).forward(request, response);
			return;
		}
		if (!RegistrationValidation.isValidUsername(username)) {
			request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.USERNAME_VALID_ERROR_MESSAGE);
		    request.getRequestDispatcher(StringUtils.REGISTER_URL).forward(request, response);
		    return;
		}
		if(!RegistrationValidation.isValidPassword(password)) {
			request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.PASSWORD_ERROR_MESSAGE);
			request.getRequestDispatcher(StringUtils.REGISTER_URL).forward(request, response);
			return;
		}		
		if(!RegistrationValidation.isValidNumber(phoneNumber)) {
			request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.PHONE_NUMBER_ERROR_MESSAGE);
			request.getRequestDispatcher(StringUtils.REGISTER_URL).forward(request, response);
			return;
		}
		
		RegisterModel newUser = new RegisterModel(firstName, lastName, gender, emailAddress, LocalDate.parse(DOB), LocalDate.parse(joinedDate), address, username,
				password, phoneNumber);
		
		if(password.equals(confirmPassword)) {
			int result = dbController.registerUser(newUser);
			switch(result) {
				case 1 -> {
					request.setAttribute(StringUtils.SUCCESS_MESSAGE, StringUtils.SUCCESS_REGISTER_MESSAGE);
					response.sendRedirect(request.getContextPath() + StringUtils.LOGIN_URL);
					break;
				}
				case 0 -> {
					request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.REGISTER_ERROR_MESSAGE);
					request.getRequestDispatcher(StringUtils.REGISTER_URL).forward(request, response);	
					break;
				}
				case -1 -> {
					request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.SERVER_ERROR_MESSAGE);
					request.getRequestDispatcher(StringUtils.REGISTER_URL).forward(request, response);
					break;
				}
				case -2 -> {
					request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.USERNAME_ERROR_MESSAGE);
					request.getRequestDispatcher(StringUtils.REGISTER_URL).forward(request, response);		
					break;
				}
				case -3 -> {
					request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.EMAIL_ERROR_MESSAGE);
					request.getRequestDispatcher(StringUtils.REGISTER_URL).forward(request, response);
					break;
				}
				case -4 -> {
					request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.PHONE_ERROR_MESSAGE);
					request.getRequestDispatcher(StringUtils.REGISTER_URL).forward(request, response);
					break;
				}
				default -> {
					request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.SERVER_ERROR_MESSAGE);
					request.getRequestDispatcher(StringUtils.REGISTER_URL).forward(request, response);
					break;
				}
			}
		}
		else {
			request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.CONFIRMPASSWORD_ERROR_MESSAGE);
			request.getRequestDispatcher(StringUtils.REGISTER_URL).forward(request, response);
		}
	}
}
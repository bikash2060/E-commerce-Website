package controller.servlets;


import java.io.IOException;

import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import controller.database.DatabaseController;
import model.RegisterModel;
import utils.RegistrationValidation;
import utils.StringUtils;

@WebServlet(asyncSupported = true, urlPatterns = {StringUtils.USER_UPDATE_SERVLET})
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
maxFileSize = 1024 * 1024 * 10, // 10MB
maxRequestSize = 1024 * 1024 * 50)
public class UserUpdateServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	DatabaseController dbController = new DatabaseController();
	
	RegisterModel user = new RegisterModel();
	       
    public UserUpdateServlet() {
        super();
    }
    
    /*
     * This method handles the POST request for updating user profile information.
     * It retrieves user session data, user input from the form, and the image file if uploaded.
     * Then, it validates the input data and updates the user information in the database.
     * Finally, it forwards the request to the user profile page with appropriate messages based on the result.
    */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		HttpSession userSession = request.getSession(false);
		String sessionValue = (String) userSession.getAttribute(StringUtils.USER);
		
		String firstName = request.getParameter(StringUtils.FIRST_NAME);
		String lastName = request.getParameter(StringUtils.LAST_NAME);
		String emailAddress = request.getParameter(StringUtils.EMAIL_ADDRESS);
		String address = request.getParameter(StringUtils.ADDRESS);
		String phoneNumber = request.getParameter(StringUtils.PHONE_NUMBER);
		Part imagePart = request.getPart("image");
		
	    String imageUrl = null; 

	    if (imagePart != null && imagePart.getSize() > 0) {
	    	user.setImageUrlFromPart(imagePart);
	        String savePath = StringUtils.IMAGE_DIR_USER;
	        String fileName = user.getImageUrlFromPart();
	        
	        if(!fileName.isEmpty() && fileName != null) {
	        	imagePart.write(savePath + fileName);	        	
	        }
	        imageUrl = fileName;
	    }
	    else {
	    	imageUrl = dbController.getPreviousImageUrl(sessionValue);
	    }
	    
		if((firstName == null || firstName.isEmpty())|| (lastName == null || lastName.isEmpty())
			|| (address == null || address.isEmpty()) || (phoneNumber == null || phoneNumber.isEmpty()) ||
			(emailAddress == null || emailAddress.isEmpty())) {
			request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.EMPTY_FIELD_ERROR_MESSAGE);
			request.getRequestDispatcher(StringUtils.USER_PROFILE_URL).forward(request, response);
			return;
		}
		
		if(!RegistrationValidation.isValidFirstName(firstName)) {
			request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.FIRST_NAME_ERROR_MESSAGE);
			request.getRequestDispatcher(StringUtils.USER_PROFILE_URL).forward(request, response);
			return;
		}
		if(!RegistrationValidation.isValidLastName(lastName)) {
			request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.LAST_NAME_ERROR_MESSAGE);
			request.getRequestDispatcher(StringUtils.USER_PROFILE_URL).forward(request, response);
			return;
		}
		if(!RegistrationValidation.isValidEmail(emailAddress)) {
			request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.EMAIL_ADDRESS_ERROR_MESSAGE);
			request.getRequestDispatcher(StringUtils.USER_PROFILE_URL).forward(request, response);
			return;
		}
		if(!RegistrationValidation.isValidNumber(phoneNumber)) {
			request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.PHONE_NUMBER_ERROR_MESSAGE);
			request.getRequestDispatcher(StringUtils.USER_PROFILE_URL).forward(request, response);
			return;
		}
		
		try {
	        if (dbController.checkEmail(emailAddress, sessionValue)) {
	            request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.EMAIL_ERROR_MESSAGE);
	            request.getRequestDispatcher(StringUtils.USER_PROFILE_URL).forward(request, response);
	            return;
	        }
	    } 
		catch (SQLException | ClassNotFoundException e) {
	        e.printStackTrace();
	    }
		
		try {
	        if (dbController.checkNumber(phoneNumber, sessionValue)) {
	            request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.PHONE_ERROR_MESSAGE);
	            request.getRequestDispatcher(StringUtils.USER_PROFILE_URL).forward(request, response);
	            return;
	        }
	    } 
		catch (SQLException | ClassNotFoundException e) {
	        e.printStackTrace();
	    }
		
		int result = dbController.updateUser(sessionValue, firstName, lastName, emailAddress, address, phoneNumber, imageUrl);
		switch(result) {
			case 1 -> {
				request.setAttribute(StringUtils.SUCCESS_MESSAGE, StringUtils.SUCCESSFULLY_UPDATED_MESSAGE);
				request.getRequestDispatcher(StringUtils.USER_PROFILE_URL).forward(request, response);	
			}
			case 0 -> {
				request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.UPDATED_ERROR_MESSAGE);
				request.getRequestDispatcher(StringUtils.USER_PROFILE_URL).forward(request, response);			
			}
			case -1 -> {
				request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.SERVER_ERROR_MESSAGE);
				request.getRequestDispatcher(StringUtils.USER_PROFILE_URL).forward(request, response);			
			}
			default -> {
				request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.SERVER_ERROR_MESSAGE);
				request.getRequestDispatcher(StringUtils.USER_PROFILE_URL).forward(request, response);
			}
		}
	}	
}

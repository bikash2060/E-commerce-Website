package controller.servlets;

import java.io.IOException;
import utils.StringUtils;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import controller.database.DatabaseController;

@WebServlet(asyncSupported = true, urlPatterns = {StringUtils.USER_PRIVILEGE_SERVLET})
public class UserPrivilegeServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
   
	DatabaseController dbController = new DatabaseController();
    public UserPrivilegeServlet() {
        super();
    }

    
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String username = request.getParameter("username");
		String privilegeType = request.getParameter("Privilege");
		
		boolean privilegeChangeable = dbController.checkPrivilegeType();
		
		if("Admin".equals(privilegeType)) {
			if(privilegeChangeable) {
				int result = dbController.changePrivilegeType(privilegeType, username);
				switch(result) {
				case 1:
					request.setAttribute(StringUtils.SUCCESS_MESSAGE, StringUtils.PRIVILEGE_SUCCESS_MESSAGE);
					request.getRequestDispatcher(StringUtils.USER_MANAGEMENT_URL).forward(request, response);
					break;
				case 0:
					request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.PRIVILEGE_ERROR_MESSAGE);
					request.getRequestDispatcher(StringUtils.USER_MANAGEMENT_URL).forward(request, response);
					break;
				case -1:
					request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.SERVER_ERROR_MESSAGE);
					request.getRequestDispatcher(StringUtils.USER_MANAGEMENT_URL).forward(request, response);
					break;
				default:
					request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.SERVER_ERROR_MESSAGE);
					request.getRequestDispatcher(StringUtils.USER_MANAGEMENT_URL).forward(request, response);
					break;
				}
			}
			else {
				request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.PRIVILEGE_NUMBER_ERROR_MESSAGE);
				request.getRequestDispatcher(StringUtils.USER_MANAGEMENT_URL).forward(request, response);
				
			}			
		}
		else {
			int result = dbController.deletePrivilegeType(privilegeType, username);
			switch(result) {
			case 1:
				request.setAttribute(StringUtils.SUCCESS_MESSAGE, StringUtils.PRIVILEGE_SUCCESS_MESSAGE);
				request.getRequestDispatcher(StringUtils.USER_MANAGEMENT_URL).forward(request, response);
				break;
			case 0:
				request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.PRIVILEGE_ERROR_MESSAGE);
				request.getRequestDispatcher(StringUtils.USER_MANAGEMENT_URL).forward(request, response);
				break;
			case -1:
				request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.SERVER_ERROR_MESSAGE);
				request.getRequestDispatcher(StringUtils.USER_MANAGEMENT_URL).forward(request, response);
				break;
			default:
				request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.SERVER_ERROR_MESSAGE);
				request.getRequestDispatcher(StringUtils.USER_MANAGEMENT_URL).forward(request, response);
				break;
			}
		}
		
	}
	
}

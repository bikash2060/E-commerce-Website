package controller.servlets;

import java.io.IOException;
import utils.StringUtils;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import controller.database.DatabaseController;

@WebServlet(asyncSupported = true, urlPatterns = { StringUtils.ORDER_STATUS_SERVLET })
public class UpdateOrderStatusServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	DatabaseController dbController = new DatabaseController();
       
    public UpdateOrderStatusServlet() {
        super();
    }

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String orderIDStr = request.getParameter("orderID");
		int orderID = Integer.parseInt(orderIDStr);
		String orderStatus = request.getParameter("change-status");
		
		int result = dbController.changeOrderStatus(orderStatus, orderID);
		switch(result) {
		case 1:
			request.setAttribute(StringUtils.SUCCESS_MESSAGE, StringUtils.ORDER_STATUS_SUCCESS_MESSAGE);
			request.getRequestDispatcher(StringUtils.ADMIN_URL).forward(request, response);
			break;
		case 0:
			request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.ORDER_STATUS_ERROR_MESSAGE);
			request.getRequestDispatcher(StringUtils.ADMIN_URL).forward(request, response);
			break;
		case -1:
			request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.SERVER_ERROR_MESSAGE);
			request.getRequestDispatcher(StringUtils.ADMIN_URL).forward(request, response);
			break;
		default:
			request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.SERVER_ERROR_MESSAGE);
			request.getRequestDispatcher(StringUtils.ADMIN_URL).forward(request, response);
			break;
		}
	}

}

package controller.servlets;

import java.io.IOException;


import utils.StringUtils;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import controller.database.DatabaseController;

@WebServlet(asyncSupported = true, urlPatterns = { StringUtils.REMOVE_PRODUCT_SERVLET })
public class RemoveProducts extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	DatabaseController dbController = new DatabaseController();

    public RemoveProducts() {
        super();
    }

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String productID = request.getParameter(StringUtils.PRODUCT_ID);
		int product = Integer.parseInt(productID);
		boolean checked = dbController.checkProductID(product);
		
		if(checked) {
			request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.PRODUCT_DELETE_ERROR_MESSAGE);
	        request.getRequestDispatcher(StringUtils.VIEW_PRODUCT_URL).forward(request, response);
		}
		else {
			dbController.deleteProductsFromOrders(product);
			int result = dbController.deleteProductsFromProduct(product);
	        switch(result) {
	        case 1:
	        	request.setAttribute(StringUtils.SUCCESS_MESSAGE, StringUtils.PRODUCT_DELETE_SUCCESS_MESSAGE);
		        request.getRequestDispatcher(StringUtils.VIEW_PRODUCT_URL).forward(request, response);
		        break;
		    case 0:
		    	request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.PRODUCT_DELETE_ERROR_MESSAGE);
		        request.getRequestDispatcher(StringUtils.VIEW_PRODUCT_URL).forward(request, response);
		        break;
		    case -1:
		    	request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.SERVER_ERROR_MESSAGE);
		        request.getRequestDispatcher(StringUtils.VIEW_PRODUCT_URL).forward(request, response);
		        break;
		    default:
		        request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.SERVER_ERROR_MESSAGE);
		        request.getRequestDispatcher(StringUtils.VIEW_PRODUCT_URL).forward(request, response);
		        break;
	        }
		}
	}
}


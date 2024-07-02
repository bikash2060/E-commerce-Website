package controller.servlets;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import controller.database.DatabaseController;
import model.CartModel;
import utils.StringUtils;


@WebServlet(asyncSupported = true, urlPatterns = {StringUtils.DELETE_CART_ITEMS_SERVLET })
public class RemoveItemsServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	DatabaseController dbController = new DatabaseController();
	CartModel userCart;
	
    public RemoveItemsServlet() {
        super();
    }
    
    /*
     * This method handles the deletion of a product from the user's cart when the user submits a form via an HTTP POST request.
     * It retrieves session information to get the userID, retrieves product details from the request parameters.
     * It gets the cart ID for the user, deletes the product from the cart.
     * It forwards the request with appropriate messages based on the result.
    */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		HttpSession userSession = request.getSession(false);
		String sessionValue = (String) userSession.getAttribute(StringUtils.USER); 
		
		int userID = dbController.getUserID(sessionValue);
		
		String productID = request.getParameter("productId");
		int productId = Integer.parseInt(productID);
		
		int cartID = dbController.returnUserCart(userID);
		
		int result = dbController.deleteCartItems(productId, cartID);
		
		switch(result) {
		case 1:
			userCart = dbController.getUserCartSummary(sessionValue);
			dbController.insertCartValues(userCart);
			request.setAttribute(StringUtils.SUCCESS_MESSAGE, StringUtils.PRODUCT_DELETED_SUCCESS_MESSAGE);
			response.sendRedirect(request.getContextPath() + StringUtils.CART_PAGE_URL);
	        break;
	    case 0:
	        request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.PRODUCTT_DELETED_ERROR_MESSAGE);
	        request.getRequestDispatcher(StringUtils.CART_PAGE_URL).forward(request, response);
	        break;
	    case -1:
	    	request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.SERVER_ERROR_MESSAGE);
	        request.getRequestDispatcher(StringUtils.CART_PAGE_URL).forward(request, response);
	        break;
	    default:
	        request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.SERVER_ERROR_MESSAGE);
	        request.getRequestDispatcher(StringUtils.CART_PAGE_URL).forward(request, response);
	        break;
	
		}
	}
}

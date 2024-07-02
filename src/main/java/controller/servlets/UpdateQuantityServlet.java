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

@WebServlet(asyncSupported = true, urlPatterns = {StringUtils.UPDATE_QUANTITY_SERVLET })
public class UpdateQuantityServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	DatabaseController dbController = new DatabaseController();
       
    public UpdateQuantityServlet() {
        super();
    }

    /*
     * This method handles the updating of quantity for a product in the cart when the user submits a form via an HTTP POST request.
     * It retrieves session information to get the userID, retrieves quantity and product details from the request parameters.
     * It calculates the line total, gets the cart ID for the user, updates the quantity for the product in the cart.
     * It forwards the request with appropriate messages based on the result.
    */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		 
		HttpSession userSession = request.getSession(false);
		String sessionValue = (String) userSession.getAttribute(StringUtils.USER); 
		
		String quantity = request.getParameter("quantity");
	    int quantityValue = Integer.parseInt(quantity);
		
	    String productID = request.getParameter("productID");
	    int productId = Integer.parseInt(productID);
		
	    String unitPriceStr = request.getParameter("price");
		double unitPrice = Double.parseDouble(unitPriceStr);
		
		double lineTotal = quantityValue * unitPrice;
		
	    int userID = dbController.getUserID(sessionValue);
		
		int cartID = dbController.returnUserCart(userID);
	    
		int result = dbController.updateQuantity(quantityValue, lineTotal, productId, cartID);
		
		switch(result) {
			case 1:
				CartModel userCart = dbController.getUserCartSummary(sessionValue);
				dbController.insertCartValues(userCart);
				request.setAttribute(StringUtils.SUCCESS_MESSAGE, StringUtils.QUANTITY_UPDATED_SUCCESSFULLY);
				response.sendRedirect(request.getContextPath() + StringUtils.CART_PAGE_URL);
		        break;
		    case 0:
		        request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.QUANTITY_UPDATED_ERROR_MESSAGE);
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

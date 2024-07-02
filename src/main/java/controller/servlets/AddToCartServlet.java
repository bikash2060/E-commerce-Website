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
import model.CartProductModel;
import utils.StringUtils;

@WebServlet(asyncSupported = true, urlPatterns = {StringUtils.ADD_TO_CART_SERVLET })
public class AddToCartServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	DatabaseController dbController = new DatabaseController();
	CartProductModel cart;
	CartModel userCart;
       
    public AddToCartServlet() {
        super();
    }
    
    /*
     * This method handles the addition of a product to the user's cart when the user submits a form via an HTTP POST request.
     * It retrieves session information to get the userID, checks if the user has a cart, retrieves product details from the request parameters.
     * It creates a cart if the user doesn't have one
     * Then it adds the product to the cart, and forwards the request with appropriate messages based on the result.
    */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession userSession = request.getSession(false);
		String sessionValue = (String) userSession.getAttribute(StringUtils.USER);
		int userID = dbController.getUserID(sessionValue); 
		
		boolean userHasCart = dbController.checkUserCart(userID);

		String productID = request.getParameter("productId");
		int productId = Integer.parseInt(productID);
		
		String unitPriceStr = request.getParameter("unitPrice");
		double unitPrice = Double.parseDouble(unitPriceStr);
		
		String image = request.getParameter("productImage");
		String name = request.getParameter("productName");
		
		int defaultQuantity = 1;
		double lineTotal = unitPrice * defaultQuantity;
		
		if(!userHasCart) {
			dbController.createCart(userID);
			int userCartID = dbController.returnUserCart(userID);
			cart = new CartProductModel(userCartID, productId, image, name, unitPrice, defaultQuantity, lineTotal);
			int result = dbController.addProductTocart(cart);
			
			switch(result) {
				case 1:
					userCart = dbController.getUserCartSummary(sessionValue);
					dbController.insertCartValues(userCart);
					HttpSession session = request.getSession();
			        session.setAttribute(StringUtils.SUCCESS_MESSAGE, StringUtils.PRODUCT_ADDED_SUCCESSFULLY_MESSAGE);
			        response.sendRedirect(request.getContextPath() + StringUtils.PRODUCT_PAGE_URL); 
			        break;
			    case 0:
			        request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.PRODUCT_ADDED_FAILED_MESSAGE);
			        request.getRequestDispatcher(StringUtils.PRODUCT_PAGE_URL).forward(request, response);
			        break;
			    case -1:
			    	request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.SERVER_ERROR_MESSAGE);
			    	request.getRequestDispatcher(StringUtils.PRODUCT_PAGE_URL).forward(request, response);
			        break;
			    default:
			        request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.SERVER_ERROR_MESSAGE);
			        request.getRequestDispatcher(StringUtils.PRODUCT_PAGE_URL).forward(request, response);
			        break;
			}
		}
		else {
			int userCartID = dbController.returnUserCart(userID);
			cart = new CartProductModel(userCartID, productId, image, name, unitPrice, defaultQuantity, lineTotal);
			int result = dbController.addProductTocart(cart);
			userCart = dbController.getUserCartSummary(sessionValue);
			dbController.insertCartValues(userCart);
			switch(result) {
				case 1:
					request.setAttribute(StringUtils.SUCCESS_MESSAGE, StringUtils.PRODUCT_ADDED_SUCCESSFULLY_MESSAGE);
			        request.getRequestDispatcher(StringUtils.PRODUCT_PAGE_URL).forward(request, response); 
			        break;
			    case 0:
			        request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.PRODUCT_ADDED_FAILED_MESSAGE);
			        request.getRequestDispatcher(StringUtils.PRODUCT_PAGE_URL).forward(request, response);
			        break;
			    case -1:
			    	request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.SERVER_ERROR_MESSAGE);
			        request.getRequestDispatcher(StringUtils.PRODUCT_PAGE_URL).forward(request, response);
			        break;
			    default:
			        request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.SERVER_ERROR_MESSAGE);
			        request.getRequestDispatcher(StringUtils.PRODUCT_PAGE_URL).forward(request, response);
			        break;
			}
		}
	}	
}

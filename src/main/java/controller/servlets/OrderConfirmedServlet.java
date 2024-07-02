package controller.servlets;

import java.io.IOException;

import java.time.LocalDate;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import controller.database.DatabaseController;
import model.CartModel;
import model.OrdersModel;
import utils.StringUtils;

@WebServlet(asyncSupported = true, urlPatterns = { StringUtils.ORDER_CONFIRM_SERVLET})
public class OrderConfirmedServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    
	DatabaseController dbController = new DatabaseController();
	CartModel userCart;

    public OrderConfirmedServlet() {
        super();
    }

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession userSession = request.getSession(false);
		String sessionValue = (String) userSession.getAttribute(StringUtils.USER);
		int userID = dbController.getUserID(sessionValue); 
		
		String totalAmountStr = request.getParameter(StringUtils.TOTAL_AMOUNT);
		String discountAmountStr = request.getParameter(StringUtils.DISCOUNT_AMOUNT);
		String grandTotalAmountStr = request.getParameter(StringUtils.GRAND_TOTAL_AMOUNT);
		
		LocalDate orderDate = LocalDate.now();
		double totalAmount = Double.parseDouble(totalAmountStr);
		double discountAmount = Double.parseDouble(discountAmountStr);
		double grandTotalAmount = Double.parseDouble(grandTotalAmountStr);
		String defaultOrderStatus = "Pending";
		String paymentMethod = request.getParameter(StringUtils.PAYMENT);
		String shippingAddress = request.getParameter(StringUtils.SHIPPING_ADDRESS);
		int userCartID = dbController.returnUserCart(userID);
		
		if((shippingAddress == null || shippingAddress.isEmpty())) {
			request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.SHIPPING_ADDRESS_ERROR_MESSAGE);
			request.getRequestDispatcher(StringUtils.ORDER_PAGE_URL).forward(request, response);
			return;
		}
		
		if((paymentMethod == null || paymentMethod.isEmpty())) {
			request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.PAYMENT_METHOD_ERROR_MESSAGE);
			request.getRequestDispatcher(StringUtils.ORDER_PAGE_URL).forward(request, response);
			return;
		}
		
		OrdersModel newOrder = new OrdersModel(orderDate, totalAmount, discountAmount, grandTotalAmount, defaultOrderStatus, 
				paymentMethod, shippingAddress, userCartID);
		
		int result = dbController.saveOrders(newOrder);
		
		switch(result) {
			case 1 -> {
				dbController.insertOrdersLine(sessionValue);
				dbController.deleteUserCartItems(userCartID);
				userCart = dbController.getUserCartSummary(sessionValue);
				dbController.insertCartValues(userCart);
				request.setAttribute(StringUtils.SUCCESS_MESSAGE, StringUtils.ORDER_PLACED_SUCCESS_MESSAGE);
				response.sendRedirect(request.getContextPath() + StringUtils.INVOICE_PAGE_URL);
				break;
			}
			case 0 -> {
				request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.ORDER_PLACES_ERROR_MESSAGE);
				request.getRequestDispatcher(StringUtils.ORDER_PAGE_URL).forward(request, response);	
				break;
			}
			case -1 -> {
				request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.SERVER_ERROR_MESSAGE);
				request.getRequestDispatcher(StringUtils.ORDER_PAGE_URL).forward(request, response);
				break;
			}
			default -> {
				request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.SERVER_ERROR_MESSAGE);
				request.getRequestDispatcher(StringUtils.REGISTER_URL).forward(request, response);
				break;
			}
		
		}
	}
}

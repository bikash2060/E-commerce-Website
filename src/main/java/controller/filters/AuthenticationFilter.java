package controller.filters;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import controller.database.DatabaseController;
import utils.StringUtils;

public class AuthenticationFilter implements Filter{
	DatabaseController dbController = new DatabaseController();

	@Override
	public void init(FilterConfig arg0) throws ServletException {
		
	}
	
	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {
		
		HttpServletRequest req = (HttpServletRequest) request;
		HttpServletResponse res = (HttpServletResponse) response;
		
		String uri = req.getRequestURI();
		
		if (uri.endsWith(".css") || uri.endsWith(".png") || uri.endsWith(".jpg")) {
	        chain.doFilter(request, response);
	        return;
	    }
	    
	    // JSP
		boolean isIndexPage = uri.endsWith(StringUtils.INDEX_URL);
	    boolean isAddProductPage = uri.endsWith(StringUtils.ADD_PRODUCT_URL);
	    boolean isAdminPage = uri.endsWith(StringUtils.ADMIN_URL);
	    boolean isCartPage = uri.endsWith(StringUtils.CART_PAGE_URL);
	    boolean isInvoicePage = uri.endsWith(StringUtils.INVOICE_PAGE_URL);
	    boolean isLoginPage = uri.endsWith(StringUtils.LOGIN_URL);
	    boolean isOrderPage = uri.endsWith(StringUtils.ORDER_PAGE_URL);
	    boolean isProfilePage = uri.endsWith(StringUtils.USER_PROFILE_URL);
	    boolean isProductDetails = uri.endsWith(StringUtils.UPDATE_PRODUCT_URL);
	    boolean isUserManagementPage = uri.endsWith(StringUtils.USER_MANAGEMENT_URL);
	    boolean isUserPassword = uri.endsWith(StringUtils.USER_PASSWORD_URL);
	    boolean isProductPage = uri.endsWith(StringUtils.VIEW_PRODUCT_URL);	    	 
	    boolean isRegisterPage = uri.endsWith(StringUtils.REGISTER_URL);
	    
    	HttpSession session = req.getSession(false); 
    	boolean isLoggedIn = session != null && session.getAttribute(StringUtils.USER) != null;
    	
    	// Applying filter when user trying to access resources withou logging
    	if(!isLoggedIn && (isAddProductPage || isAdminPage || isCartPage || isInvoicePage || isOrderPage || isProfilePage || isProductDetails
	    		|| isUserPassword || isProductPage || isUserManagementPage)) {
	    	res.sendRedirect(req.getContextPath() + StringUtils.LOGIN_URL);
	    	return;
	    }
    	
    	if(isLoggedIn && (isLoginPage || isRegisterPage|| isAdminPage || isProductDetails || isProductPage || isUserManagementPage )) {
    		res.sendRedirect(req.getContextPath() + StringUtils.INDEX_URL);
	    	return;
    	}
    	
    	
        chain.doFilter(request, response);

	}
	
	@Override
	public void destroy() {
				
	}
}

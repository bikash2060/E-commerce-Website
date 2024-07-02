package controller.servlets;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import controller.database.DatabaseController;
import model.ProductModel;
import utils.StringUtils;

@WebServlet(asyncSupported = true, urlPatterns = { StringUtils.FILTER_PRODUCT_SERVLET })
public class FilterProduct extends HttpServlet {
	private static final long serialVersionUID = 1L;

	DatabaseController dbController = new DatabaseController();

	public FilterProduct() {
		super();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
	        throws ServletException, IOException {
	    String sortOrder = request.getParameter(StringUtils.SORT_NUMBER);
	    String orderBy = sortOrder != null && sortOrder.equals("Low to High") ? "ASC" : "DESC";

	    Map<String, List<ProductModel>> productsMap = dbController.getAllProducts();
	    List<ProductModel> remainingProducts = productsMap.get("remaining");

	    if (sortOrder != null && !sortOrder.isEmpty()) {
	        if (orderBy.equals("ASC")) {
	            Collections.sort(remainingProducts, Comparator.comparing(ProductModel::getUnitPrice));
	        } else {
	        	Collections.sort(remainingProducts, Comparator.comparing(ProductModel::getUnitPrice).reversed());
	        }
	        request.setAttribute("productsList", remainingProducts);
	        request.getRequestDispatcher(StringUtils.PRODUCT_PAGE_URL).forward(request, response);
	    } else {
	        request.setAttribute("productsList", remainingProducts);
	        request.getRequestDispatcher(StringUtils.PRODUCT_PAGE_URL).forward(request, response);
	    }
	}
}

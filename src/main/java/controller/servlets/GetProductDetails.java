package controller.servlets;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.ProductModel;
import utils.StringUtils;

@WebServlet(asyncSupported = true, urlPatterns = {StringUtils.GET_PRODUCT_DETAILS_SERVLET })
public class GetProductDetails extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public GetProductDetails() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String productId = request.getParameter("productId");
        String productName = request.getParameter("productName");
        String unitPrice = request.getParameter("unitPrice");
        double unitPriceNumeric = Double.valueOf(unitPrice);
        String quantity = request.getParameter("quantity");
        int quantityNumeric = Integer.parseInt(quantity);
        String productImage = request.getParameter("productImage");
        String description = request.getParameter("description");
        String brand = request.getParameter("brand");

        
        ProductModel productInfo = new ProductModel();
        productInfo.setProductID(Integer.parseInt(productId));
        productInfo.setProductName(productName);
        productInfo.setUnitPrice(unitPriceNumeric);
        productInfo.setStockQuantity(quantityNumeric);
        productInfo.setImageUrlFromDB(productImage);
        productInfo.setDescription(description);;
        productInfo.setBrandName(brand);
        
        HttpSession session = request.getSession();
        session.setAttribute("productInfo", productInfo);
        
        request.getRequestDispatcher(StringUtils.UPDATE_PRODUCT_URL).forward(request, response);;
    }

}


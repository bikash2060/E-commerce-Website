package controller.servlets;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import controller.database.DatabaseController;
import model.ProductModel;
import utils.StringUtils;

@WebServlet(asyncSupported = true, urlPatterns = { StringUtils.ADD_NEW_PRODUCT_SERVLET })
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
maxFileSize = 1024 * 1024 * 10, // 10MB
maxRequestSize = 1024 * 1024 * 50)
public class AddNewProduct extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	DatabaseController dbController = new DatabaseController();
       
    public AddNewProduct() {
        super();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String productName = request.getParameter("product-name");
        String description = request.getParameter("description");
        String unitPriceStr = request.getParameter("unit-price");
        String quantityStr = request.getParameter("quantity");
        String category = request.getParameter("category");
        Part imagePart = request.getPart("image");
        String brand = request.getParameter("brand");


        if (productName == null || productName.isEmpty() ||
            description == null || description.isEmpty() ||
            unitPriceStr == null || unitPriceStr.isEmpty() ||
            quantityStr == null || quantityStr.isEmpty()) {
            request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.EMPTY_FIELD_ERROR_MESSAGE);
            request.getRequestDispatcher(StringUtils.ADD_PRODUCT_URL).forward(request, response);
            return;
        }

        if (imagePart == null || imagePart.getSize() == 0) {
            request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.NO_IMAGE_ERROR_MESSAGE);
            request.getRequestDispatcher(StringUtils.ADD_PRODUCT_URL).forward(request, response);
            return;
        }

        double unitPrice;
        try {
            unitPrice = Double.parseDouble(unitPriceStr);
            if (unitPrice <= 0) {
                request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.UNIT_PRICE_ERROR_MESSAGE);
                request.getRequestDispatcher(StringUtils.ADD_PRODUCT_URL).forward(request, response);
                return;
            }
        } catch (NumberFormatException e) {
            request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.INVALID_NUMBER_ERROR_MESSAGE);
            request.getRequestDispatcher(StringUtils.ADD_PRODUCT_URL).forward(request, response);
            return;
        }

        int quantity;
        try {
            quantity = Integer.parseInt(quantityStr);
            if (quantity <= 0) {
                request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.QUANTITY_ERROR_MESSAGE);
                request.getRequestDispatcher(StringUtils.ADD_PRODUCT_URL).forward(request, response);
                return;
            }
        } catch (NumberFormatException e) {
            request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.QUANTITY_ERROR_MESSAGE);
            request.getRequestDispatcher(StringUtils.ADD_PRODUCT_URL).forward(request, response);
            return;
        }
        
        boolean isExist = dbController.getProductName(productName);
        if(isExist) {
        	request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.PRODUCT_DUPLICATE_ERROR_MESSAGE);
            request.getRequestDispatcher(StringUtils.ADD_PRODUCT_URL).forward(request, response);
            return;
        }
        
        int getCategoryID = dbController.getCategoryID(category);
        
        ProductModel newProducts = new ProductModel(productName, description, unitPrice, quantity, getCategoryID,
        		imagePart, brand);
        
        int result = dbController.insertProducts(newProducts);
        switch(result) {
			case 1 -> {
				String fileName = newProducts.getImageUrlFromPart();
				
				if(!fileName.isEmpty() && fileName != null) {
					String savePath = StringUtils.IMAGE_DIR_PRODUCT;
					imagePart.write(savePath + fileName);					
				}
				request.setAttribute(StringUtils.SUCCESS_MESSAGE, StringUtils.PRODUCT_ADDEDD_SECCESS_MESSAGE);
			    request.getRequestDispatcher(StringUtils.ADD_PRODUCT_URL).forward(request, response); 
			}
			case 0 -> {
				request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.PRODUCT_ADDEDD_ERROR_MESSAGE);
				request.getRequestDispatcher(StringUtils.ADD_PRODUCT_URL).forward(request, response);			
			}
			case -1 -> {
				request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.SERVER_ERROR_MESSAGE);
				request.getRequestDispatcher(StringUtils.ADD_PRODUCT_URL).forward(request, response);			
			}
			default -> {
				request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.SERVER_ERROR_MESSAGE);
				request.getRequestDispatcher(StringUtils.ADD_PRODUCT_URL).forward(request, response);
			}
        }
    }
}

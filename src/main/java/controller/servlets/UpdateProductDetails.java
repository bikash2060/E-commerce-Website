package controller.servlets;

import java.io.IOException;
import utils.StringUtils;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import controller.database.DatabaseController;
import model.ProductModel;

@WebServlet(asyncSupported = true, urlPatterns = {StringUtils.UPDATE_PRODUCT_DETAILS_SERVLET })
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
maxFileSize = 1024 * 1024 * 10, // 10MB
maxRequestSize = 1024 * 1024 * 50)
public class UpdateProductDetails extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	ProductModel product = new ProductModel();
	
	DatabaseController dbController = new DatabaseController();
       
    public UpdateProductDetails() {
        super();
    }

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String productID = request.getParameter("productID");
		int productId = Integer.parseInt(productID);
		String productName = request.getParameter("product-name");
        String productDescription = request.getParameter("product-description");
        String price = request.getParameter("price");
        String stockQuantity = request.getParameter("stock-quantity");
        String category = request.getParameter("category");
        String brand = request.getParameter("brand");
		Part imagePart = request.getPart("image");

		
		String imageUrl = null; 

	    if (imagePart != null && imagePart.getSize() > 0) {
	    	product.setImageUrlFromPart(imagePart);
	        String savePath = StringUtils.IMAGE_DIR_PRODUCT;
	        String fileName = product.getImageUrlFromPart();
	        
	        if(!fileName.isEmpty() && fileName != null) {
	        	imagePart.write(savePath + fileName);	        	
	        }
	        imageUrl = fileName;
	    }
	    else {
	    	imageUrl = dbController.getProductPreviousImageUrl(productId);
	    }
	    
	    if(stockQuantity == null || stockQuantity.isEmpty() || price == null || price.isEmpty()) {
	    	request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.EMPTY_FIELD_ERROR_MESSAGE);
            request.getRequestDispatcher(StringUtils.UPDATE_PRODUCT_URL).forward(request, response);
            return;
	    }
	    
	    int quantity;
        try {
            quantity = Integer.parseInt(stockQuantity);
            if (quantity <= 0) {
                request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.QUANTITY_ERROR_MESSAGE);
                request.getRequestDispatcher(StringUtils.UPDATE_PRODUCT_URL).forward(request, response);
                return;
            }
        } catch (NumberFormatException e) {
            request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.QUANTITY_ERROR_MESSAGE);
            request.getRequestDispatcher(StringUtils.UPDATE_PRODUCT_URL).forward(request, response);
            return;
        }
	    
	    double unitPrice;
        try {
            unitPrice = Double.parseDouble(price);
            if (unitPrice <= 0) {
                request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.UNIT_PRICE_ERROR_MESSAGE);
                request.getRequestDispatcher(StringUtils.UPDATE_PRODUCT_URL).forward(request, response);
                return;
            }
        } catch (NumberFormatException e) {
            request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.INVALID_NUMBER_ERROR_MESSAGE);
            request.getRequestDispatcher(StringUtils.UPDATE_PRODUCT_URL).forward(request, response);
            return;
        }
        
        int result = dbController.updateProduct(productName, productDescription, unitPrice, quantity, brand, imageUrl, productId);
        switch(result) {
		case 1 -> {
			request.setAttribute(StringUtils.SUCCESS_MESSAGE, StringUtils.PRODUCT_UPDATED_SUCCESSFULLY_MESSAGE);
			request.getRequestDispatcher(StringUtils.UPDATE_PRODUCT_URL).forward(request, response);	
		}
		case 0 -> {
			request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.PRODUCT_UPDATED_ERROR_MESSAGE);
			request.getRequestDispatcher(StringUtils.UPDATE_PRODUCT_URL).forward(request, response);			
		}
		case -1 -> {
			request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.SERVER_ERROR_MESSAGE);
			request.getRequestDispatcher(StringUtils.UPDATE_PRODUCT_URL).forward(request, response);			
		}
		default -> {
			request.setAttribute(StringUtils.ERROR_MESSAGE, StringUtils.SERVER_ERROR_MESSAGE);
			request.getRequestDispatcher(StringUtils.UPDATE_PRODUCT_URL).forward(request, response);
		}
	}
       
		
	}

}

package model;

import java.io.File;
import java.io.Serializable;

import javax.servlet.http.Part;

import utils.StringUtils;

public class ProductModel implements Serializable{
	private static final long serialVersionUID = 1L;
	
	private int productID;
	private String product_name;
	private String description;
	private double unit_price;
	private int stock_quantity;
	private int category_ID;
	private String imageUrlFromPart;
	private String brandName;
	

	public ProductModel() {}
	
	public ProductModel(String product_name, String description, double unit_price, int stock_quantity, int category_ID,
			Part imagePrt, String brand) {
		super();
		this.product_name = product_name;
		this.description = description;
		this.unit_price = unit_price;
		this.stock_quantity = stock_quantity;
		this.category_ID = category_ID;
		this.imageUrlFromPart = getImageUrl(imagePrt);
		this.brandName= brand;		
	}
	
	public int getProductID() {
		return this.productID;
	}
	
	public void setProductID(int productID) {
		this.productID = productID;
	}
	
	public String getProductName() {
		return this.product_name;
	}
	
	public void setProductName(String productName) {
		this.product_name = productName;
	}
	
	public String getDescription() {
		return this.description;
	}
	
	public void setDescription(String description) {
		this.description = description;
	}
	
	public double getUnitPrice() {
		return this.unit_price;
	}
	
	public void setUnitPrice(double unitPrice) {
		this.unit_price = unitPrice;
	}
	
	public int getStockQuantity() {
		return this.stock_quantity;
	}
	
	public void setStockQuantity(int quantity) {
		this.stock_quantity = quantity;
	}
	
	public int getCategoryID() {
		return this.category_ID;
	}
	
	public void setCategory(int category) {
		this.category_ID = category;
	}
	
	public String getImageUrlFromPart() {
		return imageUrlFromPart;
	}
	
	public void setImageUrlFromPart(Part part) {
		this.imageUrlFromPart = getImageUrl(part);
	}

	public void setImageUrlFromDB(String imageUrl) {
		this.imageUrlFromPart = imageUrl;
	}
	
	public String getBrandName() {
		return brandName;
	}
	
	public void setBrandName(String brandName) {
		this.brandName = brandName;
	}
	
	public String getImageUrl(Part part) {
		
		String savePath = StringUtils.IMAGE_DIR_PRODUCT;
		
		File fileSaveDir = new File(savePath);
		
		String imageUrlFromPart = null;
		
		if (!fileSaveDir.exists()) {
			fileSaveDir.mkdir();
		}
		String contentDisp = part.getHeader("content-disposition");
		String[] items = contentDisp.split(";");
		
		for(String s: items) {
			if(s.trim().startsWith("filename")) {
				imageUrlFromPart = s.substring(s.indexOf("=") + 2, s.length() - 1);
				break;
			}
		}
		
		if(imageUrlFromPart == null || imageUrlFromPart.isEmpty()) {
			imageUrlFromPart = "download.png";
		}
		return imageUrlFromPart;
	}
}

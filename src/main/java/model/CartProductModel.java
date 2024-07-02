package model;

import java.io.Serializable;

public class CartProductModel implements Serializable {
	private static final long serialVersionUID = 1L;
	
	private int cartID;
	private int productID;
	private String productName;
	private int stockQuantity;
	private int quantity;
	private double lineTotal;
	private String imagePath;
	private double price;
	
	public CartProductModel() {}

	public CartProductModel(int cartID, int productID, String imagePath, String productName, double price, int quantity, double total) {
		this.cartID = cartID;
		this.productID = productID;
		this.imagePath = imagePath;
		this.productName = productName;
		this.price = price;
		this.quantity = quantity;
		this.lineTotal = total;
	}
	
	public int getStockQuantity() {
		return stockQuantity;
	}
	
	public void setStockQuantity(int stockQuantity) {
		this.stockQuantity = stockQuantity;
	}
	
	public String getProductName() {
		return productName;
	}

	public void setProductName(String productName) {
		this.productName = productName;
	}

	public int getCartID() {
		return cartID;
	}

	public void setCartID(int cartID) {
		this.cartID = cartID;
	}

	public int getProductID() {
		return productID;
	}

	public void setProductID(int productID) {
		this.productID = productID;
	}

	public int getQuantity() {
		return quantity;
	}

	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}

	public double getLineTotal() {
		return lineTotal;
	}

	public void setLineTotal(double lineTotal) {
		this.lineTotal = lineTotal;
	}
	
	public String getImagePath() {
		return imagePath;
	}
	
	public void setImagePath(String imagePath) {
		this.imagePath = imagePath;
	}
	
	public double getPrice() {
		return price;
	}
	
	public void setPrice(double price) {
		this.price = price;
	}
}

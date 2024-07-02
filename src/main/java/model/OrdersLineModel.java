package model;

import java.io.Serializable;

public class OrdersLineModel implements Serializable {
	private static final long serialVersionUID = 1L;
	
	private int orderID;
	private int productID;
	private int orderQuantity;
	private double lineTotal;
	private String product_name;
	private double unit_price;
	
	public OrdersLineModel() {}
	
	public OrdersLineModel(int orderID, int productID, int orderQuantity, double lineTotal) {
		this.orderID = orderID;
		this.productID = productID;
		this.orderQuantity = orderQuantity;
		this.lineTotal = lineTotal;
	}

	public int getOrderID() {
		return orderID;
	}

	public void setOrderID(int orderID) {
		this.orderID = orderID;
	}

	public int getProductID() {
		return productID;
	}

	public void setProductID(int productID) {
		this.productID = productID;
	}

	public int getOrderQuantity() {
		return orderQuantity;
	}

	public void setOrderQuantity(int orderQuantity) {
		this.orderQuantity = orderQuantity;
	}

	public double getLineTotal() {
		return lineTotal;
	}

	public void setLineTotal(double lineTotal) {
		this.lineTotal = lineTotal;
	}
		
	public String getProductName() {
		return this.product_name;
	}
	
	public void setProductName(String productName) {
		this.product_name = productName;
	}
	
	public double getUnitPrice() {
		return this.unit_price;
	}
	
	public void setUnitPrice(double unitPrice) {
		this.unit_price = unitPrice;
	}
}

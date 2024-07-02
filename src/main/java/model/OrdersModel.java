package model;

import java.io.Serializable;

import java.time.LocalDate;

public class OrdersModel implements Serializable{
	private static final long serialVersionUID = 1L;

	private int orderID;

	private LocalDate orderDate;
	private double totalAmount;
	private double discountAmount;
	private double grandTotalAmount;
	private String orderStatus;
	private String paymentType;
	private String shippingAddress;
	private int cartID;
	
	public OrdersModel() {}
	
	public OrdersModel(LocalDate orderDate, double totalAmount, double discountAmount, double grandTotalAmount, String orderStatus,
			String paymentType, String shippingAddress, int cartID) {
		this.orderDate = orderDate;
		this.totalAmount = totalAmount;
		this.discountAmount = discountAmount;
		this.grandTotalAmount = grandTotalAmount;
		this.orderStatus = orderStatus;
		this.paymentType = paymentType;
		this.shippingAddress = shippingAddress;
		this.cartID = cartID;		
	}

	public int getOrderID() {
		return orderID;
	}
	
	public void setOrderID(int orderID) {
		this.orderID = orderID;
	}
	
	public LocalDate getOrderDate() {
		return orderDate;
	}

	public void setOrderDate(LocalDate orderDate) {
		this.orderDate = orderDate;
	}

	public double getTotalAmount() {
		return totalAmount;
	}

	public void setTotalAmount(double totalAmount) {
		this.totalAmount = totalAmount;
	}

	public double getDiscountAmount() {
		return discountAmount;
	}

	public void setDiscountAmount(double discountAmount) {
		this.discountAmount = discountAmount;
	}

	public double getGrandTotalAmount() {
		return grandTotalAmount;
	}

	public void setGrandTotalAmount(double grandTotalAmount) {
		this.grandTotalAmount = grandTotalAmount;
	}

	public String getOrderStatus() {
		return orderStatus;
	}

	public void setOrderStatus(String orderStatus) {
		this.orderStatus = orderStatus;
	}

	public String getPaymentType() {
		return paymentType;
	}

	public void setPaymentType(String paymentType) {
		this.paymentType = paymentType;
	}

	public String getShippingAddress() {
		return shippingAddress;
	}

	public void setShippingAddress(String shippingAddress) {
		this.shippingAddress = shippingAddress;
	}

	public int getCartID() {
		return cartID;
	}

	public void setCartID(int cartID) {
		this.cartID = cartID;
	}	
}

package model;

import java.io.Serializable;

public class CartModel implements Serializable {
	private static final long serialVersionUID = 1L;
	
	private int cartID;
	private int userID;
	private int totalQuantity;
	private double totalAmount;
	
	public CartModel() {}
	
	public CartModel(int cartID, int userID, int totalQuantity, double totalAmount) {
		this.cartID = cartID;
		this.userID = userID;
		this.totalQuantity = totalQuantity;
		this.totalAmount = totalAmount;
	}
	
	public int getCartID() {
		return cartID;
	}

	public void setCartID(int cartID) {
		this.cartID = cartID;
	}

	public int getUserID() {
		return userID;
	}

	public void setUserID(int userID) {
		this.userID = userID;
	}

	public int getTotalQuantity() {
		return totalQuantity;
	}

	public void setTotalQuantity(int totalQuantity) {
		this.totalQuantity = totalQuantity;
	}

	public double getTotalAmount() {
		return totalAmount;
	}

	public void setTotalAmount(double totalAmount) {
		this.totalAmount = totalAmount;
	}	
}

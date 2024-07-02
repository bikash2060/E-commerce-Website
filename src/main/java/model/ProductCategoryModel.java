package model;

import java.io.Serializable;

public class ProductCategoryModel implements Serializable{
	private static final long serialVersionUID = 1L;
	
	private int categoryID;
	private String categoryName;
	
	public ProductCategoryModel() {}
	
	public ProductCategoryModel(int categoryID, String categoryName) {
		this.categoryID = categoryID;
		this.categoryName = categoryName;
	}
	
	public int getCategoryID() {
		return categoryID;
	}
	
	public void setCategoryID(int categoryID) {
		this.categoryID = categoryID;
	}
	
	public String getCategoryName() {
		return this.categoryName;
	}
	
	public void setCategoryName(String categoryName) {
		this.categoryName = categoryName;
	}
}

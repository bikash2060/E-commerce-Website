package model;

import java.io.Serializable;

public class AdminModel implements Serializable {
	private static final long serialVersionUID = 1L;
	
	private String username;
	private String password;
	private String firstname;
	private String lasttname;
	
	public AdminModel() {}
	
	public AdminModel(String username, String password) {
		this.username = username;
		this.password = password;
	}
	
	public String getFirstname() {
		return firstname;
	}
	
	public void setFirstname(String firstname) {
		this.firstname = firstname;
	}
	
	public String getLastname() {
		return lasttname;
	}
	
	public void setLasttname(String lastname) {
		this.lasttname = lastname;
	}
	public String getUsername() {
		return username;
	}
	
	public void setUsername(String username) {
		this.username = username;
	}
	
	public String getPassword() {
		return password;
	}
	
	public void setPassword(String password) {
		this.password = password;
	}
}

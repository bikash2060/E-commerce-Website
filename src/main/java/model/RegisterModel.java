package model;

import java.io.File;
import java.io.Serializable;
import java.time.LocalDate;
import javax.servlet.http.Part;
import utils.StringUtils;

public class RegisterModel implements Serializable {
	private static final long serialVersionUID = 1L;
	
	private String firstName;
	private String lastName;
	private String gender;
	private String emailAddress;
	private LocalDate dateOfBirth;
	private LocalDate joinedDate;
	private String address;
	private String username;
	private String password;
	private String phoneNumber;
	private String privilegeType = "User";
	private String imageUrlFromPart;
	
	public RegisterModel() {}
	
	public RegisterModel(String firstName, String lastName, String gender, String emailAddress, LocalDate dateOfBirth, LocalDate joinedDate,
			String address, String username, String password, String phoneNumber) {
		super();
		this.firstName = firstName;
		this.lastName = lastName;
		this.gender = gender;
		this.emailAddress = emailAddress;
		this.dateOfBirth = dateOfBirth;
		this.joinedDate = joinedDate;
		this.address = address;
		this.username = username;
		this.password = password;
		this.phoneNumber = phoneNumber;
	}
	
	public String getFirstName() {
		return this.firstName;
	}
	
	public void setFirstName(String firstName) {
		this.firstName = firstName;		
	}
	
	public String getLastName() {
		return this.lastName;
	}
	
	public void setLastName(String lastName) {
		this.lastName = lastName;
	}
	
	public String getGender() {
		return this.gender;
	}
	
	public void setGender(String gender) {
		this.gender = gender;
	}
	
	public String getEmailAddress() {
		return this.emailAddress;
	}
	
	public void setEmailAddress(String emailAddress) {
		this.emailAddress = emailAddress;
	}
	
	public LocalDate getDOB() {
		return this.dateOfBirth;
	}
	
	public void setDOB(LocalDate dob) {
		this.dateOfBirth = dob;
	}
	
	public LocalDate getJoinedDate() {
		return this.joinedDate;
	}
	
	public void setJoinedDate(LocalDate joinedDate) {
		this.joinedDate = joinedDate;
	}
	
	public String getAddress() {
		return this.address;
	}
	
	public void setAddress(String address) {
		this.address = address;
	}
	
	public String getUsername() {
		return this.username;
	}
	
	public void setUsername(String username) {
		this.username = username;
	}
	
	public String getPassword() {
		return this.password;
	}
	
	public void setPassword(String password) {
		this.password = password;
	}
	
	public String getPhoneNumber() {
		return this.phoneNumber;
	}
	
	public void setPhoneNumber(String phoneNumber) {
		this.phoneNumber = phoneNumber;
	}
	
	public String getPrivilegeType() {
		return this.privilegeType;
	}
	
	public void setPrivilegeType(String privilege) {
		this.privilegeType = privilege;
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
	
	public String getImageUrl(Part part) {
		
		String savePath = StringUtils.IMAGE_DIR_USER;
		
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

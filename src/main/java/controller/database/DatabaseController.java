package controller.database;

import java.math.BigDecimal;




import java.sql.Connection;

import java.sql.Date;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


import model.AdminModel;
import model.CartModel;
import model.CartProductModel;
import model.LoginModel;
import model.OrdersLineModel;
import model.OrdersModel;
import model.PasswordEncryption;
import model.ProductModel;
import model.RegisterModel;
import utils.StringUtils;

public class DatabaseController {
	
	/**
	 * This method is used to get a database connection object.
	 * @return Connection object
	 * @throws SQLException if there is an error in connecting to the database.
	 * @throws ClassNotFoundException if the specified driver class is not found in the classpath.
	 */
	public Connection getDatabaseConnection() throws SQLException, ClassNotFoundException {
		Class.forName(StringUtils.DRIVER_NAME);
		return DriverManager.getConnection(StringUtils.LOCALHOST_URL, StringUtils.LOCALHOST_USERNAME, StringUtils.LOCALHOST_PASSWORD);
	}

	/* Method Usage: RegisterServlet
	 * This method is used to check if a given phone number exists in the database.
	 * @return true if existed otherwise false.
	*/
	public boolean checkPhoneNumber(String phoneNumber) throws SQLException, ClassNotFoundException {
		boolean matched = false; 
		Connection con = getDatabaseConnection();
		PreparedStatement ps = con.prepareStatement(StringUtils.GET_PHONE_NUMBER);
		ps.setString(1, phoneNumber);
		ResultSet checkPhone = ps.executeQuery();
		if (checkPhone.next()) {
			String dbPhoneNumber = checkPhone.getString("Phone_Number"); 
			if (dbPhoneNumber.equals(phoneNumber)) {
				matched = true; 
			}
		}
		return matched;
	}
	
	/* Method Usage: RegisterServlet
	 * This method is used to check if a given email address exists in the database.
	 * @return true if existed otherwise false.
	*/
	public boolean checkEmailAddress(String emailAddress) throws SQLException, ClassNotFoundException {
		boolean matched = false; 
		Connection con = getDatabaseConnection();
		PreparedStatement ps = con.prepareStatement(StringUtils.GET_EMAIL_ADDRESS);
		ps.setString(1, emailAddress);
		ResultSet checkEmail = ps.executeQuery();
		if (checkEmail.next()) {
			String dbEmailAddress = checkEmail.getString("Email_Address"); // 
			if (dbEmailAddress.equals(emailAddress)) {
				matched = true; 
			}
		}
		return matched;
	}
	
	/* Method Usage: RegisterServlet
	 * This method is used to check if a given username exists in the database.
	 * @return true if existed otherwise false.
	*/
	public boolean checkUsername(String userName) throws SQLException, ClassNotFoundException {
		boolean matched = false; 
		Connection con = getDatabaseConnection();
		PreparedStatement ps = con.prepareStatement(StringUtils.GET_USERNAME);
		ps.setString(1, userName);
		ResultSet checkUsername = ps.executeQuery();
		if (checkUsername.next()) {
			String dbUsername = checkUsername.getString("Username"); 
			if (dbUsername.equals(userName)) {
				matched = true; 
			}
		}
		return matched;
	}
	
	/* Method Usage: RegisterServlet
	 * This method registers a new user by inserting their information into the database.
	 * It returns an integer code indicating the result of the registration process:
	 * 1: Registration successful
	 * -1: Error occurred during registration (SQLException or ClassNotFoundException)
	 * -2: Username already exists in the database
	 * -3: Email address already exists in the database
	 * -4: Phone number already exists in the database
	*/	
	public int registerUser(RegisterModel newUser) {
		try {
			Connection con = getDatabaseConnection(); 
			Boolean userName = checkUsername(newUser.getUsername());
			Boolean phoneNumber = checkPhoneNumber(newUser.getPhoneNumber());
			Boolean emailAddress = checkEmailAddress(newUser.getEmailAddress());
			if (userName) {
				return -2;
			}
			else if (phoneNumber) {
				return -4;
			}
			else if (emailAddress) {
				return -3;
			}
			else {
				PreparedStatement ps = con.prepareStatement(StringUtils.INSERT_USER);
				ps.setString(1, newUser.getFirstName());
				ps.setString(2, newUser.getLastName());
				ps.setDate(3, Date.valueOf(newUser.getDOB()));
				ps.setDate(4, Date.valueOf(newUser.getJoinedDate()));
				ps.setString(5, newUser.getGender());
				ps.setString(6, newUser.getEmailAddress());
				ps.setString(7, newUser.getAddress());
				ps.setString(8, newUser.getUsername());
				ps.setString(9, PasswordEncryption.encrypt(newUser.getUsername(), newUser.getPassword()));
				ps.setString(10, newUser.getPrivilegeType());
				ps.setString(11, newUser.getPhoneNumber());
				
				int result = ps.executeUpdate();
				if(result > 0) {
					return 1;
				}
				else {
					return 0;
				}				
			}
		}
		catch (SQLException | ClassNotFoundException e) {
			e.printStackTrace();
			return -1;
		}
	}
	
	/* Method Usage: Register.jsp
	 * This method retrieves all user information from the database based on the provided username.
	 * It returns a RegisterModel object containing the user information if the username is found in the database.
	 * Otherwise, it returns null.
	*/
	public RegisterModel getAllUserInfo(String username){
		
		try{
			Connection con = getDatabaseConnection();
			PreparedStatement ps = con.prepareStatement(StringUtils.GET_LOGIN_USER_INFO);
			ps.setString(1, username);
			
			ResultSet rs = ps.executeQuery();
			
			RegisterModel userInfo = new RegisterModel();
			
			while(rs.next()) {
				userInfo.setFirstName(rs.getString("First_Name"));
				userInfo.setLastName(rs.getString("Last_Name"));
				userInfo.setDOB(rs.getDate("Date_of_Birth").toLocalDate());
				userInfo.setJoinedDate(rs.getDate("Joined_Date").toLocalDate());
				userInfo.setGender(rs.getString("Gender"));
				userInfo.setEmailAddress(rs.getString("Email_Address"));
				userInfo.setAddress(rs.getString("Address"));
				userInfo.setPhoneNumber(rs.getString("Phone_Number"));
				userInfo.setUsername(rs.getString("Username"));
				userInfo.setPassword(PasswordEncryption.decrypt(rs.getString("Password"), username));
				userInfo.setImageUrlFromDB(rs.getString("Image_Path"));
			}
			return userInfo;
		}
		catch(SQLException | ClassNotFoundException e) {
			e.printStackTrace();
			return null;
		}
	}
	
	/* Method Usage: LoginServlet
	 * This method retrieves user information from the database based on the provided username and validates the login credentials.
	 * It returns an integer code indicating the result of the login process:
	 * 1: Login successful
	 * 2: Incorrect password
	 * -1: Error occurred during login (SQLException or ClassNotFoundException)
	 * -2: Username not found in the database
	*/
	public int getUserInfo(LoginModel user) {
		try {
			int matched = 0; 
			Connection con = getDatabaseConnection();
			PreparedStatement ps = con.prepareStatement(StringUtils.GET_LOGIN_USER_INFO);
			ps.setString(1, user.getUsername());

			ResultSet databaseData = ps.executeQuery();
			if(databaseData.next()) {
				String dbUsername = databaseData.getString("Username");
				String dbPassword = databaseData.getString("Password");
				String decryptedPwd = PasswordEncryption.decrypt(dbPassword, dbUsername);
				if(decryptedPwd != null && dbUsername.equals(user.getUsername()) && decryptedPwd.equals(user.getPassword())){
					matched  = 1;
				}
				else {
					matched = 2;
				}
			}
			else {
				return -2;
			}
			return matched;
		}
		catch (SQLException | ClassNotFoundException e) {
			e.printStackTrace();
			return -1;
		}
	}
	
	/* Method Usage: LoginServlet
	 * This method retrieves admin information from the database based on the provided username and validates the login credentials.
	 * It returns an integer code indicating the result of the login process:
	 * 1: Login successful
	 * 2: Incorrect password
	 * -1: Error occurred during login (SQLException or ClassNotFoundException)
	 * -2: Username not found in the database
	*/
	public int getAdminInfo(AdminModel admin) {
		try {
			int matched = 0; 
			Connection con = getDatabaseConnection(); 
			PreparedStatement ps = con.prepareStatement(StringUtils.GET_LOGIN_ADMIN_INFO);
			ps.setString(1, admin.getUsername());
			
			ResultSet databaseData = ps.executeQuery();
			if(databaseData.next()) {
				String dbUsername = databaseData.getString("Username");
				String dbPassword = databaseData.getString("Password");
				if(dbUsername.equals(admin.getUsername()) && dbPassword.equals(admin.getPassword())){
					matched  = 1;
				}
				else {
					matched = 2;
				}
			}
			else {
				return -2;
			}
			return matched;
		}
		catch (SQLException | ClassNotFoundException e) {
			e.printStackTrace();
			return -1;
		}

	}
	
	/* Method Usage: AddToCartServlet
	 * This method checks whether a user has a cart associated with their userID in the database.
	 * It returns true if the user has a cart, false otherwise.
	 * 
	*/
	public boolean checkUserCart(int userID) {
		try {
			boolean hasCart = false;
			Connection con = getDatabaseConnection(); 
			PreparedStatement ps = con.prepareStatement(StringUtils.CHECK_USER_CART);
			ps.setInt(1, userID);;
			
			ResultSet rs = ps.executeQuery();
			
			if(rs.next()) {
				hasCart = true;
			}
			return hasCart;
		}
		catch(SQLException | ClassNotFoundException e) {
			e.printStackTrace();
			return false;
		}
	}
	
	/* Method Usage: AddToCartServlet
	 * This method retrieves the cart ID associated with the given userID from the database.
	 * It returns the cart ID if found.
	 * 
	*/
	public int returnUserCart(int userID) {
		try {
			int cartID = 0;
			Connection con = getDatabaseConnection(); 
			PreparedStatement ps = con.prepareStatement(StringUtils.RETRIEVE_USER_CART);
			ps.setInt(1, userID);;
			
			ResultSet rs = ps.executeQuery();
			
			if(rs.next()) {
				cartID = rs.getInt("CartID");
			}
			return cartID;
		}
		catch(SQLException | ClassNotFoundException e) {
			e.printStackTrace();
			return -1;
		}
	}
	
	/* Method Usage: AddToCartServlet
	 * This method creates a cart associated with the given userID in the database.
	 * It returns 1 after the cart is successfully created.
	 * 
	*/
	public int createCart(int userID) {
	    try {
	        Connection con = getDatabaseConnection(); 
	        PreparedStatement ps = con.prepareStatement(StringUtils.CREATE_USER_CART);
	        ps.setInt(1, userID);

	        int rowsAffected = ps.executeUpdate();

	        return rowsAffected;
	    } catch (SQLException | ClassNotFoundException e) {
	        e.printStackTrace();
	        return -1;
	    }
	}
	
	/* Method Usage: AddToCartServlet
	 * This method retrieves the userID associated with the given username from the database.
	 * It returns the userID if found.
	*/
	public int getUserID(String username) {
		try {
			Connection con = getDatabaseConnection(); 
			PreparedStatement ps = con.prepareStatement(StringUtils.GET_USERID);
			ps.setString(1, username);
			
			ResultSet rs = ps.executeQuery();
			
			int userID = 0;
			if(rs.next()) {
				userID = rs.getInt("UserID");
			}
			return userID;
		}
		catch(SQLException | ClassNotFoundException e) {
			e.printStackTrace();
			return -1;
		}
	}
	
	/* Method Usage: AddToCartServlet
	 * This method adds a product to the user's cart in the database.
	 * It returns the following integer codes:
	 * 1: Product added successfully to the cart
	 * 0: Product already exists in the cart
	 * -1: Error occurred while adding product to the cart
	*/
	public int addProductTocart(CartProductModel cart) {
		try {
	        Connection con = getDatabaseConnection(); 
	        PreparedStatement checkPs = con.prepareStatement(StringUtils.CHECK_PRODUCT_EXISTS_IN_CART);
	        checkPs.setInt(1, cart.getCartID());
	        checkPs.setInt(2, cart.getProductID());
	        ResultSet checkRs = checkPs.executeQuery();
	        
	        if (checkRs.next() && checkRs.getBoolean("product_exists")) {
	            return 0;
	        }else {
	        	PreparedStatement ps = con.prepareStatement(StringUtils.INSERT_CART_PRODUCT);
	        	ps.setInt(1, cart.getCartID());
	        	ps.setInt(2, cart.getProductID());
	        	ps.setInt(3, cart.getQuantity());
	        	ps.setDouble(4, cart.getLineTotal());
	        	
	        	int result = ps.executeUpdate();
	        	if(result == 1) {
	        		return 1;
	        	}
	        	else {
	        		return -1;
	        	}	        	
	        }
	    } catch (SQLException | ClassNotFoundException e) {
	        e.printStackTrace();
	        return -1;
	    }
	}
	
	/* Method Usage: RemoveItemsServlet
	 * This method deletes an item with the given productId from the cart with the specified cartID in the database.
	 * It returns the following integer codes:
	 * 1: Item deleted successfully from the cart
	 * 0: No item deleted from the cart (possibly because the item doesn't exist in the cart)
	 * -1: Error occurred while deleting item from the cart
	*/
	public int deleteCartItems(int productId, int cartID) {
		try {
			Connection con = getDatabaseConnection(); 
			PreparedStatement ps = con.prepareStatement(StringUtils.DELETE_CART_ITEMS);
			ps.setInt(1, productId);
			ps.setInt(2, cartID);
			
			int result = ps.executeUpdate();
			if(result == 1) {
	    		return 1;
	    	}
	    	else {
	    		return 0;
	    	}	       
		}
		catch(SQLException | ClassNotFoundException e) {
			e.printStackTrace();
			return -1;
		}
	}
	
	/* Method Usage: UpdateQuantityServlet
	 * This method updates the quantity and line total of a product in the cart with the specified productID and cartID in the database.
	 * It returns the following integer codes:
	 * 1: Quantity and line total updated successfully
	 * 0: No update performed (possibly because the product doesn't exist in the cart)
	 * -1: Error occurred while updating quantity and line total
	 */
	public int updateQuantity(int quantity, double lineTotal, int productID, int cartID) {
		try {
			Connection con = getDatabaseConnection(); 
			PreparedStatement ps = con.prepareStatement(StringUtils.UPDATE_ITEMS_QUANTITY);
			ps.setInt(1, quantity);
			ps.setDouble(2, lineTotal);
			ps.setInt(3, productID);
			ps.setInt(4, cartID);
			
			int result = ps.executeUpdate();
			
			if(result == 1) {
				return 1;
			}
			else {
				return 0;
			}
		}
		catch(SQLException | ClassNotFoundException e) {
			e.printStackTrace();
			return -1;
		}
	}
	
	/* Method Usage: UserUpdateServlet
	 * This method retrieves the previous image URL associated with the given username from the database.
	 * It returns the previous image URL as a string if found, otherwise returns null.
	*/
	public String getPreviousImageUrl(String username) {
	    try {
	        Connection con = getDatabaseConnection();
	        PreparedStatement st = con.prepareStatement(StringUtils.GET_IMAGE_URL);
	        st.setString(1, username);
	        ResultSet rs = st.executeQuery();
	        if (rs.next()) {
	            return rs.getString("Image_Path");
	        }
	    } catch (SQLException | ClassNotFoundException e) {
	        e.printStackTrace();
	    }
	    return null;
	}
	
	/* Method Usage: UserUpdateServlet
	 * This method checks if the given email address is associated with any other user except the one with the specified username.
	 * It returns true if the email address is found in the database for any user other than the specified username.
	 * Otherwise it returns false.
	*/
	public boolean checkEmail(String emailAddress, String username) throws SQLException, ClassNotFoundException {
		Connection con = getDatabaseConnection();
		PreparedStatement ps = con.prepareStatement(StringUtils.GET_ALL_EMAIL);
		ps.setString(1, emailAddress);
		ps.setString(2, username);
		ResultSet rs = ps.executeQuery();
		if (rs.next()) {
            int count = rs.getInt(1);
            return count > 0;
        }
		return false;
	}
	
	/* Method: UserUpdateServlet
	 * This method checks if the given phone number is associated with any other user except the one with the specified username.
	 * It returns true if the phone number is found in the database for any user other than the specified username
	 * Otherwise it returns false.
	*/
	public boolean checkNumber(String phoneNumber, String username) throws SQLException, ClassNotFoundException {
		Connection con = getDatabaseConnection();
		PreparedStatement ps = con.prepareStatement(StringUtils.GET_ALL_PHONE_NUMBER);
		ps.setString(1, phoneNumber);
		ps.setString(2, username);
		ResultSet rs = ps.executeQuery();
		if (rs.next()) {
            int count = rs.getInt(1);
            return count > 0;
        }
		return false;
	}
	
	/* Method Usage: UserUpdateServlet
	 * This method updates user information in the database based on the provided parameters.
	 * It updates the user's first name, last name, shipping address, email address, phone number, and image URL.
	 * It returns 1 if the update is successful, 0 if no rows were affected, and -1 if an error occurred.
	*/
	public int updateUser(String username, String firstName, String lastName, String emailAddress, String address,
			String phoneNumber,String imageUrl) {
		try {
			Connection con = getDatabaseConnection(); 
			PreparedStatement st = con.prepareStatement(StringUtils.UPDATE_USER_INFO);
			st.setString(1, firstName);
			st.setString(2, lastName);
			st.setString(3, address);	
			st.setString(4, emailAddress);
			st.setString(5, phoneNumber);
			st.setString(6, imageUrl);
			st.setString(7, username);
			
			int result = st.executeUpdate();
			if(result > 0) {
				return 1;
			}
			else {
				return 0;
			}
		}
		catch(SQLException | ClassNotFoundException e) {
			e.printStackTrace();
			return -1;
		}
	}

	/* Method Usage: UserPasswordServlet
	 * It checks if the old password provided by the user matches the stored password for the given username.
	 * It retrieves the encrypted password from the database for the provided username and decrypts it using the username.
	 * If the decrypted password matches the old password provided by the user, returns true, otherwise, returns false.
	*/	
	public boolean checkOldPassword(String username, String oldPassword) throws SQLException, ClassNotFoundException {
		Connection con = getDatabaseConnection();
		PreparedStatement ps = con.prepareStatement(StringUtils.GET_USER_OLD_PASSWORD);
		ps.setString(1, username);
		
		ResultSet databaseData = ps.executeQuery();
		if(databaseData.next()) {
			
			String dbPassword = databaseData.getString("Password");
			String decryptedPwd = PasswordEncryption.decrypt(dbPassword, username);
			if(decryptedPwd.equals(oldPassword)) {
				return true;
			}
			
		}
		return false;
	}
	
	/* Method Usage: UserPasswordServlet
	 * This method updates the password for the given username with the new encrypted password.
	 * It returns 1 if the password update is successful, 0 if no rows were affected, and -1 if an error occurs.
	*/
	public int updatePassword(String username, String newPassword) {
		try {
			Connection con = getDatabaseConnection(); 
			PreparedStatement ps = con.prepareStatement(StringUtils.UPDATE_USER_PASSWORD);
			ps.setString(1, PasswordEncryption.encrypt(username, newPassword));
			ps.setString(2, username);
			
			int result = ps.executeUpdate();
			if(result > 0) {
				return 1;
			}
			else {
				return 0;
			}
		}
		catch(SQLException | ClassNotFoundException e) {
			e.printStackTrace();
			return -1;
		}
	}
	
	/* Method Usage: Shop.jsp
	 * This method retrieves information for all products from the database.
	 * It stores the fetched data in an ArrayList of ProductModel objects.
	 * It returns the ArrayList containing product information.
	*/
	public ArrayList<ProductModel> getAllProductInfo(){
		try {
			Connection con = getDatabaseConnection();
			PreparedStatement ps = con.prepareStatement(StringUtils.GET_ALL_PRODUCT);
	        ResultSet rs = ps.executeQuery();
	        
	        ArrayList<ProductModel> products = new ArrayList<ProductModel>();
	        
	        while (rs.next()) {
	            ProductModel productInfo = new ProductModel();
	            productInfo.setProductID(rs.getInt("ProductID"));
	            productInfo.setProductName(rs.getString("Product_Name"));
	            productInfo.setDescription(rs.getString("Description"));
	            productInfo.setUnitPrice(rs.getDouble("Unit_Price"));
	            productInfo.setStockQuantity(rs.getInt("Stock_Quantity"));         
	            productInfo.setCategory(rs.getInt("Category_ID"));
	            productInfo.setBrandName(rs.getString("Brand"));
	            productInfo.setImageUrlFromDB(rs.getString("Image_Path"));
	            
	            products.add(productInfo);
	        }
	        return products;
		        
		}
		catch(SQLException | ClassNotFoundException e) {
			e.printStackTrace();
	        return null;
		}
	}	
	
	/**
	 * This method retrieves all products from the database and organizes them into a map structure.
	 * The map contains two lists: 'firstEight' for the first eight products retrieved, and 'remaining'
	 * for the rest of the products.
	 * 
	 * @return A map containing lists of ProductModel objects. The 'firstEight' list contains the first
	 *         eight products retrieved, and the 'remaining' list contains the rest of the products.
	 *         Returns null if an SQL exception or class not found exception occurs.
	*/	
	public Map<String, List<ProductModel>> getAllProducts() {
	    try {
	        Connection con = getDatabaseConnection();
	        PreparedStatement ps = con.prepareStatement(StringUtils.GET_ALL_PRODUCT);
	        ResultSet rs = ps.executeQuery();
	        
	        Map<String, List<ProductModel>> productsMap = new HashMap<>();
	        List<ProductModel> firstEightProducts = new ArrayList<>();
	        List<ProductModel> remainingProducts = new ArrayList<>();
	        
	        int count = 0;
	        
	        while (rs.next()) {
	            ProductModel productInfo = new ProductModel();
	            productInfo.setProductID(rs.getInt("ProductID"));
	            productInfo.setProductName(rs.getString("Product_Name"));
	            productInfo.setDescription(rs.getString("Description"));
	            productInfo.setUnitPrice(rs.getDouble("Unit_Price"));
	            productInfo.setStockQuantity(rs.getInt("Stock_Quantity"));         
	            productInfo.setCategory(rs.getInt("Category_ID"));
	            productInfo.setBrandName(rs.getString("Brand"));
	            productInfo.setImageUrlFromDB(rs.getString("Image_Path"));
	            
	            if (count < 8) {
	                firstEightProducts.add(productInfo);
	            } else {
	                remainingProducts.add(productInfo);
	            }

	            count++;
	        }
	        
	        productsMap.put("firstEight", firstEightProducts);
	        productsMap.put("remaining", remainingProducts);
	        
	        return productsMap;
	    } catch (SQLException | ClassNotFoundException e) {
	        e.printStackTrace();
	        return null;
	    }
	}

	/* Method Usage: Cart.jsp
	 * This method retrieves cart items for a user specified by the username.
	 * It gets the user ID using the username.
	 * It stored the fetched data in an ArrayList of CartProductModel objects.
	 * It returns the ArrayList containing cart items.
	*/
	public ArrayList<CartProductModel> getCartItems(String username) {
		try {
			int userID = getUserID(username);
			Connection con = getDatabaseConnection();
			PreparedStatement ps = con.prepareStatement(StringUtils.GET_CART_DETAILS);
			ps.setInt(1, userID);
			ResultSet rs = ps.executeQuery();
			
			ArrayList<CartProductModel> product = new ArrayList<CartProductModel>();

			while(rs.next()) {
				CartProductModel cartitems = new CartProductModel();
				cartitems.setCartID(rs.getInt("CartID"));
				cartitems.setProductID(rs.getInt("ProductID"));
				cartitems.setStockQuantity(rs.getInt("Stock_Quantity"));
				cartitems.setImagePath(rs.getString("Image_Path"));
				cartitems.setProductName(rs.getString("Product_Name"));
				cartitems.setPrice(rs.getDouble("Unit_Price"));
				cartitems.setQuantity(rs.getInt("Quantity"));
				cartitems.setLineTotal(rs.getDouble("Line_Total"));
				product.add(cartitems);
			}
			return product;
		}
		catch(SQLException | ClassNotFoundException e) {
			e.printStackTrace();
			return null;
		}
	}	
	
	/* Method Usage: AddToCartServlet, UpdateQuantityServlet, RemoveItemsServlet
	 * This method retrieves the total quantity and total amount of products in the cart for a specified user.
	 * If no records are found in the cart_product table, sets total quantity and total amount to 0.
	 * @return A CartModel object containing the total quantity, total amount, and user ID.
	*/
	public CartModel getUserCartSummary(String username) {
	    try {
	        int userID = getUserID(username);
	        Connection con = getDatabaseConnection();
	        PreparedStatement ps = con.prepareStatement(StringUtils.GET_TOTAL_QUANTITY);
	        ps.setInt(1, userID);
	        ResultSet rs = ps.executeQuery();

	        CartModel cartitems = new CartModel();

	        if (rs.next()) {
	            cartitems.setTotalQuantity(rs.getInt("Total_Product_Quantity"));
	            cartitems.setTotalAmount(rs.getBigDecimal("Total_Amount").doubleValue());
	            cartitems.setUserID(rs.getInt("UserID"));
	        }
	        else {
	            cartitems.setTotalQuantity(0);
	            cartitems.setTotalAmount(0.0);
	            cartitems.setUserID(userID);
	        }
	        return cartitems;

	    } catch (SQLException | ClassNotFoundException e) {
	        e.printStackTrace();
	        return null;
	    }
	}
	
	/* Method Usage: AddToCartServlet, UpdateQuantityServlet, RemoveItemsServlet
	 * This method updates the total quantity and total amount of products in the cart for a specified user.
	 * If the cart is empty (total quantity is 0), sets total quantity and total amount to 0.
	 * 	
	*/
	public int insertCartValues(CartModel cart) {
	    try {
	        Connection con = getDatabaseConnection();
	        PreparedStatement ps = null;

	        if (cart.getTotalQuantity() == 0) {
	            ps = con.prepareStatement(StringUtils.INSERT_EMPTY_CART_VALUES);
	            ps.setInt(1, cart.getUserID());
	        } else {
	            ps = con.prepareStatement(StringUtils.INSERT_CART_VALUES);
	            ps.setInt(1, cart.getTotalQuantity());
	            BigDecimal totalAmount = BigDecimal.valueOf(cart.getTotalAmount());
	            ps.setBigDecimal(2, totalAmount);
	            ps.setInt(3, cart.getUserID());
	        }
	        int result = ps.executeUpdate();
	        return result > 0 ? 1 : 0;
	    } catch (SQLException | ClassNotFoundException e) {
	        e.printStackTrace();
	        return -1;
	    }
	}	
	
	/* 
	 * 
	*/
	public CartModel getCartModelInfo(String username) {		
		try {
			int userID = getUserID(username);
			Connection con = getDatabaseConnection();
			PreparedStatement ps = con.prepareStatement(StringUtils.GET_CART_INFO);
			ps.setInt(1, userID);
			
			ResultSet rs = ps.executeQuery();
			
	        CartModel cartitems = new CartModel();
	        
			while(rs.next()) {
				cartitems.setTotalQuantity(rs.getInt("Total_Quantity"));
				cartitems.setTotalAmount(rs.getDouble("Total_Amount"));
			}
			return cartitems;
			
		}catch (SQLException | ClassNotFoundException e) {
	        e.printStackTrace();
	        return null;
	    }
	}
	
	
	/*
	 * This method is used to save orders 
	*/
	public int saveOrders(OrdersModel newOrder) {
		try {
			Connection con = getDatabaseConnection();
			PreparedStatement ps = con.prepareStatement(StringUtils.INSERT_ORDERS);
			ps.setDate(1, Date.valueOf(newOrder.getOrderDate()));
			
			BigDecimal totalAmount = BigDecimal.valueOf(newOrder.getTotalAmount());
			ps.setBigDecimal(2, totalAmount);
			
			BigDecimal discountAmount = BigDecimal.valueOf(newOrder.getDiscountAmount());
	        ps.setBigDecimal(3, discountAmount);

	        BigDecimal grandTotalAmount = BigDecimal.valueOf(newOrder.getGrandTotalAmount());
	        ps.setBigDecimal(4, grandTotalAmount);
	        
			ps.setString(5, newOrder.getOrderStatus());
			ps.setString(6, newOrder.getPaymentType());
			ps.setString(7, newOrder.getShippingAddress());
			ps.setInt(8, newOrder.getCartID());
			
			int result = ps.executeUpdate();
			if(result > 0) {
				return 1;
			}
			else {
				return 0;
			}		
			
		}catch (SQLException | ClassNotFoundException e) {
	        e.printStackTrace();
	        return -1;
	    }
	}
	
	/*
	 * This method is used to remove items from cart after completing order 
	*/
	public int deleteUserCartItems(int cartID) {
		try {
			Connection con = getDatabaseConnection();
			PreparedStatement ps = con.prepareStatement(StringUtils.DELETE_USER_CART);
			ps.setInt(1, cartID);
			
			int result = ps.executeUpdate();
			if(result > 0) {
				return 1;
			}
			else {
				return 0;
			}
		}catch(SQLException | ClassNotFoundException e) {
			e.printStackTrace();
			return -1;
		}
	}
	
	/*
	 * This method is used to get latest orderId;
	*/
	public int getLatestOrderID() {
	    try {
	        Connection con = getDatabaseConnection();
	        PreparedStatement ps = con.prepareStatement(StringUtils.GET_LATEST_ORDER);
	        ResultSet rs = ps.executeQuery();
	        if (rs.next()) {
	            int orderId = rs.getInt(1);
	            return orderId;
	        }
	        return 0; 
	    } catch (SQLException | ClassNotFoundException e) {
	        e.printStackTrace();
	        return -1;
	    }
	}
	
	/*
	 * This method is used to insert value in ordersline table 
	*/
	public int insertOrdersLine(String username) {
	    try {
	        int userID = getUserID(username);
	        Connection con = getDatabaseConnection();
	        PreparedStatement ps = con.prepareStatement(StringUtils.GET_CART_DETAILS);
	        ps.setInt(1, userID);
	        ResultSet rs = ps.executeQuery();
	        
	        boolean allSuccessful = true; // Flag to track if all rows are successfully inserted
	        
	        while(rs.next()) {
	            PreparedStatement preparedStatement = con.prepareStatement(StringUtils.INSERT_ORDERS_LINE);
	            preparedStatement.setInt(1, getLatestOrderID());
	            preparedStatement.setInt(2, rs.getInt("ProductID"));
	            preparedStatement.setInt(3, rs.getInt("Quantity"));
	            
	            BigDecimal totalAmount = BigDecimal.valueOf(rs.getDouble("Line_Total"));
	            preparedStatement.setBigDecimal(4, totalAmount);
	            
	            int result = preparedStatement.executeUpdate();
	            if(result <= 0) {
	                // If the execution fails for any row, set the flag to false
	                allSuccessful = false;
	            }
	        }
	        
	        if (allSuccessful) {
	            // If all rows are successfully processed
	            return 1;
	        } else {
	            // If any execution fails for a row
	            return 0;
	        }
	        
	    } catch (SQLException | ClassNotFoundException e) {
	        e.printStackTrace();
	        return -1;
	    }
	}
	
	/*
	 * This method is used to get orders-line value
	*/
	public ArrayList<OrdersLineModel> getOrdersLine(String username) {
		try {
			int userID = getUserID(username);
			int lastestOrder = getLatestOrderID();
			Connection con = getDatabaseConnection();
			PreparedStatement ps = con.prepareStatement(StringUtils.GET_ORDERS_WITH_PRODUCTS);
			ps.setInt(1, userID);
			ps.setInt(2, lastestOrder);
			
			ArrayList<OrdersLineModel> ordersLine = new ArrayList<OrdersLineModel>();
			
			ResultSet rs = ps.executeQuery();
			while(rs.next()) {
				OrdersLineModel order = new OrdersLineModel();
				order.setProductID(rs.getInt("ProductID"));
				order.setProductName(rs.getString("Product_Name"));
				order.setUnitPrice(rs.getBigDecimal("Unit_Price").doubleValue());
				order.setOrderQuantity(rs.getInt("Order_Quantity"));
				order.setLineTotal(rs.getBigDecimal("Line_Total").doubleValue());
				ordersLine.add(order);
			}
			return ordersLine;
		}
		catch(SQLException | ClassNotFoundException e){
			e.printStackTrace();
			return null;
		}		
	}
	
	/*
	 * This method is used to get orders details 
	*/
	
	public OrdersModel getOrderDetails(String username) {
		try {
			int userID = getUserID(username);
			int userCart = returnUserCart(userID);
			Connection con = getDatabaseConnection();
			PreparedStatement ps = con.prepareStatement(StringUtils.GET_ORDERS_AMOUNT);
			ps.setInt(1, userID);
			ps.setInt(2, userCart);
			
			ResultSet rs = ps.executeQuery();
			OrdersModel orders = new OrdersModel();
			
			while(rs.next()) {
				orders.setShippingAddress(rs.getString("Shipping_Address"));
				orders.setOrderID(rs.getInt("OrderID"));
				orders.setPaymentType(rs.getString("Payment_Type"));
				orders.setTotalAmount(rs.getBigDecimal("Total_Amount").doubleValue());
				orders.setDiscountAmount(rs.getBigDecimal("Discount_Amount").doubleValue());
				orders.setGrandTotalAmount(rs.getBigDecimal("Grand_Total_Amount").doubleValue());
			}
			return orders;
		}
		catch(SQLException | ClassNotFoundException e) {
			e.printStackTrace();
			return null;
		}
	}
	
	
	/* Method Usaga: Admin.jsp
	 * This method retrieves the total number of user from the database.
	*/
	public int getAllUser() {
		try {
			Connection con = getDatabaseConnection();
			PreparedStatement ps = con.prepareStatement(StringUtils.GET_ALL_USER);
			
			ResultSet rs = ps.executeQuery();
			int totalUsers = 0;
			while(rs.next()) {
				totalUsers = Integer.parseInt(rs.getString("Total_Users"));
			}
			return totalUsers;
		}
		catch(SQLException | ClassNotFoundException e) {
			e.printStackTrace();
			return -1;
			
		}
	}
	
	/* Method Usaga: Admin.jsp
	 * This method retrieves the total number of products from the database.
	*/
	public int getTotalProducts() {
		try {
			Connection con = getDatabaseConnection();
			PreparedStatement ps = con.prepareStatement(StringUtils.GET_TOTAL_PRODUCTS);
			
			ResultSet rs = ps.executeQuery();
			int totalProducts = 0;
			while(rs.next()) {
				totalProducts = Integer.parseInt(rs.getString("Total_Products"));
			}
			return totalProducts;
		}
		catch(SQLException | ClassNotFoundException e) {
			e.printStackTrace();
			return -1;
			
		}
	}
	
	/* Method Usaga: Admin.jsp
	 * This method retrieves the total revenue from the database
	*/
	public double getTotalRevenue() {
		try {
			Connection con = getDatabaseConnection();
			PreparedStatement ps = con.prepareStatement(StringUtils.GET_TOTAL_REVENUE);
			
			ResultSet rs = ps.executeQuery();
			double totalRevenue = 0;
			if(rs.next()) {
				totalRevenue = Double.valueOf(rs.getString("Grand_Total_Amount"));
			}
			else {
				totalRevenue = 0;
			}
			return totalRevenue;
		}
		catch(SQLException | ClassNotFoundException e) {
			e.printStackTrace();
			return -1;
			
		}
	}
	
	/* Method Usaga: Admin.jsp
	 * This method retrieves the new orders from the database
	*/
	public int getNewOrders() {
		try {
			Connection con = getDatabaseConnection();
			PreparedStatement ps = con.prepareStatement(StringUtils.GET_NEW_ORDERS);			
			ResultSet rs = ps.executeQuery();
			int newOrder = 0;
			if(rs.next()) {
				newOrder = Integer.parseInt(rs.getString("New_Order"));
			}
			else {
				newOrder = 0;
			}
			return newOrder;
		}
		catch(SQLException | ClassNotFoundException e) {
			e.printStackTrace();
			return -1;
			
		}
	}
	
	/* Method Usage: Admin.jsp, UserManagement.jsp
	 * This method retrieves information of all the users. 
	*/
	public ArrayList<RegisterModel> getAllUserDetails(){
		
		try{
			Connection con = getDatabaseConnection();
			PreparedStatement ps = con.prepareStatement(StringUtils.GET_ALL_USER_INFO);
			ResultSet rs = ps.executeQuery();
			
			ArrayList<RegisterModel> allUsers = new ArrayList<RegisterModel>();
			while(rs.next()) {
				RegisterModel userInfo = new RegisterModel();
				userInfo.setFirstName(rs.getString("First_Name"));
				userInfo.setLastName(rs.getString("Last_Name"));
				userInfo.setUsername(rs.getString("Username"));
				userInfo.setGender(rs.getString("Gender"));
				userInfo.setEmailAddress(rs.getString("Email_Address"));
				userInfo.setAddress(rs.getString("Address"));
				userInfo.setPrivilegeType(rs.getString("Privilege_Type"));
				userInfo.setImageUrlFromDB(rs.getString("Image_Path"));
				allUsers.add(userInfo);
			}
			return allUsers;
		}
		catch(SQLException | ClassNotFoundException e) {
			e.printStackTrace();
			return null;
		}
	}
	
	/* Method Usage: RemoveProduct Servlet
	 * This method checks whether the given product ID is in the cartt-product or not.
	 */
	public boolean checkProductID(int productID) {
		try {
			Connection con = getDatabaseConnection();
			PreparedStatement ps = con.prepareStatement(StringUtils.CHECK_PRODUCT_ID);
			ps.setInt(1, productID);
			
			ResultSet rs = ps.executeQuery();
			if(rs.next()) {
				return true;
			}
			else {
				return false;
			}
		}
		catch(SQLException | ClassNotFoundException e) {
			e.printStackTrace();
			return false;
		}
	}
	
	/* Method Usage: RemoveProduct Servlet
	 * This method deletes the product from orders-line table.
	 */	
	public int deleteProductsFromOrders(int productID) {
		try {
			Connection con = getDatabaseConnection();
			PreparedStatement ps = con.prepareStatement(StringUtils.DELETE_PRODUCTS_FROM_ORDER_LINE);
			ps.setInt(1, productID);
			
			int result = ps.executeUpdate();
			if(result > 0) {
				return 1;
			}
			else {
				return 0;
			}
		}
		catch(SQLException | ClassNotFoundException e) {
			e.printStackTrace();
			return -1;
		}
	}
	
	/* Method Usage: RemoveProduct Servlet
	 * This method deletes the product from product table
	 */	
	public int deleteProductsFromProduct(int productID) {
		try {
			Connection con = getDatabaseConnection();
			PreparedStatement ps = con.prepareStatement(StringUtils.DELETE_FROM_PRODUCT);
			ps.setInt(1, productID);
			
			int result = ps.executeUpdate();
			if(result > 0) {
				return 1;
			}
			else {
				return 0;
			}
		}
		catch(SQLException | ClassNotFoundException e) {
			e.printStackTrace();
			return -1;
		}
	}
	
	/* Method Usage: UserPrivilegeServlet
	 * This method counts the total of numbers with admin privilege
	*/
	public boolean checkPrivilegeType() {
		try {
			Connection con = getDatabaseConnection();
			PreparedStatement ps = con.prepareStatement(StringUtils.GET_PRIVILEGE_NUMBER);
			
			ResultSet rs = ps.executeQuery();
			if(rs.next() && rs.getInt(1) == 5) {
				return false;
			}
			else {
				return true;
			}
		}
		catch(SQLException | ClassNotFoundException e) {
			e.printStackTrace();
			return false;
		}
	}
	
	
	/* Method Usage: UserPrivilegeServlet
	 * This method updates the privilege type for a given username to admin.
	*/
	public int changePrivilegeType(String privilegeType, String username) {
		try {
			Connection con = getDatabaseConnection();
			PreparedStatement ps = con.prepareStatement(StringUtils.UPDATE_PRIVILEGE_TYPE);
			ps.setString(1, privilegeType);
			ps.setString(2, username);
			
			int result = ps.executeUpdate();
			
			if(result > 0) {
				return 1;
			}
			else {
				return 0;
			}
			
		}
		catch(SQLException | ClassNotFoundException e) {
			e.printStackTrace();
			return -1;
		}
	}
	
	/* Method Usage: UserPrivilegeServlet
	 * This method updates the privilege type for a given username to user.
	*/
	public int deletePrivilegeType(String privilegeType, String username) {
		try {
			Connection con = getDatabaseConnection();
			PreparedStatement ps = con.prepareStatement(StringUtils.CHANGE_PRIVILEGE_TYPE);
			ps.setString(1, privilegeType);
			ps.setString(2, username);
			
			int result = ps.executeUpdate();
			
			if(result > 0) {
				return 1;
			}
			else {
				return 0;
			}
			
		}
		catch(SQLException | ClassNotFoundException e) {
			e.printStackTrace();
			return -1;
		}
	}
	
	
	public String getPrivilege(String username) {
		try {
			Connection con = getDatabaseConnection();
			PreparedStatement ps = con.prepareStatement(StringUtils.GET_PRIVILEGE_TYPE);
			ps.setString(1, username);
			
			String privilegeType = null;
			
			ResultSet rs = ps.executeQuery();
			
			while(rs.next()) {
				privilegeType = rs.getString("Privilege_Type");
			}
			return privilegeType;
			
		}
		catch(SQLException | ClassNotFoundException e) {
			e.printStackTrace();
			return null;
		}
	}
	
	/* Method Usage: Admin.jsp
	 * This method extracts all the orders from the order table.
	*/
	public ResultSet getTotalOrders() {
		try {
			Connection con = getDatabaseConnection();
			PreparedStatement ps = con.prepareStatement(StringUtils.GET_TOTAL_ORDERS);		
			ResultSet rs = ps.executeQuery();
			return rs;
		}
		catch(SQLException | ClassNotFoundException e) {
			e.printStackTrace();
			return null;
		}
	}
	
	/* Method Usage: MyProfile.jsp
	 * This method extracts all the order history for a particular user
	*/
	public ResultSet getOrderHistroy(String username) {
		try {
			int userID = getUserID(username);
			Connection con = getDatabaseConnection();
			PreparedStatement ps = con.prepareStatement(StringUtils.GET_ORDERS_HISTORY);	
			ps.setInt(1, userID);
			ResultSet rs = ps.executeQuery();
			return rs;
		}
		catch(SQLException | ClassNotFoundException e) {
			e.printStackTrace();
			return null;
		}
	}
	
	/* Method Usage: AddNewProduct Servlet
	 * Thid method gets the category ID based on category name.
	*/
	public int getCategoryID(String categoryName) {
		try {
			Connection con = getDatabaseConnection();
			PreparedStatement ps = con.prepareStatement(StringUtils.GET_CATEGORY_ID);
			ps.setString(1, categoryName);
			
			ResultSet rs = ps.executeQuery();
			int categoryID = 0;
			while(rs.next()) {
				categoryID = rs.getInt("Category_ID");
			}
			return categoryID;
		}
		catch(SQLException | ClassNotFoundException e) {
			e.printStackTrace();
			return -1;
		}
	}
	
	/* Method Usage: AddProduct Servlet
	 * This method inserts the new produtc in the product table.
	 */
	public int insertProducts(ProductModel product) {
		try {
			Connection con = getDatabaseConnection();
			PreparedStatement ps = con.prepareStatement(StringUtils.INSERT_PRODUCT);
			ps.setString(1, product.getProductName());
			ps.setString(2, product.getDescription());
			
			BigDecimal unitPrice = BigDecimal.valueOf(product.getUnitPrice());
			ps.setBigDecimal(3, unitPrice);
			
			ps.setInt(4, product.getStockQuantity());
			ps.setInt(5, product.getCategoryID());
			ps.setString(6, product.getImageUrlFromPart());
			ps.setString(7, product.getBrandName());
			
			int result = ps.executeUpdate();
			
			if(result > 0) {
				return 1;
			}
			else {
				return 0;
			}
		}
		catch(SQLException | ClassNotFoundException e) {
			e.printStackTrace();
			return -1;
		}
	}
	
	/* Method Usage: AddProductServlet
	 * This method checks whether the given product already existed or not in the database.
	*/
	public boolean getProductName(String productName) {
		try {
			Connection con = getDatabaseConnection();
			PreparedStatement ps = con.prepareStatement(StringUtils.GET_PRODUCT_NAME);
			ps.setString(1, productName);
			
			ResultSet rs = ps.executeQuery();
			boolean exists = false;
			if (rs.next()) {
	            int count = rs.getInt("Product_Count");
	            if (count > 0) {
	                exists = true;
	            }
	        }
			return exists;
			
		}
		catch(SQLException | ClassNotFoundException e) {
			e.printStackTrace();
			return false;
		}
	}
	
	/* Method Usage: UpdateProductDetails
	 * This method retrieves the previous image URL associated with the given product ID from the database.
	 * It returns the previous image URL as a string if found, otherwise returns null.
	*/
	public String getProductPreviousImageUrl(int productID) {
	    try {
	        Connection con = getDatabaseConnection();
	        PreparedStatement st = con.prepareStatement(StringUtils.GET_PRODUCT_IMAGE_URL);
	        st.setInt(1, productID);
	        ResultSet rs = st.executeQuery();
	        if (rs.next()) {
	            return rs.getString("Image_Path");
	        }
	    } catch (SQLException | ClassNotFoundException e) {
	        e.printStackTrace();
	        return null;
	    }
	    return null;
	}
	
	/* Method Usage: UpdateProductDetails
	 * This method updates the data in the product table.
	*/
	public int updateProduct(String productName, String description, double price, int quantity, String brand, 
			String imageUrl, int productID) {
		try {
			Connection con = getDatabaseConnection();
			PreparedStatement ps = con.prepareStatement(StringUtils.UPDATE_PRODUCT_INTO);
			ps.setString(1, productName);
			ps.setString(2, description);
			
			BigDecimal unitPrice = BigDecimal.valueOf(price);
            ps.setBigDecimal(3, unitPrice);
            
            ps.setInt(4, quantity);
            ps.setString(5, imageUrl);
            ps.setString(6, brand);
            ps.setInt(7, productID);
            
            int result = ps.executeUpdate();
            if(result>0) {
            	return 1;
            }
            else {
            	return 0;
            }
			
		} catch (SQLException | ClassNotFoundException e) {
	        e.printStackTrace();
	        return -1;
	    }
	}
	
	/* Method Usage: UpdateOrderStatusServlet
	 * This method updates the privilege type for a given username to admin.
	*/
	public int changeOrderStatus(String orderStatus, int orderID) {
		try {
			Connection con = getDatabaseConnection();
			PreparedStatement ps = con.prepareStatement(StringUtils.UPDATE_ORDER_STATUS);
			ps.setString(1, orderStatus);
			ps.setInt(2, orderID);
			
			int result = ps.executeUpdate();
			
			if(result > 0) {
				return 1;
			}
			else {
				return 0;
			}
		}
		catch(SQLException | ClassNotFoundException e) {
			e.printStackTrace();
			return -1;
		}
	}
}

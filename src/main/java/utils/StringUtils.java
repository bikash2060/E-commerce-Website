package utils;

public class StringUtils{
	
	// Database Connection Configuration
	public static final String DRIVER_NAME = "com.mysql.cj.jdbc.Driver";
	public static final String LOCALHOST_URL = "jdbc:mysql://localhost/coursework_database";
	public static final String LOCALHOST_USERNAME = "root";
	public static final String LOCALHOST_PASSWORD = "";
	
	// Variables to save image in local directory
	public static final String IMAGE_DIRECTORY = "Users\\N I T R O 5\\Desktop\\Advanced Java\\Coursework\\src\\main\\webapp\\resources\\";
	public static final String IMAGE_DIR_USER = "C:/"+ IMAGE_DIRECTORY + "user\\";
	public static final String IMAGE_DIR_PRODUCT = "C:/"+ IMAGE_DIRECTORY + "product\\";
	
	/*
	 * Constants defining parameter names used in user registration.
	 * These parameter names are used to access form data or request attributes related to user information.
	*/
	public static final String FIRST_NAME = "firstName";
	public static final String LAST_NAME = "lastName";
	public static final String USERNAME = "username";
	public static final String GENDER = "gender";
	public static final String EMAIL_ADDRESS = "emailAddress";
	public static final String DOB = "dob";
	public static final String ADDRESS = "shippingAddress";
	public static final String SHIPPING_ADDRESS = "shippingAddress";
	public static final String JOINED_DATE = "joinedDate";
	public static final String PASSWORD = "password";
	public static final String CONFIRM_PASSWORD = "confirmPassword";
	public static final String PHONE_NUMBER = "phoneNumber";
	public static final String OLD_PASSWORD = "oldPassword";
	public static final String NEW_PASSWORD = "newPassword";
	public static final String BRAND = "brand";
	public static final String PRICE = "filterPrice";
	public static final String CATEGORY = "category";
	public static final String PAYMENT = "payment";
	public static final String DISCOUNT_AMOUNT = "discountAmount";
	public static final String GRAND_TOTAL_AMOUNT = "totalAmount";
	public static final String TOTAL_AMOUNT = "netAmount";
	public static final String SORT_NUMBER = "sort";
	public static final String PRODUCT_ID = "productId";
	public static final String PRODUCT_NAME = "product-name";
	public static final String PRODUCT_DESCRIPTION = "description";
	public static final String PRODUCT_PRICE = "unit-price";
	public static final String PRODUCT_QUANTITY = "quantity";
	public static final String PRODUCT_CATEGORY = "category";
	public static final String PRODUCT_IMAGE = "image";
	public static final String PRODUCT_BRAND = "brand";
	public static final String PRODUCT_DETAILS_ARRAYLIST = "productsArrayList";
	
	// SQL query to interact with user table
	public static final String INSERT_USER = "INSERT INTO user(First_Name, Last_Name, Date_of_Birth, Joined_Date, Gender, Email_Address,"
			+ "Address, Username, Password, Privilege_Type, Phone_Number) VALUES (?,?,?,?,?,?,?,?,?,?,?)";
	
	public static final String GET_LOGIN_USER_INFO = "SELECT * FROM user WHERE Username = ?";	
	
	public static final String UPDATE_USER_INFO = "UPDATE user SET First_Name=?, Last_Name=?, Address=?, "
			+ "Email_Address=?, Phone_Number=?, Image_Path= ? WHERE Username=?";
	
	public static final String UPDATE_PRODUCT_INTO = "UPDATE product SET Product_Name = ?, Description = ?, "
			+ "Unit_Price = ?, Stock_Quantity = ?, Image_Path = ?, Brand = ? WHERE ProductID = ?";
	
	public static final String UPDATE_USER_PASSWORD = "UPDATE user SET Password=? WHERE Username=?";
	
	public static final String GET_ALL_EMAIL = "SELECT COUNT(*) FROM user WHERE Email_Address=? AND Username!=?";
	
	public static final String GET_ALL_PHONE_NUMBER = "SELECT COUNT(*) FROM user WHERE Phone_Number=? AND Username!=?";
	
	public static final String GET_USER_OLD_PASSWORD = "SELECT Password FROM user WHERE Username=?";
	
	public static final String GET_USERNAME = "SELECT * FROM user WHERE Username = ?";
	
	public static final String GET_PHONE_NUMBER = "SELECT * FROM user WHERE Phone_Number = ?";
	
	public static final String GET_EMAIL_ADDRESS = "SELECT * FROM user WHERE Email_Address = ?";
	
	public static final String GET_IMAGE_URL = "SELECT Image_Path FROM user WHERE Username = ?";
	
	public static final String GET_PRODUCT_IMAGE_URL = "SELECT Image_Path FROM product WHERE ProductID = ?";
	
	public static final String GET_USERID = "SELECT UserID FROM user where Username = ?";

	// SQL query to interact with admin table
	public static final String GET_LOGIN_ADMIN_INFO = "SELECT * FROM admin WHERE Username = ?";	
	
	public static final String GET_ADMIN_USERNAME = "SELECT Username FROM admin";
	// Other Query
	public static final String CHECK_USER_CART = "SELECT * FROM cart WHERE UserID = ?";
	
	public static final String RETRIEVE_USER_CART = "SELECT CartID FROM cart WHERE UserID = ?";
	
	public static final String CREATE_USER_CART = "INSERT INTO cart (USERID) VALUES (?)";
	
	public static final String INSERT_CART_PRODUCT = "INSERT INTO cart_product (CartID, ProductID, Quantity, Line_Total) VALUES (?,?,?,?)";
	
	public static final String CHECK_PRODUCT_EXISTS_IN_CART = "SELECT EXISTS (SELECT 1 FROM cart_product WHERE CartID = ? AND ProductID = ?) AS product_exists;";
	
	public static final String GET_CART_DETAILS = "SELECT product.Unit_Price, product.Stock_Quantity,"
			+ "product.Image_Path, product.ProductID, product.Product_Name, "
	        + "cart_product.Quantity, cart_product.Line_Total, cart.CartID "
	        + "FROM product "
	        + "INNER JOIN cart_product ON product.ProductID = cart_product.ProductID "
	        + "INNER JOIN cart ON cart_product.CartID = cart.CartID "
	        + "INNER JOIN user ON cart.UserID = user.UserID "
	        + "WHERE user.UserID = ?";
	
	public static final String GET_TOTAL_QUANTITY = "SELECT SUM(cp.Quantity) AS Total_Product_Quantity, "
	        + "SUM(cp.Line_Total) AS Total_Amount, c.UserID "
	        + "FROM cart_product cp "
	        + "INNER JOIN cart c ON cp.CartID = c.CartID "
	        + "WHERE c.UserID = ? "
	        + "GROUP BY c.CartID";
	
	public static final String GET_ORDERS_WITH_PRODUCTS = "SELECT  product.ProductID, product.Product_Name, product.Unit_Price, "
			+ "orders_line.order_quantity, orders_line.Line_Total FROM orders INNER JOIN cart ON orders.CartID = cart.CartID "
			+ "INNER JOIN user ON cart.UserID = user.UserID INNER JOIN orders_line ON orders.OrderID = orders_line.OrderID INNER "
			+ "JOIN product ON orders_line.ProductID = product.ProductID WHERE user.UserID = ? AND orders_line.OrderID = ?";
	
	public static final String GET_ORDERS_AMOUNT = "SELECT orders.Shipping_Address, orders.OrderID, orders.Payment_Type, orders.Total_Amount, orders.Discount_Amount, orders.Grand_Total_Amount " +
            "FROM orders " +
            "INNER JOIN cart ON orders.CartID = cart.CartID " +
            "INNER JOIN user ON cart.UserID = user.UserID " +
            "WHERE user.UserID = ? AND cart.CartID = ? " +
            "ORDER BY orders.OrderID DESC LIMIT 1";
	
	public static final String GET_ORDERS_HISTORY = "SELECT orders.OrderID, orders.Order_Date, orders.Grand_Total_Amount, "
			+ "orders.Payment_Type, orders.Order_Status, user.First_Name, user.Last_Name, product.Product_Name FROM user "
			+ "INNER JOIN cart ON user.UserID = cart.UserID INNER JOIN orders on cart.CartID = orders.CartID "
			+ "INNER JOIN orders_line ON orders.OrderID = orders_line.OrderID INNER JOIN product ON orders_line.ProductID = product.ProductID "
			+ "WHERE user.UserID = ?";

	
	public static final String INSERT_ORDERS_LINE = "INSERT INTO orders_line(OrderID, ProductID, Order_Quantity, Line_Total)"
			+ "VALUES(?,?,?,?)";
	
	public static final String INSERT_CART_VALUES = "UPDATE cart SET Total_Quantity = ?, Total_Amount = ? WHERE UserID = ?";
	
	public static final String DELETE_CART_ITEMS = "DELETE FROM cart_product WHERE ProductID = ? AND CartID = ?";
	
	public static final String INSERT_EMPTY_CART_VALUES = "UPDATE cart SET Total_Quantity = 0, Total_Amount = 0 WHERE UserID = ?";

	public static final String UPDATE_ITEMS_QUANTITY = "UPDATE cart_product SET Quantity = ?, Line_Total = ? "
			+ "WHERE ProductID = ? AND CartID = ?";
	
	public static final String GET_CART_INFO = "SELECT * FROM cart WHERE UserID = ?";	
	
	public static final String INSERT_ORDERS = "INSERT INTO orders(Order_Date, Total_Amount, Discount_Amount, Grand_Total_Amount,"
			+ "Order_Status, Payment_Type, Shipping_Address, CartID) VALUES (?,?,?,?,?,?,?,?)";
	
	public static final String DELETE_USER_CART = "DELETE FROM cart_product WHERE CartID = ?";
	
	public static final String GET_LATEST_ORDER = "SELECT MAX(OrderID) FROM orders";
	
	
	// SQL query to interact with product table
	public static final String GET_ALL_PRODUCT = "SELECT * FROM product";
	
	public static final String GET_ALL_USER = "SELECT COUNT(*) AS Total_Users FROM user";
	
	public static final String GET_TOTAL_PRODUCTS = "SELECT COUNT(*) AS Total_Products FROM product";
	
	public static final String GET_TOTAL_REVENUE = "SELECT SUM(Grand_Total_Amount) AS Grand_Total_Amount FROM orders";
	
	public static final String GET_NEW_ORDERS = "SELECT COUNT(*) AS New_Order FROM orders"; 
	
	public static final String GET_ALL_USER_INFO = "SELECT * FROM user";
	
	public static final String CHECK_PRODUCT_ID = "SELECT * FROM cart_product WHERE ProductID = ?";
	
	public static final String DELETE_PRODUCTS_FROM_ORDER_LINE = "DELETE FROM orders_line WHERE ProductID = ?";
	
	public static final String DELETE_FROM_PRODUCT = "DELETE FROM product WHERE ProductID = ?";
	
	public static final String GET_PRIVILEGE_NUMBER = "SELECT COUNT(*) AS Admin FROM user WHERE Privilege_Type = 'Admin'";
	
	public static final String UPDATE_PRIVILEGE_TYPE = "UPDATE user SET Privilege_Type = ? WHERE Username = ?";
	
	public static final String UPDATE_ORDER_STATUS = "UPDATE orders SET Order_Status = ? WHERE OrderID = ?";
	
	public static final String CHANGE_PRIVILEGE_TYPE = "UPDATE user SET Privilege_Type = ? WHERE Username = ?";
	
	public static final String GET_PRIVILEGE_TYPE = "SELECT Privilege_Type FROM user WHERE Username = ?";
	
	public static final String GET_TOTAL_ORDERS = "SELECT orders.OrderID, orders.Discount_Amount, orders.Grand_Total_Amount, "
            + "orders.Order_Date, orders.Order_Status, user.First_Name, user.Last_Name "
            + "FROM user INNER JOIN cart ON user.UserID = cart.UserID "
            + "INNER JOIN orders ON cart.CartID = orders.CartID";
	
	public static final String GET_CATEGORY_ID = "SELECT Category_ID FROM product_category WHERE Category_Name = ?";
	
	public static final String INSERT_PRODUCT = "INSERT INTO product"
	        + "(Product_Name, Description, Unit_Price, Stock_Quantity, Category_ID, Image_Path, Brand)"
	        + "VALUES(?,?,?,?,?,?,?)";
	
	public static final String GET_PRODUCT_NAME = "SELECT COUNT(*) AS Product_Count FROM product WHERE Product_Name = ?";
	
	public static final String GET_SORTING_PRODUCTS = "SELECT * FROM product ORDER BY Unit_Price";
	
	// Registration form validation message
	public static final String EMPTY_FIELD_ERROR_MESSAGE = "Please fill all the field";
	public static final String FIRST_NAME_ERROR_MESSAGE = "Enter valid first name";
	public static final String LAST_NAME_ERROR_MESSAGE = "Enter valid last name";
	public static final String EMAIL_ADDRESS_ERROR_MESSAGE = "Enter valid email address";
	public static final String PASSWORD_ERROR_MESSAGE = "Enter strong password";
	public static final String PHONE_NUMBER_ERROR_MESSAGE = "Enter valid phone number";
	public static final String CONFIRMPASSWORD_ERROR_MESSAGE = "Password must be same";
	public static final String USERNAME_ERROR_MESSAGE = "Username is already existed";
	public static final String EMAIL_ERROR_MESSAGE = "Email address already existed";
	public static final String PHONE_ERROR_MESSAGE = "Phone number already existed";	
	public static final String USERNAME_VALID_ERROR_MESSAGE = "Enter valid username";

	// Login form validation message
	public static final String ACCOUNT_NOT_FOUND_MESSAGE = "Account do not exist!";
	public static final String PASSWORD_NOT_MATCHED_MESSAGE = "Password do not match";

	// Error Message
	public static final String ERROR_MESSAGE = "errorMessage";
	public static final String SERVER_ERROR_MESSAGE = "An unexpected server error occured";
	public static final String REGISTER_ERROR_MESSAGE = "Please correct the form data";
	public static final String UPDATED_ERROR_MESSAGE = "Updating Unsuccessful";
	public static final String SHIPPING_ADDRESS_ERROR_MESSAGE = "Please provide shipping address";
	public static final String PAYMENT_METHOD_ERROR_MESSAGE = "Please select payment method";
	public static final String NO_ITEMS_AVAILABLE_ERROR_MESSAGE = "Add at least one item";
	public static final String NO_IMAGE_ERROR_MESSAGE = "Please select an image";
	public static final String INVALID_NUMBER_ERROR_MESSAGE = "Please enter valid unit price";
	public static final String QUANTITY_ERROR_MESSAGE = "Please enter valid quantity";
	public static final String UNIT_PRICE_ERROR_MESSAGE = "Please enter valid price";
	public static final String PRODUCT_DELETE_ERROR_MESSAGE = "Product deletion unsuccessful";
	public static final String PRIVILEGE_NUMBER_ERROR_MESSAGE = "Admin privilege limit";
	public static final String PRODUCT_DUPLICATE_ERROR_MESSAGE = "Product already existed!";
	
	// Success Message
	public static final String SUCCESS_MESSAGE = "successMessage";
	public static final String SUCCESS_REGISTER_MESSAGE = "Registered Successfully ✓";
	public static final String SUCCESS_LOGIN_MESSAGE = "Login Successfully ✓";
	public static final String SUCCESSFULLY_UPDATED_MESSAGE = "Profile updated successfully";
	public static final String PRODUCT_UPDATED_SUCCESSFULLY_MESSAGE = "Product details updated successfully";
	public static final String PRODUCT_UPDATED_ERROR_MESSAGE = "Failed to update details";
	public static final String PASSWORD_UPDATED_SUCCESSFULLY_MESSAGE = "Password update successfully";
	public static final String PRODUCT_ADDED_SUCCESSFULLY_MESSAGE = "Product addedd to cart sucessfully";
	public static final String PRODUCT_ADDED_FAILED_MESSAGE = "Product is already in your cart";
	public static final String PRODUCT_DELETED_SUCCESS_MESSAGE = "Item deleted successfully";
	public static final String PRODUCTT_DELETED_ERROR_MESSAGE = "Unable to delete item";
	public static final String QUANTITY_UPDATED_SUCCESSFULLY = "Quantity is updates successfuly";
	public static final String QUANTITY_UPDATED_ERROR_MESSAGE = "Failed to update";
	public static final String ORDER_PLACED_SUCCESS_MESSAGE = "Your order has been successfully placed !";
	public static final String ORDER_PLACES_ERROR_MESSAGE = "Your order has not been successfully placed";
	public static final String PRODUCT_DELETE_SUCCESS_MESSAGE = "Product delete successfully";
	public static final String PRIVILEGE_SUCCESS_MESSAGE = "Privilege changed successfully";
	public static final String ORDER_STATUS_SUCCESS_MESSAGE = "Order status has been updated successfully";
	public static final String ORDER_STATUS_ERROR_MESSAGE = "Failed to update order status";
	public static final String PRIVILEGE_ERROR_MESSAGE = "Privilege remains unchanged";
	public static final String PRODUCT_ADDEDD_SECCESS_MESSAGE = "Product added successfully";
	public static final String PRODUCT_ADDEDD_ERROR_MESSAGE = "Failed to add product";


	
	// JSP Route
	public static final String LOGIN_URL = "/pages/Login.jsp";
	public static final String REGISTER_URL = "/pages/Register.jsp";
	public static final String INDEX_URL = "/Index.jsp";
	public static final String ADMIN_URL = "/pages/Admin.jsp";
	public static final String USER_PROFILE_URL = "/pages/MyProfile.jsp";
	public static final String USER_PASSWORD_URL = "/pages/UserPassword.jsp";
	public static final String PRODUCT_PAGE_URL = "/pages/Shop.jsp";
	public static final String CART_PAGE_URL = "/pages/Cart.jsp";
	public static final String ORDER_PAGE_URL = "/pages/MyOrder.jsp";
	public static final String INVOICE_PAGE_URL = "/pages/Invoice.jsp";
	public static final String ADD_PRODUCT_URL = "/pages/AddProduct.jsp";
	public static final String UPDATE_PRODUCT_URL = "/pages/ProductDetails.jsp";
	public static final String VIEW_PRODUCT_URL = "/pages/ViewProduct.jsp";
	public static final String USER_MANAGEMENT_URL = "/pages/UserManagement.jsp";
	
	// Servlet Route
	public static final String LOGIN_SERVLET = "/loginUser";
	public static final String REGISTER_SERVLET = "/registerUser";
	public static final String LOGOUT_SERVLET = "/logoutUser";
	public static final String USER_UPDATE_SERVLET = "/userUpdate";
	public static final String USER_PASSWORD_SERVLET = "/userPassword";
	public static final String FILTER_PRODUCT_SERVLET = "/filterProduct";
	public static final String ADD_TO_CART_SERVLET = "/addProduct";
	public static final String DELETE_CART_ITEMS_SERVLET = "/deleteProduct";
	public static final String UPDATE_QUANTITY_SERVLET = "/updateQuantity";
	public static final String ORDER_CONFIRM_SERVLET = "/orderConfirm";
	public static final String ADD_NEW_PRODUCT_SERVLET = "/addNewProduct";
	public static final String GET_PRODUCT_DETAILS_SERVLET = "/productDetails";
	public static final String UPDATE_PRODUCT_DETAILS_SERVLET = "/updateProduct";
	public static final String REMOVE_PRODUCT_SERVLET = "/removeItems";
	public static final String USER_PRIVILEGE_SERVLET = "/userPrivilege";
	public static final String INDEX_CART_SERVLET = "/addProducts";
	public static final String ORDER_STATUS_SERVLET = "/updateOrderStatus";
	
	// Normal Text
	public static final String USER = "user";
	public static final String ADMIN = "admin";
	public static final String USER_DETAILS = "userDetails";
	public static final String OLD_PASSWORD_ERROR_MESSAGE = "Old Password do not match";
}
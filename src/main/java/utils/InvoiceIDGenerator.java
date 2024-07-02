package utils;

public class InvoiceIDGenerator {

    private static int lastGeneratedID = 999; 

    public static int generateUniqueInvoiceID() {
    	int newID = ++lastGeneratedID; 
        return newID;
    }
}

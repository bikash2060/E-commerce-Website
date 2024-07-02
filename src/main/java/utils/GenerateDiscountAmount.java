package utils;

import java.text.DecimalFormat;
import java.util.Random;

public class GenerateDiscountAmount {
	
	double minPercentage = 5.0;
    double maxPercentage = 20.0;
	
    public static int calculateDiscountPercentage() {
        Random rand = new Random();
        int discountPercentage = (int) (5.0 + (20.0 - 5.0) * rand.nextDouble());
        return discountPercentage;
    }

    public static double calculateDiscountAmount(double totalAmount, double discountPercentage) {
    	double discountAmount = totalAmount * (discountPercentage / 100);
        DecimalFormat df = new DecimalFormat("#0.00");
        return Double.parseDouble(df.format(discountAmount));
    }
}

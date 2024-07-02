package utils;

public class ShowLessWord {
	
	public static String getLessWords(String description) {
		String[] strArrays = description.split(" ");
		if(strArrays.length>10){
			String res="";
			for(int i=0; i<10; i++) {
				res = res+strArrays[i]+" ";
			}
			return (res+"...");
		}
		else {
			return (description+"..."); 
		}
	}

}

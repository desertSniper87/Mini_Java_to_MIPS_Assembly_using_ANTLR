class HW3SimpleNoIfWhile {

      public static void main(String [] args) {
           new HW3().method();   
      }

}

class HW3 {

   public void method() {

        int x;
        int y;
        
        x = 3;
        y = 7;
        
        //if (x < y) {
            System.out.print(x);
            System.out.print(" ");
        //} else {
            System.out.print(y);
            System.out.print(" ");        
        //}
        
        //while ( x < y) {
            System.out.print(x);  System.out.print("\n");
            x = x + 1;
        //}
        
        sum(3,5);
        System.out.print(sum(3,5));  System.out.print("\n");
        
        sayHi();
        
        x =  sum(times(3,4),times(5,6));
        System.out.print(x);  System.out.print("\n");
	System.out.print(sum(sum(times(3,4),times(5,6)), sum(times(7,8),times(9,16))));
        
        //if (greater(10,5)) {
            System.out.print(sum(10,7));  
            System.out.print(" ");
        //} else {
         
        //}   
            
        System.out.print(concat3("HI"));
                                         
   }  
   
   public int sum(int a, int b) {
       int sum;
       sum = a + b;
       return sum;
   }
   
   public int times(int m, int n) {
       return m * n;
   }
   
   public void sayHi() {
       System.out.print("HI");  System.out.print("\n");
   }
   
   public boolean greater(int a, int b) {
       //if (a < b) 
           return false;
       //else 
//           return true;
   }
   
   public String concat3(String s) {
       String result;
       result = s;
       result = result + s;
       result = result + s;
       return s;
   }
   
      
}


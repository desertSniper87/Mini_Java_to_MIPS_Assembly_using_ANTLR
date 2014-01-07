class Int {

      public static void main(String [] args) {
           new IntTest().method();   
      }

}

class IntTest {

    public void method() {

        int six;
        int eight; 
        int ten;
        
        six = 6;
        eight = 8;
        ten = 10;
        
        System.out.print(six);  System.out.print(" ");
        System.out.print(eight);  System.out.print(" ");
        System.out.print(ten);  System.out.print("\n");  
        
        System.out.print("< ");
        System.out.print(  six < eight   );  System.out.print(" ");
        System.out.print(  six < six   );  System.out.print(" ");        
        System.out.print(  eight < six   );  System.out.print("\n");  
        
        System.out.print("== ");
        System.out.print(  six == eight   );  System.out.print(" ");
        System.out.print(  six == six   );  System.out.print(" ");        
        System.out.print(  eight == six   );  System.out.print("\n"); 
        
        six = six * 10;
        eight = 10 * ten - eight;
        ten = six + 3 * 7;   
        System.out.print(six);  System.out.print(" ");
        System.out.print(eight);  System.out.print(" ");
        System.out.print(ten);  System.out.print("\n");  
        
        System.out.print( 3 * 5 + 6 * 8 + 20 * 10 );  System.out.print("\n"); 
        System.out.print( 3 * 5 + 6 < 100 &&  200 < 7 + 45 * 3 );  System.out.print("\n"); 
        System.out.print( 100 - 50 -10 - 3); System.out.print("\n");
        System.out.print(  3 < 4 && 4 < 2  );    System.out.print("\n");     
        System.out.print(  3 < 4 && 4 < 2 ||  7 == 3 + 8  );   System.out.print("\n");      
        System.out.print(  3 < 4 && 4 < 2 ||  7 == 3 + 8 ||  5 < 8 && 8 < 10 );

    }

}

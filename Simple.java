class Simple {

      public static void main(String [] args) {
           new SecondClass().method1();   
      }

}

class SecondClass {
      
      public void method1() {
           int x;
           int y;
           int z;
           int w;
           boolean b;
           boolean c;
           String n;

           x = 3;
           y = 5;
           w = 7 * 2;
           
           x = 2;

           n = "A String";
           System.out.print("Now a test of string assign...");
           System.out.print("\n");
           System.out.print(n);
           System.out.print("\n");

           z = x + y  + w;
           System.out.print(z);
           System.out.print("\n");

           z = x * y  + w;
           System.out.print(z);
           System.out.print("\n");           

           z = x + y  * w;
           System.out.print(z);
           System.out.print("\n");



           System.out.print("\nasdf\n");
		System.out.print((false || (true && false)));
      }

}

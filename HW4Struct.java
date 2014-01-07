class HW4Struct {

      public static void main(String [] args) {
           new HW4StructClass().method();   
      }
 
}

class Point {
      int x;
      int y;
}

class HW4StructClass {

      public void doublePoint(Point pt) {
          pt.x = 2 * pt.x;
          pt.y = 2 * pt.y;
      }
      
      public void method() {

          int x;
          int y;
          Point pt;
          pt = new Point();
          pt.x = 10;
          pt.y = 20;
          x = 300;
          y = 400;

          System.out.print(pt.x);
          System.out.print("\n");
          System.out.print(pt.y);
          System.out.print("\n");
          System.out.print(x);
          System.out.print("\n");
          System.out.print(y);  
          System.out.print("\n");

          pt.x = 2 * pt.x;
          System.out.print(pt.x);  
          pt.y = 2 * pt.y;
          System.out.print("\n");
          System.out.print(pt.y);  
          System.out.print("\n");
          pt.x = 10;
          pt.y = 20;
          doublePoint(pt);

          System.out.print(pt.x);
          System.out.print("\n");
          System.out.print(pt.y);
          System.out.print("\n");
          System.out.print(x);
          System.out.print("\n");
          System.out.print(y);  
      }

}

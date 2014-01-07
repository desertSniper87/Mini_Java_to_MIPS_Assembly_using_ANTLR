class HW4Inheritance {

      public static void main(String [] args) {
           new HW4StructClass().method();   
      }
 
}

class Point {
      int x;
      int y;
}

class ColoredPoint extends Point {
	int color;
}

class ColoredDot extends ColoredPoint {
	int radius;
}

class HW4StructClass {

      public void setColor(ColoredPoint dot, int color) {
          dot.color = color;
      }

      public void setRadius(ColoredDot pt, int radius) {
          pt.radius = radius;
      }

      public void doublePoint(Point pt) {
          pt.x = 2 * pt.x;
          pt.y = 2 * pt.y;
      }
      
      public void method() {

          int x;
          int y;
          Point pt;
	  ColoredPoint cpt;
		ColoredDot dot;
          pt = new Point();
          pt.x = 10;
	  cpt = new ColoredPoint();
	  dot = new ColoredDot();
	  setRadius(dot, 10);
          pt.y = 20;
          x = 300;
          y = 400;
	setColor(dot, 5); 
          System.out.print(pt.x);
          System.out.print("\n");
          System.out.print(pt.y);
	  dot.x = 200;
	  cpt = dot;
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
	  dot.y = 100;
	  cpt = pt;
          pt.x = 10;
          pt.y = 20;
          doublePoint(pt);

          setColor(cpt, 4); 
	  System.out.print(cpt.color);
	  System.out.print("\n");
	  doublePoint(cpt);
	  System.out.print(dot.radius);
	  System.out.print("\n");
	  System.out.print(cpt.x);
	  System.out.print("\n");
	  System.out.print(cpt.y);
	  System.out.print("\n");
	  System.out.print(dot.x);
	  System.out.print("\n");
	  setColor(cpt, 12);
	  System.out.print(cpt.color);
	  System.out.print("\n");
	  cpt.x = cpt.x / 3;
	  cpt.y = (cpt.y + cpt.x) / 5;
	  System.out.print(cpt.x);
	  System.out.print(dot.y);
	  System.out.print("\n");
	  setColor(cpt, 11);
	  System.out.print("\n");
	  doublePoint(dot);
	  System.out.print(cpt.y);
	  System.out.print("\n");
	  System.out.print(cpt.color);
	  System.out.print("\n");
	  System.out.print(dot.radius);
	  System.out.print("\n");
	  System.out.print(dot.color);
	  System.out.print("\n");
	  System.out.print(dot.x);
	  System.out.print("\n");
	  System.out.print(dot.y);
	  System.out.print("\n");
          System.out.print(pt.x);
          System.out.print("\n");
          System.out.print(pt.y);
          System.out.print("\n");
          System.out.print(x);
          System.out.print("\n");
          System.out.print(y);  
      }

}

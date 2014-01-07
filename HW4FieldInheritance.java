class HW4FieldInheritance {

      public static void main(String [] args) {
           new HW4StructClass().method();   
      }
 
}

class Point {
      int x;
      int y;
}

class ColoredPoint extends Point {
	int z;
	int w;
	int color;
}

class LabeledPoint extends Point {
     String label;
     public void display() {
         System.out.print(x);
         System.out.print(" ");
         System.out.print(y);
         System.out.print(" ");
         System.out.print(label);
     }
}


class ColoredDot extends ColoredPoint {
	int value;
	int radius;
}

class Shape {
      public void display() {
          System.out.print("Shape");
          System.out.print("\n");
      }
}
class Circle extends Shape {
      public void display() {
          System.out.print("Circle");
          System.out.print("\n");
      }
}
class Square extends Shape {
      public void display() {
          System.out.print("Square");
          System.out.print("\n");
      }
}

class Client {
      public void otherMethod(Shape s) {
           s.display();
      }
      public void method() {
          Shape sh1;
          Shape sh2;
          sh1 = new Circle();
          sh2 = new Square();
          otherMethod(sh1);
          otherMethod(sh2);
      }
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
          LabeledPoint lpt;
	  ColoredPoint cpt;
          ColoredDot dot;
          Client client;
          pt = new Point();
          lpt = new LabeledPoint();
          pt.x = 10;
	  cpt = new ColoredPoint();
	  dot= new ColoredDot();
	  setRadius(dot, 10);   /* would require VMT*/
	  dot.radius = 10;
          pt.y = 20;
          x = 300;
          y = 400;
	  setColor(dot, 5);   /* would require VMT */
	  dot.color = 5; 
          System.out.print(pt.x);
          System.out.print("\n");
          System.out.print(pt.y);
	  dot.x = 200;
          System.out.print("\n");
          System.out.print(x);
          lpt.label = "label";
          System.out.print("\n");
          System.out.print(y);  
          client = new Client();
          System.out.print("\n");

          pt.x = 2 * pt.x;
          System.out.print(pt.x);  
          pt.y = 2 * pt.y;
          System.out.print("\n");
          System.out.print(pt.y);  
          System.out.print("\n");
	  dot.y = 177;
          pt.x = 44;
          pt.y = 112;
          doublePoint(pt);

          setColor(cpt, 4); 
	  System.out.print(cpt.color);
	  System.out.print("\n");
	  doublePoint(cpt);  /* would require VMT */
	  cpt.x = cpt.x * 2;
	  cpt.y = cpt.y * 2;
	  cpt.z = 13;
	  System.out.print(dot.radius);
	  System.out.print("\n");
	  System.out.print(cpt.x);
	  cpt.w = 1444;
	  System.out.print("\n");
	  System.out.print(cpt.y);
	  System.out.print("\n");
	  dot.z = 33;
	  System.out.print(dot.x);
	  System.out.print("\n");
	  setColor(cpt, 12);
	  System.out.print(cpt.color);
	  System.out.print("\n");
	  System.out.print(cpt.z);
	  System.out.print("\n");
	  cpt.x = cpt.x / 3;
	  cpt.y = (cpt.y + cpt.x) / 5;
	  System.out.print(cpt.x);
	  System.out.print("\n");
	  System.out.print(dot.y);
	  System.out.print("\n");
	  dot.w = 122;
	  setColor(cpt, 11);
	  doublePoint(dot);  /* would require VMT */
	  dot.x = dot.x * 3;
	  dot.y = dot.y * 4;
	  System.out.print(cpt.y);
	  System.out.print("\n");
	  System.out.print(cpt.z + cpt.w);
	  System.out.print("\n");
	  System.out.print(cpt.color);
	  dot.value = 31;
	  System.out.print("\n");
	  System.out.print(dot.radius);
	  System.out.print("\n");
	  System.out.print(dot.color);
	  System.out.print("\n");
	  System.out.print(dot.x);
	  System.out.print("\n");
	  System.out.print(dot.y);
	  System.out.print("\n");
	  System.out.print(dot.z);
	  System.out.print("\n");
	  System.out.print(dot.w);
	  System.out.print("\n");
	  System.out.print(dot.value);
	  System.out.print("\n");
          client.method();
	  System.out.print(dot.value * cpt.y);
	  System.out.print("\n");
          System.out.print(pt.x);
          System.out.print("\n");
          System.out.print(cpt.y + pt.x + dot.color * dot.value);
          System.out.print("\n");
          System.out.print(pt.y);
          System.out.print("\n");
          System.out.print(x);
          System.out.print("\n");
          System.out.print(y);  
          lpt.display();
          System.out.print("\n");
          System.out.print("done!");
      }

}

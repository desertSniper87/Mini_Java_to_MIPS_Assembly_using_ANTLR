class HW3GraderTest {

      public static void main(String [] args) {
           new HW3Grader().fee();   
      }

}

class HW3Grader {


     public int level1(int a, int b) {
         int e;
         int f;
         e = a * 13;
         f = b * 15;
         System.out.print(e);
         System.out.print("\n");          
         System.out.print(f);
         System.out.print("\n");             
         return e - f;      
     }
     
     public int level2(int b, int a) {
         int d;
         int c;
         d = b * 7;
         c = a * 11;
         System.out.print(c);
         System.out.print("\n"); 
         System.out.print(d);  
         System.out.print("\n");                
         System.out.print(level1(d,c));
         System.out.print("\n");         
         return d+c;
     }
     
     public int level3(int a, int b) {
         int c;
         int d;
         c = 3 * a;
         d = 5 * b;
         System.out.print(c);
         System.out.print("\n");          
         System.out.print(d); 
         System.out.print("\n");                          
         System.out.print(level2(c,d));
         System.out.print("\n");         
         System.out.print(c);
         System.out.print("\n");         
         System.out.print(a);
         System.out.print("\n");         
         System.out.print(b);
         System.out.print("\n");         
         System.out.print("\n");         
         return c + b;
     }

     public int inc(int x) {
         return x + 1;
     }
     
     public int sum(int x, int y) {
         if (y == 0) {
             return x;
         } else {
             return sum(inc(x),y-1);
         }
     }     

     public void fee() {
         int i;
         int j;
         
         i = 10;
         while (i < 100) {
             j = 3;
             while (j < 9) {
                 System.out.print(i*10+j);
                 System.out.print(" ");
                 j = j + 2;
             }
             System.out.print("\n");
             i = i + 10;
         }
         
         if (6 < 3) {
             if (4 == 4) {
                 if (true) {
                    System.out.print("A");
                 } else {
                    System.out.print("B");                 
                 }
             } else {
                 if (true) {
                    System.out.print("C");
                 } else {
                    System.out.print("D");                 
                 }             
             }
         } else {
             if (4 == 3) {
                 if (false) {
                    System.out.print("E");
                 } else {
                    System.out.print("F");                 
                 }             
             } else {
                 if (true) {
                    System.out.print("G");
                 } else {
                    System.out.print("H");                 
                 }             
             }        
         }
                  
         System.out.print("\n");         
         System.out.print(inc(3));
         System.out.print("\n");          
         System.out.print(inc(inc(inc(4))));      
         System.out.print("\n"); 
         System.out.print(sum(4,sum(5,6)));
         System.out.print("\n");         
         System.out.print(sum(sum(sum(1,2),3),4));  
         System.out.print("\n");                   
         System.out.print(level3(3,4));
                                    
     }

}

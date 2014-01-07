class Bool {

      public static void main(String [] args) {
           new BoolTest().method();   
      }

}

class BoolTest {

   public void method() {

      boolean v1;
      boolean v2;
      boolean andV;
      boolean orV;
      boolean notV;
      boolean eqV;
      
      v1 = true;
      v2 = true;
      andV = v1 && v2;
      orV = v1 || v2;
      notV = ! v1;
      eqV = v1 == v2;
      System.out.print(v1); System.out.print("\n");
      System.out.print(v2); System.out.print("\n");      
      System.out.print(andV); System.out.print("\n");     
      System.out.print(orV); System.out.print("\n");
      System.out.print(notV); System.out.print("\n");
      System.out.print(eqV); System.out.print("\n");      
      
      v1 = false;
      andV = v1 && v2;
      orV = v1 || v2;
      notV = ! v1;
      eqV = v1 == v2;
      System.out.print(v1); System.out.print("\n");
      System.out.print(v2); System.out.print("\n");      
      System.out.print(andV); System.out.print("\n");     
      System.out.print(orV); System.out.print("\n");
      System.out.print(notV); System.out.print("\n");
      System.out.print(eqV); System.out.print("\n");       
 
      System.out.print(     !true  == !!true   );   System.out.print("\n");  
      System.out.print(   !(!true  == !!true)  );   System.out.print("\n");
      System.out.print(   !(!true  == !!true) == false  );   System.out.print("\n");
      System.out.print(   !(!true  == !!true) == true  );   System.out.print("\n");   
      System.out.print(   !(!true  == !!true) == true && false );   System.out.print("\n");
      System.out.print(   !(!true  == !!true) == true && true );   System.out.print("\n");           
      System.out.print(   !(!true  == !!true) == true && false == false );    System.out.print("\n");                             
      System.out.print(   !(!true  == !!true) == true && false == true  );   System.out.print("\n");
      System.out.print(   !(!true  == !!true) == true && false == true || true );    System.out.print("\n");     
      System.out.print(   !(!true  == !!true) == true && false == true || false );
   }  
      
}


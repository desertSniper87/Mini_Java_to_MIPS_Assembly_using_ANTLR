class TestMethodRet {

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
      boolean varTrue; // = true;
      boolean varFalse; // = true;
      varTrue = true;
      varFalse = false;
      v1 = TRUE();
      v2 = TRUE();
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
      
      v1 = FALSE();
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
      System.out.print("hello??"); 
      System.out.print(FALSE() && TRUE()); System.out.print("\n"); 
      System.out.print(varFalse && varTrue); System.out.print("\n"); 
      System.out.print(TRUE() && FALSE()); System.out.print("\n"); 
      System.out.print(TRUE() || FALSE()); System.out.print("\n"); 
      System.out.print(false || false); System.out.print("\n"); 
      System.out.print(FALSE() || FALSE()); System.out.print("\n"); 
      System.out.print(FALSE() && FALSE()); System.out.print("\n"); 
      System.out.print(FALSE() || TRUE()); System.out.print("\n"); 
      System.out.print(TRUE() && TRUE()); System.out.print("\n"); 
      System.out.print(TRUE() || TRUE()); System.out.print("\n"); 
      System.out.print(     !TRUE()  == !!TRUE()   );   System.out.print("\n");  
      System.out.print(   !(!TRUE()  == !!TRUE())  );   System.out.print("\n");
      System.out.print(   !(!TRUE()  == !!TRUE()) == FALSE()  );   System.out.print("\n");
      System.out.print(   !(!TRUE()  == !!TRUE()) == TRUE()  );   System.out.print("\n");   
      System.out.print(   !(!TRUE()  == !!TRUE()) == TRUE() && FALSE() );   System.out.print("\n");
      System.out.print(   !(!TRUE()  == !!TRUE()) == TRUE() && TRUE() );   System.out.print("\n");           
      System.out.print(   !(!TRUE()  == !!TRUE()) == TRUE() && FALSE() == FALSE() );    System.out.print("\n");                             
      System.out.print(   !(!TRUE()  == !!TRUE()) == TRUE() && FALSE() == TRUE()  );   System.out.print("\n");
      System.out.print(   !(!TRUE()  == !!TRUE()) == TRUE() && FALSE() == TRUE() || TRUE() );    System.out.print("\n");     
      System.out.print(TRUE());
      System.out.print("\n");
      System.out.print(FALSE());
      System.out.print("\n");
      System.out.print(FALSE());
      System.out.print("\n");
      System.out.print(TRUE());
      System.out.print("\n");
      System.out.print(   !(!TRUE()  == !!TRUE()) == TRUE() && FALSE() == TRUE() || FALSE() );
   }  
   public boolean TRUE() {
	   return true;
   }

   public boolean FALSE() {
	   return false;
   }
}


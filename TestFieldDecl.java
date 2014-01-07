class HW4Simple {

      public static void main(String [] args) {
           new HW4().method();   
      }
      

}

class HW4 {

   public void method() {

       System.out.print("hello\n");
                                         
   }  

      
}



class BankAccountNode {
      BankAccount bankAcct; 
      BankAccountNode next;
}

class BankAccount {

      int balance;
      boolean tf;
      String msg;


      public void deposit(int newAmt) {
         if (0 < newAmt) {
             balance = balance + newAmt;
         } else {
         }
      }

      public void withdraw(int newAmt) {
	 BankAccount tmp;
	 tmp = new BankAccount();   
         if (0 < newAmt) {
             balance = balance - newAmt;
         } else {
         }
      }
}

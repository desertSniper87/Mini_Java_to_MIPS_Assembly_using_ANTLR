class HW4Simple {

      public static void main(String [] args) {
           new HW4().method();   
      }
      

}

class BankAccount {

      int balance;


      public void deposit(int newAmt) {
         if (0 < newAmt) {
             balance = balance + newAmt;
         } else {
         }
      }

      public void withdraw(int newAmt) {
         if (0 < newAmt) {
             balance = balance - newAmt;
         } else {
         }
      }
}

class BankAccountNode {
      BankAccount bankAcct; 
      BankAccountNode next;
}

class BankAccountList {
      BankAccountNode first;

      public void init() {
          first = null;
      }

      public void addAccount(BankAccount bankAcct) {
          BankAccountNode newNode;
          newNode = new BankAccountNode();
          newNode.bankAcct = bankAcct;
          newNode.next = first;
          first = newNode;
          //System.out.print(first.bankAcct.balance);
          //System.out.print("\n");

      }

      public int totalBalance() {
          BankAccountNode curr;
          int total;
          total = 0;
          curr = first;
          while (!(curr == null)) {
              total = total + curr.bankAcct.balance;
              curr = curr.next;
          }
          return total;
      }
      
      public BankAccount maxAccount() {
          BankAccount max;
          BankAccountNode curr; 
          max = first.bankAcct;
          curr = first.next;
	  System.out.print("max balance: ");
	  System.out.print(max.balance);
	  System.out.print("\n");
          while (!(curr == null)) {
	  System.out.print("current balance: ");
	  System.out.print(curr.bankAcct.balance);
	  System.out.print("\n");
              if (max.balance < curr.bankAcct.balance) {
	  System.out.print(curr.bankAcct.balance);
	  System.out.print("\n");
                 max = curr.bankAcct;
              } else {
              }
              curr = curr.next;
          }
          return max;         
      }
}

class HW4 {


   public void method() {

       BankAccountList bnk;
       BankAccount bkAcct1;
       BankAccount bkAcct2;
       BankAccount bkAcct3;
       
       bnk = new BankAccountList();
       bnk.init();
       bkAcct1 = new BankAccount();
       bkAcct2 = new BankAccount();
       bkAcct3 = new BankAccount();

       bnk.addAccount(bkAcct1);
       bnk.addAccount(bkAcct2);
       bnk.addAccount(bkAcct3);

       bkAcct1.deposit(100);
       bkAcct1.withdraw(20);
       bkAcct1.deposit(500);

       bkAcct2.deposit(1000);
       bkAcct1.withdraw(40);
       bkAcct1.withdraw(30);

       bkAcct3.deposit(10000);
       bkAcct3.deposit(5000);

       System.out.print(bkAcct1.balance);
       System.out.print("\n");

       System.out.print(bkAcct2.balance);
       System.out.print("\n");

       System.out.print(bkAcct3.balance);
       System.out.print("\n");

       System.out.print("Total Bank Balances: ");
       System.out.print(bnk.totalBalance());
       System.out.print("\n");
       
       bkAcct2.deposit(bnk.first.bankAcct.balance);
       bnk.first.bankAcct.withdraw(bnk.first.bankAcct.balance);
       
       System.out.print(bkAcct1.balance);
       System.out.print("\n");

       System.out.print(bkAcct2.balance);
       System.out.print("\n");

       System.out.print(bkAcct3.balance);
       System.out.print("\n");       
       
       System.out.print(bnk.maxAccount().balance);
                                         
   }  
   

   
      
}



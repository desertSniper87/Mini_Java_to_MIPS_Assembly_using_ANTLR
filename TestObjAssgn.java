class TestObjAssgn {

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
          while (!(curr == null)) {
              if (max.balance < curr.bankAcct.balance) {
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
       BankAccount bkAcct2;
       BankAccount bkAcct3;
       bkAcct3 = new BankAccount();
       bkAcct2 = new BankAccount();
       bkAcct2.balance = 2;
       bkAcct3.balance = 300;
       bkAcct3 = bkAcct2;
       System.out.print(bkAcct3.balance);
       System.out.print("\n");
       System.out.print(bkAcct2.balance);
   }  

}

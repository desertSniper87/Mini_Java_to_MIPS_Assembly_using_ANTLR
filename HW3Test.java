class HW3Test {

      public static void main(String [] args) {
           new HW3().method();   
      }

}

class HW3 {

   public int sum(int a, int b) {
       int sum;
       sum = a + b;
       return sum;
   }
   
   public int mult(int m, int n) {
       int i;
       int total;
       i = 0;
       total = 0;
       while (i < n) {
           total = sum(total,m);
           i = i + 1;
       }
       return total;
   }
   
   public int fact(int n) {
       if (n == 1) {
           return 1;
       } else {
           return n * fact(n-1);
       }
   }

	public boolean FALSE() {
		return false;
	}

	public boolean TRUE() {
		return true;
	}

   public void method() {
       System.out.print(fact(6));
       System.out.print("\n");
       System.out.print(mult(5,8));
       System.out.print("\n");
       System.out.print(mult(5,8) * mult(1,3));
       System.out.print("\n");
       System.out.print(fact(mult(sum(2, 1), sum(1, 2))));
   }   
   
   
}

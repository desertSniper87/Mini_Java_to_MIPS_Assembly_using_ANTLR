class TestIntMethodCall {
	public static void main(String [] args) {
	  	new secondclass().method1();
	}
}

class secondclass {
	public void method1() {
		int SUM;
		/*
		System.out.print(sum_mult(31, 7331, sum3(33, sum2(3, 5), sum_mult(3, 4, 54))));
		System.out.print("\n");
		System.out.print(sum2(3, 5) + sum3(3, 5, 1));
		System.out.print("\n");
		SUM = sum2(3, 5) + sum3(3, 5, 1);

		System.out.print(SUM);
		*/
		/*
		System.out.print(sum2(1, 2));
		System.out.print("\n");
		System.out.print(sum2(3, 5) + sum3(3, 5, 1));
		System.out.print("\n");
		*/
		System.out.print(sum_mult(31, 7331, sum3(33, sum2(3, 5), sum_mult(3, 4, 54))));
	}

	public int sum2(int a, int b) {
		System.out.print("calling sum2");
		System.out.print("\n");
		System.out.print("sum == ");
		System.out.print(a + b);
		System.out.print("\n");
		return a + b;
	}

	public int sum3(int a, int b, int c) {
		System.out.print("calling sum3");
		System.out.print("\n");
		System.out.print("sum == ");
		System.out.print(a + b + c);
		System.out.print("\n");
		return a + b + c;
	}

	public int sum_mult(int a, int b, int c) {
		int s;
		int p; 
		s = a + b;
		p = c * s;
		System.out.print("calling sum_mult");
		System.out.print("\n");
		System.out.print("result == ");
		System.out.print(c * (a + b));
		System.out.print("\n");
		return p;
	}
}


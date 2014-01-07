class TestRecursion {
	public static void main(String [] args) {
	  	new secondclass().method1();
	}
}

class secondclass {
	public void method1() {
		testVoidRecursion(4 + 3);
		testIntRecursionSimple(2 * (2 * 2 + 1));
		testIntRecursionOnceOnly(2);
		testIntRecursion(12);
		System.out.print("recursion tests finished successfully!");
	}
		
	public void testVoidRecursion(int n) { 
		System.out.print(n);
		System.out.print("\n");
		if (n > 0) {
			testVoidRecursion(n - 1);
		}
	}

	public int testIntRecursionSimple(int n) {   /* for some reason reading from fp directly is not allowed  */
		int ret;
		int N;
		ret = 0;
		if (n > 0) {
			ret = testIntRecursionSimple(n - 1);
		}
		N = ret;
		while (N > 0) {
			System.out.print(1);
			N = N - 1;
		}
		return ret;
	}

	public int testIntRecursionOnceOnly(int n) {
		int k;
		int temp;
		temp = n;
		if (n > 0) {
			k = n;
			while (k > 0) {
				System.out.print("1");
				k = k - 1;
			}
			System.out.print("\n");
		}
		System.out.print("done!");
		System.out.print("\n");
		System.out.print(n);
		if (n > 5) {
			testIntRecursionOnceOnly(5);
		}
		return n;
	}

	public int testIntRecursion(int n) {
		int k;
		int temp;
		temp = n;
		if (n > 0) {
			k = n / 3;
			while (k > 0) {
				System.out.print("1");
				k = k - 1;
			}
			System.out.print("\n");
		}
		System.out.print("done!");
		System.out.print("\n");
		System.out.print(n);
		System.out.print("\n");
		if (n > 0) {
			testIntRecursion(n - 1);
		}
		return n;
	}
}


class TestIntArithmatic {
	public static void main(String [] args) {
	  	new secondclass().method1();
	}
}

class secondclass {
	public void method1() {
		int a;
		int b;
		int c;
		a = 4; 
		System.out.print(a);
		System.out.print("\n");
		a = 4 + (2); 
		System.out.print(a);
		System.out.print("\n");
		a = 22 - (1 + 2) - ((4 / 3)) * (5 + 6);
		System.out.print(a);
		System.out.print("\n");
		System.out.print(a == a);
		System.out.print("\n");
		b = 9 / (8 / 4);
		System.out.print(b);
		System.out.print("\n");
		c = a + 12 * b * a / (2 + (1 + b * (a + 1) + 6 / (10 - a))); 
		System.out.print(c);
		System.out.print("\n");
		System.out.print(c == a);
	}
}


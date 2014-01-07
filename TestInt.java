class TestInt {
	public static void main(String [] args) {
	  	new secondclass().method1();
	}
}

class secondclass {
	public void method1() {
		int a;
		int b;
		a = 4 - 6 / 3; 
		System.out.print(a);
		System.out.print("\n");
		a = 22 - (1 + 2 - (4 / 3)) * (5 + 6);
		System.out.print(a);
		System.out.print("\n");
		System.out.print(a == a);
		System.out.print("\n");
		b = 9 / (8 / 4);
		System.out.print(b);
	}
}


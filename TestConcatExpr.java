class TestConcatExpr {
	public static void main(String [] args) {
		new secondclass().method1();
	}
}

class secondclass {

	public void method1() {
		String c;
		String d;
		c = "HELLO!";
		d = " Good bye!";
		c = c + d;
		System.out.print(c + d); 
		System.out.print("\n");
		c = "c" + ("a" + "dsl");
		System.out.print(c + d); 
	}
}


class TestBoolean {

	public static void main(String [] args) {
		new secondclass().method1();
	}

}

class secondclass {

	public void method1() {
		boolean a;
		boolean b;
		boolean c;
		b = (false || false || (true && (false || (true)))) && (false && true);	
		System.out.print(b);
		System.out.print("\n");
		a = false || false || (true && (false || (true)));
		System.out.print(a);
		System.out.print("\n");
		a = (false || true) && (true && (false || true)) && (false && true);	
		System.out.print(a);
		System.out.print("\n");
		a = !(false || true) && (true || false);
		System.out.print(a);
		System.out.print("\n");
		c = (a && (false || true));
		System.out.print(a);
		System.out.print("\n");
		System.out.print(c);
		System.out.print("\n");
		a = (false || true) && (true && (false || true)) && (!(false || true) && (true || false));
		System.out.print(b);
		System.out.print("\n");
		System.out.print(a);
		System.out.print("\n");
		System.out.print(b);
		System.out.print(false && (false || true));
	}
}


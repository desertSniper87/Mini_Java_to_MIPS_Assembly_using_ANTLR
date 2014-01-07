class Test {

	public static void main(String [] args) {
		new secondclass().method1();
	}

}

class secondclass {

	public void method1() {
		boolean a;
		boolean b;
		boolean c;
		a = (false || true) && (true && (false || true)) && (false && true);	
		System.out.print(a);
		a = !(false || true) && (true || false);
		b = (false || false || (true && (false || ((true))))) && (false && true);	
		c = (a && (false || true));
		System.out.print(a);
		System.out.print(b);
		System.out.print(c);
		a = (false || true) && (true && (false || true)) && (!(false || true) && (true || false));
		System.out.print(b);
		System.out.print(a);
		System.out.print(b);
	}
}


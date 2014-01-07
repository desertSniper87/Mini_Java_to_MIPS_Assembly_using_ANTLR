class BasicMethodCall {
	public static void main(String [] args) {
		new HW3().method();   
	}
}

class HW3 {

	public void method() {
		int a; 
		String s;
		s = "hello";
		a = (3 + (4 + 5) * 2) / 6 - 2;
		System.out.print(s);
		System.out.print("\n");
		print_int(a);
		System.out.print("\n");
		print_concat2(s, s);
	}

	public void print_int(int a) {
		System.out.print(a);
	}

	public void print_concat2(String a, String b) {
		System.out.print(a + b);
	}
}


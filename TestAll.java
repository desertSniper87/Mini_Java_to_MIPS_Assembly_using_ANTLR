class TestAll {
	public static void main(String [] args) {
		new secondclass().method1();
	}
}

class secondclass {

	public void method1() {
		int a;
		int b;
		boolean F;
		boolean T;
		boolean B;
		String c;
		String d;

		System.out.print("hello");
		System.out.print("\n");
		System.out.print(5);
		System.out.print("\n");
		System.out.print(5 + 5);
		System.out.print("\n");
		System.out.print(5 * 3);
		System.out.print("\n");
		System.out.print("hello" + ", HELLO!!");
		System.out.print("\n");

		System.out.print(true == false == true == false);
		System.out.print("\n");
		System.out.print(true == true == false);
		System.out.print("\n");
		System.out.print(false == false == true == false == true);
		System.out.print("\n");
		System.out.print(false == true == false);
		System.out.print("\n");

		c = "HELLO!";
		a = 1 * (2 + 2 * (3 + 4 * (3 - 7)));
		B = (1 + 2) < (3 + 4); 
		System.out.print(a);
		System.out.print("\n");
		F = false;
		T = true;
		T = !T;
		System.out.print(T);
		System.out.print("\n");
		T = !T;
		System.out.print(B);
		System.out.print("\n");
		System.out.print(T);
		System.out.print("\n");
		T = !F && !F;
		System.out.print(T);
		System.out.print("\n");
		T = true;
		B = (1 + 2) > (3 + 4); 
		F = false;
		T = !((F && T) || F || T); 
		System.out.print(T);
		System.out.print("\n");
		System.out.print(B);
		System.out.print("\n");
		System.out.print(c);
		System.out.print("\n");
		F = F == T;
		System.out.print(F);
		System.out.print("\n");
		B = (1 + 2) == (3 + 4); 
		d = " Good bye!";
		System.out.print(B);
		a = 7 - (8 + 9 * (10));
		System.out.print(F && T);
		System.out.print("\n");
		System.out.print(c + d);
		System.out.print("\n");
		System.out.print(T && T);
		System.out.print("\n");
		System.out.print(a);
		System.out.print("\n");
		a = 1337 * (1 + 2 * (3 + 4 * (5 - 6))) / (7 - (8 + 9 * (10)));
		System.out.print(F || F);
		System.out.print("\n");
		System.out.print(a);
		System.out.print("\n");
		System.out.print(T || F);
		System.out.print("\n");
		a = 0 - a;
		System.out.print(a);
		System.out.print("\n");
		b = (1 + 2) * (3 + 4); 
		B = (4 + 3) > (3 + 4) || (1 + 2) < (3 + 4) ; 
		System.out.print(c + c);
		System.out.print("\n");
		System.out.print(d + (c + d));
		System.out.print("\n");
		d = d + d;
		System.out.print(B);
		System.out.print("\n");
		//a = 1;
		System.out.print("hello!");
		System.out.print("\n");
		B = (1 + 2) < (3 + 4); 
		System.out.print(B);
		System.out.print("\n");
		System.out.print(a);
		System.out.print("\n");
		a = a + a;
		System.out.print(d + (d + d + (d)));
		System.out.print("\n");
		System.out.print(a);
		System.out.print("\n");
		a = 99 + (0 + 1) / (2 + 3);
		System.out.print(a);
	}
}


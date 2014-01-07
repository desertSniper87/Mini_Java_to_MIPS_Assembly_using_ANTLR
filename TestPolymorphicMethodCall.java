class TestPolymorphicMethodCall {
	public static void main(String[] args) {
		new Test().method();
	}
}

class X {
}

class Y extends X {
}

class Z extends Y {
}

class A  {
    public void fun0() {
       System.out.print("A fun0");
       System.out.print("\n");
    }

    public void fun1() {
       System.out.print("A fun1");
       System.out.print("\n");
    }

    public void fun2() {
       System.out.print("A fun2");
       System.out.print("\n");
    }

}


class B extends A {

    public void fun1() {
       System.out.print("B fun1");
       System.out.print("\n");
    }

    public void fun4() {
       System.out.print("B fun4");
       System.out.print("\n");
    }

}


class C extends B {

    public void fun5() {
       System.out.print("C fun5");
       System.out.print("\n");
    }

    public void fun1() {
       System.out.print("C fun1");
       System.out.print("\n");
    }

}

class D extends C {

    public void fun5() {
       System.out.print("D fun5");
       System.out.print("\n");
    }

    public void fun1() {
       System.out.print("D fun1");
       System.out.print("\n");
    }

}



class processA {
	public void proc0(X b, Y c) {
		System.out.print("processA x, y");
		System.out.print("\n");
	}

	public void proc0(Y b, X c) {
		System.out.print("processA y, x");
		System.out.print("\n");
	}

	public void proc1(Y b, Y c) {
		System.out.print("processA y, y");
		System.out.print("\n");
	}

	public void proc2(Y y, Z z) {
		System.out.print("processA y, z");
		System.out.print("\n");
	}

	public void proc3(Y y, Z z) {
		System.out.print("processA y, z");
		System.out.print("\n");
	}

	public void proc4(Y y, Y z) {
		System.out.print("processA y, z");
		System.out.print("\n");
	}
}

class processB extends processA {
	public void proc1(Z z, Y y) {   /* overloading, not overriding */
		System.out.print("processB z, y");
		System.out.print("\n");
	}

	public int proc2(Y y1, Y y2) {  /* also overloading */
		System.out.print("processB y, y");
		System.out.print("\n");
		return 5;
	}

	public void proc3(Y y, Z z) {  /* overriding, must have compatible return type */
		System.out.print("processB y, z");
		System.out.print("\n");
	}

	public void proc4(Y y, Y z) {
		System.out.print("processB y, z");
		System.out.print("\n");
	}
}

class processC extends processB{
	public void proc3(Y y, Z z) {
		System.out.print("processC y, z");
		System.out.print("\n");
	}

	public void proc4(Y y, Y z) {
		System.out.print("processC y, z");
		System.out.print("\n");
	}
}

class Test {
	public void method() {
		X x;
		Y y;
		Z z;
		A objA;
		B objB;
		C objC;
		D objD;

		processA a;
		processB b;
		processC c;

		objA = new A();

		x = new X();
		y = new Y();
		z = new Z();
		objC = new C();
		b = new processB();
		c = new processC();
		objB = new B();

		a = new processA();
		//a.proc0(y, y);  // ambiguous
		a.proc0(x, y);  // ambiguous

		b.proc1(y, z);   /* A: this version is still inherited from processA */
		objB.fun1();
		b.proc1(z, y);   /* B: method overloading */

		System.out.print("\n");
		b.proc2(y, y);   /* B: method overloading */
		objB.fun2();
		objC.fun1();
		b.proc2(y, z);   /* A: method overloading */

		System.out.print("\n");
		b.proc2(z, y);   /* method overloading */
		b.proc2(z, z);   /* method overloading */
		objA.fun2();
		objB.fun4();

		System.out.print("\n");  /* method overloading */
		// b.proc3(y, y);   // no suitable method found

		b.proc4(y, z);  /* method overriding*/

		System.out.print("\n");  /* method overriding */
		c.proc3(z, z);
		c.proc3(y, z);
		c.proc4(z, z);

		objC.fun2();
		objD = new D();
		objD.fun0();
		System.out.print("polymorphic method call test completed successfully");
	}
}

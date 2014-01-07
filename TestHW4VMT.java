class Z {
	public String toString() {
		return "Z";
	}
}

class A extends Z{
	public String toString() {
		return "A";
	}
}

class B extends A {
	public String toString() {
		return "B";
	}
}

class Test1 extends Test {

	public void process(final Z z) {
		System.out.println(z.toString());
	}

	public void process(final B b) {
		System.out.println("processing1 " + b.toString());
	}
	
	public void doubleProcess(final Z z, final A a) {
		System.err.println("this is one of the purposely ambiguous method calls");
	}

	public void doubleProcess(final A a, final Z z) {
		System.err.println("this is one of the purposely ambiguous method calls");
	}
}

public class TestHW4VMT {

	public void process(final B b) {
		System.out.println("processing B");
	}

	public void process(final A a) {
		System.out.println("processing A");
	}

	public static void main(String args[]) {
		A a = new B();
		B b = new B();
		new TestHW4VMT().process(new A());
		new TestHW4VMT().process(new B());
		new TestHW4VMT().process(a);
		new Test1().process(a);
		new Test1().process(b);
		new TestHW4VMT().process(b);
		//new Test1().doubleProcess(new B(), new B());   /* ambiguous method call */
	}

}

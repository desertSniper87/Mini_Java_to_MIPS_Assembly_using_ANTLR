class TestClsVar {

	public static void main(String [] args) {
		new secondclass().method1();
	}

}

class secondclass {

	boolean a;
	int b;
	String c;
	String d;

	public void method1() {
		BankAccount A;
		BankAccount B;
		A = new BankAccount();
		B = new BankAccount();
		A.amount = 5;
		System.out.print(A.amount);
		System.out.print("\n");
		b = 5;
		a = false;
		System.out.print(b);
		System.out.print("\n");
		a = true;
		System.out.print(b);
		System.out.print("\n");
		c = "HELLO??HELLO??";
		d = c + c;
		System.out.print("\n");
		System.out.print(c);
		System.out.print("\n");
		System.out.print(b);
		System.out.print("\n");
		c = "HELLO??";
		b = 7;
		System.out.print(c);
		System.out.print("\n");
		System.out.print(b);
		System.out.print("\n");
		System.out.print(a);
		d = "HELLO??????" + d;
		System.out.print("\n");
		System.out.print(d);
		System.out.print("\n");
		A.setIsChecking(true);
		A.setAmount(7331);
		B.setIsChecking(false);
		B.setAmount(1337);
		System.out.print(B.getIsChecking());
		System.out.print("\n");
		A.printIsChecking();
		System.out.print("\n");
		A.printAmount();
		System.out.print("\n");
		System.out.print("A has ");
		System.out.print(A.getAmount());
		System.out.print("\n");
		System.out.print("B has ");
		System.out.print(B.getAmount());
		System.out.print("\n");
		System.out.print("total amount == ");
		System.out.print(A.getAmount() + B.getAmount());
		System.out.print("\n");
		B.printIsChecking();
		System.out.print("\n");
		System.out.print(A.getIsChecking());
		System.out.print(A.isChecking);
		System.out.print("\n");
		B.printAmount();
		System.out.print(B.getAmount());
		System.out.print("\n");
		System.out.print(B.amount);
		System.out.print("\n");
		A.setIsChecking(true);
		A.setAmount(7331);
		B.setIsChecking(false);
		B.setAmount(1337);
		System.out.print(A.getAmount() + B.getAmount());
		System.out.print(" \n");
		System.out.print(A.amount + B.amount);
		System.out.print(" \n");
		System.out.print(A.getAmount() * B.getAmount());
		System.out.print(" \n");
		System.out.print(A.amount * B.amount);
		System.out.print(" \n");
		System.out.print(A.amount * B.getAmount());
		System.out.print(" \n");
		System.out.print(A.getAmount() + B.amount);
		System.out.print(" \n");
		System.out.print(A.getIsChecking());
		System.out.print(" \n");
		System.out.print(B.getIsChecking());
		System.out.print(" \n");
		System.out.print(A.getIsChecking());
		System.out.print(" \n");
		System.out.print(B.getIsChecking());
		System.out.print(" \n");
		System.out.print(A.getIsChecking() || B.getIsChecking());
		System.out.print(" \n");
		System.out.print(A.getIsChecking() && B.getIsChecking());
		System.out.print(" \n");
		System.out.print(A.isChecking || B.getIsChecking());
		System.out.print(" \n");
		System.out.print(A.getIsChecking() && B.isChecking);
		System.out.print(" \n");
		A.amount = 5;
		B.amount = 33;
		A.isChecking = false;
		System.out.print(A.getIsChecking());
		System.out.print("\n");
		System.out.print("amount of A: ");
		System.out.print(A.getAmount());
		System.out.print("\n");
		System.out.print("amount of B: ");
		System.out.print(B.amount);
		System.out.print("\n");
		A.isChecking = true;
		System.out.print(A.isChecking);
		System.out.print("\n");
		A.isChecking = false;
		System.out.print(A.isChecking);
		System.out.print("\n");
		System.out.print(A.getIsChecking());
	}
}

class BankAccount {
	boolean isChecking;
	int amount;

	public void setIsChecking(boolean __isChecking) {
		isChecking = __isChecking;
	}

	public void setAmount(int __amount) {
		amount = __amount;
	}

	public void printIsChecking() {
		System.out.print(isChecking);
		System.out.print("\n");
	}

	public void printAmount() {
		System.out.print(amount);
		System.out.print("\n");
	}

	public int getAmount() {
		return amount;
	}

	public boolean getIsChecking() {
		return isChecking;
	}
}

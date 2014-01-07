class TestHeapAlloc {

	public static void main(String [] args) {
		new SecondClass().method1();   
	}

}

class SecondClass {
	int num;
	BankAccount yetAnother;
	public void method1() {
		BankAccount b;
		SecondClass c;
		b = new BankAccount();
		c = new SecondClass();
	}

}

class BankAccount {
	boolean isSaving;
	int amount;
	String accountHolder;
	BankAccount linkedAccount;
}

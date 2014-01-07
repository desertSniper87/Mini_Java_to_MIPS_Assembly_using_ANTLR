public class TestShadow {
	private int param = 1337;
	private boolean param1 = false;
	private Object param2 = null;

	private int test(int param2) {
		int param = -1;
		int param1 = 100;
		//boolean ans = param1; 
		System.out.println(param1);
		System.out.println(param2);
		//System.out.println(ans);
		return param;
	}

	public static void main(String args[]) {
		System.out.println(new TestShadow().test(13));
	}
}

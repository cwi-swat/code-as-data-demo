
public class BadProgrammer {
	public boolean justOnce() {
		// you never know!
		if (System.out != null) {
			return true;
		}
		else {
			return false;
		}
	}
	
	public boolean twoViolations() {
		if (System.out != null) 
			return true;
		else 
			return false;

	}

	public void glassHalfFull(int glass) {
		if (!(glass < 50)) {
			// comments inside
			System.out.println("The cake is a lie");
			throw new RuntimeException("Escape the stack!");
		} 
 		else {
			System.out.println("BBQ?");
		}
	}

	private final static Object fallBack = "DigiNotar";

	public boolean checkCertificate(Object certificate) {
		if (certificate == null) 
			System.out.println("oh oh");
			certificate = fallBack;

		if (certificate.hashCode() > 1) {
			return true;
		}
		else {
			return false;
		}
	}
}

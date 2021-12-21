
public class BadProgrammer {
	public boolean justOnce() {
		// you never know!
		return System.out != null;
	}
	
	public boolean twoViolations() {
		return (System.out != null);

	}

	public void glassHalfFull(int glass) {
		if ((glass < 50)) {
			System.out.println("BBQ?");
		} 
 		else {
			// comments inside
			System.out.println("The cake is a lie");
			throw new RuntimeException("Escape the stack!");
		}
	}

	private final static Object fallBack = "DigiNotar";

	public boolean checkCertificate(Object certificate) {
		if (certificate == null) {
			System.out.println("oh oh");
		}
		certificate = fallBack;

		return certificate.hashCode() > 1;
	}
}

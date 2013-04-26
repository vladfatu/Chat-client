package chat_client.aop;

public aspect LogAspect {

	private static long loginTime;
	
	pointcut sendMethodExecuted(String mesaj, boolean isFile): 
		execution(public * chat_client.Chat_Client.send(String, boolean)) && args(mesaj, isFile);
	
	before(String mesaj, boolean isFile): sendMethodExecuted(mesaj, isFile) {
		if (isFile)
		{
			System.out.printf("Aspect: sending file.\n",
					thisJoinPoint.getSignature());
		}
		else
		{
			System.out.printf("Aspect: sending message: " + mesaj + "    .\n",
					thisJoinPoint.getSignature());
		}
	}
	
	pointcut receiveMethodExecuted(): execution(public * chat_client.Input.handleMessage(String));
	
	before(): receiveMethodExecuted() {
		if (thisJoinPoint.getArgs().length > 0)
		{
			String mesaj = (String)thisJoinPoint.getArgs()[0];
			System.out.printf("Aspect: receiving message: " + mesaj + "  .\n",
					thisJoinPoint.getSignature());
		}
	}
	
	pointcut loginMethodExecuted(): execution(* chat_client.Login.loginActionPerformed(..));
	
	before(): loginMethodExecuted() {
		loginTime = System.currentTimeMillis();
	}
	
	pointcut logoutMethodExecuted(): execution(* chat_client.Meniu.formWindowClosing(..));
	
	after(): logoutMethodExecuted() {
		System.out.println("Aspect: logging out after: " + (System.currentTimeMillis() - loginTime) + " milliseconds");
	}
}

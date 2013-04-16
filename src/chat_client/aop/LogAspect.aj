package chat_client.aop;

public aspect LogAspect {

	pointcut publicMethodExecuted(): execution(public * *(..));

	before(): publicMethodExecuted() {
		System.out.printf("Aspect: About to enter method: %s. \n",
				thisJoinPoint.getSignature());
	}

	after(): publicMethodExecuted() {

		Object[] arguments = thisJoinPoint.getArgs();
		for (int i = 0; i < arguments.length; i++) {
			Object argument = arguments[i];
			if (argument != null) {
				System.out.printf(
						"Aspect: With argument of type %s and value %s. \n",
						argument.getClass().toString(), argument);
			}
		}
		System.out.printf("Aspect: Exits method: %s. \n",
				thisJoinPoint.getSignature());
	}
	
	pointcut adaugaMethodExecuted(): execution(public * chat_client.Meniu.adauga(..));
	
	after(): adaugaMethodExecuted() {
		System.out.printf("Aspect: adauga: Exits method: %s. \n",
				thisJoinPoint.getSignature());
	}
}

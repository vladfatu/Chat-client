package chat_client.aop;

import java.util.logging.Level;
import java.util.logging.Logger;

import org.aspectj.lang.Signature;

public aspect TraceAspect{
	
	pointcut adaugaMethodExecuted(): execution(public * chat_client.Meniu.adauga(..));
	
	before(): adaugaMethodExecuted() {
		Signature sig = thisJoinPointStaticPart.getSignature();
        String line =""+ thisJoinPointStaticPart.getSourceLocation().getLine();
        String sourceName = thisJoinPointStaticPart.getSourceLocation().getWithinType().getCanonicalName();
        Logger.getLogger("Tracing").log(
                Level.INFO, 
                "Aspect: Call from "
                    +  sourceName
                    +" line " +
                    line
                    +" to " +sig.getDeclaringTypeName() + "." + sig.getName()
        );
	}
	
}
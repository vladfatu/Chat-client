package chat_client.aop;

import java.io.DataOutputStream;
import java.io.IOException;

import javax.swing.JLabel;

import chat_client.Chat_Client;
import chat_client.Meniu;

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
			if (Chat_Client.stream == null)
			{
				try {
		            Chat_Client.stream = new DataOutputStream(Chat_Client.s.getOutputStream());
		        } catch (IOException ex) {
		            System.out.println("Streamul nu poate fi creat");
		        }
			}
			for (int i=0;i<Meniu.model.size();i++)
			{
				String nume = ((JLabel)Meniu.model.get(i)).getText();
				if (!nume.equals(Chat_Client.nume1))
				{
					try
					{
						Chat_Client.stream.writeUTF("/msg "+ nume +" Aspect : "+mesaj);
					} catch (IOException e)
					{
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}
			}
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

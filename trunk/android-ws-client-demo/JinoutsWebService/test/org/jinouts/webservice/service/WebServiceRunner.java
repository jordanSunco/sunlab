/**
 * 
 */
package org.jinouts.webservice.service;

import org.jinouts.webservice.service.LoginWebService;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

/**
 * @author asraf
 * asraf344@gmail.com
 */
public class WebServiceRunner
{

	/**
	 * @param args
	 */
	public static void main ( String[] args )
	{
		try
		{
			ApplicationContext context = new ClassPathXmlApplicationContext ( "applicationContext.xml" );
			LoginWebService loginWebService = (LoginWebService) context.getBean ( "loginWebService" );
			
		}
		catch ( Exception ex )
		{
			ex.printStackTrace ( );
		}


	}

}

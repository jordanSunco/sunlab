/**
 * 
 */
package org.jinouts.webservice.service;

import javax.jws.WebMethod;
import javax.jws.WebParam;
import javax.jws.WebService;

import org.jinouts.webservice.model.LoginServiceResponse;

/**
 * @author asraf
 *
 */
@WebService(serviceName="LoginService",  name="login" )
public class LoginWebService
{
	@WebMethod
	public LoginServiceResponse login ( @WebParam(name="user") String userId, @WebParam(name="pass") String password )
	{
		System.out.println ("In the login Method: user-" +userId + "Passwd: "+ password );
		LoginServiceResponse resp = new LoginServiceResponse ( );
		
		if ( userId.equals ( "asraf" ) && password.equals ( "asraf" ) )
		{
			resp.setSuccessCode ( "200" );
			resp.setSuccessMessage ( "Login Successful" );
		}
		else
		{
			resp.setErrorCode ( "notAuth" );
			resp.setErrorMessage (  "Authentication Failed !!!!" );
		}
		
		return resp;
	}
}

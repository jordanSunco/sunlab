/**
 * 
 */
package org.jinouts.webservice.model;

/**
 * @author asraf
 * asraf344@gmail.com
 */
public class LoginServiceResponse
{
	private String successCode;
	private String successMessage;
	private String errorCode;
	private String errorMessage;
	
	
	public String getSuccessCode ( )
	{
		return successCode;
	}
	public void setSuccessCode ( String successCode )
	{
		this.successCode = successCode;
	}
	public String getSuccessMessage ( )
	{
		return successMessage;
	}
	public void setSuccessMessage ( String successMessage )
	{
		this.successMessage = successMessage;
	}
	public String getErrorCode ( )
	{
		return errorCode;
	}
	public void setErrorCode ( String errorCode )
	{
		this.errorCode = errorCode;
	}
	public String getErrorMessage ( )
	{
		return errorMessage;
	}
	public void setErrorMessage ( String errorMessage )
	{
		this.errorMessage = errorMessage;
	}
}

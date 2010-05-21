package com.beyondo.sgs.client.impl.sharedutil
{
	/**
	 * Signals that a method has been invoked at an illegal or inappropriate
	 * time. In other words, the environment or application is not in an
	 * appropriate state for the requested operation.
	 */
	public class IllegalStateException extends Error {
		
		/**
		 * Constructs an IllegalStateException with the specified message.
		 * 
		 * @param message the detail message
		 */
		public function IllegalStateException(
			message:Object="IllegalStateException") {
			super(message);
		}
		
	}
}
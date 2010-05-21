package com.beyondo.sgs.client.impl.sharedutil {
	
	/**
	 * Thrown to indicate that a method has been passed an illegal or
	 * inappropriate argument.
	 */
	public class IllegalArgumentException extends Error {

		/**
		 * Constructs an NullValueException with the specified message.
		 * 
		 * @param message the detail message
		 */
		public function IllegalArgumentException(message:String="") {
			super(message);
		}
		
	}
}
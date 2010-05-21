/**
 * Beyondo licenses this file to You under the GNU General Public
 * License, Version 3.0 (the "License");
 * 
 * You may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *     http://www.gnu.org/licenses/lgpl.html
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.beyondo.sgs.client.impl.client.comm {
	
	import com.beyondo.util.BeyondoByteArray;
	import com.beyondo.sgs.client.client.ServerSessionListener;
	
	/**
	 * Listener for communications events that occur on an associated
	 * <code>ClientConnection</code>.
	 * 
	 * @see com.beyondo.sgs.client.impl.client.comm.ClientConnection ClientConnection
	 */
	public interface ClientConnectionListener	{
		
	    /**
	     * Notifies this listener that a transport connection has
	     * been established.
	     *
	     * @param connection the newly-established connection
	     */
    	function connected(connection : ClientConnection) : void;
    	
	    /**
	     * Notifies this listener that protocol data has arrived from the
	     * server.
	     *
	     * @param message protocol-specific message data
	     * 
	     * @throws com.beyondo.sgs.client.impl.sharedutil.IOException if bad
	     * 		version or other error.
	     */
	    function receivedMessage(message : BeyondoByteArray) : void;
	    
	    /**
	     * Notifies this listener that a new session has successfully logged in.
	     *
	     * @param message protocol-specific session-start data
	     *
	     * @return the listener for events on the new
	     * <code>ServerSession</code>
	     * 
	     * @see com.beyondo.sgs.client.client.ServerSession ServerSession
	     */
	    function sessionStarted(message:BeyondoByteArray) :ServerSessionListener;
	    
	    /**
	     * Notifies this listener that its associated server connection is in
	     * the process of reconnecting with the server.
	     * <p>
	     * If a connection can be re-established with the server in a
	     * timely manner, this listener's <code>reconnected</code>
	     * method will be invoked.  Otherwise, if a connection cannot be
	     * re-established, this listener's <code>disconnected</code>
	     * method will be invoked with <code>false</code> indicating that
	     * the associated session has been disconnected from the server
	     * and the client must log in again.</p>
	     *
	     * @param message protocol-specific reconnection data
	     */
	    function reconnecting(message : BeyondoByteArray) : void;
	    
	    /**
	     * Notifies this listener that a reconnection effort was successful.
	     *
	     * @param message protocol-specific reconnection data
	     */
	    function reconnected(message : BeyondoByteArray) : void;
	    
	    /**
	     * Notifies this listener that the associated server connection is
	     * disconnected.
	     * <p>
	     * If <code>graceful</code> is <code>true</code>, the disconnection was
	     * due to the associated client gracefully logging out; otherwise, the
	     * disconnection was due to other circumstances, such as forced
	     * disconnection or network failure.</p>
	     *
	     * @param graceful <code>true</code> if disconnection was part of graceful
	     *        logout, otherwise <code>false</code>
	     * @param message protocol-specific reconnection data
	     */
	    function disconnected(graceful:Boolean, message:BeyondoByteArray) : void;
	    
	    
	    function exceptionThrown(err:String):void;
	}
}
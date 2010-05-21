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

package com.beyondo.sgs.client.client {
	import com.beyondo.util.BeyondoByteArray;
	
	/**
	 * Represents a client's view of a login session with the server. Each time
	 * a client logs in, it will be assigned a different server session. A
	 * client can use its <code>ServerSession</code> to send messages to the
	 * server, to check if it is connected, or to log out.
	 * <p>
	 * A server session has an associated <code>ServerSessionListener<code> that
	 * is notified of session communication events such as message receipt,
	 * channel joins, reconnection, or disconnection. Once a server session is
	 * disconnected, it can no longer be used to send messages to the server. In
	 * this case, a client must log in again to obtain a new server session to
	 * communicate with the server.</p>
	 */
	public interface ServerSession {
		
    /**
     * Returns the session identifier for this server session.
     * 
     * @return the session identifier for this server session
     *
     * @throws com.beyondo.sgs.client.impl.sharedutil.IllegalStateException if
     * 		this session is disconnected
     */
		function get sessionId() : SessionId;
		
    /**
     * Set the session identifier for this server session.
     * 
     * @throws com.beyondo.sgs.client.impl.sharedutil.IllegalStateException if
     * 		this session is disconnected
     */
		function set sessionId(sessionId:SessionId) : void;
		
    /**
     * Sends the message contained in the specified byte array to the
     * server. The specified message is sent asychronously to the server;
     * therefore, a successful invocation of this method does not indicate
     * that the given message was successfully sent. Messages that are
     * received by the server are delivered in sending order.
     * <p>
     * The specified byte array must not be modified after invoking this
     * method; if the byte array is modified, then this method may have
     * unpredictable results.</p>
     *
     * @param message a message
     *
     * @throws com.beyondo.sgs.client.impl.sharedutil.IOException if this
     * 		session is disconnected or an IO error occurs
     */
		function send(message : BeyondoByteArray) : void;

    /**
     * Returns <code>true</code> if this session is connected, otherwise
     * returns <code>false</code>.
     * 
     * @return <code>true</code> if this session is connected, and
     *         <code>false</code> otherwise
     */
		function isConnected() : Boolean;

    /**
     * Initiates logging out from the server. If <code>force</code> is
     * <code>true</code> then this session is forcibly terminated, for
     * example, by terminating the associated client's network connections.
     * If <code>force</code> is <code>false</code>, then this session
     * is gracefully disconnected, notifying the server that the client
     * logged out. When a session has been logged out, gracefully or
     * otherwise, the <code>ServerSessionListener.disconnected</code>
     * method is invoked on this session's associated
     * <code>ServerSessionListener</code> passing a <code>boolean</code>
     * indicating whether the disconnection was graceful.
     * <p>
     * If this server session is already disconnected, then no action is
     * taken.</p>
     * 
     * @param force if <code>true</code>, this session is forcibly
     *        terminated; otherwise the session is gracefully disconnected
     *
     * @throws com.beyondo.sgs.client.impl.sharedutil.IllegalStateException if
     * 		this session is disconnected
     */
		function logout(force : Boolean) : void;
	}
}
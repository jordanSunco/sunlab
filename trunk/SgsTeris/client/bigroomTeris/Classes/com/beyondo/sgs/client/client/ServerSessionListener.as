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
	 * A client's listener for handling messages sent from server to client and
	 * for handling other connection-related events.
	 * <p>
	 * A <code>ServerSessionListener</code> for a client is notified in the
	 * following cases: when the associated client is joined to a channel
	 * (<code>joinedChannel</code>), a message is received from the
	 * server (<code>receivedMessage</code>), a connection with
	 * the server is being re-established (<code>reconnecting</code>),
	 * a connection has been re-established (<code>reconnected</code>),
	 * or finally when the associated server session becomes disconnected,
	 * gracefully or otherwise (<code>disconnected</code>).</p>
	 * <p>
	 * If a server session becomes disconnected, it can no longer be used to
	 * send messages to the server. In this case, a client must log in again to
	 * obtain a new server session to communicate with the server.</p>
	 */
	public interface ServerSessionListener {
		
		/**
		 * Notifies this listener that its associated client has joined the
		 * specified channel, and returns a <code>ClientChannelListener</code> for
		 * that channel.
		 * <p>
		 * When a message is received on the specified channel, the returned
		 * listener's <code>ClientChannelListener.receivedMessage</code>
		 * method is invoked with the specified channel, the
		 * sender's session identifier, and the message. A <code>null</code>
		 * sender indicates that the message was sent by the server. The
		 * returned listener is <i>not</i> notified of messages that its client
		 * sends on the specified channel.</p>
		 * <p>
		 * When the client associated with this server session leaves the
		 * specified channel, the returned listener's
		 * <code>ClientChannelListener.leftChannel</code> method is invoked with
		 * the specified channel.</p>
		 * 
		 * @param channel a channel
		 * @return a listener for the specified channel
		 */
		function joinedChannel(channel:ClientChannel) : ClientChannelListener;
	
    /**
     * Notifies this listener that the specified message was sent by the
     * server.
     * 
     * @param message a message
     */
		function receivedClientMessage(message : BeyondoByteArray) : void;
		
    /**
     * Notifies this listener that its associated server session is in the
     * process of reconnecting with the server.
     * <p>
     * If a connection can be re-established with the server in a timely
     * manner, this listener's <code>reconnected</code> method will
     * be invoked. Otherwise, if a connection cannot be re-established, this
     * listener's <code>disconnected</code> method will be invoked with
     * <code>false</code> indicating that the associated session is
     * disconnected from the server and the client must log in again.</p>
     */
		function reconnecting() : void;
		
    /**
     * Notifies this listener whether the associated server session is
     * successfully reconnected.
     */
		function reconnected() : void;
		
    /**
     * Notifies this listener that the associated server session is
     * disconnected.
     * <p>
     * If <code>graceful</code> is <code>true</code>, the disconnection
     * was due to the associated client gracefully logging out; otherwise,
     * the disconnection was due to other circumstances, such as forced
     * disconnection.</p>
     * <p>
     * Before this method is invoked, it is guaranteed that the listeners
     * of all <code>ClientChannel</code>s with this session as a member will
     * have their <code>ClientChannelListener.leftChannel</code>
     * methods invoked.</p>
     *
     * @param graceful <code>true</code> if disconnection was due to the
     *        associated client gracefully logging out, and
     *        <code>false</code> otherwise
     * @param reason a string indicating the reason this session was
     *        disconnected, or <code>null</code> if no reason was provided
     */
		function disconnected(graceful : Boolean, reason : String) : void;
	}
}
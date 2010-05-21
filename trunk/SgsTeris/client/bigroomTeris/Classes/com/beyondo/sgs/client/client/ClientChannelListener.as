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
	 * Listener for events relating to a <code>ClientChannel</code>.
	 * <p>
	 * When the server adds a client session to a channel, the client's
	 * <code>ServerSessionListener</code>'s
	 * <code>ServerSessionListener.joinedChannel</code> method is invoked with
	 * that client channel, returning the client's
	 * <code>ClientChannelListener</code> for the channel. A 
	 * <code>ClientChannelListener</code> for a client channel is notified as
	 * follows:</p>
	 * <ul>
	 * <li>When a message is received on a client channel, the listener's
	 * <code>ClientChannelListener.receivedMessage</code> method is
	 * invoked with the channel, the sender's session identifier, and the
	 * message. A <code>null</code> sender indicates that the message was sent
	 * by the server. The listener is <i>not</i> notified of messages that its
	 * client sends on its associated channel.</li>
	 * <li> When the associated client leaves a channel, the listener's
	 * <code>ClientChannelListener.leftChannel</code> method is invoked
	 * with the channel. Once a client has been removed from a channel, that
	 * client can no longer send messages on that channel.</li>
	 * </ul>
	 * 
	 * @see com.beyondo.sgs.client.client.ClientChannel ClientChannel
	 * @see com.beyondo.sgs.client.client.ServerSessionListener 
	 * 		ServerSessionListener
	 */
	public interface ClientChannelListener {
		
    /**
     * Notifies this listener that the specified message, sent by the
     * specified sender, was received on the specified channel. If the
     * specified sender is <code>null</code>, then the specified message
     * was sent by the server.
     * 
     * @param channel a client channel
     * @param sender sender's session identifier, or <code>null</code>
     * @param message a byte array containing a message
     */
		function receivedMessage(channel : ClientChannel,
			sender : SessionId, message : BeyondoByteArray) : void;
			
    /**
     * Notifies this listener that the associated client was removed from
     * the specified channel. The associated client can no longer send
     * messages on the specified channel.
     * 
     * @param channel a client chanel
     */
		function leftChannel(channel : ClientChannel) : void;
	}
}
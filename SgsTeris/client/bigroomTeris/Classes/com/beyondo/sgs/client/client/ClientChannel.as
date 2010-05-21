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

package com.beyondo.sgs.client.client
{
	import com.beyondo.util.BeyondoByteArray;
	import com.beyondo.util.Equals;
	
	/**
	 * Represents a client's view of a channel.  A channel is a
	 * communication group, consisting of multiple clients and the server.
	 * <p>
	 * The server is solely responsible for creating channels and
	 * adding and removing clients from channels.  If desired, a client
	 * can request that a channel be created by sending an
	 * application-specific message to the server.</p>
	 * <p>
	 * When the server adds a client session to a channel, the client's
	 * <code>ServerSessionListener.joinedChannel</code> method is invoked with
	 * that client channel, returning the client's
	 * <code>ClientChannelListener</code> for the channel.  A
	 * <code>ClientChannelListener</code> for a client channel is notified
	 * as follows:
	 * <ul>
	 * <li>When a message is received on a client channel, the listener's
	 * <code>ClientChannelListener.receivedMessage</code> method is invoked with
	 * the channel, the sender's session identifier, and the message.  A
	 * <code>null</code> sender indicates that the message was sent by the server.
	 * The listener is <i>not</i> notified of messages that its client sends on
	 * its associated channel.</li>
	 *
	 * <li> When the associated client leaves a channel, the listener's
	 * <code>ClientChannelListener.leftChannel</code> method is invoked with the
	 * channel.  Once a client has been removed from a channel, that client can
	 * no longer send messages on that channel.</li>
	 * </ul></p>
	 */
	public interface ClientChannel extends Equals {
	    /**
	     * Returns the name of this channel.  A channel's name is set when
	     * it is created by the server-side application.
	     *
	     * @return the name of this channel
	     */
		function getName() : String;

	    /**
	     * Sends the given <code>message</code> to all channel members.  If this
	     * channel has no members other than the sender, then no action is taken.
	     * <p>
	     * The specified byte array must not be modified after invoking
	     * this method; if the byte array is modified, then this method
	     * may have unpredictable results.</p>
	     *
	     * @param message a message to send
	     *
	     * @throws com.beyondo.sgs.client.impl.sharedutil.IllegalStateException if
	     * 		the sender is not a member of this channel
	     * @throws com.beyondo.sgs.client.impl.sharedutil.IOException if an IO
	     * 		problem occurs
	     */
		function send(message : BeyondoByteArray) : void;

	    /**
	     * Sends the given <code>message</code> to the <code>recipient</code> on
	     * this channel.  If the <code>recipient</code> is not a member of this
	     * channel, then no action is taken.
	     * <p>
	     * The specified byte array must not be modified after invoking
	     * this method; if the byte array is modified, then this method
	     * may have unpredictable results.</p>
	     *
	     * @param recipient the channel member that should receive the message
	     * @param message a message to send
	     *
	     * @throws com.beyondo.sgs.client.impl.sharedutil.IllegalStateException if
	     * 		the sender is not a member of this channel
	     * @throws com.beyondo.sgs.client.impl.sharedutil.IOException if an
	     * 		IO problem occurs
	     */
		function sendToUser(recipient:SessionId, message:BeyondoByteArray) : void;

	    /**
	     * Sends the given <code>message</code> data to the specified
	     * <code>recipients</code> on this channel. Any <code>recipient</code>
	     * that are not members of this channel are ignored.
	     * <p>
	     * The specified byte array must not be modified after invoking this
	     * method; if the byte array is modified, then this method may have
	     * unpredictable results.</p>
	     * 
	     * @param recipients the subset of channel members that should receive
	     *        the message
	     * @param message a message to send
	     *
	     * @throws com.beyondo.sgs.client.impl.sharedutil.IllegalStateException if
	     * 		the sender is not a member of this channel
	     * @throws com.beyondo.sgs.client.impl.sharedutil.IOException if an IO
	     * 		problem occurs
	     */
		function sendToUsers(recipients:Array, message:BeyondoByteArray) : void;
	}
}
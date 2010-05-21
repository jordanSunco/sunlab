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

package com.beyondo.sgs.client.io
{
	import com.beyondo.util.BeyondoByteArray;
	
	/**
	 * Represents a connection for data communication, independent of the QoS
	 * properties of the connection's transport or protocol. An associated
	 * <code>ConnectionListener</code> is notified of asynchonous events on the
	 * connection.
	 * 
	 * @see com.beyondo.sgs.client.io.ConnectionListener ConnectionListener
	 */
	public interface Connection {
		
		/**
		 * Asynchronously sends data on this connection.
		 * <p>
		 * The specified byte array must not be modified after invoking this method;
		 * if the byte array is modified, then this method may have unpredictable
		 * results.</p>
		 * 
		 * @param message
		 *          the message data to send
		 * 
		 * @throws com.beyondo.sgs.client.impl.sharedutil.IOException
		 *           if there was a synchronous problem sending the message
		 */
		function sendBytes(message : BeyondoByteArray) : void;
		
		
		/**
		 * Asynchronously closes this connection, freeing any resources in use. The
		 * connection should not be considered closed until
		 * <code>ConnectionListener.disconnected</code> is invoked on the
		 * <code>ConnectionListener</code> listener.
		 * 
		 * @throws com.beyondo.sgs.client.impl.sharedutil.IOException
		 *           if there was a synchronous problem closing the connection
		 * 
		 * @see com.beyondo.sgs.client.io.ConnectionListener ConnectionListener
		 */
		function close() : void;
	}
}
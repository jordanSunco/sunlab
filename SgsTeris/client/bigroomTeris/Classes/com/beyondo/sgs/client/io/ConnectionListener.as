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

package com.beyondo.sgs.client.io {
	import com.beyondo.util.BeyondoByteArray;
	
	
	/**
	 * Receives asynchronous notification of events from an associated
	 * <code>Connection</code>. The <code>connected</code> method is invoked when
	 * the connection is established, either actively from a
	 * <code>Connector</code> or passively by an <code>Acceptor</code>. The
	 * <code>bytesReceived</code> method is invoked when data arrives on the
	 * connection. The <code>exceptionThrown</code> method is invoked to forward
	 * asynchronous network exceptions. The <code>disconnected</code> method is
	 * invoked when the connection has been closed, or if the connection could not
	 * be initiated at all (e.g., when a connector fails to connect).
	 * <p>
	 * The IO framework ensures that only one notification is processed at a time
	 * for each instance of <code>Connection</code>.</p>
	 */
	public interface ConnectionListener {
		
		/**
		 * Notifies this listener that the connection is established, either
		 * actively from a <code>Connector</code> or passively by an
		 * <code>Acceptor</code>. This indicates that the connection is ready for
		 * use, and data may be sent and received on it.
		 * 
		 * @param connection
		 *          the <code>Connection</code> that has become connected.
		 */
		function connected(connection:Connection) : void;
		
		/**
		 * Notifies this listener that data arrives on a connection. The
		 * <code>message</code> is not guaranteed to be a single, whole message;
		 * this method is responsible for message reassembly unless the connection
		 * itself guarantees that only complete messages are delivered.
		 * 
		 * @param connection
		 *          the <code>Connection</code> on which the message arrived
		 * @param message
		 *          the received message bytes
		 */
		function bytesReceived(connection:Connection,message:BeyondoByteArray):void;
		
		/**
		 * Notifies this listener that a network exception has occurred on the
		 * connection.
		 * 
		 * @param connection
		 *          the <code>Connection</code> on which the exception occured
		 * @param exception
		 *          the exception description
		 */
		function exceptionThrown(connection:Connection, exception : String) : void;
		
		/**
		 * Notifies this listener that the connection has been closed, or that it
		 * could not be initiated (e.g., when a <code>Connector</code> fails to
		 * connect).
		 * 
		 * @param connection
		 *          the <code>Connection</code> that has disconnected
		 */
		function disconnected(connection:Connection) : void;
	}
}
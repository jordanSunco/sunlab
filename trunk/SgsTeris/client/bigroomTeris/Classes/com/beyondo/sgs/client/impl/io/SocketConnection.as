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

package com.beyondo.sgs.client.impl.io
{
	import com.beyondo.sgs.client.impl.sharedutil.IOException;
	import com.beyondo.sgs.client.impl.sharedutil.NullValueException;
	import com.beyondo.sgs.client.io.Connection;
	import com.beyondo.sgs.client.io.ConnectionListener;
	import com.beyondo.util.BeyondoByteArray;
	
	import flash.net.Socket;

	/**
	 * This is a socket implementation of an <code>Connection</code> using the
	 * flash socket.
	 */
	public class SocketConnection implements Connection, FilterListener {
		private var _listener:ConnectionListener;
		private var _filter:CompleteMessageFilter;
		private var _socket:Socket;
		
		/**
		 * Construct a new SocketConnection with the given listener, filter, and
		 * session.
		 * 
		 * @param listener
		 * 		the <code>ConnectionListener</code> for the <code>Connection</code>
		 * @param filter
		 * 		the <code>CompleteMessageFilter</code> for the <code>Connection</code>
		 * @param socket
		 * 		the <code>Socket</code> for the <code>Connection</code>
		 */
		public function SocketConnection(listener:ConnectionListener,
				filter:CompleteMessageFilter, socket:Socket) {
			if (listener==null || filter==null || socket==null)
				throw new NullValueException("null argument to constructor");
				
			_listener = listener;
			_filter = filter;
			_socket = socket;
		}
		
		/**
		 * @inheritDoc
		 * <p>
		 * This implementation prepends the length of the given byte array as a
		 * 4-byte <code>int</code> in network byte-order, and sends it out on the
		 * underlying <code>Socket</code>.</p>
		 * 
		 * @param message
		 *          the data to send
		 * @throws com.beyondo.sgs.client.impl.sharedutil.IOException if the
		 * 		session is not connected
		 */
		public function sendBytes(message:BeyondoByteArray):void {
			if (!_socket.connected) {
				throw new IOException(
					"SocketConnection.sendBytes: socket not connected");
			}
			
			_filter.filterSend(this, message);
		}
		
		/**
		 * @inheritDoc
		 * <p>
		 * This implementation closes the underlying <code>Socket</code>}.</p>
		 * 
		 * @throws com.beyondo.sgs.client.impl.sharedutil.IOException if the
		 * 		session is not connected
		 */
		public function close():void {
			if (!_socket.connected) {
				throw new IOException("SocketConnection.close: socket not connected");
			}

			_socket.close();
			_listener.disconnected(this);
		}
		
		// Implement FilterListener
	
		/**
		 * Dispatches a complete message to this connection's
		 * <code>ConnectionListener</code>.
		 * 
		 * @param buf a byte array containing the message to dispatch
		 */
		public function filteredMessageReceived(buf:BeyondoByteArray):void {
			_listener.bytesReceived(this, buf);
		}
		
		/**
		 * Sends the given byte array buffer out on the associated
		 * <code>Socket</code>.
		 * 
		 * @param buf the byte array to send
		 * 
		 * @throws com.beyondo.sgs.client.impl.sharedutil.IOException if the
		 * 		session is not connected
		 */
		public function sendUnfiltered(buf:BeyondoByteArray):void
		{
			if (!_socket.connected) {
				throw new IOException(
					"SocketConnection.sendUnfiltered: socket not connected");
			}

			_socket.writeBytes(buf);
			_socket.flush();
		}
		
		/**
		 * Returns the filter associated with this connection.
		 * 
		 * @return the associated filter
		 */
		public function getFilter() : CompleteMessageFilter {
			return _filter;
		}
		
		/**
		 * Returns the <code>Socket</code> associated with this connection.
		 * 
		 * @return the associated socket
		 */
		public function getSocket() : Socket {
			return _socket;
		}
		
		/**
		 * Returns the <code>ConnectionListener</code> for this connection.
		 * 
		 * @return the listener associated with this connection
		 */
		public function getConnectionListener() : ConnectionListener {
			return _listener;
		}
		
	}
}
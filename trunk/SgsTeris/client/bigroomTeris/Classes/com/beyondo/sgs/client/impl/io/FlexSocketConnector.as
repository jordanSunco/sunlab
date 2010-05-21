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
	import com.beyondo.sgs.client.impl.sharedutil.IllegalStateException;
	import com.beyondo.sgs.client.io.ConnectionListener;
	import com.beyondo.sgs.client.io.Connector;
	import com.beyondo.sgs.client.io.Endpoint;
	
	import flash.net.Socket;

	/**
	 * This is a socket-based implementation of a <code>Connector</code> using
	 * the Flex socket for the underlying transport.
	 */
	public class FlexSocketConnector implements Connector	{
		protected var _socket : Socket;
		protected var _endpoint:SocketEndpoint;
		protected var _connListener:SocketConnectionListener;
		
		
		/**
		 * Constructs a <code>FlexSocketConnector</code> using the given
		 * <code>EndPoint</code>
		 * 
		 * @param endpoint
		 *          the remote address to which to connect
		 */
		public function FlexSocketConnector(endpoint:SocketEndpoint) {
			_endpoint = endpoint;
			// Create a new socket to be used by this connector
			_socket = new Socket();
		}

		/**
		 * Connect to the <code>EndPoint</code> use the supplied listener to listen
		 * to incomming messages on the connection.
		 * 
		 * @param listener
		 * 		the connection listener
		 */
		public function connect(listener:ConnectionListener):void	{
			
			var filter:CompleteMessageFilter = new CompleteMessageFilter();
			
			var conn:SocketConnection = new SocketConnection(
				listener, filter, _socket);
				
			_connListener = new SocketConnectionListener(this, conn);
			
			//trace("trying to connect to SGS: "+_endpoint.getAddress().host);
			
			_socket.connect(_endpoint.getAddress().host, _endpoint.getAddress().port);
		}
		
		/**
		 * not implemented
		 */
		public function waitForConnect(l:uint):Boolean {
			return false;
		}
		
		
		public function isConnected():Boolean {
			if (_connListener == null) {
				throw new IllegalStateException("Illegal state exception");
			}
			return _socket.connected;
		}
		
		public function getEndpoint():Endpoint {
			return _endpoint;
		}
		
		public function shutdown():void {
			_connListener.shutdown();
		}
	}
}

import com.beyondo.sgs.client.impl.sharedutil.IllegalStateException;
import com.beyondo.sgs.client.io.Connector;
import com.beyondo.util.BeyondoByteArray;

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.net.Socket;
import com.beyondo.sgs.client.impl.io.SocketConnection;

/**
 * Internal adaptor class to handle events from the connector itself.
 */
class SocketConnectionListener {
	private var _socket:Socket;
	private var _connection:SocketConnection;
	private var _connected:Boolean = false;
	private var _cancelled:Boolean = false;
	private var _connector:Connector;
	
	
	/**
	 * Constructs a new SocketConnectionListener with a <code>Connector</code> and
	 * <code>Connection</code>.
	 * 
	 * @param connector the connector
	 * @param conn the connection
	 */
	public function SocketConnectionListener(connector:Connector,
		conn:SocketConnection) {
			
		_connector = connector;
		_connection = conn;
		_socket = conn.getSocket();
		
		registerEvents();
	}

	/**
	 * If a connection is in progress, but not yet connected, cancel the pending
	 * connection.
	 * 
	 * @throws IllegalStateException
	 *           if this connection attempt has already completed or been
	 *           cancelled
	 */
	public function cancel() : void {		
		if (_connected) {
			throw new IllegalStateException("Already connected");
		}

		if (_cancelled) {
			throw new IllegalStateException("Already cancelled");
		}
		_cancelled = true;
	}
	
	/**
	 * Close the socket connection
	 */
	public function shutdown() : void {
		_socket.close();
	}
	
	protected function registerEvents() : void {
		_socket.addEventListener(Event.CONNECT, socket_connected);
		_socket.addEventListener(Event.CLOSE, socket_closed);
		_socket.addEventListener(IOErrorEvent.IO_ERROR, socket_error);
		_socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, socket_security_error);
		_socket.addEventListener(ProgressEvent.SOCKET_DATA, socket_data);
	}
	
	protected function unregisterEvents() : void {
		_socket.removeEventListener(Event.CONNECT, socket_connected);
		_socket.removeEventListener(Event.CLOSE, socket_closed);
		_socket.removeEventListener(IOErrorEvent.IO_ERROR, socket_error);
		_socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, socket_security_error);
		_socket.removeEventListener(ProgressEvent.SOCKET_DATA, socket_data);
	}
	
	protected function socket_connected(event:Event) : void {
		_connection.getConnectionListener().connected(_connection);
	}

	protected function socket_closed(event:Event) : void {
		this.unregisterEvents();
		_connection.getConnectionListener().disconnected(_connection);
	}

	protected function socket_error(event:IOErrorEvent) : void {
		_connection.getConnectionListener().exceptionThrown(_connection, event.text);
	}

	protected function socket_security_error(event:SecurityErrorEvent) : void {
		_connection.getConnectionListener().exceptionThrown(_connection, event.text);
	}

	protected function socket_data(event:ProgressEvent) : void {
		var buf:BeyondoByteArray = new BeyondoByteArray();
		_socket.readBytes(buf);
		buf.position=0;
		_connection.getFilter().filterReceive(_connection, buf);
	}
}
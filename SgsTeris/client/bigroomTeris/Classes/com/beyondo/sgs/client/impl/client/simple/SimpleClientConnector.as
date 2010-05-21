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

package com.beyondo.sgs.client.impl.client.simple {
	import com.beyondo.sgs.client.impl.client.comm.ClientConnectionListener;
	import com.beyondo.sgs.client.impl.client.comm.ClientConnector;
	import com.beyondo.sgs.client.impl.io.SocketEndpoint;
	import com.beyondo.sgs.client.impl.io.TransportType;
	import com.beyondo.sgs.client.impl.sharedutil.IllegalArgumentException;
	import com.beyondo.sgs.client.impl.sharedutil.SocketAddress;
	import com.beyondo.sgs.client.io.Connector;

	/**
	 * A basic implementation of a <code>ClientConnector</code> which uses an 
	 * <code>Connector</code> to establish connections.
	 * 
	 * <p>
	 * The <code>SimpleClientConnector</code> constructor supports the
	 * following properties:</p>
	 * <p>
	 *
	 * <ul>
	 *
	 * <li> <i>Key:</i> <code>host</code> <br>
	 *	<i>No default &mdash; required</i> <br>
	 *	Specifies the server host.
	 *
	 * <li> <i>Key:</i> <code>port</code> <br>
	 * <i>No default &mdash; required</i> <br>
	 *	Specifies the server port.
	 *
	 * <li> <i>Key:</i> <code>connectTimeout</code> <br>
	 *	<i>Default:</i> <code>5000</code> <br>
	 *	Specifies the timeout (in milliseconds) for a connect attempt
	 *	to the server.
	 *
	 * </ul> </p>
	 */
	public class SimpleClientConnector extends ClientConnector	{
		private var connectTimeout : int;
		private var connector:Connector;
		
		/**
		 * Construct a new SimpleClientConnector with the supplied connection
		 * properties.
		 * 
		 * @param properties the connection properties (an associative array).
		 * @throws com.beyondo.sgs.client.impl.sharedutil.IllegalArgumentException 
		 * if a property is missing or the port number is &lt; 0 or &gt; 65535
		 */
		public function SimpleClientConnector(properties : Object /*Assoc Array*/) {
			super();
			var host : String = properties[ClientConnector.HOST];
			var portStr : String = properties[ClientConnector.PORT];
			
			if (host == null || host == "")
				throw new IllegalArgumentException("Missing Property: host");
				
			if (portStr == null) {
				throw new IllegalArgumentException("Missing Property: port");
			} else if (int(portStr) < 0 || int(portStr) > 65535) {
				throw new IllegalArgumentException("Bad port number: "+portStr);
			} else {
				var tmp : String = properties[ClientConnector.TIME_OUT];
				this.connectTimeout = (tmp != null && tmp != "") ? int(tmp) : 5000;
				
				var transportType: int = TransportType.RELIABLE;
				var socketAddress:SocketAddress = new SocketAddress(host, int(portStr));
				this.connector = 
					(new SocketEndpoint(socketAddress, transportType)).createConnector();
			}
		}
	
    /**
     * @inheritDoc
     */
		override public function cancel() : void {
			throw new Error("Cancel not yet implemented");
		}

    /**
     * @inheritDoc
     */
		override public function connect(connectionListener:ClientConnectionListener) : void {
			var connection:SimpleClientConnection = new SimpleClientConnection(connectionListener);
			this.connector.connect(connection);
		}
	}
}
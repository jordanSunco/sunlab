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

package com.beyondo.sgs.client.impl.io {
	import com.beyondo.sgs.client.impl.sharedutil.IllegalArgumentException;
	import com.beyondo.sgs.client.impl.sharedutil.NotSupportedException;
	import com.beyondo.sgs.client.impl.sharedutil.SocketAddress;
	import com.beyondo.sgs.client.io.Connector;
	import com.beyondo.sgs.client.io.Endpoint;

	/**
	 * An implementation of <code>Endpoint</code> that wraps a 
	 * <code>SocketAddress</code>.
	 * 
	 * @see com.beyondo.sgs.client.impl.sharedutil.SocketAddress SocketAddress
	 */
	public class SocketEndpoint extends AbstractSocketEndpoint
		implements Endpoint {
		
		/**
		 * Constructs a <code>SocketEndpoint</code> with the given
		 * <code>TransportType</code>.
		 * 
		 * @param address
		 *          the socket address to encapsulate
		 * @param type
		 *          the type of transport
		 * 
		 * @see com.beyondo.sgs.client.impl.io.TransportType TransportType
		 * @see com.beyondo.sgs.client.impl.sharedutil.SocketAddress SocketAddress
		 */
		public function SocketEndpoint(address:SocketAddress, transportType:int) {
			super(address, transportType);
		}
		
		/**
		 * Create a socket connector based on the transport type, however only
		 * TCP connection is possible in flash.
		 * 
		 * @return the connector
		 * 
		 * @throws com.beyondo.sgs.client.impl.sharedutil.NotSupportedException if
		 * 		UDP is set as the transport type
		 * @throws com.beyondo.sgs.client.impl.sharedutil.IllegalArgumentException if
		 * 		transport type is not legal
		 * 
		 * @see com.beyondo.sgs.client.impl.io.FlexSocketConnector FlexSocketConnector
		 */
		public function createConnector():Connector {
			if (_transportType == TransportType.RELIABLE) {
				// create a tcp connector
				return new FlexSocketConnector(this);
				
			} else if (_transportType == TransportType.UNRELIABLE) {
				// create a udp connector
				throw new NotSupportedException("UDP socket not supported");
			}
			throw new IllegalArgumentException("Unknown TransportType");
		}
	}
}
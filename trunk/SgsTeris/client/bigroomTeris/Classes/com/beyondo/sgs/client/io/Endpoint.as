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
	
	import com.beyondo.sgs.client.impl.sharedutil.SocketAddress;
	
	/**
	 * Represents an abstract remote communication endpoint. Implementations of
	 * <code>Endpoint</code> encapsulate the active connection-creation mechanism
	 * for particular address families (such as <code>SocketAddress</code>).
	 * 
	 * <p>
	 * In the ActionScript however the <code>Endpoint</code> can work only with
	 * <code>SocketAddress</code></p>
	 * 
	 * <p>
	 * Active connection initiation is accomplished by obtaining an
	 * <code>Endpoint</code>'s <code>Connector</code> via
	 * <code>createConnector</code>.</p>
	 */
	public interface Endpoint {
		
		/**
		 * Creates a <code>Connector</code> for actively initiating a connection to
		 * this remote <code>Endpoint</code>.
		 * 
		 * @return a <code>Connector</code> configured to connect to this
		 * <code>Endpoint</code>
		 * 
		 * @throws com.beyondo.sgs.client.impl.sharedutil.IOException if a connector
		 * cannot be created
		 */
		function createConnector() : Connector;
		
		/**
		 * Returns the address of type <code>SocketAddress</code> encapsulated by
		 * this <code>Endpoint</code>.
		 * 
		 * @return the address encapsulated by this <code>Endpoint</code>
		 */
		function getAddress() : SocketAddress;
	}
}
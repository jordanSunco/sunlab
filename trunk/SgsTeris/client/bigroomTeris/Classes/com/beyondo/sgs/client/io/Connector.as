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
	
	/**
	 * Actively initiates a single connection to an <code>Endpoint</code> and
	 * notifies the associated <code>ConnectionListener</code> when the
	 * connection completes.
	 * <p>
	 * A connection attempt may be terminated by a call to <code>shutdown</code>,
	 * unless the connection has already finished connecting. Once a
	 * <code>Connector</code> has connected or shut down, it may not be reused.
	 * </p>
	 */
	public interface Connector {
		
		/**
		 * Actively initates a connection to the associated <code>Endpoint</code>.
		 * This* call is non-blocking. <code>ConnectionListener.connected</code>
		 * will be called on the given <code>listener</code> upon successful
		 * connection, or <code>ConnectionListener.disconnected</code> if it
		 * fails.
		 * 
		 * @param listener
		 *          the listener for all IO events on the connection, including the
		 *          result of the connection attempt
		 * 
		 * @throws com.beyondo.sgs.client.impl.sharedutil.IOException
		 *           if there was a problem initating the connection
		 * @throws com.beyondo.sgs.client.impl.sharedutil.IllegalStateException
		 *           if the <code>Connector</code> has been shut down or has already
		 *           attempted a connection
		 */
		function connect(connectionlistener:ConnectionListener) : void;
		
		/**
		 * not implemented
		 */
		function waitForConnect(l:uint) : Boolean;
		
		/**
		 * Returns <code>true</code> if this connector is connected, otherwise
		 * returns <code>false</code>.
		 * 
		 * @return <code>true</code> if this connector is connected
		 */
		function isConnected() : Boolean;
		
		/**
		 * Returns the <code>Endpoint</code> for this <code>Connector</code>.
		 * 
		 * @return the <code>Endpoint</code> for this <code>Connector</code>
		 */
		function getEndpoint() : Endpoint;
		
		/**
		 * Shuts down this <code>Connector</code>. The pending connection attempt
		 * will be cancelled.
		 * 
		 * @throws com.beyondo.sgs.client.impl.sharedutil.IllegalStateException if
		 * 		there is no connection attempt in progress
		 */
		function shutdown() : void;
	}
}
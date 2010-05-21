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

package com.beyondo.sgs.client.impl.client.comm {
	import com.beyondo.sgs.client.impl.client.simple.SimpleConnectorFactory;
	
	/**
	 * An abstract mechanism for actively initiating a
	 * 		<code>ClientConnection</code>.
	 * 
	 * @see ClientConnection ClientConnection
	 */
	public class ClientConnector {
		public static var HOST		: String = "host";
		public static var PORT		: String = "port";
		public static var TIME_OUT	: String = "connectTimeout";
		
		/** The static singleton factory. */
		private static var theSingletonFactory : 
			ClientConnectorFactory = new SimpleConnectorFactory();
	
    /**
     * Creates a <code>ClientConnector</code> according to the given
     * <code>properties</code>.
     *
     * @param properties which affect the implementation of
     *        <code>ClientConnector</code> returned
     * @return a <code>ClientConnector<code>
     */
		public static function create(
				properties : Object /*Assoc Array*/) : ClientConnector {
			return theSingletonFactory.createConnector(properties);
		}
	
    /**
     * Sets the <code>ClientConnectorFactory</code> that will be used
     * to create new <code>ClientConnector</code>s.
     *
     * @param factory the factory to create new <code>ClientConnector</code>s
     */
		protected static function setConnectorFactory(
				factory:ClientConnectorFactory) :	void {
			theSingletonFactory = factory;
		}
	
    /**
     * Actively initates a connection to the target remote address.
     * This call is non-blocking.
     * <code>ClientConnectionListener.connected</code> will be called
     * asynchronously on the <code>listener</code> upon successful
     * connection, or <code>ClientConnectionListener.disconnected</code> if it
     * fails.
     *
     * @param listener the listener for all IO events on the
     *        connection, including the result of the connection attempt
     *
     * @throws com.beyondo.sgs.client.impl.sharedutil.IOException if an IO error
     * 	occurs
     */
		public function connect(listener : ClientConnectionListener) : void {
		}
	
    /**
     * Cancels a pending connect operation on this
     * <code>ClientConnection</code>.
     *
     * @throws com.beyondo.sgs.client.impl.sharedutil.IOException if an IO error
     * 		occurs
     */
		public function cancel() : void {}
	}
}
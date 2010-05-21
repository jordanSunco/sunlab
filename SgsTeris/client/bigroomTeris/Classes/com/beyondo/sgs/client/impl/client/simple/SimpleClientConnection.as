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
	
	import com.beyondo.sgs.client.impl.client.comm.ClientConnection;
	import com.beyondo.sgs.client.impl.client.comm.ClientConnectionListener;
	import com.beyondo.sgs.client.impl.sharedutil.IOException;
	import com.beyondo.sgs.client.impl.sharedutil.IllegalStateException;
	import com.beyondo.sgs.client.io.Connection;
	import com.beyondo.sgs.client.io.ConnectionListener;
	import com.beyondo.util.BeyondoByteArray;

	/**
	 * A <code>ClientConnection</code> is the central point of communication with
	 * the server. This <code>SimpleClientConnection</code> uses an
	 * <code>Connection</code> for its transport. All outbound messages to the
	 * server go out via the <code>Connection.send</code>. Incoming messages come
	 * in on the <code>ConnectionListener.messageReceived</code> callback and are
	 * dispatched to the appropriate callback on either the associated
	 * <code>ClientConnectionListener</code>.
	 */
	public class SimpleClientConnection implements ClientConnection,
			ConnectionListener {
				
		private var _connListener:ClientConnectionListener;
		private var _myHandle:Connection;
		
		/**
		 * Construct a new SimpleClientConnection with a client connection listener.
		 * 
		 * @param listener the connection listener
		 */
		public function SimpleClientConnection(listener:ClientConnectionListener) {
			_myHandle = null;
			_connListener = listener;
		}
		
    /**
     * @inheritDoc
     */
		public function sendMessage(buf:BeyondoByteArray):void {
			if (_myHandle == null) {
				throw new IllegalStateException("Illegal state. not connected");
			}
			_myHandle.sendBytes(buf);
		}
		
    /**
     * @inheritDoc
     * <p>
     * This implementation disconnects the underlying <code>Connection</code>.
     * </p>
     */
		public function disconnect():void {
			if (_myHandle == null) {
				throw new IllegalStateException("Illegal state. not connected");
			}
			_myHandle.close();
		}
		
    /**
     * @inheritDoc
     * <p>
     * This implementation notifies the associated
     * <code>ClientConnectionListener</code>.
     * </p>
     */
		public function connected(connection:Connection):void {
			//trace("connected...");
			_myHandle = connection;
			_connListener.connected(this);
		}
		
    /**
     * @inheritDoc
     * <p>
     * This implemenation forwards the message to the
     * associated <code>ClientConnectionListener</code>.
     * </p>
     */
		public function bytesReceived(connection:Connection, buf:BeyondoByteArray):void {
			//trace("bytesReceived ");
			_connListener.receivedMessage(buf);
		}
		
    /**
     * @inheritDoc
     */
		public function exceptionThrown(connection:Connection, err:String):void {
			_connListener.exceptionThrown(err);
		}
		
    /**
     * @inheritDoc
     * <p>
     * This implementation notifies the associated
     * associated <code>ClientConnectionListener</code>.
     * </p>
     */
		public function disconnected(connection:Connection):void {
			//trace("disconnected");
			_connListener.disconnected(true, null);
		}
	}
}
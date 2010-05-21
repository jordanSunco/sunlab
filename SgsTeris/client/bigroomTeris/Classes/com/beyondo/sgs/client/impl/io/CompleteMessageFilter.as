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
	import com.beyondo.util.BeyondoByteArray;


	/**
	 * This filter guarantees that only complete messages are delivered to its
	 * <code>FilterListener</code>.
	 * <p>
	 * It prepends the message length on sending, and reads the length of each
	 * message on receiving. If the message is partial, the filter will hold the
	 * partial message until the rest of the message is received, even if the
	 * message spans multiple calls to <code>filterReceive</code>.</p>
	 */
	public class CompleteMessageFilter {
		
		/** The default recv processing buffer size. */
		private static var MAX_BUFFER_SIZE:uint = 0x80000;
		private var oldBuffer:BeyondoByteArray = null;

		/**
		 * Default constructor.
		 */
		public function CompleteMessageFilter() {
		}
		
		/**
		 * Processes network data of arbitrary length and dispatches zero or more
		 * complete messages to the given <code>listener</code>. If a partial
		 * message remains, it is buffered until more data is received.
		 * 
		 * @param listener
		 *          the <code>FilterListener</code> to receive complete messages
		 * @param buf
		 *          the data to filter and optionally deliver to the
		 *          <code>FilterListener</code>
		 */
		public function filterReceive(listener:FilterListener,
			bytebuffer:BeyondoByteArray):void {
			//trace("processing " + bytebuffer.length + " bytes");
			processReceiveBuffer(listener,bytebuffer);
		}
		
		public function processReceiveBuffer(listener:FilterListener,
			bytebuffer:BeyondoByteArray):void {
			if (bytebuffer.length > MAX_BUFFER_SIZE) {
				trace("Recv filter buffer is larger than expected: "+bytebuffer.length);
			}
			
			var buff:BeyondoByteArray;
			
			if (this.oldBuffer != null && this.oldBuffer.bytesAvailable>4) {
				buff = this.oldBuffer;
				bytebuffer.readBytes(buff, buff.length, bytebuffer.bytesAvailable);
			} else {
				buff = bytebuffer;
			}
			
			while (buff.bytesAvailable > 4 && buff.prefixedDataAvailable(4)) {
				var len:int = buff.readInt();
				var arr:BeyondoByteArray = new BeyondoByteArray();
				buff.readBytes(arr,0, len);
				//var msg:String = "";
				//for (var i:int =0; i < arr.length; i++) {
				//	msg += arr[i] + " ";
				//}
				//trace("MSG: " + msg);
				
				try {
					listener.filteredMessageReceived(arr);
				} catch(e:Error) {
					trace("Exception in message disptach; dropping message"+e.getStackTrace());
				}
			}
			// check if partial message received
			// if true than save for next message
			if (buff.bytesAvailable > 0) {
				this.oldBuffer = new BeyondoByteArray();
				buff.readBytes(this.oldBuffer,buff.position,buff.bytesAvailable);
				trace("partial message: " + buff.position + " bytes");
			} else {
				this.oldBuffer = null;
			}
		}
		
		/**
		 * Prepends the length of the given byte array as a 4-byte <code>int</code>
		 * in network byte-order, and passes the result to the
		 * <code>FilterListener.sendUnfiltered</code> method of the given
		 * <code>listener</code>.
		 * 
		 * @param listener
		 *          the <code>FilterListener</code> on which to send the data
		 * @param message
		 *          the data to filter and forward to the listener
		 * 
		 * @see com.beyondo.sgs.client.impl.io.FilterListener FilterListener
		 */
		public function filterSend(listener:FilterListener,
			bytebuffer:BeyondoByteArray):void {
			var sndBuf:BeyondoByteArray = new BeyondoByteArray();
			
			// write length of buffer to message
			sndBuf.writeInt(bytebuffer.length);
			// write the buffer to message
			sndBuf.writeBytes(bytebuffer);
			// reset message position
			sndBuf.position = 0;
			
			listener.sendUnfiltered(sndBuf);
		}
	}
}
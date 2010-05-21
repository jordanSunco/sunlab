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
	 * Receives the messages resulting from processing by a <code>CompleteMessageFilter</code>
	 * @see com.beyondo.sgs.client.impl.io.CompleteMessageFilter CompleteMessageFilter
	 */
	public interface FilterListener {

		/**
		 * Notifies this listener that a complete, filtered message has been
		 * received and should be dispatched to the final recipient.
		 * 
		 * @param bytebuffer
		 *          a <code>BeyondoByteArray</code> containing the complete message
		 */
		function filteredMessageReceived(bytebuffer : BeyondoByteArray) : void;

		/**
		 * Notifies this listener that an outbound message has been filtered
		 * (prepending the message length) and should be sent "raw" on the
		 * underlying transport.
		 * 
		 * @param bytebuffer
		 *          a <code>BeyondoByteArray</code> containing the message to send
		 */
		function sendUnfiltered(bytebuffer : BeyondoByteArray) : void;
	}
}
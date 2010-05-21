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

package com.beyondo.sgs.client.impl.sharedutil {

	/**
	 * Thrown to indicate that the SGS protocol protocol version doesn't match.
	 */
	public class IllegalProtocolVersion extends Error {
		
		/**
		 * Constructs an IllegalProtocolVersion with the specified message.
		 * 
		 * @param message the detail message
		 */
		public function IllegalProtocolVersion(message:Object="") {
			super(message);
		}
		
	}
}
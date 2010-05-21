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
	 * Signals that an I/O exception of some sort has occurred. This class is
	 * the general class of exceptions produced by failed or interrupted I/O
	 * operations.
	 */
	public class IOException extends Error {
		
		/**
		 * Constructs an IOException with the specified message.
		 * 
		 * @param message the detail message
		 */
		public function IOException(message:Object="IOException") {
			super(message);
		}
	}
}
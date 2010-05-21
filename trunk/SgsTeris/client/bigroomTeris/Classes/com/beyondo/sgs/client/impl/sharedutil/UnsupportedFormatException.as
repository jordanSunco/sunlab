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
	 * An UnsupportedFormatException is thrown when a format change request fails
	 * because the requested Format is not supported.
	 */
	public class UnsupportedFormatException extends Error {
		
		/**
		 * Constructs an UnsupportedFormatException with the specified message.
		 * 
		 * @param message the detail message
		 */
		public function UnsupportedFormatException(message:Object="") {
			super(message);
		}
		
	}
}
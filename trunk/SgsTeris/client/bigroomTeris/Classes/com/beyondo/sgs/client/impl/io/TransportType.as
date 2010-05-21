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
	
	/**
	 * The type of IO transport: reliable (e.g., TCP), or unreliable (e.g., UDP).
	 */
	public final class TransportType {
		/** Reliable transport, such as TCP. */
		public static var RELIABLE : int = 0;
		
		/** Unreliable transport, such as UDP. */
		public static var UNRELIABLE : int = 1;
		
	}
}
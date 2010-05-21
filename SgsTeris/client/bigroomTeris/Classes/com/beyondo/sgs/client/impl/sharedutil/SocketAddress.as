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
	 * This class represents a Socket Address with no protocol attachment.
	 */
	public class SocketAddress {
		private var _host : String;
		private var _port : int;
		
		/**
		 * Construct a SocketAddress with the specified <code>host</code> and
		 * <code>port</code>
		 * 
		 * @param host the host
		 * @param port the port
		 */
		public function SocketAddress(host : String = "", port : int = 0) {
			this._host = host;
			this._port = port;
		}
		
		public function set host(host:String) : void {this._host = host;}
		public function get host() : String { return this._host; }
		
		public function set port(port:int) : void {this._port = port;}
		public function get port() : int { return this._port; }
	}
}
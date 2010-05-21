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

package com.beyondo.sgs.client.impl.io
{
	import com.beyondo.sgs.client.impl.sharedutil.NullValueException;
	import com.beyondo.sgs.client.impl.sharedutil.SocketAddress;
	
	import flash.utils.getQualifiedClassName;
	
	/**
	 * An abstract class that defines a socket EndPoint
	 */
	public class AbstractSocketEndpoint	{
    	protected var _address : SocketAddress;
    	protected var _transportType : int;
    	
		/**
		 * Constructs an <code>AbstractSocketEndpoint</code> with the given
		 * <code>TransportType</code>.
		 * 
		 * @param address
		 *          the socket address to encapsulate
		 * @param type
		 *          the type of transport
		 * 
		 * @throws com.beyondo.sgs.client.impl.sharedutil.NullValueException if
		 * 		address is null
		 * 
		 * @see com.beyondo.sgs.client.impl.io.TransportType
		 */
    	public function AbstractSocketEndpoint(address:SocketAddress,
    		transportType:int) {
    		if (address == null) {
    			throw new NullValueException("null address");
    		}
    		
    		_address = address;
    		_transportType = transportType;
    	}
    	
    	public function getAddress() : SocketAddress { return _address; }
    	public function getTransportType() : int { return _transportType; }
    	
    	public function toString():String {
    		return getQualifiedClassName(this) + "[" + _address + "]";
    	}
	}
}
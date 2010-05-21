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

package com.beyondo.sgs.client.client {
	
	import com.beyondo.util.BeyondoByteArray;
	import com.beyondo.sgs.client.impl.client.simple.SimpleSessionId;
	import com.beyondo.util.Equals;
	
	/**
	 * Identifies a session between client and server. ABSTRACT CLASS. 
	 * DO NOT INSTANTIATE. Call static method <code>fromBytes</code> to
	 * instantiate a new SessionId.
	 * 
	 * <p>
	 * Session identifiers are constant; their values cannot be changed
	 * after they are created.</p>
	 */
	public class SessionId implements Equals {
		
		protected var _id : BeyondoByteArray = new BeyondoByteArray();
	    
    /**
     * Returns a session identifier whose representation is contained in the
     * specified byte array.
     *
     * @param id a byte array containing a session identifier
     * @return a session identifier
     * 
     * @throws com.beyondo.sgs.client.impl.sharedutil.IllegalArgumentException 
     * 		if the specified byte array does not
     * 		contain a valid representation of a <code>SessionId</code>
		 * @throws com.beyondo.sgs.client.impl.sharedutil.NullValueException if
		 * 						<code>id</code> is null
     */
		public static function fromBytes(id : BeyondoByteArray) : SessionId {
			return new SimpleSessionId(id);
		}
	    
    /**
     * Returns a byte array containing the representation of this session
     * identifier.
     * <p>
     * The returned byte array must not be modified; if the byte array
     * is modified, the client framework may behave unpredictably.</p>
     *
     * @return a byte array containing the representation of this
     *         session identifier
     */
		public function toBytes() : BeyondoByteArray {
			return null;
		}
	    
    /**
     * Compares this session identifier to the specified object.
     * The result is <code>true</code> if and only if the argument is not
     * <code>null</code> and is a <code>SessionId</code> object that represents
     * the same session identifier as this object.
     *
     * @param obj the object to compare this <code>SessionId</code> against
     *
     * @return <code>true</code> if the given object represents a 
     *         <code>SessionId</code> equivalent to this session identifier,
     *         <code>false</code> otherwise
     */
		public function equals(obj:Equals) : Boolean {return false;	}

		public function hashCode() : uint {
			/*
			//var bits:Number = 1;
			var ret:String = "";
			var tmp:String;
			for (var i:int = 0; i < _id.length; i++) {
				//bits = 31 * bits + id[i];
				tmp = ""+_id[i];
				if (tmp.length < 2) tmp = "0"+tmp;
				ret += tmp;
			}
			// return (int) (tid >>> 32) ^ (int) tid;
			//var ret:int = int( int(bits) ^ (bits >>> 32));
			return  uint(ret);
			*/
			return uint(0);
		}
	    
		public function toString() : String {
			return null;
		}
	}
}
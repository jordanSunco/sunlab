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

package com.beyondo.sgs.client.impl.client.simple
{
	import com.beyondo.sgs.client.client.SessionId;
	import com.beyondo.sgs.client.impl.sharedutil.CompactId;
	import com.beyondo.sgs.client.impl.sharedutil.HexDumper;
	import com.beyondo.sgs.client.impl.sharedutil.NullValueException;
	import com.beyondo.util.BeyondoByteArray;
	import com.beyondo.util.Equals;
	
	import flash.utils.getQualifiedClassName;

	/**
	 * A simple implementation of a SessionId that wraps a byte array.
	 */
	public  class SimpleSessionId extends SessionId	{
		
		private var _compactId:CompactId;
		
    /**
     * Construct a new <code>SimpleSessionId</code> from the given byte array.
     *
     * @param id the byte representation of the session id
     */
		public function SimpleSessionId(id : BeyondoByteArray) {
			if(id == null) {
				throw new NullValueException("id must not be null");
			} else {
				_compactId = new CompactId(id);
				_id = _compactId.id;
			}
		}
		
    /**
     * @inheritDoc
     */
		override public function toBytes() : BeyondoByteArray {
			return _id;
		}
		
    /**
     * @inheritDoc
     */
		override public function toString():String {
			return flash.utils.getQualifiedClassName(this) + "@" + 
				com.beyondo.sgs.client.impl.sharedutil.HexDumper.toHexString(_id);
		}
		
    /**
     * @inheritDoc
     */
		override public function equals(obj:Equals) : Boolean {
			if (this == obj) return true;
			return _compactId.equals(SimpleSessionId(obj).getCompactId());
		}
		
    /**
     * Returns the <code>CompactId</code> for this instance.
     *
     * @return the <code>CompactId</code> for this instance
     */
		public function getCompactId() : CompactId {
			return _compactId;
		}
	}
}
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

package com.beyondo.util
{
	import com.beyondo.sgs.client.impl.sharedutil.IllegalArgumentException;
	
	import flash.utils.ByteArray;

	/**
	 * A class that inherits from ByteArray to add specific functionality for the
	 * SGS client.
	 */
	public class BeyondoByteArray extends ByteArray {
		
		/**
		 * Add support for the Java long type
		 * 
		 * @return the number converted from a long value
		 */
		public function readLong() : Number {
			var rv:Number = 0;
			for ( var x:int = 0; x < 8; x++ ) {
			  var bv:Number = this.readByte();
			  if ( x > 0 && bv < 0 )
			  	bv +=256;
			  rv *= 256;
			  rv += bv;
			}
			 
			return rv;
		}
		
		/**
		 * Check availability of predefined number of bytes in this array
		 * @param prefixLen the length to check (must be 1,2 or 4).
		 * @return <code>true</code> if data available <code>false</code>
		 * 		otherwise
		 * @throws com.beyondo.sgs.client.impl.sharedutil.IllegalArgumentException if
		 * 						<code>prefixLen</code> is not 1 or 2 or 4
		 */
		public function prefixedDataAvailable(prefixLen:int) : Boolean {
			var posSave:int = this.position;
			var leftOver:int;
			var len:int;

			switch(prefixLen) {
				case 1: // byte
					len = this.readByte();
					break;
				case 2: // short
					len = this.readShort();
					break;
				case 4:
					// int
					len = this.readInt();
					break;
				default:
					throw new IllegalArgumentException("Illegal prefixLen: " + prefixLen);
			}
			
			// reposition index
			this.position = posSave;

			if (this.bytesAvailable < len)
				return false;
			
			return true;
		}
	}
}
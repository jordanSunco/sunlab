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

package com.beyondo.sgs.client.impl.sharedutil
{
	import flash.utils.ByteArray;
	import com.beyondo.sgs.util.Util;
	
	/**
	 * Utility class for converting a byte array to a hex-formatted string.
	 */
	public class HexDumper {

		/**
		 * Returns a string constructed with the contents of the byte array
		 * converted to hex format.
		 * 
		 * @param bytes
		 *          a byte array to convert
		 * @return the converted byte array as a hex-formatted string
		 */
		public static function toHexString(buf : ByteArray) : String {
			buf.position = 0;
			var val : String = "";
			var tmp : String;
			for (var i:int = 0; i < buf.length; i++) {
				tmp = Number(buf.readByte()).toString(16);
				if (tmp.length < 2) tmp="0"+tmp;
				val += tmp;
			}
			return val;
		}
		
		/**
		 * Returns a byte array constructed with the contents of the given string,
		 * which contains a series of byte values in hex format.
		 * 
		 * @param hexString
		 *          a string to convert
		 * @return the byte array corresponding to the hex-formatted string
		 */
		public static function fromHexString(hexString : String) : ByteArray {
			var arr : ByteArray = new ByteArray();
			
			arr.writeUnsignedInt(com.beyondo.sgs.util.Util.HexToWord(hexString));
			
			return arr;
		}
	}
}
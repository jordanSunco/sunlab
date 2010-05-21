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
	import com.beyondo.sgs.util.Util;
	import com.beyondo.util.BeyondoByteArray;
	import com.beyondo.util.Equals;
	
	import flash.utils.getQualifiedClassName;
	
/**
 * A utility class for constructing IDs with a self-describing external format.
 * A <code>CompactId</code> is stored in its canonical form, with all leading
 * zero bytes stripped. The external format is designed to be compact if the
 * canonical ID has a small number of bytes.
 * 
 * <p>
 * The first byte of the ID's external form contains a length field of variable
 * size. If the first two bits of the length byte are not #b11, then the size of
 * the ID is indicated as follows:</p>
 * 
 * <ul>
 * <li>#b00: 14 bit ID (2 bytes total)</li>
 * <li>#b01: 30 bit ID (4 bytes total)</li>
 * <li>#b10: 62 bit ID (8 bytes total)</li>
 * </ul>
 *  
 * <p>If the first byte has the following format:</p>
 * <ul>
 * <li>1100<i>nnnn</i></li>
 * </ul>
 * then, the ID is contained in the next <code>8 +  nnnn</code> bytes.
 * 
 * <p>
 * The maximum length of an ID is 23 bytes (if the first byte of the external
 * form has the value <code>11001111</code>).
 */
	public class CompactId implements Equals {
		/** The maximum supported ID size, in bytes. */
		public static var MAX_SIZE : int = 23;
		
		/** The canonical form for this ID. */
		private var _canonicalId : BeyondoByteArray;
		
		/** The external form for this ID. */
		private var _externalForm: BeyondoByteArray;
		
		/**
		 * Constructs an instance with the specified <code>id</code>.
		 * The <code>id</code> is stored in its canonical form, with all leading
		 * zero bytes stripped.
		 * 
		 * @param id
		 *          a byte array containing an ID
		 * 
		 * @throws com.beyondo.sgs.client.impl.sharedutil.IllegalArgumentException if
		 * 						<code>id</code> is empty or if the <code>id</code> length
		 * 						exceeds the maximum length
		 * @throws com.beyondo.sgs.client.impl.sharedutil.NullValueException if
		 * 						<code>id</code> is null
		 */
		public function CompactId(id:BeyondoByteArray, ext:BeyondoByteArray=null){
			if (id == null) {
				throw new NullValueException("id is null");
			}
			
			id.position = 0;
			
			if (id.length == 0) {
				throw new IllegalArgumentException("id length is zero");
			}
			
			if (id.length > MAX_SIZE) {
				throw new IllegalArgumentException(
					"id length: "+id.length + " exceeds: " + MAX_SIZE);
			}
            
			_canonicalId = stripLeadingZeroBytes(id);
            
			if (ext != null) {
				ext.position=0;
        _externalForm = ext;
			} else {
				_externalForm = toExternalForm(_canonicalId);
			}
		}
		
		/**
		 * Returns a new byte array containing the specified <code>id</code> with
		 * leading zero bytes stripped.
		 * 
		 * @throws com.beyondo.sgs.client.impl.sharedutil.IllegalArgumentException
		 * 		if the given <code>id</code> length is zero or more than MAX_SIZE
		 * 
		 * @throws com.beyondo.sgs.client.impl.sharedutil.NullValueException
		 * 		if the given <code>id</code> is null
		 */
		private static function stripLeadingZeroBytes(id:BeyondoByteArray) :
			BeyondoByteArray {
			
			if (id == null) {
				throw new NullValueException("id is null");
			}
			
			if (id.length == 0) {
				throw new IllegalArgumentException("id length is zero");
			}
			
			if (id.length > MAX_SIZE) {
				throw new IllegalArgumentException(
					"id length: "+id.length + " exceeds: " + MAX_SIZE);
			}

			var cId:BeyondoByteArray = new BeyondoByteArray();
	        
			for(var first:int = 0; first < id.length && id[first] == 0; first++);
			
			if(first == id.length) {
				first = id.length - 1;
			}
	        
			id.position = first;
			id.readBytes(cId, id.position, id.bytesAvailable);
			return cId;
		}
		
		/**
		 * Returns the external form for the given <code>id</code>.
		 * 
		 * Note: The specified <code>id</code> must be in its canonical form
		 * (with no leading zero bytes, unless it is a single zero byte).
		 * 
		 * @param id
		 * 		the id
		 * @returns the external form
		 * 
		 * @throws com.beyondo.sgs.client.impl.sharedutil.IllegalArgumentException
		 * 		if the given <code>lengthByte</code> contains an unsupported format
		 * @throws com.beyondo.sgs.client.impl.sharedutil.NullValueException
		 * 		if the given <code>id</code> is null
		 */
		private static function toExternalForm(id:BeyondoByteArray) :
			BeyondoByteArray {
			if (id == null) {
				throw new NullValueException("id is null");
			}
			
			if (id.length == 0) {
				throw new IllegalArgumentException("id length is zero");
			}
			
			if (id.length > MAX_SIZE) {
				throw new IllegalArgumentException(
					"id length: "+id.length + " exceeds: " + MAX_SIZE);
			}
			
			// find bit count
			var first:int = 0;
			var b:int = id[first];
			var zeroBits:int;
			
			for(zeroBits = 0; zeroBits < 8 && (b & 0x80) == 0; zeroBits++)
			    b <<= 1;
			
			var bitCount:int = (id.length - first - 1 << 3) + (8 - zeroBits);
			var mask:int = 0;
			var size:int;
			
			// determine external form's byte count and the mask for most
			// significant two bits of first byte.
			if(bitCount <= 14) {
				size = 2;
			} else if(bitCount <= 30) {
				size = 4;
				mask = 64;
			} else if(bitCount <= 62) {
				size = 8;
				mask = 128;
			} else {
				size = id.length + 1;
				mask = (192 + id.length) - 8;
			}
			
			// copy id into destination byte array and apply mask
			var external:BeyondoByteArray = new BeyondoByteArray();
			var i:int = id.length - 1;
			for(var e:int = size - 1; i >= first; e--) {
				external[e] = id[i];
				i--;
			}
			
			external[0] |= mask;
			
			return external;
		}
		
		/**
		 * Returns the underlying byte array containing the canonical ID for this
		 * instance. The canonical ID contains no leading zero bytes.
		 * 
		 * @return the byte array containing the ID for this instance
		 */
		public function get id() : BeyondoByteArray {
			return _canonicalId;
		}
		
		/**
		 * Returns the underlying byte array containing the external form for this
		 * instance.
		 * 
		 * @return the byte array containing the external form for this instance
		 */
		public function get externalForm() : BeyondoByteArray {
			return _externalForm;
		}
		
		/**
		 * Returns the length, in bytes, of the external form for this instance.
		 * 
		 * @return the length, in bytes, of the external form for this instance
		 */
		public function getExternalFormByteCount() : int {
			return _externalForm.length;
		}
		
		/**
		 * Returns the byte count of a <code>CompactId</code>'s external form with
		 * the given <code>lengthByte</code>. The returned byte count includes the
		 * given byte in the count.
		 * 
		 * @param lengthByte
		 *          the first byte of the external form which contains byte count
		 *          information
		 * @return the byte count of a <code>CompactId</code>'s external form
		 * 					indicated by <code>lengthByte</code>
		 * @throws com.beyondo.sgs.client.impl.sharedutil.UnsupportedFormatException
		 * 					if the given <code>lengthByte</code> contains an unsupported
		 * 					format
		 */
		public static function getExternalFormByteCount(lengthByte:int) : int {
			switch(lengthByte & 0xc0) {
		        case 0: // '\0'
		            return 2;
		
		        case 64: // '@'
		            return 4;
		
		        case 128: 
		            return 8;
		    }
	        if((lengthByte & 0x30) == 0)
	            return 9 + (lengthByte & 0xf);
	        else
	            throw new UnsupportedFormatException(
	            	"unsupported id format; lengthByte: "+lengthByte);
		}
		
		/**
		 * Puts the external form of this <code>CompactId</code> in the specified
		 * message buffer.
		 * 
		 * @param message
		 * 		a message buffer
		 */
		public function putCompactId(message:BeyondoByteArray) : void {
			message.writeBytes(_externalForm);
		}
		
		/**
		 * Returns a <code>CompactId</code> constructed from the ID's external
		 * format contained in the specified message buffer.
		 * 
		 * @param message
		 * 		a message buffer containing the external format of a
		 * 		<code>CompactId</code>
		 * 
		 * @return a <code>CompactId</code> constructed from the external format in
		 * 		the given message buffer
		 * @throws com.beyondo.sgs.client.impl.sharedutil.UnsupportedFormatException 
		 * 		if the external format contained in the
		 * 		message buffer is malformed or unsupported
		 */
		public static function getCompactId(message:BeyondoByteArray) : CompactId {
			var extForm:BeyondoByteArray = new BeyondoByteArray();
			var lengthByte:int = message.readByte();
			var size:int = getExternalFormByteCount(lengthByte);
			
			extForm.writeByte(lengthByte);
			for(var i:int = 1; i < size; i++) {
				extForm.writeByte(message.readByte());
			}
			return fromExternalForm(extForm);
		}
		
		/**
		 * Returns a hash code value for this instance.
		 * 
		 * @return a hash code value for this instance
		 */
		public function hashCode() : int {
			return com.beyondo.sgs.util.Util.CRC32(_canonicalId.readUTF());
		}
		
		/**
		 * Returns the string representation for this instance.
		 * 
		 * @return the string representation for this instance
		 */
		public function toString() : String {
			var n:Number;
			var o:String = "";
			
			for (var i:int=0; i < _canonicalId.length;i++) {
				n = Number(_canonicalId[i]);
				o += n.toString(16);
			}
			
			return o;
		}
		
		/**
		 * Constructs a <code>CompactId</code> from the specified 
		 * <code>externalForm</code>.
		 * 
		 * @param externalForm
		 * 		a byte array containing the external form of a <code>CompactId</code>
		 * 
		 * @return a <code>CompactId</code> constructed from the specified
		 * 		<code>externalForm</code>
		 * 
		 * @throws com.beyondo.sgs.client.impl.sharedutil.NullValueException if
		 * 						<code>extForm</code> is null
		 * @throws com.beyondo.sgs.client.impl.sharedutil.IllegalArgumentException
		 * 		if <code>externalForm</code> is empty, if <code>externalForm</code>
		 * 		has a different number of bytes than is specified by its length field,
		 * 		if <code>externalForm</code>'s length exceeds the maximum length, or
		 * 		if the ID format is otherwise malformed or unsupported
		 */
		public static function fromExternalForm(extForm:BeyondoByteArray) :
			CompactId {
			
			if(extForm == null)
				throw new NullValueException("null external form");
			
			if(extForm.length < 2) {
				throw new IllegalArgumentException(
					"invalid external form; must have 2 or more bytes");
			}
			
			if(extForm.length > 24) {
				throw new IllegalArgumentException(
					"invalid external form; > 23 bytes unsupported");
			}
			
			var size:int = getExternalFormByteCount(extForm[0]);
			
			if(size != extForm.length) {
			    throw new IllegalArgumentException(
			    	"invalid external form; should have "+size+" bytes");
			}
			    
			var id:BeyondoByteArray = new BeyondoByteArray();
			if(size <= 8) {
			    var firstByte:int = extForm[0] & 0x3f;
			    var first:int = 0;
			    if(firstByte == 0) {
			        for(first = 1; 
			        	first < extForm.length && extForm[first] == 0; first++);
			    }
			    if(first == extForm.length)
			        first = extForm.length - 1;
			    id.writeBytes(extForm,first);
			    if(first == 0)
			        id[0] = firstByte;
			} else {
			    id.writeBytes(extForm,1);
			}
			return new CompactId(id, extForm);
		}
	    
		/**
		 * Returns <code>true</code> if the specified object, <code>obj<code>, is
		 * equivalent to this instance, and returns <code>false</code> otherwise.
		 * An object is equivalent to this instance if it is an instance of
		 * <code>CompactId</code> and has the same representation for its ID.
		 * 
		 * @param obj
		 * 		an object to compare
		 * @return <code>true</code> if <code>obj</code> is equivalent to this
		 * 		instance, and <code>false</code> otherwise
		 */
		public function equals(obj:Equals) : Boolean {
			if (obj is CompactId) {
				if (this == obj) return true;
				var other:CompactId = CompactId(obj);
				for (var i:int=0; i<other.id.length;i++) {
					if (this.id[i] != other.id[i])
						return false;
				}
				return true;
			}
			return false;
		}
	}
}
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
	
	/**
	 * A buffer for composing/decomposing messages.
	 * 
	 * <p>Strings are encoded in UTF-8 format</p>
	 */
	public class MessageBuffer {
		private var _buffer : BeyondoByteArray;
		private var _capacity : int = 0;
		private var _limit : int = 1;
		
		/**
		 * Constructs an empty message buffer with the specified capacity.
		 * 
		 * @param capacity
		 *          the buffer's capacity
		 */
		public function MessageBuffer(capacity : int) {
			_buffer = new BeyondoByteArray();
			_capacity = capacity+1;
		}
		
		/**
		 * return the underlying byte array
		 * 
		 * @return the underlying byte array
		 */
		public function getBuffer() : BeyondoByteArray {
			return _buffer;
		}

		/**
		 * Set the underlying buffer for this message buffer
		 * 
		 * @param buf
		 * 		the buffer
		 */
		public function setBuffer(buf : BeyondoByteArray) : void {
			_buffer = buf;
			_capacity = _buffer.bytesAvailable;
			_limit = _buffer.bytesAvailable;
		}
		
		/**
		 * Returns the size of the specified string, encoded in UTF-8 format.
		 * 
		 * @param str
		 *          a string
		 * @return the size of the specified string, encoded in UTF-8 format
		 */
		public static function getSize(str : String) : int {
			var utfLen : int = 0;
			for (var i : int = 0; i < str.length; i++) {
				var c : int = int(str.charCodeAt(i));
				if (c >= 1 && c <= 127) {
					utfLen++;
					continue;
				}
				if (c > 2047)
					utfLen += 3;
				else
					utfLen += 2;
			}

			return utfLen + 2;
		}

		/**
		 * Returns the capacity of this buffer. The capacity is the number of
		 * elements this buffer contains.
		 * 
		 * @return this buffer's capacity
		 */
		public function capacity() : int {
			return _capacity;
		}
	
		/**
		 * Returns the limit of this buffer. The limit is the index of the first
		 * element that should not be written or read. The limit is never negative
		 * and is never greater than the buffer's capacity.
		 * 
		 * @return this buffer's limit
		 */
		public function limit() : int {
			return _limit;
		}
	
		/**
		 * Returns the position of this buffer. The position is the index of the
		 * next element to be written or read.
		 * 
		 * @return this buffer's position
		 */
		public function position() : int {
			return _buffer.position;
		}
	
		/**
		 * Sets the position of this buffer to zero, making this buffer ready for
		 * re-reading of its elements.
		 */
		public function rewind() : void{
			_buffer.position = 0;
		}
	
		/**
		 * Puts the specified byte in this buffer's current position, and advances the
		 * buffer's position and limit by one.
		 * 
		 * @param b
		 *          a byte
		 * @return this buffer
		 * @throws IndexOutOfBoundsException
		 * 		if adding the byte to the buffer would overflow the buffer
		 */
		public function putByte(b : int) : MessageBuffer {
			if (_buffer.position == _capacity) {
				throw new IndexOutOfBoundsException();
			} else {
				_buffer.writeByte(b);
				return this;
			}
		}

		/**
		 * Puts into this buffer a short representing the length of the specified
		 * byte array followed by the bytes from the specified byte array, starting
		 * at the buffer's current position. The buffer's position and limit are
		 * advanced by the length of the specified byte array plus two.
		 * 
		 * @param bytes
		 *          a byte array
		 * @return this buffer
		 * @throws IndexOutOfBoundsException
		 *           if adding the bytes to this buffer would overflow the buffer
		 */
		public function putByteArray(bytes : BeyondoByteArray) : MessageBuffer {
			if (_buffer.position + 2 + bytes.length > _capacity) {
				throw new IndexOutOfBoundsException();
			} else {
				// write array length
				_buffer.writeShort(bytes.length);
				// write the array
				_buffer.writeBytes(bytes);
				return this;
			}
		}

		/**
		 * Puts the bytes from the specified byte array in this buffer, starting at
		 * the buffer's current position. The buffer's position and limit are
		 * advanced by the length of the specified byte array.
		 * 
		 * @param bytes
		 *          a byte array
		 * @return this buffer
		 * @throws IndexOutOfBoundsException
		 *           if adding the bytes to this buffer would overflow the buffer
		 */
		public function putBytes(bytes : BeyondoByteArray) : MessageBuffer {
			if (_buffer.position + bytes.length > _capacity) {
				throw new IndexOutOfBoundsException();
			} else {
				_buffer.writeBytes(bytes);
				return this;
			}
		}

		/**
		 * Puts the specified char as a two-byte value (high byte first) starting
		 * in the buffer's current position, and advances the buffer's position and
		 * limit by two.
		 * 
		 * @param v
		 *          a char value
		 * @return this buffer
		 * @throws IndexOutOfBoundsException
		 *           if adding the char to this buffer would overflow the buffer
		 */
		public function putChar(v : int) : MessageBuffer{
			if (_buffer.position + 2 > _capacity) {
				throw new IndexOutOfBoundsException();
			} else {
				_buffer.writeByte(v >>> 8 & 0xff);
				_buffer.writeByte(v >>> 0 & 0xff);
				return this;
			}
		}
	
		/**
		 * Puts the specified short as a two-byte value (high byte first) starting
		 * in the buffer's current position, and advances the buffer's position and
		 * limit by two.
		 * 
		 * @param v
		 * 		a short value
		 * @return this buffer
		 * @throws IndexOutOfBoundsException
		 * 		if adding the short to this buffer would overflow the buffer
		 */
		public function putShort(v : int) : MessageBuffer{
			if (_buffer.position + 2 > _capacity) {
				throw new IndexOutOfBoundsException();
			} else {
				_buffer.writeByte(v >>> 8 & 0xff);
				_buffer.writeByte(v >>> 0 & 0xff);
				return this;
			}
		}

		/**
		 * Puts the specified int as four bytes (high byte first) starting in the
		 * buffer's current position, and advances the buffer's position and limit
		 * by 4.
		 * 
		 * @param v
		 *          an int value
		 * @return this buffer
		 * @throws IndexOutOfBoundsException
		 *           if adding the int to this buffer would overflow the buffer
		 */
		public function putInt(v : int) : MessageBuffer {
			if (_buffer.position + 4 > _capacity) {
				throw new IndexOutOfBoundsException();
			} else {
				_buffer.writeInt(v);
				return this;
			}
		}
		
		/**
		 * Puts the specified long as eight bytes (high byte first) starting in the
		 * buffer's current position, and advances the buffer's position and limit
		 * by 8.
		 * 
		 * @param v
		 *          a long value
		 * @return this buffer
		 * @throws IndexOutOfBoundsException
		 *           if adding the long to this buffer would overflow the buffer
		 */
		public function putLong(v : Number) : MessageBuffer {
			if (_buffer.position + 8 > _capacity) {
				throw new IndexOutOfBoundsException();
			} else {
				_buffer.writeDouble(v);
				return this;
			}
		}

		/**
		 * Puts the specified string, encoded in UTF-8 format, in the buffer
		 * starting in the buffer's the current position, and advances the buffer's
		 * position and limit by the size of the encoded string.
		 * 
		 * @param str
		 *          a string
		 * @return this buffer
		 * @throws IndexOutOfBoundsException
		 * 		if adding the encoded string to this buffer would overflow the buffer
		 */
		public function putString(str : String) : MessageBuffer {
			var utfstr : String = com.beyondo.sgs.util.Util.Utf8Encode(str);
			var size : int = getSize(utfstr);
			if (_buffer.position + size > _capacity) {
				throw new IndexOutOfBoundsException();
			}

			/*
			 * Put length of modified UTF-8 encoded string, as two bytes.
			 */
			_buffer.writeShort(size - 2);
			_buffer.writeUTFBytes(utfstr);
			_limit = _buffer.position != _capacity ? _buffer.position + 1 : _buffer.position;
			return this;
		}
		
		/**
		 * Returns the byte in this buffer's current position, and advances the
		 * buffer's position by one.
		 * 
		 * @return the byte at the buffer's current position
		 * @throws IndexOutOfBoundsException
		 *           if this buffer's limit has been reached
		 */
		public function getByte() : int {
			if (_buffer.position == _limit) {
				throw new IndexOutOfBoundsException();
			} else {
				return _buffer.readByte();
			}
		}
	
		/**
		 * Returns a byte array encoded as a 2-byte length followed by the bytes,
		 * starting at this buffer's current position, and advances the buffer's
		 * position by the number of bytes obtained.
		 * 
		 * @return a byte array with the bytes from this buffer
		 * @throws IndexOutOfBoundsException
		 *           if this buffer's limit would be reached as a result of getting
		 *           the encoded bytes
		 */
		public function getByteArray() : BeyondoByteArray {
			var savePos:int = _buffer.position;
			try {
				var len:int = this.getShort();
				var ret:BeyondoByteArray = this.getBytes(len);
				return ret;
			} catch(e:Error) {
        trace(e.getStackTrace());
				_buffer.position = savePos;
			}
			return null;
		}
		
		/**
		 * Returns a byte array containing the specified number of bytes, starting
		 * at this buffer's current position, and advances the buffer's position by
		 * the number of bytes obtained.
		 * 
		 * @param size
		 *          the number of bytes to get from this buffer
		 * @return a byte array with the bytes from this buffer
		 * @throws IndexOutOfBoundsException
		 *           if this buffer's limit would be reached as a result of getting
		 *           the specified number of bytes
		 */
		public function getBytes(size : int) : BeyondoByteArray {
			if (_buffer.position+size > _limit) {
				throw new IndexOutOfBoundsException();
			}

			var arr : BeyondoByteArray = new BeyondoByteArray();
			for (var i:int; i < size; i++) {
				arr.writeByte(_buffer.readByte());
			}
			// reset new array position
			arr.position = 0;
			return arr;
		}
	
		/**
		 * Returns a short value, composed of the next two bytes (high byte first)
		 * in this buffer, and advances the buffer's position by two.
		 * 
		 * @return the short value
		 * @throws IndexOutOfBoundsException
		 *           if this buffer's limit would be reached as a result of getting
		 *           the next two bytes
		 */
		public function getShort() : int {
			if (_buffer.position+2 > _limit) {
				throw new IndexOutOfBoundsException();
			}
			return _buffer.readShort();
		}
	
		/**
		 * Returns an unsigned short value (as an int), composed of the next two
		 * bytes (high byte first) in this buffer, and advances the buffer's
		 * position by two. The value returned is between 0 and 65535, inclusive.
		 * 
		 * @return the unsigned short value as an int between 0 and 65535
		 * @throws IndexOutOfBoundsException
		 *           if this buffer's limit would be reached as a result of getting
		 *           the next two bytes
		 */
		public function getUnsignedShort() : int {
			if (_buffer.position+2 == _limit) {
				throw new IndexOutOfBoundsException();
			}

			return ((_buffer.readByte() & 0xff) << 8) + ((_buffer.readByte() & 0xff) << 0);
		}
	
		/**
		 * Returns an int value, composed of the next four bytes (high byte first)
		 * in this buffer, and advances the buffer's position by 4.
		 * 
		 * @return the int value
		 * @throws IndexOutOfBoundsException
		 *           if this buffer's limit would be reached as a result of getting
		 *           the next four bytes
		 */
		public function getInt() : int {
			if (_buffer.position+4 == _limit) {
				throw new IndexOutOfBoundsException();
			}
			
			return ((_buffer.readByte() & 0xff) << 24) + ((_buffer.readByte() & 0xff) << 16)
						+ ((_buffer.readByte() & 0xff) << 8) + ((_buffer.readByte() & 0xff) << 0);
		}
	
		/**
		 * Returns a long value, composed of the next eight bytes (high byte first)
		 * in this buffer, and advances the buffer's position by 8.
		 * 
		 * @return the long value
		 * @throws IndexOutOfBoundsException
		 *           if this buffer's limit would be reached as a result of getting
		 *           the next eight bytes
		 */
		public function getLong() : Number {
			if (_buffer.position+8 == _limit) {
				throw new IndexOutOfBoundsException();
			}

			return _buffer.readDouble();
		}
	
		/**
		 * Returns a char, composed of the next two bytes (high byte first) in this
		 * buffer, and advances the buffer's position by two.
		 * 
		 * @return the char
		 * @throws IndexOutOfBoundsException
		 *           if this buffer's limit would be reached as a result of getting
		 *           the next two bytes
		 */
		public function getChar() : int {
			if (_buffer.position+2 == _limit) {
				throw new IndexOutOfBoundsException();
			}
			
			return int((_buffer.readByte() << 8) + (_buffer.readByte() & 0xff));
		}
	
		/**
		 * Returns a string that has been encoded in UTF-8 format, starting
		 * at the buffer's current position, and advances the buffer's position by
		 * the length of the encoded string.
		 * 
		 * @return the string
		 * @throws IndexOutOfBoundsException
		 *           if this buffer's limit would be reached as a result of getting
		 *           the encoded string
		 */
		public function getString() : String {
			if (_buffer.position+2 == _limit) {
				throw new IndexOutOfBoundsException();
			}

			var savePos : int = _buffer.position;
			var utfLen : int = getUnsignedShort();
			var utfEnd : int = utfLen + savePos;
			if (utfEnd > _limit) {
				_buffer.position = savePos;
				throw new IndexOutOfBoundsException();
			}
			
			var str : String = _buffer.readUTFBytes(utfLen);
			return com.beyondo.sgs.util.Util.Utf8Decode(str);
		}
	}
}

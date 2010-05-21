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

package com.beyondo.sgs.client.protocol.simple {
	
	/**
	 * SGS Protocol constants.
	 * <p>
	 * A protocol message is constructed as follows:
	 * <ul>
	 * <li> (int) payload length, not including this int
	 * <li> (byte) version number
	 * <li> (byte) service id
	 * <li> (byte) operation code
	 * <li> optional content, depending on the operation code.
	 * </ul>
	 * </p>
	 * <p>
	 * A <code>ByteArray</code> is encoded as follows:
	 * <ul>
	 * <li> (unsigned short) number of bytes in the array
	 * <li> (byte[]) the bytes in the array
	 * </ul>
	 * </p>
	 * <p>
	 * A <code>String</code> is encoded as follows:
	 * <ul>
	 * <li> (unsigned short) number of bytes of UTF-8 encoded String
	 * <li> (byte[]) String encoded in UTF-8
	 * </ul>
	 * </p>
	 * <p>
	 * A <code>CompactId</code> is encoded as follows:
	 * </p>
	 * <p>
	 * The first byte of the ID's external form contains a length field of variable
	 * size. If the first two bits of the length byte are not #b11, then the size of
	 * the ID is indicated as follows:
	 * 
	 * <ul>
	 * <li>#b00: 14 bit ID (2 bytes total)</li>
	 * <li>#b01: 30 bit ID (4 bytes total)</li>
	 * <li>#b10: 62 bit ID (8 bytes total)</li>
	 * </ul>
	 * </p>
	 * <p>
	 * If the first byte has the following format:
	 * <ul>
	 * <li>1100<i>nnnn</i></li>
	 * </ul>
	 * </p>
	 * <p>
	 * then, the ID is contained in the next <code>8 + nnnn</code> bytes.
	 * </ul>
	 * </p>
	 */
	public class SimpleSgsProtocol {
		/**
		 * The maximum length of any protocol message field defined as a
		 * <code>String</code> or <code>byte[]</code>: 
		 * <code>MAX_MESSAGE_LENGTH</code> bytes.
		 */
	    public static var MAX_MESSAGE_LENGTH : int  = 65535;

			/** The version number, currently <code>0x02</code>. */
	    public static var VERSION :  int  = 2;
	    
			/** The Application service ID, <code>0x01</code>. */
	    public static var APPLICATION_SERVICE : int = 1;
	    
			/** The Channel service ID, <code>0x02</code>. */
	    public static var CHANNEL_SERVICE : int  = 2;
	    
			/**
			 * Login request from a client to a server. <br/>
			 * ServiceId: <code>0x01</code> (Application) <br/>
			 * Opcode: <code>0x10</code> <br/>
			 * Payload:
			 * <ul>
			 * <li>(String) name
			 * <li>(String) password
			 * </ul>
			 */
	    public static var LOGIN_REQUEST : int  = 16;
	    
			/**
			 * Login success. Server response to a client's
			 * <code>LOGIN_REQUEST</code>. <br >
			 * ServiceId: <code>0x01</code> (Application) <br />
			 * Opcode: <code>0x11</code> <br/>
			 * Payload:
			 * <ul>
			 * <li> (CompactId) sessionId
			 * <li> (CompactId) reconnectionKey
			 * </ul>
			 */
	    public static var LOGIN_SUCCESS : int  = 17;
	    
			/**
			 * Login failure. Server response to a client's
			 * <code>LOGIN_REQUEST</code>. <br />
			 * ServiceId: <code>0x01</code> (Application) <br />
			 * Opcode: <code>0x12</code> <br />
			 * Payload:
			 * <ul>
			 * <li> (String) reason
			 * </ul>
			 */
	    public static var LOGIN_FAILURE : int  = 18;
	    
			/**
			 * Reconnection request. Client requesting reconnect to a server. <br />
			 * ServiceId: <code>0x01</code> (Application) <br />
			 * Opcode: <code>0x20</code> <br />
			 * Payload:
			 * <ul>
			 * <li> (CompactId) reconnectionKey
			 * </ul>
			 */
	    public static var RECONNECT_REQUEST : int  = 32;
	    
			/**
			 * Reconnect success. Server response to a client's
			 * <code>RECONNECT_REQUEST</code>. <br />
			 * ServiceId: <code>0x01</code> (Application) <br/>
			 * Opcode: <code>0x21</code> <br/>
			 * Payload:
			 * <ul>
			 * <li> (CompactId) reconnectionKey
			 * </ul>
			 */
	    public static var RECONNECT_SUCCESS : int  = 33;
	    
			/**
			 * Reconnect failure. Server response to a client's
			 * <code>RECONNECT_REQUEST</code>. <br />
			 * ServiceId: <code>0x01</code> (Application) <br/>
			 * Opcode: <code>0x22</code> <br/>
			 * Payload:
			 * <ul>
			 * <li> (String) reason
			 * </ul>
			 */
	    public static var RECONNECT_FAILURE : int  = 34;
	    
			/**
			 * Session message. May be sent by the client or the server. Maximum
			 * length is 64 KB minus one byte. Larger messages require fragmentation
			 * and reassembly above this protocol layer. <br/>
			 * ServiceId: <code>0x01</code> (Application) <br/>
			 * Opcode: <code>0x30</code> <br/>
			 * Payload:
			 * <ul>
			 * <li> (long) sequence number
			 * <li> (ByteArray) message
			 * </ul>
			 */
	    public static var SESSION_MESSAGE : int  = 48;
	    
			/**
			 * Logout request from a client to a server. <br/>
			 * ServiceId: <code>0x01</code> (Application) <br/>
			 * Opcode: <code>0x40</code> <br/>
			 * No payload.
			 */
	    public static var LOGOUT_REQUEST : int  = 64;
	    
			/**
			 * Logout success. Server response to a client's
			 * <code>LOGOUT_REQUEST</code>. <br/>
			 * ServiceId: <code>0x01</code> (Application) <br>
			 * Opcode: <code>0x41</code> <br>
			 * No payload.
			 */
	    public static var LOGOUT_SUCCESS : int  = 65;
	    
			/**
			 * Channel join. Server notifying a client that it has joined a channel.
			 * <br/>
			 * ServiceId: <code>0x02</code> (Channel) <br>
			 * Opcode: <code>0x50</code> <br>
			 * Payload:
			 * <ul>
			 * <li> (String) channel name
			 * <li> (CompactId) channel ID
			 * </ul>
			 */
	    public static var CHANNEL_JOIN : int  = 80;
	    
			/**
			 * Channel leave. Server notifying a client that it has left a channel. <br>
			 * ServiceId: <code>0x02</code> (Channel) <br>
			 * Opcode: <code>0x52</code> <br>
			 * Payload:
			 * <ul>
			 * <li> (CompactId) channel ID
			 * </ul>
			 */
	    public static var CHANNEL_LEAVE : int  = 82;
	    
			/**
			 * Channel send request from a client to a server. <br/>
			 * ServiceId: <code>0x02</code> (Channel) <br/>
			 * Opcode: <code>0x53</code> <br/>
			 * Payload:
			 * <ul>
			 * <li> (CompactId) channel ID
			 * <li> (long) sequence number
			 * <li> (short) number of recipients (0 = all)
			 * <li> If number of recipients &gt; 0, for each recipient:
			 * <ul>
			 * <li> (CompactId) sessionId
			 * </ul>
			 * <li> (ByteArray) message
			 * </ul>
			 */
	    public static var CHANNEL_SEND_REQUEST : int  = 83;
	    
			/**
			 * Channel message (sent from server to recipient on channel). <br/>
			 * ServiceId: <code>0x02</code> (Channel) <br/>
			 * Opcode: <code>0x54</code> <br/>
			 * Payload:
			 * <ul>
			 * <li> (CompactId) channel ID
			 * <li> (long) sequence number
			 * <li> (CompactId) sender's sessionId (canonical CompactId of zero if
			 * sent by server)
			 * <li> (ByteArray) message
			 * </ul>
			 */
	    public static var CHANNEL_MESSAGE : int  = 84;
	}
}
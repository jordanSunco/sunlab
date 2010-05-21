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

package com.beyondo.sgs.client.client.simple {
	
	import com.beyondo.sgs.client.client.ServerSession;
	import com.beyondo.sgs.client.client.SessionId;
	import com.beyondo.sgs.client.impl.client.comm.ClientConnection;
	import com.beyondo.sgs.client.impl.client.comm.ClientConnectionListener;
	import com.beyondo.sgs.client.impl.client.comm.ClientConnector;
	import com.beyondo.sgs.client.impl.sharedutil.IllegalStateException;
	import com.beyondo.sgs.client.impl.sharedutil.MessageBuffer;
	import com.beyondo.sgs.client.protocol.simple.SimpleSgsProtocol;
	import com.beyondo.util.AtomicLong;
	import com.beyondo.util.BeyondoByteArray;
	import com.beyondo.util.collection.Hashtable;
	
	/**
	 * An implementation of <code>ServerSession</code> that clients can use to
	 * manage logging in and communicating with the server. A 
	 * <code>SimpleClient</code> is used to establish (or re-establish) a login
	 * session with the server, send messages to the server, and log out.
	 * <p>
	 * A <code>SimpleClient</code> is constructed with a
	 * <code>SimpleClientListener</code> which receives connection-related events,
	 * receives messages from the server, and also receives notification of each
	 * channel the client is joined to.
	 * </p>
	 * <p>
	 * If the server session associated with a simple client becomes
	 * disconnected, then its <code>send</code> and <code>sessionId</code>
	 * methods will throw <code>IllegalStateException</code>.
	 * Additionally, when a client is disconnected, the server removes that
	 * client from the channels that it had been joined to. A disconnected
	 * client can use the <code>login</code> method to log in again.</p>
	 * <p>
	 * Note that the session identifier of a client changes with each login
	 * session; so if a server session is disconnected and then logs in again,
	 * the <code>sessionId</code> method will return a new
	 * <code>SessionId</code>.
	 * </p>
	 */
	public class SimpleClient implements ServerSession {
		private var _connListener:ClientConnectionListener;
		private var _channels:Hashtable = new Hashtable();
		private var _clientConnection:ClientConnection;
		private var _clientListener:SimpleClientListener;
		private var _connectionStateChanging : Boolean;
		private var _expectingDisconnect : Boolean;
		private var _sessionId : SessionId;
		private var _sequenceNumber : AtomicLong = new AtomicLong(0);
		private var _reconnectKey : BeyondoByteArray;
		
		
		/**
		 * Creates an instance of this class with the specified listener. Once this
		 * client is logged in (by using the <code>login</code> method), the
		 * specified listener receives connection-related events, receives messages
		 * from the server, and also receives notification of each channel the
		 * client is joined to. If this client becomes disconnected for any reason,
		 * it may use the <code>login</code> method to log in again.
		 * 
		 * @param listener
		 *          a listener that will receive events for this client
		 */
		public function SimpleClient(listener:SimpleClientListener) {
			_connListener =  new SimpleClientConnectionListener(this);
			_clientListener = listener;
		}
		
		/**
		 * @inheritDoc
		 */
		public function send(buf:BeyondoByteArray):void {
			// are we connected
			checkConnected();
			
			// create a message buffer.
			// 3 bytes hdr + 8 bytes sequence + 2 bytes msg len + msg len
			var msg : MessageBuffer = new MessageBuffer((3+8+2) + buf.length);
			msg.putByte(SimpleSgsProtocol.VERSION);
			msg.putByte(SimpleSgsProtocol.APPLICATION_SERVICE);
			msg.putByte(SimpleSgsProtocol.SESSION_MESSAGE);
			msg.putLong(_sequenceNumber.getAndIncrement());
			msg.putByteArray(buf);
			
			sendRaw(msg.getBuffer());
		}
		
		/**
		 * @inheritDoc
		 */
		public function  isConnected():Boolean {
			return _clientConnection != null;
		}

		/**
		 * @inheritDoc
		 */
		public function  checkLoggedIn() : void {
			if (sessionId == null) {
				throw new IllegalStateException("Client not logged in");
			}
		}
		
		/**
		 * Initiates a login session with the server. A session is established with
		 * the server as follows:
		 * <p>
		 * First, this client's <code>PasswordAuthentication</code> login credential
		 * is obtained by invoking its listener's
		 * <code>SimpleClientListener.asswordAuthentication</code> method with a
		 * login prompt.</p>
		 * 
		 * <p>
		 * Next, if a connection with the server is successfuly established and the
		 * client's login credential (as obtained above) is verified, then the
		 * client listener's <code>SimpleClientListener.loggedIn</code> method is
		 * invoked. If, however, the login fails due to a connection failure with
		 * the server, a login authentication failure, or some other failure, the
		 * client listener's <code>SimpleClientListener.loginFailed</code> method is
		 * invoked with a <code>String</code> indicating the reason for the failure.
		 * </p>
		 * 
		 * <p>
		 * If this client is disconnected for any reason (including login failure),
		 * this method may be used again to log in.</p>
		 * 
		 * <p>
		 * The supported connection properties are:
		 * <table summary="Shows property
		 * keys and associated values">
		 * <tr>
		 * <th>Key</th>
		 * <th>Description of Associated Value</th>
		 * </tr>
		 * <tr>
		 * <td><code>host</code></td>
		 * <td>SGS host address <b>(required)</b></td>
		 * </tr>
		 * <tr>
		 * <td>{@code port}</td>
		 * <td>SGS port <b>(required)</b></td>
		 * </tr>
		 * </table>
		 * </p>
		 * 
		 * @param props
		 * 		the connection properties to use in creating the client's session
		 * 
		 * @throws com.beyondo.sgs.client.impl.sharedutil.IOException
		 * 		if a synchronous IO error occurs
		 * @throws com.beyondo.sgs.client.impl.sharedutil.IllegalStateException
		 * 		if this session is already connected or connecting
		 */
		public function  login(props:Object /*Assoc Array*/) : void {
			if (_connectionStateChanging || _clientConnection != null) {
				throw new IllegalStateException(
					"Session already connected or connecting");
			}
			_connectionStateChanging = true;
		
			var connector:ClientConnector = ClientConnector.create(props);
			connector.connect(_connListener);
		}
		
		/**
		 * @inheritDoc
		 */
		public function  logout(force:Boolean):void {
			if (_connectionStateChanging || _clientConnection == null) {
				throw new IllegalStateException("Client not connected");
			}
			_connectionStateChanging = true;
			
			if (force) {
				_clientConnection.disconnect();
				return;
			} else {
				var msg : MessageBuffer = new MessageBuffer(3);
				msg.putByte(SimpleSgsProtocol.VERSION);
				msg.putByte(SimpleSgsProtocol.APPLICATION_SERVICE);
				msg.putByte(SimpleSgsProtocol.LOGOUT_REQUEST);
				sendRaw(msg.getBuffer());
			}
			_clientConnection.disconnect();
		}
		
		public function set clientConnection(connection:ClientConnection) : void {
			_clientConnection = connection;
		}
		
		public function get clientConnection() : ClientConnection {
			return _clientConnection;
		}

		public function set connectionStateChanging(state:Boolean) : void {
			_connectionStateChanging = state;
		}
		
		public function get connectionStateChanging() : Boolean {
			return _connectionStateChanging;
		}
		
		public function set sessionId(sessionId:SessionId) : void {
			_sessionId = sessionId;
		}
		
		public function get sessionId() : SessionId {
			this.checkConnected();
			return _sessionId;
		}
		
		public function set clientListener(listener:SimpleClientListener) : void {
			_clientListener = listener;
		}
		
		public function get clientListener() : SimpleClientListener {
			return _clientListener;
		}
		
		public function get connListener() : ClientConnectionListener {
			return _connListener;
		}

		public function set reconnectKey(key:BeyondoByteArray) : void {
			_reconnectKey = key;
		}
		
		public function get reconnectKey() : BeyondoByteArray {
			return _reconnectKey;
		}

		public function set sequenceNumber(n:AtomicLong) : void {
			_sequenceNumber = n;
		}
		
		public function get sequenceNumber() : AtomicLong {
			return _sequenceNumber;
		}
		
		public function get channels() : Hashtable {
			return _channels;
		}
		
		public function  sendRaw(data:BeyondoByteArray):void {
			_clientConnection.sendMessage(data);
		}
		
		private function checkConnected() : void {
			if (!this.isConnected()) {
				throw new IllegalStateException("Not connected");
			}
		}
	}
}

import com.beyondo.sgs.client.client.ServerSessionListener;
import com.beyondo.sgs.client.client.SessionId;

import com.beyondo.sgs.client.client.simple.SimpleClient;

import com.beyondo.sgs.client.client.ClientChannel;
import com.beyondo.sgs.client.client.ClientChannelListener;
import com.beyondo.sgs.client.client.SessionId;

import com.beyondo.sgs.client.impl.client.comm.ClientConnection;
import com.beyondo.sgs.client.impl.client.comm.ClientConnectionListener;

import com.beyondo.sgs.client.impl.sharedutil.CompactId;
import com.beyondo.sgs.client.impl.sharedutil.IOException;
import com.beyondo.sgs.client.impl.sharedutil.MessageBuffer;
import com.beyondo.sgs.client.impl.sharedutil.NotSupportedException;
import com.beyondo.sgs.client.impl.sharedutil.MessageBuffer;
import com.beyondo.sgs.client.impl.sharedutil.CompactId;

import com.beyondo.util.Equals;
import com.beyondo.sgs.client.protocol.simple.SimpleSgsProtocol;

import com.beyondo.util.BeyondoByteArray;

/**
 * Receives callbacks on the associated <code>ClientConnection</code>.
 */
class SimpleClientConnectionListener implements
		ClientConnectionListener {
			
	private var _client: com.beyondo.sgs.client.client.simple.SimpleClient;
	private static var SERVER_ID:CompactId;
	
	/**
	 * construct a new SimpleClientConnectionListener.
	 * 
	 * @param client the client which its connection we listen to
	 */
	public function SimpleClientConnectionListener(client:SimpleClient) {
		_client = client;
		var ba:BeyondoByteArray=new BeyondoByteArray();
		ba.writeByte(0);
		SERVER_ID = new CompactId(ba);
	}
	
	/**
	 * @inheritDoc
	 */
	public function connected(clientConnection:ClientConnection):void {
		_client.connectionStateChanging = false;
		_client.clientConnection = clientConnection;
		
		var user:String = _client.clientListener.passwordAuthentication.username;
		var pass:String = _client.clientListener.passwordAuthentication.password;
		
		var message:MessageBuffer = new MessageBuffer(
			3 + MessageBuffer.getSize(user) + MessageBuffer.getSize(pass));

		message.putByte(SimpleSgsProtocol.VERSION);
		message.putByte(SimpleSgsProtocol.APPLICATION_SERVICE);
		message.putByte(SimpleSgsProtocol.LOGIN_REQUEST);
		message.putString(user);
		message.putString(pass);
		// reset position pointer
		message.getBuffer().position = 0;

		_client.sendRaw(message.getBuffer());
	}
	
	/**
	 * @inheritDoc
	 */
	public function disconnected(flag:Boolean, message:BeyondoByteArray):void {
		if (_client.clientConnection == null || !_client.connectionStateChanging){
			//trace("Already Disconnected");
			return;
		}
		_client.clientConnection = null;
		_client.connectionStateChanging = false;
		_client.sessionId = null;
		var reason:String = null;
		if (message != null) {
			reason = message.readUTF();
		}
		_client.clientListener.disconnected(true, reason);
	}
	
	public function exceptionThrown(err:String):void {
		_client.clientListener.exceptionThrown(err);
	}
	
	/**
	 * @inheritDoc
	 */
	public function receivedMessage(message:BeyondoByteArray):void {
		try {
			message.position = 0;
			var version:int = message.readByte();
			if (version != SimpleSgsProtocol.VERSION) {
				throw new IOException (
					"Bad version: " + version + 
					" wanted: "+SimpleSgsProtocol.VERSION);
			}
			
			var service : int = message.readByte();
			switch(service) {
				
				case SimpleSgsProtocol.APPLICATION_SERVICE:
					this.handleApplicationMessage(message);
					break;
					
				case SimpleSgsProtocol.CHANNEL_SERVICE:
					handleChannelMessage(message);
					break;
					
				default:
					throw new IOException("Unknown service: " + service);
			}
		} catch(e:IOException) {
			trace(e.getStackTrace());
			if (_client.isConnected()) {
				try {
					_client.clientConnection.disconnect();
				} catch(e:Error) {
					trace("Disconnect failed after: "+e.getStackTrace());
				}
			}
			throw new IOException(e.message);
		}
	}
	
	/**
	 * @inheritDoc
	 * <p>Currently not implemented</p>
	 */
	public function sessionStarted(message:BeyondoByteArray):
		ServerSessionListener	{
		throw new NotSupportedException("Not supported by SimpleClient");
	}
	
	/**
	 * @inheritDoc
	 * <p>Currently not implemented</p>
	 */
	public function reconnecting(message:BeyondoByteArray):void {
		throw new NotSupportedException("Not supported by SimpleClient");
	}
	
	/**
	 * @inheritDoc
	 * <p>Currently not implemented</p>
	 */
	public function reconnected(message:BeyondoByteArray):void {
		throw new NotSupportedException("Not supported by SimpleClient");
	}
	
	/**
	 * process an aplication type message.
	 * 
	 * @param msg the message to handle
	 * 
   * @throws com.beyondo.sgs.client.impl.sharedutil.IOException on error
	 */
	private function handleApplicationMessage(msg:BeyondoByteArray) : void {
		var command:int = msg.readByte();
		switch(command) {
			case SimpleSgsProtocol.LOGIN_SUCCESS: // 17
				_client.sessionId = SessionId.fromBytes(msg);
				_client.reconnectKey = msg;
				_client.clientListener.loggedIn();
				break;
				
			case SimpleSgsProtocol.LOGIN_FAILURE: // 18
				trace("Login failed");
				_client.clientListener.loginFailed(msg.readUTF());
				break;
				
			case SimpleSgsProtocol.SESSION_MESSAGE: // 48
				_client.checkLoggedIn();
				var sequence:Number = msg.readLong();
				var msgLength:int = msg.readShort();
				_client.clientListener.receivedClientMessage(msg);
				break;
				
			case SimpleSgsProtocol.RECONNECT_SUCCESS: // 33
				trace("Reconnected");
				_client.clientListener.reconnected();
				break;
				
			case SimpleSgsProtocol.RECONNECT_FAILURE: // 34
				trace("Reconnect failed");
				try {
					_client.clientConnection.disconnect();
				} catch (e:Error) {
					trace("Disconnecting a failed reconnect"+
					e.getStackTrace());
				}
				break;
				
			case SimpleSgsProtocol.LOGOUT_SUCCESS: // 65
				//trace("Logged out gracefully");
				break;
				
			default:
				throw new IOException("Unknown session opcode: " + command);
		}
	}
	
	/**
	 * process a channel message.
	 * 
	 * @param msg the message to handle
	 * 
   * @throws com.beyondo.sgs.client.impl.sharedutil.IOException on error
	 */
	private function handleChannelMessage(msg:BeyondoByteArray) : void {
		var channelId:CompactId;
		var channel:SimpleClientChannel;
		var channelName:String;

		// read first byte for command
		var command:int = msg.readByte();
		
		switch(command) {
			case SimpleSgsProtocol.CHANNEL_JOIN: // 80
				channelName = msg.readUTF();
				channelId = CompactId.getCompactId(msg);
				//trace("join channel "+channelName+" id: " + channelId.toString());
				channel = new SimpleClientChannel(_client,channelName,channelId);
				
				if (_client.channels.putIfAbsent(channelId, channel)) {
					channel.joined();
				} else {
					trace("Cannot leave channel "+channelName+": already a member");
				}
				break;
				
			case SimpleSgsProtocol.CHANNEL_LEAVE: // 82
				channelId = CompactId.getCompactId(msg);
				//trace("left channel id: " + channelId.toString());
				channel = SimpleClientChannel(_client.channels.remove(channelId));
				if (channel != null)
					channel.left();
				//else
				//	trace("Cannot leave channel "+channelId+": not a member");
				break;
				
			case SimpleSgsProtocol.CHANNEL_MESSAGE: // 84
				_client.checkLoggedIn();
				channelId = CompactId.getCompactId(msg);
				channel = SimpleClientChannel(_client.channels.getValue(channelId));
				if (channel == null) {
					trace("Ignore message on channel "+channelId+": not a member");
					return;
				}

				var sequence:Number = msg.readLong(); // FIXME sequence number
				

				var compactSessionId:CompactId = CompactId.getCompactId(msg);
				
				var sid:SessionId = compactSessionId.equals(SERVER_ID) ? 
					null : SessionId.fromBytes(compactSessionId.id);
				
				var len:int = msg.readShort();// msg length
				
				var newBA:BeyondoByteArray = new BeyondoByteArray();
				newBA.writeBytes(msg, msg.position, msg.bytesAvailable);
				newBA.position = 0;

				channel.receivedMessage(sid, newBA);
				break;
			default:
				throw new IOException("Unknown channel opcode: " + command);
		}
	}
}

//////////////////////////////////////////////////////////////
// SimpleClientChannel
class SimpleClientChannel implements ClientChannel, Equals {
	private var client:SimpleClient;
	private var name : String;
	private var _id : CompactId;
	private var _joined : Boolean = false;
	private var listener : ClientChannelListener;
	
	public function SimpleClientChannel(client:SimpleClient, name:String, id:CompactId) {
		this.client = client;
		this.name = name;
		_id = id;
	}
	
	public function getName():String {
		return this.name;
	}
	
	public function send(buf:BeyondoByteArray):void {
		this.sendInternal(null,buf);
	}
	
	public function sendToUser(sessionid:SessionId, buf:BeyondoByteArray):void {
		var recipients:Array = new Array();
		recipients.push(sessionid);
		this.sendInternal(recipients,buf);
	}
	
	public function sendToUsers(recipients:Array, buf:BeyondoByteArray):void {
		this.sendInternal(recipients,buf);
	}
	
	private function sendInternal(recipients:Array, message:BeyondoByteArray) : void {
		if (!_joined) {
			trace("Cannot send on channel "+name+": not a member");
			return;
		}
		
		var totalSessionLength:int = 0;
		var sid:SessionId;
		var i:int;
		
		if (recipients != null) {
			for (i = 0; i<recipients.length;i++) {
				sid = recipients[i];
				totalSessionLength += 2 + sid.toBytes().length;
			}
		}

		var msg:MessageBuffer = new MessageBuffer(3
				+ _id.getExternalFormByteCount() + 8 + 2 + totalSessionLength + 2
				+ message.length);
		msg.putByte(SimpleSgsProtocol.VERSION);
		msg.putByte(SimpleSgsProtocol.CHANNEL_SERVICE);
		msg.putByte(SimpleSgsProtocol.CHANNEL_SEND_REQUEST);
		msg.putBytes(_id.externalForm);
		msg.putLong(client.sequenceNumber.getAndIncrement());
		if (recipients == null) {
			msg.putShort(0);
		} else {
			msg.putShort(recipients.length);
			for (i=0; i< recipients.length; i++) {
				sid = recipients[i];
				msg.putBytes(sid.toBytes());
			}
		}
		msg.putByteArray(message);
		this.client.sendRaw(msg.getBuffer());
	}
	
	public function joined() : void {
		_joined = true;
		listener = this.client.clientListener.joinedChannel(this);
	}
	
	public function left() : void {
		if (!_joined) {
			trace("Cannot leave channel "+this.name+": not a member");
			return;
		}
		_joined = false;
		if (this.listener != null) {
			this.listener.leftChannel(this);
			this.listener = null;
		}
	}
	
	public function receivedMessage(sid:SessionId, message:BeyondoByteArray) : void {
		if (!_joined) {
			trace("Cannot leave channel "+this.name+": not a member");
			return;
		}
		listener.receivedMessage(this, sid, message);
	}
	
	public function equals(obj:Equals) : Boolean {
		if (typeof(obj) != "SimpleClientChannel") return false;
		var other:SimpleClientChannel = SimpleClientChannel(obj);
		if (_id != other._id) return false;
		return true;
	}
}

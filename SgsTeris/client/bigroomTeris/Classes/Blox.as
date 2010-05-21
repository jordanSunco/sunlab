/*
 * Author: Richard Lord
 * Copyright (c) Big Room Ventures Ltd. 2007
 * Version: 1.0.0
 *
 * Licence Agreement
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

package
{
	import bigroom.tetris.*;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.*;
	import com.beyondo.sgs.client.client.ClientChannel;
	import com.beyondo.sgs.client.client.ClientChannelListener;
	import com.beyondo.sgs.client.client.SessionId;
	import com.beyondo.sgs.client.client.simple.SimpleClient;
	import com.beyondo.sgs.client.client.simple.SimpleClientListener;
	import com.beyondo.sgs.client.impl.client.comm.ClientConnector;
	import com.beyondo.sgs.util.PasswordAuthentication;
	import com.beyondo.util.BeyondoByteArray;
	/**
	 * Main class used in the Blox game.
	 */

	public class Blox extends Sprite implements SimpleClientListener
	{
		public var game:Controller;
		private var score:Number;
		private var screen:Sprite;

		var _client:SimpleClient;
		var _pauth:PasswordAuthentication;

		var _host:String = "localhost";
		var _port:int = 1139;
		var _confName = "config.conf";
		public function Blox()
		{
			trace("构造函数");
			screen = new StartScreen();
			addChild( screen );
			//StartScreen( screen ).play_btn.addEventListener( MouseEvent.CLICK, playGame, false, 0, true );
			StartScreen( screen ).play_btn.visible =false;
			var conf:URLRequest = new URLRequest(_confName);
			var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.addEventListener(Event.COMPLETE,confLoaded);
			loader.load(conf);

		}
		function confLoaded(event:Event):void{
			var conf:XML = new XML();
			var loader:URLLoader = URLLoader(event.target);
			//trace(loader.data);
			conf = XML(loader.data);
			//trace(conf.@["host"]);
			_host = conf.@["host"];
			_port = int(conf.@["port"]);
			trace("host:"+_host+" port:"+_port);

			StartScreen( screen ).play_btn.addEventListener( MouseEvent.CLICK, playGame, false, 0, true );
			StartScreen( screen ).play_btn.visible=true;


		}
		public function playGame( ev:MouseEvent ):void
		{
			removeChild( screen );
			screen = new GameScreen();
			addChild( screen );

			game = new Controller( screen, new BloxConfig() );
			game.addEventListener( TetrisEvent.SCORE_CHANGE, scoreChanged, false, 0, true );
			game.addEventListener( TetrisEvent.GAME_OVER, gameOver, false, 0, true );
			//game.startGame();

			GameScreen( screen ).pause.addEventListener( PauseButton.PAUSE, pauseGame, false, 0, true );
			GameScreen( screen ).pause.addEventListener( PauseButton.RESUME, resumeGame, false, 0, true );
			GameScreen( screen ).mute.addEventListener( MuteButton.SOUND_OFF, soundOff, false, 0, true );
			GameScreen( screen ).mute.addEventListener( MuteButton.SOUND_ON, soundOn, false, 0, true );

			//连接服务器
			connect();
		}
		private function connect():void{
			_client = new SimpleClient(this);
			var connProps = {};
				connProps[ClientConnector.HOST] = _host;
				connProps[ClientConnector.PORT] = _port;
				_client.login(connProps);
		}
		public function scoreChanged( ev:TetrisEvent ):void
		{
			score = ev.score;
			GameScreen( screen ).score_txt.text = ev.score.toString();
		}

		public function gameOver( ev:TetrisEvent ):void
		{
			closeGame();
		}
		private function closeGame():void{
			game.removeEventListener( TetrisEvent.SCORE_CHANGE, scoreChanged );
			game.removeEventListener( TetrisEvent.GAME_OVER, gameOver );
			score = game.score;
			removeChild( screen );
			screen = new EndScreen();
			addChild( screen );
			EndScreen( screen ).play_btn.addEventListener( MouseEvent.CLICK, playGame );
			EndScreen( screen ).score_txt.text = score.toString();
			if(_client&&_client.isConnected()){
				_client.logout(true);
			}
			_client = null;
		}

		public function pauseGame( ev:Event ):void
		{
			game.pauseGame();
		}

		public function resumeGame( ev:Event ):void
		{
			game.playGame();
		}

		public function soundOff( ev:Event ):void
		{
			game.soundOn = false;
		}

		public function soundOn( ev:Event ):void
		{
			game.soundOn = true;
		}

		//sgs callback
		public function loggedIn():void{
				//status = "连接成功";
				write("连接成功");
				//向服务器发送 client ready 消息
			var buf:BeyondoByteArray = new BeyondoByteArray();
				buf.writeByte(Protocol.CLIENT_READY);
			_client.send(buf);
			}
			public function loginFailed(reason:String):void{
				//status = "连接失败";
				write("连接失败");
			}
			public function get passwordAuthentication():PasswordAuthentication {
				if(_pauth==null){
					_pauth = new PasswordAuthentication("testUser","aaa");
				}
				return _pauth;
			}
			public function set passwordAuthentication(
				pauth:PasswordAuthentication):void {
				_pauth = pauth;
			}

			// ServerSessionListener
			public function disconnected(graceful:Boolean, reason:String):void{
				write("disconnected");
				//status = "未连接";
			}
			public function joinedChannel(channel:ClientChannel):ClientChannelListener{
				write("joinedChannel");
				game.channel = channel;
				return game;
			}
			public function receivedClientMessage(message:BeyondoByteArray):void{
				write("receivedClientMessage");
				var command:int = message.readByte()
				switch(command){
					case Protocol.GAME_READY:
						write("GAME_READY");
						game.startGame();
						break;
					case Protocol.REMOVE_LINES:
						write("REMOVE_LINES");
						break;
					case Protocol.GAME_OVER:
						write("GAME_OVER");
						closeGame();
						break;
					case Protocol.CLIENT_READY:
						write("CLIENT_READY");
						break;
					default:
						write("unkown command");
						break;
				}
			}
			public function reconnected():void{
				write("reconnected");
			}
			public function reconnecting():void{
				write("reconnecting");
			}
			public function exceptionThrown(err:String):void{
				write("exceptionThrown");
			}

			function write(str:String):void{
				//msgText.text +=str+"\n";
				trace(str);
			}
	}
}

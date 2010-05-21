/*
 * Part of the Tetris Game Engine by Big Room Games.
 * 
 * Author: Richard Lord
 * Copyright (c) Big Room Ventures Ltd. 2007
 * Version: 1.0.0
 * 
 * Licence Agreement
 * 
 * This file is part of the Tetris Game Engine by Big Room Games. The Tetris Game 
 * Engine constitutes all files in the actionscripty code package bigroom.tetris.
 * The Tetris Game Engine is available under the following licence conditions:
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * (a) The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * (b) All games that use all or substantial portions of the Tetris Game Engine 
 * must include the notice "Game Engine copyright Big Room Ventures Ltd. 2007"
 * (the word 'copyright' may be replaced by the international copyright symbol)
 * 
 * (c) Where a game that uses all or substantial portions of the Tetris Game Engine 
 * includes credits to its creators, that game must include the credit 
 * "Game Engine by Big Room Games" with the other credits.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
package bigroom.tetris 
{
	import flash.events.Event;
	/**
	 * The event object used by events in a tetris game. Not all properties
	 * are used by all events.
	 */

	public class TetrisEvent extends Event 
	{
		/**
		 * Event sent when the game ends. Noadditionasl properties are added to
		 * the event object.
		 */
		public static const GAME_OVER:String = "gameOver";
		/**
		 * Event sent when the next tetrad changes. The shape property is the 
		 * shape of the new tetrad.
		 */
		public static const UPDATE_NEXT:String = "updateNext";
		/**
		 * Used internally when cells in the game area change state.
		 */
		public static const UPDATE_CELLS:String = "updateCells";
		/**
		 * Event sent when completed lines are removed from the game area.
		 * The lines property indicates the number of lines removed. Used
		 * internally to play a sound.
		 */
		public static const LINES_REMOVED:String = "linesRemoved";
		/**
		 * Event sent when the tetrad lands. Used internally to play a sound.
		 */
		public static const TETRAD_LANDED:String = "tetradLanded";
		/**
		 * Event sent when the tetrad moves. Used internally to playa sound.
		 */
		public static const TETRAD_MOVED:String = "tetradMoved";
		/**
		 * Event sent when the score changes. The score property is the new
		 * game score.
		 */
		public static const SCORE_CHANGE:String = "tetradMoved";
		
		public var shape:Shape;
		public var lines:uint;
		public var cells:Array;
		public var score:uint;

		public function TetrisEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false )
		{
			super( type, bubbles, cancelable );
		}
		
		override public function clone():Event
		{
			var ev:TetrisEvent = new TetrisEvent( type, bubbles, cancelable );
			ev.shape = shape;
			ev.lines = lines;
			ev.cells = cells;
			ev.score = score;
			return ev;
		}
	}
}

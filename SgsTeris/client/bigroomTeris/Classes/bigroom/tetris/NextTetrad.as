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
	import flash.display.Sprite;
	import flash.utils.getDefinitionByName;
	/**
	 * To display the next tetrad in the game.
	 */
	internal class NextTetrad
	{
		private var _blocksize:uint;
		private var _clip:Sprite;
		private var _sprites:Object;
		
		/**
		 * The constructor
		 * 
		 * @param holder the DisplayObject to show the tetrad in
		 * @param blocksize the size in pixels of a cell in the tetrad
		 * @param sprites an object containing the names of the sprites to use for the tetrads
		 */
		public function NextTetrad( clip:Sprite, blocksize:uint, sprites:Object ):void
		{
			_clip = clip;
			_blocksize = blocksize;
			_sprites = sprites;
		}
		
		/**
		 * Updates the display. Used as an event handler listening to the 
		 * Tetris instance.
		 * 
		 * @param ev the event object
		 */
		internal function onUpdateNext( ev:TetrisEvent ):void
		{
			var id:Class = getDefinitionByName( _sprites[ ev.shape.label ] ) as Class;
			var clip:Sprite = new id();
			while( _clip.numChildren )
			{
				_clip.removeChildAt( 0 );
			}
			_clip.addChild( clip );
			clip.x = 2 * _blocksize - clip.width * 0.5;
			clip.y = _blocksize - clip.height * 0.5;
		}
	}
}
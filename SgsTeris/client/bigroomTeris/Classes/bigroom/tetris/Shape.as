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
	/**
	 * Contains a string indicating the shape of tetrad in 
	 * a particular cell.
	 */
	internal class Shape
	{
		/**
		 * Tetrad shape I.
		 */
		internal static var I:Shape = new Shape( "I" );
		/**
		 * Tetrad shape O.
		 */
		internal static var O:Shape = new Shape( "O" );
		/**
		 * Tetrad shape T.
		 */
		internal static var T:Shape = new Shape( "T" );
		/**
		 * Tetrad shape Z.
		 */
		internal static var Z:Shape = new Shape( "Z" );
		/**
		 * Tetrad shape S.
		 */
		internal static var S:Shape = new Shape( "S" );
		/**
		 * Tetrad shape L.
		 */
		internal static var L:Shape = new Shape( "L" );
		/**
		 * Tetrad shape F.
		 */
		internal static var F:Shape = new Shape( "F" );
		/**
		 * Indicates the tetrad that is currently falling.
		 */
		internal static var CURRENT:Shape = new Shape( "CURRENT" );
		/**
		 * Indicates the cell is empty.
		 */
		internal static var CLEAR:Shape = new Shape( "CLEAR" );
		/**
		 * Indicates the cell is out of bounds.
		 */
		internal static var OUT:Shape = new Shape( "OUT" );
		/**
		 * The string representation of te cell state.
		 */
		internal var label:String;
		/**
		 * The constructor.
		 * 
		 * @param l the label for this shape
		 */
		public function Shape( l:String )
		{
			label = l;
		}
	}
}
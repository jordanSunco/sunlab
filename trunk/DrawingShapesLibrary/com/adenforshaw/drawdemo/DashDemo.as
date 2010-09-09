package com.adenforshaw.drawdemo 
{
	import flash.display.*;
	import flash.events.*;
	import nl.funkymonkey.drawing.DrawingShapes;
	/**
	 * ...
	 * @author Aden Forshaw
	 */
	public class DashDemo extends Sprite
	{
		protected var _strokeColor:Number	= 0x0B6CC0;// 0B6CC0;
		protected var _lineThickness:Number	= 2;
		protected var _fillColor:Number		= 0xFFFFFF;
		
		//dash demo
		protected var _lineHolder:Sprite;
		protected var _handles:Array;
		protected var _heldHandle:Sprite;
		
		public function DashDemo() 
		{
			init();
		}
		/**
		 * Called to redraw the dashed line when the user moves any of the handles
		 * 
		 * @param	event=null
		 */
		protected function updateDashDemo(event=null):void
		{
			//remove previously drawn line
			if (_lineHolder)_lineHolder.parent.removeChild(_lineHolder);
			//add to bottom so handles are above
			_lineHolder = this.addChildAt(new Sprite(),0) as Sprite;
			_lineHolder.graphics.lineStyle(2, _strokeColor);
			
			//loop to draw between all the handles
			for (var i:Number = 1; i < _handles.length; i++)
			{
				var prevHandle:Sprite = _handles[i - 1];
				var handle:Sprite = _handles[i];
				
				/********************************************
				 * The magic line that does the work
				 * ******************************************/				
				DrawingShapes.drawDash(_lineHolder.graphics, prevHandle.x, prevHandle.y, handle.x, handle.y);
			}
			//dispatch change to update the displayed code example
			dispatchEvent(new Event(Event.CHANGE));
			
		}
		
		public function getCodeSnippet():String
		{
			return "DrawingShapes.drawDash(_lineHolder.graphics,"+ _handles[0].x+","+  _handles[0].y+","+ _handles[1].x+","+ _handles[1].y+");";
		}
		
		protected function init()
		{
			var numHandles:Number = 2;
			var handleSize:Number = 12;
			_handles = [];			
			//loop through the number of handles to draw so we can use as many as we like
			for (var i:Number = 0; i < numHandles; i++)
			{
				var handle:Sprite = new Sprite();
				var block:Shape = handle.addChild(new Shape()) as Shape;
				//draw a square for the handle for the user to click on
				block.graphics.lineStyle(_lineThickness, 0x13294F);// _strokeColor);
				block.graphics.beginFill(_fillColor);
				block.graphics.drawRect( -(handleSize >> 1), -(handleSize >> 1), handleSize, handleSize);
				//name the handle as might be useful later
				handle.name = "handle" + i;
				//apply button mode so mouse cursor changes when user rolls over
				handle.buttonMode = true;
				//add to this as child so is rendered and seen by user
				this.addChild(handle);
				//add eventlistener for when user mouse downs on the handle
				handle.addEventListener(MouseEvent.MOUSE_DOWN, onHandle_MouseDown, false, 0, true);
				//add to array of handles so we can have as many as we like
				_handles.push(handle);
			}
			
			//set start positions of handles
			_handles[0].x = 60;
			_handles[0].y = 118;
			
			//_handles[1].x = 182;
			//_handles[1].y = 64;
			_handles[1].x = 260;
			_handles[1].y = 144;
			
			/*_handles[2].x = 216;
			_handles[2].y = 192;
			
			_handles[3].x = 260;
			_handles[3].y = 144;*/
			//draw dashed line
			updateDashDemo();
		}
		/**
		 * Called when the user mouse downs on any of the handles
		 * @param	event
		 */
		protected function onHandle_MouseDown(event:MouseEvent):void
		{
			//get the handle that the user has actioend
			var handle:Sprite = event.target as Sprite;
			//start dragging it
			handle.startDrag();
			//add listeners to the whole stage so if user mouse ups anywhere not just over the same handle the stop code will apply
			stage.addEventListener(MouseEvent.MOUSE_UP	, onHandle_MouseUp, false, 0, true);
			//on mouse move so line is redrawn when the handle moves
			stage.addEventListener(MouseEvent.MOUSE_MOVE	, updateDashDemo,false,0,true);
			//save the handle currently being dragged
			_heldHandle = handle;
		}
		/**
		 * Called when user mouse up's anywhere over the stage
		 * 
		 * @param	event
		 */
		protected function onHandle_MouseUp(event:MouseEvent):void
		{
			//stop the currently held handle being dragged
			_heldHandle.stopDrag();
			//tidy up and remove any listeners from the stage
			stage.removeEventListener(MouseEvent.MOUSE_UP	, onHandle_MouseUp);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE	, updateDashDemo);
		}
		
	}

}
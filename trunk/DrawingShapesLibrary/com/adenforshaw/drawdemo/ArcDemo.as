package com.adenforshaw.drawdemo 
{
	import com.bit101.components.HUISlider;
	import flash.display.Sprite;
	import flash.events.Event;
	import nl.funkymonkey.drawing.DrawingShapes;
	/**
	 * ...
	 * @author Aden Forshaw
	 */
	public class ArcDemo extends Sprite
	{
		
		protected var _strokeColor:Number	= 0x0B6CC0;// 0B6CC0;
		protected var _lineThickness:Number	= 2;
		protected var _fillColor:Number		= 0xFFFFFF;
		
		protected var _arcSlider:HUISlider;
		protected var _angleSlider:HUISlider;
		protected var _lineHolder:Sprite;
		
		public function ArcDemo() 
		{
			_arcSlider = this.addChild(new HUISlider()) as HUISlider
			_arcSlider.setSliderParams(0, 360, 100);
			_arcSlider.addEventListener(Event.CHANGE	, update);
			_arcSlider.x = 80;
			_arcSlider.y = 200;
			_arcSlider.label = "Arc:"
			
			_angleSlider = this.addChild(new HUISlider()) as HUISlider
			_angleSlider.setSliderParams(0, 360, 220);
			_angleSlider.addEventListener(Event.CHANGE	, update);
			_angleSlider.x = 80;
			_angleSlider.y = 220;
			_angleSlider.label = "Angle:"
			update();
		}
		
		protected function update(event=null):void
		{
			if (_lineHolder)
			{
				_lineHolder.parent.removeChild(_lineHolder);
				_lineHolder = null;
			}
			
			_lineHolder = this.addChild(new Sprite()) as Sprite;
			_lineHolder.graphics.lineStyle(2, _strokeColor);
			
			
			
			/******************************************************
			 * Magic line to use
			 * ******************************************************/
			DrawingShapes.drawArc(_lineHolder.graphics,140,120,50,_arcSlider.value,_angleSlider.value)
			
			//dispatch change to update the displayed code example
			dispatchEvent(new Event(Event.CHANGE));
			
		}
		
		public function getCodeSnippet():String
		{
			return "DrawingShapes.drawArc(_lineHolder.graphics,140,120,50,"+ _arcSlider.value+","+_angleSlider.value+");";
		}
		
	}

}
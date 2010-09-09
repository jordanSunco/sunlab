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
	public class StarDemo extends Sprite
	{
		
		protected var _strokeColor:Number	= 0x0B6CC0;// 0B6CC0;
		protected var _lineThickness:Number	= 2;
		protected var _fillColor:Number		= 0xFFFFFF;
		
		protected var _pointsSlider:HUISlider;
		protected var _innerSlider:HUISlider;
		protected var _outerSlider:HUISlider;
		protected var _angleSlider:HUISlider;
		protected var _lineHolder:Sprite;
		
		public function StarDemo() 
		{
			_pointsSlider = this.addChild(new HUISlider()) as HUISlider
			_pointsSlider.setSliderParams(3, 30, 5);
			_pointsSlider.addEventListener(Event.CHANGE	, update);
			_pointsSlider.x = 80;
			_pointsSlider.y = 180;
			_pointsSlider.label = "Points:"
			
			_innerSlider = this.addChild(new HUISlider()) as HUISlider
			_innerSlider.setSliderParams(0, 60, 60);
			_innerSlider.addEventListener(Event.CHANGE	, update);
			_innerSlider.x = 80;
			_innerSlider.y = 200;
			_innerSlider.label = "Inner:"
			
			_outerSlider = this.addChild(new HUISlider()) as HUISlider
			_outerSlider.setSliderParams(0, 60, 30);
			_outerSlider.addEventListener(Event.CHANGE	, update);
			_outerSlider.x = 80;
			_outerSlider.y = 220;
			_outerSlider.label = "Outer:"
			
			_angleSlider = this.addChild(new HUISlider()) as HUISlider
			_angleSlider.setSliderParams(0, 360, 0);
			_angleSlider.addEventListener(Event.CHANGE	, update);
			_angleSlider.x = 80;
			_angleSlider.y = 240;
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
			DrawingShapes.drawStar(_lineHolder.graphics, 170, 120, _pointsSlider.value, _innerSlider.value, _outerSlider.value,_angleSlider.value);// , 50, _angleSlider.value)
			
			//dispatch change to update the displayed code example
			dispatchEvent(new Event(Event.CHANGE));
			
		}
		
		public function getCodeSnippet():String
		{
			return "DrawingShapes.drawStar(_lineHolder.graphics, 170, 120," + _pointsSlider.value + "," + _innerSlider.value + "," + _outerSlider.value + "," + _angleSlider.value + ");";
		}
		
	}

}
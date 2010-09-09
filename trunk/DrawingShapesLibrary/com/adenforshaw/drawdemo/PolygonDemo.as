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
	public class PolygonDemo extends Sprite
	{
		
		protected var _strokeColor:Number	= 0x0B6CC0;// 0B6CC0;
		protected var _lineThickness:Number	= 2;
		protected var _fillColor:Number		= 0xFFFFFF;
		
		protected var _sidesSlider:HUISlider;
		protected var _radiusSlider:HUISlider;
		protected var _angleSlider:HUISlider;
		protected var _lineHolder:Sprite;
		
		public function PolygonDemo() 
		{
			_sidesSlider = this.addChild(new HUISlider()) as HUISlider
			_sidesSlider.setSliderParams(3, 30, 4);
			_sidesSlider.addEventListener(Event.CHANGE	, update);
			_sidesSlider.x = 80;
			_sidesSlider.y = 200;
			_sidesSlider.label = "Sides:"
			
			_radiusSlider = this.addChild(new HUISlider()) as HUISlider
			_radiusSlider.setSliderParams(5, 80,50);
			_radiusSlider.addEventListener(Event.CHANGE	, update);
			_radiusSlider.x = 80;
			_radiusSlider.y = 220;
			_radiusSlider.label = "Radius:"
			
			_angleSlider = this.addChild(new HUISlider()) as HUISlider
			_angleSlider.setSliderParams(0, 360,0);
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
			DrawingShapes.drawPolygon(_lineHolder.graphics,170,120,_sidesSlider.value,_radiusSlider.value,_angleSlider.value)
			
			//dispatch change to update the displayed code example
			dispatchEvent(new Event(Event.CHANGE));
			
		}
		
		public function getCodeSnippet():String
		{
			return "DrawingShapes.drawPolygon(_lineHolder.graphics,170,120," + _sidesSlider.value + "," + _radiusSlider.value + "," + _angleSlider.value + ");";
		}
		
	}

}
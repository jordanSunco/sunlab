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
	public class GearDemo extends Sprite
	{
		
		protected var _strokeColor:Number	= 0x0B6CC0;// 0B6CC0;
		protected var _lineThickness:Number	= 2;
		protected var _fillColor:Number		= 0xFFFFFF;
		
		protected var _sidesSlider:HUISlider;
		protected var _innerSlider:HUISlider;
		protected var _outerSlider:HUISlider;
		protected var _angleSlider:HUISlider;
		protected var _holeSidesSlider:HUISlider;
		protected var _holeRadiusSlider:HUISlider;
		protected var _lineHolder:Sprite;
		
		public function GearDemo() 
		{
			_sidesSlider = this.addChild(new HUISlider()) as HUISlider
			_sidesSlider.setSliderParams(3, 30, 12);
			_sidesSlider.addEventListener(Event.CHANGE	, update);
			_sidesSlider.x = 10;
			_sidesSlider.y = 200;
			_sidesSlider.label = "Sides:"
			
			_innerSlider = this.addChild(new HUISlider()) as HUISlider
			_innerSlider.setSliderParams(0, 60, 50);
			_innerSlider.addEventListener(Event.CHANGE	, update);
			_innerSlider.x = 10;
			_innerSlider.y = 220;
			_innerSlider.label = "Inner:"
			
			_outerSlider = this.addChild(new HUISlider()) as HUISlider
			_outerSlider.setSliderParams(0, 60, 40);
			_outerSlider.addEventListener(Event.CHANGE	, update);
			_outerSlider.x = 10;
			_outerSlider.y = 240;
			_outerSlider.width = 260;
			_outerSlider.label = "Outer:"
			
			_angleSlider = this.addChild(new HUISlider()) as HUISlider
			_angleSlider.setSliderParams(0, 360, 0);
			_angleSlider.addEventListener(Event.CHANGE	, update);
			_angleSlider.x = 180;
			_angleSlider.y = 200;
			_angleSlider.label = "Angle:"
			
			_holeSidesSlider = this.addChild(new HUISlider()) as HUISlider
			_holeSidesSlider.setSliderParams(0, 30, 6);
			_holeSidesSlider.addEventListener(Event.CHANGE	, update);
			_holeSidesSlider.x = 180;
			_holeSidesSlider.y = 220;
			_holeSidesSlider.label = "Hole Sides:"
			
			_holeRadiusSlider = this.addChild(new HUISlider()) as HUISlider
			_holeRadiusSlider.setSliderParams(0, 30, 12);
			_holeRadiusSlider.addEventListener(Event.CHANGE	, update);
			_holeRadiusSlider.x = 180;
			_holeRadiusSlider.y = 240;
			_holeRadiusSlider.label = "Hole Radius:"
			_sidesSlider.width = _innerSlider.width = _outerSlider.width=_angleSlider.width =_holeSidesSlider.width=_holeRadiusSlider.width=180;
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
			DrawingShapes.drawGear(_lineHolder.graphics, 170, 110, _sidesSlider.value, _innerSlider.value,
			_outerSlider.value,_angleSlider.value,_holeSidesSlider.value,_holeRadiusSlider.value)
			
			//dispatch change to update the displayed code example
			dispatchEvent(new Event(Event.CHANGE));
			
		}
		
		public function getCodeSnippet():String
		{
			return "DrawingShapes.drawGear(_lineHolder.graphics, 170, 110," + _sidesSlider.value + "," + _innerSlider.value + "," + _outerSlider.value + "," + _angleSlider.value + "," + _holeSidesSlider.value + "," + _holeRadiusSlider.value + ");";
		}
		
	}

}
package  
{
	import com.adenforshaw.drawdemo.*;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	/**
	 * ...
	 * @author Aden Forshaw
	 */
	public class DrawingShapesDemo extends MovieClip
	{
		
		protected var _demoHolder:Sprite;
		protected var _strokeColor:Number	= 0x0B6CC0;// 0B6CC0;
		protected var _lineThickness:Number	= 2;
		protected var _fillColor:Number		= 0xFFFFFF;
		
		//dash demo
		protected var _dashedLine:Sprite;
		protected var _handles:Array;
		protected var _heldHandle:Sprite;
		
		public function DrawingShapesDemo() 
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			dashBtn.addEventListener(MouseEvent.CLICK	, drawDashDemo);
			arcBtn.addEventListener(MouseEvent.CLICK	, drawArcDemo);
			wedgeBtn.addEventListener(MouseEvent.CLICK	, drawWedgeDemo);
			starBtn.addEventListener(MouseEvent.CLICK	, drawStarDemo);
			polygonBtn.addEventListener(MouseEvent.CLICK, drawPolygonDemo);
			burstBtn.addEventListener(MouseEvent.CLICK	, drawBurstDemo);
			gearBtn.addEventListener(MouseEvent.CLICK	, drawGearDemo);
			drawDashDemo();
		}
		
		protected function drawDemoHolder():void
		{
			if (_demoHolder)
			{
				_demoHolder.parent.removeChild(_demoHolder);
				_demoHolder = null;
			}
			_demoHolder = this.addChild(new Sprite()) as Sprite;
			_demoHolder.x = 20;
			_demoHolder.y = 60;
		}
		
		public function drawDashDemo(event:*=null):void
		{
			drawDemoHolder();
			demoName_txt.text = "DASHED LINE DEMO";
			var demo = _demoHolder.addChild(new DashDemo())
			demo.addEventListener(Event.CHANGE, onDemo_Change);
			demo.dispatchEvent(new Event(Event.CHANGE));
		}
		
		protected function drawArcDemo(event:*=null):void
		{
			drawDemoHolder();
			demoName_txt.text = "ARC DEMO";
			var demo = _demoHolder.addChild(new ArcDemo())
			demo.addEventListener(Event.CHANGE, onDemo_Change);
			demo.dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function drawWedgeDemo(event:*=null):void
		{
			drawDemoHolder();
			demoName_txt.text = "WEDGE DEMO";
			var demo = _demoHolder.addChild(new WedgeDemo())
			demo.addEventListener(Event.CHANGE, onDemo_Change);
			demo.dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function drawStarDemo(event:*=null):void
		{
			drawDemoHolder();
			demoName_txt.text = "STAR DEMO";
			var demo = _demoHolder.addChild(new StarDemo())
			demo.addEventListener(Event.CHANGE, onDemo_Change);
			demo.dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function drawPolygonDemo(event:*=null):void
		{
			drawDemoHolder();
			demoName_txt.text = "POLYGON DEMO";
			var demo = _demoHolder.addChild(new PolygonDemo())
			demo.addEventListener(Event.CHANGE, onDemo_Change);
			demo.dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function drawBurstDemo(event:*=null):void
		{
			drawDemoHolder();
			demoName_txt.text = "BURST DEMO";
			var demo = _demoHolder.addChild(new BurstDemo())
			demo.addEventListener(Event.CHANGE, onDemo_Change);
			demo.dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function drawGearDemo(event:*=null):void
		{
			drawDemoHolder();
			demoName_txt.text = "GEAR DEMO";
			var demo = _demoHolder.addChild(new GearDemo())
			demo.addEventListener(Event.CHANGE, onDemo_Change);
			demo.dispatchEvent(new Event(Event.CHANGE));
		}
		
		protected function onDemo_Change(event:Event=null):void
		{
			var demo = event.target;
			magicLine_txt.text = demo.getCodeSnippet();
		}
	}

}
package qs.controls.calendarDisplayClasses
{
	import mx.core.UIComponent;
	import mx.controls.Label;
	import mx.core.IDataRenderer;
	import qs.calendar.CalendarEvent;
	import qs.utils.DateUtils;
	import qs.utils.ColorUtils;
	import mx.core.UITextField;

	public class CalendarEventRenderer extends UIComponent implements IDataRenderer, ICalendarEventRenderer
	{
		private var _eventSummary:UITextField;
		private var _event:CalendarEvent;
		private var _allDay:Boolean = false;
		private var _displayMode:String;
		private var headerColor:uint;
		private var _grabColor:uint;
		
		private const BORDER_COLOR:Number = 0xAAAADD;
		private const HEADER_FILL:Number = 0xFFAAAA;

		public function CalendarEventRenderer():void
		{
			cacheAsBitmap = true;
		}
		
		override protected function createChildren():void
		{
			_eventSummary = new UITextField();	
			_eventSummary.styleName = this;
			_eventSummary.cacheAsBitmap = true;
			addChild(_eventSummary);
		}
		
		override protected function measure():void
		{
			measuredWidth = _eventSummary.measuredWidth;
			measuredHeight = _eventSummary.measuredHeight;
		}
	
		public function set displayMode(value:String):void
		{
			_displayMode = value;
			invalidateProperties();	
		}
		
		public function set data(value:Object):void
		{
			_event = CalendarEvent(value);
			if(_event != null)
			{
				if(_event.allDay)
					_allDay= true;
//				else
//					_allDay = (DateUtils.startOfDay(_event.start).getTime() != DateUtils.startOfDay(_event.end).getTime());

				var hsv:Object = ColorUtils.RGBToHSV(_event.calendar.contextColor);
				var v:Number = hsv.v;
				var s:Number = hsv.s;
				if(hsv.v > .3)
				{				
					hsv.v *= .7;
					hsv.s *= .9;
				}
				else
				{
					hsv.v *= 2;
					hsv.s *= .9;
				}
				headerColor = ColorUtils.HSVToRGB(hsv);
				hsv.v = Math.min(1,v*1.5);
				hsv.s = s/2;
				_grabColor = ColorUtils.HSVToRGB(hsv);

			}
			else
				_allDay = false;
			invalidateProperties();
		}
		public function get data():Object
		{
			return _event;
		}
		
		override protected function commitProperties():void
		{
			var eventText:String = "";
			if(_event != null)
			{
				if(_event.allDay == false)
				{
					var hour:int = _event.start.hours;
					if(hour >= 12)
						hour -= 12;
					if(hour == 0)
						hour = 12;
					eventText += hour.toString();
					if(_event.start.minutes > 0)
						eventText += ":"+_event.start.minutes;
					if(_event.start.hours >= 12)
						eventText += "p";
					else
						eventText += "a";
				}
				eventText += " " + _event.summary;				
			}
			if(_allDay || _displayMode == "box")
			{
				setStyle("color",0xFFFFFF);
			}
			else
			{
				setStyle("color",_event.calendar.contextColor);				
			}
			_eventSummary.text = eventText;
			toolTip = (_event)? eventText:null;
			invalidateSize();
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			graphics.clear();
			if(_displayMode == "line")
			{
				_eventSummary.setActualSize(unscaledWidth-_eventSummary.measuredHeight,unscaledHeight);			
				_eventSummary.x = measuredHeight/4;
				if(_allDay)
				{
					graphics.lineStyle(1,BORDER_COLOR);
					graphics.beginFill(_event.calendar.contextColor);
					graphics.drawRoundRect(0,2,unscaledWidth, unscaledHeight-4,unscaledHeight*.75,unscaledHeight*.75);
					graphics.endFill();
				}
			}
			else
			{
				_eventSummary.setActualSize(unscaledWidth-8,unscaledHeight);			
				_eventSummary.move(4,4);
				graphics.lineStyle(1,BORDER_COLOR);
				graphics.beginFill(headerColor);
				graphics.lineStyle(0,0,0);

				if(unscaledHeight <= 20)
				{
					graphics.drawRoundRectComplex(0,2,unscaledWidth, unscaledHeight-4,8,8,8,8);
					graphics.endFill();
					graphics.lineStyle(1,_grabColor,1,false,"normal","none");
				}
				else
				{
					graphics.drawRoundRectComplex(0,2,unscaledWidth, _eventSummary.measuredHeight,8,8,0,0);
					graphics.endFill();
					graphics.beginFill(_event.calendar.contextColor);
					graphics.drawRoundRectComplex(0,2+_eventSummary.measuredHeight,unscaledWidth, unscaledHeight-2 - (2+_eventSummary.measuredHeight),0,0,8,8);
					graphics.endFill();
					graphics.lineStyle(1,_grabColor,1,false,"normal","none");
					graphics.moveTo(0,unscaledHeight-8 );
					graphics.lineTo(unscaledWidth,unscaledHeight-8);
				}
				graphics.moveTo(unscaledWidth/2-4,unscaledHeight-6 );
				graphics.lineTo(unscaledWidth/2+4,unscaledHeight-6 );
				graphics.moveTo(unscaledWidth/2-4,unscaledHeight-4 );
				graphics.lineTo(unscaledWidth/2+4,unscaledHeight-4 );
				
			}
			
		}
		
		
	}
}
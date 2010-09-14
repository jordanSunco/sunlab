package qs.controls.calendarDisplayClasses
{
	import mx.containers.Canvas;

	public class CalendarEventRenderer_code extends Canvas
	{
	
		import qs.calendar.CalendarEvent;
		[Bindable] protected var contextColor:uint;
		[Bindable] protected var eventText:String = "";
		
		override public function set data(value:Object):void
		{
			super.data = value;
			var event:CalendarEvent = CalendarEvent(value);
			contextColor = event.calendar.contextColor;
	
			var eventText:String = "";
	
			if(event != null)
			{
				if(event.allDay == false)
				{
					var hour:int = event.start.hours;
					if(hour >= 12)
						hour -= 12;
					if(hour == 0)
						hour = 12;
					eventText += hour.toString();
					if(event.start.minutes > 0)
						eventText += ":"+event.start.minutes;
					if(event.start.hours >= 12)
						eventText += "p";
					else
						eventText += "a";
				}
				eventText += " " + event.summary;				
			}
			this.eventText = eventText;
			toolTip = (event)? eventText:null;
		}
	}
}
package qs.controls.calendarDisplayClasses
{
	import flash.events.Event;
	import qs.calendar.CalendarEvent;

	public class CalendarDisplayEvent extends Event
	{
		public static const DAY_CLICK:String = "dayClick";
		public static const ITEM_CLICK:String = "itemClick";
		public static const HEADER_CLICK:String = "headerClick";
		public static const DISPLAY_MODE_CHANGE:String = "displayModeChange";
		public function CalendarDisplayEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		public var dateTime:Date;
		public var event:CalendarEvent;
		
	}
}
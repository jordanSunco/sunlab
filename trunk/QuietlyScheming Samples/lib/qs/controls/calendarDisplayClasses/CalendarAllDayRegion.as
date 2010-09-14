package qs.controls.calendarDisplayClasses
{
	import mx.core.UIComponent;
	import mx.core.UITextField;
	import qs.controls.CalendarDisplay;

	public class CalendarAllDayRegion extends UIComponent
	{
		public var labelWidth:Number = 0;
		public var gutterWidth:Number = 0;
		
		private var calendar:CalendarDisplay;

		public function CalendarAllDayRegion(calendar:CalendarDisplay):void
		{
			this.calendar = calendar;			
		}
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			var dividerThickness:Number = calendar.getStyle("allDayDividerThickness");
			var dividerColor:Number = calendar.getStyle("allDayDividerColor");
			var bgColor:Number = calendar.getStyle("allDayBackgroundColor");
			
			graphics.clear();
			if(unscaledHeight == 0 || unscaledWidth == 0)
				return;
				
			if(!isNaN(bgColor))
			{
				graphics.lineStyle(0,0,0);
				graphics.beginFill(bgColor);
				graphics.drawRect(0,0,unscaledWidth,unscaledHeight);
				graphics.endFill();
			}
			
			if(!isNaN(dividerThickness) && !isNaN(dividerColor))
			{
				graphics.lineStyle(dividerThickness,dividerColor,1,false,"normal","none");
				graphics.moveTo(0,unscaledHeight - dividerThickness);
				graphics.lineTo(unscaledWidth,unscaledHeight - dividerThickness);
			}
		}
	}
}
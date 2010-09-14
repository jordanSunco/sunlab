package qs.controls.calendarDisplayClasses
{
	import mx.core.UIComponent;
	import mx.controls.Label;
	import mx.core.IDataRenderer;

	public class CalendarHeader extends UIComponent implements IDataRenderer
	{
		private var _dayLabel:Label;
		private var _date:Date;
		
		private const BORDER_COLOR:Number = 0xAAAADD;
		private const HEADER_FILL:Number = 0xE8EEF7;

		public function CalendarHeader():void
		{
		}
		
		override protected function createChildren():void
		{
			_dayLabel = new Label();	
			addChild(_dayLabel);
		}
		
		override protected function measure():void
		{
			measuredWidth = _dayLabel.measuredWidth;
			measuredHeight = _dayLabel.measuredHeight;
		}
		
		public function set data(value:Object):void
		{
			_date = (value as Date);
			invalidateProperties();
		}
		public function get data():Object
		{
			return _date;
		}
		
		override protected function commitProperties():void
		{
			_dayLabel.text = (_date == null)? "":_date.date.toString();
			invalidateSize();
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			_dayLabel.setActualSize(unscaledWidth,unscaledHeight);			
			
			graphics.clear();
			graphics.lineStyle(1,BORDER_COLOR);
			graphics.beginFill(HEADER_FILL);
			graphics.drawRect(0,0,unscaledWidth, unscaledHeight );
			graphics.endFill();
			
		}
		
		
	}
}
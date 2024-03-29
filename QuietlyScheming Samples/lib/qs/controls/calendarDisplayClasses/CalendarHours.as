package qs.controls.calendarDisplayClasses
{
	import mx.core.UIComponent;
	import mx.core.UITextField;
	import qs.controls.CalendarDisplay;

	public class CalendarHours extends UIComponent
	{
		private var labels:Array = [];
		
		public var labelWidth:Number = 0;
		public var gutterWidth:Number = 0;
		
		private var calendar:CalendarDisplay;
		public function CalendarHours(calendar:CalendarDisplay):void
		{
			this.calendar = calendar;			
		}
		override protected function createChildren():void
		{
			for(var i:int = 0;i<24;i++)
			{
				var tf:UITextField = new UITextField();
				labels[i] = tf;
				tf.styleName = this;
				var idx:int = i % 12;
				if (idx == 0)
					idx = 12;
				var text:String = idx.toString();
				if(i < 12)
					text += " am";
				else
					text += " pm";
				tf.text = text;

				addChild(tf);
					
			}
		}
		
		override protected function measure():void
		{
			labelWidth = 0;
			for(var i:int = 0;i<24;i++)
			{
				labelWidth = Math.max(labelWidth,labels[i].measuredWidth);
			}
			
			gutterWidth = labelWidth + 2;
			var dividerThickness:Number = calendar.getStyle("hourDividerThickness");

			if(!isNaN(dividerThickness))
				gutterWidth += dividerThickness;
		}
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			var hourSize:Number = unscaledHeight / 24;
			var dividerThickness:Number = calendar.getStyle("hourDividerThickness");
			var dividerColor:Number = calendar.getStyle("hourDividerColor");
			var bgColor:Number = calendar.getStyle("hourBackgroundColor");
			var lineThickness: Number = calendar.getStyle("hourThickness");
			var lineColor:Number = calendar.getStyle("hourColor");
			
			graphics.clear();
			if(!isNaN(bgColor))
			{
				graphics.lineStyle(0,0,0);
				graphics.beginFill(bgColor);
				graphics.drawRect(0,0,gutterWidth,unscaledHeight);
				graphics.endFill();
			}
			
			if(!isNaN(lineThickness) && !isNaN(lineColor))
			{
				graphics.lineStyle(lineThickness,lineColor);				
				for(var i:int = 0;i<24;i++)
				{
					var tf:UITextField = labels[i];
					tf.setActualSize(labelWidth,tf.measuredHeight);
					tf.move(0,hourSize * i);
					graphics.moveTo(0,hourSize*i);
					graphics.lineTo(unscaledWidth,hourSize*i);			
				}
			}


			if(!isNaN(dividerThickness) && !isNaN(dividerColor))
			{
				graphics.lineStyle(dividerThickness,dividerColor);
				graphics.moveTo(gutterWidth - Math.max(1,dividerThickness) + 1, 0);
				graphics.lineTo(gutterWidth - Math.max(1,dividerThickness) + 1, unscaledHeight);
			}
		}
	}
}
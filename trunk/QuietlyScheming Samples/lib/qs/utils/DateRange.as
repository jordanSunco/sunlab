package qs.utils
{
	public class DateRange
	{
		public var start:Date;
		public var end:Date;
		public function DateRange(start:Date = null,end:Date = null):void
		{
			this.start = start;
			this.end = (end != null)? end:
					   (start != null)? new Date(start.getTime()):
					   null;
		}

		public function get milliSpan():int 
		{
			return end.getTime() - start.getTime();
		}
		public function get duration():Number
		{
			return end.getTime() - start.getTime();
		}
		public function set duration(value:Number):void
		{
			end = new Date(start.getTime() + value);
		}
		public function clone():DateRange
		{
			return new DateRange(new Date(this.start),new Date(this.end));
		}
		
		public function contains(value:Date):Boolean
		{
			return (value >= start && value <= end);
		}

		public function containsRange(value:DateRange):Boolean
		{
			return (value.start >= start && value.end <= end);
		}
		
		public function get valid():Boolean
		{
			return (end >= start);
		}
		public function intersect(rhs:DateRange):DateRange
		{
			return new DateRange(	
				new Date(Math.max(start.getTime(),rhs.start.getTime())),
				new Date(Math.min(end.getTime(), rhs.end.getTime()))
				);
						 
		}
		public function moveTo(newStart:Date):void
		{
			var diff:Number = newStart.getTime() - start.getTime();
			end.setTime(end.getTime() + diff);
			start.setTime(newStart.getTime());
		}
		
		public function toString():String
		{
			return start.toString() + " -- " + end.toString();
		}
	}
}
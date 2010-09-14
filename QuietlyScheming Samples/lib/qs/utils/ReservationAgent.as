package qs.utils
{
	import flash.utils.Dictionary;
	
	public class ReservationAgent
	{
		private var reservations:Object = {};
		private var customerMap:Dictionary = new Dictionary();
		private var _tableCount:int = 0;		
		public function ReservationAgent():void
		{
		}
		// horribly innefficient...needs to be optimized at some point
		public function reserve(customer:Object):int
		{
			var nextTable:int = findMaxTable();
			
			_tableCount = Math.max(_tableCount, nextTable+1);
			reservations[nextTable] = customer;
			customerMap[customer] = nextTable;
			return nextTable;
		}
		public function release(customer:Object):void
		{
			var table:int = customerMap[customer];

			delete reservations[table];
			delete customerMap[customer];
			if(table == _tableCount-1)
				_tableCount = findMaxTable();
		}
		
		private function findMaxTable():int
		{
			var nextTable:int = 0;
			while(nextTable in reservations)
				nextTable++;
			return nextTable;
		}
		public function get count():int
		{
			return _tableCount;
		}
	}
}
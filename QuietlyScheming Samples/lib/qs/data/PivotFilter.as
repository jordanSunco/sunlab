package qs.data
{
	import mx.collections.IList;
	import flash.utils.Dictionary;
	
	public class PivotFilter
	{
	
		private var _slices:Array = [];
		private var _seriesTemplates:Array = [];
		private var _series:Array = [];
		private var _splits:Array = [];
		
		public function get series():Array
		{
			return _series;
		}
		
		[ArrayElementType("mx.core.IFactory")]
		[InstanceType("mx.charts.chartClasses.Series")]
		public function set seriesTemplates(value:Array):void
		{
			_seriesTemplates = value;
		}

		public function set slices(value:Array):void
		{
			_slices = value;
		}
		public function get slices():Array
		{
			return _slices;
		}

		private var _dataProvider:IList;				
		public function set dataProvider(value:Object):void
		{
			if (value is Array)
			{
				value = new ArrayCollection(value as Array);
			}
			else if (value is IList)
			{
			}
			else if (value is XMLList)
			{
				value = new XMLListCollection(XMLList(value));
			}
			else if (value != null)
			{
				value = new ArrayCollection([ value ]);
			}
			else
			{
				value = new ArrayCollection();
			}
			
			_dataProvider = IList(value);			
		}
		
		public function get dataProvider():Object
		{
			return _dataProvider;
		}
				
		public function commit():void
		{
			var dps:Dictionary = new Dictionary();
			var len:int = _dataProvider.length;		
			for(var i:int = 0;i<len;i++)
			{
				var record:Object = _dataProvider.getItemAt(i);
			}
		}
	}
}
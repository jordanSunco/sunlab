package WeatherGadgets {
	import flash.utils.Timer;

	public class MyTimer extends Timer {
		public function MyTimer(delay:Number, repeatCount:int=0) {
			super(delay, repeatCount);
		}
		
		public var sequenceNumber : int = 0;
		
	}
}
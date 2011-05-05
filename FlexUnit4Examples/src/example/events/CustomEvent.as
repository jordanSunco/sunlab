package example.events
{
	import flash.events.Event;

	public class CustomEvent extends Event
	{
		/**
		 * Not really good practice here, but just a simple event with a custom property
		 * to show testing with pass through data in UI context. 
		 */
		public var data:*;
		
		/**
		 * Constructor.
		 */
		public function CustomEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false )
		{
			super( type, bubbles, cancelable );
		}
		
		override public function clone():Event
		{
			var event:CustomEvent = new CustomEvent( type, bubbles, cancelable );
			event.data = data;
			return event;
		}
	}
}
package example.async
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.Responder;
	
	import org.flexunit.Assert;
	import org.flexunit.async.Async;
	
	public class AsyncExampleTest
	{
		[Test( async )]
		public function testRetreiveImages():void
		{
			var token:AsyncToken = new AsyncToken( null ); // httpService.send(); 
			
			token.addResponder( Async.asyncResponder( this,
													new Responder( service_resultHandler, 
																	service_faultHandler ), 
													3000, // timeout
													null, // pass-through data
													async_timeoutHandler ) );
		}
		
		protected function service_resultHandler( event:ResultEvent ):void
		{
			Assert.assertNotNull( event.result );	
		}
		
		protected function service_faultHandler( event:FaultEvent ):void
		{
			Assert.fail( "Service fault" );
		}
		
		protected function async_timeoutHandler( object:Object ):void
		{
			Assert.fail( "Pending event never fired" );
		}
		
		[Test( async, timeout="2000" )]
		public function testImageEncoding():void
		{
			var imageEncoder:*;
			
			Async.handleEvent( this, imageEncoder, Event.COMPLETE, handleImageEncoded );
			Async.failOnEvent( this, imageEncoder, ErrorEvent.ERROR );
			imageEncoder.encode();
		}
		
		protected function handleImageEncoded( event:Event ):void
		{
			var data:* = event.target.data;
			
			Assert.assertNotNull( data );
		}

		
	}
}

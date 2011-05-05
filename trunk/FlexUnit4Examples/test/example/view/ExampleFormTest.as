package example.view
{
	import example.events.CustomEvent;
	
	import flash.events.MouseEvent;
	
	import mx.events.FlexEvent;
	
	import org.flexunit.Assert;
	import org.flexunit.async.Async;
	import org.fluint.uiImpersonation.UIImpersonator;

	public class ExampleFormTest
	{
		private var view:ExampleForm;
		
		[Before( async, ui )]
		public function setUp():void
		{
			view = new ExampleForm();
						
			Async.proceedOnEvent( this, view, FlexEvent.CREATION_COMPLETE, 500 );
			UIImpersonator.addChild( view );
		}
		
		[After( async, ui )]
		public function tearDown():void
		{
			UIImpersonator.removeChild( view );
			view = null;
		}
		
		[Test( async, ui )]
		public function testSaveButton():void 
		{
			// Initially save starts out as disabled
			Assert.assertFalse( view.save.enabled );
			
			// Add some user input to the form
			view.username.text = "example";
			
			// Now the save button should be enabled since username has text in it
			Assert.assertTrue( view.save.enabled );
			
			// With the button enabled, test that clicking dispatches an event.  
						
			Async.handleEvent( this, view, "save", view_saveHandler, 500, "example" );
			// Simulate mouse click event for save button
			view.save.dispatchEvent( new MouseEvent( MouseEvent.CLICK, true, false ) );
			
		}
		
		protected function view_saveHandler( event:CustomEvent, passThroughData:* ):void
		{
			Assert.assertEquals( passThroughData, event.data );
		}
		
	}
}
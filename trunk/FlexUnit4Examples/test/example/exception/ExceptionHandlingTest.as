package example.exception
{
	public class ExceptionHandlingTest
	{
		[Test( expected="Error" )]
		public function testThatErrorIsThrown():void
		{
			throw new Error( "Expected Error" );
		}
	}
}
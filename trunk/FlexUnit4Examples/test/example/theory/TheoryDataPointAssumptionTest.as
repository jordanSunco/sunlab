package example.theory
{
	import org.flexunit.Assert;
	import org.flexunit.assumeThat;
	import org.hamcrest.core.not;
	import org.hamcrest.object.equalTo;

	[RunWith( "org.flexunit.experimental.theories.Theories" )]
	public class TheoryDataPointAssumptionTest
	{
		[DataPoints]
		[ArrayElementType( "String" )]
		public static var stringValues:Array = [ "one","two","three","four","five" ];
		
		[DataPoint]
		public static var values1:int = 2;
		
		[DataPoint]
		public static var values2:int = 4;
		
		[DataPoints]
		[ArrayElementType("int")]
		public static function provideData():Array
		{
			return [ -10, 0, 2, 4, 8, 16 ];
		}
		
		[Theory]
		public function testDivide( value1:int, value2:int ):void
		{
			// This test isn't valid is the second value is 0 (since we can't devide by 0),
			// so the assumeThat function here acts as a guard to validate that data is within
			// our expected constraints before running the test.
			assumeThat( value2, not( equalTo( 0 ) ) );
			
			var result:Number = value1 / value2;
			Assert.assertFalse( "result for " + value1 + " / " + value2 + " is "  + result,
								isNaN( result ) );
		}
		
	}
}
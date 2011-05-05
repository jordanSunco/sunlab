package example
{
	import example.async.AsyncExampleTest;
	import example.exception.ExceptionHandlingTest;
	import example.theory.TheoryDataPointAssumptionTest;
	import example.translator.PersonXmlTest;
	import example.view.ExampleFormTest;

	[Suite]
	[RunWith( "org.flexunit.runners.Suite" )]   
	public class ExampleSuite
	{
		public var t1:PersonXmlTest;
		public var t2:ExceptionHandlingTest;
		public var t3:AsyncExampleTest;
		public var t4:ExampleFormTest;
		public var t5:TheoryDataPointAssumptionTest;
	}
}
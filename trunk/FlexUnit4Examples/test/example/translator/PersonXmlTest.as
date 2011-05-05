package example.translator
{
	import flash.utils.ByteArray;
	
	import org.flexunit.Assert;

	public class PersonXmlTest
	{
		// Demonstrating how to embed data to test against
		[Embed( source="personXmlTest_1.xml", mimeType="application/octet-stream" )] 
		private static const personXmlTest_1_bytes:Class;
		private static var personXml:XML;
		
		// If this XML would be modified in the tests then I would use [Before]
		// metadata and re-read the data in every time.  Or, you could always
		// just embed the XML directly:
		// 		personXml = <person id="1"><name first="Helen" last="Rhyne" /></person>;
		[BeforeClass]
		public static function initialize():void
		{
			var bytes:ByteArray = new personXmlTest_1_bytes() as ByteArray;
			personXml = new XML( bytes.readUTFBytes( bytes.length ) );
		}
		
		[AfterClass]
		public static function cleanup():void
		{
			personXml = null;
		}
		
		[Test]
		public function testDecodeXml():void
		{
			var person:Object;
			
			person = PersonXml.decodeXml( personXml.person[ 0 ] );
			
			Assert.assertNotNull( person );
			Assert.assertEquals( 1, person.id );
			Assert.assertEquals( "Helen", person.firstName );
			Assert.assertEquals( "Rhyne", person.lastName );
			
			person = PersonXml.decodeXml( personXml.person[ 1 ] );
			
			Assert.assertNotNull( person );
			Assert.assertEquals( 2, person.id );
			Assert.assertEquals( "Percy", person.firstName );
			Assert.assertEquals( "Dawson", person.lastName );
		}
		
	}
}
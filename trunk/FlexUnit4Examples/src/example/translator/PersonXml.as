package example.translator
{
	import example.model.Person;

	public class PersonXml
	{
		/**
		 * Converts a &lt;person&gt; XML node into a <code>Person</code> instance.
		 * 
		 * &lt;person id="1"&gt;
		 * 		&lt;name first="Helen" last="Rhyne" /&gt;
		 * &lt;/person&gt;
		 */
		public static function decodeXml( personXml:XML ):Person
		{
			var person:Person = new Person();
			person.id = int( personXml.@id );
			person.firstName = personXml.name.@first.toString();
			person.lastName = personXml.name.@last.toString();
			
			return person;
		}
	}
}
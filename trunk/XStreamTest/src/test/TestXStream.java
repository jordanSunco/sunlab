/*
 * Copyright
 */

package test;

import test.model.Person;
import test.model.PhoneNumber;

import com.thoughtworks.xstream.XStream;
import com.thoughtworks.xstream.io.json.JettisonMappedXmlDriver;
import com.thoughtworks.xstream.io.xml.DomDriver;

/**
 * 测试使用XStream JSON <-> Object <-> XML
 * http://xstream.codehaus.org/tutorial.html
 * 
 * @author Sun
 * @version TestXStream.java 2010-7-24 上午11:19:06
 */
public class TestXStream {
    private static Person joe;
    
    public static void main(String[] args) {
        init();
        testXml();
        testJson();
    }

    private static void init() {
        joe = new Person("Joe", "Walnes");
        joe.setPhone(new PhoneNumber(123, "1234-456"));
        joe.setFax(new PhoneNumber(123, "9999-999"));
    }

    private static void testXml() {
        // require XPP3 library, an XML pull parser (recommended, to improve performance)
        XStream xstream = new XStream();
        // If you do not want to include this dependency,
        // you can use a standard JAXP DOM parser instead:
        // XStream xstream = new XStream(new DomDriver());

        xstream.alias("person", Person.class);
        xstream.alias("phonenumber", PhoneNumber.class);

        String xml = xstream.toXML(joe);
        System.out.println(xml);

        Person newJoe = (Person) xstream.fromXML(xml);
        System.out.println(newJoe);
    }

    private static void testJson() {
        // http://xstream.codehaus.org/json-tutorial.html
        // The JsonHierarchicalStreamDriver can only write JSON
        // XStream xstream = new XStream(new JsonHierarchicalStreamDriver());
        // Jettison can also deserialize JSON to Java objects again
        XStream xstream = new XStream(new JettisonMappedXmlDriver());

        xstream.setMode(XStream.NO_REFERENCES);
        xstream.alias("person", Person.class);

        String json = xstream.toXML(joe);
        System.out.println(json);

        Person newJoe = (Person) xstream.fromXML(json);
        System.out.println(newJoe);
    }
}

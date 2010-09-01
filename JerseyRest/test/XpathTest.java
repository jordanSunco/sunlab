/*
 * Copyright
 */

import java.io.IOException;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;

import org.w3c.dom.Document;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

/**
 * How to use XPath to query an XML document via Java.
 * XPath (XML Path Language) is a language for selecting / searching nodes from an XML document.
 * Java 5 introduced the javax.xml.xpath package which provides a XPath library.
 * 
 * @author Sun
 * @version XpathTest.java 2010-9-1 上午11:03:48
 */
public class XpathTest {
    private static final String XML = "test/person.xml";

    public static void main(String[] args) throws XPathExpressionException,
            ParserConfigurationException, SAXException, IOException {
        // Standard of reading a XML file
        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        DocumentBuilder builder = factory.newDocumentBuilder();
        Document doc = builder.parse(XML);

        // Create a XPathFactory
        XPathFactory xFactory = XPathFactory.newInstance();
        // Create a XPath object
        XPath xpath = xFactory.newXPath();

        // Compile the XPath expression
        XPathExpression expr = xpath
                .compile("//person[firstname='Lars']/lastname/text()");
        // Run the query and get a nodeset
        Object result = expr.evaluate(doc, XPathConstants.NODESET);

        // Cast the result to a DOM NodeList
        NodeList nodes = (NodeList) result;
        for (int i = 0; i < nodes.getLength(); i++) {
            System.out.println(nodes.item(i).getNodeValue());
        }

        // New XPath expression to get the number of people with name lars
        expr = xpath.compile("count(//person[firstname='Lars'])");
        // Run the query and get the number of nodes
        Double number = (Double) expr.evaluate(doc, XPathConstants.NUMBER);
        System.out.println("Number of objects " + number);

        // Do we have more then 2 people with name lars?
        expr = xpath.compile("count(//person[firstname='Lars']) > 2");
        // Run the query and get the number of nodes
        Boolean check = (Boolean) expr.evaluate(doc, XPathConstants.BOOLEAN);
        System.out.println(check);
    }
}

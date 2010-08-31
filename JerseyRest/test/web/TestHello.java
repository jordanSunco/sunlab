/*
 * Copyright
 */

package web;

import static org.junit.Assert.assertEquals;

import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.MultivaluedMap;

import model.Model;

import org.junit.Before;
import org.junit.Test;

import com.sun.jersey.api.client.Client;
import com.sun.jersey.api.client.ClientResponse;
import com.sun.jersey.api.client.WebResource;
import com.sun.jersey.api.client.filter.LoggingFilter;
import com.sun.jersey.api.representation.Form;
import com.sun.jersey.core.util.MultivaluedMapImpl;

/**
 * 
 * @author Sun
 * @version TestHello.java 2010-8-19 上午08:49:54
 */
public class TestHello {
    WebResource resource;

    @Before
    public void setUp() {
        LoggingFilter loggingFilter = new LoggingFilter();
        Client client = Client.create();
        client.addFilter(loggingFilter);

        this.resource = client
                .resource("http://localhost:8080/JerseyRest/hello");
    }

    /**
     * Test method for {@link web.Hello#sayHtmlHello(String, java.util.List)}.
     */
    @Test
    public void testSayHtmlHelloGetClientResponse() {
        String clientResponseString = this.resource.accept(MediaType.TEXT_HTML)
                .get(ClientResponse.class).toString();

        assertEquals(
                "GET http://localhost:8080/JerseyRest/hello returned a response status of 200",
                clientResponseString);
    }

    /**
     * Test method for {@link web.Hello#sayHtmlHello(String, java.util.List)}.
     */
    @Test
    public void testSayHtmlHelloGetString() {
        MultivaluedMap<String, String> params = new MultivaluedMapImpl();
        params.add("id", "foo");
        params.add("name", "bar");
        params.add("name", "foobar");

        String responseHtml = this.resource.queryParams(params)
                .accept(MediaType.TEXT_HTML).get(String.class);

        assertEquals(
                "<html><title>Hello Jersey</title><body><h1>QueryParam(a): foo, QueryParam(name): 2 size</h1></body></html>",
                responseHtml);
    }

    /**
     * Test method for {@link web.Hello#sayXmlHello()}.
     */
    @Test
    public void testSayXMLHello() {
        String responseXml = this.resource.accept(MediaType.TEXT_XML).get(
                String.class);

        assertEquals("<?xml version=\"1.0\"?><hello> Hello Jersey</hello>",
                responseXml);
    }

    /**
     * Test method for {@link web.Hello#sayFormHello(String)}.
     */
    @Test
    public void testSayFormHello() {
        Form form = new Form();
        form.add("id", "foo");

        String responseHtml = this.resource
                .type(MediaType.APPLICATION_FORM_URLENCODED_TYPE)
                .accept(MediaType.TEXT_HTML).post(String.class, form);

        assertEquals(
                "<html><title>Hello Jersey</title><body><h1>FormParam:foo</h1></body></html>",
                responseHtml);
    }

    /**
     * Test method for {@link web.Hello#sayPathHello(String)}.
     */
    @Test
    public void testSayPathHello() {
        String responseHtml = this.resource.path("ids").path("foo")
                .accept(MediaType.TEXT_HTML).get(String.class);

        assertEquals(
                "<html><title>Hello Jersey</title><body><h1>PathParam:foo</h1></body></html>",
                responseHtml);
    }

    /**
     * Test method for {@link web.Hello#sayJavaBeanHello()}.
     */
    @Test
    public void testSayJavaBeanHelloGetXml() {
        String responseXml = this.resource.path("javabean")
                .accept(MediaType.APPLICATION_XML).get(String.class);

        assertEquals(
                "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><model><id>jaxb</id></model>",
                responseXml);
    }

    /**
     * Test method for {@link web.Hello#sayJavaBeanHello()}.
     */
    @Test
    public void testSayJavaBeanHelloGetJson() {
        String responseJson = this.resource.path("javabean")
                .accept(MediaType.APPLICATION_JSON).get(String.class);

        assertEquals("{\"id\":\"jaxb\"}", responseJson);
    }

    /**
     * Test method for {@link web.Hello#sayJavaBeanHello()}.
     */
    @Test
    public void testSayJavaBeanHelloGetJavaBean() {
        Model model = this.resource.path("javabean")
                .accept(MediaType.APPLICATION_XML).get(Model.class);

        assertEquals("jaxb", model.getId());
    }

    /**
     * Test method for {@link web.Hello#sayJsonpHello(String)}.
     */
    @Test
    public void testSayJsonpHello() {
        String responseJsonp = this.resource.path("jsonp")
                .accept("application/javascript").get(String.class);

        assertEquals("callback([{\"id\":\"jaxb\"}])", responseJsonp);
    }

    /**
     * Test method for {@link web.Hello#sayJsonpHello(String)}.
     */
    @Test
    public void testSayJsonpHelloWithCallback() {
        MultivaluedMap<String, String> params = new MultivaluedMapImpl();
        params.add("callback", "foo");

        String responseJsonp = this.resource.path("jsonp").queryParams(params)
                .accept("application/javascript").get(String.class);

        assertEquals("foo([{\"id\":\"jaxb\"}])", responseJsonp);
    }
}

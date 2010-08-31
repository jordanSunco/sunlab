/*
 * Copyright
 */

package web;

import java.util.ArrayList;
import java.util.List;

import javax.ws.rs.Consumes;
import javax.ws.rs.DefaultValue;
import javax.ws.rs.FormParam;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.GenericEntity;
import javax.ws.rs.core.MediaType;

import model.Model;

import com.sun.jersey.api.json.JSONWithPadding;

/**
 * http://localhost:8080/JerseyRest/application.wadl
 * 
 * @author Sun
 * @version Hello.java 2010-8-18 下午11:50:51
 */
@Path("hello")
public class Hello {
    /**
     * This method is called if TEXT_HTML is request
     * http://localhost:8080/JerseyRest/hello?id=foo&name=bar&name=foobar
     * 
     * @param id query string parameter(getParameter)
     * @param name multiple value query string parameter(getParameterValues)
     * @return html
     */
    @GET
    @Produces(MediaType.TEXT_HTML)
    public String sayHtmlHello(
            @DefaultValue("Robot") @QueryParam("id") String id,
            @QueryParam("name") List<String> name) {
        return "<html><title>Hello Jersey</title><body><h1>QueryParam(a): " + id
                + ", QueryParam(name): " + name.size() + " size</h1></body></html>";
    }

    /**
     * This method is called if TEXT_XML is request
     * 
     * @return xml
     */
    @GET
    @Produces(MediaType.TEXT_XML)
    public String sayXmlHello() {
        return "<?xml version=\"1.0\"?><hello> Hello Jersey</hello>";
    }

    /**
     * POST request from form
     * 
     * @param id form element value
     * @return html
     */
    @POST
    @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
    @Produces(MediaType.TEXT_HTML)
    public String sayFormHello(@FormParam("id") String id) {
        return "<html><title>Hello Jersey</title><body><h1>FormParam:" + id
                + "</h1></body></html>";
    }

    /**
     * GET REST path value
     * http://localhost:8080/JerseyRest/hello/ids/foo
     * 
     * @param id path
     * @return html
     */
    @GET
    @Path("ids/{id}")
    @Produces(MediaType.TEXT_HTML)
    public String sayPathHello(@PathParam("id") String id) {
        return "<html><title>Hello Jersey</title><body><h1>PathParam:" + id
                + "</h1></body></html>";
    }

    /**
     * Produce JSON
     * http://localhost:8080/JerseyRest/hello/javabean
     * 
     * @return json
     */
    @GET
    @Path("javabean")
    @Produces({ MediaType.APPLICATION_XML, MediaType.APPLICATION_JSON })
    public Model sayJavaBeanHello() {
        Model model = new Model();
        model.setId("jaxb");
        
        return model;
    }

    /**
     * Produce JSONP
     * http://localhost:8080/JerseyRest/hello/jsonp
     * 
     * @param callback jsonp callback function name
     * @return javascript
     */
    @GET
    @Path("jsonp")
    @Produces("application/javascript")
    public JSONWithPadding sayJsonpHello(@QueryParam("callback") String callback) {
        Model model = new Model();
        model.setId("jaxb");

        List<Model> l = new ArrayList<Model>();
        l.add(model);

        // return new JSONWithPadding(model);
        // collection data must use GenericEntity
        return new JSONWithPadding(new GenericEntity<List<Model>>(l) {
        }, callback);
    }
}

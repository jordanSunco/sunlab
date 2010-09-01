/*
 * Copyright
 */

import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.Writer;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Marshaller;
import javax.xml.bind.Unmarshaller;

import model.Model;

/**
 * Writing and reading the XML file via JAXB(Java Architecture for XML Binding) 2
 * 
 * @author Sun
 * @version Main.java 2010-9-1 上午10:14:17
 */
public class JaxbTest {
    private static final String MODEL_XML = "test/model.xml";

    public static void main(String[] args) throws JAXBException, IOException {
        // create javabean
        Model model = new Model();
        model.setId("foo");

        // create JAXB context and instantiate marshaller
        JAXBContext context = JAXBContext.newInstance(Model.class);

        Marshaller m = context.createMarshaller();
        m.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, Boolean.TRUE);
        m.marshal(model, System.out);

        // marshal to file
        Writer w = new FileWriter(MODEL_XML);
        m.marshal(model, w);
        w.close();

        // unmarshaller xml file to JavaBane(JAXB)
        Unmarshaller um = context.createUnmarshaller();
        Model model1 = (Model) um.unmarshal(new FileReader(MODEL_XML));

        System.out.println(model1.getId());
    }
}

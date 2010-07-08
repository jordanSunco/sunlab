// provide namespace
dojo.provide("com.test.dijit.a.Adijit");

// include dijit dependecies
dojo.require("dijit._Widget");
dojo.require("dijit._Templated");

//declare new dijit class
dojo.declare("com.test.dijit.a.Adijit", [dijit._Widget, dijit._Templated], {
    p: "",
    // path to template
    templatePath: dojo.moduleUrl("com.test", "dijit/a/templates/Adijit.html")
  }
);

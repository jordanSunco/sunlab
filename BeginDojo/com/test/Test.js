dojo.provide("com.test.Test")
dojo.declare("com.test.Test", null, {
    constructor: function(p) {
        this.p = p;
    },
    t: function() {
        alert(this.p);
    }
});

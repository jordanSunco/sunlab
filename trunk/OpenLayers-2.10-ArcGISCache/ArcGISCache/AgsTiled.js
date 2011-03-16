/**
 * @requires OpenLayers/Layer/Grid.js
 * @requires OpenLayers/Tile/Image.js
 */

/**
 * Class: OpenLayers.Layer.AgsTiled
 * 
 * Inherits from:
 *  - <OpenLayers.Layer.Grid>
 */
OpenLayers.Layer.AgsTiled = OpenLayers.Class(OpenLayers.Layer.Grid, {
    
    /**
     * APIProperty: isBaseLayer
     * {Boolean}
     */
    isBaseLayer: true,

    /**
     * APIProperty: tileOrigin
     * {<OpenLayers.Pixel>}
     */
    tileOrigin: null,
    
    /**
     * APIProperty: tileFullExtent
     * {<OpenLayers.Bounds>}
     */
    tileFullExtent: null,

	/**
     * APIProperty: tileFormat
     * {String}
     */
    tileFormat: "",
	
    /**
     * Constructor: OpenLayers.Layer.AgsTiled
     * 
     * Parameters:
     * name - {String}
     * url - {String}
     * options - {Object} Hashtable of extra options to tag onto the layer
     */
    initialize: function(name, url, options) {
        // initialize OpenLayers.Layer.Grid layer
        OpenLayers.Layer.Grid.prototype.initialize.apply(this, [name, url, {}, options]);    	
    	// some utility methods
    	this._isDefined = OpenLayers.Util.AgsUtil.isDefined;		
    	// 'tileFormat'
    	if(this._isDefined(options['tileFormat'])) {
    		this.tileFormat = options['tileFormat'];
    	} else {
    		OpenLayers.Console.error("...tileFormat missing or empty...");
     		throw "...tileFormat missing or empty...";	
    	}   	
    	// 'tileFullExtent'
    	if(this._isDefined(options['tileFullExtent']) && options['tileFullExtent'] instanceof OpenLayers.Bounds) {
    		this.tileFullExtent = options['tileFullExtent'];
    	}     	
    	// 'tileOrigin'
    	if(this._isDefined(options['tileOrigin']) && options['tileOrigin'] instanceof OpenLayers.Pixel) {
    		this.tileOrigin = options['tileOrigin'];
    	}
    },    

    /**
     * APIMethod:destroy
     */
    destroy: function() {
        // for now, nothing special to do here. 
        OpenLayers.Layer.Grid.prototype.destroy.apply(this, arguments);  
    },

    
    /**
     * APIMethod: clone
     * 
     * Parameters:
     * obj - {Object}
     * 
     * Returns:
     * {<OpenLayers.Layer.AgsTiled>} An exact clone of this <OpenLayers.Layer.AgsTiled>
     */
    clone: function (obj) {        
        if (obj == null) {
            obj = new OpenLayers.Layer.AgsTiled(this.name, this.url, this.options);
        }
        //get all additions from superclasses
        obj = OpenLayers.Layer.Grid.prototype.clone.apply(this, [obj]);
        // copy/set any non-init, non-simple values here
        return obj;
    },    
    
    /**
     * Method: getURL
     * 
     * Parameters:
     * bounds - {<OpenLayers.Bounds>}
     * 
     * Returns:
     * {String} A string with the layer's url and parameters and also the 
     *          passed-in bounds and appropriate tile size specified as 
     *          parameters
     */
    getURL: function (bounds) {
        bounds = this.adjustBounds(bounds);
        
        var res = this.map.getResolution();
        
        var path = null;
        var url = null;
        
        if(this.tileFullExtent.intersectsBounds(bounds)) {
	        var col = null;
	        if(this.tileOrigin.lon <= bounds.left) {
	        	col = Math.round((bounds.left - this.tileOrigin.lon) / (res * this.tileSize.w));
	        } else if(this.tileOrigin.lon >= bounds.right) {
	        	col = Math.round((this.tileOrigin.lon - bounds.right) / (res * this.tileSize.w));
	        } else {
	        	return "";
	        	//return "../../img/transparent.png";
	        	OpenLayers.Console.warn("...invalid tileOrigin...");
     			//throw "...invalid tileOrigin...";	
	        }                
	        var row = null;
	        if(this.tileOrigin.lat >= bounds.top) {
	        	row = Math.round((this.tileOrigin.lat - bounds.top) / (res * this.tileSize.h));
	        } else if(this.tileOrigin.lat <= bounds.bottom) {
	        	row = Math.round((bounds.bottom - this.tileOrigin.lat) / (res * this.tileSize.h));
	        } else {
	        	return "";
	        	//return "../../img/transparent.png";
	        	OpenLayers.Console.warn("...invalid tileOrigin...");
     			//throw "...invalid tileOrigin...";
	        }        
	        var scale = this.map.getZoom();         
	        path = scale + "/" + row + "/" + col + "." + this.tileFormat;
	    	url = this.url;
	        if (url instanceof Array) {
	            url = this.selectUrl(path, url);
	        }
	        return url + path;
	    } else {
	    	// area outside of tiles' full extent
	    	return "";
	    	//return "../../img/transparent.png";	    	
	    }        
    },

    /**
     * Method: addTile
     * addTile creates a tile, initializes it, and adds it to the layer div. 
     * 
     * Parameters:
     * bounds - {<OpenLayers.Bounds>}
     * position - {<OpenLayers.Pixel>}
     * 
     * Returns:
     * {<OpenLayers.Tile.Image>} The added OpenLayers.Tile.Image
     */
    addTile:function(bounds,position) {
        return new OpenLayers.Tile.Image(this, position, bounds, 
                                         null, this.tileSize);
    },

    /** 
     * APIMethod: setMap
     * When the layer is added to a map, then we can fetch our origin 
     *    (if we don't have one.) 
     * 
     * Parameters:
     * map - {<OpenLayers.Map>}
     */
    setMap: function(map) {
        OpenLayers.Layer.Grid.prototype.setMap.apply(this, arguments);
        if(!this.tileOrigin) { 
            this.tileOrigin = new OpenLayers.LonLat(this.map.maxExtent.left,
                                                this.map.maxExtent.bottom);
        }   
        if(!this.tileFullExtent) { 
            this.tileFullExtent = this.map.maxExtent;
        }                             
    },

    CLASS_NAME: "OpenLayers.Layer.AgsTiled"
});

OpenLayers.Util.AgsUtil = (function() {
	return function() {}
})();

OpenLayers.Util.AgsUtil.isDefined = function(value) {
	if (value === undefined || value === null || value === "") {
		return false;
	}
	else {
		return true;
    }
};

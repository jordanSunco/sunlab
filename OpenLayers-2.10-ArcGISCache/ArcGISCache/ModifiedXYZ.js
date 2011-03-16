OpenLayers.Layer.XYZ.Modified = OpenLayers.Class(OpenLayers.Layer.XYZ, {
    getURL: function (bounds) {
        var res = this.map.getResolution();
        var x = Math.round((bounds.left - this.tileOrigin.lon) 
            / (res * this.tileSize.w));
        var y = Math.round((this.tileOrigin.lat - bounds.top) 
            / (res * this.tileSize.h));
        var z = this.map.getZoom();

        var url = this.url;
        var s = '' + x + y + z;
        if (url instanceof Array)
        {
            url = this.selectUrl(s, url);
        }
        
        var path = OpenLayers.String.format(url, {'x': x, 'y': y, 'z': z});

        return path;
    },
    calculateGridLayout: function(bounds, extent, resolution) {
        var tilelon = resolution * this.tileSize.w;
        var tilelat = resolution * this.tileSize.h;
        
        var offsetlon = bounds.left - this.tileOrigin.lon;
        var tilecol = Math.floor(offsetlon/tilelon) - this.buffer;
        var tilecolremain = offsetlon/tilelon - tilecol;
        var tileoffsetx = -tilecolremain * this.tileSize.w;
        var tileoffsetlon = this.tileOrigin.lon + tilecol * tilelon;
        
        var offsetlat = this.tileOrigin.lat - bounds.top + tilelat; 
        var tilerow = Math.floor(offsetlat/tilelat) - this.buffer;
        var tilerowremain = tilerow - offsetlat/tilelat;
        var tileoffsety = tilerowremain * this.tileSize.h;
        var tileoffsetlat = this.tileOrigin.lat - tilelat*tilerow;
        
        return { 
          tilelon: tilelon, tilelat: tilelat,
          tileoffsetlon: tileoffsetlon, tileoffsetlat: tileoffsetlat,
          tileoffsetx: tileoffsetx, tileoffsety: tileoffsety
        };
    },

    CLASS_NAME: "OpenLayers.Layer.XYZ.Modified"
});

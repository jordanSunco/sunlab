OpenLayers.Layer.XYZ.Modified = OpenLayers.Class(OpenLayers.Layer.XYZ, {
    /**
     * ����һЩ��Ƭ�Ǹ���tile origin����max extent�������.
     * ���ֻ����tileOrigin�滻maxExtent����.
     * With gridded tile systems, sometimes the tile origin is far from the actual maxExtent of the data.
     * For example, when a "google-like" tiling scheme is used with local data.
     * This type of setup is also common with ESRI tile caches.
     */
    getXYZ: function(bounds) {
        var res = this.map.getResolution();
        var x = Math.round((bounds.left - this.tileOrigin.lon)
            / (res * this.tileSize.w));
        var y = Math.round((this.tileOrigin.lat - bounds.top)
            / (res * this.tileSize.h));
        var z = this.serverResolutions != null ?
            OpenLayers.Util.indexOf(this.serverResolutions, res) :
            this.map.getZoom() + this.zoomOffset;

        return {'x': x, 'y': y, 'z': z};
    },

    /**
     * �����°汾(trunk/openlayers)��, �Ѿ�������ȡ��getURL��λ�ȡx, y, z���߼�,
     * ����ֻ����дgetXYZ����, ����ֻ�ǽ����°��getURL�հ����, û�н�����չ.
     * 
     * TODO ��˵��°汾�в���getXYZ��, ����Ҫ��д�˷���, ֻ��Ҫ��дgetXYZ
     */
    getURL: function (bounds) {
        var xyz = this.getXYZ(bounds);
        var url = this.url;
        if (url instanceof Array) {
            var s = '' + xyz.x + xyz.y + xyz.z;
            url = this.selectUrl(s, url);
        }

        return OpenLayers.String.format(url, xyz);
    },

    /**
     * �����°汾(trunk/openlayers)��, �Ѿ������޸���initGriddedTiles��λ�ȡorigin���߼�.
     * ��ǰ(2.10)��ֱ�ӻ��maxExtent, �ټ���calculateGridLayout(bounds, extent, resolution),
     * ���originͨ��һ��getTileOrigin����ȡ, �ж���tileOrigin�򷵻�tileOrigin,
     * �������maxExtent�������origin, �ټ���calculateGridLayout(bounds, origin, resolution).
     * 
     * TODO ��˵��°汾�в���getTileOrigin��, ����Ҫ��д�˷���
     */
    calculateGridLayout: function(bounds, extent, resolution) {
        var tilelon = resolution * this.tileSize.w;
        var tilelat = resolution * this.tileSize.h;

        var offsetlon = bounds.left - this.tileOrigin.lon;
        var tilecol = Math.floor(offsetlon/tilelon) - this.buffer;
        var tilecolremain = offsetlon/tilelon - tilecol;
        var tileoffsetx = -tilecolremain * this.tileSize.w;
        var tileoffsetlon = this.tileOrigin.lon + tilecol * tilelon;

        var offsetlat = bounds.top - (this.tileOrigin.lat + tilelat);
        var tilerow = Math.ceil(offsetlat/tilelat) + this.buffer;
        var tilerowremain = tilerow - offsetlat/tilelat;
        var tileoffsety = -tilerowremain * this.tileSize.h;
        var tileoffsetlat = this.tileOrigin.lat + tilerow * tilelat;

        return {
          tilelon: tilelon, tilelat: tilelat,
          tileoffsetlon: tileoffsetlon, tileoffsetlat: tileoffsetlat,
          tileoffsetx: tileoffsetx, tileoffsety: tileoffsety
        };
    },

    CLASS_NAME: "OpenLayers.Layer.XYZ.Modified"
});

package org.openscales.core.layer {
    import mx.utils.ArrayUtil;
    
    import org.openscales.core.StringUtils;
    import org.openscales.core.tile.ImageTile;
    import org.openscales.geometry.basetypes.Bounds;
    import org.openscales.geometry.basetypes.Pixel;
    import org.openscales.geometry.basetypes.Size;

    /**
     * The XYZ class is designed to make it easier for people who have tiles
     * arranged by a standard XYZ grid.
     * 
     * @author Sun
     * @see OpenLayers.Layer.XYZ
     */
    public class XYZ extends Grid {
        public function XYZ(name:String, url:String) {
            super(name, url);
        }

        override public function addTile(bounds:Bounds, position:Pixel):ImageTile {
            return new ImageTile(this, position, bounds, this.getURL(bounds),
                new Size(this.tileWidth, this.tileHeight));
        }

        /**
         * 
         * @param bounds
         * @return A string with the layer's url and parameters and also the
         *     passed-in bounds and appropriate tile size specified as parameters
         * @see OpenLayers.Layer.XYZ.getURL
         */
        override public function getURL(bounds:Bounds):String {
            var xyz:Object = getXYZ(bounds);
            var url:String = this.url;

            if (this.altUrls != null) {
                var s:String = '' + xyz.x + xyz.y + xyz.z;
                url = selectUrl(s, this.altUrls);
            }

            return StringUtils.format(url, xyz);
        }

        /**
         * Calculates x, y and z for the given bounds.
         * 
         * @param bounds
         * @return an object with x, y and z properties.
         * @see OpenLayers.Layer.XYZ.getXYZ
         */
        public function getXYZ(bounds:Bounds):Object {
            var res:Number = this.map.resolution;
            var x:Number = Math.round((bounds.left - this.maxExtent.left)
                / (res * tileWidth));
            var y:Number = Math.round((this.maxExtent.top - bounds.top)
                / (res * tileHeight));
            var z:Number = this.resolutions != null ?
                ArrayUtil.getItemIndex(res, this.resolutions) :
                this.map.zoom;

            return {"x": x, "y": y, "z": z};
        }
    }
}

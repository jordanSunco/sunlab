package org.openscales.ext.layer {
    import mx.utils.ArrayUtil;
    
    import org.openscales.core.layer.XYZ;
    import org.openscales.geometry.basetypes.Bounds;

    /**
     * 读取以TileOrigin(瓦片原点)来切图的瓦片图片服务, 做为静态地图服务.
     * 例如ArcGIS Server就是以TileOrigin来切片的.
     * 
     * @author Sun
     * @see http://trac.osgeo.org/openlayers/ticket/2741 Support Tile/Grid Extent in all Layers
     * @see http://virgos.javaeye.com/blog/546952 深入理解ArcGIS Server的切图原理
     */
    public class TileOriginCache extends XYZ {
        public function TileOriginCache(name:String, url:String) {
            super(name, url);
        }

        /**
         * 通过<code>tileOrigin</code>而非<code>maxExtent</code>来计算XYZ
         */
        override public function getXYZ(bounds:Bounds):Object {
            var res:Number = this.map.resolution;
            var x:Number = Math.round((bounds.left - this.tileOrigin.lon)
                / (res * tileWidth));
            var y:Number = Math.round((this.tileOrigin.lat - bounds.top)
                / (res * tileHeight));
            var z:Number = this.resolutions != null ?
                ArrayUtil.getItemIndex(res, this.resolutions) :
                this.map.zoom;

            return {"x": x, "y": y, "z": z};
        }
    }
}

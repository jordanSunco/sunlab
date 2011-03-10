package com.modestmaps.mapproviders {
    import com.modestmaps.core.Coordinate;

    /**
     * 将ArcGIS Server发布的地图服务(TiledMapService)作为basemap(直接读取XYZ瓦片图片).
     * 在flexmappers的基础上扩展
     * 1. 以参数形式配置ArcGIS地图服务地址
     * 2. 修改瓦片大小为512 * 512
     * 
     * @TODO 目前只能获取http://server.arcgisonline.com/ArcGIS/rest/services/ESRI_Imagery_World_2D/MapServer的瓦片
     * 
     * @author flexmappers, Sun
     * @see http://flexmappers.blogspot.com/2009/06/modest-maps-and-arcgis.html
     */
    public class EsriMapProvider extends AbstractMapProvider
            implements IMapProvider {
        private static const TILE_PATH:String = "/tile/";

        private var tileBaseUrl:String;

        /**
         * @param url ArcGIS Server发布的地图服务地址, 例如http://server.arcgisonline.com/ArcGIS/rest/services/ESRI_Imagery_World_2D/MapServer
         * @param minZoom
         * @param maxZoom
         */
        public function EsriMapProvider(url:String, minZoom:int=MIN_ZOOM,
                maxZoom:int=MAX_ZOOM) {
            super(minZoom, maxZoom);
            tileBaseUrl = url + TILE_PATH;
        }

        public function getTileUrls(coord:Coordinate):Array {
            return [tileBaseUrl + getZoomString(coord)];
        }

        protected function getZoomString(coord:Coordinate):String {
            var sourceCoord:Coordinate = sourceCoordinate(coord);
            return sourceCoord.zoom + "/" + sourceCoord.row + "/" + sourceCoord.column;
        }

        override public function sourceCoordinate(coord:Coordinate):Coordinate {
            var tilesWide:int = Math.pow(2, coord.zoom + 1);
            var wrappedColumn:Number = coord.column % tilesWide;

            while (wrappedColumn < 0) {
                wrappedColumn += tilesWide;
            }

            return new Coordinate(coord.row, wrappedColumn, coord.zoom);
        }

        override public function get tileWidth():Number {
            return 512;
        }

        override public function get tileHeight():Number {
            return 512;
        }

        public function toString():String {
            return "ESRI";
        }
    }
}

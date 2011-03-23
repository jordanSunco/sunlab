import mx.core.UIComponent;
import mx.events.FlexEvent;
import mx.rpc.events.ResultEvent;

import org.openscales.core.Map;
import org.openscales.core.control.LayerManager;
import org.openscales.core.control.PanZoom;
import org.openscales.core.events.FeatureEvent;
import org.openscales.core.feature.Feature;
import org.openscales.core.format.WKTFormat;
import org.openscales.core.handler.feature.SelectFeaturesHandler;
import org.openscales.core.handler.mouse.DragHandler;
import org.openscales.core.handler.mouse.WheelHandler;
import org.openscales.core.layer.FeatureLayer;
import org.openscales.core.layer.ogc.WFS;
import org.openscales.core.layer.ogc.WMS;
import org.openscales.core.popup.Anchored;
import org.openscales.core.style.Style;
import org.openscales.ext.layer.TileOriginCache;
import org.openscales.geometry.basetypes.Bounds;
import org.openscales.geometry.basetypes.Location;

private var arcgisTileCacheBaseUrl:String = "http://192.168.200.58:8399/arcgis/rest/services/HeNan512/MapServer/tile/${z}/${y}/${x}";
// arcgis server 9.3.1 发布的WMS服务是1.0.0版, styles参数是必须的, 直接添加到URL中
// geoserver 发布的WMS服务是1.1.1版, styles参数是可选的
private var arcgisWmsUrl:String = "http://192.168.200.102:8399/arcgis/services/tmpbsarea/MapServer/WMSServer?styles=";
private var arcgisWfsUrl:String = "http://192.168.200.102:8399/arcgis/services/wgyw/MapServer/WFSServer";

private var map:Map;
private var featureLayer:FeatureLayer;
private var popup:Anchored;

private function init():void {
    var mapContainer:UIComponent = new UIComponent();
    mapContainer.percentWidth = 100;
    mapContainer.percentHeight = 100;
    mapContainer.addEventListener(FlexEvent.CREATION_COMPLETE, initMap);
    addElement(mapContainer);
}

private function initMap(event:FlexEvent):void {
    var ui:UIComponent = event.target as UIComponent;

    map = new Map(ui.width, ui.height);
    map.addEventListener(FeatureEvent.FEATURE_CLICK, onFeatureClick);

    new DragHandler(map);
    new WheelHandler(map);
    new SelectFeaturesHandler(map);

    map.addControl(new PanZoom());
    map.addControl(new LayerManager());

    addBasemap();
    addWms();
    // TODO 换用1.2.1版本后, 加载WFS图层报错, 经测试只是公司的服务报错, 使用OpenScales的WFS没有问题
    // 元素类型“FeatureCollection”必须以匹配的结束标记“</FeatureCollection>”结束。
    // org\openscales\core\format\GMLFormat.as:143]
//    addWfs();
    addFeatureLayer();
    testSpatialAnalysis();

    ui.addChild(map);
}

private function addFeatureLayer():void {
    // 展现要素的临时图层
    featureLayer = new FeatureLayer("临时图层");
    featureLayer.style = Style.getDefaultSurfaceStyle();
    map.addLayer(featureLayer, false, true);
}

private function testSpatialAnalysis():void {
    // 读写WKT
    var wktf:WKTFormat = new WKTFormat();

    var polygonFeature1:Feature = wktf.read("Polygon((111.33 33, 112.55 33.40, 112.55 32.90, 111.33 33))") as Feature;
    polygonFeature1.attributes = {
        a: "要素属性值1",
        b: "要素属性值2"
    };
    polygonFeature1.style = Style.getDrawSurfaceStyle();

    var polygonFeature2:Feature = wktf.read("Polygon((112.11 33, 112.55 32.55, 113.22 32.90, 112.11 33))") as Feature;

    featureLayer.addFeature(polygonFeature1);
    featureLayer.addFeature(polygonFeature2);

    // FIXME WKT读取GEOMETRYCOLLECTION格式错误.
    // PS: 可以成功写入
    // trace(new WKTFormat().write([lineFeature, pointFeature]));
    // new WKTFormat().read("GEOMETRYCOLLECTION(LINESTRING(111.11 33,112.22 33),POINT(113.11 33))");
}

/**
 * 在点击WFS上的要素时, 在地图上打开窗口展现要素的属性信息
 */
private function onFeatureClick(event:FeatureEvent):void {
    if(popup) {
        popup.destroy();
    }
    popup = new Anchored();
    popup.feature = event.feature;
    var content:String = "";
    for (var p:String in popup.feature.attributes) {
        content = content + p + " = " + popup.feature.attributes[p] + "\n";
    }
    popup.htmlText = content;
    map.addPopup(popup, true);
}

/**
 * 读取瓦片做为底图
 */
private function addBasemap():void {
    var arcgisTileCache:TileOriginCache = new TileOriginCache("ArcGIS瓦片图层",
        arcgisTileCacheBaseUrl);

    // 获取ArcGIS瓦片必须的计算项
    // 1. 瓦片的宽高
    // 2. 切片的原点
    // 3. 切片每一层的resolution(一个像素所占的地图单位长度)
    // http://virgos.javaeye.com/blog/546952
    arcgisTileCache.tileWidth = 512;
    arcgisTileCache.tileHeight = 512;
    arcgisTileCache.tileOrigin = new Location(-400, 400);
    arcgisTileCache.resolutions = [
        0.009517844023321119,
        0.0019035688046642235,
        9.517844023321118E-4,
        4.758922011660559E-4,
        2.3794610058302794E-4,
        1.1897305029151397E-4,
        4.758922011660559E-5,
        2.3794610058302794E-5,
        1.1897305029151397E-5
    ];
    arcgisTileCache.maxExtent = new Bounds(110.03976754966028, 31.135256049990446,
        116.96302345001618, 36.61552095020106);

    map.addLayer(arcgisTileCache, true);
}

/**
 * WMS图层是通过GetMap操作得到一整张支持透明的图片叠加到basemap上
 */
private function addWms():void {
    var wms:WMS = new WMS("ArcGIS WMS业务图层", arcgisWmsUrl, "0");
    // 告诉WMS输出支持透明的图片格式来进行图层叠加, 这种机制可以成功叠加图层, 但会遮盖底图.
    // 因为没有办法预先调整透明度(如让WMS输出50%透明度的图层), 需要通过SLD来调整图层样式.
    wms.params["transparent"] = true;
    wms.params["format"] = "image/png";

    // 通过Flex原生的透明度机制来进行图层叠加, 可以达到预先图层透明的效果
    // 同时采用2种透明支持展现效果最好
    // 如果只采用Flex原生的透明, 会有蒙板的感觉, 有点模糊不清
    wms.alpha = 0.5;

    map.addLayer(wms, false, true);
}

/**
 * WFS图层是通过GetFeature操作获取的所有要素信息, 在前端绘制的.
 * 因为没有进行Filter Encoding过滤, 如果数据量过大会造成前端卡死.
 */
private function addWfs():void {
    var wfs:WFS = new WFS("ArcGIS WFS要素图层", arcgisWfsUrl, "baseStationSector");
//    var wfs:WFS = new WFS("wfs", "http://openscales.org/geoserver/wfs", "topp:states");
    wfs.style = Style.getDefaultSurfaceStyle();

    map.addLayer(wfs, false, true);
}

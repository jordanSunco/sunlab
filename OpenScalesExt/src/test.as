import mx.core.UIComponent;
import mx.events.FlexEvent;

import org.openscales.core.Map;
import org.openscales.core.control.LayerManager;
import org.openscales.core.control.PanZoom;
import org.openscales.core.events.FeatureEvent;
import org.openscales.core.handler.feature.SelectFeaturesHandler;
import org.openscales.core.handler.mouse.DragHandler;
import org.openscales.core.handler.mouse.WheelHandler;
import org.openscales.core.layer.ogc.WFS;
import org.openscales.core.layer.ogc.WMS;
import org.openscales.core.popup.Anchored;
import org.openscales.core.style.Style;
import org.openscales.ext.layer.TileOriginCache;
import org.openscales.geometry.basetypes.Bounds;
import org.openscales.geometry.basetypes.Location;

private var arcGISCacheBaseUrl:String = "http://192.168.200.102:8399/arcgis/rest/services/henjichu/MapServer/tile/${z}/${y}/${x}";
// styles参数是必须的, 直接添加到URL中
private var arcGISWms:String = "http://192.168.200.102:8399/arcgis/services/tmpbsarea/MapServer/WMSServer?styles=";
private var arcGISWfs:String = "http://192.168.200.102:8399/arcgis/services/wgyw/MapServer/WFSServer";

private var map:Map;
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

    ui.addChild(map);
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
    var arcgisCache:TileOriginCache = new TileOriginCache("ArcGISCache", arcGISCacheBaseUrl);

    // 获取ArcGIS瓦片必须的计算项
    // 1. 瓦片的宽高
    // 2. 切片的原点
    // 3. 切片每一层的resolution(一个像素所占的地图单位长度)
    // http://virgos.javaeye.com/blog/546952
    arcgisCache.tileWidth = 512;
    arcgisCache.tileHeight = 512;
    arcgisCache.tileOrigin = new Location(-400, 400);
    arcgisCache.resolutions = [
        0.006583916254990255,
        0.0016459802534780667,
        8.229889370085304E-4,
        4.114944685042652E-4,
        1.028736171260663E-4,
        2.571959401201949E-5,
        1.2858607275506831E-5,
        6.4293036377534154E-6,
        8.351908130464281E-7
    ];
    arcgisCache.maxExtent = new Bounds(110.03992934964583,31.134783400499995,
        116.9596256503196,36.6254465895);

    map.addLayer(arcgisCache, true);
}

/**
 * WMS图层是通过GetMap操作得到一整张支持透明的图片叠加到basemap上
 */
private function addWms():void {
    var wms:WMS = new WMS("arcGISWms", arcGISWms, "0");
    // 必须透明才能完成叠加
    wms.params["transparent"] = true;
    wms.params["format"] = "image/png";

    map.addLayer(wms, false, true);
}

/**
 * WFS图层是通过GetFeature操作获取的所有要素信息, 在前端绘制的.
 * 因为没有进行Filter Encoding过滤, 如果数据量过大会造成前端卡死.
 */
private function addWfs():void {
    var wfs:WFS = new WFS("arcGISWfs", arcGISWfs, "baseStationSector");
//    var wfs:WFS = new WFS("arcGISWfs", "http://openscales.org/geoserver/wfs", "topp:states");
    wfs.style = Style.getDefaultSurfaceStyle();

    map.addLayer(wfs, true, true);
}

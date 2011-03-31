import flash.events.Event;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.URLVariables;

import mx.core.UIComponent;
import mx.events.FlexEvent;

import org.openscales.core.Map;
import org.openscales.core.basetypes.maps.HashMap;
import org.openscales.core.control.LayerManager;
import org.openscales.core.control.PanZoom;
import org.openscales.core.events.FeatureEvent;
import org.openscales.core.feature.Feature;
import org.openscales.core.format.GMLFormat;
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
private var arcgisWmsUrl:String = "http://192.168.200.58:8399/arcgis/services/tmpbsarea/MapServer/WMSServer?styles=";
private var arcgisWfsUrl:String = "http://192.168.200.58:8399/arcgis/services/testwfs/MapServer/WFSServer";

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
    addWfs();
    addFeatureLayer();
    testSpatialAnalysis();
//    testWfsFilterByHttpGet();
    testWfsFilterByHttpPost();
    testGeoserverWfsFilter();

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
//     trace(new WKTFormat().write([lineFeature, pointFeature]));
//     new WKTFormat().read("GEOMETRYCOLLECTION(LINESTRING(111.11 33,112.22 33),POINT(113.11 33))");
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
    var wfs:WFS = new WFS("ArcGIS WFS要素图层", arcgisWfsUrl, "restaurant");
    wfs.style = Style.getDefaultPointStyle();

    map.addLayer(wfs, false, true);
}

private function testWfsFilterByHttpGet():void {
    var filter:String = "<Filter xmlns='http://www.opengis.net/ogc'><PropertyIsGreaterThan><PropertyName>FID</PropertyName><Literal>189</Literal></PropertyIsGreaterThan></Filter>";

    var urlRequest:URLRequest = new URLRequest(arcgisWfsUrl);
    // 必须指定为1.0.0版本的WFS服务, 否则能得到feature但不能显示feature
    var params:URLVariables = new URLVariables("service=wfs&version=1.0.0&request=getFeature&typeName=restaurant&filter=" + filter);
    urlRequest.data = params;

    loadWfsGml(urlRequest);
}

private function testWfsFilterByHttpPost():void {
    var getFeatureXml:XML =
        <wfs:GetFeature xmlns:wfs="http://www.opengis.net/wfs"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xsi:schemaLocation="http://www.opengis.net/wfs http://schemas.opengis.net/wfs/1.0.0/WFS-transaction.xsd"
                service="WFS" version="1.0.0">
            <wfs:Query typeName="testwfs:restaurant" xmlns:testwfs="http://localhost/arcgis/services/testwfs/MapServer/WFSServer">
                <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
                    <ogc:PropertyIsGreaterThan>
                        <ogc:PropertyName>FID</ogc:PropertyName>
                        <ogc:Literal>189</ogc:Literal>
                    </ogc:PropertyIsGreaterThan>
                </ogc:Filter>
            </wfs:Query>
        </wfs:GetFeature>;

    var urlRequest:URLRequest = new URLRequest(arcgisWfsUrl);
    urlRequest.method = URLRequestMethod.POST;
    urlRequest.contentType = "text/xml";
    urlRequest.data = getFeatureXml.toXMLString();

    loadWfsGml(urlRequest);
}

private function testGeoserverWfsFilter():void {
    var getFeatureXml:XML =
        <wfs:GetFeature xmlns:wfs="http://www.opengis.net/wfs"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xsi:schemaLocation="http://www.opengis.net/wfs http://schemas.opengis.net/wfs/1.0.0/WFS-transaction.xsd"
                service="WFS" version="1.0.0">
            <wfs:Query typeName="za:za_natural" xmlns:za="http://opengeo.org/za">
                <ogc:Filter xmlns:ogc="http://www.opengis.net/ogc">
                    <ogc:Or>
                        <ogc:PropertyIsEqualTo>
                            <ogc:PropertyName>name</ogc:PropertyName>
                            <ogc:Literal>Alexandra Reservoir</ogc:Literal>
                        </ogc:PropertyIsEqualTo>
                        <ogc:PropertyIsEqualTo>
                            <ogc:PropertyName>name</ogc:PropertyName>
                            <ogc:Literal>Beervlei Dam</ogc:Literal>
                        </ogc:PropertyIsEqualTo>
                    </ogc:Or>
                </ogc:Filter>
            </wfs:Query>
        </wfs:GetFeature>;

    var urlRequest:URLRequest = new URLRequest("http://demo.opengeo.org/geoserver/wfs");
    urlRequest.method = URLRequestMethod.POST;
    urlRequest.contentType = "text/xml";
    urlRequest.data = getFeatureXml.toXMLString();

    loadWfsGml(urlRequest);
}

private function loadWfsGml(urlRequest:URLRequest):void {
    var urlLoader:URLLoader = new URLLoader();
    urlLoader.load(urlRequest);
    urlLoader.addEventListener(Event.COMPLETE, function (event:Event):void {
        var gml:GMLFormat = new GMLFormat(addFeature, new HashMap());
        gml.read(urlLoader.data);
    });
}

private function addFeature(feature:Feature, dispatchFeatureEvent:Boolean=true,
        reproject:Boolean=true):void {
    // TODO 通过GMLFormat读取ArcGIS Server WFS的GML数据, 能够正常读取到每一个feature,
    // 但是不管有多少个feature, 只有第一个feature能够加入到featureLayer中.
    // 使用org.openscales.core.layer.ogc.WFS来叠加ArcGIS Server WFS也是一样的,
    // 在地图只会展现一个feature.
    // 测试geoserver WFS没有这种问题, 莫非是返回的GML数据有微妙的差别?
    // XXX 通过clone的方式, 可以正常显示所有feature, 但attributes全部丢失, 需复制过去
//    var f:Feature = feature.clone();
//    f.attributes = feature.attributes;
//    f.style = Style.getDefaultPointStyle();
//    featureLayer.addFeature(f);
    feature.style = Style.getDefaultPointStyle();
    featureLayer.addFeature(feature);
    trace(feature, featureLayer.features.length);
}

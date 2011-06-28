import mx.core.UIComponent;
import mx.events.FlexEvent;

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
import org.openscales.core.popup.Anchored;
import org.openscales.core.style.Style;
import org.openscales.core.style.symbolizer.LineSymbolizer;

private var map:Map;
/**
 * 展现要素的临时图层
 */
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

    addFeatureLayer();
    testWkt();

    ui.addChild(map);
}

/**
 * 在点击地图上的Feature时, 在地图上打开窗口展现要素的属性信息
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

private function addFeatureLayer():void {
    featureLayer = new FeatureLayer("临时图层");
    featureLayer.style = Style.getDefaultSurfaceStyle();
    map.addLayer(featureLayer, false, true);
}

/**
 * 测试WKT数据格式
 * 
 * @see http://en.wikipedia.org/wiki/Well-known_text
 */
private function testWkt():void {
    var wktFormat:WKTFormat = new WKTFormat();
    var wkt:String = "POINT (30 10)";
    var feature:Feature = wktFormat.read(wkt) as Feature;
    feature.attributes = {wkt: wkt};
    feature.style = Style.getDefaultPointStyle();
    featureLayer.addFeature(feature);
    
    // FIXME WKTFormat解析不了MULTIPOINT
//    wkt = "MULTIPOINT ((10 40), (40 30), (20 20), (30 10))";
//    wkt = "MULTIPOINT (10 40, 40 30, 20 20, 30 10)";
//    feature = wktFormat.read(wkt) as Feature;
//    feature.attributes = {wkt: wkt};
//    featureLayer.addFeature(feature);

    // wkt = "LINESTRING (35 15, 15 35, 45 45)";
    // MULTILINESTRING可以表示只有一条线
    wkt = "MULTILINESTRING ((35 15, 15 35, 45 45))";
    feature = wktFormat.read(wkt) as Feature;
    feature.attributes = {wkt: wkt};
    feature.style = Style.getDefaultLineStyle();
    featureLayer.addFeature(feature);

    // 多条线
    wkt = "MULTILINESTRING ("
        + "(90 20, 100 30, 90 50),"
        + "(120 50, 110 40, 120 30, 110 20)"
    + ")";
    feature = wktFormat.read(wkt) as Feature;
    feature.attributes = {wkt: wkt};
    feature.style = Style.getDefaultLineStyle();
    // 修改样式突出MULTILINESTRING中的2条线是一体的
    (feature.style.rules[0].symbolizers[0] as LineSymbolizer).stroke.color = 0xfff;
    featureLayer.addFeature(feature);

    // 一个普通多边形, 注意起点终点必须保持一致
    wkt = "POLYGON ((65 45, 45 55, 55 75, 75 75, 65 45))";
    feature = wktFormat.read(wkt) as Feature;
    feature.attributes = {wkt: wkt};
    featureLayer.addFeature(feature);

    // 使用POLYGON也可以构造任意个多边形, 不管是普通的还是有内环的
    // POLYGON表示有1个有内环的多边形
    // wkt = "POLYGON ((95 70, 70 80, 75 100, 105 105, 95 70), (80 90, 95 95, 90 80, 80 90))";
    // POLYGON表示2个没有关系的多边形
    // wkt = "POLYGON ((135 125, 115 145, 150 145, 135 125), (120 110, 145 115, 115 125, 110 115, 120 110))";
    // POLYGON表示1个普通多边形和1个有内环的多边形
    wkt = "POLYGON ("
        + "(180 180, 160 185, 185 170, 180 180),"
        + "(160 175, 185 160, 170 145, 150 150, 150 170, 160 175),"
        + "(170 160, 160 165, 160 155, 170 160)"
    + ")";
    feature = wktFormat.read(wkt) as Feature;
    feature.attributes = {wkt: wkt};
    feature.style = Style.getDrawSurfaceStyle();
    featureLayer.addFeature(feature);

    // 2个没有关系的多边形, POLYGON可以构造, 暂时不需要
//    wkt = "MULTIPOLYGON (((135 125, 115 145, 150 145, 135 125)), ((120 110, 145 115, 115 125, 110 115, 120 110)))";
//    feature = wktFormat.read(wkt) as Feature;
//    feature.attributes = {wkt: wkt};
//    feature.style = Style.getDefaultSurfaceStyle();
//    (feature.style.rules[0].symbolizers[0] as PolygonSymbolizer).stroke.color = 0xf0f;
//    featureLayer.addFeature(feature);
    // 1个普通多边形和1个有内环的多边形, POLYGON可以构造, 暂时不需要
//    wkt = "MULTIPOLYGON (((180 180, 160 185, 185 170, 180 180)), ((160 175, 185 160, 170 145, 150 150, 150 170, 160 175), (170 160, 160 165, 160 155, 170 160)))";
//    feature = wktFormat.read(wkt) as Feature;
//    feature.attributes = {wkt: wkt};
//    feature.style = Style.getDefaultSurfaceStyle();
//    (feature.style.rules[0].symbolizers[0] as PolygonSymbolizer).stroke.color = 0xff00ff;
//    featureLayer.addFeature(feature);
}

import mx.core.UIComponent;
import mx.events.FlexEvent;

import org.openscales.core.Map;
import org.openscales.core.control.LayerManager;
import org.openscales.core.control.PanZoom;
import org.openscales.core.events.FeatureEvent;
import org.openscales.core.feature.Feature;
import org.openscales.core.feature.LineStringFeature;
import org.openscales.core.feature.MultiLineStringFeature;
import org.openscales.core.feature.MultiPointFeature;
import org.openscales.core.feature.MultiPolygonFeature;
import org.openscales.core.feature.PointFeature;
import org.openscales.core.feature.PolygonFeature;
import org.openscales.core.handler.feature.SelectFeaturesHandler;
import org.openscales.core.handler.mouse.DragHandler;
import org.openscales.core.handler.mouse.WheelHandler;
import org.openscales.core.layer.FeatureLayer;
import org.openscales.core.popup.Anchored;
import org.openscales.core.style.Style;
import org.openscales.core.style.marker.WellKnownMarker;
import org.openscales.core.style.symbolizer.LineSymbolizer;
import org.openscales.core.style.symbolizer.PointSymbolizer;
import org.openscales.core.style.symbolizer.PolygonSymbolizer;
import org.openscales.geometry.Geometry;
import org.openscales.geometry.LineString;
import org.openscales.geometry.LinearRing;
import org.openscales.geometry.MultiLineString;
import org.openscales.geometry.MultiPoint;
import org.openscales.geometry.MultiPolygon;
import org.openscales.geometry.Point;
import org.openscales.geometry.Polygon;

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
    addFeatures();

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

private function addFeatures():void {
    addPoint();
    addMultiPoint();
    addLine();
    addMultiLine();
    addPolygon();
    addMultiPolygonByPolygon();
    addMultiPolygon();
}

private function addPoint():void {
    // 创建Point的过程
    // Point(x, y)
    var geometry:Geometry = new org.openscales.geometry.Point(30, 10);

    var feature:Feature = new PointFeature(geometry as org.openscales.geometry.Point,
        {label: "Point"}, Style.getDefaultPointStyle());
    featureLayer.addFeature(feature);
}

private function addMultiPoint():void {
    // 创建MultiPoint的过程
    // Vector.<Number>
    // MultiPoint
    var vertices:Vector.<Number> = new Vector.<Number>();
    vertices.push(10, 40, 40, 30, 20, 20);
    var geometry:Geometry = new MultiPoint(vertices);

    var feature:Feature = new MultiPointFeature(geometry as MultiPoint,
        {label: "MultiPoint"}, Style.getDefaultPointStyle());
    ((feature.style.rules[0].symbolizers[0] as PointSymbolizer).graphic as WellKnownMarker).stroke.color = 0x0000ff;
    featureLayer.addFeature(feature);
}

private function addLine():void {
    // 创建LineString的过程
    // Vector.<Number>
    // LineString
    var vertices:Vector.<Number> = new Vector.<Number>();
    vertices.push(35, 15, 15, 35, 45, 45);

    var geometry:Geometry = new LineString(vertices);

    var feature:Feature = new LineStringFeature(geometry as LineString,
        {label: "LineString"}, Style.getDefaultLineStyle());
    featureLayer.addFeature(feature);
}

private function addMultiLine():void {
    // 创建MultiLineString的过程
    // 1. 创建LineString
    // Vector.<Number>
    // LineString
    // 2. 添加LineString
    // Vector.<Geometry>
    // MultiLineString
    var vertices:Vector.<Number> = new Vector.<Number>();
    vertices.push(90, 20, 100, 30, 90, 50);
    var line1:LineString = new LineString(vertices);

    vertices = new Vector.<Number>();
    vertices.push(120, 50, 110, 40, 120, 30, 110, 20);
    var line2:LineString = new LineString(vertices);

    var lines:Vector.<Geometry> = new Vector.<Geometry>();
    lines.push(line1, line2);
    var geometry:Geometry = new MultiLineString(lines);

    var feature:Feature = new MultiLineStringFeature(geometry as MultiLineString,
        {label: "MultiLineString"}, Style.getDefaultLineStyle());
    (feature.style.rules[0].symbolizers[0] as LineSymbolizer).stroke.color = 0xfff;
    featureLayer.addFeature(feature);
}

private function addPolygon():void {
    // 创建Polygon的过程
    // Vector.<Number>
    // LinearRing
    // Vector.<Geometry>
    // Polygon
    var vertices:Vector.<Number> = new Vector.<Number>();
    vertices.push(65, 45, 45, 55, 55, 75, 75, 75, 65, 45);
    var ring:LinearRing = new LinearRing(vertices);

    var rings:Vector.<Geometry> = new Vector.<Geometry>();
    rings.push(ring);
    var geometry:Geometry = new Polygon(rings);

    var feature:Feature = new PolygonFeature(geometry as Polygon,
        {label: "Polygon"});
    featureLayer.addFeature(feature);
}

private function addMultiPolygonByPolygon():void {
    var vertices:Vector.<Number> = new Vector.<Number>();
    vertices.push(95, 70, 70, 80, 75, 100, 105, 105, 95, 70);
    var ring1:LinearRing = new LinearRing(vertices);

    vertices = new Vector.<Number>();
    vertices.push(80, 90, 95, 95, 90, 80, 80, 90);
    var ring2:LinearRing = new LinearRing(vertices);

    var rings:Vector.<Geometry> = new Vector.<Geometry>();
    rings.push(ring1, ring2);
    var geometry:Geometry = new Polygon(rings);

    var feature:Feature = new PolygonFeature(geometry as Polygon,
        {label: "MultiPolygon By Polygon"}, Style.getDrawSurfaceStyle());
    featureLayer.addFeature(feature);
}

private function addMultiPolygon():void {
    // 创建MultiPolygon的过程
    // 1. 创建Polygon
    // Vector.<Number>
    // LinearRing
    // Vector.<Geometry>
    // Polygon
    // 2. 添加Polygon
    // Vector.<Geometry>
    // MultiPolygon
    var vertices:Vector.<Number> = new Vector.<Number>();
    vertices.push(135, 125, 115, 145, 150, 145, 135, 125);
    var ring:LinearRing = new LinearRing(vertices);

    var rings:Vector.<Geometry> = new Vector.<Geometry>();
    rings.push(ring);
    var polygon1:Geometry = new Polygon(rings);

    vertices = new Vector.<Number>();
    vertices.push(120, 110, 145, 115, 115, 125, 110, 115, 120, 110);
    ring = new LinearRing(vertices);

    rings = new Vector.<Geometry>();
    rings.push(ring);
    var polygon2:Geometry = new Polygon(rings);

    var polygons:Vector.<Geometry> = new Vector.<Geometry>();
    polygons.push(polygon1, polygon2);
    var geometry:Geometry = new MultiPolygon(polygons);

    var feature:Feature = new MultiPolygonFeature(geometry as MultiPolygon,
        {label: "MultiPolygon"}, Style.getDefaultSurfaceStyle());
    (feature.style.rules[0].symbolizers[0] as PolygonSymbolizer).stroke.color = 0xf0f;
    featureLayer.addFeature(feature);
}

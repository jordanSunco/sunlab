import com.monkey.supermap.web.spatialanalyst.SpatialAnalystService;
import com.monkey.supermap.web.spatialanalyst.buffer.BufferAnalystParameter;
import com.monkey.supermap.web.spatialanalyst.buffer.BufferParameter;
import com.monkey.supermap.web.spatialanalyst.overlay.OverlayParameter;

import mx.core.UIComponent;
import mx.events.FlexEvent;
import mx.rpc.AsyncResponder;

import org.openscales.core.Map;
import org.openscales.core.control.LayerManager;
import org.openscales.core.control.PanZoom;
import org.openscales.core.events.FeatureEvent;
import org.openscales.core.feature.Feature;
import org.openscales.core.feature.PolygonFeature;
import org.openscales.core.handler.feature.SelectFeaturesHandler;
import org.openscales.core.handler.mouse.DragHandler;
import org.openscales.core.handler.mouse.WheelHandler;
import org.openscales.core.layer.FeatureLayer;
import org.openscales.core.popup.Anchored;
import org.openscales.core.style.Style;
import org.openscales.geometry.Geometry;
import org.openscales.geometry.LinearRing;
import org.openscales.geometry.Point;
import org.openscales.geometry.Polygon;

private var map:Map;

/**
 * 展现要素的临时图层
 */
private var featureLayer:FeatureLayer;
private var popup:Anchored;

private var spatialAnalystService:SpatialAnalystService;

private function init():void {
    var mapContainer:UIComponent = new UIComponent();
    mapContainer.percentWidth = 100;
    mapContainer.percentHeight = 100;
    mapContainer.addEventListener(FlexEvent.CREATION_COMPLETE, initMap);
    addElement(mapContainer);

    this.spatialAnalystService = new SpatialAnalystService("http://cloud.supermap.com.cn/iserver/services/spatialanalyst-sample/restjsr/spatialanalyst/geometry");
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
    testSpatialAnalystService();

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

private function testSpatialAnalystService():void {
    testGeometryBuffer();
    testGeometryOverlay();
}

private function testGeometryBuffer():void {
    var bufferParameter:BufferParameter = new BufferParameter(
        new org.openscales.geometry.Point(1, 2), new BufferAnalystParameter());

    this.spatialAnalystService.geometryBuffer(bufferParameter,
        new AsyncResponder(handlerPointBufferResult, traceFault, this.spatialAnalystService));
}

private function handlerPointBufferResult(bufferResult:Object,
        spatialAnalystService:SpatialAnalystService):void {
    var feature:Feature = new PolygonFeature(spatialAnalystService.getBufferResultGeometry(),
        {label: "Buffered Point"});
    featureLayer.addFeature(feature);
}

private function traceFault(info:Object, token:Object):void {
    trace(info, token);
}

private function testGeometryOverlay():void {
    var vertices:Vector.<Number> = new Vector.<Number>();
    vertices.push(23, 23, 33, 35, 43, 22);
    var ring:LinearRing = new LinearRing(vertices);
    var rings:Vector.<Geometry> = new Vector.<Geometry>();
    rings.push(ring);
    var sourceGeometry:Geometry = new Polygon(rings);

    vertices = new Vector.<Number>();
    vertices.push(23, 23, 34, 47, 50, 12);
    ring = new LinearRing(vertices);
    rings = new Vector.<Geometry>();
    rings.push(ring);
    var operateGeometry:Geometry = new Polygon(rings);

    this.spatialAnalystService.geometryOverlay(
        new OverlayParameter(sourceGeometry, operateGeometry),
        new AsyncResponder(handlerGeometryOverlayResult, traceFault, this.spatialAnalystService));
}

private function handlerGeometryOverlayResult(bufferResult:Object,
        spatialAnalystService:SpatialAnalystService):void {
    var geometry:Geometry = spatialAnalystService.getBufferResultGeometry();

    var feature:Feature = new PolygonFeature(geometry as Polygon,
        {label: "Overlay Geometry"});
    featureLayer.addFeature(feature);
}

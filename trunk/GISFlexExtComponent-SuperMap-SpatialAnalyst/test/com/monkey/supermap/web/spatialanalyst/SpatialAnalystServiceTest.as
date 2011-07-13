package com.monkey.supermap.web.spatialanalyst {
    import com.monkey.supermap.web.spatialanalyst.buffer.BufferAnalystParameter;
    import com.monkey.supermap.web.spatialanalyst.buffer.BufferParameter;
    import com.monkey.supermap.web.spatialanalyst.overlay.OverlayParameter;
    import com.monkey.utils.GeometryUtil;
    
    import mx.rpc.AsyncResponder;
    import mx.rpc.IResponder;
    
    import org.flexunit.asserts.assertEquals;
    import org.flexunit.async.Async;
    import org.openscales.geometry.Geometry;
    import org.openscales.geometry.LinearRing;
    import org.openscales.geometry.Point;
    import org.openscales.geometry.Polygon;

    /**
     * @author Sun
     */
    public class SpatialAnalystServiceTest {
        private var spatialAnalystService:SpatialAnalystService;

        [Before]
        public function setUp():void {
            this.spatialAnalystService = new SpatialAnalystService("http://cloud.supermap.com.cn/iserver/services/spatialanalyst-sample/restjsr/spatialanalyst/geometry");
        }

        [Test(async)]
        public function testPointBuffer():void {
            var bufferParameter:BufferParameter = new BufferParameter(
                new Point(1, 2), new BufferAnalystParameter());
            var asyncResponder:IResponder = Async.asyncResponder(this,
                new AsyncResponder(handlerPointBufferResult, traceFault, this.spatialAnalystService), 0);

            this.spatialAnalystService.geometryBuffer(bufferParameter,
                asyncResponder);
        }

        private function handlerPointBufferResult(bufferResult:Object,
                spatialAnalystService:SpatialAnalystService):void {
            var geometry:Geometry = spatialAnalystService.getBufferResultGeometry();
            assertEquals("-1,2,-0.41421356237309515,0.5857864376269051,0.9999999999999996,0,2.414213562373095,0.5857864376269046,3,2,2.414213562373095,3.414213562373095,1.0000000000000002,4,-0.4142135623730947,3.4142135623730954,-1,2",
                GeometryUtil.getCoordinates(geometry));
        }

        private function traceFault(info:Object, token:Object):void {
            trace(info, token);
            // 如果服务调用失败或者异常则宣告测试失败
            assertEquals(1, 2);
        }

        [Test(async)]
        public function testGeometryOverlay():void {
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

            var asyncResponder:IResponder = Async.asyncResponder(this,
                new AsyncResponder(handlerGeometryOverlayResult, traceFault, this.spatialAnalystService), 0);
            this.spatialAnalystService.geometryOverlay(
                new OverlayParameter(sourceGeometry, operateGeometry),
                asyncResponder);
        }

        private function handlerGeometryOverlayResult(overlayResult:Object,
                spatialAnalystService:SpatialAnalystService):void {
            var geometry:Geometry = spatialAnalystService.getOverlayResultGeometry();
            assertEquals("43,22,23,23,33,35,43,22",
                GeometryUtil.getCoordinates(geometry));
        }
    }
}

package com.monkey.arcgis.gp {
    import mx.rpc.AsyncResponder;
    import mx.rpc.IResponder;
    import mx.rpc.Responder;
    import mx.utils.ObjectUtil;
    
    import org.flexunit.asserts.assertEquals;
    import org.flexunit.async.Async;
    import org.openscales.core.feature.Feature;
    import org.openscales.core.feature.PointFeature;
    import org.openscales.geometry.Point;

    /**
     * @author Sun
     */
    public class GeoprocessorTest {
        [Test(async)]
        public function testPrepareTask():void {
            var features:Vector.<Feature> = new Vector.<Feature>();
            var feature:Feature = new PointFeature(new Point(30, 10), {label: "Point"});
            features.push(feature);

            var inputParameters:Object = {
                feature: feature,
                features: features,
                a: 1,
                b: 2
            };

            var gp:Geoprocessor = new Geoprocessor("http://192.168.200.58:8399/arcgis/rest/services/TestGP/GPServer/TestPointInput");
            // 同步测试, 等执行完成后再执行其他测试, 对于同步GP服务, 不能同时执行多次, 否则会因为多线程问题出现间歇性错误
            // 这里先运行testPrepareTask(执行了一次同步GP), 如果结果还没有返回就去运行testExecute(再次执行同步GP), 就会出现上述问题
            var asyncResponder:IResponder = Async.asyncResponder(this,
                new Responder(function ():void {}, traceFault), 0);
            gp.execute(inputParameters, asyncResponder);

            // 经过GP处理, 部分输入参数由Object变成了字符串, 例如Feature转成了FeatureSet JSON
            assertEquals(true, inputParameters.feature is String);
            assertEquals(true, inputParameters.features is String);
            // 经过GP处理, 输入参数追加f=json
            assertEquals("json", inputParameters.f);
        }

        [Test(async)]
        /**
         * 异步程序需要通过flexunit的异步测试机制来运行, 否则单元测试会马上走完测试流程, 显示测试通过.
         * 但当运行到回调中时, 如果有异常则会报错, 而测试结果仍然是通过的.
         * 通过flexunit的异步测试机制让异步程序在测试过程中以"同步"的方式执行.
         */
        public function testExecute():void {
            // TODO 目前GP服务没有使用输入参数
            var inputParameters:Object = {
                a: 1,
                b: 2
            };

            var gp:Geoprocessor = new Geoprocessor("http://192.168.200.58:8399/arcgis/rest/services/TestGP/GPServer/TestPointInput");
            // flexunit的异步测试机制
            var asyncResponder:IResponder = Async.asyncResponder(this,
                new AsyncResponder(handleExecuteResult, traceFault, gp), 0);
            gp.execute(inputParameters, asyncResponder);
        }

        private function handleExecuteResult(executeResult:Object,
                gp:Geoprocessor):void {
            var p1x:Array = [1298200.1895321002, 1946777.692202618];
            var p1y:Array = [4064264.699309526, 4241780.243755155];

            // TODO 现在返回的2组结果是一样的
            var featureAttributes:Array = [{
                FID: 0,
                OBJECTID: 1
            }, {
                FID: 1,
                OBJECTID: 2
            }];

            // TODO 现在返回的2组结果是一样的, 修改GP服务让其返回2组不一样的结果
            var p2x:Array = [1298200.1895321002, 1946777.692202618];
            var p2y:Array = [4064264.699309526, 4241780.243755155];

            var param1Features:Vector.<Feature> = gp.getExecuteResultValue("POINT_FS_Project") as Vector.<Feature>;
            var param2Features:Vector.<Feature> = gp.getExecuteResultValue("POINT_FS_Project1") as Vector.<Feature>;

            for (var i:uint = 0, length:uint = param1Features.length; i < length; i++) {
                var param1Feature:Feature = param1Features[i];
                var param1Point:Point = param1Feature.geometry as Point;

                assertEquals(p1x[i], param1Point.x);
                assertEquals(p1y[i], param1Point.y);
                assertEquals(0, ObjectUtil.compare(param1Feature.attributes,
                    featureAttributes[i]));
            }

            for (var j:uint = 0, lengthj:uint = param2Features.length; j < lengthj; j++) {
                var param2Feature:Feature = param2Features[j];
                var param2Point:Point = param2Feature.geometry as Point;

                assertEquals(p2x[j], param2Point.x);
                assertEquals(p2y[j], param2Point.y);
                assertEquals(0, ObjectUtil.compare(param2Feature.attributes,
                    featureAttributes[j]));
            }
        }

        private function traceFault(info:Object):void {
            trace(info);
        }
    }
}

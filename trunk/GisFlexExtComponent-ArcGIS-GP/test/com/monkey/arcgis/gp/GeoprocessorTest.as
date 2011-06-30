package com.monkey.arcgis.gp {
    import mx.rpc.Responder;
    import mx.utils.ObjectUtil;
    
    import org.flexunit.asserts.assertEquals;
    import org.openscales.core.feature.Feature;
    import org.openscales.geometry.Point;

    public class GeoprocessorTest {
        [Test]
        public function testExecute():void {
            // TODO 目前GP服务没有使用输入参数
            var inputParameters:Object = {
                a: 1,
                b: 2
            };

            var gp:Geoprocessor = new Geoprocessor("http://192.168.200.58:8399/arcgis/rest/services/TestGP/GPServer/TestPointInput");
            gp.execute(inputParameters, new Responder(handleExecuteResult,
                traceFault));
        }

        private function handleExecuteResult(executeResult:ExecuteResult):void {
            var p1x:Array = [1298200.1895321002, 1946777.692202618];
            var p1y:Array = [4064264.699309526, 4241780.243755155];
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

            for each (var parameterValue:ParameterValue in executeResult.results) {
                var features:Vector.<Feature> = parameterValue.value as Vector.<Feature>;

                for (var i:uint = 0, length:uint = features.length; i < length; i++) {
                    var feature:Feature = features[i];
                    var point:Point = feature.geometry as Point;

                    if (parameterValue.paramName == "POINT_FS_Project") {
                        assertEquals(p1x[i], point.x);
                        assertEquals(p1y[i], point.y);
                        assertEquals(0, ObjectUtil.compare(feature.attributes,
                            featureAttributes[i]));
                    } else if (parameterValue.paramName == "POINT_FS_Project1") {
                        assertEquals(p2x[i], point.x);
                        assertEquals(p2y[i], point.y);
                        assertEquals(0, ObjectUtil.compare(feature.attributes,
                            featureAttributes[i]));
                    }
                }
            }
        }

        private function traceFault(info:Object):void {
            trace(info);
        }
    }
}

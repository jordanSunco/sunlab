package com.monkey.supermap.web.spatialanalyst.overlay {
    import org.openscales.geometry.Geometry;

    /**
     * SuperMap叠加分析参数类
     * 
     * @author Sun
     * @see http://support.supermap.com.cn/DataWarehouse/WebDocHelp/6.0/iSever6R/mergedProjects/SuperMapiServerRESTAPI/root/spatialanalyst/geometry/geometryOverlayResults/geometryOverlayResults.htm 几何对象叠加分析请求体中的参数
     */
    public class OverlayParameter {
        /**
         * 叠加方式: 裁剪
         */
        public static const OPERATION_CLIP:String = "CLIP";

        /**
         * 叠加方式: 擦除
         */
        public static const OPERATION_ERASE:String = "ERASE";

        /**
         * 叠加方式: 合并
         */
        public static const OPERATION_UNION:String = "UNION";

        /**
         * 叠加方式: 相交
         */
        public static const OPERATION_INTERSECT:String = "INTERSECT";

        /**
         * 叠加方式: 同一
         */
        public static const OPERATION_IDENTITY:String = "IDENTITY";

        /**
         * 叠加方式: 对称差
         */
        public static const OPERATION_XOR:String = "XOR";

        /**
         * 叠加方式: 更新
         */
        public static const OPERATION_UPDATE:String = "UPDATE";

        private var _sourceGeometry:Object;
        private var _operateGeometry:Object;
        public var operation:String;

        /**
         * 构造SuperMap叠加分析参数
         * 
         * @param sourceGeometry 源几何对象
         * @param operateGeometry 操作几何对象
         * @param operation 叠加方式
         */
        public function OverlayParameter(sourceGeometry:Geometry,
                operateGeometry:Geometry, operation:String=OPERATION_CLIP) {
            this.sourceGeometry = sourceGeometry;
            this.operateGeometry = operateGeometry;
            this.operation = operation;
        }

        public function get sourceGeometry():Object {
            return this._sourceGeometry;
        }

        /**
         * 使用OpenScales的Geometry来做SuperMap的缓冲区分析
         */
        public function set sourceGeometry(value:Object):void {
            this._sourceGeometry = value as Geometry;
        }

        public function get operateGeometry():Object {
            return this._operateGeometry;
        }

        /**
         * 使用OpenScales的Geometry来做SuperMap的缓冲区分析
         */
        public function set operateGeometry(value:Object):void {
            this._operateGeometry = value as Geometry;
        }
    }
}
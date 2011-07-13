package com.monkey.supermap.web.spatialanalyst.buffer {
    import org.openscales.geometry.Geometry;

    /**
     * SuperMap基于几何对象的缓冲区分析参数类
     * 
     * @author Sun
     * @see com.supermap.web.iServerJava2.queryServices.BufferQueryParameters
     */
    public class BufferParameter {
        private var _sourceGeometry:Object;
        public var analystParameter:BufferAnalystParameter;

        public function BufferParameter(sourceGeometry:Geometry,
                analystParameter:BufferAnalystParameter) {
            this.sourceGeometry = sourceGeometry;
            this.analystParameter = analystParameter;
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
    }
}

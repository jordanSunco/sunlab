package com.monkey.supermap {
    import com.monkey.GeometryDialect;
    
    import org.openscales.geometry.Geometry;

    /**
     * SuperMap Geometry &lt;-&gt; OpenScales Geometry
     * 
     * @author Sun
     */
    public class SuperMapGeometryDialect implements GeometryDialect {
        public function getGeometry(geometryJson:String):Geometry {
            return null;
        }
    }
}

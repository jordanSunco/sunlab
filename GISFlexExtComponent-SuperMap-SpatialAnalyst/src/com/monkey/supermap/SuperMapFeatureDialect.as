package com.monkey.supermap {
    import com.adobe.serialization.json.JSON;
    import com.darronschall.serialization.ObjectTranslator;
    import com.monkey.FeatureDialect;
    import com.monkey.GeometryDialect;
    import com.monkey.supermap.web.core.Feature;
    import com.monkey.supermap.web.core.geometry.Geometry;
    
    import org.openscales.core.feature.Feature;
    import org.openscales.core.feature.LineStringFeature;
    import org.openscales.core.feature.PointFeature;
    import org.openscales.core.feature.PolygonFeature;
    import org.openscales.core.style.Style;

    /**
     * SuperMap Feature &lt;-&gt; OpenScales Feature
     * 
     * @author Sun
     */
    public class SuperMapFeatureDialect implements FeatureDialect {
        public var geometryDialect:GeometryDialect;

        public function SuperMapFeatureDialect(geometryDialect:GeometryDialect) {
            this.geometryDialect = geometryDialect;
        }

        public function getFeatureFromJson(featureJson:String):org.openscales.core.feature.Feature {
            return getFeatureFromObject(JSON.decode(featureJson));
        }

        public function getFeatureFromObject(featureObject:Object):org.openscales.core.feature.Feature {
            var superMapFeature:com.monkey.supermap.web.core.Feature =
                ObjectTranslator.objectToInstance(featureObject, com.monkey.supermap.web.core.Feature);

            var feature:org.openscales.core.feature.Feature =
                createFeatureByGeometryType(superMapFeature.geometry);
            feature.attributes = getAttributes(superMapFeature);
            feature.geometry = this.geometryDialect.getGeometryFromObject(
                superMapFeature.geometry);

            return feature;
        }

        private function createFeatureByGeometryType(superMapGeometryObject:Object):org.openscales.core.feature.Feature {
            var feature:org.openscales.core.feature.Feature;

            var superMapGeometry:com.monkey.supermap.web.core.geometry.Geometry =
                ObjectTranslator.objectToInstance(superMapGeometryObject, com.monkey.supermap.web.core.geometry.Geometry);
            switch (superMapGeometry.type) {
                case com.monkey.supermap.web.core.geometry.Geometry.GEOPOINT:
                    feature = new PointFeature();
                    feature.style = Style.getDefaultPointStyle();
                    break;
                case com.monkey.supermap.web.core.geometry.Geometry.GEOLINE:
                    feature = new LineStringFeature();
                    feature.style = Style.getDefaultLineStyle();
                    break;
                case com.monkey.supermap.web.core.geometry.Geometry.GEOREGION:
                    feature = new PolygonFeature();
                    feature.style = Style.getDefaultSurfaceStyle();
                    break;
                default:
                    trace("default");
            }

            return feature;
        }

        private function getAttributes(superMapFeature:com.monkey.supermap.web.core.Feature):Object {
            var fieldNames:Array = superMapFeature.fieldNames;
            var fieldValues:Array = superMapFeature.fieldValues;

            var attributes:Object = {};
            for (var i:uint = 0, length:uint = fieldNames.length; i < length; i++) {
                attributes[fieldNames[i]] = fieldValues[i];
            }

            return attributes;
        }

        public function toFeature(feature:org.openscales.core.feature.Feature):Object {
            var superMapFeature:com.monkey.supermap.web.core.Feature = new com.monkey.supermap.web.core.Feature();

            var fieldNameAndValues:Array = getFieldNameAndValues(feature.attributes);
            superMapFeature.fieldNames = fieldNameAndValues[0];
            superMapFeature.fieldValues = fieldNameAndValues[1];
            superMapFeature.geometry = this.geometryDialect.toGeometry(feature.geometry);

            return superMapFeature;
        }

        private function getFieldNameAndValues(attributes:Object):Array {
            var fieldNames:Array = [];
            var fieldValues:Array = [];

            for (var fieldName:String in attributes) {
                fieldNames.push(fieldName);
                fieldValues.push(attributes[fieldName]);
            }

            return [fieldNames, fieldValues];
        }

        public function toFeatureJson(feature:org.openscales.core.feature.Feature):String {
            return JSON.encode(toFeature(feature));
        }
    }
}

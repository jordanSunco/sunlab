package com.monkey.gis.data.feature.impl.supermap {
    import com.adobe.serialization.json.JSON;
    import com.darronschall.serialization.ObjectTranslator;
    import com.monkey.gis.data.feature.Feature;
    import com.monkey.gis.data.feature.FeatureDialect;
    import com.monkey.gis.data.wkt.WktDialect;

    /**
     * Feature &lt;-&gt; SuperMap Feature JSON
     * 
     * @author Sun
     */
    public class SuperMapFeatureDialect implements FeatureDialect {
        private var wktDialect:WktDialect;

        public function SuperMapFeatureDialect(wktDialect:WktDialect) {
            this.wktDialect = wktDialect;
        }

        public function getFeatureJson(feature:com.monkey.gis.data.feature.Feature):String {
            var superMapFeature:com.monkey.gis.data.feature.impl.supermap.Feature = new com.monkey.gis.data.feature.impl.supermap.Feature();

            var fieldNameAndValues:Array = getFieldNameAndValues(feature.attributes);
            superMapFeature.fieldNames = fieldNameAndValues[0];
            superMapFeature.fieldValues = fieldNameAndValues[1];
            superMapFeature.geometry = JSON.decode(this.wktDialect.getGeometryJson(feature.geometry));

            return JSON.encode(superMapFeature);
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

        public function toFeature(geometryJson:String):com.monkey.gis.data.feature.Feature {
            var superMapFeature:com.monkey.gis.data.feature.impl.supermap.Feature = ObjectTranslator.objectToInstance(
                JSON.decode(geometryJson), com.monkey.gis.data.feature.impl.supermap.Feature);

            var geometry:String = this.wktDialect.toWkt(JSON.encode(superMapFeature.geometry));
            var attributes:Object = getAttributes(superMapFeature);
            return new com.monkey.gis.data.feature.Feature(geometry, attributes);
        }

        private function getAttributes(superMapFeature:com.monkey.gis.data.feature.impl.supermap.Feature):Object {
            var fieldNames:Array = superMapFeature.fieldNames;
            var fieldValues:Array = superMapFeature.fieldValues;

            var attributes:Object = {};
            for (var i:uint = 0, length:uint = fieldNames.length; i < length; i++) {
                attributes[fieldNames[i]] = fieldValues[i];
            }

            return attributes;
        }
    }
}
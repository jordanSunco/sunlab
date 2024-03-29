package maps.events {
    import com.esri.ags.tasks.FeatureSet;
    
    import flash.events.Event;

    /**
     * 
     * @author Sun
     */
    public class ArcGisFlashlikeMapEvent extends Event {
        /**
         * 当地图上/下钻完成后, 渲染地图图形时派发此事件
         */
        public static const RENDER_GRAPHIC:String = "renderGraphic";

        public var flashMapLevel:uint;
        public var featureSet:FeatureSet;

        public function ArcGisFlashlikeMapEvent(type:String,
                flashMapLevel:uint, featureSet:FeatureSet, bubbles:Boolean=false,
                cancelable:Boolean=false) {
            super(type, bubbles, cancelable);

            this.flashMapLevel = flashMapLevel;
            this.featureSet = featureSet;
        }
    }
}

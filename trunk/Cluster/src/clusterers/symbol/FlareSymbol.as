/*
 * Copyright
 */

package clusterers.symbol {
    import clusterers.Cluster;
    
    import com.esri.ags.Map;
    import com.esri.ags.geometry.Geometry;
    import com.esri.ags.symbol.MarkerSymbol;
    
    import flare.TweenFlareContainer;
    
    import flash.display.Sprite;

    /**
     * 表现聚合点散开/合拢的Symbol
     * 
     * @author Sun
     */
    public class FlareSymbol extends MarkerSymbol {
        public function FlareSymbol() {
            super();
        }

        override public function draw(sprite:Sprite, geometry:Geometry,
                attributes:Object, map:Map):void {
            var cluster:Cluster = geometry as Cluster;
            sprite.x = toScreenX(map, cluster.x);
            sprite.y = toScreenY(map, cluster.y);

            removeAllChildren(sprite);
            sprite.addChild(new TweenFlareContainer(cluster.mapPointGraphics));
        }
    }
}

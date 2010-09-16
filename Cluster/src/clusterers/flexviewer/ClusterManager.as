package clusterers.flexviewer {
    import com.esri.ags.Graphic;
    import com.esri.ags.Map;
    import com.esri.ags.esri_internal;
    import com.esri.ags.events.ExtentEvent;
    import com.esri.ags.geometry.MapPoint;
    
    import flash.utils.Dictionary;
    
    import mx.collections.ArrayCollection;
    import mx.events.CollectionEvent;
    import mx.events.CollectionEventKind;
    
    /**
     * Cluster a set of map points.
     */
    public class ClusterManager {
        [Bindable] public var map:Map;
        [Bindable] public var sink:ArrayCollection = new ArrayCollection();
        [Bindable] public var source/*<ClusterGraphic>*/:ArrayCollection = new ArrayCollection();
		
		// in pixels
		//合成的范围
        public var radius:int = 20; 
        private var m_diameter:int;
        
        public function ClusterManager() {
            // 监听CollectionEventKind.REFRESH事件
            sink.addEventListener(CollectionEvent.COLLECTION_CHANGE, sink_collectionChangeHandler);
        }

        private function sink_collectionChangeHandler(event:CollectionEvent):void {
            if( event.kind === CollectionEventKind.REFRESH ) {
                map.removeEventListener(ExtentEvent.EXTENT_CHANGE, extentChangeHandler);
                clusterMapPoints();
                map.addEventListener(ExtentEvent.EXTENT_CHANGE, extentChangeHandler);
            }
        }
        
        private function extentChangeHandler(event:ExtentEvent):void {
            clusterMapPoints();            
        }
        
        private var m_orig/*<int,Cluster>*/:Dictionary;                
        private var m_overlapExists:Boolean;
        
        private function clusterMapPoints():void {
            m_diameter = radius + radius;
            
            assignMapPointsToClusters();
            // Keep merging overlapping clusters until none overlap.
            do {
                mergeOverlappingClusters();
            } while (m_overlapExists);
            source.removeAll();
            for each (var cluster:Cluster in m_orig) {
                // Convert clusters to graphics so they can be displayed.
				//将clusters转为graphics,方便显示
                cluster.x = map.esri_internal::toMapX(cluster.x);
                cluster.y = map.esri_internal::toMapY(cluster.y);
                var graphic:Graphic = new ClusterGraphic(cluster, null, {n:cluster.n,data:cluster.data/*自定义数据*/});
                source.addItem(graphic);
            }
        }
        
		/**
		 * 合成clusters
		 */
        private function mergeOverlappingClusters():void {
            m_overlapExists = false;
            // Create a new set to hold non-overlapping clusters.            
            const dest/*<int,Cluster>*/:Dictionary = new Dictionary();
            for each (var cluster:Cluster in m_orig) {
                // skip merged cluster
                if(cluster.n === 0) {
                    continue;
                }
                // Search all immediately adjacent clusters.
                searchAndMerge(cluster,  1,  0);
                searchAndMerge(cluster, -1,  0);
                searchAndMerge(cluster,  0,  1);
                searchAndMerge(cluster,  0, -1);
                searchAndMerge(cluster,  1,  1);
                searchAndMerge(cluster,  1, -1);
                searchAndMerge(cluster, -1,  1);
                searchAndMerge(cluster, -1, -1);

                // Find the new cluster centroid values.                
                var cx:int = cluster.x / m_diameter;
                var cy:int = cluster.y / m_diameter;
                cluster.cx = cx;
                cluster.cy = cy;
                // Compute new dictionary key.
                var ci : int = (cx << 16) | cy;
                dest[ci] = cluster;                                                                
            }
            m_orig = dest;
        }
        
		/**
		 * 寻找附近的cluster并做合成
		 */
        private function searchAndMerge(cluster:Cluster, ox:int, oy:int):void {
            const cx:int = cluster.cx + ox;
            const cy:int = cluster.cy + oy;
            const ci:int = (cx << 16) | cy;
            const found:Cluster = m_orig[ci] as Cluster;
            if(found && found.n) {
                const dx:Number = found.x - cluster.x;
                const dy:Number = found.y - cluster.y;
                const dd:Number = Math.sqrt(dx * dx + dy * dy);
                // Check if there is a overlap based on distance. 
                if( dd < m_diameter ) {
                    m_overlapExists = true;
                    merge(cluster, found);
                }
            }
        }
        
        /**
         * Adjust centroid weighted by the number of map points in the cluster.
         * The more map points a cluster has, the less it moves.
		 * 将两个cluster合成一个cluster,并将数据转移  
         */
        private function merge(lhs:Cluster, rhs:Cluster):void {
            const nume:Number = lhs.n + rhs.n;
            lhs.x = (lhs.n * lhs.x + rhs.n * rhs.x ) / nume;
            lhs.y = (lhs.n * lhs.y + rhs.n * rhs.y ) / nume;
			lhs.data.addItem(rhs.data);
            lhs.n += rhs.n; // merge the map points
            rhs.n = 0; // marke the cluster as merged.
			rhs.data=new ArrayCollection();
        }
        
        /**
         * Assign map points to clusters.
		 * 初始化mappoint到clusters
         */
        private function assignMapPointsToClusters():void {
            m_orig = new Dictionary();
            for each (var gra:Graphic in sink) {
				var mapPoint:MapPoint = gra.geometry as MapPoint;
                // Cluster only map points in the map extent
                if(map.extent.contains(mapPoint)) {
                    // Convert world map point to screen values.
                    var sx:Number = map.esri_internal::toScreenX( mapPoint.x );
                    var sy:Number = map.esri_internal::toScreenY( mapPoint.y );
 
                    // Convert to cluster x/y values.
                    var cx:int = sx / m_diameter;
                    var cy:int = sy / m_diameter;
					
					//data
					//为cluster初始化数据
					var data:Object={name:gra.attributes["Case_Number"], dj:gra.attributes["Reference_Marker"] }

                    // Convert to cluster dictionary key.
                    var ci:int = (cx << 16) | cy;

                    // Find existing cluster                    
                    var cluster:Cluster = m_orig[ci];
                    if (cluster) {
                        // Average centroid values based on new map point.
                        cluster.x = (cluster.x + sx) / 2.0;
                        cluster.y = (cluster.y + sy) / 2.0;
						//为cluster添加数据
						cluster.data.addItem(data);
                        // Increment the number map points in that cluster.
                        cluster.n++;
                    } else {
                        // Not found - create a new cluster as that index.
                        m_orig[ci] = new Cluster(sx, sy, cx, cy, data);
                    }
                }
            }
        }
    }
}
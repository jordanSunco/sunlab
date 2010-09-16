package clusterers {
	import com.esri.ags.Graphic;
	import com.esri.ags.geometry.MapPoint;

	public class Cluster extends MapPoint {
	    // Centroid x value
		private var _cx:int;
		// Centroid y value
		private var _cy:int;

		// Number of map points in the cluster
		[ArrayElementType("com.esri.ags.Graphic")]
		private var _mapPointGraphics:Array;

		private var _merged:Boolean = false;

		public function Cluster(x:Number, y:Number, cx:int, cy:int) {
			super(x, y);
			this.cx = cx;
			this.cy = cy;

			_mapPointGraphics = new Array();
		}

		public function addMapPointGraphic(mapPointGraphic:Graphic):void {
		    mapPointGraphics.push(mapPointGraphic);
		}

		public function getMapPointCount():uint {
		    return mapPointGraphics.length;
		}

        /**
         * Adjust centroid weighted by the number of map points in the cluster.
         * The more map points a cluster has, the less it moves.
         */
        public function merge(rhs:Cluster):void {
            // 左边
            var lhsMapPointCount:uint = this.getMapPointCount();
            // 右边
            var rhsMapPointCount:uint = rhs.getMapPointCount();

            const nume:Number = lhsMapPointCount + rhsMapPointCount;
            this.x = (lhsMapPointCount * this.x + rhsMapPointCount * rhs.x) / nume;
            this.y = (lhsMapPointCount * this.y + rhsMapPointCount * rhs.y) / nume;

            // merge the map points
            // 将graphic转移到聚合点上, rhs将不再包含任何点(已被合并为)
            for (var i:int = rhs.mapPointGraphics.length - 1; i >= 0; i--) {
                this.addMapPointGraphic(rhs.mapPointGraphics.pop());
            }
        }

        public function get cx():int {
            return this._cx;
        }

        public function set cx(value:int):void {
            this._cx = value;
        }

        public function get cy():int {
            return this._cy;
        }

        public function set cy(value:int):void {
            this._cy = value;
        }

        public function get mapPointGraphics():Array {
            return this._mapPointGraphics;
        }
	}
}

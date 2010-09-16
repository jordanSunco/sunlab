package clusterers.flexviewer {
	import com.esri.ags.SpatialReference;
	import com.esri.ags.geometry.MapPoint;
	
	import mx.collections.ArrayCollection;
	
	public class Cluster extends MapPoint {
		public var cx:int; // Centroid x value
		public var cy:int; // Centroid y value
		public var n:Number; // Number of map points in the cluster
		//cluster的自定义数据
		public var data:ArrayCollection = new ArrayCollection();

		public function Cluster(x:Number, y:Number, cx:int, cy:int, data:Object) {
			//TODO: implement function
			super(x, y);
			this.cx = cx;
			this.cy = cy;
			this.n = 1;
			this.data.addItem(data);
		}
	}
}

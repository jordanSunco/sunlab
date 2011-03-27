class com.FlashDynamix.geom.Line {
	public static function length(sPt, ePt):Number {
		var xdist:Number = sPt.x-ePt.x;
		var ydist:Number = sPt.y-ePt.y;
		return Math.sqrt((xdist*xdist)+(ydist*ydist));
	}
	public static function scalar(sPt, ePt, pt):Number {
		var l:Number = Line.length(sPt, ePt);
		var s:Number = Line.length(sPt, pt);
		return (s/l);
	}
	public static function angle(sPt, ePt):Number {
		return Math.atan2(ePt.y-sPt.y, ePt.x-sPt.x);
	}
	public static function degree(sPt, ePt):Number {
		return angle(sPt, ePt)*180/Math.PI;
	}
	public static function isParallel(sPt1, ePt1, sPt2, ePt2):Boolean {
		return Line.angle(sPt1, ePt1) == Line.angle(sPt2, ePt2);
	}
	public static function isPointOnLine(sPt, ePt, pt):Boolean {
		return (Math.abs(Line.degree(sPt, ePt)-Line.degree(sPt, pt))<0.25 && Line.length(sPt, pt)<=Line.length(sPt, ePt));
	}
	public static function projectOnLine(sPt, ePt, l) {
		var a = Line.angle(sPt, ePt);
		return {x:sPt.x+Math.cos(a)*l, y:sPt.y+Math.sin(a)*l};
	}
}

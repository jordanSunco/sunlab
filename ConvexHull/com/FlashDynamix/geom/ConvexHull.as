import com.FlashDynamix.geom.Line;
import com.FlashDynamix.types.Array2;
//
class com.FlashDynamix.geom.ConvexHull {
	public static function isLeft(P0, P1, P2) {
		return (P1.x-P0.x)*(P2.y-P0.y)-(P2.x-P0.x)*(P1.y-P0.y);
	}
	public static function bottomLeft(p:Array):Number {
		var idx = 0;
		for (var i = 0; i < p.length; i++) {
			var pt = p[i];
			if ( pt.y > p[idx].y || (pt.y >= p[idx].y && pt.x < p[idx].x) ) {
				idx = i;
			}
		}
		return idx;
	}
	public static function bottomRight(p:Array):Number {
		var idx = 0;
		for (var i = 0; i < p.length; i++) {
			var pt = p[i];
			if ( pt.y > p[idx].y || (pt.y >= p[idx].y && pt.x > p[idx].x) ) {
				idx = i;
			}
		}
		return idx;
	}
	public static function startBottomRight(p:Array){
		var idx:Number = ConvexHull.bottomRight(p);
		var np:Array = p.slice(idx, p.length);
		np = np.concat(p.slice(0, idx));
		return np
	}
	public static function findAngle(x1:Number, y1:Number, x2:Number, y2:Number) {
		var deltaX = x2-x1;
		var deltaY = y2-y1;
		if (deltaX == 0 && deltaY == 0) {
			return 0;
		}
		var angle = Math.atan(deltaY/deltaX)*(180/Math.PI);
		//TAKE INTO ACCOUNT QUADRANTS, VALUE: 0°-360°
		if (deltaX>=0 && deltaY>=0) {
			angle = 90+angle;
		} else if (deltaX>=0 && deltaY<0) {
			angle = 90+angle;
		} else if (deltaX<0 && deltaY>0) {
			angle = 270+angle;
		} else if (deltaX<0 && deltaY<=0) {
			angle = 270+angle;
		}
		return angle;
	}
	public static function sortC(start:Function, p:Array):Array{
		sortCC(start, p).reverse();
		p.unshift(p.pop());
		return p;
	}
	public static function sortCC(start:Function, p:Array):Array{
		var idx:Number = start(p);
		var pt = p[idx];
		var same:Array = new Array();
		p.sort(function(a, b){
			var aR:Number = Line.angle(pt, a);
			var bR:Number = Line.angle(pt, b);
			if (aR>bR ) {
				return -1;
			} else if (aR<bR ) {
				return 1;
			} else {
				same.push(a);
				return 0;
			}
		});
		Array2.removeItems(p, same);
		return p;
	}
	// Works in any case most memory intensive
	public static function grahamScan2D(p:Array):Array {
		//
		ConvexHull.sortC(ConvexHull.bottomRight, p);
		//
		var H:Array = new Array(p[1], p[0]);
		var i:Number = 2;
		//
		while (i<p.length) {
			if (ConvexHull.isLeft( H[0], H[1], p[i])<=0) {
				H.unshift(p[i]);
				i++;
			} else {
				H.splice(0, 1);
			}
		}
		H.push(H[0]);
		return H;
	}
	public static function jarvisMarchHull2D(p:Array):Array {
		//
		var H:Array = new Array();
		var n:Number = p.length;
		var maxAngle = 0;
		var minAngle = 0;
		var maxPoint = 0;
		var minPoint = 0;
		//
		for (var k = 1; k<n; k++) {
			if (p[k].y>p[maxPoint].y) {
				maxPoint = k;
			}
		}
		for (var j = 1; j<n; j++) {
			if (p[j].y<p[minPoint].y) {
				minPoint = j;
			}
		}
		H[minPoint] = p[minPoint];
		var currPoint = minPoint;
		while (currPoint != maxPoint) {
			maxAngle = currPoint;
			for (var y = 0; y<n; y++) {
				if (findAngle(p[currPoint].x, p[currPoint].y, p[maxAngle].x, p[maxAngle].y)<findAngle(p[currPoint].x, p[currPoint].y, p[y].x, p[y].y) && (H[y] == undefined || y == maxPoint) && findAngle(p[currPoint].x, p[currPoint].y, p[y].x, p[y].y)<=270) {
					maxAngle = y;
				}
			}
			currPoint = maxAngle;
			H[currPoint] = p[currPoint];
		}
		currPoint = minPoint;
		while (currPoint != maxPoint) {
			minAngle = maxPoint;
			for (var y = 0; y<n; y++) {
				if (findAngle(p[currPoint].x, p[currPoint].y, p[minAngle].x, p[minAngle].y)>findAngle(p[currPoint].x, p[currPoint].y, p[y].x, p[y].y) && (H[y] == undefined || y == maxPoint) && findAngle(p[currPoint].x, p[currPoint].y, p[y].x, p[y].y)>=90) {
					minAngle = y;
				}
			}
			currPoint = minAngle;
			H[currPoint] = p[currPoint];
		}
		//
		for(var i=0; i<H.length; i++){
			if(H[i] == undefined){
				H.splice(i, 1);
				i--;
			}
		}
		//
		return H;
	}
	// Usually less memory intensive than Graham Scan
	public static function melkmanHull2D(p:Array):Array {
		var n = p.length;
		var D:Array = new Array(2*n+1);
		var bot = n-2;
		var top = bot+3;
		D[bot] = D[top]=p[2];
		if (isLeft(p[0], p[1], p[2])>0) {
			D[bot+1] = p[0];
			D[bot+2] = p[1];
		} else {
			D[bot+1] = p[1];
			D[bot+2] = p[0];
		}
		for (var i = 3; i<n; i++) {
			if (isLeft(D[bot], D[bot+1], p[i])>0 && isLeft(D[top-1], D[top], p[i])>0) {
				continue;
			}
			while (isLeft(D[bot], D[bot+1], p[i])<=0) {
				++bot;
			}
			D[--bot] = p[i];
			while (isLeft(D[top-1], D[top], p[i])<=0) {
				--top;
			}
			D[++top] = p[i];
		}
		var H:Array = new Array();
		for (var h = 0; h<=(top-bot); h++) {
			H[h] = D[bot+h];
		}
		delete D;
		return H;
	}
	// If the points are a polyline in order use this at it's very effecient
	public static function chainHull2D(p:Array) {
		var h:Array = new Array();
		var bot = 0;
		var top = (-1);
		var n = p.length;
		var minmin = 0;
		var minmax = minmin;
		var xmin = p[0].x;
		for (var i = 1; i<n; i++) {
			if (p[i].x != xmin) {
				break;
			}
			minmax = i-1;
		}
		if (minmax == n-1) {
			h[++top] = p[minmin];
			if (p[minmax].y != p[minmin].y) {
				h[++top] = p[minmax];
			}
			h[++top] = p[minmin];
			return h;
		}
		var maxmin = n-1;
		var maxmax = maxmin;
		var xmax = p[n-1].x;
		for (var i = n-2; i>=0; i--) {
			if (p[i].x != xmax) {
				break;
			}
			maxmin = i+1;
		}
		h[++top] = p[minmin];
		i = minmax;
		while (++i<=maxmin) {
			if (isLeft(p[minmin], p[maxmin], p[i])>=0 && i<maxmin) {
				continue;
			}
			while (top>0) {
				if (isLeft(h[top-1], h[top], p[i])>0) {
					break;
				} else {
					top--;
				}
			}
			h[++top] = p[i];
		}
		if (maxmax != maxmin) {
			h[++top] = p[maxmax];
		}    
		bot = top;
		i = maxmin;
		while (--i>=minmax) {
			if (isLeft(p[maxmax], p[minmax], p[i])>=0 && i>minmax) {
				continue;
			}
			while (top>bot) {
				if (isLeft(h[top-1], h[top], p[i])>0) {
					break;
				} else {
					top--;
				}
			}
			h[++top] = p[i];
		}
		if (minmax != minmin) {
			h[++top] = p[minmin];
		}
		return h;
	}
	// Most memory effecient and can scale the accuracy with k - larger number more accurate
	public static function bfpHullD(P:Array, k:Number):Array {
		var H:Array = new Array();
		var n:Number = P.length;
		var minmin = 0;
		var minmax = 0;
		var maxmin = 0;
		var maxmax = 0;
		var xmin = P[0].x;
		var xmax = P[0].x;
		var cP;
		var bot = 0;
		var top = (-1);
		for (var i = 1; i<n; i++) {
			cP = P[i];
			if (cP.x<=xmin) {
				if (cP.x<xmin) {
					xmin = cP.x;
					minmin = minmax=i;
				} else {
					if (cP.y<P[minmin].y) {
						minmin = i;
					} else if (cP.y>P[minmax].y) {
						minmax = i;
					}
				}
			}
			if (cP.x>=xmax) {
				if (cP.x>xmax) {
					xmax = cP.x;
					maxmin = maxmax=i;
				} else {
					if (cP.y<P[maxmin].y) {
						maxmin = i;
					} else if (cP.y>P[maxmax].y) {
						maxmax = i;
					}
				}
			}
		}
		if (xmin == xmax) {
			H[++top] = P[minmin];
			if (minmax != minmin) {
				H[++top] = P[minmax];
			}
			return top+1;
		}
		var B = new Array(k+2);
		B[0] = new Object();
		B[0].min = minmin;
		B[0].max = minmax;
		B[k+1] = new Object();
		B[k+1].min = maxmin;
		B[k+1].max = maxmax;
		for (var b = 1; b<=k; b++) {
			B[b] = new Object();
			B[b].min = B[b].max=-1;
		}
		var b = 0;
		for (var i = 0; i<n; i++) {
			cP = P[i];
			if (cP.x == xmin || cP.x == xmax) {
				continue;
			}
			if (ConvexHull.isLeft(P[minmin], P[maxmin], cP)<0) {
				b = int((k*(cP.x-xmin)/(xmax-xmin))+1);
				if (B[b].min == -1) {
					B[b].min = i;
				} else if (cP.y<P[B[b].min].y) {
					B[b].min = i;
				}
				continue;
			}
			if (ConvexHull.isLeft(P[minmax], P[maxmax], cP)>0) {
				b = int((k*(cP.x-xmin)/(xmax-xmin))+1);
				if (B[b].max == -1) {
					B[b].max = i;
				} else if (cP.y>P[B[b].max].y) {
					B[b].max = i;
				} 
				continue;
			}
		}
		for (var i = 0; i<=k+1; ++i) {
			if (B[i].min == -1) {
				continue;
			}
			cP = P[B[i].min];
			while (top>0) {
				if (ConvexHull.isLeft(H[top-1], H[top], cP)>0) {
					break;
				} else {
					top--;
				}
			}
			H[++top] = cP;
		}
		if (maxmax != maxmin) {
			H[++top] = P[maxmax];
		}
		bot = top;
		for (var i = k; i>=0; --i) {
			if (B[i].max == -1) {
				// no max povar in this range
				continue;
			}
			cP = P[B[i].max];
			while (top>bot) {
				if (ConvexHull.isLeft(H[top-1], H[top], cP)>0) {
					break;
				} else {
					top--;
				}
			}
			H[++top] = cP;
		}
		if (minmax != minmin) {
			H[++top] = P[minmin];
		}
		H.pop();
		return H;
	}

}
package qs.graphics
{
	import mx.core.UIComponent;
	import mx.graphics.IFill;
	import mx.graphics.IStroke;
	import flash.geom.Rectangle;

	[Style(name="fill", type="mx.graphics.IFill", inherit="no")]
	[Style(name="stroke", type="mx.graphics.IStroke", inherit="no")]
	public class Box extends UIComponent
	{
		private static var rc:Rectangle = new Rectangle();
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			var f:IFill = getStyle("fill");
			var s:IStroke = getStyle("stroke");
			var o:Number = 0;
			
			graphics.clear();
			
			if(s != null)
			{
				o = s.weight/2;
				unscaledHeight -=s.weight;
				unscaledWidth -= s.weight;
				s.apply(graphics);
			}
			else
				graphics.lineStyle(0,0,0);

			if(f != null)
			{
				rc.left = rc.right = o;
				rc.width = unscaledWidth;
				rc.height = unscaledHeight;
				f.begin(graphics,rc);
			}
			graphics.drawRect(o,o,unscaledWidth,unscaledHeight);
			if(f != null)
			{
				f.end(graphics);
			}
			
			
		}
	}
}
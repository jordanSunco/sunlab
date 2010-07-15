package skins
{

	import flash.display.GradientType;
	import flash.display.Graphics;
	
	import mx.skins.ProgrammaticSkin;
	import mx.styles.StyleManager;
	import mx.utils.ColorUtil;
	
	public class TitleBackgroundEx extends ProgrammaticSkin
	{
	
		public function TitleBackgroundEx()
		{
			super();
		}
		
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);
			var backgroundColor:int = isNaN(getStyle("backgroundColor")) ? 0xFFFFFF : getStyle("backgroundColor");
			var backgroundAlpha:Number = isNaN(getStyle("backgroundAlpha")) ? 1 : getStyle("backgroundAlpha");
			var borderAlpha:Number = isNaN(getStyle("borderAlpha")) ? 1 : getStyle("borderAlpha");
			var borderColor:int = getStyle("borderColor");
			var borderThickness:int = getStyle("borderThickness");
			var cornerRadius:Number = getStyle("cornerRadius");
			var headerColors:Array = getStyle("headerColors");
			var headerHeight:int = isNaN(getStyle("headerHeight")) ? 26 : getStyle("headerHeight");
			var headerCapColor:uint = getStyle("headerCapColor");
			var headerCapHeight:int = getStyle("headerCapHeight");
			var showChrome:Boolean = headerColors != null;		
			var g:Graphics = graphics;
			g.clear();
			if (h < 3)
				return;
			if (showChrome) 
			{
				// Title cap
				drawRoundRect(0, 0, w, headerCapHeight, {tl: cornerRadius, tr:cornerRadius, bl: 0, br: 0}, headerCapColor, 1);  
				// Title background
				drawRoundRect(
					0, headerCapHeight + borderThickness, w, h - headerCapHeight - borderThickness * 2,
					{ tl: 0, tr: 0, bl: 0, br: 0 },
					headerColors, borderAlpha,
					verticalGradientMatrix(0, headerCapHeight + borderThickness, w, h - headerCapHeight - borderThickness * 2));
					
				g.lineStyle(borderThickness, borderColor, borderAlpha);
				// Borders
				g.moveTo(0, headerCapHeight);
				g.lineTo(w, headerCapHeight);
				g.moveTo(0, h - borderThickness);
				g.lineTo(w, h - borderThickness);
			}		
		}
	}

}

/*
///////////////////////////////////////////////////////////////////////////////
//
//  KButton by Kingnare.com
//
///////////////////////////////////////////////////////////////////////////////
*/

package com.kingnare.skins
{
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.Graphics;
	import flash.display.GradientType;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class KButton extends Sprite
	{
    		
		public function KButton(width:uint, height:uint, label:String)
		{
			var sb:SimpleButton = new SimpleButton();
        	sb.downState      = DrawButton(width, height, [0.1,0.0], [0.08,0.03]);
        	sb.overState      = DrawButton(width, height, [0.15,0.05], [0.08,0.03]);
        	sb.upState        = DrawButton(width, height, [0.1,0.0], [0.08,0.03]);
        	sb.hitTestState   = DrawButton(width, height, [0.1,0.0], [0.08,0.03]);
        	sb.useHandCursor  = true;
        	//
        	var btnLabel:TextField = appendText(width, height, label);
			btnLabel.x = 0;
			btnLabel.y = 2;
			//
			addChild(btnLabel);
			addChild(sb);
		}
		
		private function appendText(w:uint, h:uint, text:String):TextField
		{
			//
			var newFormat:TextFormat = new TextFormat();
			newFormat.color = 0xFFFFFF;
			newFormat.font = "Verdana";
			newFormat.align = TextFormatAlign.CENTER;
			newFormat.size = 10;
			//
			var label:TextField = new TextField();
			label.selectable = false;
			label.width = w;
			label.height = h;
			label.text = text;
			label.setTextFormat(newFormat);
			return label;
		}
		
		private function DrawButton(w:uint,h:uint,innerFrameAlphas:Array,innerHighlightAlphas:Array):Shape
		{
			var s:Shape = new Shape();
			var g:Graphics = s.graphics;
			g.clear();
			var gradientBoxMatrix:Matrix = new Matrix();   
			g.lineStyle(1, 0xFFFFFF, 0.1);
			g.drawRect(0, 0, w, h);
			//
			g.lineStyle(1, 0x000000, 0.6);
			gradientBoxMatrix.createGradientBox(w, h, Math.PI/2, 0, 0);
			g.beginGradientFill(GradientType.LINEAR,[0xFFFFFF, 0xFFFFFF],innerFrameAlphas,null,gradientBoxMatrix);
			g.drawRect(1, 1, w-2, h-2);
			g.endFill();
			//
			g.lineGradientStyle(GradientType.LINEAR,[0xFFFFFF, 0xFFFFFF],innerHighlightAlphas,null,gradientBoxMatrix);
			g.drawRect(2, 2, w-4, h-4);
			return s;
		}
	}
}
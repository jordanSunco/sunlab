package com.frogiology {
	import caurina.transitions.Tweener;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class Main extends Sprite {	
		
		private const CIRCLE_NUM:int = 15;
		private const RADIUS:int = 80;
		
		public var restartBtn:SimpleButton;
		
		private var circleArr:Array = new Array();
		
		public function Main() {
			restartBtn.addEventListener(MouseEvent.CLICK, this.onRestartBtnClick);
			
			this.startEffect();
		}
		
		private function onRestartBtnClick(e:MouseEvent) {
			this.startEffect();
		}
		
		private function startEffect() {
			//clear
			while (circleArr.length > 0) {
				this.removeChild(circleArr.pop());
			}
			
			//remove all previous Tween
			Tweener.removeAllTweens();
			
			var centerPt:Point = new Point(stage.width / 2, stage.height / 2);
			
			for (var i:int = 0; i < CIRCLE_NUM; i++) {
				var circleMc:MovieClip = new CircleMc();
				this.addChild(circleMc);
				
				this.circleArr.push(circleMc);
				
				circleMc.alpha = 0;
				circleMc.x = centerPt.x;
				circleMc.y = centerPt.y;
				
				var angle:Number = 2 * Math.PI / CIRCLE_NUM * i;
				var targetPt:Point = new Point();
				
				targetPt.x = RADIUS * Math.cos(angle) + centerPt.x;
				targetPt.y = RADIUS * Math.sin(angle) + centerPt.y;
				
				Tweener.addTween(circleMc, {
					alpha: 1,
					x: targetPt.x,
					y: targetPt.y,
					transition: "easeOutExpo",
					time: 1,
					delay: i * 0.2
				});
				
				Tweener.addTween(circleMc, {
					x: centerPt.x,
					y: centerPt.y,
					alpha: 0,
					time: 1,
					transition: "easeInExpo",
					delay: i * 0.2 + 3
				});
			}
		}
	}
}
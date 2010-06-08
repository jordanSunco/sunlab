package com.frogiology {
	import caurina.transitions.Tweener;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class Main extends Sprite {	
		
		public var startBtn:SimpleButton;
		
		private var circleArr:Array;
		
		public function Main() {
			
			this.circleArr = new Array();
			
			this.startBtn.addEventListener(MouseEvent.CLICK, this.startEffect);
		}
		
		private function startEffect(e:MouseEvent) {
			Tweener.removeAllTweens();
			
			while (this.circleArr.length > 0) {
				this.removeChild(this.circleArr.pop());
			}
			
			Tweener.addCaller(this, {
				time: 3,
				count: 27,
				transition: "easeOutQuad",
				onUpdate: this.putCircle
			});
		}
		
		private function putCircle() {
			
			var circleMc:MovieClip = new CircleMc();
			
			this.addChild(circleMc);
			
			circleMc.x = (this.circleArr.length % 9) * 50 + 40;
			circleMc.y = Math.floor(this.circleArr.length / 9) * 50 + 70;
			
			circleMc.alpha = 0;
			circleMc.scaleX = circleMc.scaleY = 0;
			
			Tweener.addTween(circleMc, {
				alpha: 1,
				scaleX: 1,
				scaleY: 1,
				transition: "easeOutElastic",
				time: 0.5
			});
			
			this.circleArr.push(circleMc);
		}
	}
}
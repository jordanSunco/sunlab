package com.frogiology {
	import caurina.transitions.Tweener;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class Main extends Sprite {	
		
		public var ball1Mc:MovieClip;
		public var ball2Mc:MovieClip;
		
		public var restart1Btn:SimpleButton;
		public var restart2Btn:SimpleButton;
		
		public function Main() {
			restart1Btn.addEventListener(MouseEvent.CLICK, this.onRestart1BtnClick);
			restart2Btn.addEventListener(MouseEvent.CLICK, this.onRestart2BtnClick);
		}
		
		private function onRestart1BtnClick(e:MouseEvent) {
			Tweener.removeTweens(this.ball1Mc);
			
			this.ball1Mc.x = 70;
			this.ball1Mc.y = 190;
			
			Tweener.addTween(this.ball1Mc, {
				x: 190,
				transition: "linear",
				time: 1
			});
			
			Tweener.addTween(this.ball1Mc, {
				y: 70,
				transition: "easeOutQuad",
				time: 0.5
			});
			
			Tweener.addTween(this.ball1Mc, {
				y: 190,
				transition: "easeInQuad",
				time: 0.5,
				delay: 0.5
			});
		}
		
		private function onRestart2BtnClick(e:MouseEvent) {
			Tweener.removeTweens(this.ball2Mc);
			
			this.ball2Mc.x = 280;
			this.ball2Mc.y = 190;
			
			Tweener.addTween(this.ball2Mc, {
				x: 400,
				transition: "easeInSine",
				time: 1
			});
			
			Tweener.addTween(this.ball2Mc, {
				y: 70,
				transition: "easeOutSine",
				time: 1
			});
		}
	}
}
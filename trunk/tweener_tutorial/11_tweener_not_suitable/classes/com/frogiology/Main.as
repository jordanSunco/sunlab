package com.frogiology {
	import caurina.transitions.Tweener;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class Main extends Sprite {	
		
		private const NUM_CIRCLE:Number = 500;
		
		public var containerMc:MovieClip;
		
		private var circleArr:Array;
		
		public function Main() {
			this.circleArr = new Array();
			
			for (var i:int = 0; i < NUM_CIRCLE; i++) {
				var circleMc:MovieClip = new CircleMc();
				
				this.containerMc.addChild(circleMc);
				this.circleArr.push(circleMc);
				
				circleMc.x = Math.random() * stage.width;
				circleMc.y = Math.random() * stage.height;
				
				circleMc.gotoAndStop(Math.floor(Math.random() * 3) + 1);
			}
			
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, this.onMouseWheel);
		}
		
		private function onMouseWheel(e:MouseEvent) {
			for (var i:int = 0; i < this.circleArr.length; i++) {
				var circleMc:MovieClip = this.circleArr[i];
				
				Tweener.addTween(circleMc, {
					scaleX: circleMc.scaleX + e.delta / 20,
					scaleY: circleMc.scaleX + e.delta / 20,
					time: 1
				});
			}
		}
	}
}
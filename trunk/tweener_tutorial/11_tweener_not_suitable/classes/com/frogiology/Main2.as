package com.frogiology {
	import caurina.transitions.Tweener;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class Main2 extends Sprite {	
		
		private const NUM_CIRCLE:Number = 500;
		
		public var containerMc:MovieClip;
		
		private var circleArr:Array;
		private var targetScale:Number;
		
		public function Main2() {
			this.targetScale = 1;
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
			stage.addEventListener(Event.ENTER_FRAME, this.handleEnterFrame);
		}
		
		private function handleEnterFrame(e:Event) {
			for (var i:int = 0; i < this.circleArr.length; i++) {
				var circleMc:MovieClip = this.circleArr[i];
				
				circleMc.scaleX += (this.targetScale - circleMc.scaleX) / 10;
				circleMc.scaleY += (this.targetScale - circleMc.scaleY) / 10;
			}
		}
		
		private function onMouseWheel(e:MouseEvent) {
			this.targetScale += e.delta / 20;
		}
	}
}
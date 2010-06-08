package com.frogiology {
	import caurina.transitions.Tweener;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class Main extends Sprite {	
		
		public var secHandMc:MovieClip;
		public var clockBgMc:MovieClip;
		
		public function Main() {
			//set timer
			var timer:Timer = new Timer(1000);
			timer.addEventListener(TimerEvent.TIMER, this.onTimerUpdate);
			timer.start();
			
			this.clockBgMc.addEventListener(MouseEvent.MOUSE_OVER, this.onClockBgOver);
			this.clockBgMc.addEventListener(MouseEvent.MOUSE_OUT, this.onClockBgOut);
		}
		
		private function onTimerUpdate(e:TimerEvent) {
			Tweener.addTween(this.secHandMc, {
				rotation: this.secHandMc.rotation + 6,
				time: 0.75,
				transition: "easeOutElastic"
			});
		}
		
		private function onClockBgOver(e:MouseEvent) {
			Tweener.addTween(this.clockBgMc, {
				scaleX: 1.2,
				scaleY: 1.2,
				time: 1,
				transition: "easeOutElastic"
			});
		}
		
		private function onClockBgOut(e:MouseEvent) {
			Tweener.addTween(this.clockBgMc, {
				scaleX: 1,
				scaleY: 1,
				time: 0.5,
				transition: "easeOutBack"
			});
		}
	}
}
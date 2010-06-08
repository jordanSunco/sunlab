package com.frogiology {
	import caurina.transitions.Tweener;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	
	public class Main extends Sprite {	
		
		public var logoMc:MovieClip;
		
		private var blurFilter:BlurFilter;
		
		public function Main() {
			
			this.blurFilter = new BlurFilter(50, 50);
			
			this.logoMc.buttonMode = true;
			this.logoMc.filters = [this.blurFilter];
			
			this.logoMc.addEventListener(MouseEvent.MOUSE_OVER, this.onLogoMcOver);
			this.logoMc.addEventListener(MouseEvent.MOUSE_OUT, this.onLogoMcOut);
		}
		
		private function onLogoMcOver(e:MouseEvent) {
			Tweener.addTween(this.blurFilter, {
				blurX: 0,
				blurY: 0,
				time: 1,
				transition: "easeOutCubic",
				onUpdate: this.onBlurFilterUpdate
			});
		}
		
		private function onLogoMcOut(e:MouseEvent) {
			Tweener.addTween(this.blurFilter, {
				blurX: 100,
				blurY: 100,
				time: 1,
				transition: "easeOutCubic",
				onUpdate: this.onBlurFilterUpdate
			});
		}
		
		private function onBlurFilterUpdate() {
			this.logoMc.filters = [this.blurFilter];
		}
	}
}
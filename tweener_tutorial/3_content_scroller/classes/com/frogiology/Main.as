package com.frogiology {
	import caurina.transitions.Tweener;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class Main extends Sprite {	
		
		public var nav1Btn:SimpleButton;
		public var nav2Btn:SimpleButton;
		public var nav3Btn:SimpleButton;
		public var nav4Btn:SimpleButton;
		
		public var contentMc:MovieClip;
		
		public function Main() {
			nav1Btn.addEventListener(MouseEvent.CLICK, this.onNavBtnClick);
			nav2Btn.addEventListener(MouseEvent.CLICK, this.onNavBtnClick);
			nav3Btn.addEventListener(MouseEvent.CLICK, this.onNavBtnClick);
			nav4Btn.addEventListener(MouseEvent.CLICK, this.onNavBtnClick);
		}
		
		private function onNavBtnClick(e:MouseEvent) {
			var targetPos:Point = new Point();
			
			//a bit hardcode here...
			switch (e.target.name) {
				case "nav1Btn":
					targetPos.x = 0;
					targetPos.y = 0;
					break;
				case "nav2Btn":
					targetPos.x = -480;
					targetPos.y = 0;
					break;
				case "nav3Btn":
					targetPos.x = 0;
					targetPos.y = -250;
					break;
				case "nav4Btn":
					targetPos.x = -480;
					targetPos.y = -250;
					break;
			}
			
			Tweener.addTween(this.contentMc, {
				x: targetPos.x,
				y: targetPos.y,
				time: 1
			});
		}
	}
}
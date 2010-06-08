package com.frogiology {
	import caurina.transitions.Tweener;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class Main extends Sprite {
		public var mc1:MovieClip;
		public var mc2:MovieClip;
		
		private var offset:Point;
		
		public function Main() {
			mc1.buttonMode = true;
			mc1.addEventListener(MouseEvent.MOUSE_DOWN, this.onMc1MouseDown);
			mc1.addEventListener(MouseEvent.MOUSE_UP, this.onMc1MouseUp);
			
			mc2.buttonMode = true;
			mc2.addEventListener(MouseEvent.MOUSE_DOWN, this.onMc2MouseDown);
		}
		
		//for mc1
		private function onMc1MouseDown(e:MouseEvent) {
			mc1.startDrag();
		}
		
		private function onMc1MouseUp(e:MouseEvent) {
			mc1.stopDrag();
		}
		
		//for mc2
		private function onMc2MouseDown(e:MouseEvent) {
			stage.addEventListener(MouseEvent.MOUSE_MOVE, this.onMc2MouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, this.onMc2MouseUp);
			
			this.offset = new Point(-this.mc2.mouseX, -this.mc2.mouseY);
		}
		
		private function onMc2MouseMove(e:MouseEvent) {
			//use tweener
			Tweener.addTween(mc2, {
				x: this.mouseX + this.offset.x,
				y: this.mouseY + this.offset.y,
				time: 1
			});
		}
		
		private function onMc2MouseUp(e:MouseEvent) {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.onMc2MouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,this.onMc2MouseUp);
		}
	}
}
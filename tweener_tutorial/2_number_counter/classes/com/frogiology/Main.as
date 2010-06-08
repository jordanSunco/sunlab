package com.frogiology {
	import caurina.transitions.Tweener;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class Main extends MovieClip {	
		
		public var countBtn:SimpleButton;
		public var numberTxt:TextField;
		
		//must be declared as public as Tweener to access
		public var tempNum:int;
		
		public function Main() {
			this.tempNum = 0;
			
			countBtn.addEventListener(MouseEvent.CLICK,this.onCountBtnClick);
		}
		
		private function onCountBtnClick(e:MouseEvent) {
			var targetNum:int = Math.floor(Math.random() * 100000);
			
			Tweener.addTween(this, {
				tempNum: targetNum,
				time: 5,
				transition: "easeOutCubic",
				rounded:true, //round the number
				onUpdate: this.updateNumberTxt
			});
		}
		
		private function updateNumberTxt() {
			this.numberTxt.text = this.padLeft(this.tempNum.toString(),"0",6);
		}
		
		private function padLeft(inStr:String,padChar:String,finalLength:Number):String {
			var result:String = "";
			
			for (var i:Number=0;i<finalLength - inStr.length;i++) {
				result += padChar;
			}
			
			return result + inStr;
		}
		
	}
}
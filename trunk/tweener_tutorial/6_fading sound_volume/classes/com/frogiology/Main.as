package com.frogiology {
	import caurina.transitions.Tweener;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	public class Main extends Sprite {	
		
		public var soundBtn:MovieClip;
		
		private var isSoundOn:Boolean;
		private var soundObj:Sound;
		private var soundChannel:SoundChannel;
		private var soundTranform:SoundTransform;
		
		public var tempVolume:Number;
		
		public function Main() {
			this.isSoundOn = false;
			
			this.tempVolume = 0;
			this.soundBtn.gotoAndStop("OFF");
			
			//sound obj
			this.soundObj = new BgSound();
			this.soundChannel = soundObj.play(0,int.MAX_VALUE);
			
			//sound transform
			this.soundTranform = new SoundTransform();
			this.soundTranform.volume = 0;
			
			//sound channel
			this.soundChannel.soundTransform = this.soundTranform;
			
			this.soundBtn.buttonMode = true;
			this.soundBtn.addEventListener(MouseEvent.CLICK,this.onSoundBtnClick);
		}
		
		private function onSoundBtnClick(e:MouseEvent) {
			var targetVolume:Number;
			
			if (isSoundOn) {
				targetVolume = 0;
				
				this.soundBtn.gotoAndStop("OFF");
			}
			else {
				targetVolume = 1;
				
				this.soundBtn.gotoAndStop("ON");
			}
			
			Tweener.addTween(this, {
				tempVolume: targetVolume,
				time: 2,
				transition: "easeOutQuad",
				onUpdate: onUpdateVolume
			});
			
			isSoundOn = !isSoundOn;
		}
		
		private function onUpdateVolume() {
			this.soundTranform.volume = this.tempVolume;
			this.soundChannel.soundTransform = this.soundTranform;
		}
	}
}
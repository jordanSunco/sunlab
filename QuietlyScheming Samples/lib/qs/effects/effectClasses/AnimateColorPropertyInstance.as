package qs.effects.effectClasses
{
	import mx.effects.effectClasses.TweenEffectInstance;
	import mx.core.mx_internal;
	import qs.utils.ColorUtils;
	
	use namespace mx_internal;
		
	public class AnimateColorPropertyInstance extends TweenEffectInstance
	{
		public function AnimateColorPropertyInstance(target:Object)
		{
			super(target);
		}
		public var property:String;
		public var toValue:Number;
		public var fromValue:Number;
		public var isStyle:Boolean = false;
		
		private var fromHSV:Object;
		private var toHSV:Object;
			
		override public function play():void
		{
			// Do what effects normally do when they start, namely
			// dispatch an 'effectStart' event from the target.
			super.play();

			fromHSV = ColorUtils.RGBToHSV(fromValue);
			toHSV = ColorUtils.RGBToHSV(toValue);			
			// Create a Tween 
			tween = /*mx_internal::*/createTween(this, 0, 1, duration);
	
			// If the caller supplied their own easing equation, override the
			// one that's baked into Tween.
			if (easingFunction != null)
				tween.easingFunction = easingFunction;
	
			onTweenUpdate(Number(tween.mx_internal::getCurrentValue(0)));
		}
		
		
		/**
		 * @private
		 */
		override public function onTweenUpdate(value:Object):void
		{
			var newHSV:Object = {
				h: fromHSV.h + (toHSV.h - fromHSV.h)*Number(value),
				s: fromHSV.s + (toHSV.s - fromHSV.s)*Number(value),
				v: fromHSV.v + (toHSV.v - fromHSV.v)*Number(value)			
			}
			var rgb:Number = ColorUtils.HSVToRGB(newHSV);
			if(isStyle)
				target.setStyle(property,rgb);
			else
				target[property] = rgb;
		}

	}
	
}
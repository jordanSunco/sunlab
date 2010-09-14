package qs.effects
{
	import mx.effects.TweenEffect;
	import mx.effects.EffectInstance;
	import qs.effects.effectClasses.AnimateColorPropertyInstance;
	
	public class AnimateColorProperty extends TweenEffect
	{
		public function AnimateColorProperty (target:Object = null)
		{
			super(target);
			
			instanceClass = AnimateColorPropertyInstance;
		}
		public var isStyle:Boolean = false;
		public var toValue:Number;
		public var property:String;
		public var fromValue:Number;			
		override public function getAffectedProperties():Array /* of String */
		{
			return [ property ];
		}
	
		override protected function initInstance(instance:EffectInstance):void
		{
			super.initInstance(instance);
			
			var animatePropertyInstance:AnimateColorPropertyInstance =
				AnimateColorPropertyInstance(instance);
	
			animatePropertyInstance.fromValue = fromValue;
			animatePropertyInstance.isStyle = isStyle;
			animatePropertyInstance.toValue = toValue;
			animatePropertyInstance.property = property;
		}	
	}
}



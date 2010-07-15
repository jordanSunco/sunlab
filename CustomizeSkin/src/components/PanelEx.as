package components
{
	import mx.containers.Panel;
	
	[Style(name="headerCapColor", type="uint", format="Color", inherit="no")]
    [Style(name="headerCapHeight", type="Number", format="Length", inherit="no")]
	
	public class PanelEx extends Panel
	{
		public function PanelEx()
		{
			super();
		}
		
		override protected function getHeaderHeight():Number
		{
			var headerCapHeight:int = getStyle("headerCapHeight");
			var headerHeight:int = isNaN(getStyle("headerHeight")) ? 26 : getStyle("headerHeight");
			return headerHeight + headerCapHeight;
		}
		
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);
			var headerCapHeight:int = getStyle("headerCapHeight");
			var headerHeight:int = isNaN(getStyle("headerHeight")) ? 26 : getStyle("headerHeight");
			var borderThickness:int = getStyle("borderThickness");
			if(titleTextField)
			{
				titleTextField.y = headerCapHeight + (headerHeight - borderThickness * 2 - titleTextField.textHeight)/2;
			}
		} 
		
	}
}
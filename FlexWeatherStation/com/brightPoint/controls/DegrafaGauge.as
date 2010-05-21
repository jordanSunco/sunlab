/*
Gauge Component v.04 7/28/08

Copyright (c) 2008, Thomas W. Gonzalez

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

www.brightpointinc.com

Additional modifications made by Roger Webster, including major tick value labels and
specific support for several types of "weather gauges," including wind speed, wind
direction, temperature and related items like humidity.  Also added "Durango-enablement."

*/		
package com.brightPoint.controls {	
	import com.brightPoint.controls.gauge.GaugeSkin;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.filters.BitmapFilter;
	import flash.filters.DropShadowFilter;
	
	import mx.core.IFlexDisplayObject;
	import mx.core.IInvalidating;
	import mx.core.IProgrammaticSkin;
	import mx.core.UIComponent;
	import mx.effects.Rotate;
	import mx.events.EffectEvent;
	import mx.formatters.NumberFormatter;
	import mx.styles.ISimpleStyleClient;

	/** faceSkin
	 * The skin class for the background of the gauge. The default class
	 * is gauge.GaugeSkin.
	 */
	[Style(name="faceSkin", type="Class", inherit="no")]
	
	/** highlightSkin
	 * The skin class for the indicator indicatorCrown. The default class is
	 * is gauge.GaugeSkin.
	 */
	[Style(name="highlightSkin", type="Class", inherit="no")]
	
	/** lowValueSkin
	 * The skin class for the high water marker. The default class is
	 * is gauge.GaugeSkin.
	 */
	[Style(name="lowValueSkin", type="Class", inherit="no")]
	
	/** highValueSkin
	 * The skin class for the high water marker. The default class is
	 * is gauge.GaugeSkin.
	 */
	[Style(name="highValueSkin", type="Class", inherit="no")]
	
	/** indicatorSkin
	 * The skin class for the indicator. The default class is
	 * is gauge.GaugeSkin.
	 */
	[Style(name="indicatorSkin", type="Class", inherit="no")]
	
	/** indicatorSkin
	 * The skin class for the indicator. The default class is
	 * is gauge.GaugeSkin.
	 */
	[Style(name="secondaryIndicatorSkin", type="Class", inherit="no")]
	
	/** labelBorderSkin
	 * The skin class for the label border. The default class is
	 * is gauge.GaugeSkin.
	 */
	[Style(name="labelBorderSkin", type="Class", inherit="no")]
	
	/** gaugeCaptionSkin
	 * The skin class for the gauge caption. The default class is
	 * is gauge.GaugeSkin.
	 */
	[Style(name="gaugeCaptionSkin", type="Class", inherit="no")]
	
	/** gaugeValueSkin
	 * The skin class for the gauge value. The default class is
	 * is gauge.GaugeSkin.
	 */
	[Style(name="gaugeValueSkin", type="Class", inherit="no")]
	
	/** indicatorCrownSkin
	 * The skin class for the indicator center. The default class is
	 * is gauge.GaugeSkin.
	 */
	[Style(name="indicatorCrownSkin", type="Class", inherit="no")]
	
	/** faceColor
	 * The color for the background of the frame. Default: white
	 */
	[Style(name="faceColor", type="Number", format="Color", inherit="no")]
	
	/** backgroundAlpha
	 * The transparency of the background of the frame. Default: 1
	 */
	[Style(name="backgroundAlpha", type="Number", inherit="no")]
	
	/** indicatorColor
	 * The color of the indicator. Default: black
	 */
	[Style(name="indicatorColor", type="Number", format="Color", inherit="no")]
	
	/** indicatorColor
	 * The color of the indicator. Default: black
	 */
	[Style(name="secondaryIndicatorColor", type="Number", format="Color", inherit="no")]
	
	/** highValueColor
	 * The color of the high water marker. Default: black
	 */
	[Style(name="highValueColor", type="Number", format="Color", inherit="no")]
	
	/** lowValueColor
	 * The color of the low water marker. Default: black
	 */
	[Style(name="lowValueColor", type="Number", format="Color", inherit="no")]
	
	/** indicatorCrownColor
	 * The color of the indicator indicatorCrown. Default: dark gray
	 */
	[Style(name="indicatorCrownColor", type="Number", format="Color", inherit="no")]
	
	/** measureMarksColor
	 * The color of the tick marks around the gauge:. Default: white
	 */
	[Style(name="measureMarksColor", type="Number", format="Color", inherit="no")]
	
	/** measureMarksAlpha
	 * The alpha of the tick marks around the gauge:. Default: 1
	 */
	[Style(name="measureMarksAlpha", type="Number", inherit="no")]	
	
	/** bezelColor
	 * The color of the rim around the gauge. Default: dark gray
	 */
	[Style(name="bezelColor", type="Number", format="Color", inherit="no")]
	
	/** bezelColor
	 * The color of the rim around the gauge. Default: dark gray
	 */
	[Style(name="captionColor", type="Number", format="Color", inherit="no")]
	
	/** bezelColor
	 * The color of the rim around the gauge. Default: dark gray
	 */
	[Style(name="valueColor", type="Number", format="Color", inherit="no")]
	
	/** bezelColor
	 * The color of the rim around the gauge. Default: dark gray
	 */
	[Style(name="markLabelsColor", type="Number", format="Color", inherit="no")]
	
	/** indicatorFilter
	* The type of filter to apply to the indicator, setting NULL will result in no filter.
	* Default: true (shadow)
	*/
	[Style(name="indicatorFilter", type="flash.filters.BitmapFilter", inherit="no", default="flash.filters.DropShadowFilter")]	
	
	/** showLabel
	* Indicates whehter the value label is visible
	*/
	[Style(name="showLabel", type="Boolean", inherit="no", default="true")]
	
	/** labelStyleName
	* Indicates the style name of the value label
	*/
	[Style(name="labelStyleName", type="String", inherit="no")]
	
	/** gaugeStyle
	* Indicates the style name of the value label
	*/
	[Style(name="gaugeStyle", type="String", inherit="no")]
	
	/** useBounceEffect 
	* Indicates if gauge will use Bounce.easeOut easing effect
	*/
	[Style(name="useBounceEffect", type="Boolean", inherit="no", default="true")]
	
	/** alertValues
	* Values used to create sequential alert ranges
	*/
	[Style(name="alertValues", type="Array", inherit="no", default="[]")]
	
	/** alertColors
	* Colors used to create sequential alert ranges
	*/
	[Style(name="alertColors", type="Array", inherit="no", default="[]")]
	
	/** alertAlphas
	* Alphas used to create sequential alert ranges
	*/
	[Style(name="alertAlphas", type="Array", inherit="no", default="[]")]
	
	
	
	
	public class DegrafaGauge extends UIComponent {		
		
		public static const SCALE_LINEAR 						: String = "linear";
		public static const SCALE_LOG 							: String = "log";
	        
		public static const SpeedAutoScaleType 			: String = "SpeedAutoScale";
		public static const CompassType 						: String = "Compass";
		public static const PlusMinusAutoScaleType 	: String = "PlusMinusAutoScale";
		public static const BasicGaugeType 					: String = "BasicGauge";
			
		   
		/**
		 * PROPERTIES
		 *
		 * When a property is set, its value is copied to the class variable (eg,
		 * _value) and then invalidateDisplayList is called. This allows the Flex framework
		 * to call updateDisplayList at the proper time. For example, it is possible
		 * to set a property before there are any graphics present; calling updateDisplayList
		 * then would lead to an error.
		 */
		 
		private var _bezelColor : String = "AAAAAA";
		private var _faceColor : String = "333333";
		private var _pointerColor : String = "FC5976";
		private var _secondaryPointerColor : String = "EEEE00";
		private var _crownColor : String = "AAAAAA";
		private var _marksColor : String = "FFFFFF";
		private var _captionColor : String = "EEEEEE";
		private var _markLabelsColor : String = "EEEEEE";
		private var _valueColor : String = "EEEEEE";
		
		
		[Editable(noBind,type="Color",Name="Bezel Color",Value="AAAAAA")]
		[Persistent]
		public function set BezelColor (c : String) : void {
			_bezelColor = c;
			setStyle("bezelColor", "#"+c);
		}
		public function get BezelColor () : String {
			return _bezelColor;
		}
		
		[Editable(noBind,type="Color",Name="Face Color",Value="333333")]
		[Persistent]
		public function set FaceColor (c : String) : void {
			_faceColor = c;
			setStyle("faceColor", "#"+c);
		}
		public function get FaceColor () : String {
			return _faceColor;
		}
		
		[Editable(noBind,type="Color",Name="Pointer Color",Value="FC5976")]
		[Persistent]
		public function set PointerColor (c : String) : void {
			_pointerColor = c;
			setStyle("indicatorColor", "#"+c);
		}
		public function get PointerColor () : String {
			return _pointerColor;
		}
		
		[Editable(noBind,type="Color",Name="Secondary Pointer Color",Value="EEEE00")]
		[Persistent]
		public function set SecondaryPointerColor (c : String) : void {
			_secondaryPointerColor = c;
			setStyle("secondaryIndicatorColor", "#"+c);
		}
		public function get SecondaryPointerColor () : String {
			return _secondaryPointerColor;
		}
		
		[Editable(noBind,type="Color",Name="Crown Color",Value="333333")]
		[Persistent]
		public function set CrownColor (c : String) : void {
			_crownColor = c;
			setStyle("indicatorCrownColor", "#"+c);
		}
		public function get CrownColor () : String {
			return _crownColor;
		}
		
		[Editable(noBind,type="Color",Name="Marks Color",Value="FFFFFF")]
		[Persistent]
		public function set MarksColor (c : String) : void {
			_marksColor = c;
			setStyle("measureMarksColor", "#"+c);
		}
		public function get MarksColor () : String {
			return _marksColor;
		}
		
		[Editable(noBind,type="Color",Name="Caption Color",Value="CCCCCC")]
		[Persistent]
		public function set CaptionColor (c : String) : void {
			_captionColor = c;
			setStyle("captionColor", "#"+c);
		}
		public function get CaptionColor () : String {
			return _captionColor;
		}
		
		[Editable(noBind,type="Color",Name="Value Color",Value="DDDDDD")]
		[Persistent]
		public function set ValueColor (c : String) : void {
			_valueColor = c;
			setStyle("valueColor", "#"+c);
		}
		public function get ValueColor () : String {
			return _valueColor;
		}
		
		[Editable(noBind,type="Color",Name="Mark Labels Color",Value="EEEEEE")]
		[Persistent]
		public function set markLabelsColor (c : String) : void {
			_markLabelsColor = c;
			setStyle("markLabelsColor", "#"+c);
		}
		public function get markLabelsColor () : String {
			return _markLabelsColor;
		}
		/*				
		[Editable(noBind,type="Color",Name="Bezel Color")]
		[Persistent]
		MarksAlpha
		
		[Editable(noBind,type="Color",Name="Bezel Color")]
		[Persistent]
		LabelAlpha
		*/
		 
		private var showHigh : Boolean = false;
		
		private var theCaption : String = "";
		
		[Persistent]
		[Editable(Name="Caption")]
		[Bindable]
		public function set caption (s : String) : void {
			theCaption = s;
		}
		
		public function get caption () : String {
			return theCaption;
		}
	
		[Persistent]
		public function set showHighMark (b : Boolean) : void {
			showHigh = b;
		}
		
		public function get showHighMark () : Boolean {
			return showHigh;
		}
		 
		private var showLow : Boolean = false;
	
		[Persistent]
		public function set showLowMark (b : Boolean) : void {
			showLow = b;
		}
		
		public function get showLowMark () : Boolean {
			return showLow;
		}
		 
		private var showSecondary : Boolean = false;
	
		[Persistent]
		public function set showSecondaryIndicator (b : Boolean) : void {
			showSecondary = b;
		}
		
		public function get showSecondaryIndicator () : Boolean {
			return showSecondary;
		}
	
		[Persistent]
		public function set startAngle (v : Number) : void {
			_minimumAngle = v;
		}
		
		public function get startAngle () : Number {
			return _minimumAngle;
		}
		
		[Persistent]
		public function set endAngle (v : Number) : void {
			_maximumAngle = v;
		}
		
		public function get endAngle () : Number {
			return _maximumAngle;
		}
		
		/***
		* value
		* 
		* The value of the gauge; guaranteed to be between the minimum
		* and maximum values.
		*/
		private var _value : Number = 0;
		
		[Bindable(event="valueChanged")]
		[AutoConnect(sink)]
		public function get value () : Number {
			return _value;
		}
		
		public function set value (n : Number) : void {
			if (isNaN(n))
				return;
				
			_value = n;
			if (gaugeType == CompassType) {
				_value += 180;
			}
			
			if (minimum > n) {
				n /= 10;
				n = Math.round(n);
				n *= 10;
				n -= 10;
				minimum = n;
			}
			
			n = _value;
			if (maximum < n) {
				n /= 10;
				n = Math.round(n);
				n *= 10;
				n += 10;
				maximum = n;
			}
			
			invalidateDisplayList();
			dispatchEvent(new Event("valueChanged"));
		}
		
		/***
		* value
		* 
		* The value of the gauge; guaranteed to be between the minimum
		* and maximum values.
		*/
		private var _secondaryValue : Number = 0;
		
		[Bindable(event="secondaryValueChanged")]
		[AutoConnect(sink)]
		public function get secondaryValue () : Number {
			return _secondaryValue;
		}
		
		public function set secondaryValue (n : Number) : void {
			if (isNaN(n))
				return;
				
			showSecondary = true;
				
			_secondaryValue = n;
			if (gaugeType == CompassType) {
				_secondaryValue += 180;
			}
			
			if (minimum > n) {
				n /= 10;
				n = Math.round(n);
				n *= 10;
				n -= 10;
				minimum = n;
			}
			
			n = _secondaryValue;
			if (maximum < n) {
				n /= 10;
				n = Math.round(n);
				n *= 10;
				n += 10;
				maximum = n;
			}
			
			invalidateDisplayList();
			dispatchEvent(new Event("secondaryValueChanged"));
		}


		private var _highValue : Number = 0;
		
		[Bindable(event="highValueChanged")]
		public function get highValue () : Number {
			return _highValue;
		}
		
		private var autoScaleMarks : Boolean = true;
		
		[Persistent]
		[Editable(noBind,Name="Auto Scale",type=Boolean)]
		public function set autoScale (b : Boolean) : void {
			autoScaleMarks = b;
		}
		public function get autoScale () : Boolean {
			return autoScaleMarks;
		}
		
		public function set highValue (n : Number) : void {
			showHigh = true;
			_highValue = n;
			if (gaugeType == SpeedAutoScaleType) {
				if (n < 30)
					maximum = 30;
				else if (n < 50)
					maximum = 50;
				else if (n < 100)
					maximum = 100;
				else maximum = 200;
			} else if (gaugeType == PlusMinusAutoScaleType) {
				if (n < 90)
					maximum = 100;
				else if (n < 100)
					maximum = 120;
				else maximum = 150;
			}
			
			invalidateDisplayList();
			dispatchEvent(new Event("highValueChanged"));
		}


		private var _lowValue : Number = 0;
		
		[Bindable(event="lowValueChanged")]
		public function get lowValue () : Number {
			return _lowValue;
		}
		
		public function set lowValue (n : Number) : void {
			showLow = true;
			_lowValue = n;
			
			if (gaugeType == PlusMinusAutoScaleType) {
				if (n > 10)
					minimum = 0;
				else if (n > -30)
					minimum = -40;
				else if (n > -60)
					minimum = -80;
				else minimum = -150;
			}
			
			invalidateDisplayList();
			dispatchEvent(new Event("lowValueChanged"));
		}
		
		/***
		* minimumAngle
		*/
		private var _minimumAngle : Number = 30;
		
		/***
		* maximumAngle
		*/
		private var _maximumAngle : Number = 330;
		
		   
		
		/***
		* minimum
		* 
		* The smallest allowed value for the gauge; default=0.
		*/
		private var _minimum : Number = 0;
		
		[Bindable]
		[Persistent]
		[Editable(noBind,Name="Minimum")]
		public function get minimum () : Number { return _minimum; }
		
		public function set minimum (n : Number ) : void {
			_minimum = n;
			invalidateDisplayList();
		}
		
		/***
		* maximum
		* 
		* The largest allowed value for the gauge; default=100. The maximum
		* value is mapped to the 4 o'clock position.
		*/
		public var _maximum : Number = 150;
		    
		private var gaugeKind : String = SpeedAutoScaleType;
		
		[Editable(noBind,Name="Gauge Type")]
		[Persistent]
		public function set gaugeType (v : String) : void {
			gaugeKind = v;
			invalidateDisplayList();
		}
		
		public function get gaugeType () : String {
			return gaugeKind;
		}
		
		[Bindable]
		[Persistent]
		[Editable(noBind,Name="Maximum")]
		public function get maximum () : Number 	{ return _maximum}
			
		public function set maximum (n : Number) : void {
			_maximum = n;
			
			if (faceSkin != null) {
	    	switch (gaugeType) {
	    		case SpeedAutoScaleType:
	    			if (n > 50)
	    				GaugeSkin(faceSkin).setSpeedLabels(1);
	    			else
	    				GaugeSkin(faceSkin).setSpeedLabels(0);
	    			break;
	    			
	    		case CompassType:
	    			GaugeSkin(faceSkin).setSpeedLabels(3);
	    			break;
	    			
	    		case BasicGaugeType:
	    			GaugeSkin(faceSkin).setSpeedLabels(1);
	    			break;
	    	}
	    }
		    
			invalidateDisplayList();
		}
	
		public var formatterPrecision : Number = -1;
		
		[Bindable]
		[Persistent]
		[Editable(nobind,Name="Precision")]
		public function set precision (v : Number) : void {
			formatterPrecision = v;
			
			if (labelFormatter == null && formatterPrecision >= 0) {
				labelFormatter = new NumberFormatter();
				labelFormatter.rounding = "nearest";
				labelFormatter.precision = formatterPrecision;
			}
		}
		
		public function get precision () : Number {
			return formatterPrecision;
		}
		
	  private var labelFormatter:NumberFormatter;
		
		[Bindable]
		[Persistent]
		public function get valueScale () : String {
			return _valueScale;
		}
	
		public function set valueScale (value : String) : void {
			_valueScale=value;
			this.regenerateStyleCache(true);
		}
		
		private var _valueScale:String=SCALE_LINEAR;
		
		/** PROTECTED Variables
		 */
		
		// Variables holding the skin instances
		protected var faceSkin 										: IFlexDisplayObject;
		protected var highlightSkin 							: IFlexDisplayObject;
		protected var indicatorSkin 							: IFlexDisplayObject;
		protected var secondaryIndicatorSkin 			: IFlexDisplayObject;
		protected var highValueSkin 							: IFlexDisplayObject;
		protected var lowValueSkin 								: IFlexDisplayObject;
		protected var indicatorCrownSkin 					: IFlexDisplayObject;
		protected var indicatorFilter 						: BitmapFilter;
		protected var labelBorderSkin							: IFlexDisplayObject;
		protected var gaugeCaptionSkin						: IFlexDisplayObject;
		protected var gaugeValueSkin							: IFlexDisplayObject;
	
		
		// Single Rotate effect used to move the indicator.
		private var rotate : Rotate;
		private var secondaryRotate : Rotate;
		private var rotateHighValue : Rotate;
		private var rotateLowValue : Rotate;
		
		/***
		 * Constructor
		 * 
		 */
		public function DegrafaGauge () { 
			super();
		}
		
		override public function set styleName (value : Object) : void {
			super.styleName=value;
		}
		
		override public function regenerateStyleCache (recursive : Boolean) : void {
			super.regenerateStyleCache(recursive);
			
			if (this.numChildren > 0) {  //This is expensive, but we want to refresh the skins by removing all children and starting over
				for (var i : int = this.numChildren - 1; i >= 0; i--) {
					this.removeChildAt(i);
				}
				
				this.createChildren();
				this.invalidateDisplayList();
			}
		}
		
		private var suffix : String = "";
		
		[Persistent]
		[Editable(noBind,Name="Units Suffix")]
		public function set unitsSuffix (s : String) : void {
			suffix = s;
		}
		
		public function get unitsSuffix () : String {
			return suffix;
		}
		
		override public function set height (value : Number) : void {
			diameter = value;
		}
		
		override public function set width (value : Number) : void {
			diameter = value;
		}
		
		public function set diameter (value : Number) : void {
			super.width = value;
			super.height = value;
		}
		
		[Bindable]
		[Persistent]
		public function get diameter () : Number { return width; }
		
		/***
		 * createChildren
		 * 
		 * This method is invoked by the Flex framework when it is time for
		 * the component to create any children. In this case, it is time
		 * to create the skins.
		 */
		override protected function createChildren () : void {
			super.createChildren();
			indicatorFilter = new DropShadowFilter();			
			
			faceSkin  = createSkin( "faceSkin", com.brightPoint.controls.gauge.GaugeSkin ); 
			addChild(DisplayObject(faceSkin));
			gaugeCaptionSkin = createSkin( "gaugeCaptionSkin", com.brightPoint.controls.gauge.GaugeSkin ); 
			addChild(DisplayObject(gaugeCaptionSkin));
			gaugeValueSkin = createSkin( "gaugeValueSkin", com.brightPoint.controls.gauge.GaugeSkin ); 
			addChild(DisplayObject(gaugeValueSkin));
			secondaryIndicatorSkin = createSkin( "secondaryIndicatorSkin", com.brightPoint.controls.gauge.GaugeSkin ); 
			addChild(DisplayObject(secondaryIndicatorSkin));
			indicatorSkin = createSkin( "indicatorSkin", com.brightPoint.controls.gauge.GaugeSkin ); 
			addChild(DisplayObject(indicatorSkin));
			highValueSkin = createSkin( "highValueSkin", com.brightPoint.controls.gauge.GaugeSkin ); 
			addChild(DisplayObject(highValueSkin));
			lowValueSkin = createSkin( "lowValueSkin", com.brightPoint.controls.gauge.GaugeSkin ); 
			addChild(DisplayObject(lowValueSkin));
			indicatorCrownSkin  = createSkin( "indicatorCrownSkin", com.brightPoint.controls.gauge.GaugeSkin );
			addChild(DisplayObject(indicatorCrownSkin));
			highlightSkin = createSkin( "highlightSkin", com.brightPoint.controls.gauge.GaugeSkin ); 
			addChild(DisplayObject(highlightSkin));
			labelBorderSkin = createSkin( "labelBorderSkin", com.brightPoint.controls.gauge.GaugeSkin ); 
			addChild(DisplayObject(labelBorderSkin));
			
			rotate = new Rotate(indicatorSkin);
			secondaryRotate = new Rotate(secondaryIndicatorSkin);
		}
		
		/***
		 * createSkin
		 * 
		 * Creates the given skin. The skin will either have been specified
		 * by the skin style or, if not present, the skin will default to
		 * the one given.
		 * 
		 */
		protected function createSkin (skinName : String, defaultSkin : Class ) : IFlexDisplayObject {
			// Look up the skin by its name to see if it is already created. Note
			// below where addChild() is called; this makes getChildByName possible.
			
			var newSkin : IFlexDisplayObject = IFlexDisplayObject(getChildByName(skinName));
				
			// if the skin needs to be created it will be null...
			
			if (newSkin == null) {
				// Attempt to get the class for the skin. If one has not been supplied
				// by a style, use the default skin.
				
				var newSkinClass : Class = Class(getStyle(skinName));
				if(newSkinClass == null) 
					newSkinClass = defaultSkin;
				
				if (newSkinClass != null) {
					// Create an instance of the class.
					newSkin = IFlexDisplayObject(new newSkinClass());
					if (newSkin == null) 
						newSkin = new defaultSkin();
					
					// Set its name so that we can find it in the future
					// using getChildByName().
					newSkin.name = skinName;
	
					// Make the getStyle() calls in the skin class find the styles
					// for this Gauge instance. In other words, by setting the styleName
					// to 'this' it allows the skin to query the component for styles. For
					// example, when the skin code does getStyle('backgroundColor') it 
					// retrieves the style from this Gauge and not from the skin.
					var styleableSkin : ISimpleStyleClient = newSkin as ISimpleStyleClient;
					if (styleableSkin != null)
						styleableSkin.styleName = this;
						
					// If the skin is programmatic, and we've already been
	        // initialized, update it now to avoid flicker.
	        if (newSkin is IInvalidating) { 
	        	IInvalidating(newSkin).validateNow();
	        }
	        else if (newSkin is IProgrammaticSkin && initialized) {
	        	IProgrammaticSkin(newSkin).validateDisplayList()
	        }
					
				}
			}
			
			return newSkin;
		}
		
		/***
		 * measure
		 * 
		 * Define the default size of the component. Here the minimum size
		 * will be 50x50.
		 */
		 
		override protected function measure () : void {
	    super.measure();
	
	    measuredWidth = measuredMinWidth = 50;
	    measuredHeight = measuredMinHeight = 50;
		}
		
		// This component uses a RotateEffect to position the indicator; _prevAngle
		// holds the last known value.
		private var _prevAngle : Number = 0;
		private var _secondaryPrevAngle : Number = 0;
	    
    /***
    * updateDisplayList
    * 
    * Draws the skin and its elements. This method is called by the Flex 2 framework
    * at the appropriate time. Never call this method directly. You can indicate the
    * need for it to be called by using invalidateDisplayList().
    */
		override protected function updateDisplayList (unscaledWidth : Number, unscaledHeight : Number) : void {
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			
			var lv : Number = value;
			if (gaugeType == CompassType) {
				lv += 180;
				if (lv > 360)
					lv -= 360;
			}
			
			var s : String = "";
			
			if (labelFormatter != null)
				s = labelFormatter.format(lv);
			else
				s = String(lv);
				
			s += unitsSuffix;
			
			
			GaugeSkin(gaugeCaptionSkin).caption = caption;
			GaugeSkin(gaugeValueSkin).gaugeValue = s;
			
			if (gaugeType == CompassType)
				GaugeSkin(gaugeValueSkin).yOffsetMultiplier = 0.4;
		 			
			var indicatorDropShadowEnabled : Object = getStyle("indicatorDropShadowEnabled");
		
			faceSkin.setActualSize(unscaledWidth, unscaledHeight);
			indicatorSkin.setActualSize(unscaledWidth, unscaledHeight);
			secondaryIndicatorSkin.setActualSize(unscaledWidth, unscaledHeight);
			highValueSkin.setActualSize(unscaledWidth, unscaledHeight);
			lowValueSkin.setActualSize(unscaledWidth, unscaledHeight);
			indicatorCrownSkin.setActualSize(unscaledWidth, unscaledHeight);
			highlightSkin.setActualSize( unscaledWidth, unscaledHeight);
			labelBorderSkin.setActualSize( unscaledWidth, unscaledHeight);
			gaugeCaptionSkin.setActualSize( unscaledWidth, unscaledHeight);
			gaugeValueSkin.setActualSize( unscaledWidth, unscaledHeight);
			
			if (indicatorFilter != null) {
				//indicatorFilter=new DropShadowFilter(diameter/100,45,0,.4,diameter/66,diameter/66);
				DisplayObject(indicatorSkin).filters = [indicatorFilter];
				DisplayObject(secondaryIndicatorSkin).filters = [indicatorFilter];
		    DisplayObject(indicatorCrownSkin).filters= [indicatorFilter];
		    DisplayObject(highValueSkin).filters= [indicatorFilter];
		    DisplayObject(lowValueSkin).filters= [indicatorFilter];
		  }
		    
		  // adjust the value to make sure it is within bounds.
			if (_value < _minimum) _value = _minimum;
			if (_value > _maximum) _value = _maximum;
			
			// determine the angle of the indicator based on the current
			// value and minimum and maximum values.
			var angle : Number = calculateAngleFromValue(_value);
			
			// Use a Rotate effect to spin the indicator from its previous
			// position.
		
			if (rotate.isPlaying) {
				rotate.addEventListener(EffectEvent.EFFECT_END, rotate_onEnd);
				return;	
			}
                     
			if (gaugeType == CompassType) {
   			var pa : int = _prevAngle - 180;
   			var na : int = angle - 180;
   
   			if ((pa < 90 && na > 270) || (pa > 270 && na < 90)) {                      
  				if (pa > 180)
     				pa = pa - 360;
     
  				if (na > 180) {
     				na = na - 360;
     				if (na > 0)
            	na -= 360;
  				}
   			}
   
   			_prevAngle = pa + 180;
   			angle = na + 180;
			}
		
			rotate.angleFrom = _prevAngle;
    	rotate.angleTo = angle;
    	rotate.originX = 0;
    	rotate.originY = 0;
    	rotate.duration = 2000;
    	rotate.play();
    	
    	highValueSkin.rotation = calculateAngleFromValue(highValue);
    	lowValueSkin.rotation = calculateAngleFromValue(lowValue);
		
			_prevAngle = angle;		
			
			angle = calculateAngleFromValue(_secondaryValue);
		
			if (secondaryRotate.isPlaying) {
				secondaryRotate.addEventListener(EffectEvent.EFFECT_END, rotate_onEnd);
				return;	
			}
		
			secondaryRotate.angleFrom = _secondaryPrevAngle;
    	secondaryRotate.angleTo = angle;
    	secondaryRotate.originX = 0;
    	secondaryRotate.originY = 0;
    	secondaryRotate.duration = 2000;
    	secondaryRotate.play();
    	
    	_secondaryPrevAngle = angle;
		}
	    
    private function rotate_onEnd (e : Event) : void {
    	rotate.removeEventListener(EffectEvent.EFFECT_END, rotate_onEnd);
    	invalidateDisplayList();
    }
	            
    /***
    * calculateAngleFromValue
    * 
    * Determines the angle of the indicator based on the value
    * and minimum and maximum properties.
    * 
    * Note: it is tempting to put the two statements of this function
    * directly into the updateDisplayList function. However, should someone
    * want to extend this class, they can use this method to do the same
    * calculation from the extended class' updateDisplayList.
    */
    public function calculateAngleFromValue (v : Number) : Number {
    	var max : Number = GaugeSkin(faceSkin).calculateUsableMaximum();
    	if (max == 0)
    		max = _maximum;
    	
    	var ratio : Number = (v - _minimum) / (max  -_minimum); //percentage value
    	
    	if (valueScale == SCALE_LOG) {       		
    		//On less than 1 values set to 1 otherwise log function gets out-of-whack.
    		if (v < 1) 
    			v = 1;      		
    			
    		var computedMaximum : Number = Math.ceil(Math.log(max) / Math.LN10);
    		var computedMinimum : Number = Math.floor(Math.log(_minimum) / Math.LN10);
    		
    		ratio = (Math.log(v) * Math.LOG10E) / (computedMaximum - computedMinimum);
      }
 
 			var angle : Number = (_maximumAngle - _minimumAngle) * ratio + _minimumAngle;  
 		
    	return angle;
    }
		
		// Control dynamic reusability...
		private var r : Boolean = true;
		
		public function get reusable () : Boolean {
			return r;
		}
		
		public function set reusable (b : Boolean) : void {
			r = b;
		}     
		
	}
}
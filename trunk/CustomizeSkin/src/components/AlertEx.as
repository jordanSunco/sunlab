
package components
{

import flash.display.Sprite;
import flash.events.Event;
import flash.events.EventPhase;

import mx.core.Application;
import mx.core.EdgeMetrics;
import mx.core.FlexVersion;
import mx.core.IFlexDisplayObject;
import mx.core.UIComponent;
import mx.core.mx_internal;
import mx.events.CloseEvent;
import mx.events.FlexEvent;
import mx.managers.ISystemManager;
import mx.managers.PopUpManager;
import mx.resources.IResourceManager;
import mx.resources.ResourceManager;

use namespace mx_internal;

//--------------------------------------
//  Styles
//--------------------------------------

/**
 *  Name of the CSS style declaration that specifies 
 *  styles for the AlertEx buttons. 
 * 
 *  @default "alertButtonStyle"
 */
[Style(name="buttonStyleName", type="String", inherit="no")]

/**
 *  Name of the CSS style declaration that specifies
 *  styles for the AlertEx message text. 
 *
 *  <p>You only set this style by using a type selector, which sets the style 
 *  for all AlertEx controls in your application.  
 *  If you set it on a specific instance of the AlertEx control, it can cause the control to 
 *  size itself incorrectly.</p>
 * 
 *  @default undefined
 */
[Style(name="messageStyleName", type="String", inherit="no")]

/**
 *  Name of the CSS style declaration that specifies styles
 *  for the AlertEx title text. 
 *
 *  <p>You only set this style by using a type selector, which sets the style 
 *  for all AlertEx controls in your application.  
 *  If you set it on a specific instance of the AlertEx control, it can cause the control to 
 *  size itself incorrectly.</p>
 * 
 *  @default "windowStyles" 
 */
[Style(name="titleStyleName", type="String", inherit="no")]

[Style(name="headerCapColor", type="Color", format="uint", inherit="no")]
[Style(name="headerCapHeight", type="Number", format="uint", inherit="no")]

//--------------------------------------
//  Other metadata
//--------------------------------------

[AccessibilityClass(implementation="mx.accessibility.AlertAccImpl")]

[RequiresDataBinding(true)]

[ResourceBundle("controls")]
    
/**
 *  The AlertEx control is a pop-up dialog box that can contain a message,
 *  a title, buttons (any combination of OK, Cancel, Yes, and No) and an icon. 
 *  The AlertEx control is modal, which means it will retain focus until the user closes it.
 *
 *  <p>Import the mx.controls.AlertEx class into your application, 
 *  and then call the static <code>show()</code> method in ActionScript to display
 *  an AlertEx control. You cannot create an AlertEx control in MXML.</p>
 *
 *  <p>The AlertEx control closes when you select a button in the control, 
 *  or press the Escape key.</p>
 *
 *  @includeExample examples/SimpleAlertEx.mxml
 *
 *  @see mx.managers.SystemManager
 *  @see mx.managers.PopUpManager
 */
public class AlertEx extends PanelEx
{

    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    /**
     *  Value that enables a Yes button on the AlertEx control when passed
     *  as the <code>flags</code> parameter of the <code>show()</code> method.
     *  You can use the | operator to combine this bitflag
     *  with the <code>OK</code>, <code>CANCEL</code>,
     *  <code>NO</code>, and <code>NONMODAL</code> flags.
     */
    public static const YES:uint = 0x0001;
    
    /**
     *  Value that enables a No button on the AlertEx control when passed
     *  as the <code>flags</code> parameter of the <code>show()</code> method.
     *  You can use the | operator to combine this bitflag
     *  with the <code>OK</code>, <code>CANCEL</code>,
     *  <code>YES</code>, and <code>NONMODAL</code> flags.
     */
    public static const NO:uint = 0x0002;
    
    /**
     *  Value that enables an OK button on the AlertEx control when passed
     *  as the <code>flags</code> parameter of the <code>show()</code> method.
     *  You can use the | operator to combine this bitflag
     *  with the <code>CANCEL</code>, <code>YES</code>,
     *  <code>NO</code>, and <code>NONMODAL</code> flags.
     */
    public static const OK:uint = 0x0004;
    
    /**
     *  Value that enables a Cancel button on the AlertEx control when passed
     *  as the <code>flags</code> parameter of the <code>show()</code> method.
     *  You can use the | operator to combine this bitflag
     *  with the <code>OK</code>, <code>YES</code>,
     *  <code>NO</code>, and <code>NONMODAL</code> flags.
     */
    public static const CANCEL:uint= 0x0008;

    /**
     *  Value that makes an AlertEx nonmodal when passed as the
     *  <code>flags</code> parameter of the <code>show()</code> method.
     *  You can use the | operator to combine this bitflag
     *  with the <code>OK</code>, <code>CANCEL</code>,
     *  <code>YES</code>, and <code>NO</code> flags.
     */
    public static const NONMODAL:uint = 0x8000;

    //--------------------------------------------------------------------------
    //
    //  Class mixins
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     *  Placeholder for mixin by AlertExAccImpl.
     */
    mx_internal static var createAccessibilityImplementation:Function;

    //--------------------------------------------------------------------------
    //
    //  Class variables
    //
    //--------------------------------------------------------------------------

	/**
	 *  @private
	 *  Storage for the resourceManager getter.
	 *  This gets initialized on first access,
	 *  not at static initialization time, in order to ensure
	 *  that the Singleton registry has already been initialized.
	 */
	private static var _resourceManager:IResourceManager;
	
	/**
	 *  @private
     *  A reference to the object which manages
     *  all of the application's localized resources.
     *  This is a singleton instance which implements
     *  the IResourceManager interface.
	 */
	private static function get resourceManager():IResourceManager
	{
		if (!_resourceManager)
			_resourceManager = ResourceManager.getInstance();

		return _resourceManager;
	}
	
	/**
	 *  @private
	 */
	private static var initialized:Boolean = false;
	
    //--------------------------------------------------------------------------
    //
    //  Class properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  buttonHeight
    //----------------------------------

    [Inspectable(category="Size")]

    /**
     *  Height of each AlertEx button, in pixels.
     *  All buttons must be the same height.
     *
     *  @default 22
     */
    public static var buttonHeight:Number = 22;
    
    //----------------------------------
    //  buttonWidth
    //----------------------------------

    [Inspectable(category="Size")]

    /**
     *  Width of each AlertEx button, in pixels.
     *  All buttons must be the same width.
     *
     *  @default 60
     */
    public static var buttonWidth:Number = FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0 ? 60 : 65;
    
    //----------------------------------
    //  cancelLabel
    //----------------------------------
    
    /**
	 *  @private
	 *  Storage for the cancelLabel property.
	 */
	private static var _cancelLabel:String;
	
    /**
	 *  @private
	 */
	private static var cancelLabelOverride:String;

    [Inspectable(category="General")]

    /**
     *  The label for the Cancel button.
     *
     *  <p>If you use a different label, you may need to adjust the 
     *  <code>buttonWidth</code> property to fully display it.</p>
     *
     *  The English resource bundle sets this property to "CANCEL". 
     */
	public static function get cancelLabel():String
	{
		initialize();
		
		return _cancelLabel;
	}

	/**
	 *  @private
	 */
	public static function set cancelLabel(value:String):void
	{
		cancelLabelOverride = value;

		_cancelLabel = value != null ?
					   value :
					   resourceManager.getString(
					       "controls", "cancelLabel");
	}
    
    //----------------------------------
    //  noLabel
    //----------------------------------
    
    /**
	 *  @private
	 *  Storage for the noLabel property.
	 */
	private static var _noLabel:String;
	
    /**
	 *  @private
	 */
	private static var noLabelOverride:String;

    [Inspectable(category="General")]

    /**
     *  The label for the No button.
     *
     *  <p>If you use a different label, you may need to adjust the 
     *  <code>buttonWidth</code> property to fully display it.</p>
     *
     *  The English resource bundle sets this property to "NO". 
     */
	public static function get noLabel():String
	{
		initialize();
		
		return _noLabel;
	}

	/**
	 *  @private
	 */
	public static function set noLabel(value:String):void
	{
		noLabelOverride = value;

		_noLabel = value != null ?
				   value :
				   resourceManager.getString(
				      "controls", "noLabel");
	}

    //----------------------------------
    //  okLabel
    //----------------------------------

    /**
	 *  @private
	 *  Storage for the okLabel property.
	 */
	private static var _okLabel:String;
	
    /**
	 *  @private
	 */
	private static var okLabelOverride:String;

    [Inspectable(category="General")]

    /**
     *  The label for the OK button.
     *
     *  <p>If you use a different label, you may need to adjust the 
     *  <code>buttonWidth</code> property to fully display the label.</p>
     *
     *  The English resource bundle sets this property to "OK". 
     */
	public static function get okLabel():String
	{
		initialize();
		
		return _okLabel;
	}

	/**
	 *  @private
	 */
	public static function set okLabel(value:String):void
	{
		okLabelOverride = value;

		_okLabel = value != null ?
				   value :
				   resourceManager.getString(
				       "controls", "okLabel");
	}

    //----------------------------------
    //  yesLabel
    //----------------------------------
    
    /**
	 *  @private
	 *  Storage for the yesLabel property.
	 */
	private static var _yesLabel:String;
	
    /**
	 *  @private
	 */
	private static var yesLabelOverride:String;

    [Inspectable(category="General")]

    /**
     *  The label for the Yes button.
     *
     *  <p>If you use a different label, you may need to adjust the 
     *  <code>buttonWidth</code> property to fully display the label.</p>
     *
     *  The English resource bundle sets this property to "YES". 
     */
	public static function get yesLabel():String
	{
		initialize();
		
		return _yesLabel;
	}

	/**
	 *  @private
	 */
	public static function set yesLabel(value:String):void
	{
		yesLabelOverride = value;

		_yesLabel = value != null ?
					value :
					resourceManager.getString(
						"controls", "yesLabel");
	}

    //--------------------------------------------------------------------------
    //
    //  Class methods
    //
    //--------------------------------------------------------------------------

    /**
     *  Static method that pops up the AlertEx control. The AlertEx control 
     *  closes when you select a button in the control, or press the Escape key.
     * 
     *  @param text Text string that appears in the AlertEx control. 
     *  This text is centered in the alert dialog box.
     *
     *  @param title Text string that appears in the title bar. 
     *  This text is left justified.
     *
     *  @param flags Which buttons to place in the AlertEx control.
     *  Valid values are <code>AlertEx.OK</code>, <code>AlertEx.CANCEL</code>,
     *  <code>AlertEx.YES</code>, and <code>AlertEx.NO</code>.
     *  The default value is <code>AlertEx.OK</code>.
     *  Use the bitwise OR operator to display more than one button. 
     *  For example, passing <code>(AlertEx.YES | AlertEx.NO)</code>
     *  displays Yes and No buttons.
     *  Regardless of the order that you specify buttons,
     *  they always appear in the following order from left to right:
     *  OK, Yes, No, Cancel.
     *
     *  @param parent Object upon which the AlertEx control centers itself.
     *
     *  @param closeHandler Event handler that is called when any button
     *  on the AlertEx control is pressed.
     *  The event object passed to this handler is an instance of CloseEvent;
     *  the <code>detail</code> property of this object contains the value
     *  <code>AlertEx.OK</code>, <code>AlertEx.CANCEL</code>,
     *  <code>AlertEx.YES</code>, or <code>AlertEx.NO</code>.
     *
     *  @param iconClass Class of the icon that is placed to the left
     *  of the text in the AlertEx control.
     *
     *  @param defaultButtonFlag A bitflag that specifies the default button.
     *  You can specify one and only one of
     *  <code>AlertEx.OK</code>, <code>AlertEx.CANCEL</code>,
     *  <code>AlertEx.YES</code>, or <code>AlertEx.NO</code>.
     *  The default value is <code>AlertEx.OK</code>.
     *  Pressing the Enter key triggers the default button
     *  just as if you clicked it. Pressing Escape triggers the Cancel
     *  or No button just as if you selected it.
     *
     *  @return A reference to the AlertEx control. 
     *
     *  @see mx.events.CloseEvent
     */
    public static function show(text:String = "", title:String = "",
                                flags:uint = 0x4 /* AlertEx.OK */, 
                                parent:Sprite = null, 
                                closeHandler:Function = null, 
                                iconClass:Class = null, 
                                defaultButtonFlag:uint = 0x4 /* AlertEx.OK */):AlertEx
    {
        var modal:Boolean = (flags & AlertEx.NONMODAL) ? false : true;

        if (!parent)
        {
            var sm:ISystemManager = ISystemManager(Application.application.systemManager);
            if (sm.useSWFBridge())
                parent = Sprite(sm.getSandboxRoot());
            else
                parent = Sprite(Application.application);
        }
        
        var alert:AlertEx = new AlertEx();

        if (flags & AlertEx.OK||
            flags & AlertEx.CANCEL ||
            flags & AlertEx.YES ||
            flags & AlertEx.NO)
        {
            alert.buttonFlags = flags;
        }
        
        if (defaultButtonFlag == AlertEx.OK ||
            defaultButtonFlag == AlertEx.CANCEL ||
            defaultButtonFlag == AlertEx.YES ||
            defaultButtonFlag == AlertEx.NO)
        {
            alert.defaultButtonFlag = defaultButtonFlag;
        }
        
        alert.text = text;
        alert.title = title;
        alert.iconClass = iconClass;
            
        if (closeHandler != null)
            alert.addEventListener(CloseEvent.CLOSE, closeHandler);

		// Setting a module factory allows the correct embedded font to be found.
        if (parent is UIComponent)
        	alert.moduleFactory = UIComponent(parent).moduleFactory;
        	
        PopUpManager.addPopUp(alert, parent, modal);

        alert.setActualSize(alert.getExplicitOrMeasuredWidth(),
                            alert.getExplicitOrMeasuredHeight());
        alert.addEventListener(FlexEvent.CREATION_COMPLETE, static_creationCompleteHandler);
        
        return alert;
    }

	/**
	 *  @private    
     */
	private static function initialize():void
	{
		if (!initialized)
		{
			// Register as a weak listener for "change" events
			// from ResourceManager.
			resourceManager.addEventListener(
				Event.CHANGE, static_resourceManager_changeHandler,
				false, 0, true);

			static_resourcesChanged();

			initialized = true;
		}
	}

    /**
     *  @private    
     */
    private static function static_resourcesChanged():void
    {
		cancelLabel = cancelLabelOverride;
        noLabel = noLabelOverride;
		okLabel = okLabelOverride;
        yesLabel = yesLabelOverride;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Class event handlers
    //
    //--------------------------------------------------------------------------

    /**
	 *  @private
	 */
	private static function static_resourceManager_changeHandler(
									event:Event):void
	{
		static_resourcesChanged();
	}

 
    /**
     *  @private
     */
    private static function static_creationCompleteHandler(event:FlexEvent):void
    {
        if (event.target is IFlexDisplayObject && event.eventPhase == EventPhase.AT_TARGET)
        {
            event.target.removeEventListener(FlexEvent.CREATION_COMPLETE, static_creationCompleteHandler);
            PopUpManager.centerPopUp(IFlexDisplayObject(event.target));
        }
    }
    
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     */
    public function AlertEx()
    {
        super();

        // Panel properties.
        title = "";
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden properties
    //
    //--------------------------------------------------------------------------

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  alertForm
    //----------------------------------
    
    /**
     *  @private
     *  The internal AlertExForm object that contains the text, icon, and buttons
     *  of the AlertEx control.
     */
    private var alertForm:AlertFormEx;

    //----------------------------------
    //  buttonFlags
    //----------------------------------

    /**
     *  A bitmask that contains <code>AlertEx.OK</code>, <code>AlertEx.CANCEL</code>, 
     *  <code>AlertEx.YES</code>, and/or <code>AlertEx.NO</code> indicating
	 *  the buttons available in the AlertEx control.
     *
     *  @default AlertEx.OK
     */
    public var buttonFlags:uint = OK;
    
    //----------------------------------
    //  defaultButtonFlag
    //----------------------------------

    [Inspectable(category="General")]

    /**
     *  A bitflag that contains either <code>AlertEx.OK</code>, 
     *  <code>AlertEx.CANCEL</code>, <code>AlertEx.YES</code>, 
     *  or <code>AlertEx.NO</code> to specify the default button.
     *
     *  @default AlertEx.OK
     */
    public var defaultButtonFlag:uint = OK;
    
    //----------------------------------
    //  iconClass
    //----------------------------------

    [Inspectable(category="Other")]

    /**
     *  The class of the icon to display.
     *  You typically embed an asset, such as a JPEG or GIF file,
     *  and then use the variable associated with the embedded asset 
     *  to specify the value of this property.
     *
     *  @default null
     */
    public var iconClass:Class;
    
    //----------------------------------
    //  text
    //----------------------------------

    [Inspectable(category="General")]
    
    /**
     *  The text to display in this alert dialog box.
     *
     *  @default ""
     */
    public var text:String = "";
    
    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    override protected function initializeAccessibility():void
    {
        if (AlertEx.createAccessibilityImplementation != null)
            AlertEx.createAccessibilityImplementation(this);
    }

    /**
     *  @private
     */
    override protected function createChildren():void
    {
        super.createChildren();

        var messageStyleName:String = getStyle("messageStyleName");
        if (messageStyleName)
            styleName = messageStyleName;

        if (!alertForm)
        {   
            alertForm = new AlertFormEx();
            alertForm.styleName = this;
            addChild(alertForm);
        }
    }

    /**
     *  @private
     */
    override protected function measure():void
    {   
        super.measure();
        
        var m:EdgeMetrics = viewMetrics;
        
        // The width is determined by the title or the AlertExForm,
        // whichever is wider.
        measuredWidth = 
            Math.max(measuredWidth, alertForm.getExplicitOrMeasuredWidth() +
            m.left + m.right);
        
        measuredHeight = alertForm.getExplicitOrMeasuredHeight() +
                         m.top + m.bottom;
    }

    /**
     *  @private
     */
    override protected function updateDisplayList(unscaledWidth:Number,
                                                  unscaledHeight:Number):void
    {
        super.updateDisplayList(unscaledWidth, unscaledHeight);
        
        // Position the AlertExForm inside the "client area" of the Panel
        var vm:EdgeMetrics = viewMetrics;
        alertForm.setActualSize(unscaledWidth - vm.left - vm.right -
                                getStyle("paddingLeft") -
                                getStyle("paddingRight"),
                                unscaledHeight - vm.top - vm.bottom -
                                getStyle("paddingTop") -
                                getStyle("paddingBottom"));
    }

    /**
     *  @private
     */
    override public function styleChanged(styleProp:String):void
    {
        super.styleChanged(styleProp);
        
        if (styleProp == "messageStyleName")
        {
            var messageStyleName:String =
                getStyle("messageStyleName");

            styleName = messageStyleName;
        }
        
        if (alertForm)
            alertForm.styleChanged(styleProp);
    }

    /**
     *  @private
     */
	override protected function resourcesChanged():void
	{
		super.resourcesChanged();

		static_resourcesChanged();
	}
}

}

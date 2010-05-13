////////////////////////////////////////////////////////////////////////////////
//
//  (c) Arc90, Inc.
//  http://www.arc90.com
//  http://lab.arc90.com
//  Licensed under : Creative Commons Attribution 2.5 http://creativecommons.org/licenses/by/2.5/
//
////////////////////////////////////////////////////////////////////////////////

package com.arc90.containers
{
import com.arc90.skins.ShuffleCardBorderSkin;
import com.arc90.skins.ShuffleCardHeaderSkin;
	
import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.MouseEvent;

import mx.containers.Canvas;
import mx.controls.Button;
import mx.core.ClassFactory;
import mx.core.Container;
import mx.core.IFactory;
import mx.events.ChildExistenceChangedEvent;
import mx.events.DataGridEvent;
import mx.skins.halo.AccordionHeaderSkin;
import mx.styles.CSSStyleDeclaration;
import mx.styles.IStyleClient;
import mx.styles.StyleManager;

/**
 * Point to the style definition that determines the appearance
 * of individual card headers.
 */
[Style(name="headerStyleName", type="String", inherits="no")]

[Exclude]
/**
 * The ShuffleCard class is used by the ShuffleStack as wrappers
 * for all of it's internal content children.
 */
public class ShuffleCard extends Canvas
{
	//--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------
  
  	/**
  	 * @private
  	 */
  	private static const DEFAULT_HEADER_HEIGHT:int = 22;
  	
    /**
     *  @private
     *  Header name.
     */
    private static const HEADER_NAME:String = "_header";

	//--------------------------------------------------------------------------
    //
    //  Class variables
    //
    //--------------------------------------------------------------------------
    
	/**
	 * @private
	 */
	private static var classConstructed:Boolean = constructClass();
	
    //--------------------------------------------------------------------------
    //
    //  Class methods
    //
    //--------------------------------------------------------------------------

	/**
	 * @private
	 */
	private static function constructClass():Boolean
	{
		var styleDecl:CSSStyleDeclaration;
			
		styleDecl = new CSSStyleDeclaration();
		styleDecl.setStyle("disabledSkin", ShuffleCardHeaderSkin);
		styleDecl.setStyle("downSkin", ShuffleCardHeaderSkin);
		styleDecl.setStyle("fillAlphas", [1,1]);
		styleDecl.setStyle("fontSize", 10);
		styleDecl.setStyle("fontWeight", "bold");
		styleDecl.setStyle("horizontalGap", 2);
		styleDecl.setStyle("overSkin", ShuffleCardHeaderSkin);
		styleDecl.setStyle("paddingLeft", 5);
		styleDecl.setStyle("paddingRight", 5);
		styleDecl.setStyle("selectedDisabledSkin", ShuffleCardHeaderSkin);
		styleDecl.setStyle("selectedDownSkin", ShuffleCardHeaderSkin);
		styleDecl.setStyle("selectedOverSkin", ShuffleCardHeaderSkin);
		styleDecl.setStyle("selectedUpSkin", ShuffleCardHeaderSkin);
		styleDecl.setStyle("textAlign", "left");
		styleDecl.setStyle("upSkin", ShuffleCardHeaderSkin);
		StyleManager.setStyleDeclaration(".shuffleCardHeaderStyle", styleDecl, true);
		
		styleDecl = new CSSStyleDeclaration();
		styleDecl.setStyle("backgroundAlpha", 1);
		styleDecl.setStyle("backgroundColor", 0xFFFFFF);
		styleDecl.setStyle("borderSkin", ShuffleCardBorderSkin);
		styleDecl.setStyle("borderStyle", "solid");
		styleDecl.setStyle("dropShadowEnabled", true);
		styleDecl.setStyle("headerStyleName", "shuffleCardHeaderStyle");
		styleDecl.setStyle("shadowDirection", "left");
		StyleManager.setStyleDeclaration("ShuffleCard", styleDecl, true);
	
		return true;
	}
	
    //--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 * The child content container.
	 */
	private var content:Container;
	
	/**
	 * @private
	 * The interactive header for this container.
	 */
	private var header:Button;
	
	/**
     *  @private
     *  Storage for the headerRenderer property.
     */
    private var headerRenderer:IFactory;
    
    //--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function ShuffleCard()
	{
		super();
		
		headerRenderer = new ClassFactory(Button);
		
		addEventListener(ChildExistenceChangedEvent.CHILD_ADD, childAddHandler);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
		
    //----------------------------------
    //  prop
    //----------------------------------
        
    //--------------------------------------------------------------------------
	//
	//  Overidden Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	override protected function createChildren():void
	{
		super.createChildren();
		
		createHeader();
	}
	
	/**
	 * @private
	 */
	override public function getExplicitOrMeasuredHeight():Number
	{
		return super.getExplicitOrMeasuredHeight() + DEFAULT_HEADER_HEIGHT;
	}	
	
	/**
     *  @private
     */
    override public function styleChanged(styleProp:String):void
    {
        super.styleChanged(styleProp);

        if(!styleProp || styleProp == "styleName" ||
        	styleProp == "headerStyleName")
        {
            var headerStyleName:Object = getStyle("headerStyleName");
            if(headerStyleName)
            {
                var headerStyleDecl:CSSStyleDeclaration = 
                    StyleManager.getStyleDeclaration("." + headerStyleName);
                
                if(headerStyleDecl)
                {
                    if(header)
                    {
                        header.styleDeclaration = headerStyleDecl;
                        header.regenerateStyleCache(true);
                        header.styleChanged(null);
                    }
                }
            }
        }
    }
    
	/**
	 * @private
	 */
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
	{
		super.updateDisplayList(unscaledWidth, unscaledHeight);
		
		header.setActualSize(unscaledWidth, DEFAULT_HEADER_HEIGHT);
		header.move(0, 1 - DEFAULT_HEADER_HEIGHT);
	}
	
    //--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	private function createHeader():void
	{
		if(header)
			return;
			
		header = Button(headerRenderer.newInstance());
        header.name = HEADER_NAME;
        header.styleName = this;
        
        var headerStyleName:String = getStyle("headerStyleName"); 
        if (headerStyleName)
        {
            var headerStyleDecl:CSSStyleDeclaration = StyleManager.
                        getStyleDeclaration("." + headerStyleName);
                        
            if (headerStyleDecl)
                header.styleDeclaration = headerStyleDecl;
        }
        
        rawChildren.addChildAt(header, rawChildren.numChildren - 1);
                      
        header.addEventListener(MouseEvent.CLICK, headerClickHandler);
	}
	
	/**
	 * Return the internal content.
	 */
	public function getContent():Container
	{
		return content;	
	}
	
	/**
	 * Return the internal header.
	 */
	public function getHeader():Button
	{
		return header;	
	}
	
	/**
	 * Return the height of the internal header.
	 */
	public function getHeaderHeight():Number
	{
		if(header && header.height > 0)
			return header.height;
		
		return DEFAULT_HEADER_HEIGHT;	
	}
	
	//--------------------------------------------------------------------------
	//
	//  Event Handlers
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	private function childAddHandler(event:ChildExistenceChangedEvent):void
	{
		if(event.relatedObject is Container)
        {
        	content = Container(event.relatedObject);
        	
			content.addEventListener("labelChanged", labelChangedHandler);
	        content.addEventListener("iconChanged", iconChangedHandler);
	        			
			if(!header)
			{
	        	createHeader();
	  		}
	           
           	header.label = content.label;
            if (content.icon)
                header.setStyle("icon", content.icon);

            // If the child has a toolTip, transfer it to the header.
            var toolTip:String = content.toolTip;
            if (toolTip && toolTip != "")
            {
                header.toolTip = toolTip;
                content.toolTip = null;
            }
        }
	}	
		
	/**
	 * @private
	 */
	private function headerClickHandler(event:MouseEvent):void
	{
		dispatchEvent(new DataGridEvent(DataGridEvent.HEADER_RELEASE));
	}
							
    /**
     *  @private
     *  Handles "labelChanged" event.
     */
    private function labelChangedHandler(event:Event):void
    {
    	header.label = Container(event.target).label;
    }

    /**
     *  @private
     *  Handles "iconChanged" event.
     */
    private function iconChangedHandler(event:Event):void
    {
        header.setStyle("icon", Container(event.target).icon);
    }
}
}
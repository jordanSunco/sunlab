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
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.MouseEvent;

import mx.collections.ArrayCollection;
import mx.containers.Canvas;
import mx.containers.Panel;
import mx.containers.VBox;
import mx.containers.accordionClasses.AccordionHeader;
import mx.controls.Button;
import mx.core.ClassFactory;
import mx.core.Container;
import mx.core.EdgeMetrics;
import mx.core.IFactory;
import mx.core.IUIComponent;
import mx.core.ScrollPolicy;
import mx.core.UIComponent;
import mx.effects.Move;
import mx.effects.Parallel;
import mx.events.ChildExistenceChangedEvent;
import mx.events.DataGridEvent;
import mx.events.EffectEvent;
import mx.events.FlexEvent;
import mx.styles.CSSStyleDeclaration;
import mx.styles.IStyleClient;
import mx.styles.StyleManager;

/**
 *  Incremental padding start value for top and bottom.
 *  The default value is 15.
 */
[Style(name="childPaddingBottomTop", type="Number", inherit="no")]

/**
 *  Incremental padding start value for left and right.
 *  The default value is 15.
 */
[Style(name="childPaddingLeftRight", type="Number", inherit="no")]

/**
 *  Duration, in milliseconds, of the movement animation.
 *  The default value is 400.
 */
[Style(name="moveDuration", type="Number", format="Time", inherit="no")]

//--------------------------------------
//  Excluded APIs
//--------------------------------------

[Exclude(name="autoLayout", kind="property")]
[Exclude(name="clipContent", kind="property")]
[Exclude(name="defaultButton", kind="property")]
[Exclude(name="horizontalLineScrollSize", kind="property")]
[Exclude(name="horizontalPageScrollSize", kind="property")]
[Exclude(name="horizontalScrollBar", kind="property")]
[Exclude(name="horizontalScrollPolicy", kind="property")]
[Exclude(name="horizontalScrollPosition", kind="property")]
[Exclude(name="maxHorizontalScrollPosition", kind="property")]
[Exclude(name="maxVerticalScrollPosition", kind="property")]
[Exclude(name="verticalLineScrollSize", kind="property")]
[Exclude(name="verticalPageScrollSize", kind="property")]
[Exclude(name="verticalScrollBar", kind="property")]
[Exclude(name="verticalScrollPolicy", kind="property")]
[Exclude(name="verticalScrollPosition", kind="property")]

[Exclude(name="scroll", kind="event")]

[Exclude(name="bottom", kind="style")]
[Exclude(name="horizontalScrollBarStyleName", kind="style")]
[Exclude(name="left", kind="style")]
[Exclude(name="paddingBottom", kind="style")]
[Exclude(name="paddingLeft", kind="style")]
[Exclude(name="paddingRight", kind="style")]
[Exclude(name="paddingTop", kind="style")]
[Exclude(name="right", kind="style")]
[Exclude(name="top", kind="style")]
[Exclude(name="verticalScrollBarStyleName", kind="style")]

/**
 * The ShuffleStack creates a stack of children with the topmost child
 * being the selected child. Clicking on the header of any of the children
 * lower down in the stack will bring that child to the front of the stack.
 */
public class ShuffleStack extends Container
{
	//--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  Base for all card names (_card0 - _cardN).
     */
    private static const CARD_NAME_BASE:String = "_card";
    
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
		if(!StyleManager.getStyleDeclaration("ShuffleStack"))
		{
			var styleDecl:CSSStyleDeclaration = new CSSStyleDeclaration();
			styleDecl.setStyle("childPaddingBottomTop", 15);
			styleDecl.setStyle("childPaddingLeftRight", 15);
			styleDecl.setStyle("moveDuration", 400);
			StyleManager.setStyleDeclaration("ShuffleStack", styleDecl, true);
		}	
		return true;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------
		
    /**
     *  @private
     */
    private var focusedIndex:int = -1;
    
    /**
     * @private
     */
    private var childPaddingChanged:Boolean = false;
    
    /**
     * @private
     */
    private var defaultMoveDuration:int = 400;
    
	/**
	 * @private
	 */
	private var defaultPaddingBottomTop:int = 15;
	
	/**
	 * @private
	 */
	private var defaultPaddingLeftRight:int = 15;
	
	/**
	 * @private
	 * The navItem factory that creates all children.
	 */
	private var navItemFactory:IFactory;
	
	/**
	 * @private
	 * The movement effect for card shuffling. 
	 */
	private var parallel:Parallel = new Parallel();
		
	/**
     *  @private
     */
    private var showFocusIndicator:Boolean = false;
		 
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function ShuffleStack()
	{
		super();
		
		navItemFactory = new ClassFactory(ShuffleCard);
		
		addEventListener(ChildExistenceChangedEvent.CHILD_ADD, childAddHandler);
		addEventListener(ChildExistenceChangedEvent.CHILD_REMOVE, childRemoveHandler);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
    
    //----------------------------------
    //  horizontalScrollPolicy
    //----------------------------------

    [Inspectable(environment="none")]

    /**
     *  @private
     */
    override public function get horizontalScrollPolicy():String
    {
        return ScrollPolicy.OFF;
    }

    /**
     *  @private
     */
    override public function set horizontalScrollPolicy(value:String):void
    {
    }

	//----------------------------------
    //  selectedChild
    //----------------------------------

    [Bindable("valueCommit")]
    /**
     *  A reference to the currently visible child container.
     *  The default value is a reference to the first child.
     *  If there are no children, this property is <code>null</code>.
     *
     *  <p><b>Note:</b> You can only set this property in an ActionScript statement, 
     *  not in MXML.</p>
     */
    public function get selectedChild():Container
    {
        if (selectedIndex == -1)
            return null;

        return Container(getChildAt(selectedIndex));
    }

    /**
     *  @private
     */
    public function set selectedChild(value:Container):void
    {
    	var child:DisplayObject = findChild(value);
    	
    	if(!child)
    		return;
    		
        var newIndex:int = getChildIndex(child);

        if (newIndex >= 0 && newIndex < numChildren)
            selectedIndex = newIndex;
    }
	
	//----------------------------------
    //  selectedIndex
    //----------------------------------

    /**
     *  @private
     *  Storage for the selectedIndex and selectedChild properties.
     */
    private var _selectedIndex:int = -1;

    /**
     *  @private
     */
    private var proposedSelectedIndex:int = -1;

    [Bindable("valueCommit")]
    /**
     *  The zero-based index of the currently visible child container.
     *  Child indexes are in the range 0, 1, 2, ... , n - 1, where n is the number
     *  of children.
     *  The default value is 0, corresponding to the first child.
     *  If there are no children, this property is <code>-1</code>.
     *
     *  @default 0
     */
    public function get selectedIndex():int
    {
        if (proposedSelectedIndex != -1)
            return proposedSelectedIndex;

        return _selectedIndex;
    }

    /**
     *  @private
     */
    public function set selectedIndex(value:int):void
    {
        if (value == -1)
            return;
		
        if (value == _selectedIndex)
            return;

        proposedSelectedIndex = value;
        invalidateProperties();

        dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
    }
    
    //----------------------------------
    //  verticalScrollPolicy
    //----------------------------------

    [Inspectable(environment="none")]

    /**
     *  @private
     */
    override public function get verticalScrollPolicy():String
    {
        return ScrollPolicy.OFF;
    }

    /**
     *  @private
     */
    override public function set verticalScrollPolicy(value:String):void
    {
    }
    
	//--------------------------------------------------------------------------
	//
	//  Overidden Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	override public function addChildAt(child:DisplayObject, index:int):DisplayObject
	{
		if(!(child is Container))
			throw new Error(child + " is not an instance of mx.core.Container.");
			
		var card:DisplayObject = createCard(child, index);
		
		// Create the Card for the new child
		return super.addChildAt(card, index);	
	}
	
	/**
	 * @private
	 */
	override protected function commitProperties():void
	{
		super.commitProperties();
		
		commitSelectedIndex();
	}
	
	/**
	 * @private
	 */
	override public function removeChild(child:DisplayObject):DisplayObject
	{
		return super.removeChild(findChild(child as Container));
	}
	 
	/**
	 * @private
	 */
	override public function styleChanged(styleProp:String):void
	{
		super.styleChanged(styleProp);
		
		if(!styleProp ||
			styleProp == "childPaddingBottomTop" ||
			styleProp == "childPaddingLeftRight")
		{
			if(!isNaN(getStyle("childPaddingBottomTop")))
			{
				childPaddingChanged = true;
				invalidateDisplayList();		
			}
			
			if(!isNaN(getStyle("childPaddingLeftRight")))
			{
				childPaddingChanged = true;
				invalidateDisplayList();		
			}
		}	
	}
	
	/**
	 * @private
	 */
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
	{
		super.updateDisplayList(unscaledWidth, unscaledHeight);
		
		var bottomTop:int = isNaN(getStyle("childPaddingBottomTop")) 
							? defaultPaddingBottomTop 
							: getStyle("childPaddingBottomTop");
		var leftRight:int = isNaN(getStyle("childPaddingLeftRight"))
							? defaultPaddingLeftRight
							: getStyle("childPaddingLeftRight");		 
		 		
		for(var i:int = 0; i < numChildren; i++)
		{
			var child:UIComponent = UIComponent(getChildAt(i));
			
			if(childPaddingChanged)
			{
				var x:int = leftRight * i;
				var y:int = bottomTop * i;
		
				child.move(x, y + ShuffleCard(child).getHeaderHeight());
			}	
			
			var w:int = unscaledWidth - (leftRight * (numChildren - 1));
			var h:int = unscaledHeight - (ShuffleCard(child).getHeaderHeight() + bottomTop * (numChildren - 1));
			
			child.setActualSize(w, h);
		}
		
		childPaddingChanged = false;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	private function bringChildToFront(toFrontChild:DisplayObject):void
	{
		var move:Move;
		var secondaryMove:Move;
		var moves:Array = [];
		var child:DisplayObject;
		var prevChild:DisplayObject;
		var n:int = numChildren;
		var frontChild:DisplayObject = getChildAt(n - 1);
		var i:int = getChildIndex(frontChild);
				
		if(getChildIndex(toFrontChild) != n - 1)
		{
			// Move the selectedChild from it's current position
			// to the position of the topmost child in the stack
			move = new Move(toFrontChild);
			move.xTo = frontChild.x;
			move.yTo = frontChild.y;
			moves.push(move);
			
			secondaryMove = new Move(toFrontChild);
			secondaryMove.xTo = frontChild.x;
			
			// Loop through any children in front of the selectedChild
			// and move them to the position one deeper than its current
			// place in the stack
			for(i; i > getChildIndex(toFrontChild); i--)
			{
				child = getChildAt(i);
				prevChild = getChildAt(i - 1);
				
				move = new Move(child);
				move.xTo = prevChild.x;
				move.yTo = prevChild.y;
				moves.push(move);
			} 
			
			// Setup and Play the effect
			parallel.children = moves;
			parallel.duration = isNaN(getStyle("moveDuration")) 
								? defaultMoveDuration 
								: getStyle("moveDuration"); 
			parallel.play();
		}
		
		// Move the selectedChild to the top of the stack
		setChildIndex(getChildAt(_selectedIndex), numChildren - 1);
		
		// Set the selectedIndex to the topmost child
		_selectedIndex = numChildren - 1;	
	}
	
	/**
     *  @private
     */
    private function commitSelectedIndex():void
    {
        if (proposedSelectedIndex == -1)
            return;

        var newIndex:int = proposedSelectedIndex;
        proposedSelectedIndex = -1;

        // The selectedIndex must be undefined if there are no children,
        // even if a selectedIndex has been proposed.
        if (numChildren == 0)
        {
            _selectedIndex = -1;
            return;
        }

        // Ensure that the new index is in bounds.
        if (newIndex < 0)
            newIndex = 0;
        else if (newIndex > numChildren - 1)
            newIndex = numChildren - 1;

        // Remember the old index.
        var oldIndex:int = _selectedIndex;
		
        // Bail if the index isn't changing.
        if (newIndex == oldIndex)
            return;

        // Unfocus the old header.
        if (focusedIndex != newIndex)
           drawHeaderFocus(focusedIndex, false);

        // Deselect the old header.
        if (oldIndex != -1)
            getCardHeader(getChildAt(oldIndex)).selected = false;

        // Commit the new index.
        _selectedIndex = newIndex;

        // Select the new header.
        getCardHeader(getChildAt(newIndex)).selected = true;

		// Move the Children
		bringChildToFront(getChildAt(_selectedIndex));
		
        if (focusedIndex != newIndex)
        {
            // Focus the new header.
            focusedIndex = newIndex;
            drawHeaderFocus(focusedIndex, showFocusIndicator);
        }
    }
    
	/**
	 * @private
	 */
	private function createCard(content:DisplayObject, index:int):DisplayObject
	{
		// Create the parent container
		var card:Container = Container(navItemFactory.newInstance());
		card.name = CARD_NAME_BASE + numChildren;
		card.addChild(content);
		card.addEventListener(DataGridEvent.HEADER_RELEASE, headerReleaseHandler);
		
		return card;
	}
	
 	/**
     *  @private
     */
    private function drawHeaderFocus(headerIndex:int, isFocused:Boolean):void
    {
        if (headerIndex != -1)
            getCardHeader(getChildAt(headerIndex)).drawFocus(isFocused);
    }
	
	/**
	 * @private
	 */
	private function findChild(innerChild:Container):DisplayObject
	{
		for(var i:int = 0; i < numChildren; i++)
		{
			var child:Container = Container(getChildAt(i));
			
			if(child.contains(innerChild))
				return child as DisplayObject;
		}
		
		return null;	
	}

	/**
	 * @private
	 */
	private function findChildIndex(innerChild:Container):int
	{
		for(var i:int = 0; i < numChildren; i++)
		{
			var child:Container = Container(getChildAt(i));
			
			if(child.contains(innerChild))
				return i;
		}
		
		return -1;	
	}
	
	/**
	 * Returns the index of the supplied child.
	 * 
	 * @param child The content child to find.
	 */
	public function getContentIndex(child:DisplayObject):int
	{
		return findChildIndex(child as Container);
	}
		
	/**
	 * Returns the card at the specified index.
	 * 
	 * @param index The index of the child to find.
	 */
	public function getContentAt(index:int):DisplayObject
	{
		var card:DisplayObject = getChildAt(index);
		
		return DisplayObject(ShuffleCard(card).getContent());	
	}
	
	/**
     * Returns a reference to the navigator button for a child container.
     *
     * @param index Zero-based index of the child.
     */ 
    public function getCardHeader(child:DisplayObject):Button
    {
    	return ShuffleCard(child).getHeader();
    }
    
    /**
	 * Sets the value of <code>child</code> visibility to
	 * the value specified by <code>visible</code>.
	 * 
	 * @param child Content Child to show or hide
	 * 
	 * @param visible If <code>true</code>, the child is shown.
	 */
	public function setChildVisible(child:DisplayObject, visible:Boolean, noEvent:Boolean=false):void
	{
		var card:DisplayObject = findChild(child as Container);
		
		if(!card)
			return;
			
		UIComponent(card).setVisible(visible, noEvent);
	}  
    
    //--------------------------------------------------------------------------
    //
    //  Overidden event handlers
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */
    override protected function focusInHandler(event:FocusEvent):void
    {
        super.focusInHandler(event);
        
        showFocusIndicator = focusManager.showFocusIndicator;
    }

    /**
     *  @private
     */
    override protected function focusOutHandler(event:FocusEvent):void
    {
        super.focusOutHandler(event);
        
        showFocusIndicator = false;
    }
    
	//--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------
    
	/**
	 * @private
	 */
	private function childAddHandler(event:ChildExistenceChangedEvent):void
	{
		var child:UIComponent = UIComponent(event.relatedObject);
        var newIndex:int = numChildren - 1;
        var bottomTop:int = isNaN(getStyle("childPaddingBottomTop")) 
							? defaultPaddingBottomTop 
							: getStyle("childPaddingBottomTop");
		var leftRight:int = isNaN(getStyle("childPaddingLeftRight"))
							? defaultPaddingLeftRight
							: getStyle("childPaddingLeftRight");	
		        		
		// Set the selectedIndex to numChildren
		selectedIndex = newIndex;
		
		var x:int = leftRight * newIndex;
		var y:int = bottomTop * newIndex;
		
		child.move(x, y + ShuffleCard(child).getHeaderHeight());
	}
	
	/**
	 * @private
	 */
	private function childRemoveHandler(event:ChildExistenceChangedEvent):void
	{
		var child:UIComponent;
		var bottomTop:int = isNaN(getStyle("childPaddingBottomTop")) 
							? defaultPaddingBottomTop 
							: getStyle("childPaddingBottomTop");
		var leftRight:int = isNaN(getStyle("childPaddingLeftRight"))
							? defaultPaddingLeftRight
							: getStyle("childPaddingLeftRight");	
				
		for(var i:int = 0; i < numChildren; i++)
		{
			child = UIComponent(getChildAt(i));
			
			var x:int = leftRight * i;
			var y:int = bottomTop * i;
			
			child.move(x, y + ShuffleCard(child).getHeader().height);
		}
	}
	
	/**
	 * @private
	 */
	private function headerReleaseHandler(event:DataGridEvent):void
	{
		selectedIndex = getChildIndex(event.currentTarget as DisplayObject);
	}
}
}
package com.esri.tools
{
import com.esri.ags.Map;
import com.esri.ags.layers.Layer;
import com.esri.ags.toolbars.BaseToolbar;

import flash.display.Graphics;
import flash.display.Shape;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;

import mx.events.ResizeEvent;
import mx.managers.CursorManager;

/**
 * A spotlight masking tool for map layers.
 */
public class SpotlightTool extends BaseToolbar
{
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Creates a new instance of the spotlight tool.
	 * 
	 * @param map Map the toolbar is associated with.
	 */
	public function SpotlightTool( map:Map = null, layer:Layer = null )
	{
		super(map);
		
		this.layer = layer;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------
	
	private var _active:Boolean = false;
	private var _dragging:Boolean = false;
	private var _lastMouseLoc:Point;
	
	private var _radius:Number = 50;
	private var _layer:Layer;
	private var _mask:Shape;
	
	// Mouse cursor management
	private var _cursorID:int = -1;
	private var _currentCursor:Class;
	
	[Embed(source="com/esri/solutions/flexviewer/assets/images/spotlight/spotlight.png")]
	private var _spotlightIcon:Class;
	
	[Embed(source="com/esri/solutions/flexviewer/assets/images/spotlight/spacer.gif")]
	private var _spacerIcon:Class;
	
	
	//--------------------------------------------------------------------------
	//  Property:  map
	//--------------------------------------------------------------------------
	
	[Bindable("mapChanged")]
	/**
	 * Map the toolbar is associated with.
	 */
	override public function get map():Map {
		return super.map;
	}
	/**
	 * @private
	 */
	override public function set map( value:Map ):void {
		if (value != super.map) {
			var reactivate:Boolean = active;
			deactivate();
			
			super.map = value;
			
			if (reactivate) {
				activate();
			}
			
			dispatchEvent(new Event("mapChanged"));
		}
	}
	
	//--------------------------------------------------------------------------
	//  Property:  layer
	//--------------------------------------------------------------------------
	
	[Bindable("layerChanged")]
	/**
	 * The map layer to be swiped with this tool.
	 */
	public function get layer():Layer {
		return _layer;
	}
	/**
	 * @private
	 */
	public function set layer( value:Layer ):void {
		if (value != _layer) {
			var reactivate:Boolean = active;
			deactivate();
			
			_layer = value;
			
			if (reactivate) {
				activate();
			}
			
			dispatchEvent(new Event("layerChanged"));
		}
	}
	
	//--------------------------------------------------------------------------
	//  Property:  radius
	//--------------------------------------------------------------------------
	
	[Bindable]
	[Inspectable(category="Mapping")]
	/**
	 * The radius of the spotlight circle, in pixels.
	 * 
	 * @default 50
	 */
	public function get radius():Number {
		return _radius;
	}
	/**
	 * @private
	 */
	public function set radius( value:Number ):void {
		_radius = value;
	}
	
	//--------------------------------------------------------------------------
	//  Property:  active
	//--------------------------------------------------------------------------
	
	[Bindable("activate")]
	[Bindable("deactivate")]
	/**
	 * Whether this tool is in the active or inactive state.
	 */
	public function get active():Boolean {
		return _active;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Activates the toolbar for spotlighting layers.
	 * Activating the toolbar disables map navigation.
	 */
	public function activate():void {
		if (!map || !layer) {
			return;
		}
		if (_active) {
			return;
		}
		_active = true;
		
		map.addEventListener(ResizeEvent.RESIZE, map_onResize, false, 0, true);
		map.addEventListener(MouseEvent.MOUSE_DOWN, map_onMouseDown, false, 0, true);
		map.addEventListener(MouseEvent.MOUSE_OVER, map_onMouseOver, false, 0, true);
		map.addEventListener(MouseEvent.MOUSE_OUT, map_onMouseOut, false, 0, true);
		
		deactivateMapTools(true, false, false, true);
		
		dispatchEvent(new Event("activate"));
	}
	
	/**
	 * Deactivates the toolbar and reactivates map navigation.
	 */
	public function deactivate():void {
		if (!_active) {
			return;
		}
		_active = false;
		_dragging = false;
		_lastMouseLoc = null;
		
		clearCursor();
		unapplyMask();
		
		if (map) {
			map.removeEventListener(ResizeEvent.RESIZE, map_onResize);
			map.removeEventListener(MouseEvent.MOUSE_DOWN, map_onMouseDown);
			map.removeEventListener(MouseEvent.MOUSE_MOVE, map_onMouseMove);
			map.removeEventListener(MouseEvent.MOUSE_UP, map_onMouseUp);
			map.removeEventListener(MouseEvent.MOUSE_OVER, map_onMouseOver);
			map.removeEventListener(MouseEvent.MOUSE_OUT, map_onMouseOut);
		}
		
		activateMapTools(true, false, false, true);
		
		dispatchEvent(new Event("deactivate"));
	}
	
	private function map_onResize( event:ResizeEvent ):void {
		clearCursor();
		
		if (_mask) {
			unapplyMask();
			if (_lastMouseLoc) {
				applyMask(_lastMouseLoc);
			}
		}
	}
	
	private function map_onMouseOver( event:MouseEvent ):void {
		calcMouseLocation(event);
		if (_dragging) {
			setCursor(_spacerIcon);
		} else {
			setCursor(_spotlightIcon);
		}
	}
	
	private function map_onMouseOut( event:MouseEvent ):void {
		calcMouseLocation(event);
		clearCursor();
	}
	
	private function map_onMouseDown( event:MouseEvent ):void {
		_dragging = true;
		setCursor(_spacerIcon);
		
		var mousePt:Point = calcMouseLocation(event);
		applyMask(mousePt);
		
		map.removeEventListener(MouseEvent.MOUSE_DOWN, map_onMouseDown);
		map.addEventListener(MouseEvent.MOUSE_MOVE, map_onMouseMove, false, 0, true);
		map.addEventListener(MouseEvent.MOUSE_UP, map_onMouseUp, false, 0, true);
	}
	
	private function map_onMouseUp( event:MouseEvent ):void {
		_dragging = false;
		_lastMouseLoc = null;
		unapplyMask();
		setCursor(_spotlightIcon);
		
		map.removeEventListener(MouseEvent.MOUSE_MOVE, map_onMouseMove);
		map.removeEventListener(MouseEvent.MOUSE_UP, map_onMouseUp);
		map.addEventListener(MouseEvent.MOUSE_DOWN, map_onMouseDown, false, 0, true);
	}
	
	private function map_onMouseMove( event:MouseEvent ):void {
		if (_dragging) {
			var mousePt:Point = calcMouseLocation(event);
			updateMask(mousePt);
		}
	}
	
	/**
	 * Returns the mouse pixel location in map local coordinate space.
	 * Updates the cached last mouse position.
	 */
	private function calcMouseLocation( event:MouseEvent ):Point {
		var pt:Point = map.globalToLocal(new Point(event.stageX, event.stageY));
		_lastMouseLoc = pt;
		return pt;
	}
	
	private function applyMask( mousePt:Point ):void {
		if (!_mask) {
			const w:Number = map.width / Math.abs(map.scaleX);
			const h:Number = map.height / Math.abs(map.scaleY);
			const x:Number = mousePt.x;
			const y:Number = mousePt.y;
			const r:Number = radius;
			
			_mask = new Shape();
			
			var g:Graphics = _mask.graphics;
			g.clear();
			g.beginFill(0x000000);
			
			/*
				The following graphics code draws a mask with this shape:
				
				+----------------------------+
				|         |                  |
				|         |                  |
				|       /---\                |
				|       | x |                |
				|       \---/                |
				|                            |
				|                            |
				+----------------------------+
				
				where "x" is the mouse pointer location. The mask shape is a
				rectangle sized to the map width and height, with a circular
				cutout around the mouse location, based on the radius property.
			*/
			
			// Render the mask based on the current mouse position
			g.moveTo(0, 0);
			g.lineTo(x, 0);
			// Take a detour from the map edge into the interior, and draw a circle
			g.lineTo(x, y - r);
			for (var i:int = 0; i <= 360; i++) {
				var dx:Number = x - r * Math.sin(i * Math.PI / 180);
				var dy:Number = y - r * Math.cos(i * Math.PI / 180);
				g.lineTo(dx, dy);
			}
			// Back to the edge
			g.lineTo(x, 0);
			g.lineTo(w, 0);
			g.lineTo(w, h);
			g.lineTo(0, h);
			g.lineTo(0, 0);
			
			g.endFill();
			
			// Add the mask to the display list, using rawChildren since Map extends Container
			map.rawChildren.addChild(_mask);
			
			// Apply the mask to the target layer
			layer.mask = _mask;
		}
	}
	
	private function updateMask( mousePt:Point ):void {
		unapplyMask();
		applyMask( mousePt );
	}
	
	private function unapplyMask():void {
		if (layer) {
			// Unmask the target layer
			layer.mask = null;
		}
		if (_mask) {
			if (map) {
				// Remove the mask from the display list, using rawChildren since Map extends Container
				try {
					map.rawChildren.removeChild(_mask);
				} catch (e:Error) {}
			}
			_mask = null;
		}
	}
	
	//--------------------------------------------------------------------------
	//
	//  Cursor management methods
	//
	//--------------------------------------------------------------------------
	
	private function setCursor( cursor:Class ):void
	{
		if (cursor) {
			if (cursor !== _currentCursor) {
				clearCursor();
				_currentCursor = cursor;
				_cursorID = CursorManager.setCursor(cursor);
			}
		} else {
			clearCursor();
		}
	}
	
	private function clearCursor():void
	{
		if (_currentCursor) {
			CursorManager.removeCursor(_cursorID);
			_cursorID = -1;
			_currentCursor = null;
		}
	}
}

}

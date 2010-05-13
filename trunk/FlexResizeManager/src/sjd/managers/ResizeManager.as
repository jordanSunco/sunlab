package sjd.managers{
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import mx.containers.Panel;
	import mx.core.Application;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.managers.CursorManager;
	import mx.managers.CursorManagerPriority;
	
	/**
	 * @class ResizeManager
	 * @brief Enable any UIComponent to resize
	 * @author Jove
	 * @version 1.1
	 */
	public class ResizeManager{
		
		[Embed(source="/sjd/assets/mouseMove.gif")]
		private static const CURSOR_MOVE:Class;
		[Embed(source="/sjd/assets/verticalSize.gif")]
		private static const VERTICAL_SIZE:Class;
		[Embed(source="/sjd/assets/horizontalSize.gif")]
		private static const HORIZONTAL_SIZE:Class;
		[Embed(source="/sjd/assets/leftObliqueSize.gif")]
		private static const LEFT_OBLIQUE_SIZE:Class;
		[Embed(source="/sjd/assets/rightObliqueSize.gif")]
		private static const RIGHT_OBLIQUE_SIZE:Class;
		
		private static const RESIZE_OLD_POINT:String = "oldPoint";
		private static const RESIZE_OLD_HEIGHT:String = "oldHeight";
		private static const RESIZE_OLD_WIDTH:String = "oldWidth";
		private static const RESIZE_OLD_X:String = "oldX";
		private static const RESIZE_OLD_Y:String = "oldY";
		private static const RESIZE_MIN_SIZE:String = "minSize";
		private static const RESIZE_IS_POPUPE:String = "isPopup";
		
		private static const SIDE_OTHER:Number = 0;
		private static const SIDE_TOP:Number = 1;
		private static const SIDE_BOTTOM:Number = 2;
		private static const SIDE_LEFT:Number = 4;
		private static const SIDE_RIGHT:Number = 8;
		
		private static var resizeObj:UIComponent;
		private static var mouseState:Number = 0;
		
		public static var isResizing:Boolean = false;
		public static var mouseMargin:Number = 4;
		public static var defaultCursor:Class = null;
		public static var defaultCursorOffX:Number = 0;
		public static var defaultCursorOffY:Number = 0;
		
		public static function setDefaultCursor(cursor:Class = null, offX:Number = 0, offY:Number = 0):void{
			defaultCursor = cursor;
			defaultCursorOffX = offX;
			defaultCursorOffY = offY;
		}
		
		/**
		 * Enable the UIComponent to have resize capability.
		 * @param targetObj The UIComponent to be enabled resize capability
		 * @param minSize The min size of the UIComponent when resizing
		 */
		public static function enableResize(targetObj:UIComponent, minSize:Number):void{
			//Application.application.parent:SystemManager
			Application.application.parent.addEventListener(MouseEvent.MOUSE_UP, doMouseUp);
			Application.application.parent.addEventListener(MouseEvent.MOUSE_MOVE, doResize);
			
			initPosition(targetObj);
			
			targetObj.setStyle(RESIZE_OLD_POINT, new Point());
			targetObj.setStyle(RESIZE_MIN_SIZE, minSize);
			targetObj.setStyle(RESIZE_IS_POPUPE, targetObj.isPopUp);
			
			targetObj.addEventListener(MouseEvent.MOUSE_DOWN, doMouseDown);
			//targetObj.addEventListener(MouseEvent.MOUSE_UP, doMouseUp);
			targetObj.addEventListener(MouseEvent.MOUSE_MOVE, doMouseMove);
			targetObj.addEventListener(MouseEvent.MOUSE_OUT, doMouseOut);
		}
		
		/**
		 * Disable the UIComponent to have resize capability.
		 * @param targetObj The UIComponent to be disabled resize capability
		 */
		public static function disableResize(targetObj:UIComponent):void{
			targetObj.removeEventListener(MouseEvent.MOUSE_DOWN, doMouseDown);
			//targetObj.removeEventListener(MouseEvent.MOUSE_UP, doMouseUp);
			targetObj.removeEventListener(MouseEvent.MOUSE_MOVE, doMouseMove);
			targetObj.removeEventListener(MouseEvent.MOUSE_OUT, doMouseOut);
		}
		
				
		private static function initPosition(obj:Object):void{
			obj.setStyle(RESIZE_OLD_HEIGHT, obj.height);
			obj.setStyle(RESIZE_OLD_WIDTH, obj.width);
			obj.setStyle(RESIZE_OLD_X, obj.x);
			obj.setStyle(RESIZE_OLD_Y, obj.y);
		}
		
		/**
		 * Set the first global point that mouse down on the resizeObj.
		 * @param The MouseEvent.MOUSE_DOWN
		 */
		private static function doMouseDown(event:MouseEvent):void{
			
			if(mouseState != SIDE_OTHER){
				
				resizeObj = UIComponent(event.currentTarget);
				
				initPosition(resizeObj);
				
				var point:Point = new Point();
				point.x = resizeObj.mouseX;
				point.y = resizeObj.mouseY;

				point = resizeObj.localToGlobal(point);
				resizeObj.setStyle(RESIZE_OLD_POINT, point);
			}
		}
		
		/**
		 * Clear the resizeObj and also set the latest position.
		 * @param The MouseEvent.MOUSE_UP
		 */
		private static function doMouseUp(event:MouseEvent):void{
			isResizing = false;
			if(resizeObj != null){
				initPosition(resizeObj);
			}
			resizeObj = null;
		}
		
		/**
		 * Show the mouse arrow when not draging.
		 * Call doResize(event) to resize resizeObj when mouse is inside the resizeObj area.
		 * @param The MouseEvent.MOUSE_MOVE
		 */
		private static function doMouseMove(event:MouseEvent):void{
			
			
			var thisObj:UIComponent = UIComponent(event.currentTarget);
			var point:Point = new Point();
				
			point = thisObj.localToGlobal(point);
			
			isResizing = true;
			
			if(resizeObj == null){
				var xPosition:Number = Application.application.parent.mouseX;
				var yPosition:Number = Application.application.parent.mouseY;
				if(xPosition >= (point.x + thisObj.width - mouseMargin) && yPosition >= (point.y + thisObj.height - mouseMargin)){
					changeCursor(LEFT_OBLIQUE_SIZE, -6, -6); 
					mouseState = SIDE_RIGHT | SIDE_BOTTOM;
				}else if(xPosition <= (point.x + mouseMargin) && yPosition <= (point.y + mouseMargin)){
					changeCursor(LEFT_OBLIQUE_SIZE, -6, -6);
					mouseState = SIDE_LEFT | SIDE_TOP;
				}else if(xPosition <= (point.x + mouseMargin) && yPosition >= (point.y + thisObj.height - mouseMargin)){
					changeCursor(RIGHT_OBLIQUE_SIZE, -6, -6);
					mouseState = SIDE_LEFT | SIDE_BOTTOM;
				}else if(xPosition >= (point.x + thisObj.width - mouseMargin) && yPosition <= (point.y + mouseMargin)){
					changeCursor(RIGHT_OBLIQUE_SIZE, -6, -6);
					mouseState = SIDE_RIGHT | SIDE_TOP;
				}else if(xPosition >= (point.x + thisObj.width - mouseMargin)){
					changeCursor(HORIZONTAL_SIZE, -9, -9);
					mouseState = SIDE_RIGHT;
				}else if(xPosition <= (point.x + mouseMargin)){
					changeCursor(HORIZONTAL_SIZE, -9, -9);
					mouseState = SIDE_LEFT;
				}else if(yPosition >= (point.y + thisObj.height - mouseMargin)){
					changeCursor(VERTICAL_SIZE, -9, -9);
					mouseState = SIDE_BOTTOM;
				}else if(yPosition <= (point.y + mouseMargin)){
					changeCursor(VERTICAL_SIZE, -9, -9);
					mouseState = SIDE_TOP;
				}else{
					changeCursor(defaultCursor, defaultCursorOffX, defaultCursorOffY);
					mouseState = SIDE_OTHER;
					isResizing = false;
				}
				
				if(thisObj.getStyle(RESIZE_IS_POPUPE)){
					//When cursor is move arrow, disable popup
					if(mouseState != SIDE_OTHER){
						thisObj.isPopUp = false;
					}else{
						thisObj.isPopUp = true;
					}
				}
			}
			
			//Use SystemManager to listen the mouse reize event, so we needn't handle the event at the current object.
			//doResize(event);
		}
		
		/**
		 * Hide the arrow when not draging and moving out the resizeObj.
		 * @param The MouseEvent.MOUSE_MOVE
		 */
		private static function doMouseOut(event:MouseEvent):void{
			if(resizeObj == null){
				changeCursor(defaultCursor, defaultCursorOffX, defaultCursorOffY);
				mouseState = SIDE_OTHER;
			}
		}
		
		/**
		 * Resize when the draging resizeObj, resizeObj is not null.
		 * @param The MouseEvent.MOUSE_MOVE
		 */
		private static function doResize(event:MouseEvent):void{
			
			if(resizeObj != null){
				
				var point:Point = Point(resizeObj.getStyle(RESIZE_OLD_POINT));
				
				var xPlus:Number = Application.application.parent.mouseX - point.x;
				var yPlus:Number = Application.application.parent.mouseY - point.y;
				
				var windowMinSize:Number = Number(resizeObj.getStyle(RESIZE_MIN_SIZE));
				
				var ow:Number = Number(resizeObj.getStyle(RESIZE_OLD_WIDTH));
				var oh:Number = Number(resizeObj.getStyle(RESIZE_OLD_HEIGHT));
				var oX:Number = Number(resizeObj.getStyle(RESIZE_OLD_X));
				var oY:Number = Number(resizeObj.getStyle(RESIZE_OLD_Y))
				
			    switch(mouseState){
			    	case SIDE_RIGHT | SIDE_BOTTOM:
			    		resizeObj.width = ow + xPlus > windowMinSize ? ow + xPlus : windowMinSize;
		    			resizeObj.height = oh + yPlus > windowMinSize ? oh + yPlus : windowMinSize;
			    		break;
			    	case SIDE_LEFT | SIDE_TOP:
			    		resizeObj.width = ow - xPlus > windowMinSize ? ow - xPlus : windowMinSize;
		    			resizeObj.height = oh - yPlus > windowMinSize ? oh - yPlus : windowMinSize;
		    			resizeObj.x = xPlus < ow - windowMinSize ? oX + xPlus: resizeObj.x;
		    			resizeObj.y = yPlus < oh - windowMinSize ? oY + yPlus : resizeObj.y;
			    		break;
			    	case SIDE_LEFT | SIDE_BOTTOM:
			    		resizeObj.width = ow - xPlus > windowMinSize ? ow - xPlus : windowMinSize;
		    			resizeObj.height = oh + yPlus > windowMinSize ? oh + yPlus : windowMinSize;
			    		resizeObj.x = xPlus < ow - windowMinSize ? oX + xPlus: resizeObj.x;
			    		break;
			    	case SIDE_RIGHT | SIDE_TOP:
			    		resizeObj.width = ow + xPlus > windowMinSize ? ow + xPlus : windowMinSize;
		    			resizeObj.height = oh - yPlus > windowMinSize ? oh - yPlus : windowMinSize;
			    		resizeObj.y = yPlus < oh - windowMinSize ? oY + yPlus : resizeObj.y;
			    		break;
			    	case SIDE_RIGHT:
			    		resizeObj.width = ow + xPlus > windowMinSize ? ow + xPlus : windowMinSize;
			    		break;
			    	case SIDE_LEFT:
			    		resizeObj.width = ow - xPlus > windowMinSize ? ow - xPlus : windowMinSize;
			    		resizeObj.x = xPlus < ow - windowMinSize ? oX + xPlus: resizeObj.x;
			    		break;
			    	case SIDE_BOTTOM:
			    		resizeObj.height = oh + yPlus > windowMinSize ? oh + yPlus : windowMinSize;
			    		break;
			    	case SIDE_TOP:
			    		resizeObj.height = oh - yPlus > windowMinSize ? oh - yPlus : windowMinSize;
			    		resizeObj.y = yPlus < oh - windowMinSize ? oY + yPlus : resizeObj.y;
			    		break;
			    }
			    
			}
			
		}
		
		
		
		private static var currentType:Class = null;
				
		/**
		 * Remove the current cursor and set an image.
		 * @param type The image class
		 * @param xOffset The xOffset of the cursorimage
		 * @param yOffset The yOffset of the cursor image
		 */
		private static function changeCursor(type:Class, xOffset:Number = 0, yOffset:Number = 0):void{
			if(currentType != type){
				currentType = type;
				CursorManager.removeCursor(CursorManager.currentCursorID);
				if(type != null){
					CursorManager.setCursor(type, CursorManagerPriority.MEDIUM, xOffset, yOffset);
				}
			}
		}
		
	}
	
}
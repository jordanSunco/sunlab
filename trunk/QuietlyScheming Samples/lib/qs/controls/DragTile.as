package qs.controls
{
	import mx.core.UIComponent;
	import mx.core.IUIComponent;
	import mx.core.IFactory;
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.events.Event;
	import mx.core.ClassFactory;
	import mx.core.IDataRenderer;
	import mx.managers.DragManager;
	import mx.core.DragSource;
	import mx.core.BitmapAsset;
	import flash.display.PixelSnapping;
	import mx.events.DragEvent;
	import mx.states.RemoveChild;
	import mx.containers.Tile;
	import mx.core.Container;
	import mx.core.ScrollPolicy;

	/** the amount of space, in pixels, between invidual items */
	[Style(name="spacing", type="Number", inherit="no")]
	[Style(name="padding", type="Number", inherit="no")]
		
	[Event("change")]

	public class DragTile extends Container
	{
		private var _items:Array = [];
		private var _pendingItems:Array;
		protected var itemsChanged:Boolean = false;
		/** true if the renderers need to be regenerated */
		protected var renderersDirty:Boolean = true;
		/** the renderers representing the data items, one for each item */
		protected var renderers:Array = [];		
		/** the factory that generates item renderers
		 */
		private var _itemRendererFactory:IFactory;
		/** 
		 * the object that manages animating the children layout
		 */
		private var _rowLength:int = 16;
		private var _colLength:int;
		private var _tileWidth:int;
		private var _tileHeight:int;
		private var _dragTargetIdx:Number;
		private var _dragMouseStart:Point;
		private var _dragMousePos:Point;
		private var _dragPosStart:Point;
				
		private var animator:LayoutAnimator;
		
		
		public function DragTile()
		{
			super();
			_itemRendererFactory= new ClassFactory(CachedLabel);
			animator = new LayoutAnimator();
			animator.autoPrioritize = false;
			animator.animationSpeed = .2;
			animator.layoutFunction = generateLayout;
			animator.updateFunction = layoutUpdated;
			
			horizontalScrollPolicy = ScrollPolicy.OFF;
			clipContent = true;
			
			addEventListener(MouseEvent.MOUSE_DOWN,startReorder);
			addEventListener(DragEvent.DRAG_ENTER,dragEnter);
			addEventListener(DragEvent.DRAG_OVER,dragOver);
			addEventListener(DragEvent.DRAG_EXIT,dragOut);
			addEventListener(DragEvent.DRAG_DROP,dragDrop);
			addEventListener(DragEvent.DRAG_COMPLETE,dragComplete);
						
		}
		//-----------------------------------------------------------------
		
		/** the data source
		 */
		public function set dataProvider(value:Array):void
		{
			_pendingItems= value;

			renderersDirty = true;
			itemsChanged = true;
			invalidateProperties();			
		}
		public function get dataProvider():Array
		{
			return _items;

		}
		//-----------------------------------------------------------------

		/**
		 * by making the itemRenderer be of type IFactory, 
		 * developers can define it inline using the <Component> tag
		 */
		public function get itemRenderer():IFactory
		{
			return _itemRendererFactory;
		}
		public function set itemRenderer(value:IFactory):void
		{
			_itemRendererFactory = value;
			renderersDirty = true;
			invalidateProperties();						
		}
		//-----------------------------------------------------------------

		
		override protected function commitProperties():void
		{
			// its now safe to switch over new dataProviders.
			if(_pendingItems != null)
			{
				_items = _pendingItems;
				_pendingItems = null;
			}
			
			itemsChanged = false;
			
			if(renderersDirty)
			{
				// something has forced us to reallocate our renderers. start by throwing out the old ones.
				renderersDirty = false;
				for(var i:int=numChildren-1;i>= 0;i--)
					removeChildAt(i);
				
				renderers = [];

				// allocate new renderers, assign the data.
				for(var i:int = 0;i<_items.length;i++)
				{
					var renderer:IUIComponent = _itemRendererFactory.newInstance();
					IDataRenderer(renderer).data = _items[i];
					renderers[i] = renderer;
					addChild(DisplayObject(renderer));
				}
				animator.items = renderers;

			}
			invalidateSize();
		}
		
		private function get spacingWidthDefault():Number
		{
			var result:Number = getStyle("spacing");
			if(isNaN(result))
				result = 20;
			return result;
		}
		private function get paddingWidthDefault():Number
		{
			var result:Number = getStyle("padding");
			if(isNaN(result))
				result = 40;
			return result;
		}
		
		override protected function measure():void
		{
			_tileWidth = 0;
			_tileHeight = 0;
			
			// first, calculate the largest width/height of all the items, since we'll have to make all of the items
			// that size

			for(var i:int=0;i<renderers.length;i++)
			{
				var itemRenderer:IUIComponent = renderers[i];
				_tileWidth = Math.max(_tileWidth,itemRenderer.getExplicitOrMeasuredWidth());
				_tileHeight = Math.max(_tileHeight,itemRenderer.getExplicitOrMeasuredHeight());
			}
			// square them off
			_tileWidth = Math.max(_tileWidth,_tileHeight);
			//_tileHeight = _tileWidth;
						
			var itemsInRow:Number = Math.min(renderers.length,_rowLength);
			
			var spacing:Number = spacingWidthDefault;
			measuredWidth = itemsInRow * _tileWidth + (itemsInRow - 1) * spacing;
			var defaultColumnCount:Number = Math.ceil(renderers.length / _rowLength);
			measuredHeight = defaultColumnCount*_tileHeight + (defaultColumnCount-1)*spacing;
	
			animator.invalidateLayout();		
							
		}
		
		private function findItemAt(px:Number,py:Number,seamAligned:Boolean):Number
		{
			var gPt:Point = localToGlobal(new Point(px,py));
						
			px += horizontalScrollPosition;
			py += verticalScrollPosition;
			
			var spacing:Number = spacingWidthDefault;
			var padding:Number = paddingWidthDefault;
			
			var targetWidth:Number = unscaledWidth -2*padding + spacing;
			var rowLength:Number = Math.min(renderers.length,Math.floor(targetWidth/(_tileWidth+spacing)) );
			var colLength:Number = (rowLength == 0)? 0:(Math.ceil(renderers.length / rowLength));
			var leftSide:Number = (unscaledWidth - (rowLength * _tileWidth + (rowLength-1) * spacing + 2*padding))/2;
			
									
			var rowPos:Number = (px-padding - leftSide) / (_tileWidth + spacing);
			var colPos:Number = (py-spacing/2) / (_tileHeight + spacing);
			rowPos = (seamAligned)? Math.round(rowPos):Math.floor(rowPos);
			colPos = Math.floor(colPos);
						
			if(seamAligned)
			{
				rowPos = Math.max(0,Math.min(rowPos,rowLength));
				colPos = Math.max(0,Math.min(colPos,colLength));
				var result:Number = colPos * rowLength + rowPos;						
				return Math.min(_items.length,result);
								
			}
			else
			{
				if(rowPos >= rowLength || rowPos < 0)
					return NaN;
				if(colPos >= colLength || colPos < 0)
					return NaN;
				var result:Number = colPos * rowLength + rowPos;																	
				if(result > _items.length)
					return NaN;
				var r:DisplayObject = renderers[result];
				if(r.hitTestPoint(gPt.x,gPt.y,true) == false)
					return NaN;					
				return result;
			}
		}
				
						
		private function startReorder(e:MouseEvent):void
		{
			var dragIdx:Number = findItemAt(mouseX,mouseY,false);
			if(isNaN(dragIdx))
				return;

			var dragItem:IUIComponent = renderers[dragIdx];
			
			var dragImage:UIBitmap = new UIBitmap(dragItem,PixelSnapping.NEVER);			

			var dragSrc:DragSource = new DragSource();
			dragSrc.addData([dataProvider[dragIdx]],"items");
			dragSrc.addData(dragIdx,"index");
			
			var pt:Point = DisplayObject(dragItem).localToGlobal(new Point(0,0));
			pt = globalToLocal(pt);
			DragManager.doDrag(this,dragSrc,e,dragImage,-pt.x - 4 ,-pt.y - 4,.6);
		}
		private function dragEnter(e:DragEvent):void
		{
			if(e.dragInitiator == this)
			{
		    	DragManager.acceptDragDrop(this);
				e.action = DragManager.MOVE;
				DragManager.showFeedback(DragManager.MOVE);
			}
			else
			{
		    	DragManager.acceptDragDrop(this);								
				if(e.shiftKey)
					DragManager.showFeedback(DragManager.COPY);
				else
					DragManager.showFeedback(DragManager.MOVE);				
			}
			animator.animationSpeed = .1;
		}
		private function dragOver(e:DragEvent):void
		{
			if(e.shiftKey)
				DragManager.showFeedback(DragManager.COPY);
			else
				DragManager.showFeedback(DragManager.MOVE);				
			_dragTargetIdx = findItemAt(mouseX,mouseY,true);
			_dragMousePos = new Point(mouseX,mouseY);
			animator.invalidateLayout(true);						
		}
		private function dragDrop(e:DragEvent):void
		{
			_dragTargetIdx = findItemAt(mouseX,mouseY,true);
			if(e.dragInitiator == this && e.action == DragManager.MOVE)
			{
				DragManager.showFeedback(DragManager.LINK);
				var dragFromIndex:Number = Number(e.dragSource.dataForFormat("index"));
				if(_dragTargetIdx > dragFromIndex)
				{
					_items.splice(_dragTargetIdx,0,_items[dragFromIndex]);
					_items.splice(dragFromIndex,1);
					setChildIndex(renderers[dragFromIndex],numChildren-1);
					renderers.splice(_dragTargetIdx,0,renderers[dragFromIndex]);
					renderers.splice(dragFromIndex,1);
				
				}
				else
				{
					var tmp:* = _items[dragFromIndex];
					_items.splice(dragFromIndex,1);
					_items.splice(_dragTargetIdx,0,tmp);
					tmp = renderers[dragFromIndex];
					setChildIndex(tmp,numChildren-1);
					renderers.splice(dragFromIndex,1);
					renderers.splice(_dragTargetIdx,0,tmp);												
				}
				dispatchEvent(new Event("change"));
			}
			else
			{
				var newItems:Array = (e.dragSource.dataForFormat("items") as Array).concat();
				var newRenderers:Array = [];
				for(var i:int =0;i<newItems.length;i++)
				{
					var r:IUIComponent = newRenderers[i] = _itemRendererFactory.newInstance();
					IDataRenderer(r).data = newItems[i];
					addChild(DisplayObject(r));
					_items.splice(_dragTargetIdx,0,newItems[i]);
					renderers.splice(_dragTargetIdx+i,0,r);
																				
				}
			}
			_dragTargetIdx = NaN;
			animator.animationSpeed = .2;
			animator.invalidateLayout(true);
		}
		private function dragComplete(e:DragEvent):void
		{
			if(e.action == DragManager.MOVE)
			{
				var dragFromIndex:Number = Number(e.dragSource.dataForFormat("index"));
				_items.splice(dragFromIndex,1);
				var r:IUIComponent = renderers.splice(dragFromIndex,1)[0];
				removeChild(DisplayObject(r));
				animator.invalidateLayout();
			}
		}
		private function dragOut(e:DragEvent):void
		{
			_dragTargetIdx = NaN;
			animator.animationSpeed = .2;						
			animator.invalidateLayout(true);
		}
		
		
		private function layoutUpdated():void
		{
			validateDisplayList();
		}
		private function generateLayout():void
		{
			var spacing:Number = spacingWidthDefault;
			var padding:Number = paddingWidthDefault;
			var targetWidth:Number = unscaledWidth - 2*padding + spacing;
			var rowLength:Number = Math.min(renderers.length,Math.floor(targetWidth/(spacing + _tileWidth)) );
			var colLength:Number = Math.ceil(renderers.length / rowLength);
			
			var leftSide:Number = (unscaledWidth - (rowLength * _tileWidth + (rowLength-1) * spacing + 2*padding))/2;
			
			var positionFunc:Function = function(r:int,c:int,offset:Number):void
			{			
				var idx:int = c*rowLength + r;
				if(idx >= renderers.length)
					return;								
				var renderer:IUIComponent = renderers[idx];
				var target:LayoutTarget = animator.targetFor(renderer);//targets[idx];
				target.scaleX = target.scaleY = 1;
				target.item = renderer;
				target.unscaledWidth = renderer.getExplicitOrMeasuredWidth();
				target.unscaledHeight = renderer.getExplicitOrMeasuredHeight();
				target.x = offset + r * (_tileWidth + spacing) + _tileWidth/2 - target.unscaledWidth/2;
				target.y = spacing + c * (_tileHeight + spacing)+ _tileHeight/2 - target.unscaledHeight/2;
				target.animate = true;					
			}

			var insertRowPos:Number = _dragTargetIdx % rowLength;
			var insertColPos:Number = Math.floor(_dragTargetIdx / rowLength);
			
			for(var c:int = 0;c<colLength;c++)			
			{
				if(c == insertColPos)
				{
					for(var r:int = 0;r<insertRowPos;r++)
					{
						positionFunc(r,c,leftSide);
					}
					for(var r:int = insertRowPos;r<rowLength;r++)
					{
						positionFunc(r,c,leftSide + 2*padding);
					}
				}
				else
				{
					for(var r:int = 0;r<rowLength;r++)
					{
						positionFunc(r,c,leftSide + padding);
					}
				}
			}
		}

		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			graphics.clear();
			graphics.moveTo(0,0);
			graphics.beginFill(0,0);
			graphics.drawRect(0,0,unscaledWidth,unscaledHeight);
			
			
			animator.invalidateLayout();			
			
			super.updateDisplayList(unscaledWidth,unscaledHeight);
		}
		override public function styleChanged(styleProp:String):void
		{
			invalidateSize();
			invalidateDisplayList();
			animator.invalidateLayout();
		}

	}
}
/*
 * MouseSelectableTileList
 * Ticore Shih
 * http://ticore.blogspot.com/
 */

package com.ticore.uicomponents {
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    
    import mx.controls.TileList;
    import mx.controls.listClasses.TileBaseDirection;
    import mx.core.UIComponent;
    import mx.events.FlexEvent;
    import mx.events.ScrollEvent;   
    
    [Style(name="nVerticalGap", type="String", inherit="no")]
    [Style(name="nHorizontalGap", type="String", inherit="no")]
    
    public class MouseSelectableTileList extends TileList
    {
        /**
         * 垂直間距
         */     
        private var _verticalGap:Number = 0;
        /**
         * 水平間距
         */     
        private var _horizontalGap:Number = 0;
        /**
         * 底部背景
         */     
        private var bg:UIComponent;
        /**
         * 選圖ui
         */     
        private var selectBox:UIComponent;
        /**
         * 開始畫圖的落點
         */     
        private var startPoint:Point;
        /**
         * 起點index坐標
         */     
        private var startIndexPoint:Point;
        /**
         * 終點index坐標
         */     
        private var endIndexPoint:Point;
        /**
         * 框選時鼠標離開邊框的x軸距離
         */     
        private var offsetX:Number = 0;
        /**
         * 框選時鼠標離開邊框的y軸距離
         */
        private var offsetY:Number = 0;
        /**
         * 原始水平scrollbar位置
         */     
        private var oHScrollPosition:Number = 0;
        /**
         * 原始垂直scrollbar位置
         */     
        private var oVScrollPosition:Number = 0;
        
        public function MouseSelectableTileList()
        {
            addEventListener(FlexEvent.CREATION_COMPLETE, initBgHandler);
            addEventListener(Event.ENTER_FRAME, autoScrollHandler);
        }
        
        /**
         * 初始化
         * @param evt
         * 
         */     
        private function initBgHandler(evt:FlexEvent):void
        {
            initStyle();
            bg = new UIComponent();
            with(bg.graphics){
                beginFill(0x00ff00, 0);
                drawRect(0, 0, width, height);
                endFill();
            }
            listContent.addChildAt(bg, 0);
            bg.addEventListener(MouseEvent.MOUSE_DOWN, selectingHandler);
        }
        
        /**
         * 初始化子項邊距
         * 
         */     
        private function initStyle():void
        {
            _verticalGap = Number(getStyle("nVerticalGap"));
            if(isNaN(_verticalGap))_verticalGap = 0;
            _horizontalGap = Number(getStyle("nHorizontalGap"));
            if(isNaN(_horizontalGap))_horizontalGap = 0;
        }
        
        /**
         * 開始選圖
         * @param evt
         * 
         */     
        private function selectingHandler(evt:MouseEvent):void
        {
            selectedIndices = [];
            addEventListener(ScrollEvent.SCROLL, scrollingHandler);
            stage.addEventListener(MouseEvent.MOUSE_UP, selectedHandler);
            stage.addEventListener(MouseEvent.MOUSE_MOVE, changeSelectRectHandler);
            selectBox = new UIComponent();
            listContent.addChild(selectBox);
            startPoint = new Point(mouseX, mouseY);
            startIndexPoint = endIndexPoint = pointToIndex(startPoint);
            oHScrollPosition = horizontalScrollPosition;
            oVScrollPosition = verticalScrollPosition;
        }
        
        /**
         * 滾動條事件
         * @param evt
         * 
         */     
        private function scrollingHandler(evt:ScrollEvent):void
        {
            changeSelectRectHandler();
        }
        
        /**
         * scrollbar自動滾動
         * @param evt
         * 
         */     
        private function autoScrollHandler(evt:Event):void
        {
            if(selectBox){
                //計算x軸偏移量
                if(mouseX > width)
                    offsetX = mouseX - width;
                else if(mouseX < 0)
                    offsetX = mouseX;
                else
                    offsetX = 0;
                //計算y軸偏移量
                if(mouseY > height)
                    offsetY = mouseY - height;
                else if(mouseY < 0)
                    offsetY = mouseY;
                else
                    offsetY = 0;
                if(offsetX || offsetY)
                    changeSelectRectHandler();
            }else{
                offsetX = 0;
                offsetY = 0;
            }
        }
        
        /**
         * 畫選擇框
         * @param evt
         * 
         */     
        private function changeSelectRectHandler(evt:MouseEvent = null):void
        {
            if(!selectBox)return;
            setScrollPosition();
            drawSelectRect();
            setSelectedItem();
        }
        
        /**
         * 畫選擇框
         * 
         */     
        private function drawSelectRect():void
        {
            //設定x軸界限
            var _x:Number = mouseX;
            if(_x > width)
                _x = width;
            if(_x < 0)_x = 0;
            //設定y軸界限
            var _y:Number = mouseY;
            if(_y > height)
                _y = height;
            if(_y < 0)_y = 0;
            //畫圖
            with(selectBox.graphics){
                clear();
                lineStyle(1, 0xff0000);
                beginFill(0xff0000, 0.5);
                drawRect(startPoint.x, startPoint.y, 
                        _x - startPoint.x - selectBox.x, 
                        _y - startPoint.y - selectBox.y);
                endFill();
            }
        }
        
        /**
         * 設定滾動條位置
         * 
         */     
        private function setScrollPosition():void
        {
            //設置水平滾動條位置
            var horPos:Number = horizontalScrollPosition + offsetX;
            if(horPos > 0){
                if(horPos < maxHorizontalScrollPosition)
                    horizontalScrollPosition = horPos;
                else
                    horizontalScrollPosition = maxHorizontalScrollPosition;
            }else
                horizontalScrollPosition = 0;
            if(horizontalScrollBar)
                selectBox.x = (oHScrollPosition - horizontalScrollPosition)*
                    horizontalScrollBar.lineScrollSize*columnWidth;
            //設置垂直滾動條位置
            var verPos:Number = verticalScrollPosition + offsetY;
            if(verPos > 0){
                if(verPos < maxVerticalScrollPosition)
                    verticalScrollPosition = verPos;
                else
                    verticalScrollPosition = maxVerticalScrollPosition;             
            }else
                verticalScrollPosition = 0;
            if(verticalScrollBar)
                selectBox.y = (oVScrollPosition - verticalScrollPosition)*
                    verticalScrollBar.lineScrollSize*rowHeight;
//          trace(horizontalScrollBar, verticalScrollPosition);
        }
        
        /**
         * 設定選中項
         * 
         */     
        private function setSelectedItem():void
        {
            endIndexPoint = pointToIndex(new Point(mouseX, mouseY));
            var i:Number, ix:Number, iy:Number;
            var xFlag:Boolean = false;
            var yFlag:Boolean = false;
            var newSelectedIndices:Array = [];
            if(direction == TileBaseDirection.HORIZONTAL){
                for (i = 0 ; i < dataProvider.length ; ++i) {
                    
                    ix = i % columnCount;
                    iy = Math.floor(i / columnCount);
                    
                    xFlag = false;
                    if (startIndexPoint.x <= endIndexPoint.x)
                        xFlag = ix >= startIndexPoint.x && ix <= endIndexPoint.x;
                    else
                        xFlag = ix <= startIndexPoint.x && ix >= endIndexPoint.x;
                    
                    yFlag = false;
                    if (startIndexPoint.y <= endIndexPoint.y)
                        yFlag = iy >= startIndexPoint.y && iy <= endIndexPoint.y;
                    else
                        yFlag = iy <= startIndexPoint.y && iy >= endIndexPoint.y;
                    
                    if (xFlag && yFlag)
                        newSelectedIndices.push(i);
                }
            }else{
                for (i = 0 ; i < dataProvider.length ; ++i) {
                    
                    ix = Math.floor(i / rowCount);
                    iy = i % rowCount;
                    
                    xFlag = false;
                    if (startIndexPoint.x <= endIndexPoint.x)
                        xFlag = ix >= startIndexPoint.x && ix <= endIndexPoint.x;
                    else
                        xFlag = ix <= startIndexPoint.x && ix >= endIndexPoint.x;
                    
                    yFlag = false;
                    if (startIndexPoint.y <= endIndexPoint.y)
                        yFlag = iy >= startIndexPoint.y && iy <= endIndexPoint.y;
                    else
                        yFlag = iy <= startIndexPoint.y && iy >= endIndexPoint.y;
                    
                    if (xFlag && yFlag)
                        newSelectedIndices.push(i);
                }
            }
            //測試是否在選中的範圍
            selectedIndices = newSelectedIndices;
        }
        
        /**
         * 將點的位置轉成x, y的index
         * @param p
         * @return 
         * 
         */     
        private function pointToIndex(p:Point):Point
        {
            var indexPoint:Point = new Point();
            indexPoint.x = Math.floor(p.x/columnWidth) + horizontalScrollPosition - 0.5;
            indexPoint.y = Math.floor(p.y/rowHeight) + verticalScrollPosition - 0.5;
            //*/
            indexPoint.x += (p.x%columnWidth) > _horizontalGap ? 0.5 : 0;
            indexPoint.y += (p.y%rowHeight) > _verticalGap ? 0.5 : 0;
            
            indexPoint.x += (p.x%columnWidth) > (columnWidth - _horizontalGap) ? 0.5 : 0;
            indexPoint.y += (p.y%rowHeight) > (rowHeight - _verticalGap) ? 0.5 : 0;
            //*/
            return indexPoint;
        }
        
        /**
         * 選圖完成時移除事件
         * @param evt
         * 
         */     
        private function selectedHandler(evt:MouseEvent):void
        {
            removeEventListener(ScrollEvent.SCROLL, scrollingHandler);
            stage.removeEventListener(MouseEvent.MOUSE_UP, selectedHandler);
            stage.removeEventListener(MouseEvent.MOUSE_MOVE, changeSelectRectHandler);
            startPoint = null;
            offsetX = 0;
            offsetY = 0;
            oHScrollPosition = 0;
            oVScrollPosition = 0;
            if(selectBox){
                listContent.removeChild(selectBox);
                selectBox = null;
            }
        }
    }
}

package com.monkey.common.components {
    import flash.display.Sprite;
    
    import mx.controls.TileList;
    import mx.controls.listClasses.IListItemRenderer;
    import mx.core.UIComponent;

    /**
     * 实现没有高亮, (鼠标/键盘)选中标识的TileList.
     * 因此当itemRenderer是由其他组件渲染时(例如Button), 不会影响其选中/未选中的状态标识,
     * 否则会有一个默认的背景色标识item的选中/未选中状态.
     * 
     * @author Sun
     * @see com.adobe.aharui.CheckBoxDataGrid
     */
    public class NoIndicatorTileList extends TileList {
        /**
         * 关闭TileList上item默认的高亮提示, 否则当mouseOver时会有高亮提示.
         * 如果item设置了enabled=false, 那么这个高亮提示会误导用户这个item还是可以点击的.
         */
        override protected function drawHighlightIndicator(indicator:Sprite,
                x:Number, y:Number,width:Number, height:Number, color:uint,
                itemRenderer:IListItemRenderer):void {
        }

        /**
         * 关闭TileList上item默认的选中提示.
         * 如果item是通过button来渲染的, 那么这个选中提示会导致button周围会有选中提示的背景.
         */
        override protected function drawSelectionIndicator(indicator:Sprite,
                x:Number, y:Number, width:Number, height:Number, color:uint,
                itemRenderer:IListItemRenderer):void {
        }

        /**
         * 关闭TileList上item默认通过键盘进行选择时(左右移动)的选中提示.
         * 如果item是通过button来渲染的, 那么这个选中提示会导致button周围会有选中提示的背景.
         */
        override protected function drawCaretIndicator(indicator:Sprite,
                x:Number, y:Number, width:Number, height:Number, color:uint,
                itemRenderer:IListItemRenderer):void {
        }

        /**
         * 只有当item.enabled=true时才进行选中操作
         */
        override protected function selectItem(item:IListItemRenderer,
                shiftKey:Boolean, ctrlKey:Boolean,
                transition:Boolean = true):Boolean {
            if (item.enabled) {
                // pretend we're using ctrl selection
                return super.selectItem(item, false, true, transition);
            }
            return false;
        }

        /**
         * whenever we draw the renderer, make sure we re-eval the selected state
         */
        override protected function drawItem(item:IListItemRenderer,
                selected:Boolean = false, highlighted:Boolean = false,
                caret:Boolean = false, transition:Boolean = false):void {
            if (item is UIComponent) {
                UIComponent(item).invalidateProperties();
            }
            super.drawItem(item, selected, highlighted, caret, transition);
        }
    }
}

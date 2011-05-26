package com.monkey.common.components.renderers {
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    
    import mx.controls.Button;
    import mx.controls.listClasses.ListBase;
    
    /**
     * 配合NoIndicatorTileList来使用的Button渲染器, 可以在List中单选/多选Button.
     * 支持默认启用/禁用Button, 只需data中包含enabled属性即可, 默认为启用.
     * 
     * @author Sun
     * @see com.adobe.aharui.renderers.CheckBoxRenderer
     */
    public class ListButtonRenderer extends Button {
        public function ListButtonRenderer() {
            super();
            this.focusEnabled = false;
            this.toggle = true;
        }

        override public function set data(value:Object):void {
            super.data = value;

            if (value.hasOwnProperty("enabled")) {
                this.enabled = value["enabled"];
            }

            invalidateProperties();
        }

        override protected function commitProperties():void {
            super.commitProperties();
            if (owner is ListBase) {
                selected = ListBase(owner).isItemSelected(data);
            }
        }

        /**
         * eat keyboard events, the underlying list will handle them
         */
        override protected function keyDownHandler(event:KeyboardEvent):void {
        }

        /**
         * eat keyboard events, the underlying list will handle them 
         */
        override protected function keyUpHandler(event:KeyboardEvent):void {
        }

        /**
         * eat mouse events, the underlying list will handle them
         */
        override protected function clickHandler(event:MouseEvent):void {
        }
    }
}

package com.adobe.aharui {
    import flash.display.DisplayObject;
    import mx.controls.DataGrid;
    import mx.core.IUIComponent;
    import mx.core.EdgeMetrics;
    import mx.styles.ISimpleStyleClient;

    public class FooterDataGrid extends DataGrid {
        protected var footer:DataGridFooter;
        protected var footerHeight:int = 22;

        public function FooterDataGrid() {
            super();
        }
    
        override protected function createChildren():void {
            super.createChildren();

            if (!footer) {
                footer = new DataGridFooter();
                footer.styleName = this;
                addChild(footer);
            }
        }

        override protected function adjustListContent(unscaledWidth:Number = -1,
                unscaledHeight:Number = -1):void {
            super.adjustListContent(unscaledWidth, unscaledHeight);

            listContent.setActualSize(listContent.width, listContent.height - footerHeight);
            footer.setActualSize(listContent.width, footerHeight);
            footer.move(listContent.x, listContent.y + listContent.height + 1);
        }

        override public function invalidateDisplayList():void {
            super.invalidateDisplayList();
            if (footer)
                footer.invalidateDisplayList();
        }
    }
}

package maps {
    import com.esri.ags.Graphic;

    /**
     * 根据一组能与Graphic对应上的值对象来决定Graphic的样式.
     * 以策略模式实现, 面向接口编程, 与实现相分离, 达到灵活变更实现的目的.
     * 
     * @author Sun
     */
    public interface GraphicStyleStrategy {
        /**
         * 根据值对象初始化Graphic的样式
         * 
         * @param level 从层级概念中推算出传入的Graphic是什么类型的区域, 例如第2层为县区域
         * @param graphic
         * @param vos
         */
        function initGraphicStyle(level:uint, graphic:Graphic, vos:Array):void;

        /**
         * 从一组值对象中根据关联关系找出能匹配上的值对象.
         * 例如Graphic.attributes某属性值与对象的某属性值有关联关系.
         * 
         * @param level 从层级概念中推算出传入的Graphic是什么类型的区域, 例如第2层为县区域
         * @param graphic
         * @param vos
         * 
         * @return 匹配上的值对象
         */
        function getGraphicVo(level:uint, graphic:Graphic, vos:Array):Object;

        /**
         * 根据Graphic匹配的值对象来决定Graphic的样式.
         * 例如根据值对象中某属性值来决定填充色.
         * 
         * @param graphic
         * @param graphicVo
         */
        function styleIt(graphic:Graphic, graphicVo:Object):void;
    }
}

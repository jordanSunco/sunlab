/*
 * WTFPL
 */

package com.monkey.common.components {
    import flash.display.DisplayObject;
    import flash.events.Event;
    import flash.events.TimerEvent;
    import flash.utils.Timer;
    
    import mx.controls.ProgressBar;
    import mx.controls.ProgressBarLabelPlacement;
    import mx.controls.ProgressBarMode;
    import mx.controls.SWFLoader;
    import mx.core.FlexGlobals;
    import mx.managers.PopUpManager;
    
    /**
     * 弹出式进度条, 用于显示模态/非模态进度蒙板
     * 
     * @author Sun
     */
    public class ProgressMask extends ProgressBar {
        /**
         * 默认以顶层应用程序居中
         */
        private var _popUpParent:DisplayObject = FlexGlobals.topLevelApplication.parent;

        /**
         * 弹出模态/非模态窗口
         */
        public var modal:Boolean = true;

        private var _timeout:Number;
        private var timer:Timer = new Timer(0, 1);

        public function ProgressMask() {
            // 不确定进度
            this.indeterminate = true;
            // 1. 手动更新ProgressBar的状态, 否则在PopUpManager模态弹出时, 不会显示进度
            this.mode = ProgressBarMode.MANUAL;

            timer.addEventListener(TimerEvent.TIMER_COMPLETE, function ():void {
                close();
            });
        }

        /**
         * 弹出式进度条的父级显示对象, 弹出时居中在此显示对象之上
         * 
         * @default FlexGlobals.topLevelApplication.parent
         */
        public function set popUpParent(value:DisplayObject):void {
            _popUpParent = value;
        }

        public function open():void {
            popUp();
            closeWhenTimeout();
        }

        private function popUp():void {
            // TODO 改用flex commitProperties机制, 在每次属性更改时重新弹出进度条
            PopUpManager.removePopUp(this);

            PopUpManager.addPopUp(this, _popUpParent, modal);
            PopUpManager.centerPopUp(this);

            // 2. 设置进度, 否则在PopUpManager模态弹出时, 不会显示进度
            setProgress(0, 0);
        }

        public function close():void {
            PopUpManager.removePopUp(this);
            timer.reset();
        }

        /**
         * 进度条超时机制, 自动关闭进度条
         * 
         * @param value 毫秒数
         */
        public function set timeout(value:Number):void {
            _timeout = value;
        }

        private function closeWhenTimeout():void {
            if (_timeout) {
                timer.reset();
                timer.delay = _timeout;
                timer.start();
            }
        }

//        public static function progressLoad(url:String):SWFLoader {
//            var loader:SWFLoader = new SWFLoader();
//            loader.addEventListener(Event.COMPLETE, function ():void {
////                sourceContainer.source = loader.content;
//                progressMask.close();
//            });
//
//            var progressMask:ProgressMask = new ProgressMask();
//            if (loader.width) {
//                progressMask.width = loader.width;
//            }
//            progressMask.labelPlacement = ProgressBarLabelPlacement.CENTER;
//
//            // 根据loader派发的progress和complete事件来显示进度
//            progressMask.indeterminate = false;
//            progressMask.mode = ProgressBarMode.EVENT;
//            progressMask.source = loader;
//
//            progressMask.modal = false;
//            progressMask.popUpParent = sourceContainer;
//            progressMask.open();
//
//            // 通过MXML来实例化SWFLoader, 直接指定source属性即可加载内容
//            // <mx:SWFLoader source="url" progress="progressHandler(event)" />
//            // 通过代码方式来实例化SWFLoader, 需要指定source属性后调用load();
//            // 为了演示每次加载的进度效果, 通过URL追加随机数来禁用缓存
//            loader.source = url + "?" + Math.random();
//            loader.load();
//
//            return load;
//        }
    }
}

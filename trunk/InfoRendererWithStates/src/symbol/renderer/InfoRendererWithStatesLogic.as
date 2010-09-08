import mx.core.Application;
import mx.core.UIComponent;
import mx.states.AddChild;
import mx.states.RemoveChild;

private var previewDisplayObject:DisplayObject;
private var previewDisplayObjectWith:uint;
private var previewDisplayObjectHeight:uint;
private var previewDisplayObjectScaleFactor:Number = 0.7;

[Bindable]
private var titleLabelText:String;
[Bindable]
private var detailContent:UIComponent;

private function init():void {
    getData();
    addPreviewDisplayObject();
    initDetailContent();
    effectEndHandler();
}

/**
 * 从data属性中获取契约数据
 */
private function getData():void {
    if (data) {
        previewDisplayObject = data["previewDisplayObject"];
        previewDisplayObjectWith = data["previewDisplayObjectWith"]
        previewDisplayObjectHeight = data["previewDisplayObjectHeight"]

        titleLabelText = data["titleLabelText"];
        detailContent = data["detailContent"];
    }
}

/**
 * 在标题栏右侧添加用于显示预览的组件
 */
private function addPreviewDisplayObject():void {
    if (previewDisplayObject) {
        titleBar.addChild(previewDisplayObject);
        // TODO 直接指定了预览对象, 是否不需要设置组件的大小?
        // initPreviewDisplayObjectWidthHeight();
        // 点击预览显示对象, 切换详细和初始状态
        previewDisplayObject.addEventListener(MouseEvent.CLICK, function ():void {
            toggleDetailState();
        });
    } else if (detailContent) {
        addDetailContentSnapshot();
    }
}

/**
 * 初始化预览显示对象的宽高
 */
private function initPreviewDisplayObjectWidthHeight():void {
    callLater(function ():void {
        if (previewDisplayObjectWith > 0) {
            previewDisplayObject.width = previewDisplayObjectWith;
        } else {
            previewDisplayObject.width = previewDisplayObject.width * previewDisplayObjectScaleFactor;
        }

        if (previewDisplayObjectHeight > 0) {
            previewDisplayObject.height = previewDisplayObjectHeight;
        } else {
            previewDisplayObject.height = previewDisplayObject.height * previewDisplayObjectScaleFactor;
        }
    });
}

/**
 * 添加详细信息显示对象的快照
 */
private function addDetailContentSnapshot():void {
    addDetailContent2Application();

    callLater(function ():void {
        addSnapshot2TitleBar(snapshotDetailContent());
        removeDetailContentFromApplication();
    });
}

/**
 * 将详细信息显示对象添加到主程序中, 并设置为不可见
 */
private function addDetailContent2Application():void {
    detailContent.visible = false;
    detailContent.includeInLayout = false;

    Application.application.addChild(detailContent);
}

/**
 * 将拍照位图添加到标题栏
 */
private function addSnapshot2TitleBar(bitmap:Bitmap):void {
    // 预览对象为拍照的位图
    previewDisplayObject = bitmap;

    var ui:UIComponent = new UIComponent();
    // Bitmap 不能添加鼠标事件, 只能加到UIComponent上
    // TODO 点不中UIComponent?
    ui.addEventListener(MouseEvent.CLICK, function ():void {
        toggleDetailState();
    });
    ui.addChild(bitmap);
    titleBar.addChild(ui);

    // TODO 限制位图大小后, 还是漂浮在TitleBar上面
    initPreviewDisplayObjectWidthHeight();
}

/**
 * 对详细信息显示对象拍照
 */
private function snapshotDetailContent():Bitmap {
    var bmd:BitmapData = new BitmapData(detailContent.width,
        detailContent.height);
    bmd.draw(detailContent);

    return new Bitmap(bmd);
}

/**
 * 将详细信息显示对象从主程序中移除, 恢复其显示属性
 */
private function removeDetailContentFromApplication():void {
    detailContent.visible = true;
    detailContent.includeInLayout = true;

    Application.application.removeChild(detailContent);
}

/**
 * 初始化用于显示详细信息的组件
 */
private function initDetailContent():void {
    var addDetailContent:AddChild = new AddChild(this);
    addDetailContent.targetFactory = new DeferredInstanceFromFunction(
        function ():Object {
            return detailContent;
        }
    );

    // 在动态改变组件后, 有可能详细信息组件已经添加, 需要先删除
    if (detailContent && detailContent.parent) {
        var removeChild:RemoveChild = new RemoveChild(detailContent);
        detailState.overrides.push(removeChild);
    }
    
    detailState.overrides.push(addDetailContent);
}

private function toggleDetailState():void {
    if (currentState != "detailState") {
        currentState = "detailState";
    } else {
        currentState = null;
    }
}

private function rollOverHandler(event:Event):void {
    if (currentState == null || currentState == "") {
        currentState = "titleState";
    }
}

private function rollOutHandler(event:Event):void {
    if (currentState == "titleState") {
        currentState = "";
    }
}

private function effectEndHandler():void {
    parent.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
    parent.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
}

private function effectStartHandler():void {
    parent.removeEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
    parent.removeEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
}

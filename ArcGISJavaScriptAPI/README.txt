ArcGIS JavaScript API v1.6 本地包

原作者: 曾纪锋 alex_zengjf@sina.com
    修改 by Sun 2010-07-05

安本地包后, 使用 ArcGIS javascript API 仅访问本网站文件, 不需要访问http://serverapi.arcgisonline.com
    方便不能访问外网或不能上网的客户端使用, 并增强系统安全性
    方便定制自己特有的样式和改进系统, 如自定义infowindow样式
ArcGIS javascript API 版本为1.6, dojo库版本为1.4.1, 帮助文件请访问http://resources.esri.com/help/9.3/arcgisserver/apis/javascript/arcgis/help/jsapi_start.htm
    本地包仅供方便使用, 其各部分版权为原作者所有, 此本地包作者不承担使用此包引起任何相关的责任, 使用此本地包请保留此文件

新增功能说明
    A.增加配置变量esri.config.defaults.map.zoomAnimDisable, 默认为false.
            当esri.config.defaults.map.zoomAnimDisable为false时, map放大缩小使用CSS动画.
            当esri.config.defaults.map.zoomAnimDisable为true时, map放大缩小不使用CSS动画, 直接缩放, 此时缩放速度快, 所需资源少.
    B.增加配置变量esri.config.defaults.map.SetInfoWindowInBody, 默认为false.
            当esri.config.defaults.map.SetInfoWindowInBody为false时, infowindow的parent元素是map div
            当esri.config.defaults.map.SetInfoWindowInBody为true时, infowindow的parent元素是文档的body, 此时infowindow可浮在上面, 而不是在map div中.
        esri.config.defaults.map.SetInfoWindowInBody仅在创建esri.map前设置有效。
    C.增加配置变量esri.config.defaults.map.InfoWindowbgImageUseGIF, 默认为false.
            当esri.config.defaults.map.InfoWindowbgImageUseGIF为false时, IE6中infowindow的背景图片是png格式文件
            当esri.config.defaults.map.InfoWindowbgImageUseGIF为true时, IE6中infowindow的背景图片是gif格式文件, 此时同名的gif文件必须存放在png文件相同的目录下, 如tundra.infowindow.png的gif文件为tundra.infowindow.gif
            设置esri.config.defaults.map.InfoWindowbgImageUseGIF为true主要用于防止某些IE6及以下的版本使用png格式文件背景图片时崩溃, 参见infowindow的样式修改.
    D.infowindow修正
            修正当map所在的html网页不加首行
      <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">, <meta http-equiv="X-UA-Compatible" content="IE=7" />
            时, 在IE中不能正常显示问题.


1. 安装
    a. 将此目录jsapi拷贝到Web工程目录
        这里将文件放入[WebContent/styles/scripts/arcgis/]
    b. 将文件jsapi/arcgis.js中_1.registerModulePath("esri"，"/arcgis/jsapi/js/esri")的"/arcgis/jsapi/js/esri"改为其对应的URL
        注意一定要带上Web上下文(Context)
        "/ArcGISJavaScriptAPI/styles/scripts/arcgis/jsapi/js/esri"
    c. 如果不同的域其它网站使用此包, 请将文件jsapi/arcgis.js中_1.registerModulePath("esri",(location.protocol === 'file:' ? 'http:' : location.protocol) + '//' + "serverapi.arcgis.com/arcgis/jsapi/js/esri")的"/arcgis/jsapi/js/esri"设为绝对URL地址

2. 使用
   将以下js, 以及theme的css引入到文件中
    <link rel="stylesheet" type="text/css" href="styles/scripts/arcgis/jsapi/js/dojo/dijit/themes/tundra/tundra.css" />
    <script type="text/javascript" src="styles/scripts/arcgis/jsapi/js/dojo/dojo/dojo.js"></script>
    <script type="text/javascript" src="styles/scripts/arcgis/jsapi/js/arcgis.js"></script>


自定义infowindow(样式修改)
  infowindow相关的文件在 jsapi/js/esri/dijit 目录下, 包括css/InfoWindow.css, templates/InfoWindow.html, images/.png .gif文件, 修改其中内容可改变其样式
  images目录下包括yellow目录和default目录, 其中yellow目录为红黄色infowindow
  infowindow.png为默认样式使用, 其他带theme名字(tundra, nihilo, soria)对应dojo各主题
  .png文件为IE7以上, FireFox等使用; .gif文件仅供esri.config.defaults.map.InfoWindowbgImageUseGIF为true时IE6及以下的版本使用.

dojo库
  dojo库放置在 js/dojo 目录下, 版本为1.4.1, dojo说明请访问http://www.dojotoolkit.org/
  theme在 jsapi/js/dojo/dijit/themes 目录下, 包括tundra, nihilo, soria, 引入主题css如 jsapi/js/dojo/dijit/themes/tundra/tundra.css

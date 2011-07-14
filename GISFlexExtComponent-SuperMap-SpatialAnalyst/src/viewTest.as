import com.monkey.supermap.web.spatialanalyst.SpatialAnalystService;
import com.monkey.supermap.web.spatialanalyst.SpatialAnalystService;
import com.monkey.supermap.web.spatialanalyst.buffer.BufferAnalystParameter;
import com.monkey.supermap.web.spatialanalyst.buffer.BufferParameter;
import com.monkey.supermap.web.spatialanalyst.isoline.IsolineParameter;
import com.monkey.supermap.web.spatialanalyst.overlay.OverlayParameter;

import mx.core.UIComponent;
import mx.events.FlexEvent;
import mx.rpc.AsyncResponder;

import org.openscales.core.Map;
import org.openscales.core.control.LayerManager;
import org.openscales.core.control.PanZoom;
import org.openscales.core.events.FeatureEvent;
import org.openscales.core.feature.Feature;
import org.openscales.core.feature.PolygonFeature;
import org.openscales.core.handler.feature.SelectFeaturesHandler;
import org.openscales.core.handler.mouse.DragHandler;
import org.openscales.core.handler.mouse.WheelHandler;
import org.openscales.core.layer.FeatureLayer;
import org.openscales.core.popup.Anchored;
import org.openscales.core.style.Style;
import org.openscales.geometry.Geometry;
import org.openscales.geometry.LinearRing;
import org.openscales.geometry.Point;
import org.openscales.geometry.Polygon;

private var map:Map;

/**
 * 展现要素的临时图层
 */
private var featureLayer:FeatureLayer;
private var popup:Anchored;

private var spatialAnalystService:SpatialAnalystService;

private function init():void {
    var mapContainer:UIComponent = new UIComponent();
    mapContainer.percentWidth = 100;
    mapContainer.percentHeight = 100;
    mapContainer.addEventListener(FlexEvent.CREATION_COMPLETE, initMap);
    addElement(mapContainer);

    this.spatialAnalystService = new SpatialAnalystService("http://cloud.supermap.com.cn/iserver/services/spatialanalyst-sample/restjsr/spatialanalyst/geometry");
}

private function initMap(event:FlexEvent):void {
    var ui:UIComponent = event.target as UIComponent;

    map = new Map(ui.width, ui.height);
    map.addEventListener(FeatureEvent.FEATURE_CLICK, onFeatureClick);

    new DragHandler(map);
    new WheelHandler(map);
    new SelectFeaturesHandler(map);

    map.addControl(new PanZoom());
    map.addControl(new LayerManager());

    addFeatureLayer();
    testSpatialAnalystService();

    ui.addChild(map);
}

/**
 * 在点击地图上的Feature时, 在地图上打开窗口展现要素的属性信息
 */
private function onFeatureClick(event:FeatureEvent):void {
    if(popup) {
        popup.destroy();
    }
    popup = new Anchored();
    popup.feature = event.feature;
    var content:String = "";
    for (var p:String in popup.feature.attributes) {
        content = content + p + " = " + popup.feature.attributes[p] + "\n";
    }
    popup.htmlText = content;
    map.addPopup(popup, true);
}

private function addFeatureLayer():void {
    featureLayer = new FeatureLayer("临时图层");
    featureLayer.style = Style.getDefaultSurfaceStyle();
    map.addLayer(featureLayer, false, true);
}

private function testSpatialAnalystService():void {
    testGeometryBuffer();
    testGeometryOverlay();
    testGeometryIsoline();
}

private function testGeometryBuffer():void {
    var bufferParameter:BufferParameter = new BufferParameter(
        new org.openscales.geometry.Point(1, 2), new BufferAnalystParameter());

    this.spatialAnalystService.geometryBuffer(bufferParameter,
        new AsyncResponder(handlerPointBufferResult, traceFault, this.spatialAnalystService));
}

private function handlerPointBufferResult(bufferResult:Object,
        spatialAnalystService:SpatialAnalystService):void {
    var feature:Feature = new PolygonFeature(spatialAnalystService.getBufferResultGeometry(),
        {label: "Buffered Point"});
    featureLayer.addFeature(feature);
}

private function traceFault(info:Object, token:Object):void {
    trace(info, token);
}

private function testGeometryOverlay():void {
    var vertices:Vector.<Number> = new Vector.<Number>();
    vertices.push(23, 23, 33, 35, 43, 22);
    var ring:LinearRing = new LinearRing(vertices);
    var rings:Vector.<Geometry> = new Vector.<Geometry>();
    rings.push(ring);
    var sourceGeometry:Geometry = new Polygon(rings);

    vertices = new Vector.<Number>();
    vertices.push(23, 23, 34, 47, 50, 12);
    ring = new LinearRing(vertices);
    rings = new Vector.<Geometry>();
    rings.push(ring);
    var operateGeometry:Geometry = new Polygon(rings);

    this.spatialAnalystService.geometryOverlay(
        new OverlayParameter(sourceGeometry, operateGeometry),
        new AsyncResponder(handlerGeometryOverlayResult, traceFault, this.spatialAnalystService));
}

private function handlerGeometryOverlayResult(overlayResult:Object,
        spatialAnalystService:SpatialAnalystService):void {
    var geometry:Geometry = spatialAnalystService.getOverlayResultGeometry();

    var feature:Feature = new PolygonFeature(geometry as Polygon,
        {label: "Overlay Geometry"});
    featureLayer.addFeature(feature);
}

private function testGeometryIsoline():void {
    var pointsJson:String = '[{"y":5846399.011754164,"x":1210581.346513096},{"y":5806144.683668519,"x":1374568.1968855716},{"y":5770737.831291649,"x":1521370.8530005363},{"y":5528199.929583105,"x":1095631.459772168},{"y":5570741.490646067,"x":1198626.2178598372},{"y":5593290.502553593,"x":1373169.3807736137},{"y":5627352.642284978,"x":1612502.8281910105},{"y":5411257.388322545,"x":1081393.2452306529},{"y":5458415.294482666,"x":1369469.8846276256},{"y":5476577.894029853,"x":1479703.1555390328},{"y":5538359.532668987,"x":1625450.5930904327},{"y":5322253.555958582,"x":874680.7560980343},{"y":5387691.351356046,"x":1247212.6046764243},{"y":5365829.12376669,"x":1552293.4250750828},{"y":5189236.973831155,"x":1129966.2695203843},{"y":5263941.139760235,"x":1421971.5173268518},{"y":5316511.814620616,"x":1646535.1712997695},{"y":5380482.773487299,"x":1781263.7373000358},{"y":5387628.373045736,"x":2020110.7478655668},{"y":5149389.373350877,"x":1404994.6955034048},{"y":5175828.876635731,"x":1548389.2686075717},{"y":5309279.172401399,"x":1907367.4314964274},{"y":5293521.857410377,"x":2062286.6638636012},{"y":4976125.839822388,"x":927814.7588465774},{"y":5026632.568699232,"x":1543409.9808747866},{"y":5130288.827051805,"x":1672545.493733304},{"y":5188386.307743394,"x":1815170.6158166437},{"y":5093043.212162165,"x":1776810.620376544},{"y":5157034.502564225,"x":2000720.9392682184},{"y":5251089.301254044,"x":2137211.956299985},{"y":5332054.204347666,"x":-1384684.2197622396},{"y":5275056.308383501,"x":-1266592.6719580323},{"y":5175286.301711081,"x":-1173120.3754703254},{"y":5241172.933846466,"x":-1666090.7220438174},{"y":5203815.902033236,"x":-1462060.0483470496},{"y":5089465.3051254805,"x":-1553103.0628854935},{"y":4985329.134084863,"x":-1122827.8972311313},{"y":5084477.143904437,"x":-1860653.0737309058},{"y":5012320.004497735,"x":-1725720.7392514374},{"y":4847254.456649401,"x":-1220678.0242665065},{"y":4967869.579179868,"x":-1863459.0940122611},{"y":4846715.029039686,"x":-1376674.687197066},{"y":4749993.799084707,"x":-1503256.3959701844},{"y":4733437.6562208235,"x":-1062382.7330463112},{"y":4817393.2495100135,"x":-1666642.3185378732},{"y":4731665.181996931,"x":-1268721.0651795513},{"y":4691431.379461973,"x":-1784339.0745681566},{"y":4643802.532478138,"x":-1537407.4064784427},{"y":4595707.881575817,"x":-2419318.1651853207},{"y":4697780.174467408,"x":-2175064.947991378},{"y":4571808.980501302,"x":-2199394.381915284},{"y":4596066.823439882,"x":-1978125.6284305337},{"y":4496517.046471464,"x":-1432929.6567465703},{"y":4311774.011786542,"x":-1425142.4755286605},{"y":4452868.317491553,"x":-2347377.8808384025},{"y":4340268.274635454,"x":-2287997.73283675},{"y":4250483.425830898,"x":-2163460.0275789727},{"y":4263739.817542193,"x":-1828785.5212808836},{"y":4188669.3150986824,"x":-1212229.2824720086},{"y":4183182.8387389183,"x":-2025606.9271885597},{"y":4710813.7915879795,"x":-825209.3944219579},{"y":4670956.244135948,"x":-925452.7068768775},{"y":4526184.5763541795,"x":-321480.00337016344},{"y":4529087.789700593,"x":-651959.4917517804},{"y":4456951.669698392,"x":-217002.751793607},{"y":4361674.173881491,"x":-862966.0323723028},{"y":4356696.391350958,"x":-665822.612619922},{"y":4318695.188269256,"x":-16755.895493976277},{"y":4291518.681501339,"x":-548534.0275191526},{"y":4214198.760832034,"x":-281463.84777592047},{"y":4217114.789970843,"x":-993942.1769293299},{"y":4188310.296903083,"x":-388864.10082736285},{"y":4147044.700455064,"x":-163911.28277835716},{"y":3994669.652291734,"x":-989326.1699265253},{"y":4097277.4680672437,"x":-831169.1324349911},{"y":4027790.2582361028,"x":-663189.7758112816},{"y":4008890.1524949092,"x":-423251.71794886334},{"y":3985439.0098199043,"x":-185918.90060111196},{"y":3940087.843014853,"x":-887752.6423217809},{"y":3902840.708227953,"x":-607958.6429741071},{"y":3933468.6238576137,"x":-284995.3146274127},{"y":3854005.315530641,"x":-98784.42162919845},{"y":3823156.347624073,"x":-1062959.9844394173},{"y":3808807.6550712436,"x":-378120.5224401556},{"y":3778115.4734166022,"x":0},{"y":4730534.720172568,"x":555675.8939736363},{"y":4852624.171435939,"x":719410.7659517572},{"y":4596256.330055919,"x":416086.8926742442},{"y":4791746.948773282,"x":788837.8597004436},{"y":4453008.152320324,"x":115404.7540462873},{"y":4596011.987461325,"x":641143.9830660761},{"y":4481738.358798096,"x":288969.73549622495},{"y":4503841.155366805,"x":445513.5966258035},{"y":4547533.1139068995,"x":735284.8907746233},{"y":4410713.692703613,"x":554568.91407516},{"y":4443600.751319248,"x":667140.2306366649},{"y":4340461.478129971,"x":697974.317012174},{"y":4275630.554049344,"x":63161.04945440512},{"y":4386963.1282620365,"x":200844.7047105074},{"y":4202007.508177135,"x":253524.48712527702},{"y":4291562.138461853,"x":419214.55097630795},{"y":4246332.741613248,"x":520391.41847044195},{"y":4212339.5650682505,"x":724422.3419775809},{"y":4319799.307435994,"x":803872.4404582562},{"y":4129148.2394462284,"x":104259.64215694086},{"y":4109815.7660399284,"x":403953.28813597944},{"y":4182364.9195765033,"x":658420.2373994242},{"y":4116114.814604882,"x":810569.0478714453},{"y":4015665.7031279653,"x":57888.61285015985},{"y":4051893.798730688,"x":207560.53288720318},{"y":3955829.3950785063,"x":276969.2552145735},{"y":4033619.2114662286,"x":529235.8905866949},{"y":4074202.839647999,"x":652385.2109960385},{"y":3996377.3703957982,"x":696258.0548386875},{"y":4008021.5303751975,"x":828160.9527746729},{"y":3924572.250126263,"x":395141.80540117476},{"y":3987617.532555718,"x":604975.0994465819},{"y":3874146.399281319,"x":574491.97093995},{"y":3900010.4698660634,"x":826688.5654787718},{"y":3798192.2154325526,"x":148384.11511321797},{"y":3820764.883623278,"x":233881.00740820862},{"y":3751682.6673423555,"x":364131.9938371991},{"y":3754910.3556443714,"x":538899.2224736068},{"y":3813977.854491748,"x":658807.4635671165},{"y":3806050.1037092097,"x":792225.2844255305},{"y":4878613.669687378,"x":989879.4510146382},{"y":4913952.113706568,"x":1247443.675713319},{"y":4831270.944774808,"x":1140083.2510781523},{"y":4921315.05493549,"x":1492086.6167464997},{"y":5052757.707713311,"x":1918509.2753008604},{"y":5063796.813019381,"x":2042017.2997923675},{"y":4793681.904221991,"x":877851.0997333587},{"y":4774006.995349113,"x":1040808.5086067809},{"y":4825058.940827238,"x":1372389.7854108089},{"y":4809389.80096441,"x":1543742.5278637896},{"y":4902262.258833995,"x":1597042.343587792},{"y":4895476.54413311,"x":1842559.9434883138},{"y":4599996.604939047,"x":932329.7912851481},{"y":4634929.709817533,"x":1130375.6558870135},{"y":4663722.198935332,"x":1271390.1018698853},{"y":4697792.92263294,"x":1416741.0287793688},{"y":4699147.5474785445,"x":1613992.8644604657},{"y":4827335.189098092,"x":1738675.3002621508},{"y":4866923.041308589,"x":1954423.5716503449},{"y":4493384.048768748,"x":958554.9844920259},{"y":4584793.262616345,"x":1039735.8753779468},{"y":4573368.719742009,"x":1264987.125449884},{"y":4535682.898934459,"x":1326693.9259942314},{"y":4635574.883527959,"x":1504197.3432253445},{"y":4700294.42098123,"x":1780949.1315812443},{"y":4609648.656003613,"x":1736296.8572612894},{"y":4681629.349428268,"x":1892050.8669771217},{"y":4429115.494615303,"x":819736.7840938661},{"y":4391346.676023165,"x":875265.4632116298},{"y":4480718.865042775,"x":1069883.2875826268},{"y":4426733.672017401,"x":1161193.5583540704},{"y":4499741.207576295,"x":1429545.7266807582},{"y":4544119.35480714,"x":1634202.9161613043},{"y":4462966.02017487,"x":1612068.9106345084},{"y":4332966.078239502,"x":963309.0101788022},{"y":4261654.548436485,"x":1032901.8353483415},{"y":4335564.775845768,"x":1105939.225169126},{"y":4317860.357647642,"x":1170895.8407751273},{"y":4217404.249060418,"x":895159.9217773122},{"y":4172037.285068486,"x":1013674.1774255243},{"y":4294064.323209426,"x":1410882.223112259},{"y":4065800.4828681257,"x":981182.9106279407},{"y":4085762.366366327,"x":1083753.047062522},{"y":4132090.7520524934,"x":1318132.2692009804},{"y":4142586.734808678,"x":1529070.0056755273},{"y":3901432.308547681,"x":934688.3653426437},{"y":3979771.3162048385,"x":1055867.4688408729},{"y":3941036.3075741176,"x":1065036.6671956114},{"y":3945317.282583976,"x":1157932.9886013204},{"y":4021239.522476727,"x":1239207.3702849862},{"y":3959852.5588213224,"x":1350795.4103596883},{"y":4049571.6663974132,"x":1410747.9096857496},{"y":3812004.0719843972,"x":930774.7628580885},{"y":3861707.0504562464,"x":1052333.0052869653},{"y":3820762.9488621466,"x":1192606.778480341},{"y":3878446.397744965,"x":1291276.5905477551},{"y":3740457.1322103385,"x":-2280711.2893337477},{"y":3610835.6465768386,"x":-1898494.8947958327},{"y":3432858.020978356,"x":-1399626.0910837462},{"y":3525877.2468072847,"x":-1283933.4892611878},{"y":3417074.9256983995,"x":-1207841.1059202068},{"y":3472059.7109441776,"x":-2235091.7538738195},{"y":3405191.5810551345,"x":-1535719.261658893},{"y":3317974.063750213,"x":-1313233.1022214005},{"y":3215456.023662541,"x":-1668231.0790676079},{"y":3213100.734077703,"x":-1543300.5038628753},{"y":3226788.463817602,"x":-1322861.9636839945},{"y":3174717.875474587,"x":-1726275.5353356437},{"y":3071026.639358625,"x":-1213998.1039728494},{"y":3042582.079568073,"x":-1551388.8266032175},{"y":3718278.012159869,"x":-1134893.926110122},{"y":3541408.5544612724,"x":-891441.2257767961},{"y":3675701.197141478,"x":-834256.4397984666},{"y":3540464.439599922,"x":-732998.0301551202},{"y":3746189.5669284817,"x":-608366.655726914},{"y":3606814.827940583,"x":-487052.6741149729},{"y":3709929.5466406867,"x":-305817.3964722081},{"y":3576785.1318503767,"x":-185572.12330141864},{"y":3736802.08201411,"x":-188273.03422844442},{"y":3671256.446405228,"x":-88798.55268419566},{"y":3554207.6132366266,"x":-7623.304182909062},{"y":3442294.0016021784,"x":-1043182.719348437},{"y":3372470.133392552,"x":-879746.0059734449},{"y":3329846.4658615887,"x":-735820.2624347302},{"y":3385774.1722521205,"x":-598714.2916338673},{"y":3365061.3710883446,"x":-467319.13892095536},{"y":3438511.6724030804,"x":-432661.89096875046},{"y":3289222.03255561,"x":-365797.2908334787},{"y":3388770.1790684424,"x":-257770.63354085243},{"y":3489340.014889814,"x":-225771.69297925572},{"y":3470604.7546822317,"x":-132336.98535452466},{"y":3443468.922936775,"x":-44754.622365783674},{"y":3336462.9567291737,"x":-29663.170191185807},{"y":3188348.3603367843,"x":-562133.8027324993},{"y":3182395.102553785,"x":-451072.0290892085},{"y":3171691.2776708156,"x":-190690.80834799097},{"y":3246944.608980542,"x":-93001.31981324543},{"y":3189044.906916246,"x":-1018939.2432069526},{"y":3075883.6698584314,"x":-452936.7750086531},{"y":3181664.9609899763,"x":-288960.4615969602},{"y":3118781.2239375394,"x":-159790.7445777159},{"y":3048061.6610416863,"x":-728952.0085410624},{"y":3016310.1160733365,"x":-593441.2162723129},{"y":3065512.7917198557,"x":-337546.79149758763},{"y":3037253.544343302,"x":-38674.85881369523},{"y":2870958.9179865606,"x":-562922.8573945801},{"y":2940239.589357,"x":-267015.16607381543},{"y":2876002.748849146,"x":-126172.57311585417},{"y":2832711.954581689,"x":-472704.96379865234},{"y":2800972.8503497858,"x":-272502.7081027229},{"y":2772709.840500228,"x":-170569.94021037238},{"y":2821578.0335128047,"x":-70850.18431489395},{"y":2637288.510643946,"x":-655586.1204770276},{"y":2644172.1839265637,"x":-587777.7267451586},{"y":2703298.899468653,"x":-482287.72041299165},{"y":2700248.2972229365,"x":-313691.5834534966},{"y":2621928.103777759,"x":-349824.7477876109},{"y":2618547.8901200593,"x":-233803.40853525937},{"y":2679316.7597328294,"x":-115340.8723860747},{"y":2531477.8697073124,"x":-728995.1007179908},{"y":2563094.6488132644,"x":-125143.60317222273},{"y":2502934.899520999,"x":-502247.56152175396},{"y":2358890.8824017625,"x":-524954.1072237731},{"y":2292630.5117716733,"x":-439585.3749905917},{"y":2377779.7265067752,"x":-416990.3048070796},{"y":2445570.1604807805,"x":-309745.082737913},{"y":2232920.8583603576,"x":-359916.3992944942},{"y":2352502.548550708,"x":-326398.3321045548},{"y":2436706.3927038647,"x":-166103.91202709795},{"y":3688008.895707773,"x":67600.22720728668},{"y":3663480.15988555,"x":192838.1845297635},{"y":3662810.5969428364,"x":355703.3307535223},{"y":3688204.187762022,"x":458561.3952959383},{"y":3644173.482835289,"x":547133.5219779018},{"y":3718679.28398731,"x":671945.729762831},{"y":3736696.4329654854,"x":777367.1482989233},{"y":3518527.4771429766,"x":186765.44495685885},{"y":3539458.569836056,"x":696201.5730748323},{"y":3638944.5959001407,"x":865109.8551088024},{"y":3408250.6546268538,"x":282035.41013164417},{"y":3484719.53651323,"x":371995.50174161646},{"y":3415764.8766247705,"x":536177.0206151215},{"y":3460331.706550587,"x":617095.7188366835},{"y":3441411.772176821,"x":719233.6364178912},{"y":3546714.9420923963,"x":827799.0231700841},{"y":3449748.548672987,"x":839739.868053981},{"y":3349980.9813490435,"x":90421.65942428632},{"y":3351011.0721426997,"x":165247.2674443215},{"y":3309382.620691914,"x":234913.69606538085},{"y":3299160.426489802,"x":423508.6723597367},{"y":3329772.0768911727,"x":710677.7599318783},{"y":3352006.0765095893,"x":939912.9224508674},{"y":3260166.7845416553,"x":103889.7261913604},{"y":3252089.697622625,"x":264733.74515526387},{"y":3212982.417114271,"x":424247.1094237186},{"y":3269120.012534639,"x":595211.4390030195},{"y":3233715.911396386,"x":681507.1139124233},{"y":3280596.970280573,"x":863121.036452202},{"y":3124913.8838264085,"x":4790.183869418629},{"y":3125950.5461812913,"x":140506.95528566814},{"y":3117269.8929029834,"x":495831.120641366},{"y":3134080.455536591,"x":775380.7644865728},{"y":3107858.762718601,"x":922632.1394875564},{"y":3046593.5443637297,"x":41857.0362429994},{"y":3056211.556197878,"x":207498.12891658462},{"y":3047811.127657084,"x":363960.37935196055},{"y":3014137.9004304614,"x":523881.7779395319},{"y":3086839.0436280575,"x":643823.7842502822},{"y":3002649.08852154,"x":769827.4833575047},{"y":2869651.628693182,"x":27872.931748413404},{"y":2915984.3712338824,"x":184415.713127814},{"y":2947341.330275152,"x":317288.19073703396},{"y":2897186.399902232,"x":459764.10902280925},{"y":2882905.729636032,"x":636193.6001869313},{"y":2898971.7531689852,"x":756729.755392647},{"y":2968738.556166012,"x":916448.8160896833},{"y":2890565.8162698783,"x":976711.3389860386},{"y":2791279.373797482,"x":171902.057106717},{"y":2839146.6111394614,"x":361998.7737941324},{"y":2754915.989578115,"x":476456.06826857},{"y":2822295.1332140043,"x":557463.4371011496},{"y":2772793.281167362,"x":658343.4049611333},{"y":2844691.4542012904,"x":886760.6526373475},{"y":2807138.335144382,"x":943423.4251188046},{"y":2662024.1185623296,"x":18418.80673020621},{"y":2663586.261990063,"x":177481.05336135285},{"y":2709676.473359335,"x":255020.70915318988},{"y":2727489.45631578,"x":352799.33223594585},{"y":2663296.580972992,"x":532908.7569076398},{"y":2735201.310011072,"x":802909.6066380447},{"y":2760413.644147722,"x":998128.5715977435},{"y":3721063.11897967,"x":1096537.3935231194},{"y":3806009.766366724,"x":1264114.542137645},{"y":3659897.8914728835,"x":977303.1653559952},{"y":3667119.1269373465,"x":1276315.61125214},{"y":3702016.0232953187,"x":1383256.4582488476},{"y":3553877.7773890067,"x":993474.6081741418},{"y":3468372.02258786,"x":988812.4707273329},{"y":3574413.543237962,"x":1136200.785387387},{"y":3485554.36380323,"x":1280217.313951403},{"y":3602651.628451882,"x":1404852.6664553324},{"y":3532437.8945520557,"x":1534975.7004949152},{"y":3389316.8374463916,"x":1058628.6776923917},{"y":3451596.5864182524,"x":1137507.2802350293},{"y":3388043.075075766,"x":1273287.3328760872},{"y":3431490.184649596,"x":1352440.043371532},{"y":3404118.136547506,"x":1446840.4410162715},{"y":3430248.270349106,"x":1537904.457715784},{"y":3300696.238288291,"x":1138696.0089750628},{"y":3269372.4020511936,"x":1247991.0128511982},{"y":3310808.8815425243,"x":1368572.0417980603},{"y":3307745.875236407,"x":1436282.3006032947},{"y":3183057.729784578,"x":1050098.71440737},{"y":3165123.623912988,"x":1169757.5286660253},{"y":3247205.0843053535,"x":1508596.8046190727},{"y":3220867.3050061967,"x":1623292.939241635},{"y":3072906.1280205715,"x":1055834.0537688746},{"y":3054259.103116134,"x":1185083.1453954037},{"y":3153271.28341821,"x":1336444.5203740203},{"y":3106608.2953502275,"x":1442694.0693596064},{"y":3162114.3166902494,"x":1532059.5467476053},{"y":3068112.2816459835,"x":1522546.416469869},{"y":2968163.182551749,"x":1139742.5988121654},{"y":2950198.460712459,"x":1222724.7351557822},{"y":3023025.033847958,"x":1249618.6019452491},{"y":3028386.49699655,"x":1317873.8167660807},{"y":2987528.206261337,"x":1488901.1963909506},{"y":2883359.911539713,"x":1118210.8311772407},{"y":2883598.587873241,"x":1301055.0738268332},{"y":2836475.4056941792,"x":1419701.4283473317},{"y":2958458.586052904,"x":1543326.8307900922},{"y":2773249.9748587757,"x":1134190.4428769792},{"y":2797825.8579814397,"x":1230215.3926476222},{"y":2698499.265373066,"x":1210454.4310213025},{"y":2779877.976375714,"x":1308155.9944745468},{"y":2781523.466416342,"x":1478372.5311298936},{"y":2780955.2564035747,"x":1695729.51000478},{"y":2510740.1276242808,"x":6799.328028777925},{"y":2585502.0735023525,"x":308869.62466417975},{"y":2551956.4589385763,"x":447221.76718473545},{"y":2541072.167230608,"x":561536.9253824775},{"y":2617749.620865224,"x":746443.9667971656},{"y":2616622.644095268,"x":870118.731926645},{"y":2526117.355519371,"x":871138.4465391008},{"y":2589894.8107570503,"x":962572.7132316977},{"y":2666076.8500070497,"x":1073650.6683669835},{"y":2595916.050900111,"x":1127265.847895014},{"y":2643960.9529985506,"x":1322781.058915147},{"y":2690579.3581378814,"x":1625448.0503596873},{"y":2439386.410984494,"x":85592.52013502677},{"y":2493652.9343016613,"x":163473.37690824404},{"y":2450556.7211649176,"x":521986.4004062561},{"y":2466884.1465693545,"x":646186.9180199988},{"y":2425626.3189612515,"x":767653.1312149623},{"y":2447486.4696193095,"x":857239.3594679679},{"y":2522243.1889932826,"x":989620.3954393753},{"y":2507730.9163674656,"x":1197469.0237843061},{"y":2515065.5362655967,"x":1575725.7575531695},{"y":2711088.223883681,"x":1724911.1161599383},{"y":2321657.019225234,"x":192226.95533462946},{"y":2358215.7463019025,"x":333125.84907642344},{"y":2340110.4303765353,"x":616071.1196871599},{"y":2386868.0482459776,"x":942101.9799330588},{"y":2427051.4605350755,"x":1069925.2507115088},{"y":2552373.8616701905,"x":1691516.604359593},{"y":2284684.516806565,"x":377265.3007606633},{"y":2232072.6150846556,"x":433410.4215628289},{"y":2212966.147268718,"x":567501.5281171727},{"y":2294192.766526101,"x":726918.621760921},{"y":2285821.6952323783,"x":811372.65703444},{"y":2083802.143100597,"x":569203.736194104},{"y":1974178.475648839,"x":388581.6390896372},{"y":2023621.247856548,"x":490290.1314917419},{"y":1997704.0501551162,"x":586386.7288987899},{"y":1884474.0662141703,"x":489483.43657642923}]';
    var points:Array = JSON.decode(pointsJson);

    var zValuesJson:String = "[-3,-2,0,-1,-3,0,1,0,1,1,1,2,0,3,-2,5,3,2,4,6,5,5,5,2,7,5,3,4,5,4,6,5,4,8,5,9,4,4,9,6,10,8,8,11,-4,15,12,12,12,7,13,11,12,12,12,13,13,11,4,12,5,10,10,5,10,10,8,8,8,10,3,8,9,5,2,5,0,1,6,4,6,11,-5,1,4,5,2,6,2,6,6,6,5,4,8,5,9,10,9,8,7,9,-1,8,10,9,10,14,10,9,9,10,12,10,15,11,11,13,15,9,9,11,15,12,15,3,8,6,7,5,4,4,6,8,8,7,4,3,8,8,8,7,6,6,8,6,10,10,9,6,8,3,10,11,10,10,10,8,10,13,13,12,11,14,13,12,14,13,13,12,14,15,6,13,13,13,13,14,14,14,14,1,1,0,-3,0,4,0,2,7,7,9,3,6,0,-4,1,-2,4,-3,-1,0,2,3,6,15,2,4,8,7,6,1,8,9,2,6,15,17,13,4,17,17,9,5,7,3,12,6,9,18,12,17,12,13,15,13,11,15,17,15,21,17,16,15,21,15,18,20,23,19,24,22,19,19,12,14,15,7,13,12,15,15,15,15,15,16,15,16,16,15,16,17,17,17,17,17,17,17,17,16,17,17,17,18,18,17,18,17,18,8,15,17,18,17,13,16,18,17,17,12,18,19,15,15,17,17,18,17,19,15,20,15,18,19,19,20,15,14,15,15,15,16,16,16,16,15,16,16,17,16,16,17,17,17,8,9,17,12,18,17,17,18,19,18,18,15,18,18,18,12,18,19,19,20,20,18,19,20,20,13,20,26,17,21,21,20,20,20,21,20,19,22,21,25.2,19,22,22,21,23,22,22,22,23,24,23,22,23,23,23,25,23,23,24,23,23,25,25,24,25,26]";
    var zValues:Array = JSON.decode(zValuesJson);

    this.spatialAnalystService.geometryIsoline(
        new IsolineParameter(points, zValues),
        new AsyncResponder(handlerGeometryIsolineResult, traceFault, this.spatialAnalystService));
}

private function handlerGeometryIsolineResult(bufferResult:Object,
        spatialAnalystService:SpatialAnalystService):void {
    var features:Array = spatialAnalystService.getIsolineResultFeatures();
    var featureVector:Vector.<Feature> = Vector.<Feature>(features);
    // TODO 由于SuperMap给的测试数据坐标值非常大, 例如5846399, 因此无法在地图上显示出来, 需要找到可以显示的数据示例
    featureLayer.addFeatures(featureVector);
}

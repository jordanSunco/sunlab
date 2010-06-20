package
{
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	
	import gs.TweenMax;
	import gs.easing.Quad;
	
	import org.papervision3d.materials.BitmapMaterial;
	import org.papervision3d.materials.ColorMaterial;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.primitives.Cube;
	import org.papervision3d.view.BasicView;

	[SWF(width="900", height="480", backgroundColor="0xffffff", frameRate="31")]
	public class FullScreenCube extends BasicView
	{
		[Embed(source="/assets/car.jpg")]
		private var carAsset:Class;

		[Embed(source="/assets/back.jpg")]
		private var backAsset:Class;

		[Embed(source="/assets/brabus.jpg")]
		private var brabusAsset:Class;

		[Embed(source="/assets/ferrari.jpg")]
		private var ferrariAsset:Class;
		
		private var cube:Cube;		
		private var mouseDownX:Number = 0;
		private var targetRotation:Number = 0;
		
		public function FullScreenCube()
		{
			super(900, 480);
			viewport.x = -650;
			
			opaqueBackground = 0x000000;
			camera.focus = 100;
			camera.zoom = 10;
			
			var materialsList:MaterialsList = new MaterialsList();
			materialsList.addMaterial(createBitmapMaterialFromAsset(carAsset), "front");
			materialsList.addMaterial(createBitmapMaterialFromAsset(backAsset), "back");
			materialsList.addMaterial(createBitmapMaterialFromAsset(brabusAsset), "left");
			materialsList.addMaterial(createBitmapMaterialFromAsset(ferrariAsset), "right");
			materialsList.addMaterial(new ColorMaterial(0xffffff), "top");
			materialsList.addMaterial(new ColorMaterial(0xffffff), "bottom");
			
			cube = new Cube(materialsList, 900, 900, 480);
			cube.z = 450;
			scene.addChild(cube);
			
			startRendering();
			
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}
		
		private function createBitmapMaterialFromAsset(asset:Class):BitmapMaterial
		{
			var bitmap:Bitmap = new asset() as Bitmap;
			var material:BitmapMaterial = new BitmapMaterial(bitmap.bitmapData, true);
			
			return material;
		}
		
		private function mouseDownHandler(event:MouseEvent):void
		{
			mouseDownX = event.localX;
		}
		
		private function mouseUpHandler(event:MouseEvent):void
		{
			var currentMouseX:Number = event.localX;
			if(currentMouseX < mouseDownX)
			{
				targetRotation += 90;
				
			}
			else
			{
				targetRotation -= 90;
			}
			TweenMax.to(cube, .5, {rotationY:targetRotation, z:450, bezierThrough:[{z:700}], ease:Quad.easeInOut});
		}
	}
}

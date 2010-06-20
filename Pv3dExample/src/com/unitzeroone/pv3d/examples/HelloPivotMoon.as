package com.unitzeroone.pv3d.examples {
	import flash.display.BitmapData;
	import flash.events.Event;

	import org.papervision3d.materials.BitmapMaterial;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.primitives.Sphere;
	import org.papervision3d.view.BasicView;

	/**
	 * @author Ralph Hauwert
	 */
	public class HelloPivotMoon extends BasicView {
		protected var moon:Sphere;
		protected var moonBitmapData:BitmapData;
		protected var moonMaterial:BitmapMaterial;
		protected var moonPivotPoint:DisplayObject3D;

		protected var world:Sphere;
		protected var worldBitmapData:BitmapData;
		protected var worldMaterial:BitmapMaterial;

		/**
		 * HelloPivotMoon
		 * 
		 * HelloPivotMoon extends BasicView, which is an utility class for Papervision3D, which automatically sets up
		 * Scene, Camera, Renderer and Viewport for you.
		 * 
		 * This allows for easy Papervision3D initialization.
		 * 
		 * This HelloPivotMoon example utilizes BasicView to set up the the basics, and then extends upon it and setup a basic primitive and material.
		 * 
		 * HelloPivotMoon shows the usage of displayobject3D nesting to allow for rotation around pivot points, whilst still enabling rotations around the original origin.
		 */	
		public function HelloPivotMoon() {
			// Call the BasicView constructor.
			// Width and Height are set to 1, since scaleToStage is set to true, these will be overriden.
			// We will not use interactivity and keep the default cameraType.
//			super(1, 1, true, false);
			super(450, 300, false, false);

			//Color the background of this basicview / helloworld instance black.
			opaqueBackground = 0;

			//Create the materials and primitives.
			initScene();

			//Call the native startRendering function, to render every frame.
			startRendering();
		}

		/**
		 * initScene will create the needed primitives, and materials.
		 */
		protected function initScene():void {
			//Create a new bitmapdata to be used as a texture for our world.
			worldBitmapData = new BitmapData(512, 256, false, 0);
			//Use perlin noise to colorize the texture....for examples sake.
			worldBitmapData.perlinNoise(512, 256, 4, 123456, true, false);

			//Create a material to be used by the sphere primitive.
			//The Material will utilize the bitmapData we just created as a texture.
			worldMaterial = new BitmapMaterial(worldBitmapData);

			//Create the world primitive, using the native Sphere primitive.
			world = new Sphere(worldMaterial, 300, 10,10);

			//Add the world to the scene, which is already instanciated by the super BasicView.
			scene.addChild(world);

			//Create a bitmapdata to be used as a texture for the moon.			
			moonBitmapData = new BitmapData(256,128, false,0);

			//Use grayscale perlinnoise to fill the moontexture.
			moonBitmapData.perlinNoise(256,127,8,1234,true, true,7,true);

			//Use a bitmapmaterial which uses the moonBitmapData to use for the moon Sphere primitive
			moonMaterial = new BitmapMaterial(moonBitmapData, false);

			//Setup the moon Sphere, new material....50....
			moon = new Sphere(moonMaterial, 50);

			//Offset the moon's x position to it's parent.
			moon.x = 450;

			//Create an empty DisplayObject3D, to be used as a parent for the moon sphere primitive.
			moonPivotPoint = new DisplayObject3D();

			//Add the moon to the displayobject3d which we will use as a pivot point.
			moonPivotPoint.addChild(moon);

			//Add the pivot point containing the moon to the scene.
			scene.addChild(moonPivotPoint);
		}

		/**
		 * onRenderTick();
		 * 
		 * onRenderTick can be overriden so you can execute code on a per render basis, using basicview.
		 * in this case we use it to
		 */
		override protected function onRenderTick(event:Event=null):void {
			//Rotate the world Sphere primitive.
			world.yaw(1);

			//Rotate the moon around it's own axis.
			moon.yaw(-2);

			//Rotate the pivot point, which in turn makes the nested moon rotate around the earth.
			moonPivotPoint.yaw(1);

			//Call the super.onRenderTick function, which renders the scene to the viewport using the renderer and camera classes.
			super.onRenderTick(event);
		}
	}
}

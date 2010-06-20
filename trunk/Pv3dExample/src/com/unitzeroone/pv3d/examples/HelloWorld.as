package com.unitzeroone.pv3d.examples {
	import flash.display.BitmapData;
	import flash.events.Event;

	import org.papervision3d.materials.BitmapMaterial;
	import org.papervision3d.objects.primitives.Sphere;
	import org.papervision3d.view.BasicView;

	/**
	 * @author Ralph Hauwert
	 */
	public class HelloWorld extends BasicView {
		protected var world:Sphere;
		protected var worldBitmapData:BitmapData;
		protected var worldMaterial:BitmapMaterial;

		/**
		 * HelloWorld
		 * 
		 * HelloWorld extends BasicView, which is an utility class for Papervision3D, which automatically sets up
		 * Scene, Camera, Renderer and Viewport for you.
		 * 
		 * This allows for easy Papervision3D initialization.
		 * 
		 * This HelloWorld example utilizes BasicView to set up the the basics, and then extends upon it and setup a basic primitive and material.
		 */	
		public function HelloWorld() {
			// Call the BasicView constructor.
			// Width and Height are set to 1, since scaleToStage is set to true, these will be overriden.
			// We will not use interactivity and keep the default cameraType.
			super(1, 1, true, false);

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
			world = new Sphere(worldMaterial, 300, 10, 10);

			//Add the world to the scene, which is already instanciated by the super BasicView.
			scene.addChild(world);
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

			//Call the super.onRenderTick function, which renders the scene to the viewport using the renderer and camera classes.
			super.onRenderTick(event);
		}
	}
}

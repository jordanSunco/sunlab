package com.frogiology {
	import caurina.transitions.Tweener;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.ColorTransform;
	import flash.utils.Dictionary;
	import org.papervision3d.core.geom.Vertex3D;

	// Import Papervision3D
	import org.papervision3d.core.proto.*;
	import org.papervision3d.scenes.*;
	import org.papervision3d.cameras.*;
	import org.papervision3d.objects.*;
	import org.papervision3d.materials.*;

	public class Main extends Sprite {
		
		public var container :Sprite;
		private var scene     :MovieScene3D;
		private var camera    :Camera3D;
		
		private var planeByContainer :Dictionary = new Dictionary();
		
		private const PLANE_NUM:Number = 50;
		private const RADIUS:Number = 400;
		private const CAMERA_MOVE_BACK:Number = 600;
		
		public function Main() {
			init3D();
		}
		
		private function init3D():void {
			// Create scene
			scene = new MovieScene3D( container );

			// Create camera
			camera = new Camera3D();
			camera.zoom = 5;
			
			//setup the 3D space
			var material:MovieAssetMaterial = new MovieAssetMaterial( "LogoMc", true );

			material.doubleSided = true;
			material.lineColor = 0xFFFFFF;
			material.updateBitmap();
			
			for (var i:int = 0; i < PLANE_NUM; i++) {
				var plane :Plane = new Plane(material, 150, 135, 2, 2);
				var angle:Number = i * Math.PI / 8;
				
				plane.x = RADIUS * Math.cos(angle);
				plane.y = (i - PLANE_NUM / 2) * 35;
				plane.z = RADIUS * Math.sin(angle);
				
				//plane.rotationX = 30;
				plane.rotationY = 270 - angle * 180 / Math.PI;
				
				scene.addChild(plane, "LogoMc" + i);
				
				var container:Sprite = plane.container;
				container.buttonMode = true;
				
				plane.container.addEventListener(MouseEvent.CLICK, this.onPlaneClick);
				plane.container.addEventListener(MouseEvent.MOUSE_OVER, this.onPlaneOver);
				plane.container.addEventListener(MouseEvent.MOUSE_OUT, this.onPlaneOut);
				
				planeByContainer[container] = plane;
			}
			
			// Render
			this.updateScene();
		}
		
		private function onPlaneClick(e:Event):void {
			var plane:Plane = planeByContainer[e.target];
			
			var target :DisplayObject3D = new DisplayObject3D();
			
			target.copyTransform(plane);
			target.moveBackward(CAMERA_MOVE_BACK);
			
			Tweener.addTween(camera, {
				x: target.x,
				y: target.y,
				z: target.z,
				time: 2
			});
			
			Tweener.addTween(camera.target, {
				x: plane.x,
				y: plane.y,
				z: plane.z,
				time: 2,
				onUpdate: this.updateScene
			});
		};
		
		private function onPlaneOver(e:Event):void {
			var plane:Plane = planeByContainer[e.target];
			
			Tweener.addTween(plane, {
				scaleX: 1.2,
				scaleY: 1.2,
				scaleZ: 1.2,
				time: 1,
				transition: "easeOutElastic",
				onUpdate: this.updateScene
			});
		}
		
		private function onPlaneOut(e:Event):void {
			var plane:Plane = planeByContainer[e.target];
			
			Tweener.addTween(plane, {
				scaleX: 1,
				scaleY: 1,
				scaleZ: 1,
				time: 1,
				transition: "easeOutElastic",
				onUpdate: this.updateScene
			});
		}
		
		private function updateScene() {
			scene.renderCamera( this.camera );
		}
	}
}
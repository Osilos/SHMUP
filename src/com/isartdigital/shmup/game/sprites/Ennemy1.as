package com.isartdigital.shmup.game.sprites 
{
	import com.isartdigital.shmup.game.GameManager;
	import com.isartdigital.shmup.game.planes.GamePlane;
	import com.isartdigital.shmup.ui.hud.Hud;
	import com.isartdigital.utils.sound.SoundFX;
	import flash.display.MovieClip;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Flavien
	 */ 
	public class Ennemy1 extends Ennemy
	{
		private static var Direction:String = "DOWN";
		
		private const MARGIN_SCREEN:int = 100;
		private var speed:Number = 5;
		
		public var move:Function;
		private var j:Number = Math.PI / 2;
		private var yOrigin:Number;
		private var upOrDown:String;
				
		public var meltingEnnemy:Vector.<Ennemy1> = new Vector.<Ennemy1>;

		
		public function Ennemy1(pX:Number, pY:Number) 
		{
			super();
			
			x = pX;
			y = yOrigin = pY;
			
			collider();
			
			upOrDown = Direction;
			Direction = Direction == "DOWN" ? "UP" : "DOWN";
			move = toLeftStart;
			life = 30;
			SCORE_VALUE = 100;
			generateCollectable = false;

		}
		
		override public function hit_by_bullet(pDegat:Number):void {
			life -= pDegat;
			if (life <= 0) {
				Player.getInstance().energy += ENERGY_VALUE;
				Hud.getInstance().score += SCORE_VALUE;
				Player.getInstance().refreshHUD();
				destroy();
			} else anim.play();
		}
		
		//Remplie le tableau de collision
		override public function collider():void {
			for (var i:int = 0; i < GameManager.getInstance().ennemyList.length; i++ ) {
				if (GameManager.getInstance().ennemyList[i] != this) {
					if (GameManager.getInstance().ennemyList[i] is Ennemy1) {
						var testX:Number = x - GameManager.getInstance().ennemyList[i].x;
						if ( testX <= width && testX >= -width) {
							meltingEnnemy.push(GameManager.getInstance().ennemyList[i]);
						}
					}
				}
			}
		}
		
		override protected function doActionNormal():void {
			if(this != null) super.doActionNormal();
			if (!isDestroy) move();
			if (meltingEnnemy != null && this != null) melting_test();
		}
		
		override protected function melting_test():void {
			for (var i = meltingEnnemy.length - 1; i >= 0; i--) {
				if (meltingEnnemy[i].isDestroy) {
					meltingEnnemy.splice(i, 1);
				} else {
					if (hitBox.hitTestObject(meltingEnnemy[i].hitBox) && x < GamePlane.currentScreenLimits.right - 400) {
						meltingEnnemy[i].destroy();
						GameManager.getInstance().createEnnemy2(x, y);
						Ennemy.fusionSound.start();
						destroy();
						break;
					}
				}
			}
		}
		
		private function toLeftStart():void {
			x -= speed;
			if (x < GamePlane.currentScreenLimits.right - GamePlane.currentScreenLimits.width / 4) move = toTurn;
		}
		
		public function toLeft():void {
			x -= speed;
		}
		
		private function toTurn():void { 
			x++;
			y = yOrigin +(Math.cos(j) * 120);
			j += upOrDown == "DOWN" ? 0.05: -0.05;
			if (j > 10 || j < -10) move = toLeft;
		}
		
		override public function destroy():void {
			move = null;
			meltingEnnemy = null;
			super.destroy();
		}
	}

}
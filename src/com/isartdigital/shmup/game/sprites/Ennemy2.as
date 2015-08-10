package com.isartdigital.shmup.game.sprites 
{
	import com.isartdigital.shmup.game.GameManager;
	import com.isartdigital.shmup.game.planes.GamePlane;
	import com.isartdigital.shmup.ui.hud.Hud;
	import com.isartdigital.utils.sound.SoundFX;
	/**
	 * ...
	 * @author Flavien
	 */
	public class Ennemy2 extends Ennemy
	{
		private const TIME_TO_SHOOT = 100;
		private var shootTime:Number = 0;
		private var speed:Number = 10;
		private var  movable:Boolean = false;
		
		private var meltingEnnemy:Vector.<Ennemy2> = new Vector.<Ennemy2>;
		
		public function Ennemy2(pX:Number, pY:Number) 
		{			
			super();
			
			x = pX;
			y = pY;
			
			collider();
			
			direction = 1;
			
			life = 60;
			SCORE_VALUE= 200;
		}
		
		override protected function doActionNormal():void {
			
			
			
			if (shootTime == TIME_TO_SHOOT) {
				shootTime = 0;
				GameManager.getInstance().createEnnemyShoot(x, y);
			} else shootTime++;
			
			if (movable) move();
			else if (x < GamePlane.currentScreenLimits.right - GamePlane.currentScreenLimits.width / 2) movable = true;
			
			if (meltingEnnemy != null) melting_test();
			super.doActionNormal();
		}
		
		/*
		 * Function qui initialise un tableau d'ennemi, possiblement collisionable.
		 */
		override public function collider():void {
			for (var i:int = 0; i < GameManager.getInstance().ennemyList.length; i++ ) {
				if (GameManager.getInstance().ennemyList[i] != this) {
					if (GameManager.getInstance().ennemyList[i] is Ennemy2) {
							meltingEnnemy.push(GameManager.getInstance().ennemyList[i]);
					}
				}
			}
		}
		
		/*
		 * Test si il est collision avec un ennemi du tableau meltingEnnemy
		 */
		override protected function melting_test():void {
			for (var i = meltingEnnemy.length - 1; i >= 0; i--) {
				if (meltingEnnemy[i].hitBox == null) {
					meltingEnnemy.splice(i, 1);
				} else {
					if (hitBox.hitTestObject(meltingEnnemy[i].hitBox)) {
						meltingEnnemy[i].destroy();
						GameManager.getInstance().createEnnemy3(x, y);
						Ennemy.fusionSound.start();
						destroy();
						break;
					}
				}
			}
		}
		
		private function move():void {
			x += GamePlane.ScrollSpeed;
			x += speed * direction;
			if (x > GamePlane.currentScreenLimits.right - width) direction *= -1;
		}
		
		 override public function destroy():void {
			meltingEnnemy = null;
			super.destroy();
		}
	}

}
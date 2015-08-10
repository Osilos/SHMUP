package com.isartdigital.shmup.game.sprites 
{
	import com.isartdigital.shmup.game.GameManager;
	import com.isartdigital.shmup.game.planes.GamePlane;
	import com.isartdigital.shmup.ui.hud.Hud;
	import com.isartdigital.utils.sound.SoundFX;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Flavien
	 */
	public class Ennemy3 extends Ennemy 
	{
		private const TIME_TO_SHOOT:Number = 60;
		private var shootTime:Number = 0;
		
		private var speedX:Number = 3;
		private var speedY:Number = 5;
		
		public function Ennemy3(pX:Number, pY:Number) 
		{	
			super();
			
			x = pX;
			y = pY;
			
			life = 120;
			SCORE_VALUE = 250;
		}
		
		override protected function doActionNormal():void {
			shootTime++;
			if (shootTime == TIME_TO_SHOOT) {
				shootTime = 0;
				GameManager.getInstance().createEnnemyShoot(x, y);
			}
			move();
			super.doActionNormal();
		}
		
		private function move():void {
			x += GamePlane.ScrollSpeed;
			x += speedX;
			y += speedY
			if (y < GamePlane.currentScreenLimits.y) speedY = Math.abs(speedY);
			else if (y > GamePlane.currentScreenLimits.height) speedY = - Math.abs(speedY);
			if (x > GamePlane.currentScreenLimits.right) speedX =  -Math.abs(speedX);
		}
		
	}

}
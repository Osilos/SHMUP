package com.isartdigital.shmup.game.sprites 
{
	import com.isartdigital.shmup.game.GameManager;
	import com.isartdigital.shmup.game.planes.GamePlane;
	import com.isartdigital.utils.game.StateGraphic;
	/**
	 * ...
	 * @author Flavien
	 */
	public class BulletEnemy extends Bullet
	{		
		public function BulletEnemy() 
		{
			super();
			speed = 15;
		}
		
		override protected function hit_test():void {
			if (hitBox.hitTestObject(Player.getInstance().hitBox)) {
				Player.getInstance().hit_by_bullet(this);
				destroy();
			}
		}
		
		override protected function move():void {
			x -= speed;
			x += GamePlane.ScrollSpeed;
		}
	}

}
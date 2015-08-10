package com.isartdigital.shmup.game.sprites 
{
	import com.isartdigital.shmup.game.GameManager;
	import com.isartdigital.shmup.game.planes.GamePlane;
	import com.isartdigital.utils.game.StateGraphic;
	/**
	 * ...
	 * @author Flavien
	 */
	public class Bullet extends StateGraphic
	{
		protected var speed:Number = 40;
		protected var damage:Number = 20;
		public var isDestroy:Boolean = false;
		
		public function Bullet(power:String = null) 
		{	
			if (power == "Big") {
				isBigBullet();
			}
			super();
			cacheAsBitmap = true;
		}
		
		private function isBigBullet():void {
			assetName = "BigBullet";
			damage = 60;
			Player.getInstance().bigShoot --;
		}
		
		override protected function doActionNormal():void {
			move();
			if (!isDestroy) hit_test();
			exit_test();
			
			
		}
		
		protected function move():void {
			x += GamePlane.ScrollSpeed + speed;
		}
		
		protected function hit_test():void {
			for (var i = GameManager.getInstance().ennemyList.length - 1; i >= 0; i--) {
				if (GameManager.getInstance().ennemyList[i].isDestroy) continue;
				else if (hitBox.hitTestObject(GameManager.getInstance().ennemyList[i].hitBox)) {
					GameManager.getInstance().ennemyList[i].hit_by_bullet(damage);
					destroy();
					break;
				}
			}
		}
		
		protected function exit_test():void {
			if (isDestroy) return;
			if (x < GamePlane.currentScreenLimits.x) destroy();
			if (x > GamePlane.currentScreenLimits.right) destroy();
		}
		
		override public function destroy():void {
			parent.removeChild(this);
			super.destroy();
			isDestroy = true;
		}
	}

}
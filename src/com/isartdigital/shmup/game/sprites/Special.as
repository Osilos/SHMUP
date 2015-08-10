package com.isartdigital.shmup.game.sprites 
{
	import com.isartdigital.shmup.game.GameManager;
	import com.isartdigital.shmup.game.planes.GamePlane;
	import com.isartdigital.shmup.ui.hud.Hud;
	import com.isartdigital.utils.game.StateGraphic;
	/**
	 * ...
	 * @author Flavien
	 */
	public class Special extends Bullet
	{
		private const SPLIT_SCORE:Number = 100;
		
		public static var instance:Special = null;
		
		
		
		public function Special() 
		{
			super();
			start();
			instance = this;
		}
		
		override protected function doActionNormal():void {
			super.doActionNormal();
		}
		
		override protected function move():void {
			x += speed + GamePlane.ScrollSpeed;
		}
		
		override protected function hit_test():void {
			for (var i = GameManager.getInstance().ennemyList.length - 1 ; i >= 0; i--) {
				if (GameManager.getInstance().ennemyList[i].isDestroy) continue;
				if (hitBox.hitTestObject(GameManager.getInstance().ennemyList[i].hitBox)) {
					if (GameManager.getInstance().ennemyList[i] is Ennemy1) {
						GameManager.getInstance().ennemyList[i].y += GameManager.getInstance().ennemyList[i].y > y ? width: - width;
						Hud.getInstance().score += SPLIT_SCORE;
						break;
					} else if (GameManager.getInstance().ennemyList[i] is Ennemy2) {
						GameManager.getInstance().splitEnnemy2(GameManager.getInstance().ennemyList[i].x, y, height);
						Hud.getInstance().score += SPLIT_SCORE;
						GameManager.getInstance().ennemyList[i].destroy();
						GameManager.getInstance().createExplosion(x, y);
						break;
					} else if (GameManager.getInstance().ennemyList[i] is Ennemy3){
						GameManager.getInstance().splitEnnemy3(GameManager.getInstance().ennemyList[i].x, y, height);
						Hud.getInstance().score += SPLIT_SCORE;
						GameManager.getInstance().ennemyList[i].destroy();
						GameManager.getInstance().createExplosion(x, y);
						break;
					}
				}
			}
		}
		
		override public function destroy():void {
			instance = null;
			super.destroy();
		}
	}

}
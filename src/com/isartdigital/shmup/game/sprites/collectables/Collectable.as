package com.isartdigital.shmup.game.sprites.collectables 
{
	import com.isartdigital.shmup.game.GameManager;
	import com.isartdigital.shmup.game.planes.GamePlane;
	import com.isartdigital.shmup.game.sprites.Player;
	import com.isartdigital.shmup.ui.hud.Hud;
	import com.isartdigital.utils.game.StateGraphic;
	import com.isartdigital.utils.sound.SoundFX;
	/**
	 * ...
	 * @author Flavien
	 */
	public class Collectable extends StateGraphic
	{
		private const SCORE_VALUE:Number = 50;
		protected static var BigShootSound:SoundFX = new SoundFX("powerup_firePower");
		protected static var LifeSound:SoundFX = new SoundFX("powerup_life");
		protected static var SmartBombSound:SoundFX = new SoundFX("powerup_bomb");
		protected static var TripleShootSound:SoundFX = new SoundFX("powerup_fireUpgrade");
		
		
		public var isDestroy = false;
		
		public function Collectable() 
		{
			super();
			cacheAsBitmap = true;
		}
		
		override protected function doActionNormal():void {
			if (hitBox.hitTestObject(Player.getInstance().hitBox)) {
				effect();
				Hud.getInstance().score += SCORE_VALUE;
				destroy();
			}
			if (x < GamePlane.currentScreenLimits.x) destroy();
		}
		
		protected function effect():void {
			
		}
		
		override public function destroy():void {
			if (parent.contains(this)) parent.removeChild(this);
			isDestroy = true;
		}
		
	}

}
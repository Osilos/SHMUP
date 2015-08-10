package com.isartdigital.shmup.game.sprites 
{
	import com.isartdigital.shmup.game.GameManager;
	import com.isartdigital.shmup.game.planes.GamePlane;
	import com.isartdigital.shmup.ui.hud.Hud;
	import com.isartdigital.utils.game.GameStage;
	import com.isartdigital.utils.game.StateGraphic;
	import com.isartdigital.utils.sound.SoundFX;
	/**
	 * ...
	 * @author Flavien
	 */
	public class Ennemy extends StateGraphic
	{
		protected const ENERGY_VALUE:Number = 50;
		protected var SCORE_VALUE:Number;
		protected var life:Number = 10;
		protected var generateCollectable:Boolean = true;
		
		protected static var explosionSound:SoundFX = new SoundFX("enemy_explosion");
		protected static var fusionSound:SoundFX = new SoundFX("enemy_fusion");
		
		public var direction:Number;
		public var isDestroy:Boolean = false;

		public function Ennemy() 
		{
			super();
			
			init();
			anim.stop();
		}
		
		private function init():void {
			GameManager.getInstance().ennemyList.push(this);
			start();
		}
		
		protected function exit_test():void {
			if (isDestroy) return;
			if (x < GamePlane.currentScreenLimits.x) destroy();
		}
		
		override protected function doActionNormal():void {
			anim_test();
			exit_test();
		}
		
		protected function anim_test():void {
			if (anim == null) return;
			if (anim.isPlaying) {
				if (isAnimEnd()) {
					anim.stop();
					anim.gotoAndStop(0);
				}
			}
		}
		
		protected function melting_test():void {
			
		}  
		
		public function collider():void {
			
		}
		
		public function hit_by_bullet(pDegat:Number):void {
			life -= pDegat;
			if (life <= 0) {
				Player.getInstance().energy += ENERGY_VALUE;
				Hud.getInstance().score += SCORE_VALUE;
				Player.getInstance().refreshHUD();
				if (generateCollectable) GameManager.getInstance().createCollectable(x, y);
				destroy();
				Ennemy.explosionSound.start();
			} else anim.play();
		}
		
		override public function destroy():void {
			isDestroy = true;
			if (life <= 0) GameManager.getInstance().createExplosion(x, y);
			parent.removeChild(this);
			super.destroy();
		}
		
	}

}
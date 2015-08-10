package com.isartdigital.shmup.game.sprites 
{
	import com.isartdigital.shmup.game.GameManager;
	import com.isartdigital.utils.game.GameObject;
	import com.isartdigital.utils.game.StateGraphic;
	/**
	 * ...
	 * @author Flavien
	 */
	public class Explosion extends StateGraphic
	{
		public var isDestroy = false;
		//FUNCTION PUBLIC
		
		override protected function doActionNormal():void {
			if (anim.currentFrame == anim.totalFrames) {//Si l'animation est entièrement joué
				anim.stop();
				destroy();
			}
		}
		
		override public function destroy():void {
			parent.removeChild(this);
			isDestroy = true;
		}		
		//CONSTRUCTEUR
		public function Explosion()
		{
			
			simpleBox = true;
			super();
			GameManager.getInstance().explosionList.push(this);
		}
		
	}
}
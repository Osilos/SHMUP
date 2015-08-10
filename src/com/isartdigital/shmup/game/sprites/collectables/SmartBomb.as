package com.isartdigital.shmup.game.sprites.collectables 
{
	import com.isartdigital.shmup.game.sprites.Player;
	import com.isartdigital.shmup.ui.hud.Hud;
	import com.isartdigital.utils.game.StateGraphic;
	import com.isartdigital.utils.sound.SoundFX;
	/**
	 * ...
	 * @author Flavien
	 */
	public class SmartBomb extends Collectable
	{		
		public function SmartBomb() 
		{
			super();
		}
		
		override protected function effect():void {
			Collectable.SmartBombSound.start();
			Player.getInstance().bombNumber++;
		}
	}

}
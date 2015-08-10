package com.isartdigital.shmup.game.sprites.collectables 
{
	import com.isartdigital.shmup.game.sprites.Player;
	import com.isartdigital.utils.game.StateGraphic;
	import com.isartdigital.utils.sound.SoundFX;
	/**
	 * ...
	 * @author Flavien
	 */
	public class TripleShoot extends Collectable
	{		
		public function TripleShoot() 
		{
			super();
		}
		override protected function effect():void {
			Player.getInstance().tripleShoot += 3;
			Collectable.TripleShootSound.start();
		}
	}

}
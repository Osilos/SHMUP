package com.isartdigital.shmup.game.sprites.collectables 
{
	import com.isartdigital.shmup.game.sprites.Player;
	import com.isartdigital.utils.sound.SoundFX;
	/**
	 * ...
	 * @author Flavien
	 */
	public class BigShoot extends Collectable
	{
		
		public function BigShoot() 
		{
			super();
		}
		
		override protected function effect():void {
			Collectable.BigShootSound.start();
			Player.getInstance().bigShoot += 9;
		}
	}

}
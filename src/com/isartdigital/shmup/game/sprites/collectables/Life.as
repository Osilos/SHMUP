package com.isartdigital.shmup.game.sprites.collectables 
{
	import com.isartdigital.shmup.game.sprites.Player;
	import com.isartdigital.utils.sound.SoundFX;
	/**
	 * ...
	 * @author Flavien
	 */
	public class Life extends Collectable
	{
		
		public function Life() 
		{
			super();
		}
		
		override protected function effect():void {
			Collectable.LifeSound.start();
			Player.getInstance().lifePoints++;
			Player.getInstance().refreshHUD();
			//TO DO: lancement de l'anim getLife
		}		
	}

}
package com.isartdigital.shmup.game.sprites.collectables 
{
	import com.isartdigital.shmup.game.sprites.Player;
	/**
	 * ...
	 * @author Flavien
	 */
	public class Shield extends Collectable
	{
		
		public function Shield() 
		{
			super();
		}
		
		override protected function effect():void {
			Player.getInstance().killable = false;
		}
	}

}
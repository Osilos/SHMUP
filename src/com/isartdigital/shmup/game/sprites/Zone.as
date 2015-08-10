package com.isartdigital.shmup.game.sprites 
{
	import com.isartdigital.utils.game.StateGraphic;
	/**
	 * ...
	 * @author Flavien
	 */
	public class Zone extends StateGraphic
	{
		public var shieldZone:Boolean = false;
		public var bombZone:Boolean = false;
		
		public function Zone() 
		{
			simpleBox = true;
			super();
			
		}
		
		override protected function doActionNormal():void {

		}
	}

}
package com.isartdigital.shmup.ui 
{
	import com.isartdigital.utils.ui.Screen;
	import com.isartdigital.shmup.ui.UIManager;
	import com.isartdigital.utils.ui.UIPosition;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * Classe mère des écrans de fin
	 * @author Mathieu ANTHOINE
	 */
	public class EndScreen extends Screen 
	{
		
		public var mcBackground:Sprite;
		
		public var btnNext:SimpleButton;
	
		public function EndScreen() 
		{
			super();
		}
		
		override protected function onResize (pEvent:Event=null): void {	
			UIManager.getInstance().setPosition(mcBackground, UIPosition.FIT_SCREEN);
		}

	}
}
package com.isartdigital.shmup.ui 
{
	import com.isartdigital.utils.sound.SoundFX;
	import com.isartdigital.utils.ui.Screen;
	import com.isartdigital.shmup.ui.UIManager;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * Ecran principal
	 * @author Mathieu ANTHOINE
	 */
	public class TitleCard extends Screen
	{
		
		/**
		 * instance unique de la classe TitleCard
		 */
		protected static var instance: TitleCard;
		
		public var btnPlay:SimpleButton;
		
		public var uiSound:SoundFX = new SoundFX("ui_loop");
		
		public function TitleCard() 
		{
			super();
		}
		
		/**
		 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
		 * @return instance unique
		 */
		public static function getInstance (): TitleCard {
			if (instance == null) instance = new TitleCard();
			return instance;
		}
				
		override protected function init (pEvent:Event): void {
			super.init(pEvent);	
			//trace("init ok");
			uiSound.start();
			btnPlay.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		protected function onClick (pEvent:MouseEvent) : void {
			var lClickSound:SoundFX =  new SoundFX("click");
			lClickSound.start();
			UIManager.getInstance().addScreen(Help.getInstance());
			//TODO: if score > score_newbie skip helpscreen
		}
		
		/**
		 * détruit l'instance unique et met sa référence interne à null
		 */
		override public function destroy (): void {
			btnPlay.removeEventListener(MouseEvent.CLICK, onClick);
			instance = null;
			super.destroy();
		}

	}
}
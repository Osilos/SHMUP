package com.isartdigital.shmup.ui 
{
	import com.isartdigital.shmup.game.GameManager;
	import com.isartdigital.shmup.game.planes.GamePlane;
	import com.isartdigital.shmup.game.sprites.Player;
	import com.isartdigital.shmup.ui.hud.Hud;
	import com.isartdigital.utils.sound.SoundFX;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	/**
	 * Ecran de Victoire (Singleton)
	 * @author Mathieu ANTHOINE
	 */
	public class WinScreen extends EndScreen 
	{
		/**
		 * instance unique de la classe WinScreen
		 */
		protected static var instance: WinScreen;
		
		public var Field:Sprite;
		
		public function WinScreen() 
		{
			super();
			btnNext.addEventListener(MouseEvent.CLICK, nextScreen);
		}
		
		/**
		 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
		 * @return instance unique
		 */
		public static function getInstance (): WinScreen {
			if (instance == null) instance = new WinScreen();
			return instance;
		}
		
		private function nextScreen(e:MouseEvent):void 
		{
			GameManager.stopMusic();
			var lClickSound:SoundFX =  new SoundFX("click");
			lClickSound.start();
			GamePlane.getInstance().x = 0;
			GamePlane.getInstance().reset();
			Player.getInstance().destroy();
			GameManager.getInstance().init();
			Hud.getInstance().score = 0;
			Hud.getInstance().parent.removeChild(Hud.getInstance());
			UIManager.getInstance().addScreen(TitleCard.getInstance());
		}
		
		/**
		 * détruit l'instance unique et met sa référence interne à null
		*/
		override public function destroy (): void {
			instance = null;
			super.destroy();
		}
		
	}

}
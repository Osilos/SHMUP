package com.isartdigital.shmup.ui.hud 
{
	import com.isartdigital.shmup.controller.Controller;
	import com.isartdigital.utils.Config;
	import com.isartdigital.utils.ui.Screen;
	import com.isartdigital.shmup.ui.UIManager;
	import com.isartdigital.utils.ui.UIPosition;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	
	/**
	 * Classe en charge de gérer les informations du Hud
	 * @author Mathieu ANTHOINE
	 */
	public class Hud extends Screen 
	{
		
		/**
		 * instance unique de la classe Hud
		 */
		protected static var instance: Hud;
		
		public var mcTopLeft:Sprite;
		public var mcTopCenter:Sprite;
		public var mcTopRight:Sprite;
		public var mcBottomRight:Sprite;
	
		
		//Score
		public var score:Number = 0;
		
		public function Hud() 
		{
			super();
			if (!Config.debug && Controller.type != Controller.TOUCH) {
				removeChild(mcBottomRight);
				mcBottomRight = null;
			}
		}
		
		/**
		 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
		 * @return instance unique
		 */
		public static function getInstance (): Hud {
			if (instance == null) instance = new Hud();
			return instance;
		}
		
		/**
		 * repositionne les éléments du Hud
		 * @param	pEvent
		 */
		override protected function onResize (pEvent:Event=null): void {
			UIManager.getInstance().setPosition(mcTopLeft, UIPosition.TOP_LEFT);
			UIManager.getInstance().setPosition(mcTopCenter, UIPosition.TOP);
			UIManager.getInstance().setPosition(mcTopRight, UIPosition.TOP_RIGHT);
			if (mcBottomRight!=null) UIManager.getInstance().setPosition(mcBottomRight, UIPosition.BOTTOM_RIGHT);
		}
		
		/**
		 * détruit l'instance unique et met sa référence interne à null
		 */
		override public function destroy (): void {
			instance = null;
			super.destroy();
		}
		
		public function updateScore():void
		{
			TextField(mcTopCenter.getChildByName("txtScore")).text = "" + score;
		}
		
		public function updateLife(pLIFE_MAX:Number, pLifePoints:Number):void {
			for (var i:int = pLIFE_MAX - 1; i >= 0; i--) {
				var mclife:DisplayObject = Hud.getInstance().mcTopRight.getChildByName("mcLife" + i );
				if (i < pLifePoints) mclife.visible = true; 
				else mclife.visible = false;
			}
		}
		
		public function updateBomb(pBOMB_MAX:Number, pBombNumber:Number):void {
			for (var j:int = pBOMB_MAX - 1; j >= 0; j--) {
				var mcbomb:DisplayObject = Hud.getInstance().mcTopLeft.getChildByName("mcBomb" + j);
				if (j < pBombNumber) mcbomb.visible = true;
				else mcbomb.visible = false;
			}
		}
		
		public function updateSpecialBar(pEnergy:Number):void {
			var lBar = mcTopLeft.getChildByName("mcSpecialBar");
			var lmcBar:DisplayObject = lBar.getChildByName("mcBar");
			
			lmcBar.x = pEnergy * 3 - 300;
			if (lmcBar.x >= 0) {
				//upSpecialSound.start();
				lmcBar.x = 0;
			}
		}

	}
}
package com.isartdigital.shmup.ui {
	
	import com.isartdigital.shmup.ui.hud.Hud;
	import com.isartdigital.utils.Config;
	import com.isartdigital.utils.game.GameStage;
	import com.isartdigital.utils.ui.Screen;
	import com.isartdigital.utils.ui.UIPosition;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	/**
	 * Manager (Singleton) en charge de gérer les écrans d'interface
	 * @author Mathieu ANTHOINE
	 */
	public class UIManager 
	{
		
		/**
		 * instance unique de la classe UIManager
		 */
		protected static var instance: UIManager;
	
		public function UIManager() 
		{
			
		}
		
		/**
		 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
		 * @return instance unique
		 */
		public static function getInstance (): UIManager {
			if (instance == null) instance = new UIManager();
			return instance;
		}
		
		/**
		 * Ajoute un écran dans le conteneur de Screens en s'assurant qu'il n'y en a pas d'autres
		 * @param	pScreen
		 */
		public function addScreen (pScreen: Screen): void {
			closeScreens();
			GameStage.getInstance().getScreensContainer().addChild(pScreen);
		}
		
		/**
		 * Supprimer les écrans dans le conteneur de Screens
		 * @param	pScreen
		 */
		public function closeScreens (): void {
			while (GameStage.getInstance().getScreensContainer().numChildren > 0) {
				Screen(GameStage.getInstance().getScreensContainer().getChildAt(0)).destroy();
				GameStage.getInstance().getScreensContainer().removeChildAt(0);
			}
		}
		
		/**
		* 
		* @param	pTarget DisplayObject à positionner
		* @param	pPosition type de positionnement
		* @param	pOffsetX décalage en X (positif si c'est vers l'interieur de la zone de jeu sinon en négatif)
		* @param	pOffsetY décalage en Y (positif si c'est vers l'interieur de la zone de jeu sinon en négatif)
		*/
		public function setPosition (pTarget:DisplayObject, pPosition:String, pOffsetX:Number = 0, pOffsetY:Number = 0): void {
			
			if (pTarget.parent == null) return;
			
			var lTopLeft:Point = new Point (0, 0);
			var lBottomRight:Point = new Point (Config.stage.stageWidth, Config.stage.stageHeight);
			
			lTopLeft = pTarget.parent.globalToLocal(lTopLeft);
			lBottomRight = pTarget.parent.globalToLocal(lBottomRight);
			lBottomRight.subtract(lTopLeft);
			
			if (pPosition == UIPosition.TOP || pPosition == UIPosition.TOP_LEFT || pPosition == UIPosition.TOP_RIGHT) pTarget.y = lTopLeft.y + pOffsetY;
			if (pPosition == UIPosition.BOTTOM || pPosition == UIPosition.BOTTOM_LEFT || pPosition == UIPosition.BOTTOM_RIGHT) pTarget.y = lBottomRight.y - pOffsetY;
			if (pPosition == UIPosition.LEFT || pPosition == UIPosition.TOP_LEFT || pPosition == UIPosition.BOTTOM_LEFT) pTarget.x = lTopLeft.x + pOffsetX;
			if (pPosition == UIPosition.RIGHT || pPosition == UIPosition.TOP_RIGHT || pPosition == UIPosition.BOTTOM_RIGHT) pTarget.x = lBottomRight.x - pOffsetX;
			
			if (pPosition == UIPosition.FIT_WIDTH || pPosition == UIPosition.FIT_SCREEN) {
				pTarget.x = lTopLeft.x;
				pTarget.width = lBottomRight.x - lTopLeft.x;
			}
			if (pPosition == UIPosition.FIT_HEIGHT || pPosition == UIPosition.FIT_SCREEN) {
				pTarget.y = lTopLeft.y;
				pTarget.height = lBottomRight.y - lTopLeft.y;
			}

		}
		
		/**
		 * lance le jeu
		 */
		 public function startGame (): void {
			closeScreens();
			GameStage.getInstance().getHudContainer().addChild(Hud.getInstance());			
		}
		
		/**
		 * détruit l'instance unique et met sa référence interne à null
		 */
		public function destroy (): void {
			instance = null;
		}

	}
	
}
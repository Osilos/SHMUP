package com.isartdigital.shmup.game.planes 
{
	import com.isartdigital.shmup.game.levelDesign.GameObjectsGenerator;
	import com.isartdigital.shmup.game.sprites.Player;
	import com.isartdigital.utils.game.GameStage;
	import flash.geom.Rectangle;
	
	/**
	 * Classe "plan de jeu", elle contient tous les éléments du jeu, Generateurs, Player, Ennemis, shoots...
	 * @author Mathieu ANTHOINE
	 */
	public class GamePlane extends HorizontalScrollingPlane 
	{
		static public var ScrollSpeed:Number = 8;
		static public var currentScreenLimits:Rectangle;
		protected const MARGING_SAFE:Number = 200;
		
		/**
		 * instance unique de la classe GamePlane
		 */
		protected static var instance: GamePlane;

		public function GamePlane() 
		{
			super();
			
			addChild(Player.getInstance());
			Player.getInstance().y = getScreenLimits().height / 2;
			listClip.sort(compareX);
			currentScreenLimits = getScreenLimits();
		}      
		/**
		 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
		 * @return instance unique
		 */
		public static function getInstance (): GamePlane {
			if (instance == null) instance = new GamePlane();
			return instance;
		}
		private function compareX(a, b):int {
			var aX:Number = a.x;
			var bX:Number = b.x
			if (aX < bX) return 1;
			else if (aX > bX) return -1;
			else return 0;
		}
		override protected function doActionNormal():void 
		{
			x -= ScrollSpeed;
			currentScreenLimits = getScreenLimits();
			for (var i:int = listClip.length - 1; i >= 0; i-- ) {
				if (listClip[i].x  < getScreenLimits().right + getScreenLimits().width / 2) {
					listClip[i].generate();
					listClip.pop();					
				} else break;
			}
		}
		
		override protected function init():void {
			if (listClip.length == 0){
				for (var i:int = 0; i < numChildren; i++) {
					listClip.push(getChildAt(i));
				}
			}
		}
		
		public function reset():void {
			//super.reset();
			listClip = null;
			parent.removeChild(this);
			instance = null;
			
		}

	}
}
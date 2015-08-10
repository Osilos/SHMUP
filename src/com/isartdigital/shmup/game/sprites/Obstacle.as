package com.isartdigital.shmup.game.sprites 
{
	import com.isartdigital.shmup.game.GameManager;
	import com.isartdigital.shmup.game.planes.GamePlane;
	import com.isartdigital.utils.game.StateGraphic;
	
	/**
	 * Classe Obstacle
	 * Cette classe hérite de la classe StateGraphic elle possède donc une propriété anim représentation graphique
	 * de l'obstacle et une propriété box servant de boite de collision de l'Obstacle
	 * @author Mathieu ANTHOINE
	 */
	public class Obstacle extends StateGraphic 
	{
		public var numEnnemyLink:Number = 0;
		/**
		 * Constructeur de la classe Object
		 * @param	pAsset Nom de la classe du Generateur de l'Obstacle. Ce nom permet d'identifier l'Obstacle et le créer en conséquence
		 */
		public function Obstacle(pAsset:String) 
		{
			assetName = pAsset;
			simpleBox = true;
			init();
			super();	
		}
		
		protected function init():void {
			//GameManager.getInstance().explosionList.push(this);
		}
		
		override protected function doActionNormal():void {
			
		}
	}

}
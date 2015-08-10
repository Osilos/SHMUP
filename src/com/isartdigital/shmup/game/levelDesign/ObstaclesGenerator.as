package com.isartdigital.shmup.game.levelDesign 
{
	import com.isartdigital.shmup.game.sprites.Obstacle;
	import flash.utils.getQualifiedClassName;
	/**
	 * Classe qui permet de générer des Obstacles dans le GamePlane
	 * @author Mathieu ANTHOINE
	 */
	public class ObstaclesGenerator extends GameObjectsGenerator 
	{
		
		public function ObstaclesGenerator() 
		{
			super();
		}
		
		/**
		 * Méthode generate surchargeant la méthode de la classe mère
		 * Crée un Obstacle à l'endroit du générateur et retire le générateur
		 * transmet le nom de la classe du generateur à l'instance d'Obstacle lui permettant ainsi de savoir quel Obstacle créer
		 */
		override public function generate (): void {
			var lObstacle:Obstacle = new Obstacle(getQualifiedClassName(this));
			
			lObstacle.x = x;
			lObstacle.y = y;
			
			parent.addChild(lObstacle);
			lObstacle.start();
			super.generate();
		}
		
		
	}

}
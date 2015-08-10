package com.isartdigital.shmup.game.levelDesign
{
	import com.isartdigital.shmup.game.GameManager;
	import com.isartdigital.shmup.game.planes.GamePlane;
	import com.isartdigital.shmup.game.sprites.Boss;
	import com.isartdigital.shmup.game.sprites.Ennemy;
	import com.isartdigital.shmup.game.sprites.Ennemy1;
	import com.isartdigital.shmup.game.sprites.Ennemy2;
	import com.isartdigital.shmup.game.sprites.Ennemy3;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * Classe qui permet de générer des classes d'ennemis
	 * TODO: S'inspirer de la classe ObstacleGenerator pour le développement
	 * @author Mathieu ANTHOINE
	 */
	public class EnemySpawnsGenerator extends GameObjectsGenerator
	{
		
		public function EnemySpawnsGenerator()
		{
			super();
		
		}
		
		private function choseEnnemy():Ennemy {
			if (getQualifiedClassName(this) == "SecondaryEnnemy") return new Ennemy2(x, y) as Ennemy;
			if (getQualifiedClassName(this) == "BigEnnemy") return new Ennemy3(x, y) as Ennemy;
			if (getQualifiedClassName(this) == "SimpleEnnemy") return new Ennemy1(x, y) as Ennemy;
			
			return null;
		}
		
		override public function generate():void
		{
			if (getQualifiedClassName(this) == "BigBoss") {
				var lBoss = new Boss();
				lBoss.x = x;
				lBoss.y = y;
				GamePlane.getInstance().addChild(lBoss);
			} else {
				var lEnnemy:Ennemy = choseEnnemy();
				if (lEnnemy == null) trace("Erreur dans la definition de classe, voir la bibliothèque du .fla");
				GamePlane.getInstance().addChild(lEnnemy);
				lEnnemy.collider();
			}
			super.generate();
		}
	
	}

}
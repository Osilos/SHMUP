package com.isartdigital.shmup.game.sprites 
{
	import com.isartdigital.shmup.game.GameManager;
	import com.isartdigital.shmup.game.planes.GamePlane;
	import com.isartdigital.shmup.ui.hud.Hud;
	import com.isartdigital.utils.game.StateGraphic;
	import com.isartdigital.utils.sound.SoundFX;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Boss extends StateGraphic
	{
		
		/**
		 * instance unique de la classe Boss
		 */
		public static var instance: Boss;
		
		/**
		 * variable pour compteur de frames
		 */
		protected var compteur:uint;
		
		/**
		 * variable de temps à attendre avant déclenchement de l'attaque, unité Frame
		 */
		protected var timeToAttack:uint;
		
		/**
		 * tableau des frames auxquelles le boss Shoot
		 */
		protected var tabFrameShoot:Array;

		// etats du boss
		protected const ATTACK_STATE:String = "attack";
		
		/**
		* Etat du déplacement du boss
		*/
		private var move:Function; 
		
		/**
		 * Phase d'attack en cours
		 */
		private var attack:Function;
		
		/**
		 * Vie du Boss
		 */
		protected var life:int = 40;
		
		/**
		 * Valeur du Boss en points
		 */
		protected var SCORE_VALUE:int = 1000;
		
		/**
		 * Son d'explosion
		 */
		protected var explosionSound:SoundFX = new SoundFX("enemy_explosion");
		protected var musicOne:SoundFX = new SoundFX("boss_loop0");
		protected var musicTwo:SoundFX = new SoundFX("boss_loop1");
		protected var musicThree:SoundFX = new SoundFX("boss_loop2");
		protected var shootSound:SoundFX = new SoundFX("boss_shoot");
		
		//variable utiliser pour le mouvement
		private var upOrDown:Boolean = true;
		
		public function Boss() 
		{
			instance = this;
			
			// permet d'utiliser une box de collision différente suivant l'état du Boss.
			simpleBox = false;
			
			compteur = 0;
			timeToAttack = 120;
			
			super();
			
			start();
			move = moveVoid;
			attack = firstAttack;
			GameManager.stopMusic();
			musicOne.loop();
			
		}
		
		public function stopMusic() : void {
			musicOne.stop();
			musicTwo.stop();
			musicThree.stop();
		}
		
		override protected function doActionNormal(): void {
			// Compte les frame pour savoir quand lancer l'attaque
			if (compteur == timeToAttack)
			{
				compteur = 0;
				shootSound.start();
				setModeAttack();
			}
			compteur++;
			move();
			testHit();
			
		}
		
		/**
		 * applique le mode normal (mode par defaut)
		 */
		protected function setModeAttack(): void {
			doAction = doActionAttack;
			setState (ATTACK_STATE);
		}
		
		/**
		 * fonction destinée à appliquer le comportement d'attack
		 */
		protected function doActionAttack (): void {
			
			attack();
			// Si l'animation touche à sa fin, l'attaque est terminée, retour au comportement par défaut
			if (isAnimEnd())
			{
				setState (DEFAULT_STATE, true);
				setModeNormal();
			}
			
			moveWait();
			testHit();
		}
		
		/**
		 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
		 * @return instance unique
		 */
		public static function getInstance (): Boss {
			if (instance == null) instance = new Boss();
			return instance;
		}
		
		/**
		 * détruit l'instance unique et met sa référence interne à null
		 */
		override public function destroy (): void {
			Hud.getInstance().score += SCORE_VALUE
			instance = null;
			explosionSound.destroy();
			explosionSound = null;
			super.destroy();
			GameManager.getInstance().win();
		}
		
		/**
		 * Troisième phase d'attack
		 */
		private function thirdAttack():void {
			if (anim.currentFrame % 12 == 0) {
				
				var lEnnemy:Ennemy1 = new Ennemy1(x, y - height / 2);
				GamePlane.getInstance().addChild(lEnnemy);
				lEnnemy.move = lEnnemy.toLeft;
				lEnnemy.meltingEnnemy = null;
				
				var lEnnemyb:Ennemy1 = new Ennemy1(x, y + height / 2);
				GamePlane.getInstance().addChild(lEnnemyb);
				lEnnemyb.move = lEnnemyb.toLeft;
				lEnnemyb.meltingEnnemy = null;
				var lEnnemyc:Ennemy1 = new Ennemy1(x, y);
				GamePlane.getInstance().addChild(lEnnemyc);
				lEnnemyc.move = lEnnemyc.toLeft;
				lEnnemyc.meltingEnnemy = null;
				if (life <= 0)  {
					musicThree.stop();
					destroy();
				}
			}
		}
		 
		/**
		 * Seconde Phase d'attack
		 */
		private function secondAttack():void {
			if (anim.currentFrame % 5 == 0){
				var i:Number = Math.floor(Math.random() * 3);
				if (i == 1) GameManager.getInstance().createEnnemyShoot(x, y - height / 2);
				if (i == 2) GameManager.getInstance().createEnnemyShoot(x, y + height / 2);
				if (i == 0) GameManager.getInstance().createEnnemyShoot(x, y);
			}
			if (life <= 15) {
				musicTwo.stop();
				musicThree.loop();
				timeToAttack = 80;
				upOrDown = false;
				attack = thirdAttack;
			}
		}
		
		/**
		 * Première Phase d'attack
		 */
		private function firstAttack():void {
			if (life <= 30) {
				musicOne.stop();
				musicTwo.loop();
				attack = secondAttack;
			}
			if (isAnimEnd()){
				var lEnemeny:Ennemy3 = new Ennemy3(x, y + height/2);
				GamePlane.getInstance().addChild(lEnemeny);
				}
			}
		
		/**
		 * Test si le Boss se fait toucher.
		 */
		private function testHit():void {
			var lGameManager:GameManager = GameManager.getInstance();
			for (var i = lGameManager.bulletList.length - 1; i >= 0; i--) {
				if (hitBox == null) break;
				if (lGameManager.bulletList[i].isDestroy) continue;
				if (lGameManager.bulletList[i] is BulletEnemy) continue;
				if (hitBox.hitTestObject(lGameManager.bulletList[i].hitBox)) {
					GameManager.getInstance().createExplosion(lGameManager.bulletList[i].x, lGameManager.bulletList[i].y);
					explosionSound.start();
					lGameManager.bulletList[i].destroy();
					life--;
				} 
				if (hitTestObject(Player.getInstance().hitBox)) Player.getInstance().loseLife();
			}
		}
		
		/**
		 * Déplace le Boss en mode Normale
		 */
		private function moveNormal():void {
			moveWait();
			if (upOrDown) {
				x-= 5;
				y--;
				if (y - height / 2 < GamePlane.currentScreenLimits.y) upOrDown = false;
			} else {
				x+= 5;
			    y++;
				if (x > GamePlane.currentScreenLimits.right - 400) move = moveWait;
				else if (x + width / 2 > GamePlane.currentScreenLimits.right) upOrDown = true;
			}
		}
		
		/**
		 * Deplace le Boss de haut en bas
		 */
		private function moveFinal():void {
			moveWait();
			if (upOrDown) {
				y--;
				if (y - height / 2 - 100 < GamePlane.currentScreenLimits.y) upOrDown = false;
			} else {
				y++;
				if (y + height / 2 > GamePlane.currentScreenLimits.bottom) upOrDown = true;
			}
		}
		
		/**
		 * Le boss ne bouge pas
		 */
		private function moveVoid():void {
			if (x < GamePlane.currentScreenLimits.right - width) move = moveNormal;
		}
		
		/**
		 * Le Boss reste où il est
		 */
		private function moveWait():void {
			x += GamePlane.ScrollSpeed;
		}
	}
}
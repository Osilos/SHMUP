package com.isartdigital.shmup.game.sprites 
{
	import com.isartdigital.shmup.controller.Controller;
	import com.isartdigital.shmup.controller.Keyboard;
	import com.isartdigital.shmup.controller.Pad;
	import com.isartdigital.shmup.controller.Touch;
	import com.isartdigital.shmup.game.GameManager;
	import com.isartdigital.shmup.game.planes.GamePlane;
	import com.isartdigital.shmup.game.planes.HorizontalScrollingPlane;
	import com.isartdigital.shmup.ui.hud.Hud;
	import com.isartdigital.utils.game.StateGraphic;
	import com.isartdigital.utils.sound.SoundFX;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	/**
	 * Classe du joueur (Singleton)
	 * En tant que classe héritant de StateGraphic, Playuer contient un certain nombre d'états définis par les constantes LEFT_STATE, RIGHT_STATE, etc.
	 * @author Mathieu ANTHOINE
	 */
	public class Player extends StateGraphic
	{
		
		/**
		 * instance unique de la classe Player
		 */
		protected static var instance: Player;
		
		/**
		 * controleur de jeu
		 */
		public var controller: Controller;
		
		/**
		 * vitesse du joueur
		 */
		protected var speed:Number = 25;
		
		/**
		 * marge par rapport aux bords de l'écran 
		 */
		protected const MARGIN_SCREEN:int = 100;
		
		// etats du joueur
		protected const LEFT_STATE:String = "left";
		protected const RIGHT_STATE:String = "right";
		protected const UP_STATE:String = "up";
		protected const DOWN_STATE:String = "down";
		protected const HIT_STATE:String = "hit";
		
		//Ancienne position du joueur
		private var old_x:Number;
		private var old_y:Number;
		
		//Points de vie du joueur
		private const LIFE_MAX:Number = 5;
		public var lifePoints:Number = LIFE_MAX;
		public var timerlife:Number = 0;
		
		//Nombre de SmartBomb
		public var bombNumber:Number = 0;
		public const BOMB_MAX:Number = 4;
		private var bombZone:BombZone = new BombZone();
		
		//BigShoot number
		public var bigShoot:Number = 0;
		
		//TripleShoot number
		public var tripleShoot:Number = 0;
		
		//etat killable
		public var  killable:Boolean = true;
		private var timerUnKillable:Number = 0;
		private const time_to_shield:Number = 4 * 60; // 60 = frames par secondes
		private var shieldZone:ShieldZone = new ShieldZone();
		
		//timer
		/**
		 * Cadence de tir en Frames par Secondes
		 */
		protected const TIME_TO_SHOOT:Number = 20;
		protected var shootTimer:Number = 0;
		
		/**
		 * Energy
		 */
		public var energy:Number = 0;
		public const COST_SPECIAL:Number = 90;
		
		//Son utiliser par le joueur:
		private var shootSound:SoundFX = new SoundFX("player_shoot");
		private var bombSound:SoundFX = new SoundFX("bomb");
		private var specialSound:SoundFX = new SoundFX("special");
		private var loselifeSound:SoundFX = new SoundFX("loselife");
		private var upSpecialSound:SoundFX = new SoundFX("powerup_special");
		private var playerDeadSound:SoundFX = new SoundFX("player_explosion");
		private var BigShootSound:SoundFX = new SoundFX("powerup_firePower");
		
		
		//instance du GamePlane
		//private var iGamePlane:GamePlane = GamePlane.getInstance();
		
			
		public function Player() 
		{
			simpleBox = true;
			super();
			
			// crée le controleur correspondant à la configuration du jeu
			// upcasting du controleur: controller (new Pad()) -> On lui assigne un nouvel objet Pad, Touch ou Keyboard et on l'upcast pour correspondre au type de la propriété controller
			if (Controller.type == Controller.PAD) controller = Controller(new Pad());
			else if (Controller.type == Controller.TOUCH) controller = Controller(new Touch());
			else controller = Controller(new Keyboard());
			refreshHUD();
			
			addChild(shieldZone);
			shieldZone.visible = false;
			
			addChild(bombZone);
			bombZone.visible = false;
			
		}
		
		/**
		 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
		 * @return instance unique
		 */
		public static function getInstance (): Player {
			if (instance == null) instance = new Player();
			return instance;
		}
		
		/**
		 * détruit l'instance unique et met sa référence interne à null
		 */
		override public function destroy (): void {
			if (Boss.instance != null) Boss.getInstance().stopMusic();
			playerDeadSound.start();
			instance = null;
			removeChild(bombZone);
			bombZone.destroy();
			bombZone = null;
			removeChild(shieldZone);
			shieldZone.destroy();
			shieldZone = null;
			shootSound.destroy();
			bombSound.destroy();
			specialSound.destroy();
			loselifeSound.destroy();
			upSpecialSound.destroy();
			super.destroy();
		}
		
		override protected function doActionNormal():void 
		{
			shootTimer++;
			if (shootTimer >= TIME_TO_SHOOT) {
				shootTimer = 0;
				shoot();
				if (controller.bomb && bombNumber > 0) {
					GameManager.getInstance().useBomb();
					bombSound.start();
				}
				
			}
			//Deplace le joueur
			move();
			
			//Gêre le coût special
			if (controller.special && energy > COST_SPECIAL && Special.instance == null) {
				specialSound.start();
				GameManager.getInstance().createSpecial(x, y);
				energy -= COST_SPECIAL;
				Hud.getInstance().updateSpecialBar(energy);
			}
			
			//lance le test de hit uniquemen si la touche G n'est pas activé et que le shield  n'est pas activé
			if (!controller.god && killable) {
				shieldZone.visible = false;
			}	else if (!controller.god) { //lance le timer du bouclier si il est activé
				timerShield();
				shieldZone.visible = true;
			} else shieldZone.visible = true;
			if (timerlife != 0) timerlife--;
			
			//Gêre l'affichaage de la bombZone
			if (bombNumber == 0) bombZone.visible = false;
			else bombZone.visible = true;
			
			//rafraichi l'hud:
			Hud.getInstance().updateBomb(BOMB_MAX, bombNumber);
			Hud.getInstance().updateScore();
		}
		
		/*
		 * Fonction qui controlle la prise de dégats
		 */
		public function hit_by_bullet(lBullet:BulletEnemy):void {
			if (!controller.god && killable) {
				//TO DO: lance l'animation du player touché
				loseLife();
				Hud.getInstance().updateLife(LIFE_MAX, lifePoints);
			}
		}
		
		/*
		 * Actualise l'HUD
		 */
		public function refreshHUD():void {
			//rafraichie les vies
			Hud.getInstance().updateLife(LIFE_MAX, lifePoints);
			//rafraichie les bombs
			Hud.getInstance().updateBomb(BOMB_MAX, bombNumber);
			//rafraichi la spécial bar
			Hud.getInstance().updateSpecialBar(energy);
			//score
			Hud.getInstance().updateScore();
		}
		
		/*
		 * gère le timer du shield
		 */
		private function timerShield():void {
			if (timerUnKillable == time_to_shield) {
				killable = true;
				timerUnKillable = 0;
			} else timerUnKillable++;
		}

		/*
		 * Function qui gêre la prise de dégat
		 */
		public function loseLife():void {
			if (timerlife == 0) {
				lifePoints--;
				loselifeSound.start();
				timerlife = 90;
				setState(HIT_STATE);
			}
			Hud.getInstance().updateLife(LIFE_MAX, lifePoints);
		}
		
		/*
		 * Test si la touche "fire" est activé.
		 */ 
		private function shoot():void {
			if (controller.fire && tripleShoot == 0) {
				GameManager.getInstance().createShoot();
				shootSound.start();
			}
			else if (controller.fire && tripleShoot > 0) {
				GameManager.getInstance().createTripleShoot();
				BigShootSound.start();
				tripleShoot--;
			}
		}
		
		/*
		 * Déplace le joueur en fonction des touches appuyé, appel la fonction "changeState"
		 */
		private function move():void {
			x += GamePlane.ScrollSpeed;
			old_x = x;
			old_y = y;
			
			var lScreen:Rectangle = GamePlane.currentScreenLimits;
			if (x > MARGIN_SCREEN + lScreen.x && x < lScreen.x + lScreen.width / 2) {
					x += speed * (controller.right - controller.left);
					if (x < MARGIN_SCREEN + lScreen.x) x = old_x;
					if ( x > lScreen.x + lScreen.width / 2) x = old_x;
				}
			if (y > MARGIN_SCREEN + lScreen.y && y < lScreen.bottom - MARGIN_SCREEN) {
					y += speed * (controller.down - controller.up);
					if (y < MARGIN_SCREEN + lScreen.y) y = old_y;
					if ( y > lScreen.bottom - MARGIN_SCREEN) y = old_y;
				}
			changeState();
		}
		
		/*
		 * Change l'état du player en fonction de son déplacement entre la dernière frames et la frames actuel
		 */
		private function changeState():void {
			
			if (timerlife != 0) return;
			
			if (x - old_x < 0) {
				setState(LEFT_STATE);
			}
			
			else if (x - old_x > 0) {
				setState(RIGHT_STATE);
			}
			
			else if (y - old_y < 0) {
				setState(UP_STATE);
			}
			
			else if (y - old_y > 0) {
				setState(DOWN_STATE);
			}
			else setState(DEFAULT_STATE);
			
		}

	}
}
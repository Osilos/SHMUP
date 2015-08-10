package com.isartdigital.shmup.game {
	
	import com.isartdigital.shmup.game.planes.GamePlane;
	import com.isartdigital.shmup.game.planes.HorizontalScrollingPlane;
	import com.isartdigital.shmup.game.sprites.Boss;
	import com.isartdigital.shmup.game.sprites.Bullet;
	import com.isartdigital.shmup.game.sprites.BulletEnemy;
	import com.isartdigital.shmup.game.sprites.collectables.BigShoot;
	import com.isartdigital.shmup.game.sprites.collectables.Collectable;
	import com.isartdigital.shmup.game.sprites.collectables.Life;
	import com.isartdigital.shmup.game.sprites.collectables.Shield;
	import com.isartdigital.shmup.game.sprites.collectables.SmartBomb;
	import com.isartdigital.shmup.game.sprites.collectables.TripleShoot;
	import com.isartdigital.shmup.game.sprites.Ennemy;
	import com.isartdigital.shmup.game.sprites.Ennemy1;
	import com.isartdigital.shmup.game.sprites.Ennemy2;
	import com.isartdigital.shmup.game.sprites.Ennemy3;
	import com.isartdigital.shmup.game.sprites.Explosion;
	import com.isartdigital.shmup.game.sprites.Obstacle;
	import com.isartdigital.shmup.game.sprites.Player;
	import com.isartdigital.shmup.game.sprites.Special;
	import com.isartdigital.shmup.ui.GameOver;
	import com.isartdigital.shmup.ui.hud.Hud;
	import com.isartdigital.shmup.ui.TitleCard;
	import com.isartdigital.shmup.ui.UIManager;
	import com.isartdigital.shmup.ui.WinScreen;
	import com.isartdigital.utils.Config;
	import com.isartdigital.utils.Debug;
	import com.isartdigital.utils.game.GameStage;
	import com.isartdigital.utils.sound.SoundFX;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.globalization.NumberFormatter;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;
	
	
	/**
	 * Manager (Singleton) en charge de gérer le déroulement d'une partie
	 * @author Mathieu ANTHOINE
	 */
	public class GameManager
	{
		
		/**
		 * instance unique de la classe GameManager
		 */
		protected static var instance: GameManager;
		
		// plans de décors
		protected var background1:HorizontalScrollingPlane; 
		protected var background2:HorizontalScrollingPlane;
		protected var foreground:HorizontalScrollingPlane;
		
		
		// tableau de bullet
		public var bulletList:Vector.<Bullet> = new Vector.<Bullet>;
		
		// tableau d'ennemmis
		public var ennemyList:Vector.<Ennemy> = new Vector.<Ennemy>;
		
		//tableau d'obstacle
		public var explosionList:Vector.<Explosion> = new Vector.<Explosion>;
		
		//tableaux de collectibles
		public var collectableChoice:Vector.<Collectable> = new Vector.<Collectable>;
		public var collectableList:Vector.<Collectable> = new Vector.<Collectable>;
		
		private const COLLECTABLE_RATIO:Number = 0.75;
		
		private const COLLECTABLE_LIFE:Number = 2;//2
		private const COLLECTABLE_BOMB:Number = 10;//10
		private const COLLECTABLE_TRIPLESHOOT:Number = 5;//5
		private const COLLECTABLE_BIGSHOOT:Number = 5;
		private const COLLECTABLE_SHIELD:Number = 2;//2
		
		/*
		 * jeu en pause ou non
		 */
		protected var isPause:Boolean = true;
		private var newPause:Boolean = false;
		private var oldPause:Boolean = false;
		
		private var splitSound:SoundFX = new SoundFX("enemy_split");
		
		private static var musiclvl:SoundFX = new SoundFX("level_loop");
		private static var musicGO:SoundFX = new SoundFX("gameover_jingle");
		private static var musicWin:SoundFX = new SoundFX("win_jingle");
		
		public function GameManager() 
		{
			instance = this;
		}
		
		/**
		 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
		 * @return instance unique
		 */
		public static function getInstance (): GameManager {
			if (instance == null) instance = new GameManager();
			return instance;
		}
		
		public function init (): void {
			
			
			TitleCard.getInstance().uiSound.stop();
			
			
			//remplissage du tableau de collectable
			for (var i:int = 0; i < COLLECTABLE_LIFE; i++) {
				collectableChoice.push(new Life());
			}
			for (var j:int = 0; j < COLLECTABLE_BOMB; j++) {
				collectableChoice.push(new SmartBomb());
			}
			for (var k:int = 0; k < COLLECTABLE_SHIELD; k++) {
				collectableChoice.push(new Shield());
			}
			for (var l:int = 0; l < COLLECTABLE_TRIPLESHOOT; l++) {
				collectableChoice.push(new TripleShoot());
			}
			for (var m:int = 0; m < COLLECTABLE_BIGSHOOT; m++) {
				collectableChoice.push(new BigShoot());
			}
			

		}
		
		public function start (): void {
			
			Debug.getInstance().addButton("game over",cheatGameOver);
			Debug.getInstance().addButton("win", cheatWin);

			
			UIManager.getInstance().startGame();
			
			// TODO: votre code d'initialisation commence ici
			init();
			
			var lBackground1:Class = getDefinitionByName("Background1")as Class;
			var lBackground2:Class = getDefinitionByName("Background2") as Class;
			var lForeground:Class = getDefinitionByName("Foreground") as Class;
			
			background1 = new lBackground1();
			background2 = new lBackground2();
			foreground = new lForeground();
			
			GameStage.getInstance().getGameContainer().addChild(background1);
			GameStage.getInstance().getGameContainer().addChild(background2);
			GameStage.getInstance().getGameContainer().addChild(GamePlane.getInstance());
			GameStage.getInstance().getGameContainer().addChild(foreground);
			
			background1.speed = 1 / 3;
			background2.speed = 1 / 2;
			foreground.speed = 1.2;
			
			background1.start();
			background2.start();
			foreground.start();
			foreground.cacheAsBitmap = true;
			GamePlane.getInstance().start();
			Player.getInstance().start();
			musiclvl.loop();
			
			resume();
			
			Config.stage.focus;
			Config.stage.addEventListener(Event.ENTER_FRAME, testPause);
			
		}
		
		public static function stopMusic () : void {
			musiclvl.stop();
			musicGO.stop();
			musicWin.stop();
		}
		
		// ==== Mode Cheat =====
		
		protected function cheatGameOver (pEvent:Event): void {
			/* les fonctions callBack des méthodes de cheat comme addButton retournent
			 * un evenement qui contient la cible pEvent.target (le composant de cheat)
			 * et sa valeur (pEvent.target.value) à exploiter quand c'est utile */
			Debug.getInstance().clear();
			gameOver();
		}
		
		protected function cheatWin (pEvent:Event): void {
			/* les fonctions callBack des méthodes de cheat comme addButton retournent
			 * un evenement qui contient la cible pEvent.target (le composant de cheat)
			 * et sa valeur (pEvent.target.value) à exploiter quand c'est utile */
			Debug.getInstance().clear();
			win();
		}
		
		/**
		 * boucle de jeu (répétée à la cadence du jeu en fps)
		 * @param	pEvent
		 */
		protected function gameLoop (pEvent:Event): void {
			// TODO: votre code de gameloop commence ici
			scroll();
			GamePlane.getInstance().doAction();
			Player.getInstance().doAction();
			for (var i = bulletList.length - 1; i >= 0; i--) {
				if (bulletList[i].isDestroy) {
					bulletList.splice(i, 1);
				} else {
				bulletList[i].doAction();
				}
			}
			for (var j = ennemyList.length - 1; j >= 0; j--) {
				if (ennemyList[j].isDestroy) {
					ennemyList.splice(j, 1);
				} else {
				ennemyList[j].doAction();
				}
			}
			for (var l = explosionList.length - 1; l >= 0; l--) {
				if (explosionList[l].isDestroy) {
					explosionList.splice(l, 1);
				} else {
				explosionList[l].doAction();
				}
			}
			for (var k = collectableList.length - 1; k >= 0; k--) {
				if (collectableList[k].isDestroy) {
					collectableList.splice(k, 1);
				} else {
				collectableList[k].doAction();
				}
			}
			if (Player.getInstance().lifePoints == 0) gameOver();
			if (Boss.instance != null) Boss.getInstance().doAction();
		}
		
		public function createSpecial(pX:Number, pY:Number):void {
			var lSpecial:Special = new Special();
			lSpecial.x = pX;
			lSpecial.y = pY;
			GamePlane.getInstance().addChild(lSpecial);
			bulletList.push(lSpecial);
		}
		/**
		 * fonction qui fait scroller les plans, l'ordre est important: BG1, BG2, FG.
		 */
		protected function scroll():void {
			background1.doAction();
			background2.doAction();
			foreground.doAction();
		}
		/*
		 * Fonction qui cré les Shoots du joueur
		 */
		public function createShoot():Bullet {
			var lBullet:Bullet = Player.getInstance().bigShoot > 0 ? new Bullet("Big"): new Bullet();
			
			lBullet.x = Player.getInstance().x;
			lBullet.y = Player.getInstance().y;
			GamePlane.getInstance().addChild(lBullet);
			bulletList.push(lBullet);
			lBullet.start();
			return lBullet;
		}
		/*
		 * Fonction qui créer trois shoots 
		 */
		public function createTripleShoot():void {
			var lBullet:Bullet = createShoot();
			var lBullet2:Bullet = createShoot();
			var lBullet3:Bullet = createShoot();
			lBullet2.x = lBullet.x - lBullet.width;
			lBullet2.y = lBullet.y - lBullet.height;
			lBullet3.x = lBullet.x - lBullet.width;
			lBullet3.y = lBullet.y + lBullet.height;
		}
		/*
		 * Function qui créer les shoot des ennemis.
		 */
		public function createEnnemyShoot(pX:Number, pY:Number):void {
			var lBullet:BulletEnemy = new BulletEnemy();
			lBullet.x = pX;
			lBullet.y = pY;
			GamePlane.getInstance().addChild(lBullet);
			bulletList.push(lBullet);
			lBullet.start();
		}
		
		/*
		 * Fonction qui utilise la bomb
		*/
		public function useBomb():void {
			Player.getInstance().bombNumber--;
			Player.getInstance().refreshHUD();
			//TO DO: THE SMART BOMB
			var toKill:Array = new Array();
			for (var j = ennemyList.length - 1; j >= 0; j--) {
				if (Math.sqrt(Math.pow(Number(ennemyList[j].y - Player.getInstance().y), 2) + Math.pow(Number(ennemyList[j].x - Player.getInstance().x), 2)) < 600) toKill.push(ennemyList[j]);
			}
			
			for (var k = bulletList.length - 1; k >= 0; k--) {
				if (Math.sqrt(Math.pow(Number(bulletList[k].y - Player.getInstance().y), 2) + Math.pow(Number(bulletList[k].x - Player.getInstance().x), 2)) < 600) toKill.push(bulletList[k]);
			}
			
			for (var i:int = toKill.length -1 ; i >= 0; i--) {
				var lExplosion:Explosion = new Explosion();
				lExplosion.x = toKill[i].x;
				lExplosion.y = toKill[i].y;
				lExplosion.start();
				GamePlane.getInstance().addChild(lExplosion);
				toKill[i].destroy();
			}
			
		}
		
		public function createExplosion(pX:Number, pY:Number) {
			var lExplosion:Explosion = new Explosion();
			lExplosion.x = pX;
			lExplosion.y = pY;
			lExplosion.start();
			GamePlane.getInstance().addChild(lExplosion);
		}
		
		
		/*
		 * Fonction qui cré les Ennemy2
		 */
		public function createEnnemy2(pX:Number, pY:Number):void {
			var lEnnemy:Ennemy2 = new Ennemy2(pX, pY);
			GamePlane.getInstance().addChild(lEnnemy);
		}
		/*
		 * Fonction qui créer deux ennemis 1 depuis un ennemi 2
		 */
		public function splitEnnemy2(pX:Number, pY:Number, pHeight):void {
			var lEnnemy:Ennemy1 = new Ennemy1(pX, pY + pHeight);
			GamePlane.getInstance().addChild(lEnnemy);
			lEnnemy.move = lEnnemy.toLeft;
			
			var lEnnemyB:Ennemy1 = new Ennemy1(pX, pY - pHeight);
			GamePlane.getInstance().addChild(lEnnemyB);
			lEnnemyB.move = lEnnemyB.toLeft;
			splitSound.start();
		}
		/*
		 * Fonction qui cré deux ennemis 2 depuis un ennemi 3
		 */
		public function splitEnnemy3(pX:Number, pY:Number, pheight):void {
			var lEnnemy:Ennemy2 = new Ennemy2(pX, pY + pheight);
			GamePlane.getInstance().addChild(lEnnemy);
			
			var lEnnemyB:Ennemy2 = new Ennemy2(pX, pY - pheight);
			GamePlane.getInstance().addChild(lEnnemyB);
			splitSound.start();
		}
		
		/*
		 * Fonction qui cré un ennemi 3
		 */
		public function createEnnemy3(pX:Number, pY:Number):void {
			var lEnnemy:Ennemy3 = new Ennemy3(pX, pY);
			GamePlane.getInstance().addChild(lEnnemy);
		}
		
		public function createCollectable(pX:Number, pY:Number):void {
			if (Math.random() > COLLECTABLE_RATIO) return;
			if (collectableChoice.length == 0) return;
			var lI:Number = Math.floor(Math.random() * collectableChoice.length );
			var lCollectable:Collectable = collectableChoice[lI];
			collectableChoice.splice(lI, 1);
			lCollectable.x = pX;
			lCollectable.y = pY;
			GamePlane.getInstance().addChild(lCollectable);
			lCollectable.start();
			collectableList.push(lCollectable);
		}
		
		protected function gameOver ():void {
			Config.stage.removeEventListener (Event.ENTER_FRAME, gameLoop);
			musiclvl.stop();
			musicGO.loop();
			var lScore:TextField = GameOver.getInstance().Field.getChildByName("txtScore") as TextField;
			lScore.text = "Score : " + Hud.getInstance().score;
			UIManager.getInstance().addScreen(GameOver.getInstance());
		}
		
		public function win():void {
			Config.stage.removeEventListener (Event.ENTER_FRAME, gameLoop);
			musiclvl.stop();
			musicWin.loop();
			var lScore:TextField = WinScreen.getInstance().Field.getChildByName("txtScore") as TextField;
			lScore.text = "Score : " + Hud.getInstance().score;
			UIManager.getInstance().addScreen(WinScreen.getInstance());
		}
		
		public function pause (): void {
			if (!isPause) {
				isPause = true;
				Config.stage.removeEventListener (Event.ENTER_FRAME, gameLoop);
				
				//testPause();
			}
		}
		
		private function testPause(e:Event):void {
			newPause = Player.getInstance().controller.pause;
			if (!newPause && oldPause) 
			{
				if (isPause){
					trace("resume");
					resume()
				}
				else {
					pause();
				}
			}
			oldPause = newPause;
		}
		
		public function resume (): void {			
			if (!Player.getInstance().controller.pause) {
				isPause = false;
				Config.stage.addEventListener (Event.ENTER_FRAME, gameLoop);
			}
		}
		
		/**
		 * détruit l'instance unique et met sa référence interne à null
		 */
		public function destroy (): void {
			Config.stage.removeEventListener (Event.ENTER_FRAME, gameLoop);
			for (var i = bulletList.length - 1; i >= 0; i--) {
				if (bulletList[i].isDestroy) {
					bulletList.splice(i, 1);
				} else {
				bulletList[i].destroy();
				bulletList.splice(i, 1);
				}
			}
			for (var j = ennemyList.length - 1; j >= 0; j--) {
				if (ennemyList[j].isDestroy) {
					ennemyList.splice(j, 1);
				} else {
				ennemyList[j].destroy();
				ennemyList.splice(j, 1);
				}
			}
			for (var k = explosionList.length - 1; k >= 0; k--) {
				if (explosionList[k].isDestroy) {
					explosionList.splice(k, 1);
				} else {
				explosionList[k].destroy();
				explosionList.splice(k, 1);
				}
			}
			
			for (var l = collectableList.length - 1; l >= 0; l--) {
				if (collectableList[l].isDestroy) {
					collectableList.splice(l, 1);
				} else {
				collectableList[l].destroy();
				collectableList.splice(l, 1);
				}
			}
			if (background1 != null) background1.resetList();
			if (background2 != null) background2.resetList();
			if (foreground != null) foreground.resetList();
			ennemyList = null; bulletList = null; explosionList = null; collectableChoice = null; collectableList = null;
			Player.getInstance().destroy();
			splitSound = null;
			instance = null;
			
		}

	}
}
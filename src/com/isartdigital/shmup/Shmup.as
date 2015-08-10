package com.isartdigital.shmup 
{
	import com.isartdigital.shmup.controller.Controller;
	import com.isartdigital.shmup.game.levelDesign.EnemySpawnsGenerator;
	import com.isartdigital.shmup.game.levelDesign.ObstaclesGenerator;
	import com.isartdigital.shmup.ui.GraphicLoader;
	import com.isartdigital.shmup.ui.TitleCard;
	import com.isartdigital.shmup.ui.UIManager;
	import com.isartdigital.utils.Config;
	import com.isartdigital.utils.Debug;
	import com.isartdigital.utils.events.AssetsLoaderEvent;
	import com.isartdigital.utils.game.GameStage;
	import com.isartdigital.utils.game.StateGraphic;
	import com.isartdigital.utils.loader.AssetsLoader;
	import com.isartdigital.utils.text.LocalizedTextField;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.GameInputEvent;
	import flash.system.Capabilities;
	import flash.system.TouchscreenType;
	import flash.ui.GameInput;
	import com.isartdigital.shmup.controller.Pad;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	/**
	 * Classe initiale du Shmup associée au fichier Shmup.fla
	 * Est en charge d'assurer le chargement des fichiers de configuration et
	 * des premières ressources du jeu
	 * @author Mathieu ANTHOINE
	 */
	public class Shmup extends MovieClip 
	{
		
		/**
		 * instance unique de la classe Shmup
		 */
		protected static var instance: Shmup;
		
		/**
		 * chemin vers le fichier de configuration
		 */
		protected static const CONFIG_PATH:String = "config.xml";
		
		/**
		 * vérifie qu'un pad est connecté
		 */
		protected var padInput:GameInput;
			
		public function Shmup() 
		{
			super();
			
			// cas particulier de cette classe qui est associée au document et qui n'invoque donc pas getInstance() au moment de sa création.
			instance = this;
			
			if (Capabilities.touchscreenType == TouchscreenType.FINGER) {
				Controller.type = Controller.TOUCH;
				Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			} else {
				padInput = new GameInput();
				padInput.addEventListener(GameInputEvent.DEVICE_ADDED, addPad);
			}
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		/**
		 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
		 * @return instance unique
		 */
		public static function getInstance (): Shmup {
			if (instance == null) instance = new Shmup();
			return instance;
		}
		
		/**
		 * Initialisation
		 * @param pEvent
		 */
		protected function init (pEvent:Event=null): void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align =  StageAlign.TOP_LEFT;
			
			var lLoader:AssetsLoader = new AssetsLoader ();
			lLoader.addTxtFile(CONFIG_PATH);
			
			lLoader.addEventListener(AssetsLoaderEvent.COMPLETE, onLoadConfigComplete);
			
			lLoader.load();
		}
		
		/**
		 * crée une référence vers un pad
		 * @param	pEvent
		 */
		protected function addPad (pEvent:GameInputEvent) : void {
			padInput.removeEventListener(GameInputEvent.DEVICE_ADDED, addPad);
			Controller.type = Controller.PAD;
			Pad.init(pEvent.device);	
		}
		
		/**
		 * Déclenché à la fin du chargement des fichiers de configuration
		 * @param	pEvent
		 */
		protected function onLoadConfigComplete (pEvent:AssetsLoaderEvent): void {
			
			pEvent.target.removeEventListener(AssetsLoaderEvent.COMPLETE, onLoadConfigComplete);
			
			Config.init(CONFIG_PATH, stage);
			
			addChild(GameStage.getInstance());
			GameStage.getInstance().init(loadAssets);

			addChild(Debug.getInstance());
			
		}
		
		/**
		 * lance le chargement principal
		 */
		protected function loadAssets (): void {
			
			var lLoader:AssetsLoader = new AssetsLoader ();
			
			// paramétrage (la propriété statique boxAlpha n'est pas déclarée explicitement dans la classe Config, pour accéder à une propriété dynamiquement créé, on utilise la syntaxe [])
			if (Config.debug) StateGraphic.boxAlpha = Config["boxAlpha"];
			
			lLoader.addTxtFile(Config.langPath + Config.language+"/main.xlf");
			lLoader.addTxtFile("sound.xml");
			lLoader.addDisplayFile("ui.swf");
			lLoader.addDisplayFile("assets.swf");
			lLoader.addDisplayFile("boxes.swf");
			lLoader.addDisplayFile("leveldesign.swf");
			lLoader.addDisplayFile("sound.swf");
			
			lLoader.addEventListener(AssetsLoaderEvent.PROGRESS, onLoadProgress);
			lLoader.addEventListener(AssetsLoaderEvent.COMPLETE, onLoadComplete);
			
			UIManager.getInstance().addScreen(GraphicLoader.getInstance());
			
			lLoader.load();
		}
		
		protected function onLoadProgress (pEvent:AssetsLoaderEvent): void {
			GraphicLoader.getInstance().update(pEvent.filesLoaded / pEvent.nbFiles);
		}
		
		protected function onLoadComplete (pEvent:AssetsLoaderEvent): void {
			pEvent.target.removeEventListener(AssetsLoaderEvent.PROGRESS, onLoadProgress);
			pEvent.target.removeEventListener(AssetsLoaderEvent.COMPLETE, onLoadComplete);
			
			LocalizedTextField.init(String(AssetsLoader.getContent(Config.langPath + Config.language+"/main.xlf")));
			
			UIManager.getInstance().addScreen(TitleCard.getInstance());
		}
		
		/**
		 * détruit l'instance unique et met sa référence interne à null
		 */
		public function destroy (): void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			padInput.removeEventListener(GameInputEvent.DEVICE_ADDED, addPad);
			instance = null;
		}
		
		/**
		 * Classe "hack" pour forcer l'import de classes dans le fichier Shmup.swf
		 * Par exemple ObstaclesGenerator n'est utilisé que dans le fichier leveldesign.swf
		 * si on ne force pas son import dans Shmup.swf par l'intermédiaire de cette méthode
		 * le code de la classe ne sera mis à jour que si on recompile leveldesign.swf
		 * ce qui est une grosse source d'erreur.
		 * Seules les classes dans ce cas sont à intégrer ici
		 */
		private static function importClasses (): void {
			ObstaclesGenerator;
			EnemySpawnsGenerator;
		}
		

	}
}
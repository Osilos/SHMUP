package com.isartdigital.utils {
	
	import com.bit101.components.CheckBox;
	import com.bit101.components.Component;
	import com.bit101.components.HUISlider;
	import com.bit101.components.InputText;
	import com.bit101.components.NumericStepper;
	import com.bit101.components.PushButton;
	import com.bit101.components.Window;
	import flash.display.Sprite;
	import flash.events.Event;
	import utils.debug.Stats;
	
	/**
	 * Classe de Debug
	 * Peut initialiser un compteur de Fps
	 * Peut afficher des outils de cheat dans un panneau de cheat à l'aide des différentes méthodes à disposition
	 * @author Mathieu ANTHOINE
	 */
	public class Debug extends Sprite 
	{
		
		/**
		 * instance unique de la classe Debug
		 */
		protected static var instance: Debug;
		
		/**
		 * popin de debug
		 */
		protected var cheat:Window;
		
		/**
		 * marge entre les composants
		 */
		protected static const MARGIN:int = 5;
		
		/**
		 * prochain y pour placer un composant
		 */
		protected var nextY:int=MARGIN;
	
		public function Debug() 
		{
			super();					
			if (Config.fps) addChild (new Stats());
			
			init();
		}
		
		/**
		 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
		 * @return instance unique
		 */
		public static function getInstance (): Debug {
			if (instance == null) instance = new Debug();
			return instance;
		}

		protected function init():void {
			nextY = MARGIN;
			addSlideBar("cheat zoom", 1, 4, 1, 0.5, scaleCheat);
		}
		
		protected function scaleCheat (pEvent:Event):void {
			scaleX = scaleY = pEvent.target.value;
		}
		
		protected function addToCheatPanel(pComponent:Component): void {
			if (cheat == null) {
				cheat = new Window(this,Config.fps ? 80 : 0,0, "Cheat");
				cheat.hasMinimizeButton = true;
			}
			nextY += pComponent.height + MARGIN;
			cheat.addChild(pComponent);
			cheat.width = Math.max (cheat.width, pComponent.width);
			cheat.height = 25+nextY;
		}
		
		public function addSlideBar (pTitle:String, pMin:Number=0, pMax:Number=10, pValue:Number=5, pStep:Number=1,pCallBack:Function=null): void {
			if (!Config.cheat) return;
			
			var lComp:HUISlider = new HUISlider(cheat, MARGIN, nextY, pTitle, pCallBack);
			lComp.setSliderParams(pMin, pMax, pValue);
			lComp.tick = pStep;
			if (pStep is int) lComp.labelPrecision = 0;
			else lComp.labelPrecision = 2;
			addToCheatPanel(lComp);
		}
		
		public function addCheckBox (pTitle:String, pSelected:Boolean = false, pCallBack:Function = null): void {
			if (!Config.cheat) return;
			
			var lComp:CheckBox = new CheckBox(cheat, MARGIN, nextY, pTitle, pCallBack);
			lComp.selected = pSelected;
			addToCheatPanel(lComp);
		}
		
		public function addButton (pTitle:String, pCallBack:Function = null): void {
			if (!Config.cheat) return;
			
			var lComp:PushButton = new PushButton(cheat, MARGIN, nextY, pTitle, pCallBack);
			addToCheatPanel(lComp);
			
		}
		
		public function addToggleButton (pTitle:String, pToggle:Boolean = false, pCallBack:Function = null): void {
			if (!Config.cheat) return;
			
			var lComp:PushButton = new PushButton(cheat, MARGIN, nextY, pTitle, pCallBack);
			lComp.toggle = pToggle;
			addToCheatPanel(lComp);		
		}
		
		public function addInputText (pTitle:String, pValue:String = "", pCallBack:Function = null): void {
			if (!Config.cheat) return;
			
			var lComp:InputText = new InputText(cheat, MARGIN, nextY, pTitle, pCallBack);
			lComp.text = pValue;
			addToCheatPanel(lComp);		
		}
		
		public function addStepper (pTitle:String, pMin:Number = 0, pMax:Number = 10, pValue:Number = 5, pStep:Number = 1, pCallBack:Function = null): void {
			if (!Config.cheat) return;
			
			var lComp:NumericStepper = new NumericStepper(cheat, MARGIN, nextY, pCallBack);
			lComp.step = pStep;
			lComp.minimum = pMin;
			lComp.maximum = pMax;
			lComp.value = pValue;
			addToCheatPanel(lComp);
		}
		
		public function clear (): void {
			removeChild(cheat);
			cheat = null;
			init();
		}
		
		/**
		 * détruit l'instance unique et met sa référence interne à null
		 */
		public function destroy (): void {
			removeChild(cheat);
			cheat = null;
			instance = null;
		}

	}
}
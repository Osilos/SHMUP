package com.isartdigital.shmup.controller 
{
	import com.isartdigital.utils.Config;
	import flash.events.KeyboardEvent;
	
	import flash.ui.Keyboard;
	
	/**
	 * Controleur clavier
	 * @author Mathieu ANTHOINE
	 */
	public class Keyboard extends Controller
	{	
		private var key_LEFT:Number = 0;
		private var key_UP:Number = 0;
		private var key_RIGHT:Number = 0;
		private var key_DOWN:Number = 0;
		private var key_SPACE:Boolean = false;
		private var key_Q:Boolean = false;
		private var key_S:Boolean = false;
		private var key_D:Boolean = false;
		private var key_G:Boolean = false;
		
		public function Keyboard() 
		{
			super();
			
			// donne le focus au stage pour capter les evenements de clavier
			Config.stage.focus = Config.stage;
			//Ajout des listeners de touche
			Config.stage.addEventListener(KeyboardEvent.KEY_DOWN, register);
			Config.stage.addEventListener(KeyboardEvent.KEY_UP, unregister);			
		}
		
		private function unregister(e:KeyboardEvent):void 
		{
			switch (e.keyCode) {
				case 37:
					key_LEFT = 0;
					break;
				case 38:
					key_UP = 0;
					break;
				case 39:
					key_RIGHT = 0;
					break;
				case 40:
					key_DOWN = 0;
					break;
				case 32:
					key_SPACE = false;
					break;
				case 81: 
					key_Q = false;
					break;
				case 83:
					key_S = false;
					break;
				case 68:
					key_D = false;
					break;
				case 71:
					key_G = false;
					break;
			}
		}
		
		private function register(e:KeyboardEvent):void 
		{
						switch (e.keyCode) {
				case 37:
					key_LEFT = 1;
					break;
				case 38:
					key_UP = 1;
					break;
				case 39:
					key_RIGHT = 1;
					break;
				case 40:
					key_DOWN = 1;
					break;
				case 32:
					key_SPACE = true;
					break;
				case 81: 
					key_Q = true;
					break;
				case 83:
					key_S = true;
					break;
				case 68:
					key_D = true;
					break;
				case 71:
					key_G = true;
					break;
			}
		}

		override public function get fire (): Boolean {
			return key_Q;
		}
		
		override public function get bomb (): Boolean {
			return key_D;
		}
		
		override public function get special (): Boolean {
			return key_S;
		}
	
		override public function get pause (): Boolean {
			return key_SPACE;
		}
		

		override public function get god (): Boolean {
			return key_G;
		}
		
		override public function get left (): Number {
			return key_LEFT;
		}
		
		override public function get right (): Number {
			return key_RIGHT;
		}
		
		override public function get up (): Number {
			return key_UP;
		}
		
		override public function get down (): Number {
			return key_DOWN;
		} 
	
	}
}
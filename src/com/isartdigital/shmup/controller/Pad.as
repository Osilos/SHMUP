package com.isartdigital.shmup.controller 
{
	import flash.ui.GameInputDevice;
	import flash.events.Event;
	import flash.ui.GameInputControl;
	
	/**
	 * Controleur Pad
	 * @author Mathieu ANTHOINE
	 */
	public class Pad extends Controller 
	{
	
		protected static const A:String = "BUTTON_4";
		protected static const B:String = "BUTTON_5";
		protected static const X:String = "BUTTON_6";
		protected static const RB:String = "BUTTON_9";
		protected static const START:String = "BUTTON_13";
		protected static const HORIZONTAL:String = "AXIS_0";	
		protected static const VERTICAL:String = "AXIS_1";		;		
		
		protected static var device: GameInputDevice;
		
		protected static const MIN_VALUE:Number = 0.15;
		
		/**
		 * tableau stockant l'etat des touches et sticks du pad
		 */
		protected var controls:Object = new Object();
		
		public function Pad() 
		{
			super();
			var lLength:int=device.numControls;
			for (var i:int=0;i<lLength;i++) device.getControlAt(i).addEventListener(Event.CHANGE,pressPad);
		}
		
		public static function init (pDevice:GameInputDevice):void {
			device = pDevice;
			device.enabled = true;
		}
		
		protected function pressPad (pEvent:Event): void {
			var lPad:GameInputControl = GameInputControl(pEvent.target);		
			controls[lPad.id] = lPad.value;
		}
		
		override public function get fire (): Boolean {
			return Boolean(controls[Pad.A]);
		}
		
		override public function get bomb (): Boolean {
			return Boolean(controls[Pad.X]);
		}
		
		override public function get special (): Boolean {
			return Boolean(controls[Pad.B]);
		}
		
		override public function get pause (): Boolean {
			return Boolean(controls[Pad.START]);
		}
		
		override public function get god (): Boolean {
			return Boolean(controls[Pad.RB]);
		}
		
		override public function get left (): Number {
			if (controls[Pad.HORIZONTAL] > -MIN_VALUE) return 0;
			return -controls[Pad.HORIZONTAL];
		}
		
		override public function get right (): Number {
			if (controls[Pad.HORIZONTAL] < MIN_VALUE) return 0;
			return controls[Pad.HORIZONTAL];
		}
		
		override public function get up (): Number {
			if (controls[Pad.VERTICAL] < MIN_VALUE) return 0;
			return controls[Pad.VERTICAL];
		}
		
		override public function get down (): Number {
			if (controls[Pad.VERTICAL] > -MIN_VALUE) return 0;
			return -controls[Pad.VERTICAL];
		}

	}
}
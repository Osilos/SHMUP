package com.isartdigital.shmup.game.planes 
{
	import com.isartdigital.utils.Config;
	import com.isartdigital.utils.game.GameStage;
	import com.isartdigital.utils.game.GameObject;
	import flash.display.MovieClip;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;
	
	/**
	 * Classe "Plan de scroll", chaque plan de scroll (y compris le GamePlane) est une instance de HorizontalScrollingPlane ou d'une classe fille de HorizontalScrollingPlane
	 * TODO: A part GamePlane, toutes les instances de HorizontalScrollingPlane contiennent 3 MovieClips dont il faut gérer le "clipping" afin de les faire s'enchainer correctement
	 * alors que l'instance de HorizontalScrollingPlane se déplace
	 * @author Mathieu ANTHOINE
	 */
	public class HorizontalScrollingPlane extends GameObject
	{
		public var speed:Number;
		
		protected var listClip:Vector.<MovieClip> = new Vector.<MovieClip>;
		
		private static const PARTH_WIDTH = 1219;
		
		public function HorizontalScrollingPlane() 
		{
			super();
			init();
		}
		
		/**
		 * Retourne les coordonnées des 4 coins de l'écran dans le repère du plan de scroll concerné 
		 * @return Rectangle dont la position et les dimensions correspondant à la taille de l'écran dans le repère local
		 */
		public function getScreenLimits ():Rectangle {
			var lTopLeft:Point = new Point (0, 0);
			var lBottomRight:Point = new Point (Config.stage.stageWidth, 0);
			
			lTopLeft = globalToLocal(lTopLeft);
			lBottomRight = globalToLocal(lBottomRight);
						
			return new Rectangle(lTopLeft.x, 0, lBottomRight.x-lTopLeft.x, GameStage.SAFE_ZONE_HEIGHT);
		}
		
		protected function init():void {
			for (var i:int = 0; i < numChildren; i++) {
				if (i == 0) listClip.push(getChildAt(i));
				else {
					if (getChildAt(i).x > getChildAt(i - 1).x) listClip.push(getChildAt(i));
					else listClip.unshift(getChildAt(i));
				}
			}
		}
		
		override protected function doActionNormal():void {

			x -= GamePlane.ScrollSpeed * speed;
			
			//Clipping
			for (var i:int = 0; i < listClip.length; i++ ) {
				if (listClip[i].x + listClip[i].width < getScreenLimits().x) {
					listClip[i].x += getScreenLimits().width + HorizontalScrollingPlane.PARTH_WIDTH ;
					listClip.push(listClip.shift());
					i--;
				} else break;  
			}
		}
		
		public function resetList():void {
				for (var i:int = listClip.length - 1; i > 0; i--) {
					removeChild(listClip[i]);
					listClip.pop();
				}
		}
		
	}

}
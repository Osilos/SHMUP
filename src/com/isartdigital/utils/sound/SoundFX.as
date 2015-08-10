package com.isartdigital.utils.sound 
{
	import com.isartdigital.utils.events.SoundFXEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundLoaderContext;
	import flash.net.URLRequest;	
	import flash.utils.getDefinitionByName;
	import flash.media.SoundChannel;
	import flash.events.EventDispatcher;
	import flash.media.SoundTransform;
	
	/**
	 * Classe simplifiée pour la manipulation de sons contenus dans des swfs chargés (pas de son externes)
	 * Gère un ENTER_FRAME interne pour une utilisation simplifiée
	 * N'a pas besoin d'être ajouté à la gameLoop mais les sons ne seront pas associés à la pause du jeu.
	 * @author Mathieu ANTHOINE
	 */
	public class SoundFX extends EventDispatcher
	{
		/**
		 * vitesse du fade de volume par frame
		 */
		protected static const FADE_SPEED:Number = 0.005;
		
		/**
		 * son manipulé par la classe SoundFX
		 */
		protected var sound:Sound;
		
		/**
		 * canal du son interne
		 */
		protected var channel:SoundChannel;
		
		/**
		 * position de la lecture
		 */
		protected var position:int = 0;
		
		/**
		 * volume (valeur plus précise du volume que celle stockée par channel)
		 */
		protected var realVolume:Number = 0;
		
		/**
		 * permet de bénéficier du ENTER_FRAME sur un objet non graphique
		 */
		protected var framer:Sprite;
		
		public function SoundFX(pName:String) 
		{
			var lClass:Class = Class(getDefinitionByName(pName));
			sound = Sound(new lClass());
			framer = new Sprite();
		}
		
		/**
		 * retourne la longueur du son
		 */
		public function get length ():Number {
			return sound.length;
		}
		
		/**
		 * Lance la lecture du son
		 * @param	pStartTime position de départ en millisecondes
		 * @param	pLoops nombre de répétitions
		 */
		public function start (pStartTime:Number = 0, pLoops:int = 0):void {
			if (channel != null) stop();
			channel = sound.play (pStartTime, pLoops);
			position = channel.position;
			volume = 1;
			channel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
		}

		/**
		 * stop le son
		 */
		public function stop ():void {
			if (channel == null) return;
			channel.removeEventListener(Event.SOUND_COMPLETE, onSoundComplete);
			framer.removeEventListener(Event.ENTER_FRAME, doFadeIn);
			framer.removeEventListener(Event.ENTER_FRAME, doFadeOut);
			channel.stop();
			channel = null;
		}		
		
		/**
		 * joue le son en boucle infinie
		 */
		public function loop ():void {
			start (0, int.MAX_VALUE);
		}
		
		/**
		 * met le son en pause
		 */
		public function pause ():void {
			if (channel == null) return;
			position = channel.position;
			stop();
			trace ("pause");
		}
		
		/**
		 * relance le son (un son relancé par resume sera lancé en boucle infinie car il n'est pas possible de connaitre le nombre de boucle déjà executées)
		 */
		public function resume ():void {
			start(position);
			channel.addEventListener(Event.SOUND_COMPLETE, setLoop);
			trace("resume");
		}
		
		/**
		 * Un son repartant d'une position ne sait pas boucler correctement. Cette méthode permet de combler le problème
		 * @param	pEvent
		 */
		protected function setLoop (pEvent:Event): void {
			pEvent.target.removeEventListener(Event.SOUND_COMPLETE, setLoop);
			loop();
		}
		
		/**
		 * volume du son
		 */
		public function get volume ():Number {
			return realVolume;
		}
		
		/**
		 * volume du son
		 */
		public function set volume (pVolume:Number):void {
			realVolume = pVolume;
			var lSoundTransform:SoundTransform=new SoundTransform(realVolume);
			channel.soundTransform = lSoundTransform;
		}
		
		/**
		 * lance un fadeIn depuis le volume actuel jusqu'à 1
		 */
		public function fadeIn (): void {
			framer.removeEventListener(Event.ENTER_FRAME, doFadeOut);
			if (channel == null) {
				loop();
				volume = 0;
			}
			framer.addEventListener(Event.ENTER_FRAME,doFadeIn);
		}
		
		/**
		 * fait évoluer le son pendant le fadeIn
		 */
		protected function doFadeIn (pEvent:Event): void {	
			volume+= FADE_SPEED;
			//trace ("fadeIn",volume);
			if (volume>=1) framer.removeEventListener(Event.ENTER_FRAME,doFadeIn);
		}
		
		/**
		 * lance un fadeOut jusqu'a 0
		 */
		public function fadeOut ():void {
			if (channel == null) return;
			framer.removeEventListener(Event.ENTER_FRAME,doFadeIn);
			framer.addEventListener(Event.ENTER_FRAME,doFadeOut);
		}
		
		/**
		 * fait évoluer le son pendant le fadeOut
		 */
		protected function doFadeOut (pEvent:Event): void {	
			volume-= FADE_SPEED;
			//trace ("fadeOut",volume);
			if (volume <= 0) onSoundComplete();
		}
		
		/**
		 * diffuse l'évenement de fin de son
		 * @param	pEvent Evenement SOUND_COMPLETE diffusé par le canal
		 */
		protected function onSoundComplete (pEvent:Event=null):void {
			stop();
			dispatchEvent(new SoundFXEvent(SoundFXEvent.COMPLETE));
		}
		
		/**
		 * nettoyage de l'instance de SoundFX
		 */
		public function destroy (): void {	
			stop();
			framer = null;
			sound = null;
		}
		
	}
}
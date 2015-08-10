package com.isartdigital.utils.game {
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * Classe de base des objets interactifs ayant plusieurs états graphiques
	 * Elle gère la représentation graphique (anim) et les conteneurs utiles au gamePlay (box) qui peuvent être de simples boites de collision ou beaucoup plus
	 * suivant l'implémentation faite par le développeur dans les classes filles
	 * @author Mathieu ANTHOINE
	 */
	public class StateGraphic extends GameObject 
	{
		/**
		 * anim de l'état courant
		 */
		protected var anim:MovieClip;
		
		/**
		 * box de l'état courant ou box générale si simpleBox est true
		 */
		protected var box:Sprite;
		
		/**
		 * suffixe du nom d'export des Symboles Animés
		 */
		protected const ANIM_SUFFIX:String = "";
		
		/**
		 * suffixe du nom d'export des Symboles Box
		 */
		protected const BOX_SUFFIX:String = "_box";	
		
		/**
		 * etat par défaut
		 */
		protected const DEFAULT_STATE:String = "static";
		
		/**
		 * Nom de l'asset (sert à identifier les symboles utilisées dans les fichiers assets.fla et boxes.fla)
		 */
		protected var assetName:String;
		
		/**
		 * état en cours
		 */
		protected var state:String;
		
		/**
		 * anim qui boucle ou pas
		 * l'anim n'est jamais stoppée même quand loop est false
		 * l'anim ne renvoie jamais isAnimEnd si loop est true
		 */
		protected var loop:Boolean;
		
		/**
		 * Si simpleBox est true, seul un Symbole sert de Box pour tous les états
		 * Son nom d'export etant assetName+"_"+BOX_SUFFIX
		 */
		protected var simpleBox:Boolean;
		
		/**
		 * niveau d'alpha des Boxes, si l'alpha est à 0 (valeur par défaut), les boxes sont en fait invisible
		 */
		public static var boxAlpha:Number=0;
		
		public function StateGraphic() 
		{
			super();
			if (assetName == null) assetName= getQualifiedClassName(this).split("::").pop();
			setState (DEFAULT_STATE);
		}
		
		/**
		 * défini l'état courant du MySprite
		 * @param	pState nom de l'état. Par exemple si pState est "run" et assetName "Player", anim chercher l'export "Player_run" dans le fichier assets.fla et box "Player_run_box" dans le fichier boxes.fla
		 * @param	pLoop l'anim boucle (isAnimEnd sera toujours false) ou pas
		 * @param	pStart lance l'anim à cette frame
		 */
		protected function setState (pState:String, pLoop:Boolean = false, pStart:uint=1): void {
			if (pState == state) return;
			clearState();
			
			loop = pLoop;
			
			var lClass:Class = getDefinitionByName(assetName+"_" + pState+ANIM_SUFFIX) as Class;
			
			anim = new lClass();
			addChild(anim);
			if (anim.totalFrames>1) anim.gotoAndPlay(pStart);
			
			if (!simpleBox || box==null) {
				lClass = getDefinitionByName(assetName+ (!simpleBox ? "_" + pState+BOX_SUFFIX : BOX_SUFFIX)) as Class;
				
				box = new lClass();
				if (boxAlpha== 0) box.visible = false;
				else box.alpha = boxAlpha;
				addChild (box);	
			}
			
			state = pState;
			
		}
		
		/**
		 * nettoie les conteneurs anim et box
		 * @param	pDestroy force un nettoyage complet
		 */
		protected function clearState (pDestroy:Boolean=false): void {
			if (state != null) {
				anim.stop();
				removeChild(anim);
				if (pDestroy || !simpleBox) removeChild(box);
			}
		}
		
		/**
		 * met en pause l'anim
		 */
		public function pause ():void {
			if (anim != null) anim.stop();
		}
		
		/**
		 * relance l'anim
		 */
		public function resume ():void {
			if (anim != null) anim.play();
		}	
		
		/**
		 * précise si l'anim est arrivée à la fin
		 * @return anim finie ou non
		 */
		public function isAnimEnd (): Boolean {
			if (anim != null && !loop) return anim.currentFrame == anim.totalFrames;
			return false;
		}
		
		/**
		 * retourne la zone de hit de l'objet
		 * fonction getter: est utilisé comme une propriété ( questionner hitBox et non hitBox() )
		 */
		public function get hitBox (): DisplayObject {
			return box;
		}
		
		/**
		 * nettoyage et suppression de l'instance
		 */
		override public function destroy (): void {
			clearState(true);
			anim = null;
			box = null;
			super.destroy();
		}
		
	}

}
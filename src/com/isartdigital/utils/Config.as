package com.isartdigital.utils {
	import com.isartdigital.utils.loader.AssetsLoader;
	import flash.display.Stage;
	import flash.system.Capabilities;
	
	/**
	 * Classe de configuration
	 * Cette classe contient toutes les variables définies dans le fichier config.xml sous forme de propriétés statiques typées.
	 * Certaines variables existent qu'elles aient été définies ou non dans le fichier. Si elles n'ont pas été définies elles prennent la valeur par défaut de la classe
	 * @author Mathieu ANTHOINE
	 */
	public class Config 
	{
		/**
		 * référence vers le stage
		 */
		public static var stage:Stage;
		
		/**
		 * version de l'application
		 */
		public static var version		:String		= "0.0.0";

		/** 
		 * chemin du dossier de langues
		 */
		public static var langPath		: String	= "";
		
		/**
		 * langue courante
		 */
		public static var language		: String;
		
		/**
		 * langues disponibles
		 */
		public static var languages		: Array;
		
		/**
		 * défini si le jeu est en mode "cheat" ou pas (si prévu dans le code du jeu)
		 */
		public static var cheat			: Boolean	= false;
		
		/**
		 * défini si le jeu est en mode "debug" ou pas (si prévu dans le code du jeu)
		 */
		public static var debug			: Boolean	= false;
		
		/**
		 * défini l'affichage ou non des fps
		 */
		public static var fps			: Boolean	= false;		
		
		public function Config() {}
		
		public static function init(pFile:String,pStage:Stage=null): void {
			stage = pStage;
			
			var lXml : XML = new XML(AssetsLoader.getContent(pFile));
			
			var lChilds : XMLList = lXml.children();
			
			for each(var lItem : XML in lChilds) {
				var lValue : String = lItem.toString();
				var lType : String = lItem.@type;
				var lName : String = lItem.name();
				
				if (lType=="Number") Config[lName] = Number(lValue);
				else if (lType=="Boolean") Config[lName] = lValue=="true";
				else if (lType=="Array") Config[lName] = lValue.split(",");
				else Config[lName]= lValue;
				
			}
			
			// gestion des textes localisés
			if (language == "" && languages.indexOf(Capabilities.language.substr(0, 2)) != -1) language = languages[languages.indexOf(Capabilities.language.substr(0, 2))];
			else language = languages[0];
			
		}
		
		/**
		 * Retourne une valeur transmise par le fichier config.xml
		 * @return la valeur stockée dans la propriété statique dynamique
		 */
		public static function getValue (pName:String): * {
			return Config[pName];
		}
		
	}

}
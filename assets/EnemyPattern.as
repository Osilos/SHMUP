package {

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.display.DisplayObject;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;


	public class EnemyPattern extends MovieClip {
		private var tabEnemies: Array;
		private var finalString:String;
		private var file: FileReference = new FileReference();

		public function EnemyPattern() {
			// constructor code
			addEventListener(Event.ADDED_TO_STAGE, initClass);
		}

		private function initClass(pEvent: Event): void {
			tabEnemies = new Array();
			finalString = "";
			removeEventListener(Event.ADDED_TO_STAGE, initClass);

			var mcTMP: MovieClip;
			var finBoucle: uint = numChildren;
			var i: int;

			for (i = 0; i < finBoucle; i++) {
				mcTMP = getChildAt(i) as MovieClip;
				if (mcTMP is MovieClip) {
					mcTMP.flagFinish = false;
					mcTMP.arrayCoords = "";
					tabEnemies.push(mcTMP);
					mcTMP.addEventListener(Event.ENTER_FRAME, doEnterFrame);
				}
			}
		}

		private function doEnterFrame(pEvent: Event): void {
			var mcTMP: MovieClip = pEvent.currentTarget as MovieClip;
			mcTMP.arrayCoords += '{"x":' + mcTMP.vaisseau.x + ',"y":' + mcTMP.vaisseau.y + '}';
			if (mcTMP.currentFrame == mcTMP.totalFrames) {
				mcTMP.removeEventListener(Event.ENTER_FRAME, doEnterFrame);
				mcTMP.flagFinish = true;
				checkAllDone();
			}
			else
			{
				mcTMP.arrayCoords += ',';
			}
		}

		private function checkAllDone(): void {
			// parcourir tableau de clip, vérifier tous les flasgFinish à true
			var allDone: Boolean = true;
			var i: uint = 0;
			var nbBoucle: uint = tabEnemies.length;

			while (allDone && (i < nbBoucle)) {
				if (tabEnemies[i].flagFinish == false) {
					allDone = false;
				}
				i++;
			}
			if(allDone)
			{
				var j:int;
				var mcTMP: MovieClip;
				var className:String;
				
				finalString += '{"patterns":{';
				
				for(j=0; j<nbBoucle; j++)
				{
					if(j!=0)
					{
						finalString += ',';
					}
					mcTMP = tabEnemies[j];
					className = getQualifiedClassName(mcTMP);
					finalString += '"' + className + '":[' + mcTMP.arrayCoords + ']';
				}
				finalString += '}}';
				trace("finalString : " + finalString);
				doSave();
			}
		}

		private function doSave(): void {
			var data:ByteArray = new ByteArray();
			data.writeMultiByte(finalString, "utf-8");
			file.save(data, "patterns.json");
		}
	}

}
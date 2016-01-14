package {
	import flash.display.Shape;
	public class Catcher extends Shape{
		public var couleur:Number;
		public var nom:String="";
		public function Catcher(_couleur:Number):void{
			this.couleur=_couleur;
			graphics.lineStyle(0.5, 0x000000);
			
			if(this.couleur==0){
				graphics.beginFill(0xFFFF00);
				this.nom="jaune";
			}else{ 
				graphics.beginFill(0xFF0000);
				this.nom="rouge";
			}
			
			graphics.drawCircle(0, 0, 20);
			graphics.endFill();		
		}
	}
}
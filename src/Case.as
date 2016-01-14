package
{
	import flash.display.Shape;
	public class Case extends Shape{
		public var nom:String="vide";
		public var couleur:Number;
		public var couleur_jeton:Number=0xFFFFFF;
		
		public function Case(_couleur:Number, _nom:String):void
		{
			this.nom=_nom;
			this.couleur=_couleur;
			graphics.lineStyle(0.5, 0x000000);
			
			if(this.couleur==0){
				graphics.beginFill(0x0189E1);
			}else{ 
				graphics.beginFill(0xFE0000);
			}
			
			graphics.drawRect(0, 0, 50, 50);
			
			if(_nom=="rouge"){
				graphics.beginFill(0xFF0000);
			}else if(_nom=="jaune"){
				graphics.beginFill(0xFFFF00);
			}
			
			graphics.lineStyle(0.5, 0x000000);
			graphics.drawCircle(25, 25, 20);
			graphics.endFill();		
		}
	}
}
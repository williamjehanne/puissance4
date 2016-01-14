package
{
	import flash.display.*;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.external.ExternalInterface;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.text.*;
	import flash.utils.Timer;
	
	public class Puissance4 extends Sprite
	{
		public var catcher:Catcher;
		public var canvas:Sprite;
		public var maxX:Number;
		public var maxY:Number;
		public var boutonJouer:SimpleButton;
		public var niveau:Number;
		public var Message:TextField;
		public var MessageG:TextField;
		public var t:Array;
		public var vitesse:Timer;
		public var conteneurSon:Sound;
		public var liste_musique:Array;
		public var ecouteur:SoundChannel;
		public var controleur:SoundTransform;
		public var id_musique:int=0;
		public var conteneurImage:Loader = new Loader();
		public var image:URLRequest = new URLRequest("img/logo.png");
		public var conteneurImageBackground:Loader = new Loader();
		public var imageBackground:URLRequest = new URLRequest("img/galaxy.png");
		public var conteneurImageLicence:Loader = new Loader();
		public var imageLicence:URLRequest = new URLRequest("img/licence.png");
		public var conteneurImageJouer:Loader = new Loader();
		
		public function Puissance4():void
		{
			
			conteneurImage.load(image);
			conteneurImage.x=0;
			conteneurImage.y=0;
			maxX=390;
			maxY=380;
			canvas=new Sprite();
			canvas.graphics.drawRect(0,0,maxX,maxY);
			addChild(canvas);		
			conteneurImageBackground.load(imageBackground);
			conteneurImageBackground.x=0;
			conteneurImageBackground.y=0;
			
			addChildAt(conteneurImageBackground, 0);
			boutonJouer=null;
			creerBouton("Jouer");
			addChildAt(conteneurImage, 1);
			catcher=null;
			
			conteneurImageLicence.load(imageLicence);
			conteneurImageLicence.x=0;
			conteneurImageLicence.y=350;
			
			addChildAt(conteneurImageLicence, 1);

		}
		public function creerBouton(s1:String):void{
			if(s1=="Jouer"){
				
				var imageJouer:URLRequest = new URLRequest("img/jouer.png");
				conteneurImageJouer.load(imageJouer);
				conteneurImageJouer.x=180;
				conteneurImageJouer.y=150;
				conteneurImageJouer.addEventListener(MouseEvent.CLICK, jouer);
				addChild(conteneurImageJouer);
				
			}else{	
				imageJouer= new URLRequest("img/rejouer.png");
				conteneurImageJouer.load(imageJouer);
				conteneurImageJouer.x=180;
				conteneurImageJouer.y=150;
				conteneurImageJouer.addEventListener(MouseEvent.CLICK, jouer);
				addChild(conteneurImageJouer);
			}

		}
		public function supprimerBouton():void{
			conteneurImageJouer.removeEventListener(MouseEvent.CLICK, jouer);
			removeChild(conteneurImageJouer);
		}
		public function jouer(e:Event):void {	
			removeChild(conteneurImageLicence);
			ecouteur = new SoundChannel(); //Création d'un lecteur de son
			conteneurSon = new Sound();
			controleur = new SoundTransform();
			
			supprimerBouton();
			
			liste_musique = new Array();
			liste_musique[0] = new URLRequest("bubble_bobble.mp3");
			conteneurSon.load(liste_musique[0]);
			id_musique++;
			ecouteur=conteneurSon.play();
			
			controleur.volume = 0.25; //Réglage du volume 
			ecouteur.soundTransform = controleur; //Application du volume sonore
			ecouteur.addEventListener(Event.SOUND_COMPLETE, boucle_son); //Applique un écouteur détectant la fin de lecture du son
			
			
			
			if(catcher==null){
				catcher = new Catcher(0);	
			}
			catcher.y = catcher.height+0;
			catcher.x = catcher.width;
			canvas.addChildAt(catcher, 0);
			t=new Array(42); // tableau de 7 x 6
			
			chargerPlateau(t);
			
			
			if(Message==null) Message = new TextField();
			Message.autoSize=TextFieldAutoSize.LEFT;
			
			Message.text = "A vous de jouer";
			Message.textColor=0xffffff;
			var format:TextFormat = new TextFormat(); 
			format.font = "Trebuchet MS";
			Message.setTextFormat(format);
			Message.x=370;
			Message.y=10;
			
			if(MessageG!=null) canvas.removeChild(MessageG);
			
			canvas.addChild(Message);
			
			
			vitesse = new Timer(1);
			vitesse.addEventListener(TimerEvent.TIMER, descendreCatcher);
			
			canvas.addEventListener(MouseEvent.MOUSE_MOVE,deplacerCatcher);
			canvas.addEventListener(MouseEvent.CLICK,sourisPresse);
		}
		public function boucle_son(e:Event):void
		{
			
			ecouteur.removeEventListener(Event.SOUND_COMPLETE, boucle_son); //Supprime l'écouteur actuel
			ecouteur = new SoundChannel(); //Remplace le lecteur de son par un nouveau
			ecouteur = conteneurSon.play(); //Lancement de la lecture du son
			ecouteur.soundTransform = controleur; //Application du volume sonore
			ecouteur.addEventListener(Event.SOUND_COMPLETE, boucle_son); //Applique un écouteur détectant la fin de lecture du son
		} 
		
		public function chargerPlateau(_t:Array):void{
			var y:int=0;
			var Ligne:int=0;
			
			for ( var i:int = 0; i <= 41; i++ )
			{
				_t[i]=new Case(0, "vide");
				//ExternalInterface.call("alert", row+"," + " \n");
				_t[i].x=20;
				_t[i].y=60;
				
				if(y==7){
					Ligne++;
					y=0;
				}
				_t[i].x=_t[i].x+50*y;
				_t[i].y=_t[i].y+50*Ligne;
				canvas.addChildAt(_t[i], 1);
				y++;
			}
		}
		public function deplacerCatcher(e:MouseEvent):void{
			catcher.x=mouseX;
			if((catcher.x+catcher.width)>maxX){
					catcher.x=maxX-catcher.width;
			}else if((catcher.x)<=catcher.width){
				catcher.x=catcher.width;
			}
		}
		public function sourisPresse(e:MouseEvent):void{
			vitesse.start();
		}
		public function finDuJeu(_c:Case):void{
			conteneurImage.load(image);
			conteneurImage.x=0;
			conteneurImage.y=0;
			
			ecouteur.stop();
			MessageG = new TextField();
			MessageG.autoSize=TextFieldAutoSize.LEFT;
			MessageG.text = "Le gagnant est le joueur " + _c.nom;
			MessageG.textColor=0xFFFFFF;
			var format6:TextFormat = new TextFormat(); 
			format6.font = "Trebuchet MS";
			MessageG.setTextFormat(format6);
			MessageG.x=300;
			MessageG.y=10;
			
			removeChild(canvas);
			catcher = null;
			
			maxX=390;
			maxY=380;
			canvas=new Sprite();
			canvas.graphics.drawRect(0,0,maxX,maxY);
			addChild(canvas);
			
			boutonJouer=null;
			canvas.addChild(MessageG);
			
			conteneurImageBackground.load(imageBackground);
			conteneurImageBackground.x=0;
			conteneurImageBackground.y=0;
			
			addChildAt(conteneurImageBackground, 0);
			boutonJouer=null;
			creerBouton("Rejouer");
			addChildAt(conteneurImage, 1);

			
			addChildAt(conteneurImageLicence, 1);
			
			canvas.removeChild(catcher);
			vitesse.stop();

			
			
		}
		public function verifierGagnant(_i:int, _c:Case):void{
			var nbreCase:int = 0
		
			for ( var i:int = 0; i <= 41; i++ )
			{
				if(t[i].nom!="vide"){
					nbreCase++;
				}
			}
			
			//verification horizontale
			var _nbreChorizontale:int = 0;
			var i2:int = 0;

			i2=_i-3;
			if((i2>=0 && i2<=41) && (t[i2].nom==_c.nom)){//ok
				_nbreChorizontale++;
			}else if((i2>=0 && i2<=41) && (t[i2].nom!=_c.nom)){//non il y a une cassure
				_nbreChorizontale=0;
			}
						
			i2=_i-2;
			if((i2>=0 && i2<=41) && (t[i2].nom==_c.nom)){//ok
				_nbreChorizontale++;
			}else if((i2>=0 && i2<=41) && (t[i2].nom!=_c.nom)){//non il y a une cassure
				_nbreChorizontale=0;
			}
			
			i2=_i-1;
			if((i2>=0 && i2<=41) && (t[i2].nom==_c.nom)){//ok
				_nbreChorizontale++;
			}else if((i2>=0 && i2<=41) && (t[i2].nom!=_c.nom)){//non il y a une cassure
				_nbreChorizontale=0;
			}
			
			
			i2=_i;
			if((i2>=0 && i2<=41) && (t[i2].nom==_c.nom)){//ok
				_nbreChorizontale++;
			}else if((i2>=0 && i2<=41) && (t[i2].nom!=_c.nom)){//non il y a une cassure
				_nbreChorizontale=0;
			}
			
			if(_nbreChorizontale==4){
				finDuJeu(_c);
			}
			
			i2=_i+1;
			if((i2>=0 && i2<=41) && (t[i2].nom==_c.nom)){//ok
				_nbreChorizontale++;
			}else if((i2>=0 && i2<=41) && (t[i2].nom!=_c.nom)){//non il y a une cassure
				_nbreChorizontale=0;
			}
			
			if(_nbreChorizontale==4){
				finDuJeu(_c);
			}
			
			i2=_i+2;
			if((i2>=0 && i2<=41) && (t[i2].nom==_c.nom)){//ok
				_nbreChorizontale++;
			}else if((i2>=0 && i2<=41) && (t[i2].nom!=_c.nom)){//non il y a une cassure
				_nbreChorizontale=0;
			}
			
			if(_nbreChorizontale==4){
				finDuJeu(_c);
			}
			
			i2=_i+3;
			if((i2>=0 && i2<=41) && (t[i2].nom==_c.nom)){//ok
				_nbreChorizontale++;
			}else if((i2>=0 && i2<=41) && (t[i2].nom!=_c.nom)){//non il y a une cassure
				_nbreChorizontale=0;
			}
				
			if(_nbreChorizontale==4){
				finDuJeu(_c);
			}
			
			
			
			
			
			
			//verification verticale
			var _nbreCverticale:int = 0;
			var i3:int = 0;
			
			i3=_i-21;
			if((i3>=0 && i3<=41) && (t[i3].nom==_c.nom)){//ok
				_nbreCverticale++;
			}else if((i3>=0 && i3<=41) && (t[i3].nom!=_c.nom)){//non il y a une cassure
				_nbreCverticale=0;
			}
			
			i3=_i-14;
			if((i3>=0 && i3<=41) && (t[i3].nom==_c.nom)){//ok
				_nbreCverticale++;
			}else if((i3>=0 && i3<=41) && (t[i3].nom!=_c.nom)){//non il y a une cassure
				_nbreCverticale=0;
			}
			
			i3=_i-7;
			if((i3>=0 && i3<=41) && (t[i3].nom==_c.nom)){//ok
				_nbreCverticale++;
			}else if((i3>=0 && i3<=41) && (t[i3].nom!=_c.nom)){//non il y a une cassure
				_nbreCverticale=0;
			}
			
			
			i3=_i;
			if((i3>=0 && i3<=41) && (t[i3].nom==_c.nom)){//ok
				_nbreCverticale++;
			}else if((i3>=0 && i3<=41) && (t[i3].nom!=_c.nom)){//non il y a une cassure
				_nbreCverticale=0;
			}
			
			if(_nbreCverticale==4){
				finDuJeu(_c);
			}
			
			i3=_i+7;
			if((i3>=0 && i3<=41) && (t[i3].nom==_c.nom)){//ok
				_nbreCverticale++;
			}else if((i3>=0 && i3<=41) && (t[i3].nom!=_c.nom)){//non il y a une cassure
				_nbreCverticale=0;
			}
			
			if(_nbreCverticale==4){
				finDuJeu(_c);
			}
			
			i3=_i+14;
			if((i3>=0 && i3<=41) && (t[i3].nom==_c.nom)){//ok
				_nbreCverticale++;
			}else if((i3>=0 && i3<=41) && (t[i3].nom!=_c.nom)){//non il y a une cassure
				_nbreCverticale=0;
			}
			
			if(_nbreCverticale==4){
				finDuJeu(_c);
			}
			
			i3=_i+21;
			if((i3>=0 && i3<=41) && (t[i3].nom==_c.nom)){//ok
				_nbreCverticale++;
			}else if((i3>=0 && i3<=41) && (t[i3].nom!=_c.nom)){//non il y a une cassure
				_nbreCverticale=0;
			}
			
			if(_nbreCverticale==4){
				finDuJeu(_c);
			}
			
			
			
			
			
			
			//verification diagonale decroissante
			var _nbreCdiagonaleDecroissante:int = 0;
			var i4:int = 0;
			
			i4=_i-24;
			if((i4>=0 && i4<=41) && (t[i4].nom==_c.nom)){//ok
				_nbreCdiagonaleDecroissante++;
			}else if((i4>=0 && i4<=41) && (t[i4].nom!=_c.nom)){//non il y a une cassure
				_nbreCdiagonaleDecroissante=0;
			}
			
			i4=_i-16;
			if((i4>=0 && i4<=41) && (t[i4].nom==_c.nom)){//ok
				_nbreCdiagonaleDecroissante++;
			}else if((i4>=0 && i4<=41) && (t[i4].nom!=_c.nom)){//non il y a une cassure
				_nbreCdiagonaleDecroissante=0;
			}
			
			i4=_i-8;
			if((i4>=0 && i4<=41) && (t[i4].nom==_c.nom)){//ok
				_nbreCdiagonaleDecroissante++;
			}else if((i4>=0 && i4<=41) && (t[i4].nom!=_c.nom)){//non il y a une cassure
				_nbreCdiagonaleDecroissante=0;
			}
			
			
			i4=_i;
			if((i4>=0 && i4<=41) && (t[i4].nom==_c.nom)){//ok
				_nbreCdiagonaleDecroissante++;
			}else if((i4>=0 && i4<=41) && (t[i4].nom!=_c.nom)){//non il y a une cassure
				_nbreCdiagonaleDecroissante=0;
			}
			
			if(_nbreCdiagonaleDecroissante==4){
				finDuJeu(_c);
			}
			
			i4=_i+8;
			if((i4>=0 && i4<=41) && (t[i4].nom==_c.nom)){//ok
				_nbreCdiagonaleDecroissante++;
			}else if((i4>=0 && i4<=41) && (t[i4].nom!=_c.nom)){//non il y a une cassure
				_nbreCdiagonaleDecroissante=0;
			}
			
			if(_nbreCdiagonaleDecroissante==4){
				finDuJeu(_c);
			}
			
			i4=_i+16;
			if((i4>=0 && i4<=41) && (t[i4].nom==_c.nom)){//ok
				_nbreCdiagonaleDecroissante++;
			}else if((i4>=0 && i4<=41) && (t[i4].nom!=_c.nom)){//non il y a une cassure
				_nbreCdiagonaleDecroissante=0;
			}
			
			if(_nbreCdiagonaleDecroissante==4){
				finDuJeu(_c);
			}
			
			i4=_i+24;
			if((i4>=0 && i4<=41) && (t[i4].nom==_c.nom)){//ok
				_nbreCdiagonaleDecroissante++;
			}else if((i4>=0 && i4<=41) && (t[i4].nom!=_c.nom)){//non il y a une cassure
				_nbreCdiagonaleDecroissante=0;
			}
			
			if(_nbreCdiagonaleDecroissante==4){
				finDuJeu(_c);
			}
			
			
			
			
			
			
			
			
			//verification diagonale croissante
			var _nbreCdiagonaleCroissante:int = 0;
			var i5:int = 0;
			
			i5=_i-18;
			if((i5>=0 && i5<=41) && (t[i5].nom==_c.nom)){//ok
				_nbreCdiagonaleCroissante++;
			}else if((i5>=0 && i5<=41) && (t[i5].nom!=_c.nom)){//non il y a une cassure
				_nbreCdiagonaleCroissante=0;
			}
			
			i5=_i-12;
			if((i5>=0 && i5<=41) && (t[i5].nom==_c.nom)){//ok
				_nbreCdiagonaleCroissante++;
			}else if((i5>=0 && i5<=41) && (t[i5].nom!=_c.nom)){//non il y a une cassure
				_nbreCdiagonaleCroissante=0;
			}
			
			i5=_i-6;
			if((i5>=0 && i5<=41) && (t[i5].nom==_c.nom)){//ok
				_nbreCdiagonaleCroissante++;
			}else if((i5>=0 && i5<=41) && (t[i5].nom!=_c.nom)){//non il y a une cassure
				_nbreCdiagonaleCroissante=0;
			}
			
			
			i5=_i;
			if((i5>=0 && i5<=41) && (t[i5].nom==_c.nom)){//ok
				_nbreCdiagonaleCroissante++;
			}else if((i5>=0 && i5<=41) && (t[i5].nom!=_c.nom)){//non il y a une cassure
				_nbreCdiagonaleCroissante=0;
			}
			
			if(_nbreCdiagonaleCroissante==4){
				finDuJeu(_c);
			}
			
			i5=_i+6;
			if((i5>=0 && i5<=41) && (t[i5].nom==_c.nom)){//ok
				_nbreCdiagonaleCroissante++;
			}else if((i5>=0 && i5<=41) && (t[i5].nom!=_c.nom)){//non il y a une cassure
				_nbreCdiagonaleCroissante=0;
			}
			
			if(_nbreCdiagonaleCroissante==4){
				finDuJeu(_c);
			}
			
			i5=_i+12;
			if((i5>=0 && i5<=41) && (t[i5].nom==_c.nom)){//ok
				_nbreCdiagonaleCroissante++;
			}else if((i5>=0 && i5<=41) && (t[i5].nom!=_c.nom)){//non il y a une cassure
				_nbreCdiagonaleCroissante=0;
			}
			
			if(_nbreCdiagonaleCroissante==4){
				finDuJeu(_c);
			}
			
			i5=_i+18;
			if((i5>=0 && i5<=41) && (t[i5].nom==_c.nom)){//ok
				_nbreCdiagonaleCroissante++;
			}else if((i5>=0 && i5<=41) && (t[i5].nom!=_c.nom)){//non il y a une cassure
				_nbreCdiagonaleCroissante=0;
			}
			
			if(_nbreCdiagonaleCroissante==4){
				finDuJeu(_c);
			}
			
			
			
			
			
			
			
			//////////////////////////////////////////////////////////////////////////////
			if(nbreCase==42){ // fin du jeu naturel
				Message.text = "Fin du jeu";
				var format:TextFormat = new TextFormat(); 
				format.font = "Trebuchet MS";
				Message.setTextFormat(format);
			}
			//ExternalInterface.call("alert", t[41].nom);
			
		}
		public function descendreCatcher(e:Event):void{
			
				for ( var i:int = 0; i <= 41; i++ )
				{
					if(catcher.y<=maxY-46){
						
						if (t[i].hitTestObject(catcher)){
							if(t[i].nom=="vide"){
								canvas.removeEventListener(MouseEvent.MOUSE_MOVE,deplacerCatcher);
								catcher.y++;
								catcher.y++;
								catcher.y++;
								
								
								var Z:Number=i+7;
								if(t[Z].nom!="vide"){
								
									var emplacement_x3:Number=t[i].x;
									var emplacement_y3:Number=t[i].y;
									canvas.removeChild(t[i]);
									t[i]=new Case(0, catcher.nom);
									
									t[i].x=emplacement_x3;
									t[i].y=emplacement_y3;
									canvas.addChildAt(t[i], 1);
									
									vitesse.stop();
									canvas.removeChild(catcher);
									
									var nomC:String=catcher.nom;
									catcher=null;
									if(catcher==null){
										if(nomC=="jaune"){
											catcher = new Catcher(1);
											Message.text = "A l'ordinateur de jouer";
											var format:TextFormat = new TextFormat(); 
											format.font = "Trebuchet MS";
											Message.setTextFormat(format);
											verifierGagnant(i, t[i]);
											var valeur_aleatoire2:Number = Math.round(Math.random()*(maxX-0+1)+(0-.5)); 
											catcher.x=valeur_aleatoire2;
											if((catcher.x+catcher.width)>maxX){
												catcher.x=maxX-catcher.width;
											}else if((catcher.x)<=catcher.width){
												catcher.x=catcher.width;
											}
											catcher.y = catcher.height+0;
											
											canvas.addChildAt(catcher, 0);
											vitesse = new Timer(1);
											vitesse.addEventListener(TimerEvent.TIMER, descendreCatcher);
											vitesse.start();
											
										}else{
											catcher = new Catcher(0);
											Message.text = "A vous de jouer";
											var format1:TextFormat = new TextFormat(); 
											format1.font = "Trebuchet MS";
											Message.setTextFormat(format1);
											verifierGagnant(i, t[i]);
											catcher.y = catcher.height+0;
											catcher.x = catcher.width;
											canvas.addChildAt(catcher, 0);
											canvas.addEventListener(MouseEvent.MOUSE_MOVE,deplacerCatcher);
										}
										
									}
									
									
								}
							}else{
								if(catcher.nom=="jaune"){
									//canvas.removeEventListener(MouseEvent.CLICK,sourisPresse);
									vitesse.stop();
									
									canvas.removeChild(catcher);
									
									catcher = new Catcher(0);
									Message.text = "A vous de jouer";
									var format2:TextFormat = new TextFormat(); 
									format2.font = "Trebuchet MS";
									Message.setTextFormat(format2);
									verifierGagnant(i, t[i]);
									catcher.y = catcher.height+0;
									catcher.x = catcher.width;
									canvas.addChildAt(catcher, 0);
									canvas.addEventListener(MouseEvent.MOUSE_MOVE,deplacerCatcher);
									canvas.addEventListener(MouseEvent.CLICK,sourisPresse);
									
									//AJOUTER UN SON D'erreur à charger ici
								}else{
									canvas.removeChild(catcher);
									vitesse.stop();
									catcher=null;
									catcher = new Catcher(1);
									Message.text = "A l'ordinateur de jouer";
									var format3:TextFormat = new TextFormat(); 
									format3.font = "Trebuchet MS";
									Message.setTextFormat(format3);
									verifierGagnant(i, t[i]);
									var valeur_aleatoire4:Number = Math.round(Math.random()*(maxX-0+1)+(0-.5)); 
									catcher.x=valeur_aleatoire4;
									if((catcher.x+catcher.width)>maxX){
										catcher.x=maxX-catcher.width;
									}else if((catcher.x)<=catcher.width){
										catcher.x=catcher.width;
									}
									catcher.y = catcher.height+0;
									
									canvas.addChildAt(catcher, 0);
									vitesse = new Timer(1);
									vitesse.addEventListener(TimerEvent.TIMER, descendreCatcher);
									vitesse.start();
								}
							}
						}
					}else{
						//on est tout en bas
						if (t[i].hitTestObject(catcher)){
							var emplacement_x:Number=t[i].x;
							var emplacement_y:Number=t[i].y;
							
							canvas.removeChild(t[i]);
							t[i]=new Case(0, catcher.nom);
							
							t[i].x=emplacement_x;
							t[i].y=emplacement_y;
							canvas.addChildAt(t[i], 1);
							
							vitesse.stop();
							canvas.removeChild(catcher);
							var nomC3:String=catcher.nom;
							catcher=null;
							if(catcher==null){
								if(nomC3=="jaune"){
									catcher = new Catcher(1);
									Message.text = "A l'ordinateur de jouer";
									var format4:TextFormat = new TextFormat(); 
									format4.font = "Trebuchet MS";
									Message.setTextFormat(format4);
									verifierGagnant(i, t[i]);
									var valeur_aleatoire1:Number = Math.round(Math.random()*(maxX-0+1)+(0-.5)); 
									catcher.x=valeur_aleatoire1;
									if((catcher.x+catcher.width)>maxX){
										catcher.x=maxX-catcher.width;
									}else if((catcher.x)<=catcher.width){
										catcher.x=catcher.width;
									}
									catcher.y = catcher.height+0;
									
									canvas.addChildAt(catcher, 0);
									vitesse = new Timer(1);
									vitesse.addEventListener(TimerEvent.TIMER, descendreCatcher);
									vitesse.start();
									
								}else{
									catcher = new Catcher(0);
									Message.text = "A vous de jouer";
									var format5:TextFormat = new TextFormat(); 
									format5.font = "Trebuchet MS";
									Message.setTextFormat(format5);
									verifierGagnant(i, t[i]);
									catcher.y = catcher.height+0;
									catcher.x = catcher.width;
									canvas.addChildAt(catcher, 0);
									canvas.addEventListener(MouseEvent.MOUSE_MOVE,deplacerCatcher);
								}
								
							}
							
						}
						
					}
					
				}
		}
		
	
	}
}
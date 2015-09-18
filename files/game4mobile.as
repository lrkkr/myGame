package {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Point;
	import flash.errors.IOError;

	public class game4mobile extends MovieClip {
		private var mymap: myMap;
		private var gameSprite: Sprite;
		private var mapWidth: int = 15;
		private var mapHeight: int = 15;
		private var tileSize: int = 768 / mapWidth;
		private var map: Array;
		private var hero: Object;
		private var gameMode: String = "start";
		private var pics: Array;
		private var mydialogMc: dialogMc;
		public var saveData: XML;
		private var ep: Number = 0;
		private var mp: Number = 0;
		private var hp: Number = 0;
		private var elp: Number = 0;
		private var mlp: Number = 0;
		private var hlp: Number = 0;
		private var ewr: Number = 0;
		private var mwr: Number = 0;
		private var hwr: Number = 0;
		private var twr: Number = 0;
		private var tp: int = 0;
		private var myFile: File = File.applicationStorageDirectory.resolvePath("sd.xml");
		private var saveFileStream: FileStream;
		private var openFileStream: FileStream;
		public var myString: String;
		public var movePoint: Point = new Point();
		public var moveMapPoint: Point = new Point();
		public var mcList: Array = new Array();
		public var moveList:Array=new Array();
		public function game4mobile(): void {
			mydialogMc = new dialogMc();
			mydialogMc.x = (768 - mydialogMc.width) / 2;
			mydialogMc.y = (1366 - mydialogMc.height) / 2;
			mydialogMc.addEventListener(MouseEvent.CLICK, fl_confirm);
			mymap = new myMap();
			saveData = <saveData> 
					<easyPoint>0</easyPoint>
					<mediumPoint>0</mediumPoint> 
					<hardPoint>0</hardPoint>
					<easyLostPoint>0</easyLostPoint> 
					<mediumLostPoint>0</mediumLostPoint>
					<hardLostPoint>0</hardLostPoint> 
					<easyWinrate>0</easyWinrate>
					<mediumWinrate>0</mediumWinrate> 
					<hardWinrate>0</hardWinrate>
					<totalWinrate>0</totalWinrate> 
					<totalPoint>0</totalPoint>
				</saveData>
				readSaveData();
		}
		public function data2String(): void {
			readSaveData();
			trace(saveData);
			myString = new String();
			myString = "简单模式：\n"
			myString += "成功：" + saveData.easyPoint.toString() + "\n";
			myString += " 失败：" + saveData.easyLostPoint.toString() + "\n";
			myString += " 胜率：" + saveData.easyWinrate.toString() + "\n";
			myString += "中等模式：\n";
			myString += "成功：" + saveData.mediumPoint.toString() + "\n";
			myString += " 失败：" + saveData.mediumLostPoint.toString() + "\n";
			myString += " 胜率：" + saveData.mediumWinrate.toString() + "\n";
			myString += "困难模式：\n";
			myString += "成功：" + saveData.hardPoint.toString() + "\n";
			myString += " 失败：" + saveData.hardLostPoint.toString() + "\n";
			myString += " 胜率：" + saveData.hardWinrate.toString() + "\n";
			myString += "总胜率：" + saveData.totalWinrate.toString() + "\n";
			myString += "总评分：" + saveData.totalPoint.toString();
			trace(myString);
		}
		public function readSaveData(): void {
			openFileStream = new FileStream();
			try{
				openFileStream.open(myFile, FileMode.READ);
				saveData = XML(openFileStream.readUTFBytes(openFileStream.bytesAvailable));
				ep = saveData.easyPoint;
				mp = saveData.mediumPoint;
				hp = saveData.hardPoint;
				elp = saveData.easyLostPoint;
				mlp = saveData.mediumLostPoint;
				hlp = saveData.hardLostPoint;
				ewr = saveData.easyWinrate;
				mwr = saveData.mediumWinrate;
				hwr = saveData.hardWinrate;
				twr = saveData.totalWinrate;
				tp = saveData.totalPoint;
				openFileStream.close();
			}catch(erroe:IOError){
				trace("can't readSaveData");
			}
		}
		public function saveSaveData(): void {
			saveFileStream = new FileStream();
			saveFileStream.open(myFile, FileMode.WRITE);
			var outputString: String = '<?xml version="1.0" encoding="utf-8"?>\n';
			saveData.easyPoint = ep;
			saveData.mediumPoint = mp;
			saveData.hardPoint = hp;
			saveData.easyLostPoint = elp;
			saveData.mediumLostPoint = mlp;
			saveData.hardLostPoint = hlp;
			saveData.easyWinrate = ewr;
			saveData.mediumWinrate = mwr;
			saveData.hardWinrate = hwr;
			saveData.totalWinrate = twr;
			saveData.totalPoint = tp;
			outputString += saveData.toXMLString();
			saveFileStream.writeUTFBytes(outputString);
			saveFileStream.close();
		}
		public function setMapWidth(MW: int): void {
			mapWidth = mapHeight = MW;
			tileSize = 768 / mapWidth;
		}
		/*private function passAns():Array
		{
			return mymap.getAns();
		}*/
		private function showMap(): void {
			trace(mapWidth);
			gameMode = "play";
			map = mymap.getMap(mapWidth, mapHeight);
			pics = new Array();
			for (var rows: int = 0; rows < mapHeight; rows++) {
				pics.push(new Array());
			}
			gameSprite = new Sprite();
			for (var row: int = 0; row < mapHeight; row++) {
				for (var col: int = 0; col < mapWidth; col++) {
					addPic(row, col);
				}
			}
			gameSprite.addChild(hero.mc);
			addChild(gameSprite);
		}
		public function addPic(row: int, col: int): void {
			var newPic: Pic = new Pic();
			newPic.x = col * tileSize + (768 - mapWidth * tileSize) / 2;
			newPic.y = row * tileSize + 40;
			newPic.width = newPic.height = tileSize;
			if (map[row][col] == -1 || map[row][col] == -2) {
				newPic.type = 1;
			} else {
				newPic.type = 2;
			}
			newPic.gotoAndStop(newPic.type);
			gameSprite.addChild(newPic);
			pics[row][col] = newPic;
		}
		public function createHero(): void {
			hero = new Object();
			hero.mc = new myHero();
			hero.direction = 2;
			hero.ax = 1;
			hero.ay = 1;
			hero.mc.x = tileSize + (768 - mapWidth * tileSize) / 2;
			hero.mc.y = tileSize + 40;
			hero.mc.width = hero.mc.height = tileSize;
		}
		public function keyFunction(keyCode: int): void {
			if (gameMode != "play") return;
			if (cantMove()) {
				gameOver();
				return;
			}
			if (map[hero.ax][hero.ay] == -3 && passAll()) {
				gameComplete();
				return;
			} else if (map[hero.ax][hero.ay] == -3 && (!passAll())) {
				gameOver();
				return;
			}
			if (keyCode == 37) {
				//left
				trace("press left");
				if (map[hero.ax][hero.ay - 1] != -1 && map[hero.ax][hero.ay - 1] != -2 && map[hero.ax][hero.ay - 1] != 1) {
					hero.ay--;
					hero.direction = 3;
					reDraw(0, -1);
				}
			} else if (keyCode == 39) {
				//right
				trace("press right");
				if (map[hero.ax][hero.ay + 1] != -1 && map[hero.ax][hero.ay + 1] != -2 && map[hero.ax][hero.ay + 1] != 1) {
					hero.ay++;
					hero.direction = 4;
					reDraw(0, 1);
				}
			} else if (keyCode == 38) {
				//up
				trace("press up");
				if (map[hero.ax - 1][hero.ay] != -1 && map[hero.ax - 1][hero.ay] != -2 && map[hero.ax - 1][hero.ay] != 1) {
					hero.ax--;
					hero.direction = 1;
					reDraw(-1, 0);
				}
			} else if (keyCode == 40) {
				//down
				trace("press down");
				if (map[hero.ax + 1][hero.ay] != -1 && map[hero.ax + 1][hero.ay] != -2 && map[hero.ax + 1][hero.ay] != 1) {
					hero.ax++;
					hero.direction = 2;
					reDraw(1, 0);
				}
			} else if (keyCode == 8) {
				//Backspace
				trace("press Backspace");
				gmBack();
			}
		}
		public function savePoint(ox: int, oy: int): void {
			var bmc: Point = new Point();
			//trace(hero.mc.x);
			movePoint.x = hero.ax;
			movePoint.y = hero.ay;
			moveList.push(movePoint.clone());
			moveMapPoint.x = hero.ax - ox;
			moveMapPoint.y = hero.ay - oy;
			bmc.x = hero.mc.x;
			bmc.y = hero.mc.y;
			trace(bmc);
			mcList.push(bmc.clone());
			if(moveList.length==3){
				moveList.shift();
			}
			if(mcList.length==3){
				mcList.shift();
			}
			//trace(mcList);
		}
		public function gmBack(): void {
			if(mcList.length<2) return;
			if(moveList.length<2) return;
			var mcp: Point = new Point();
			var mpt: Point = new Point();
			moveList.pop();
			mpt = moveList.pop() as Point;
			hero.ax = mpt.x;
			hero.ay = mpt.y;
			map[moveMapPoint.x][moveMapPoint.y] = 0;
			var backPic: Pic = pics[moveMapPoint.x][moveMapPoint.y];
			backPic.type = 2;
			backPic.gotoAndStop(backPic.type);
			//mcList.pop();
			mcp = mcList.pop() as Point;
			trace(mcList);
			hero.mc.x = mcp.x;
			hero.mc.y = mcp.y;
		}
		public function cantMove(): Boolean {
			if ((map[hero.ax + 1][hero.ay] != -1 && map[hero.ax + 1][hero.ay] != -2 && map[hero.ax + 1][hero.ay] != 1) || (map[hero.ax - 1][hero.ay] != -1 && map[hero.ax - 1][hero.ay] != -2 && map[hero.ax - 1][hero.ay] != 1) || (map[hero.ax][hero.ay + 1] != -1 && map[hero.ax][hero.ay + 1] != -2 && map[hero.ax][hero.ay + 1] != 1) || (map[hero.ax][hero.ay - 1] != -1 && map[hero.ax][hero.ay - 1] != -2 && map[hero.ax][hero.ay - 1] != 1)) {
				return false;
			}
			return true;
		}
		public function reDraw(dx: int, dy: int): void {
			savePoint(dx, dy);
			map[hero.ax - dx][hero.ay - dy] = 1;
			var oldPic: Pic = pics[hero.ax - dx][hero.ay - dy];
			//gameSprite.removeChild(pics[hero.ax - dx][hero.ay - dy]);
			oldPic.type = 3;
			oldPic.gotoAndStop(oldPic.type);
			//gameSprite.addChild(oldPic);
			hero.mc.x = oldPic.x + dy * tileSize;
			hero.mc.y = oldPic.y + dx * tileSize;
		}
		public function gameOver(): void {
			if (mapWidth == 15) {
				elp += 1;
				ewr = 100 * ep / (elp + ep);
			} else if (mapWidth == 25) {
				mlp += 1;
				mwr = 100 * mp / (mlp + mp);
			} else if (mapWidth == 35) {
				hlp += 1;
				hwr = 100 * hp / (hlp + hp);
			}
			twr = 100 * (ep + mp + hp) / (elp + ep + mlp + mp + hlp + hp);
			tp = int(twr * 1000 + ep + mp * 2 + hp * 3 - elp - mlp * 2 - hlp * 3);
			saveSaveData();
			trace("game over!");
			gameMode = "over";
			removeChild(gameSprite);
			mydialogMc.gotoAndStop(2);
			addChild(mydialogMc);
		}
		public function gameComplete(): void {
			if (mapWidth == 15) {
				ep += 1;
				ewr = 100 * ep / (elp + ep);
			} else if (mapWidth == 25) {
				mp += 1;
				mwr = 100 * mp / (mlp + mp);
			} else if (mapWidth == 35) {
				hp += 1;
				hwr = 100 * hp / (hlp + hp);
			}
			twr = 100 * (ep + mp + hp) / (elp + ep + mlp + mp + hlp + hp);
			tp = int(twr * 1000 + ep + mp * 2 + hp * 3 - elp - mlp * 2 - hlp * 3);
			saveSaveData();
			trace("success!");
			gameMode = "clear";
			removeChild(gameSprite);
			mydialogMc.gotoAndStop(3);
			addChild(mydialogMc);
		}
		public function fl_confirm(event: MouseEvent): void {
			trace("fl_confirm");
			removeChild(mydialogMc);
			gotoAndStop(2);
		}
		public function passAll(): Boolean {
			for (var row: int = 0; row < mapHeight; row++) {
				for (var col: int = 0; col < mapWidth; col++) {
					if (map[row][col] == 0) return false;
				}
			}
			return true;
		}
	}
}
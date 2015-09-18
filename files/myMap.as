package {
	import flash.geom.Point;

	public class myMap {
		private const UP: String = "U";
		private const DOWN: String = "D";
		private const LEFT: String = "L";
		private const RIGHT: String = "R";
		private var _width: uint;
		private var _height: uint;
		private var _myMap: Array;
		private var _walkList: Array;
		private var _start: Point;
		private var myDirections: Array;
		private var moveStatus: Array;
		private var count: int;
		public function getMap(Width: int, Height: int): Array {
			do {
				myDirections = new Array();
				count = 0;
				moveStatus = new Array();
				_start = new Point(1, 1);
				_width = Width;
				_height = Height;
				_arrayCreater();
				_createMap();
			} while (myDirections.length < (Width * Height / 3));
			trace("myDirections:" + myDirections);
			return _myMap;
		}
		/*
		public function getAns(): Array {
			return myDirections;
		}
		*/
		private function _arrayCreater(): void {
			_myMap = new Array();
			for (var row: int = 0; row < _height; row++) {
				_myMap[row] = new Array();
				for (var column: int = 0; column < _width; column++) {
					_myMap[row][column] = -1;
				}
			}
			_myMap[_start.x][_start.y] = 1;
		}
		private function _createMap(): void {
			var back: Point;
			var pos: Point = _start.clone();
			var direction: int;
			var possibleDirections: String;
			_walkList = new Array();
			_walkList.push(pos.clone());
			while (pos.y != _width - 1) {
				possibleDirections = "";
				if ((pos.x - 1 != 0) && (_myMap[pos.x - 1][pos.y] != -2) && (_myMap[pos.x - 1][pos.y] != 0)) {
					possibleDirections += UP;
				}
				if ((pos.x + 1 != _height - 1) && (_myMap[pos.x + 1][pos.y] != -2) && (_myMap[pos.x + 1][pos.y] != 0)) {
					possibleDirections += DOWN;
				}
				if ((pos.y - 1 != 0) && (_myMap[pos.x][pos.y - 1] != -2) && (_myMap[pos.x][pos.y - 1] != 0)) {
					possibleDirections += LEFT;
				}
				if ((pos.y + 1 != _width) && (_myMap[pos.x][pos.y + 1] != -2) && (_myMap[pos.x][pos.y + 1] != 0)) {
					possibleDirections += RIGHT;
				}
				if (possibleDirections.length > 0) {
					if (moveStatus[count - 1] == 0) {
						_walkList.push(pos.clone());
					}
					direction = getRandom(0, (possibleDirections.length - 1));
					switch (possibleDirections.charAt(direction)) {
						case UP:
							_myMap[pos.x][pos.y] = 0;
							pos.x -= 1;
							myDirections.push(UP);
							countOne();
							break;
						case DOWN:
							_myMap[pos.x][pos.y] = 0;
							pos.x += 1;
							myDirections.push(DOWN);
							countOne();
							break;
						case LEFT:
							_myMap[pos.x][pos.y] = 0;
							pos.y -= 1;
							myDirections.push(LEFT);
							countOne();
							break;
						case RIGHT:
							_myMap[pos.x][pos.y] = 0;
							pos.y += 1;
							myDirections.push(RIGHT);
							countOne();
							break;
					}
					_walkList.push(pos.clone());
				} else {
					countZero();
					_myMap[pos.x][pos.y] = -2;
					back = _walkList.pop() as Point;
					myDirections.pop();
					pos.x = back.x;
					pos.y = back.y;
				}
				_myMap[pos.x][pos.y] = -3;
			}
		}
		private function countOne(): void {
			moveStatus[count] = 1;
			count++;
		}
		private function countZero(): void {
			moveStatus[count] = 0;
			count++;
		}
		private function getRandom(min: int, max: int): int {
			return int((Math.random() * (max - min + 1)) + min);
		}
	}
}
package;

import flixel.tile.FlxTilemap;

class GameMap extends FlxTilemap
{
	static var PASSES:Int = 5;
	static var init_chance:Float = 0.1;
	// static var max_enemies:Int = 10;
	// static var enemy_chance = 0.075;
	static var cavern_threshold:Float = 0.33;

	static var starvation:Int = 3;
	static var overpop:Int = 9;
	static var birth:Int = 4;

	var map:Array<Array<Int>>;
	var numX:Int;
	var numY:Int;

	public override function new(x:Int, y:Int)
	{
		super();
		numX = x;
		numY = y;
		generateMap();
	}

	public function generateMap()
	{
		map = [for (i in 0...numX) [for (j in 0...numY) 1]];
		for (j in 0...map[0].length)
		{
			for (i in 0...map.length)
			{
				var rand:Float = Math.random();
				if (rand < init_chance)
				{
					map[i][j] = 2;
				}
			}
		}
		for (i in 0...PASSES)
		{
			doGenerationStep();
		}

		var boundMap:Array<Array<Int>> = Util.bindMapInBox(map);
		loadMapFrom2DArray(boundMap, AssetPaths.tiles__png);
	}

	function doGenerationStep()
	{
		var clone:Array<Array<Int>> = Util.deepCopyMap(map);
		for (y in 0...map[0].length)
		{
			for (x in 0...map.length)
			{
				var alive:Int = countAliveNeighbors(x, y);
				if (map[x][y] > 1)
				{
					clone[x][y] = (alive < starvation || alive > overpop) ? 1 : 2;
				}
				else
				{
					clone[x][y] = (alive > birth) ? 2 : 1;
				}
			}
		}
		map = clone;
	}

	function countAliveNeighbors(x, y)
	{
		var count:Int = 0;
		for (i in -1...1)
		{
			for (j in -1...1)
			{
				var n_x:Int = x + i;
				var n_y:Int = y + j;
				if (i == 0 && j == 0) {}
				else if (n_x < 0 || n_y < 0 || n_x >= map.length || n_y >= map.length)
				{
					count += 1;
				}
				else
				{
					count += (map[n_x][n_y] == 1) ? 1 : 0;
				}
			}
		}
		return count;
	}
}

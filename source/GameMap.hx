package;

import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.tile.FlxTilemap;

class GameMap extends FlxTilemap
{
	static var PASSES:Int = 6;
	static var init_chance:Float = 0.5;
	static var cavern_threshold:Float = 0.5;

	static var starvation:Int = 4;
	static var overpop:Int = 9;
	static var birth:Int = 5;

	var map:Array<Array<Int>>;
	var numX:Int;
	var numY:Int;

	public override function new(x:Int, y:Int)
	{
		super();
		numX = x;
		numY = y;
		makeMap();
	}

	public function makeMap()
	{
		generateMap();
		fillInHoles();
		var boundMap:Array<Array<Int>> = Util.bindMapInBox(map);
		loadMapFrom2DArray(boundMap, AssetPaths.tiles__png);
	}

	public function generateMap()
	{
		map = [for (i in 0...numX) [for (j in 0...numY) 1]];
		for (j in 0...map[0].length)
		{
			for (i in 0...map.length)
			{
				var rand:Float = FlxG.random.float();
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
	}

	function doGenerationStep()
	{
		var clone:Array<Array<Int>> = Util.deepCopyMap(map);
		for (y in 0...map[0].length)
		{
			for (x in 0...map.length)
			{
				var alive:Int = countAliveNeighbors(x, y, false);
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

	function countAliveNeighbors(x, y, dir4)
	{
		var count:Int = 0;
		for (i in -1...1)
		{
			for (j in -1...1)
			{
				var n_x:Int = x + i;
				var n_y:Int = y + j;
				if (i == 0 && j == 0 || (dir4 && (i == 0 || j == 0))) {}
				else if (n_x < 0 || n_y < 0 || n_x >= map.length || n_y >= map.length)
				{
					count += 1;
				}
				else
				{
					count += (map[n_x][n_y] == 2) ? 2 : 1;
				}
			}
		}
		return count;
	}

	function fillInHoles()
	{
		var goodCavern:Bool = false;
		var clone:Array<Array<Int>> = [for (i in 0...numX) [for (j in 0...numY) 1]];
		while (!goodCavern)
		{
			clone = [for (i in 0...numX) [for (j in 0...numY) 1]];
			var fillPoint:FlxPoint = FlxPoint.weak(FlxG.random.int(0, numX - 1), FlxG.random.int(0, numY - 1));
			floodFill(clone, Std.int(fillPoint.x), Std.int(fillPoint.y));

			var numFilled:Int = 0;
			for (y in 0...clone[0].length)
			{
				for (x in 0...clone.length)
				{
					if (clone[x][y] > 1)
					{
						numFilled += 1;
					}
				}
			}

			if (numFilled < 3)
			{
				continue;
			}

			if (numFilled / (numX * numY) < cavern_threshold)
			{
				generateMap();
			}
			else
			{
				goodCavern = true;
			}
		}

		for (y in 0...clone[0].length)
		{
			for (x in 0...clone.length)
			{
				if (clone[x][y] <= 1)
				{
					map[x][y] = 2;
				}
			}
		}
	}

	function floodFill(clone:Array<Array<Int>>, x:Int, y:Int)
	{
		if (x < 0 || y < 0 || x >= map.length || y >= map[0].length || map[x][y] > 1 || clone[x][y] > 1) {}
		else
		{
			clone[x][y] = 2;
			floodFill(clone, x - 1, y);
			floodFill(clone, x + 1, y);
			floodFill(clone, x, y - 1);
			floodFill(clone, x, y + 1);
		}
	}
}

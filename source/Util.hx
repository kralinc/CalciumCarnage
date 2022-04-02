package;

class Util
{
	public static function deepCopyMap(map:Array<Array<Int>>)
	{
		var newMap:Array<Array<Int>> = [for (x in 0...map.length) [for (y in 0...map[0].length) 1]];
		for (i in 0...map[0].length)
		{
			for (j in 0...map.length)
			{
				newMap[i][j] = map[i][j];
			}
		}

		return newMap;
	}

	public static function bindMapInBox(map:Array<Array<Int>>)
	{
		var newMap:Array<Array<Int>> = [for (x in 0...map.length + 2) [for (y in 0...map[0].length + 2) 2]];
		for (y in 0...map[0].length)
		{
			for (x in 0...map.length)
			{
				newMap[x + 1][y + 1] = map[x][y];
			}
		}
		return newMap;
	}
}

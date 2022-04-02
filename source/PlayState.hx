package;

import enemies.Enemy;
import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import guns.Bullet;
import guns.Gun;
import guns.Pistol;

class PlayState extends FlxState
{
	private static var MAPSIZE:FlxPoint = new FlxPoint(25, 25);

	var player:Player;
	var gun:Gun;
	var map:GameMap;

	public var bullets:FlxTypedGroup<Bullet>;
	public var enemies:FlxTypedGroup<Enemy>;

	override public function create()
	{
		player = new Player(50, 50);
		bullets = new FlxTypedGroup();
		for (i in 0...100)
		{
			var b:Bullet = new Bullet(0, 0, new FlxPoint(0, 0), "");
			b.kill();
			bullets.add(b);
		}
		gun = new Pistol(25, player, bullets, 0.5, 350);

		map = new GameMap(Std.int(MAPSIZE.x), Std.int(MAPSIZE.y));
		map.follow();
		map.setTileProperties(1, NONE);
		map.setTileProperties(2, ANY);
		var playerStart:FlxPoint = map.getTileCoords(1, false)[Std.int(MAPSIZE.y)];
		player.setPosition(playerStart.x, playerStart.y);

		FlxG.camera.follow(player, TOPDOWN, 1);

		add(map);
		add(player);
		add(gun);
		add(bullets);
		super.create();
	}

	override public function update(elapsed:Float)
	{
		// if (FlxG.mouse.justPressed)
		// {
		// 	map.generateMap();
		// }
		FlxG.collide(player, map);
		// map.overlapsWithCallback(bullets, removeBullet);
		super.update(elapsed);
	}

	function removeBullet(bullet:Bullet)
	{
		bullet.kill();
	}
}

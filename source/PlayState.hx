package;

import enemies.Enemy;
import enemies.Shooty;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import guns.Bullet;
import guns.EnemyBullet;
import guns.Gun;
import guns.Pistol;

class PlayState extends FlxState
{
	private static var MAPSIZE:FlxPoint = new FlxPoint(25, 25);

	var player:Player;
	var gun:Gun;
	var map:GameMap;

	var wave:Int = 0;

	public var bullets:FlxTypedGroup<Bullet>;
	public var enemyBullets:FlxTypedGroup<EnemyBullet>;
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
		enemyBullets = new FlxTypedGroup();
		for (i in 0...250)
		{
			var eb:EnemyBullet = new EnemyBullet();
			eb.kill();
			enemyBullets.add(eb);
		}

		gun = new Pistol(25, player, bullets, 0.5, 350);

		map = new GameMap(Std.int(MAPSIZE.x), Std.int(MAPSIZE.y));
		map.follow();
		map.setTileProperties(1, NONE);
		map.setTileProperties(2, ANY);
		var playerStart:FlxPoint = map.getTileCoords(1, false)[Std.int(MAPSIZE.y)];
		player.setPosition(playerStart.x, playerStart.y);

		FlxG.camera.follow(player, TOPDOWN, 1);

		enemies = new FlxTypedGroup();

		add(map);
		add(player);
		add(enemies);
		add(gun);
		add(bullets);
		add(enemyBullets);

		nextWave();
		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		FlxG.collide(player, map);
		FlxG.collide(enemies, map);
		FlxG.collide(map, bullets, removeBullet);
		FlxG.collide(map, enemyBullets, removeEBullet);
		FlxG.collide(enemies, bullets, bulletCollidesEnemy);
		enemies.forEachAlive(checkEnemyVision);
	}

	function nextWave()
	{
		wave++;
		enemies = new FlxTypedGroup();
		var numEnemies:Int = Std.int((wave + 5) * 1.1);
		for (i in 0...numEnemies)
		{
			var tileCoords:Array<FlxPoint> = map.getTileCoords(0, true);
			var ePos = tileCoords[FlxG.random.int(0, tileCoords.length - 1)];
			enemies.add(new Shooty(enemyBullets, ePos.x, ePos.y, (1 / wave) * 0.5, 200));
		}
	}

	function removeBullet(tile:FlxObject, bullet:Bullet)
	{
		bullet.kill();
	}

	function removeEBullet(tile:FlxObject, bullet:EnemyBullet)
	{
		bullet.kill();
	}

	function bulletCollidesEnemy(enemy:Enemy, bullet:Bullet)
	{
		bullet.kill();
		enemy.health--;
		if (enemy.health <= 0)
		{
			enemy.kill();
		}
	}

	function checkEnemyVision(enemy:Enemy)
	{
		if (map.ray(enemy.getMidpoint(), player.getMidpoint()))
		{
			enemy.seesPlayer = true;
			enemy.playerPosition = player.getMidpoint();
		}
		else
		{
			enemy.seesPlayer = false;
		}
	}
}

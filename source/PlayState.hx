package;

import enemies.Enemy;
import enemies.Shooty;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.math.FlxVelocity;
import flixel.util.FlxSpriteUtil;
import guns.Bullet;
import guns.EnemyBullet;
import guns.Gun;
import guns.Pistol;
import hud.GameOverHud;
import hud.Hud;

class PlayState extends FlxState
{
	private static var MAPSIZE:FlxPoint = new FlxPoint(25, 25);

	var player:Player;
	var gun:Gun;
	var map:GameMap;
	var hud:Hud;
	var goHud:GameOverHud;
	var cam:CamFollow;

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
		for (i in 0...200)
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

		cam = new CamFollow(player);
		FlxG.camera.follow(player, TOPDOWN_TIGHT, 1);

		enemies = new FlxTypedGroup();

		hud = new Hud(player);

		goHud = new GameOverHud();
		goHud.kill();

		add(map);
		add(player);
		add(enemies);
		add(gun);
		add(bullets);
		add(enemyBullets);
		add(hud);
		add(cam);
		add(goHud);

		nextWave();
		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		FlxG.collide(player, map);
		FlxG.collide(enemies, map);
		FlxG.collide(player, enemies);
		FlxG.collide(map, bullets, removeBullet);
		FlxG.collide(map, enemyBullets, removeEBullet);
		FlxG.overlap(enemies, bullets, bulletTouchEnemy);
		FlxG.overlap(player, enemyBullets, playerTouchEBullet);
		enemies.forEachAlive(checkEnemyVision);
	}

	function nextWave()
	{
		wave++;
		hud.setWaveText(wave);
		enemies.clear();
		var numEnemies:Int = Std.int((wave + 5) * 1.1);
		for (i in 0...numEnemies)
		{
			var tileCoords:Array<FlxPoint> = map.getTileCoords(1, true);
			var ePos = tileCoords[FlxG.random.int(0, tileCoords.length - 1)];
			enemies.add(new Shooty(enemyBullets, ePos.x, ePos.y, 4 - (0.1 * wave), 100 + (2 * wave)));
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

	function bulletTouchEnemy(enemy:Enemy, bullet:Bullet)
	{
		bullet.kill();
		if (!FlxSpriteUtil.isFlickering(enemy))
		{
			enemy.health--;
			if (enemy.health <= 0)
			{
				enemy.kill();
				hud.addScore(1);
				if (enemies.countLiving() <= 0)
				{
					nextWave();
				}
			}
		}
	}

	function playerTouchEBullet(player:Player, eb:EnemyBullet)
	{
		eb.kill();
		if (!FlxSpriteUtil.isFlickering(player))
		{
			player.health--;
			FlxSpriteUtil.flicker(player);
			if (player.health <= 0)
			{
				player.kill();
				cam.kill();
				gun.kill();
				hud.kill();
				goHud.revive();
			}
		}
	}

	function checkEnemyVision(enemy:Enemy)
	{
		var canSeePlayer:Bool = map.ray(enemy.getMidpoint(), player.getMidpoint());

		if (canSeePlayer && enemy.isOnScreen())
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

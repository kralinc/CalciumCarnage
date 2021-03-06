package;

import enemies.Enemy;
import enemies.RapidGunny;
import enemies.Shooty;
import enemies.Shotgunny;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.util.FlxSave;
import flixel.util.FlxSpriteUtil;
import guns.Bullet;
import guns.EnemyBullet;
import guns.Gun;
import guns.GunPickup;
import guns.Pistol;
import hud.GameOverHud;
import hud.Hud;

class PlayState extends FlxState
{
	private static var MAPSIZE:FlxPoint = new FlxPoint(20, 20);
	public static var GUNRADIUS:Float = 20;

	var _gameSave:FlxSave;
	var player:Player;
	var gun:Gun;
	var map:GameMap;
	var hud:Hud;
	var goHud:GameOverHud;
	var gunPickup:GunPickup;

	var gunPickupTimer:Float = 0;
	var gunPickupTimeLimit:Float = 30;
	var hasPickup:Bool = false;
	var gunPickupUsageTimer:Float = 0;
	var gunPickupUsageTimeLimit:Float = 12;

	var gunPickupSound:FlxSound;
	var playerHitSound:FlxSound;
	var waveSound:FlxSound;

	var wave:Int = 0;
	var openTiles:Array<FlxPoint>;

	public var bullets:FlxTypedGroup<Bullet>;
	public var enemyBullets:FlxTypedGroup<EnemyBullet>;
	public var enemies:FlxTypedGroup<Enemy>;

	override public function create()
	{
		_gameSave = new FlxSave();
		_gameSave.bind("highscore");

		player = new Player(50, 50, 215);

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

		gun = new Pistol(PlayState.GUNRADIUS, player, bullets);
		gunPickup = new GunPickup(player, bullets);

		map = new GameMap(Std.int(MAPSIZE.x), Std.int(MAPSIZE.y));
		map.follow();
		map.setTileProperties(1, NONE);
		map.setTileProperties(2, ANY);
		openTiles = map.getTileCoords(1, false);

		var playerStart:FlxPoint = openTiles[Std.int(openTiles.length / 2)];
		player.setPosition(playerStart.x, playerStart.y);

		FlxG.camera.follow(player, TOPDOWN_TIGHT, 1);

		enemies = new FlxTypedGroup();

		hud = new Hud(player);

		goHud = new GameOverHud();
		goHud.kill();

		gunPickupSound = FlxG.sound.load(AssetPaths.chachik__wav);
		playerHitSound = FlxG.sound.load(AssetPaths.playerhit__wav);
		waveSound = FlxG.sound.load(AssetPaths.wav__wav);

		add(map);
		add(player);
		add(gunPickup);
		add(enemies);
		add(gun);
		add(bullets);
		add(enemyBullets);
		add(hud);
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
		FlxG.overlap(player, gunPickup, pickupGun);
		enemies.forEachAlive(checkEnemyVision);

		gunPickupTimer += elapsed;
		if (gunPickupTimer >= gunPickupTimeLimit)
		{
			resetGunPickup();
		}
		if (hasPickup)
		{
			gunPickupUsageTimer += elapsed;
			if (gunPickupUsageTimer >= gunPickupUsageTimeLimit)
			{
				endGunPickup();
			}
		}
	}

	function nextWave()
	{
		wave++;
		hud.setWaveText(wave);
		enemies.clear();
		waveSound.play();

		var numShooty:Int = Std.int(5 + (wave * 0.6));
		var numGunny:Int = Std.int((wave) * 0.5);
		var numShotGunny:Int = Std.int((wave) * 0.33);

		for (i in 0...numShooty)
		{
			var ePos:FlxPoint = getNewEnemyPosition();
			enemies.add(new Shooty(enemyBullets, ePos.x, ePos.y, 4 - (0.1 * wave), 100 + (2 * wave)));
		}

		for (g in 0...numGunny)
		{
			var ePos:FlxPoint = getNewEnemyPosition();
			enemies.add(new RapidGunny(enemyBullets, ePos.x, ePos.y, 5 - (0.1 * wave), 70 + (2 * wave)));
		}

		for (s in 0...numShotGunny)
		{
			var ePos:FlxPoint = getNewEnemyPosition();
			enemies.add(new ShotGunny(enemyBullets, ePos.x, ePos.y, 4 - (0.1 * wave), 110 + (2 * wave)));
		}

		hud.setLeftText(enemies.countLiving());
	}

	function getNewEnemyPosition()
	{
		return openTiles[FlxG.random.int(0, openTiles.length - 1)];
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
		if (!FlxSpriteUtil.isFlickering(enemy) && enemy.alive)
		{
			enemy.health--;
			enemy.hit();
			if (enemy.health <= 0)
			{
				enemy.kill();
				hud.addScore(1);
				hud.setLeftText(enemies.countLiving());
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
			playerHitSound.play();
			hud.hit();
			player.health--;
			FlxSpriteUtil.flicker(player);
			FlxSpriteUtil.flicker(gun);
			if (player.health <= 0)
			{
				gameOver();
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

	function resetGunPickup()
	{
		var pos:FlxPoint = getNewEnemyPosition();
		gunPickup.revive();
		gunPickup.init(pos.x, pos.y, (FlxG.random.float() < 0.5) ? GunType.MACHINEGUN : GunType.SHOTGUN);
		gunPickupTimer = 0;
		gunPickupTimeLimit = FlxG.random.int(30, 75);
	}

	function pickupGun(player:Player, gunpickup:GunPickup)
	{
		gunPickupSound.play();
		remove(gun);
		gun = gunpickup.getGun();
		add(gun);
		hasPickup = true;
		gunPickupUsageTimer = 0;
		gunpickup.kill();
	}

	function endGunPickup()
	{
		remove(gun);
		gun = new Pistol(GUNRADIUS, player, bullets);
		add(gun);
		gunPickupUsageTimer = 0;
		gunPickupTimer = 0;
		hasPickup = false;
	}

	function gameOver()
	{
		player.kill();
		gun.kill();
		hud.kill();
		goHud.revive();
		goHud.setData(hud.getScore(), wave);

		if (_gameSave.data.highscore == null || _gameSave.data.highscore < hud.getScore())
		{
			_gameSave.data.highscore = hud.getScore();
			_gameSave.flush();
		}
	}
}

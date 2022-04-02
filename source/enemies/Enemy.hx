package enemies;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import guns.EnemyBullet;

class Enemy extends FlxSprite
{
	static var FLICKERTIMER:Float = 1;
	static var THINKTIMELIMIT:Float = 0.5;
	static var MOVETOPLAYERWEIGHT:Float = 0.45;

	public var seesPlayer:Bool = false;
	public var playerPosition:FlxPoint;
	public var bullets:FlxTypedGroup<EnemyBullet>;

	var thinkTimer:Float = 0;
	var shootTimeLimit:Float;
	var shootTimer:Float = 0;
	var speed:Float;
	var bulletSpeed:Float;

	public override function new(bullets:FlxTypedGroup<EnemyBullet>, x:Float, y:Float, bulletSpeed:Float, health:Int)
	{
		super(x, y);
		playerPosition = new FlxPoint(0, 0);
		this.bullets = bullets;
		this.bulletSpeed = bulletSpeed;
		this.health = health;
	}

	public override function update(elapsed:Float)
	{
		think(elapsed);
		super.update(elapsed);
	}

	function think(elapsed:Float) {}

	function moveRandomly()
	{
		var moveDirection:Float = FlxG.random.int(0, 12) * 30;

		velocity.set(speed, 0);
		velocity.rotate(FlxPoint.weak(), moveDirection);
	}

	function shoot()
	{
		var eb:EnemyBullet = bullets.recycle();
		eb.init(x, y, bulletSpeed, playerPosition);
	}
}

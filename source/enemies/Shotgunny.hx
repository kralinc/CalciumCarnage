package enemies;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxVelocity;
import flixel.util.FlxColor;
import guns.EnemyBullet;

class ShotGunny extends Enemy
{
	public override function new(bullets:FlxTypedGroup<EnemyBullet>, x:Float, y:Float, shootTimeLimit:Float, speed:Float)
	{
		super(bullets, x, y, 340, 4);
		this.shootTimeLimit = shootTimeLimit;
		this.speed = speed;
		moveToPlayerWeight = 0.99;
		loadGraphic(AssetPaths.shotgunny__png);
	}

	override function think(elapsed:Float)
	{
		if (thinkTimer >= Enemy.THINKTIMELIMIT)
		{
			if (seesPlayer)
			{
				if (shootTimer >= shootTimeLimit)
				{
					shoot();
					shootTimer = 0;
				}

				if (Math.random() < moveToPlayerWeight)
				{
					FlxVelocity.moveTowardsPoint(this, playerPosition, Std.int(speed));
				}
				else
				{
					moveRandomly();
				}
			}
			else
			{
				moveRandomly();
			}
			thinkTimer = 0;
		}
		else
		{
			thinkTimer += elapsed;
			shootTimer += elapsed;
		}
	}

	override function shoot()
	{
		var bulletSize:Int = 10;
		var eb:EnemyBullet;
		var midpoint:FlxPoint = FlxPoint.weak().copyFrom(getMidpoint());
		for (i in -2...2)
		{
			var shootDirection:FlxPoint = FlxPoint.weak().copyFrom(playerPosition);
			shootDirection.rotate(FlxPoint.weak().copyFrom(midpoint), (i * 0.2) * 180 / Math.PI);
			eb = bullets.recycle();
			eb.init(x, y, bulletSize, bulletSize, bulletSpeed, shootDirection);
		}
	}
}

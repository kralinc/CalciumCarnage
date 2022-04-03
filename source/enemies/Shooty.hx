package enemies;

import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.math.FlxVelocity;
import guns.EnemyBullet;

class Shooty extends Enemy
{
	public override function new(bullets:FlxTypedGroup<EnemyBullet>, x:Float, y:Float, shootTimeLimit:Float, speed:Float)
	{
		super(bullets, x, y, 200, 2);
		this.shootTimeLimit = shootTimeLimit;
		this.speed = speed;
		loadGraphic(AssetPaths.shooty__png);
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
		super.shoot();
		var eb:EnemyBullet = bullets.recycle();
		var midpoint:FlxPoint = FlxPoint.weak().copyFrom(getMidpoint());
		eb.init(midpoint.x, midpoint.y, 16, 16, bulletSpeed, playerPosition);
	}
}

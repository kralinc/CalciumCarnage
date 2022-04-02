package enemies;

import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.math.FlxVelocity;
import flixel.util.FlxColor;
import guns.EnemyBullet;

class RapidGunny extends Enemy
{
	var bulletsInBurst:Int = 10;
	var bulletsShot:Int = 0;

	public override function new(bullets:FlxTypedGroup<EnemyBullet>, x:Float, y:Float, shootTimeLimit:Float, speed:Float)
	{
		super(bullets, x, y, 410, 1);
		this.shootTimeLimit = shootTimeLimit;
		this.speed = speed;
		thinkTimer = 0.25;
		moveToPlayerWeight = 0.5;
		makeGraphic(16, 16, FlxColor.GREEN);
	}

	override function think(elapsed:Float)
	{
		if (thinkTimer >= Enemy.THINKTIMELIMIT)
		{
			if (seesPlayer)
			{
				if (shootTimer >= shootTimeLimit && bulletsShot < bulletsInBurst)
				{
					shoot();
					shootTimer = shootTimeLimit - 0.05;
					bulletsShot++;
				}
				else if (bulletsShot >= bulletsInBurst)
				{
					shootTimer = 0;
					bulletsShot = 0;
				}

				if (Math.random() < moveToPlayerWeight)
				{
					FlxVelocity.moveTowardsPoint(this, playerPosition, Std.int(speed / 2));
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
		var eb:EnemyBullet = bullets.recycle();
		eb.init(x, y, 8, 8, bulletSpeed, playerPosition);
	}
}

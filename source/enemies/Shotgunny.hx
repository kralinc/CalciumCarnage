package enemies;

import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
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
		makeGraphic(16, 16, FlxColor.YELLOW);
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
		var angleToPlayer:Float = Math.atan2(playerPosition.y - y, playerPosition.x - x);
		var playerAngleLeft:FlxPoint = new FlxPoint(Math.cos(angleToPlayer - 0.2), Math.sin(angleToPlayer - 0.2));
		var playerAngleRight:FlxPoint = new FlxPoint(Math.cos(angleToPlayer + 0.2), Math.sin(angleToPlayer + 0.2));
		var eb:EnemyBullet = bullets.recycle();
		eb.init(x, y, bulletSize, bulletSize, bulletSpeed, playerPosition);
		eb = bullets.recycle();
		eb.init(x, y, bulletSize, bulletSize, bulletSpeed, playerAngleLeft);
		eb = bullets.recycle();
		eb.init(x, y, bulletSize, bulletSize, bulletSpeed, playerAngleRight);
	}
}

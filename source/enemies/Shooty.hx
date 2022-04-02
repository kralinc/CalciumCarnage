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
		super(bullets, x, y, 375, 2);
		this.shootTimeLimit = shootTimeLimit;
		this.speed = speed;
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

				if (Math.random() < Enemy.MOVETOPLAYERWEIGHT)
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
}

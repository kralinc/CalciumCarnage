package guns;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import guns.Bullet.BulletOwner;

class Shotgun extends Gun
{
	public override function new(radius:Float, center:FlxSprite, bullets:FlxTypedGroup<Bullet>)
	{
		super(0, center, bullets, 0.5, 400, 20, 15);
		loadGraphic(AssetPaths.shotgun__png);
	}

	public override function shoot()
	{
		FlxG.camera.shake(0.008, 0.05);
		var b:Bullet;
		for (i in -3...3)
		{
			var vx:Float = bulletVelocity * Math.cos(gunAngle + (i * 0.25));
			var vy:Float = bulletVelocity * Math.sin(gunAngle + (i * 0.25));
			var shootDirection:FlxPoint = FlxPoint.weak(vx, vy);
			b = bullets.recycle();
			b.init(x, y, shootDirection, BulletOwner.PLAYER);
		}
	}
}

package guns;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import guns.Bullet.BulletOwner;

class MachineGun extends Gun
{
	public override function new(radius:Float, center:FlxSprite, bullets:FlxTypedGroup<Bullet>)
	{
		super(0, center, bullets, 0.1, 400, 30, 12);
		loadGraphic(AssetPaths.bangbang__png);
	}

	public override function shoot()
	{
		FlxG.camera.shake(0.005, 0.05);
		var vx:Float = bulletVelocity * Math.cos(gunAngle);
		var vy:Float = bulletVelocity * Math.sin(gunAngle);
		var boolet:Bullet = new Bullet(x, y, new FlxPoint(vx, vy), BulletOwner.PLAYER);
		bullets.add(boolet);
	}
}

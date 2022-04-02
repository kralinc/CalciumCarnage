package guns;

import flixel.math.FlxPoint;
import guns.Bullet.BulletOwner;

class Pistol extends Gun
{
	public override function shoot()
	{
		var vx:Float = bulletVelocity * Math.cos(gunAngle);
		var vy:Float = bulletVelocity * Math.sin(gunAngle);
		// var boolet:Bullet = new Bullet(x, y, new FlxPoint(vx, vy), BulletOwner.PLAYER);
		var b:Bullet = bullets.recycle();
		b.init(x, y, new FlxPoint(vx, vy), BulletOwner.PLAYER);
	}
}

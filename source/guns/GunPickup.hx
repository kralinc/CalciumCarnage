package guns;

import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxSplash;
import flixel.util.FlxColor;

class GunType
{
	public static var PISTOL:Int = 1;
	public static var MACHINEGUN:Int = 2;
	public static var SHOTGUN:Int = 3;
}

class GunPickup extends FlxSprite
{
	public var gun:Int;

	var gunCenter:FlxSprite;
	var bullets:FlxTypedGroup<Bullet>;

	public override function new(gunCenter:FlxSprite, bullets:FlxTypedGroup<Bullet>)
	{
		super(0, 0);
		this.gunCenter = gunCenter;
		this.bullets = bullets;
		kill();
	}

	public function init(x:Float, y:Float, gun:Int)
	{
		setPosition(x, y);
		this.gun = gun;
		makeGraphic(16, 16, FlxColor.CYAN);
	}

	public function getGun():Gun
	{
		if (gun == GunType.PISTOL)
		{
			return new Pistol(PlayState.GUNRADIUS, gunCenter, bullets);
		}
		else if (gun == GunType.MACHINEGUN)
		{
			return new MachineGun(PlayState.GUNRADIUS, gunCenter, bullets);
		}
		else if (gun == GunType.SHOTGUN) {}

		return null;
	}
}

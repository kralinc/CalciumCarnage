package guns;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.mouse.FlxMouse;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.util.FlxColor;

class Gun extends FlxSprite
{
	var bullets:FlxTypedGroup<Bullet>;
	var center:FlxSprite;
	var radius:Float;
	var delay:Float;
	var bulletVelocity:Float;
	var gunAngle:Float;
	var shootTimer:Float;
	var playerGunSound:FlxSound;

	public override function new(radius:Float, center:FlxSprite, bullets:FlxTypedGroup<Bullet>, delay:Float, bulletVelocity:Float, ?width:Int = 20,
			?height:Int = 10)
	{
		super(0, 0);
		this.center = center;
		this.bullets = bullets;
		this.radius = radius;
		this.delay = delay;
		this.bulletVelocity = bulletVelocity;
		playerGunSound = FlxG.sound.load(AssetPaths.gun__wav);
		makeGraphic(width, height, FlxColor.RED);
	}

	override function update(elapsed:Float)
	{
		setRotation();
		if (FlxG.mouse.justPressed)
		{
			shootTimer = delay;
		}
		if (FlxG.mouse.pressed)
		{
			shootTimer += elapsed;
			if (shootTimer >= delay)
			{
				playerGunSound.stop();
				shoot();
				playerGunSound.play();
				shootTimer = 0;
			}
		}
		super.update(elapsed);
	}

	function setRotation()
	{
		var y:Float;
		var x:Float;
		var mousePos:FlxPoint = FlxG.mouse.getPosition();
		x = mousePos.x - center.x;
		y = mousePos.y - center.y;
		angle = Math.atan2(y, x) * 180 / Math.PI;
		gunAngle = Math.atan2(y, x);
		x = center.x + radius * Math.cos(gunAngle);
		y = center.y + radius * Math.sin(gunAngle);
		setPosition(x, y);
	}

	public function shoot() {}
}

package guns;

import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

class BulletOwner
{
	public static var PLAYER:String = "PLAYER";
	public static var ENEMY:String = "ENEMY";
}

class Bullet extends FlxSprite
{
	public var owner:String;

	var deathCounter:Float = 0;

	static var DEATH_TIMER:Float = 3;

	public override function new(x:Float, y:Float, velocity:FlxPoint, owner:String)
	{
		super(x, y);
		this.velocity = velocity;
		this.owner = owner;
		makeGraphic(8, 8, FlxColor.WHITE);
	}

	public function init(x:Float, y:Float, velocity:FlxPoint, owner:String)
	{
		setPosition(x, y);
		this.velocity = velocity;
		this.owner = owner;
		deathCounter = 0;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		deathCounter += elapsed;
		if (deathCounter >= DEATH_TIMER && !isOnScreen())
		{
			kill();
		}
	}
}

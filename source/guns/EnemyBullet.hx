package guns;

import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.math.FlxVelocity;
import flixel.util.FlxColor;

class EnemyBullet extends FlxSprite
{
	public override function new()
	{
		super(0, 0);
		makeGraphic(16, 16, FlxColor.RED);
		offset = new FlxPoint(8, 8);
	}

	public function init(x:Float, y:Float, width:Int, height:Int, speed:Float, target:FlxPoint)
	{
		setGraphicSize(width, height);
		setSize(width * 0.85, height * 0.85);
		offset.set(width * 0.075, height * 0.075);
		setPosition(x, y);
		FlxVelocity.moveTowardsPoint(this, target, speed);
	}
}

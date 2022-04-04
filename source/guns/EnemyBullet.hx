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
		// makeGraphic(16, 16, FlxColor.RED);
		loadGraphic(AssetPaths.enemybullet__png);
		offset = new FlxPoint(8, 8);
	}

	public function init(x:Float, y:Float, width_:Int, height_:Int, speed:Float, target:FlxPoint)
	{
		setGraphicSize(width_, height_);
		origin.set(0, 0);
		setSize(width_ * 0.70, height_ * 0.70);
		offset.set(width_ * 0.15, height_ * 0.15);
		setPosition(x, y);
		FlxVelocity.moveTowardsPoint(this, target, speed);
	}
}

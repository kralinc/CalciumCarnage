package;

import flixel.FlxG;
import flixel.FlxSprite;

class Player extends FlxSprite
{
	var speed:Float;

	public override function new(x:Float, y:Float, ?speed:Float = 200)
	{
		super(x, y);
		this.speed = speed;
		health = 3;
		loadGraphic(AssetPaths.gaming__png, true, 16, 16);
		animation.add("walk", [1, 0, 2, 0], 15, false);
	}

	override function update(elapsed:Float)
	{
		checkInput();
		super.update(elapsed);
	}

	private function checkInput()
	{
		var vx:Float = 0;
		var vy:Float = 0;

		if (FlxG.keys.anyPressed([UP, W]))
		{
			vy -= 1;
		}
		if (FlxG.keys.anyPressed([DOWN, S]))
		{
			vy += 1;
		}
		if (FlxG.keys.anyPressed([LEFT, A]))
		{
			vx -= 1;
		}
		if (FlxG.keys.anyPressed([RIGHT, D]))
		{
			vx += 1;
		}

		vx *= speed;
		vy *= speed;

		if (vx != 0 || vy != 0)
		{
			vx = speed * (vx / Math.sqrt(vx * vx + vy * vy));
			vy = speed * (vy / Math.sqrt(vx * vx + vy * vy));
			animation.play("walk");
		}

		velocity.set(vx, vy);
	}
}

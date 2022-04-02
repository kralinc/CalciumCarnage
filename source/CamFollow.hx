package;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.math.FlxPoint;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class CamFollow extends FlxObject
{
	var player:Player;

	public override function new(player:Player)
	{
		super(0, 0);
		this.player = player;
	}

	public override function update(elapsed:Float)
	{
		var mousePos:FlxPoint = FlxG.mouse.getPosition();
		FlxTween.tween(this, {x: (mousePos.x + player.x) / 2, y: (mousePos.y + player.y) / 2}, 0.1, {type: FlxTweenType.ONESHOT, ease: FlxEase.sineIn});
		// setPosition((mousePos.x + player.x) / 2, (mousePos.y + player.y) / 2);
	}
}

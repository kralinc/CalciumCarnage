package hud;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tile.FlxBaseTilemap.FlxTilemapDiagonalPolicy;
import flixel.ui.FlxButton;
import openfl.system.System;

class GameOverHud extends FlxTypedGroup<FlxSprite>
{
	var background:FlxSprite;
	var gameOverText:FlxText;
	var waveText:FlxText;
	var scoreText:FlxText;
	var retryButton:FlxButton;
	var quitButton:FlxButton;

	public override function new()
	{
		super();
		background = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xCC000000);
		background.scrollFactor.set(0, 0);

		gameOverText = new FlxText(FlxG.width / 10, FlxG.height / 10, 0, "GAME OVER", 64);
		gameOverText.scrollFactor.set(0, 0);

		retryButton = new FlxButton(FlxG.width / 2, FlxG.height / 2, "Retry", restart);
		retryButton.scrollFactor.set(0, 0);

		quitButton = new FlxButton(retryButton.x, retryButton.y + 15, "Quit", quit);
		quitButton.scrollFactor.set(0, 0);

		add(background);
		add(gameOverText);
		add(retryButton);
		add(quitButton);
	}

	function restart()
	{
		FlxG.switchState(new PlayState());
	}

	function quit()
	{
		System.exit(0);
	}
}

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

		scoreText = new FlxText(FlxG.width / 10, FlxG.height / 3, 0, "Score: NaN", 32);
		scoreText.scrollFactor.set(0, 0);

		waveText = new FlxText(FlxG.width - FlxG.width / 3, scoreText.y, 0, "Wave NaN", 32);
		waveText.scrollFactor.set(0, 0);

		retryButton = new FlxButton(FlxG.width / 3, FlxG.height / 2, "Retry", restart);
		retryButton.scrollFactor.set(0, 0);

		quitButton = new FlxButton(retryButton.x, retryButton.y + 35, "Quit", quit);
		quitButton.scrollFactor.set(0, 0);

		add(background);
		add(gameOverText);
		add(retryButton);
		add(quitButton);
		add(scoreText);
		add(waveText);
	}

	public function setData(score:Int, wave:Int)
	{
		scoreText.text = "Score: " + score;
		waveText.text = "Wave " + wave;
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

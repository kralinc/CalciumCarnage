package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxSave;
import hud.AboutHud;

class MenuState extends FlxState
{
	var _gameSave:FlxSave;
	var aboutHud:AboutHud;
	var title:FlxText;
	var subtitle:FlxText;
	var highScoreText:FlxText;
	var startButton:FlxButton;
	var aboutButton:FlxButton;
	var meText:FlxText;
	var skull:FlxSprite;

	public override function create()
	{
		_gameSave = new FlxSave();
		_gameSave.bind("highscore");
		if (_gameSave.data.highscore == null)
		{
			_gameSave.data.highscore = 0;
			_gameSave.flush();
		}

		aboutHud = new AboutHud();
		aboutHud.kill();
		title = new FlxText(FlxG.width / 10, FlxG.height / 10, 0, "CALCIUM CARNAGE", 42);
		subtitle = new FlxText(FlxG.width / 8, title.y + 55, 0, "Defend your Bones!", 32);
		skull = new FlxSprite(FlxG.width / 2.25, subtitle.y + 75).loadGraphic(AssetPaths.lives__png);
		skull.setGraphicSize(64, 64);
		highScoreText = new FlxText(FlxG.width / 4, skull.y + skull.height + 30, 0, "High Score: " + _gameSave.data.highscore, 32);
		startButton = new FlxButton(FlxG.width / 2.5, FlxG.height / 1.5, "Start!", start);
		aboutButton = new FlxButton(startButton.x, startButton.y + 35, "About", about);
		meText = new FlxText(0, FlxG.height - 16, "Ludum Dare 50 - 2022 Cactus Dan  -  https://kralinc.github.io - https://cactusdan.itch.io");

		add(title);
		add(subtitle);
		add(startButton);
		add(aboutButton);
		add(skull);
		add(highScoreText);
		add(meText);
		add(aboutHud);
		super.create();
		if (FlxG.sound.music == null)
		{
			FlxG.sound.playMusic(AssetPaths.savethecity__ogg, 0.8, true);
		}
	}

	public override function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	function start()
	{
		FlxG.switchState(new PlayState());
	}

	function about()
	{
		aboutHud.revive();
	}
}

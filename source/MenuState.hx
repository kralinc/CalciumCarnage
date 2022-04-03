package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import hud.AboutHud;

class MenuState extends FlxState
{
	var aboutHud:AboutHud;
	var title:FlxText;
	var startButton:FlxButton;
	var aboutButton:FlxButton;

	public override function create()
	{
		aboutHud = new AboutHud();
		aboutHud.kill();
		title = new FlxText(FlxG.width / 10, FlxG.height / 10, 0, "CALCIUM CARNAGE", 42);
		startButton = new FlxButton(FlxG.width / 2.5, FlxG.height / 2, "Start!", start);
		aboutButton = new FlxButton(startButton.x, startButton.y + 35, "About", about);

		add(title);
		add(startButton);
		add(aboutButton);
		add(aboutHud);
		super.create();
		// if (FlxG.sound.music == null)
		// {
		FlxG.sound.playMusic(AssetPaths.savethecity__wav, 1, true);
		// }
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

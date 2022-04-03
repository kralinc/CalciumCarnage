package hud;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;

class AboutHud extends FlxTypedGroup<FlxSprite>
{
	var background:FlxSprite;
	var resourcesTitle:FlxText;
	var resources:FlxText;
	var controlsTitle:FlxText;
	var controls:FlxText;
	var backButton:FlxButton;

	public override function new()
	{
		super();
		background = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xff000000);
		resourcesTitle = new FlxText(FlxG.width / 10, 0, 0, "Resources Used", 16);
		resources = new FlxText(resourcesTitle.x, resourcesTitle.y + 35, FlxG.width * 0.4, "HaxeFlixel: haxeflixel.com\n
            \nHaxeFlixel RPG Tutorial: haxeflixel.com\n
            \nLeshy SFMaker: www.leshylabs.com\n
            \nGIMP: gimp.org\n
            \nAudacity: audacityteam.org\n", 12);

		controlsTitle = new FlxText(FlxG.width / 2, 0, 0, "Controls", 16);
		controls = new FlxText(controlsTitle.x, controlsTitle.y + 35, 0, "Mouse Pointer: Aim\n
        \nLeft Mouse: Shoot\n
        \nWASD/Arrow Keys:Move", 12);

		backButton = new FlxButton(FlxG.width / 2.5, FlxG.height * 0.9, "Menu", menu);

		add(background);
		add(resourcesTitle);
		add(resources);
		add(controlsTitle);
		add(controls);
		add(backButton);
	}

	function menu()
	{
		kill();
	}
}

package hud;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class Hud extends FlxTypedGroup<FlxSprite>
{
	var player:Player;
	var background:FlxSprite;
	var livesSprite:FlxSprite;
	var livesCounter:FlxText;
	var scoreSprite:FlxSprite;
	var scoreCounter:FlxText;
	var waveText:FlxText;
	var leftText:FlxText;

	var score:Int;

	public override function new(player_:Player, ?textSize:Int = 32, ?spriteSize:Int = 32)
	{
		super();

		player = player_;
		score = 0;

		// Transparent black
		background = new FlxSprite().makeGraphic(FlxG.width, Std.int(FlxG.height / 10), 0x55ffffff);
		background.color = 0x000000;
		background.scrollFactor.set(0, 0);

		var spriteHeight:Float = (background.height - spriteSize) / 2;
		// var textHeight:Float = (background.height - textSize) / 2;
		var textHeight:Float = 0;
		var textOffset:Float = spriteSize / 2;

		livesSprite = makeSprite(livesSprite, AssetPaths.lives__png, FlxG.width / 100, spriteHeight, spriteSize);
		livesCounter = new FlxText(livesSprite.x + livesSprite.width + textOffset, textHeight, 0, "" + player.health, textSize);
		livesCounter.scrollFactor.set(0, 0);

		scoreSprite = makeSprite(scoreSprite, AssetPaths.score__png, FlxG.width - spriteSize - (4 * textSize) - textOffset, spriteHeight, spriteSize);
		scoreCounter = new FlxText(scoreSprite.x + scoreSprite.width + textOffset, textHeight, 0, "" + score, textSize);
		scoreCounter.scrollFactor.set(0, 0);

		waveText = new FlxText(livesCounter.x + livesCounter.fieldWidth + 2 * textOffset, textHeight, 0, "", textSize);
		waveText.scrollFactor.set(0, 0);

		leftText = new FlxText(waveText.x + 11 * textOffset, textHeight, 0, "", textSize);
		leftText.scrollFactor.set(0, 0);

		add(background);
		add(livesCounter);
		add(livesSprite);
		add(scoreCounter);
		add(scoreSprite);
		add(waveText);
		add(leftText);
	}

	override public function update(elapsed:Float)
	{
		setLivesText();
	}

	private function makeSprite(sprite:FlxSprite, assetPath:String, spriteX:Float, spriteHeight:Float, spriteSize:Int)
	{
		sprite = new FlxSprite(0, 0, assetPath);
		sprite.setGraphicSize(spriteSize, spriteSize);
		sprite.updateHitbox();
		sprite.setPosition(spriteX, spriteHeight);
		sprite.scrollFactor.set(0, 0);
		return sprite;
	}

	public function addScore(score:Int)
	{
		this.score += score;
		scoreCounter.text = "" + this.score;
	}

	public function getScore()
	{
		return score;
	}

	public function setLivesText()
	{
		livesCounter.text = "" + player.health;
	}

	public function setWaveText(wave:Int)
	{
		waveText.text = "Wave " + wave;
	}

	public function setLeftText(left:Int)
	{
		leftText.text = "Left: " + left;
	}

	public function hit()
	{
		background.color = 0xff0000;
		FlxTween.tween(background, {color: 0x000000}, 0.33);
	}
}

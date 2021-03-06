package enemies;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import guns.EnemyBullet;

using flixel.util.FlxSpriteUtil;

class Enemy extends FlxSprite
{
	static var FLICKERTIMER:Float = 1;
	static var THINKTIMELIMIT:Float = 0.5;
	static var SHOOTSOUND:FlxSound;
	static var SHOOTSOOUND2:FlxSound;
	static var DIESOUND:FlxSound;
	static var HITSOUND:FlxSound;

	public var seesPlayer:Bool = false;
	public var playerPosition:FlxPoint;
	public var bullets:FlxTypedGroup<EnemyBullet>;

	var healthBar:FlxSprite;
	var thinkTimer:Float = 0;
	var shootTimeLimit:Float;
	var shootTimer:Float = 0;
	var speed:Float;
	var bulletSpeed:Float;
	var maxHealth:Int;
	var moveToPlayerWeight:Float = 0.45;

	public override function new(bullets:FlxTypedGroup<EnemyBullet>, x:Float, y:Float, bulletSpeed:Float, health:Int)
	{
		super(x, y);
		playerPosition = new FlxPoint(0, 0);
		this.bullets = bullets;
		this.bulletSpeed = bulletSpeed;
		this.health = health;
		maxHealth = health;
		this.flicker(FLICKERTIMER, 0.05, true);
		SHOOTSOUND = FlxG.sound.load(AssetPaths.enemygun__wav);
		SHOOTSOOUND2 = FlxG.sound.load(AssetPaths.enemygunb__wav);
		HITSOUND = FlxG.sound.load(AssetPaths.enemyhit__wav);
		DIESOUND = FlxG.sound.load(AssetPaths.enemydie__wav);
	}

	public override function update(elapsed:Float)
	{
		if (!this.isFlickering() && alive)
		{
			think(elapsed);
		}
		super.update(elapsed);
	}

	public override function kill()
	{
		alive = false;
		DIESOUND.play();

		FlxTween.tween(this, {alpha: 0, y: y - 16, angle: 90}, 0.22, {ease: FlxEase.bounceOut, onComplete: finishKill});
	}

	function finishKill(_)
	{
		exists = false;
	}

	public function hit()
	{
		color = 0xff0000;
		FlxTween.tween(this, {color: 0xffffff}, 0.33);
		HITSOUND.stop();
		HITSOUND.play();
	}

	function think(elapsed:Float) {}

	function moveRandomly()
	{
		var moveDirection:Float = FlxG.random.int(0, 12) * 30;

		velocity.set(speed, 0);
		velocity.rotate(FlxPoint.weak(), moveDirection);
	}

	function playShootSound()
	{
		(FlxG.random.float() < 0.5) ? SHOOTSOOUND2.play() : SHOOTSOUND.play();
	}

	function shoot()
	{
		playShootSound();
	}
}

package model;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.system.FlxSound;
import model.Bullet;

/**
 * ...
 * @author Oelson TCS
 */
class Ship extends FlxSpriteGroup
{
	
	public var rateOfFire:Float = 1;
	public var speed:Float = .1;
	public var sprite:FlxSprite;
	public var sndBullet:FlxSound;
	

	public function new() 
	{
		super();
		sndBullet = FlxG.sound.load(AssetPaths.shot1__wav);
	}
	
	public function fire(speed:Float, owner:String)
	{
		var bullet:Bullet = Registry.bulletPool.recycle(Bullet, bulletFactory);
		bullet.owner = owner;
		bullet.x = sprite.x - this.x + sprite.width / 2 - bullet.width / 2;
		bullet.y = sprite.y - this.y + sprite.height / 2 - bullet.height / 2;
		bullet.speed = speed;
		bullet.angle = sprite.angle;
		bullet.velocity.set(Math.cos((bullet.angle-90) * Math.PI / 180) * speed, Math.sin((bullet.angle-90) * Math.PI / 180) * speed);
		trace(Registry.bulletPool.length);
		sndBullet.play(true);
	}
	
	function bulletFactory():Bullet
	{
		trace("Bullet Factory");
		return new Bullet();
	}
	
	override public function kill():Void 
	{
		trace("killShip");
		super.kill();
	}
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
	}
}
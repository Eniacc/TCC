package model;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import playStateFolder.Bullet;

/**
 * ...
 * @author Oelson TCS
 */
class Ship extends FlxSpriteGroup
{
	
	public var rateOfFire:Float = 1;
	public var speed:Float = .1;
	public var sprite:FlxSprite;
	public var bullets:FlxTypedSpriteGroup<Bullet>;
	

	public function new() 
	{
		super();
		bullets = new FlxTypedSpriteGroup<Bullet>();
		add(bullets);
	}
	
	public function fire(speed:Float)
	{
		var bullet:Bullet = bullets.recycle(Bullet, bulletFactory);
		bullet.x = sprite.x - this.x + sprite.width / 2 - bullet.width / 2;
		bullet.y = sprite.y - this.y + sprite.height / 2 - bullet.height / 2;
		bullet.speed = speed;
		bullet.angle = sprite.angle;
		bullet.velocity.set(Math.cos((bullet.angle-90) * Math.PI / 180) * speed, Math.sin((bullet.angle-90) * Math.PI / 180) * speed);
		//bullet.setRotation(sprite.angle);
		add(bullet);
		trace(bullets.length, sprite.angle, speed);
	}
	
	function bulletFactory():Bullet
	{
		return new Bullet();
	}
	
	public function move()
	{
		
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
	}
}
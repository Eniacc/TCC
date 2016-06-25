package model;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;

/**
 * ...
 * @author Oelson TCS
 */
class Ship extends FlxSpriteGroup
{
	
	public var rateOfFire:Float = 1;
	public var firing:Bool = false;
	public var speed:Float = 10;
	public var sprite:FlxSprite;

	public function new() 
	{
		super();
	}
	
	public function atira()
	{
		
	}
	
	public function move()
	{
		
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (firing) atira();
		super.update(elapsed);
	}
}
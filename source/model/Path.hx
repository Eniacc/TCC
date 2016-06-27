package model;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;

/**
 * ...
 * @author Oelson TCS
 */
class Path extends FlxTypedSpriteGroup<Waypoint>
{
	public var spriteURL:String = "";
	
	public function new()
	{
		super();
	}
}
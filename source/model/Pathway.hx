package model;

import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.util.FlxTimer;
import haxe.Constraints.Function;
import haxe.Timer;

/**
 * ...
 * @author Oelson TCS
 */
class Pathway extends FlxTypedSpriteGroup<Waypoint>
{
	public var spriteURL:String = "";
	
	private var callbackSpawn:Function;
	
	public function new()
	{
		super();
	}
	
	public function spawnBots(callbackSpawn:Function)
	{
		this.callbackSpawn = callbackSpawn;
		
		callbackSpawn(this);
		
		if (getFirstAlive().numShips > 1)
		{
			var timer:FlxTimer = new FlxTimer();
			timer.start(getFirstAlive().interval, spawn, getFirstAlive().numShips - 1);
		}
	}
	private function spawn(timer:FlxTimer)
	{
		callbackSpawn(this);
	}
}
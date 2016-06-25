package model;
import flixel.FlxBasic;
import flixel.FlxSprite;

/**
 * ...
 * @author Oelson TCS
 */
class Waypoint extends FlxSprite
{

	//public var x:Float;
	//public var y:Float;
	public var xPer:Float;
	public var yPer:Float;
	public var rotation:Float;
	public var rateOfFire:Float;
	public var fire:Bool;
	public var speed:Float;
	public var wait:Float;
	
	//if Starter
	public var numShips:Int;
	public var interval:Float;
	
	public function new() 
	{
		super();
		loadGraphic(AssetPaths.pin__png, true, 50, 50);
		animation.add('normal', [0], 1, false);
		animation.add('selected', [1], 1, false);
		animation.add('starter', [2], 1, false);
		
		animation.play('starter');
	}
}
package model;
import flixel.FlxBasic;
import flixel.FlxSprite;

/**
 * ...
 * @author Oelson TCS
 */
class Waypoint extends FlxSprite
{
	public static var defaultXPer:Float = 0;
	public static var defaultYPer:Float = 0;
	public static var defaultrotation:Float = 0;
	public static var defaultRateOfFire:Float = 0;
	public static var defaultSpeed:Float = .01;
	public static var defaultWait:Float = .01;
	public static var defaultNumShip:Int = 1;
	public static var defaultInterval:Float = .01;
	
	@:isVar public var xPer(get, set):Float;
	@:isVar public var yPer(get, set):Float;
	@:isVar public var rotation(get, set):Float;
	@:isVar public var rateOfFire(get, set):Float;
	@:isVar public var speed(get, set):Float;
	@:isVar public var wait(get, set):Float;
	
	//if Starter
	@:isVar public var numShips(get, set):Int;
	@:isVar public var interval(get, set):Float;
	
	public function new() 
	{
		super();
		loadGraphic(AssetPaths.pin__png, true, 50, 50);
		animation.add('normal', [0], 1, false);
		animation.add('selected', [1], 1, false);
		animation.add('starter', [2], 1, false);

		animation.play('starter');
	}
	
	function get_xPer():Float 
	{
		return Math.isNaN(xPer) ? defaultXPer : xPer;
	}
	
	function set_xPer(value:Float):Float 
	{
		return xPer = value;
	}
	
	function get_yPer():Float 
	{
		return Math.isNaN(yPer) ? defaultYPer : yPer;
	}
	
	function set_yPer(value:Float):Float 
	{
		return yPer = value;
	}
	
	function get_rotation():Float 
	{
		return Math.isNaN(rotation) ? defaultrotation: rotation;
	}
	
	function set_rotation(value:Float):Float 
	{
		return rotation = value;
	}
	
	function get_rateOfFire():Float 
	{
		return Math.isNaN(rateOfFire) ? defaultRateOfFire : rateOfFire;
	}
	
	function set_rateOfFire(value:Float):Float 
	{
		return rateOfFire = value;
	}
	
	function get_speed():Float 
	{
		return Math.isNaN(speed) ? defaultSpeed : speed;
	}
	
	function set_speed(value:Float):Float 
	{
		return speed = value;
	}
	
	function get_wait():Float 
	{
		return Math.isNaN(wait) ? defaultWait : wait;
	}
	
	function set_wait(value:Float):Float 
	{
		return wait = value;
	}
	
	function get_numShips():Int 
	{
		return numShips;
	}
	
	function set_numShips(value:Int):Int 
	{
		return numShips = value;
	}
	
	function get_interval():Float 
	{
		return Math.isNaN(interval) ? defaultInterval : interval;
	}
	
	function set_interval(value:Float):Float 
	{
		return interval = value;
	}
}
package model;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxRect;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;

/**
 * ...
 * @author Oelson TCS
 */
class Bot extends Ship
{
	public var waypoints:FlxTypedGroup<Waypoint>;
	private var currentWaypoint:Int = 0;
	public var wait:Float;
	public var reference:FlxRect;
	
	var debug:FlxText = new FlxText();

	//public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	//{
		//super(X, Y, SimpleGraphic);
		//loadGraphic(AssetPaths.Bot__png);
	public function new()
	{
		super();
		sprite = new FlxSprite(0, 0, AssetPaths.Bot__png);
		//sprite = new FlxSprite(0, 0);
		add(sprite);
		waypoints = new FlxTypedGroup<Waypoint>();
		//debug.color = 0x0000FF;
		debug.size = 16;
		add(debug);
	}
	
	public function awake()
	{
		gotoWaypoint(0);
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		//sprite.color = 0xFF0000;
	}
	
	function gotoWaypoint(currentWaypoint:Int) 
	{
		var wp:Waypoint = waypoints.members[currentWaypoint];
		//x = wp.x;
		//y = wp.y;
		//angle = wp.rotation;
		//rateOfFire = wp.rateOfFire;
		//firing = wp.fire;
		//speed = wp.speed;// * FlxG.updateFramerate;
		//wait = wp.wait;
		//speed / getDistance(wp.x, wp.y)
		//debug.text = (Std.string(speed) + " / " + Std.string(getDistance(wp.x, wp.y)) + " = " + Std.string(speed / getDistance(wp.x, wp.y)));
		//FlxG.log.add(debug.text);
		//var time:Float = speed / getDistance(wp.x, wp.y);
		//debug.text = "Spd " + Std.string(speed).substr(0, 5) + "\nRot " + Std.string(wp.rotation) + "°\n";
		//trace(wp.x, wp.offsetX);
		var botX:Float = reference.x + wp.xPer * reference.width - sprite.width * .5;
		var botY:Float = reference.y + wp.yPer * reference.height - sprite.height * .5;
		FlxTween.tween(sprite, {x: botX, y: botY , angle: wp.rotation}, speed, {onComplete: getParams});
		//FlxTween.tween(debug, {x: botX, y: botY}, speed);
	}
	
	function getParams(tween:FlxTween) 
	{
		var wp:Waypoint = waypoints.members[currentWaypoint];
		rateOfFire = wp.rateOfFire;
		firing = wp.fire;
		speed = wp.speed; // * FlxG.updateFramerate;
		wait = wp.wait <= 0 ? .01 : wp.wait;
		FlxTween.tween(sprite, { }, wait, { onComplete: nextWaypoint } );
	}
	
	function nextWaypoint(tween:FlxTween) 
	{
		currentWaypoint++;		
		if (currentWaypoint >= waypoints.length) currentWaypoint = 0;
		//FlxG.log.add('Goto Waypoint: ' + currentWaypoint);
		//debug.text = Std.string(currentWaypoint);
		gotoWaypoint(currentWaypoint);
	}
	
	public function setGraphic(sprite:FlxSprite)
	{
		//FlxG.log.add("Set graphic");
		FlxG.log.add("Set graphic"+" "+ sprite.width +" "+ sprite.height);
		this.sprite.pixels = sprite.pixels;
	}
	
	//function getDistance(gx:Int, gy:Int) 
	//{
		//return Math.sqrt(Math.pow(sprite.x - gx, 2) + Math.pow(sprite.y - gy, 2));
	//}
}
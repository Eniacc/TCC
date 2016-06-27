package model;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxRect;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

/**
 * ...
 * @author Oelson TCS
 */
class Bot extends Ship
{
	public var waypoints:FlxTypedGroup<Waypoint>;
	public var reference:FlxRect;
	private var currentWaypoint:Int = 0;
	private var wait:Float;
	
	var timer:FlxTimer;

	public function new()
	{
		super();
		sprite = new FlxSprite(0, 0, AssetPaths.Bot__png);
		add(sprite);
		waypoints = new FlxTypedGroup<Waypoint>();
		
		timer = new FlxTimer();
	}
	
	public function awake()
	{
		gotoWaypoint(0);
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
	}
	
	function gotoWaypoint(currentWaypoint:Int) 
	{
		var wp:Waypoint = waypoints.members[currentWaypoint];
		var botX:Float = reference.x + wp.xPer * reference.width - sprite.width * .5;
		var botY:Float = reference.y + wp.yPer * reference.height - sprite.height * .5;
		FlxTween.tween(sprite, {x: botX, y: botY , angle: wp.rotation}, speed, {onComplete: getParams});
	}
	
	function getParams(tween:FlxTween) 
	{
		var wp:Waypoint = waypoints.members[currentWaypoint];
		rateOfFire = wp.rateOfFire;
		speed = wp.speed; // * FlxG.updateFramerate;
		wait = wp.wait <= 0 ? .01 : wp.wait;
		//if(rateOfFire > 0 ) timer.start(rateOfFire, shoot, 0);
		FlxTween.tween(sprite, { }, wait, { onComplete: nextWaypoint } );
	}
	
	function nextWaypoint(tween:FlxTween) 
	{
		currentWaypoint++;		
		if (currentWaypoint >= waypoints.length) currentWaypoint = 0;
		gotoWaypoint(currentWaypoint);
	}
	
	function shoot(timer:FlxTimer = null) 
	{
		trace('SHOOT');
		fire(50);
	}
	
	public function setGraphic(sprite:FlxSprite)
	{
		FlxG.log.add("Set graphic"+" "+ sprite.width +" "+ sprite.height);
		this.sprite.pixels = sprite.pixels;
	}
	
	override public function kill():Void 
	{
		timer.cancel();
		timer.destroy();
		timer.active = false;
		timer.onComplete = null;
		trace(timer.active);
		super.kill();
	}
	
	//function getDistance(gx:Int, gy:Int) 
	//{
		//return Math.sqrt(Math.pow(sprite.x - gx, 2) + Math.pow(sprite.y - gy, 2));
	//}
}
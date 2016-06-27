package model;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxRect;
import flixel.tweens.FlxTween;
import flixel.tweens.misc.VarTween;
import flixel.util.FlxTimer;
import model.Path;

/**
 * ...
 * @author Oelson TCS
 */
class Bot extends Ship
{
	public var botPath:Path;
	public var reference:FlxRect;
	private var currentWaypoint:Waypoint;
	private var inEditor:Bool;
	
	private var tween:VarTween;
	private var wait:FlxTimer;
	private var shootTimer:FlxTimer;
	
	public var scoreValue:Int = 50;
	private var scoreTimer:FlxTimer;
	
	public function new(inEditor:Bool = false)
	{
		super();
		this.inEditor = inEditor;
		//sprite = new FlxSprite(0, 0, AssetPaths.Bot__png);
		sprite = new FlxSprite(0, 0, AssetPaths.Enemy1__png);
		add(sprite);
		botPath = new Path();
		
		wait = new FlxTimer();
		shootTimer = new FlxTimer();
		scoreTimer = new FlxTimer();
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
	}
	
	public function awake()
	{
		gotoWaypoint(getNextWaypoint(null));
		scoreValue = 50;
		scoreTimer.start(1, function(timer:FlxTimer){scoreValue--; }, scoreValue);
	}
	
	function gotoWaypoint(wp:Waypoint) 
	{
		if (wp == null)
		{
			this.kill();
		}else{
			currentWaypoint = wp;
			var botX:Float = reference.x + wp.xPer * reference.width - sprite.width * .5;
			var botY:Float = reference.y + wp.yPer * reference.height - sprite.height * .5;
			tween = FlxTween.tween(sprite, {x: botX, y: botY , angle: wp.rotation}, speed, {onComplete: getParams});
		}
	}
	
	function getParams(tween:FlxTween) 
	{
		rateOfFire = currentWaypoint.rateOfFire;
		speed = currentWaypoint.speed; // * FlxG.updateFramerate;
		if (rateOfFire > 0) shootTimer.start(rateOfFire, shoot, 0);
		else shootTimer.cancel();
		
		wait.start(currentWaypoint.wait <= 0 ? .01 : currentWaypoint.wait, gotoNextWaypoint);
	}
	
	function gotoNextWaypoint(timer:FlxTimer) 
	{
		gotoWaypoint(getNextWaypoint(currentWaypoint));
	}
	
	function getNextWaypoint(current:Waypoint):Waypoint
	{
		if (current == null) return botPath.getFirstAlive();
		
		var index:Int = botPath.members.indexOf(current) + 1;
		if (index >= botPath.members.length)
		{
			if (inEditor) return botPath.getFirstAlive();
			return null;
		}
		
		var next:Waypoint = botPath.members[index];
		if (next.alive) return next;
		else return getNextWaypoint(next);
	}
	
	function shoot(timer:FlxTimer = null) 
	{
		fire(50, "Enemy");
	}
	
	public function setGraphic(sprite:FlxSprite)
	{
		FlxG.log.add("Set graphic"+" "+ sprite.width +" "+ sprite.height);
		this.sprite.pixels = sprite.pixels;
	}
	
	override public function kill():Void 
	{
		tween.cancel();
		wait.destroy();
		shootTimer.destroy();
		scoreTimer.destroy();
		botPath = null;
		super.kill();
	}
	
	//function getDistance(gx:Int, gy:Int) 
	//{
		//return Math.sqrt(Math.pow(sprite.x - gx, 2) + Math.pow(sprite.y - gy, 2));
	//}
}
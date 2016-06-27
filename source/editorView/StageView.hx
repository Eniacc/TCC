package editorView;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;
import gameView.GameStageView;
import haxe.Constraints.Function;
import lime.graphics.PixelFormat;
import model.Bot;
import model.Path;
import model.Wave;
import model.Waypoint;

/**
 * ...
 * @author Oelson TCS
 */
class StageView extends FlxSpriteGroup
{
	var p:Path = new Path();
	
	var lines:FlxSprite;
	var waypoints:FlxTypedSpriteGroup<Waypoint> = new FlxTypedSpriteGroup<Waypoint>();
	
	var backGround:FlxSprite;
	var gameStage:GameStageView;
	var dif:FlxPoint;
	
	public var selectedWaypoint:Waypoint;
	public var callbackSelected:Function;
	
	var bots:FlxTypedSpriteGroup<Bot> = new FlxTypedSpriteGroup<Bot>();
	
	public function new(?X:Float = 0, ?Y:Float = 0)
	{
		super();
		
		this.x = X;
		this.y = Y;
		
		backGround = new FlxSprite();
		backGround.makeGraphic(Registry.gameWidth, Std.int(Registry.gameHeight - Y * 2), 0xFF000022);
		add(backGround);
		
		gameStage = new GameStageView(.7);
		gameStage.x = (backGround.width - gameStage.width)  / 2;
		gameStage.y = (backGround.height - gameStage.height)  / 2;
		gameStage.showHelp();
		add(gameStage);
		
		lines = new FlxSprite(0, 0);
		lines.makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT);
		add(lines);
		
		add(waypoints);
		add(bots);
		
		dif = new FlxPoint(backGround.x - gameStage.x, backGround.y - gameStage.y);
	}
	
	public function loadPath(p:Path)
	{
		waypoints.clear();
		
		this.p = p;
		for (i in 0...p.members.length)
		{
			var waypoint:Waypoint = p.members[i];
			waypoints.add(waypoint);
		}
	}
	
	override public function update(elapsed:Float):Void
	{
		
		if (FlxG.mouse.overlaps(backGround))
		{
			if (FlxG.mouse.justPressed)
			{
				selectedWaypoint = getOverlap();
				if (selectedWaypoint == null) newWaypoint();
			}
			if (FlxG.mouse.justPressedRight)
			{
				selectedWaypoint = getOverlap();
				if (selectedWaypoint != null) removeWaypoint(selectedWaypoint);
			}
			
			if (FlxG.mouse.pressed && selectedWaypoint != null)
			{
				selectedWaypoint.xPer = getPer(FlxG.mouse.x, FlxG.mouse.y).x;
				selectedWaypoint.yPer = getPer(FlxG.mouse.x, FlxG.mouse.y).y;
				callbackSelected(selectedWaypoint, p.members.indexOf(selectedWaypoint));
			}
		}
		
		for (i in 0...waypoints.length)
		{
			if (i == 0) waypoints.members[i].animation.play('starter');
			else waypoints.members[i].animation.play('normal');
		}
		if(selectedWaypoint != null) selectedWaypoint.animation.play('selected');
		
		connect();
		super.update(elapsed);
	}
	
	function getOverlap():Waypoint
	{
		for (i in 0...waypoints.length)
		{
			if (FlxG.mouse.overlaps(waypoints.members[i]))
			{
				return waypoints.members[i];
			}
		}
		return null;
	}
	
	function newWaypoint() 
	{
		var wp:Waypoint = new Waypoint();
		var point:FlxPoint = getPer(FlxG.mouse.x, FlxG.mouse.y);
		wp.xPer = point.x;
		wp.yPer = point.y;
		wp.rotation = 0;
		wp.speed = 1;
		wp.wait = .1;
		wp.numShips = 1;
		wp.interval = 0;
		p.add(wp);
		
		trace(	"mouseX: "+ FlxG.mouse.x,
				"backGround.x: "+ backGround.x,
				"gameStage.x:"+ gameStage.x,
				"backGround.width: "+ backGround.width,
				"gameStage.width:"+ gameStage.width,
				"wp.xPer: "+wp.xPer,
				"wp.xPer * backGround.width: " + wp.xPer * backGround.width,
				"wp.xPer * gameStage.width: "+wp.xPer * gameStage.width);
		loadPath(p);
		
		callbackSelected(wp, p.members.indexOf(wp));
	}
	
	function removeWaypoint(selectedWaypoint:Waypoint)
	{
		//selectedWaypoint.destroy();
		waypoints.remove(selectedWaypoint, true);
		p.remove(selectedWaypoint, true);
		loadPath(p);
		callbackSelected(null);
	}
	
	function getPer(xPoint:Float = 0, yPoint:Float = 0):FlxPoint
	{
		return new FlxPoint((xPoint - gameStage.x) / gameStage.width, (yPoint - gameStage.y) / gameStage.height);
	}
	
	function connect()
	{
		FlxSpriteUtil.fill(lines, FlxColor.TRANSPARENT);
		for (i in 0...p.members.length)
		{
			var wp:Waypoint = p.members[i];
			var wpx:Float = (wp.xPer * gameStage.width) - dif.x;
			var wpy:Float = (wp.yPer * gameStage.height) - dif.y;
			
			if (i > 0)
			{
				var prevWp:Waypoint  = p.members[i - 1];
				FlxSpriteUtil.drawLine(lines, wpx, wpy, (prevWp.xPer * gameStage.width) - dif.x, (prevWp.yPer * gameStage.height) - dif.y);
			}
			
			waypoints.members[i].x = wpx + backGround.x - wp.width * .5;
			waypoints.members[i].y = wpy + backGround.y - wp.height;
		}
	}
	
	public function test(play:Bool) 
	{
		if (play)
		{
			if (p.length > 0)
			{
				//bots.revive();
				spawn();
				if (p.members[0].numShips > 1)
				{
					var timer:FlxTimer = new FlxTimer();
					timer.start(p.members[0].interval, spawn, p.members[0].numShips - 1);
				}
			}
		}else{
			//bots.kill();
			for (i in 0...bots.length)
			{
				bots.members[i].kill();
				bots.members[i].destroy();
			}
			bots.clear();
		}
	}
	
	function spawn(timer:FlxTimer = null) 
	{
		//var bot:Bot = bots.recycle(Bot, botFactory);
		var bot:Bot = new Bot();
		//bot.setGraphic(selectionView.spriteBox);
		bot.waypoints = p;
		bot.reference = gameStage.getHitbox();// new FlxRect(stage.gameStage.x, stage.gameStage.y, stage.gameStage.width, stage.gameStage.height);
		//trace(bot.reference);
		bot.awake();
		bots.add(bot);
	}
	
	function botFactory() 
	{
		return new Bot();
	}
}
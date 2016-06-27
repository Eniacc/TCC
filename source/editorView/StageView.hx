package editorView;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;
import gameView.GameStageView;
import haxe.Constraints.Function;
import haxe.Timer;
import lime.graphics.PixelFormat;
import model.Bot;
import model.Path;
import model.Wave;
import model.Waypoint;
import model.Bullet;

/**
 * ...
 * @author Oelson TCS
 */
class StageView extends FlxSpriteGroup
{
	var p:Path = new Path();
	
	var lines:FlxSprite;
	
	var backGround:FlxSprite;
	var gameStage:GameStageView;
	var dif:FlxPoint;
	
	public var selectedWaypoint:Waypoint;
	public var callbackSelected:Function;
	
	var bots:FlxTypedSpriteGroup<Bot> = new FlxTypedSpriteGroup<Bot>();
	var timer:Timer;
	
	public function new(?X:Float = 0, ?Y:Float = 0, gameStageScale:Float = 1)
	{
		super();
		this.x = X;
		this.y = Y;
		
		backGround = new FlxSprite();
		backGround.makeGraphic(Registry.gameWidth, Std.int(Registry.gameHeight - Y * 2), 0xFF000022);
		add(backGround);
		
		gameStage = new GameStageView(gameStageScale);
		gameStage.x = (backGround.width - gameStage.width)  / 2;
		gameStage.y = (backGround.height - gameStage.height)  / 2;
		gameStage.showHelp();
		add(gameStage);
		
		lines = new FlxSprite(0, 0);
		lines.makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT);
		add(lines);
		
		add(p);
		add(bots);
		
		Registry.bulletPool = new FlxTypedSpriteGroup<Bullet>();
		add(Registry.bulletPool);
		
		dif = new FlxPoint(backGround.x - gameStage.x, backGround.y - gameStage.y);
	}
	
	public function loadPath(p:Path)
	{
		this.p.forEachAlive(function(wp:Waypoint){
			remove(wp);
		});
		
		this.p = p;
		
		p.forEachAlive(function(wp:Waypoint){
			add(wp);
		});
	}
	
	override public function update(elapsed:Float):Void
	{
		
		if (FlxG.mouse.overlaps(backGround) && bots.countLiving() <= 0)
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
		
		p.forEachAlive(function(wp:Waypoint){
			wp.animation.play('normal');
			wp.visible = bots.countLiving() <= 0;
		});
		if(p.countLiving() > 0) p.getFirstAlive().animation.play('starter');
		if(selectedWaypoint != null) selectedWaypoint.animation.play('selected');
		
		connect();
		super.update(elapsed);
	}
	
	function getOverlap():Waypoint
	{
		var wpOverlap:Waypoint = null;
		
		p.forEachAlive(function(wp:Waypoint)
		{
			if (FlxG.mouse.overlaps(wp))
			{
				wpOverlap = wp;
			}
		});
		return wpOverlap;
	}
	
	function newWaypoint() 
	{
		//var wp:Waypoint = new Waypoint();
		var wp:Waypoint = p.recycle(Waypoint, waypointFactory);
		var point:FlxPoint = getPer(FlxG.mouse.x, FlxG.mouse.y);
		wp.xPer = point.x;
		wp.yPer = point.y;
		wp.rotation = Waypoint.defaultrotation;
		wp.speed = 1;
		wp.wait = Waypoint.defaultWait;
		wp.numShips = Waypoint.defaultNumShip;
		wp.interval = Waypoint.defaultInterval;
		
		trace(	"mouseX: "+ FlxG.mouse.x,
				"backGround.x: "+ backGround.x,
				"gameStage.x:"+ gameStage.x,
				"backGround.width: "+ backGround.width,
				"gameStage.width:"+ gameStage.width,
				"wp.xPer: "+wp.xPer,
				"wp.xPer * backGround.width: " + wp.xPer * backGround.width,
				"wp.xPer * gameStage.width: "+wp.xPer * gameStage.width);
		
		p.members.push(p.members.splice(p.members.indexOf(wp), 1)[0]);
		
		add(wp);
		selectedWaypoint = wp;
		
		callbackSelected(wp, p.members.indexOf(wp));
	}
	
	function waypointFactory():Waypoint 
	{
		trace("USE FACTORY");
		return new Waypoint();
	}
	
	function removeWaypoint(selectedWaypoint:Waypoint)
	{
		selectedWaypoint.kill();
		remove(selectedWaypoint);
		p.members.push(p.members.splice(p.members.indexOf(selectedWaypoint), 1)[0]);
		callbackSelected(null , -1);
	}
	
	function getPer(xPoint:Float = 0, yPoint:Float = 0):FlxPoint
	{
		return new FlxPoint((xPoint - gameStage.x) / gameStage.width, (yPoint - gameStage.y) / gameStage.height);
	}
	
	function connect()
	{
		FlxSpriteUtil.fill(lines, FlxColor.TRANSPARENT);
		var prevWp:Waypoint = null;
		
		p.forEachAlive(function(wp:Waypoint)
		{
			var wpx:Float = (wp.xPer * gameStage.width) - dif.x;
			var wpy:Float = (wp.yPer * gameStage.height) - dif.y;
			
			if (prevWp != null)
			{
				FlxSpriteUtil.drawLine(lines, wpx, wpy, (prevWp.xPer * gameStage.width) - dif.x, (prevWp.yPer * gameStage.height) - dif.y);
			}
			
			wp.x = wpx + backGround.x - wp.width * .5;
			wp.y = wpy + backGround.y - wp.height;
			
			prevWp = wp;
		});
	}
	
	public function test(play:Bool) 
	{
		if (play)
		{
			if (p.countLiving() > 0)
			{
				spawn();
				var numShips:Int = p.getFirstAlive().numShips;
				if (numShips > 1)
				{
					timer = new Timer(Std.int(p.getFirstAlive().interval * 1000));
					timer.run = spawn;
					//timer.start(p.getFirstAlive().interval, spawn, numShips - 1);
				}
			}
		}else{
			if (timer != null) timer.stop();
			bots.forEachAlive(function(bot:Bot){
				bot.kill();
			});
		}
	}
	
	//function spawn(timer:FlxTimer = null) 
	function spawn():Void
	{
		var bot:Bot = bots.recycle(Bot, botFactory);
		//var bot:Bot = new Bot();
		//bot.setGraphic(selectionView.spriteBox);
		bot.speed = .001;
		bot.botPath = p;
		bot.reference = gameStage.getHitbox();// new FlxRect(stage.gameStage.x, stage.gameStage.y, stage.gameStage.width, stage.gameStage.height);
		//trace(bot.reference);
		bot.awake();
		//bots.add(bot);
		
		if (bots.countLiving() >= p.getFirstAlive().numShips && timer != null) timer.stop();
	}
	
	function botFactory() 
	{
		return new Bot(Registry.inEditor);
	}
}
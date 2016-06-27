package gameView;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxRect;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import haxe.Constraints.Function;
import haxe.Timer;
import model.Bot;
import model.Path;
import model.Wave;

/**
 * ...
 * @author Oelson TCS
 */
class GameStageView extends FlxSpriteGroup
{
	private var waves:FlxTypedGroup<Wave>;
	private var currentWave:Int = 0;
	private var timer:Timer;
	public var bots:FlxTypedSpriteGroup<Bot>;
	public var callbackStageComplete:Function;
	public var callbackGameOver:Function;
	
	private var gameArea:FlxSprite;
	//private var offscreen:FlxSprite;
	
	public function new(scale:Float = 1) 
	{
		super();
		
		//offscreen = new FlxSprite();
		//offscreen.makeGraphic(Std.int(Registry.gameWidth), Std.int(Registry.gameHeight), 0xFF000022);
		//add(offscreen);
		
		gameArea = new FlxSprite();
		gameArea.makeGraphic(Std.int(Registry.gameWidth * scale), Std.int(Registry.gameHeight * scale), 0xFF000055);
		gameArea.updateHitbox();
		add(gameArea);
		
		add(Registry.bulletPool);
	}
	
	public function showHelp() 
	{
		var text:FlxText = new FlxText(0, 0, 0, "Game Area");
		text.color = FlxColor.GRAY;
		text.x = gameArea.width / 2 - text.width / 2;
		text.y = gameArea.height - text.height;
		add(text);
	}
	
	public function loadGame()
	{
		waves = Registry.stage;
		bots = new FlxTypedSpriteGroup<Bot>();
		add(bots);
		gameArea.visible = false;
		loadWave(0);
	}
	
	function loadWave(index:Int) 
	{
		currentWave = index;
		trace("CURRENT WAVE", bots.countLiving());
		if (currentWave >= waves.members.length) callbackStageComplete();
		else{
			for (p in waves.members[index])
			{
				spawnPath(p);
			}
		}
	}
	
	private function spawnPath(p:Path) 
	{
		spawnBot(p);
		trace("spawin!11!");
		var numShips:Int = p.getFirstAlive().numShips;
		if (numShips > 1)
		{
			timer = new Timer(Std.int(p.getFirstAlive().interval * 1000));
			timer.run = function spawnBot() {
				var bot:Bot = bots.recycle(Bot, botFactory);
				bot.speed = .001;
				bot.botPath = p;
				bot.reference = this.getHitbox();// new FlxRect(stage.gameStage.x, stage.gameStage.y, stage.gameStage.width, stage.gameStage.height);
				bot.awake();
				
				if (bots.countLiving() >= p.getFirstAlive().numShips && timer != null) timer.stop();
			};
		}
	}
	
	function spawnBot(p:Path=null)
	{
		var bot:Bot = bots.recycle(Bot, botFactory);
		bot.speed = .001;
		bot.botPath = p;
		bot.reference = this.getHitbox();// new FlxRect(stage.gameStage.x, stage.gameStage.y, stage.gameStage.width, stage.gameStage.height);
		bot.awake();
		
		if (bots.countLiving() >= p.getFirstAlive().numShips && timer != null) timer.stop();
	};
	
	function botFactory() 
	{
		return new Bot(Registry.inEditor);
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		if (!Registry.inEditor)
		{
			if(bots.countLiving() <= 0)
			{
				currentWave++;
				loadWave(currentWave);
			}
		}
	}
	
	override public function destroy():Void 
	{
		remove(Registry.bulletPool);
		super.destroy();
	}
}
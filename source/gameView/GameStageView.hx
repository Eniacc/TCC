package gameView;

import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import haxe.Constraints.Function;
import haxe.Timer;
import model.Bot;
import model.Path;
import model.Wave;
import model.Bullet;

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
	private var botArea:FlxSpriteGroup;
	private var totalWaveBots:Int = 0;
	private var totalSpawnedInWave:Int = 0;
	//private var offscreen:FlxSprite;
	
	public function new(scale:Float = 1) 
	{
		super();
		
		gameArea = new FlxSprite();
		gameArea.makeGraphic(Std.int(Registry.gameWidth * scale), Std.int(Registry.gameHeight * scale), 0xFF000055);
		gameArea.updateHitbox();
		add(gameArea);
		
		//var offscreen:FlxSpriteGroup = new FlxSpriteGroup();
		//bulletArea.makeGraphic(Std.int(Registry.gameWidth * scale), Std.int(Registry.gameHeight * scale), FlxColor.TRANSPARENT);
		//offscreen.add(bulletArea);
		//add(offscreen);
		
		trace('inEditor',Registry.inEditor);
		if (!Registry.inEditor)
		{
			botArea = new FlxSpriteGroup();
			add(botArea);
			Registry.bulletPool = new FlxTypedSpriteGroup<Bullet>();
			add(Registry.bulletPool);
		}
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
		botArea.add(bots);
		gameArea.visible = false;
		loadWave(0);
	}
	
	function loadWave(index:Int) 
	{
		totalWaveBots = 0;
		totalSpawnedInWave = 0;
		currentWave = index;
		trace("CURRENT WAVE", currentWave);
		if (currentWave >= waves.members.length) callbackStageComplete();
		else{
			for (p in waves.members[index])
			{
				//currentPath = p;
				totalWaveBots += p.getFirstAlive().numShips;
				//spawnPath(currentPath);
				p.spawnBots(spawnBot);
			}
		}
	}
	
	//private function spawnPath(p:Path) 
	//{
		//spawnBot();
		//trace("spawin!11!");
		//var numShips:Int = p.getFirstAlive().numShips;
		//if (numShips > 1)
		//{
			//timer = new Timer(Std.int(p.getFirstAlive().interval * 1000));
			//timer.run = spawnBot;
			////
			////function spawnBot() {
				////var bot:Bot = bots.recycle(Bot, botFactory);
				////bot.speed = .001;
				////bot.botPath = p;
				////bot.reference = this.getHitbox();// new FlxRect(stage.gameStage.x, stage.gameStage.y, stage.gameStage.width, stage.gameStage.height);
				////bot.awake();
				////
				////p.getFirstAlive().numSpawned++;
				////if (p.getFirstAlive().numSpawned >= p.getFirstAlive().numShips && timer != null) timer.stop();
			////};
		//}
	//}
	
	function spawnBot(p:Path)
	{
		var bot:Bot = bots.recycle(Bot, botFactory);
		bot.speed = .001;
		bot.botPath = p;
		bot.reference = this.getHitbox();// new FlxRect(stage.gameStage.x, stage.gameStage.y, stage.gameStage.width, stage.gameStage.height);
		bot.awake();
		
		totalSpawnedInWave++;
		//currentPath.getFirstAlive().numSpawned++;
		//if (currentPath.getFirstAlive().numSpawned >= currentPath.getFirstAlive().numShips && timer != null) timer.stop();
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
			//Todos criados e todos mortos
			if(totalWaveBots == totalSpawnedInWave && bots.countLiving() <= 0)
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
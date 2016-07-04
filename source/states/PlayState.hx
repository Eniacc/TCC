package states;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.editors.tiled.TiledMap.FlxTiledAsset;
import flixel.effects.particles.FlxParticle;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxTimer;
import gameView.GameStageView;
import model.Bot;
import model.Bullet;
import openfl.display.FPS;
import playStateFolder.HUD;
import playStateFolder.OverlayState;
import playStateFolder.Player;

class PlayState extends FlxState
{
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	
	private var player:Player;
	private var music:FlxSound;
	private var sndExplosion:FlxSound;
	private var countFrame:Float = 0;
	private var backdrop:FlxBackdrop;
	private var health:Int = 3;
	private var enemiesKilled:Int = 0;
	private var hud:HUD;
	private var overlay:OverlayState;
	private var subStateColor:FlxColor;
	private var borderLeft:FlxSprite;
	private var borderRight:FlxSprite;

	private var fps:FPS = new FPS();
	//private var weapon:FlxWeapon = new FlxWeapon("arma", null, Bullet);

	private var _explosionPixel:FlxParticle;
	
	private var gameStage:GameStageView;
	
	private var reviveTimer:FlxTimer;
	
	override public function create():Void
	{
		
		add(backdrop = new FlxBackdrop(AssetPaths.background__jpg));
		backdrop.velocity.set(0, 200);
		
		sndExplosion = FlxG.sound.load(AssetPaths.explosion1__wav);
		#if flash
		music = FlxG.sound.load(AssetPaths.Battle_Normal__mp3);
		#elseif(cpp || neko)
		music = FlxG.sound.load(AssetPaths.Battle_Normal__ogg);
		#end
		music.volume = .5;
		music.play();
		
		Registry.inEditor = false;
		
		gameStage = new GameStageView();
		gameStage.x = Registry.minXShip;
		add(gameStage);
		gameStage.callbackStageComplete = stageComplete;
		gameStage.callbackGameOver = gameOver;
		gameStage.loadGame();
		//add(gameStage.bots);
		
		startPlayer();
		
		add(Registry.bulletPool);
		
		borderLeft = new FlxSprite();
		borderLeft.makeGraphic(332, 720, 0xFF000022);
		add(borderLeft);		
		
		borderRight = new FlxSprite();
		borderRight.makeGraphic(332, 720, 0xFF000022);
		borderRight.x = Registry.maxXShip;
		add(borderRight);
		
		hud = new HUD();
		add(hud);
		
		//add(new FlxText(100, 100, 200, "Xbox360 Controller " + ((player.gamePad == null) ? "NOT FOUND" : "FOUND")));
		
		reviveTimer = new FlxTimer();
		
		super.create();
	}
	
	function startPlayer()
	{
		//player = new Player(640, 600);
		player = new Player();
		player.sprite.setPosition(gameStage.x + gameStage.width / 2 - player.sprite.width / 2, 600);
		player.antialiasing = true;
		add(player);
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		player = FlxDestroyUtil.destroy(player);
		music = FlxDestroyUtil.destroy(music);
		sndExplosion = FlxDestroyUtil.destroy(sndExplosion);
		backdrop = FlxDestroyUtil.destroy(backdrop);
		hud = FlxDestroyUtil.destroy(hud);
		overlay = FlxDestroyUtil.destroy(overlay);
		borderLeft = FlxDestroyUtil.destroy(borderLeft);
		borderRight = FlxDestroyUtil.destroy(borderRight);
		
		super.destroy();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		//trace(gameStage.width);
		
		if (FlxG.keys.anyPressed(["ESCAPE"])) openMenu();
		
		if (player.sprite.alive)
		{
			Registry.bulletPool.forEachAlive(function(B:Bullet)
			{
				gameStage.bots.forEachAlive(function(bot:Bot)
				{
					//trace("botalive",bot);
					if(B.alive && bot.alive && B.owner == "Player" && B.overlaps(bot.sprite))
					{
						hud.updateHUD(3, hud.score+bot.scoreValue);
						B.kill();
						bot.kill();
						sndExplosion.play(true);
					}
				});
				
				if (B.alive && player.sprite.alive && B.owner == "Enemy" && B.overlaps(player.hitbox))
				{
					B.kill();
					killPlayer();
					//gameOver();
				}
			});
			
			gameStage.bots.forEachAlive(function(bot:Bot)
			{
				if (bot.sprite.overlaps(player.hitbox))
				{
					bot.kill();
					killPlayer();
					sndExplosion.play(true);
				}
			});
		}
		
		//FlxG.overlap(gameStage.bots, player, enemyHit);
		//FlxG.overlap(Registry.bulletPool, gameStage.bots, bulletHitEnemy);
		//FlxG.overlap(Registry.bulletPool, player, bulletHitPlayer);
	}
	
	function killPlayer()
	{
		player.killPlayer();
		sndExplosion.play(true);
		hud.updateHUD(3, 0);
		reviveTimer.start(1, function(timer:FlxTimer){
			player.sprite.setPosition(gameStage.gameArea.x + gameStage.gameArea.width / 2 - player.sprite.width / 2, 600);
			player.revivePlayer(); 
		});
	}
	
	private function openMenu() {
			
		subStateColor = 0x99808080;
		
		overlay = new OverlayState(subStateColor);
		overlay.isPersistant = true;
		overlay.score = hud.score;
		overlay.endGameStatus = -1;
		openSubState(overlay);
	}
	
	private function stageComplete() {
			
		subStateColor = 0x99808080;
		
		overlay = new OverlayState(subStateColor);
		overlay.isPersistant = true;
		overlay.score = hud.score;
		overlay.endGameStatus = 1;
		openSubState(overlay);
	}
	
	private function gameOver() {
			
		subStateColor = 0x99808080;
		
		overlay = new OverlayState(subStateColor);
		overlay.isPersistant = true;
		overlay.score = hud.score;
		overlay.endGameStatus = 0;
		openSubState(overlay);
	}
}

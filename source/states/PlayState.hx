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
	//private var grpEnemy:FlxTypedGroup<Enemy>;
	private var grpBullet:FlxTypedGroup<Bullet>;
	private var sndBullet:FlxSound;
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
		
		//grpBullet = new FlxTypedGroup<Bullet>();
		//add(grpBullet);
		
		//add(new FlxText(100, 100, 200, "Xbox360 Controller " + ((player.gamePad == null) ? "NOT FOUND" : "FOUND")));
		
		//trace(FlxG.overlap(player, grpEnemy));
		
		sndBullet = FlxG.sound.load(AssetPaths.shot1__wav);
		sndExplosion = FlxG.sound.load(AssetPaths.explosion1__mp3);
		music = FlxG.sound.load(AssetPaths.Battle_Normal__mp3);
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
		
		reviveTimer = new FlxTimer();
		
		super.create();
	}
	
	function startPlayer()
	{
		//player = new Player(640, 600);
		player = new Player();
		player.sprite.setPosition(gameStage.width / 2 - player.sprite.width / 2, 600);
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
		grpBullet = FlxDestroyUtil.destroy(grpBullet);
		sndBullet = FlxDestroyUtil.destroy(sndBullet);
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
		
		if (FlxG.keys.anyPressed(["ESCAPE"])) openMenu();
		
		if (player.sprite.alive)
		{
			Registry.bulletPool.forEachAlive(function(B:Bullet)
			{
				gameStage.bots.forEachAlive(function(bot:Bot)
				{
					if(B.owner == "Player" && B.overlaps(bot.sprite))
					{
						B.kill();
						bot.kill();
						sndExplosion.play(true);
						hud.updateHUD(3, hud.score+bot.scoreValue);
					}
				});
				
				if (B.owner == "Enemy" && B.overlaps(player.sprite))
				{
					B.kill();
					killPlayer();
					//gameOver();
				}
			});
			
			gameStage.bots.forEachAlive(function(bot:Bot)
			{
				if (bot.sprite.overlaps(player.sprite))
				{
					bot.kill();
					killPlayer();
					sndExplosion.play(true);
				}
				//trace(FlxG.pixelPerfectOverlap(bot.sprite, player.sprite));
			});
		}
		
		//Registry.bulletPool.forEach(function(B:Bullet) {
			//if (B.overlaps(player))
			//{
				//trace("OVERLAP1");
			//}
		//});
		
		//FlxG.overlap(gameStage.bots, player, enemyHit);
		//FlxG.overlap(Registry.bulletPool, gameStage.bots, bulletHitEnemy);
		//FlxG.overlap(Registry.bulletPool, player, bulletHitPlayer);
		//grpBullet.forEach(bulletTest);
		//grpEnemy.forEach(hitTest);
	}
	
	function killPlayer()
	{
		player.killPlayer();
		sndExplosion.play(true);
		hud.updateHUD(3, 0);
		reviveTimer.start(1, function(timer:FlxTimer){
			player.sprite.setPosition(gameStage.width / 2 - player.sprite.width / 2, 600);
			player.revivePlayer(); 
		});
	}
	
	//function bulletHitPlayer(obj1:FlxObject, obj2:FlxObject) 
	//{
		//trace("BULLET-PLAYER HIT: ", obj1, obj2);
		//obj1.kill();
		//obj2.kill();
		//gameOver();
	//}
	//
	//function bulletHitEnemy(obj1:FlxObject, obj2:FlxObject) 
	//{
		//trace("BULLET-ENEMY HIT: ", obj1, obj2);
		//obj1.kill();
		//obj2.kill();
	//}
	//
	//function enemyHit(obj1:FlxObject, obj2:FlxObject) 
	//{
		//trace("DIRECT HIT: ", obj1, obj2);
		////player.killPlayer();
		//gameOver();
	//}
	
	//private function hitTest(E:Enemy)
	//{
		//if (FlxG.pixelPerfectOverlap(E, player))
		//{
			//sndExplosion.play(true);
			//player.killPlayer();
			//player = FlxDestroyUtil.destroy(player);
			//health--;
			//hud.updateHUD(health, enemiesKilled);
			//startPlayer();
		//}
	//}
	
	//private function bulletTest(B:Bullet)
	//{
		//if (!B.isOnScreen(FlxG.camera)) destroyBullet(B);
		//grpEnemy.forEach(function(E:Enemy) {
			//if (FlxG.pixelPerfectOverlap(B, E))
			//{
				//bulletHitEnemy(B, E);
			//}});
		//trace('Objects: '+(grpEnemy.length+grpBullet.length+1)+' FPS: '+fps.currentFPS);
	//}
	//
	//private function destroyBullet(B:Bullet)
	//{
		//B.kill();
		//B.destroy();
		//grpBullet.remove(B);
	//}
	
	//private function bulletHitEnemy(B:Bullet, E:Enemy)
	//{
		//if (E.alive && E.exists && B.alive && B.exists)
		//{
			//destroyBullet(B);
			//E.kill();
			//E.destroy();
			//grpEnemy.remove(E);
			//grpEnemy.add(new Enemy(FlxG.random.int(200, 1200), FlxG.random.int(0, 400))); // TEST
			//if(Math.random() > .8) grpEnemy.add(new Enemy(FlxG.random.int(200, 1200), FlxG.random.int(0, 400))); // TEST
			//
			//sndExplosion.play(true);
			//
			//var fe = new FlxEmitter(B.x, B.y, 30);
//
			//fe.launchMode = FlxEmitterMode.SQUARE;
			//fe.velocity.set(-500, -200, 500, 50);
			//fe.lifespan.set(0, 2);
			//add(fe);
			//
			//for (i in 0...(Std.int(fe.maxSize / 3))) 
			//{
				//_explosionPixel = new FlxParticle();
				//_explosionPixel.makeGraphic(2, 2, FlxColor.YELLOW);
				//_explosionPixel.visible = false; 
				//fe.add(_explosionPixel);
				//_explosionPixel = new FlxParticle();
				//_explosionPixel.makeGraphic(1, 1, FlxColor.RED);
				//_explosionPixel.visible = false;
				//fe.add(_explosionPixel);
				//_explosionPixel = new FlxParticle();
				//_explosionPixel.makeGraphic(1, 1, FlxColor.WHITE);
				//_explosionPixel.visible = false;
				//fe.add(_explosionPixel);
			//}
			//fe.start(true, 3);
			//
			//
			//enemiesKilled++;
			//hud.updateHUD(health,enemiesKilled);
		//}
	//}
	
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

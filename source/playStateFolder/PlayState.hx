package playStateFolder;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSpriteUtil;
import openfl.display.FPS;
import playStateFolder.Player;
import playStateFolder.HUD;
import flixel.addons.display.FlxBackdrop;

class PlayState extends FlxState
{
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	
	private var player:Player;
	private var grpEnemy:FlxTypedGroup<Enemy>;
	private var grpBullet:FlxTypedGroup<PBullet>;
	private var sndBullet:FlxSound;
	private var sndExplosion:FlxSound;
	private var countFrame:Float = 0;
	private var backdrop:FlxBackdrop;
	private var _health:Int = 3;
	private var _enemiesKilled:Int = 0;
	private var _hud:HUD;

	private var fps:FPS = new FPS();
	//private var weapon:FlxWeapon = new FlxWeapon("arma", null, Bullet);

	private var _explosionPixel:FlxParticle;
	 
	override public function create():Void
	{		
		
		add(backdrop = new FlxBackdrop(AssetPaths.background__jpg));
		backdrop.velocity.set(0, 200);
		
		_hud = new HUD();
		add(_hud);
		
		grpBullet = new FlxTypedGroup<PBullet>();
		add(grpBullet);
		
		startPlayer();
		
		grpEnemy = new FlxTypedGroup<Enemy>();
		add(grpEnemy);
		grpEnemy.add(new Enemy(500, 100));
		
		//add(new FlxText(100, 100, 200, "Xbox360 Controller " + ((player.gamePad == null) ? "NOT FOUND" : "FOUND")));
		
		//trace(FlxG.overlap(player, grpEnemy));
		
		sndBullet = FlxG.sound.load(AssetPaths.shot1__wav);
		sndExplosion = FlxG.sound.load(AssetPaths.explosion1__ogg);
		
		super.create();
	}
	
	function startPlayer()
	{
		player = new Player(640, 600);
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
		grpEnemy = FlxDestroyUtil.destroy(grpEnemy);
		super.destroy();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		if (_health == 0)
			FlxG.switchState(new MenuState());
			
		FlxSpriteUtil.bound(player);
		//trace(fps.currentFPS); //Show FPS
		var shoot:Bool = (player.gamePad != null && player.gamePad.anyPressed([FlxGamepadInputID.RIGHT_TRIGGER])) ? true : FlxG.keys.anyPressed(["SPACE"]);
		if (shoot)
		{
			if (countFrame <= 0)
			{
				//grpBullet.add(new PBullet(player.x + 12.5, player.y + 5));
				grpBullet.add(new PBullet(player.x + 22.5, player.y + 5));
				//FlxG.camera.shake(0.001, 0.1, null, true, 2);
				FlxG.camera.shake(0.001, 0.1, null, true, null);
				sndBullet.play(true);
				countFrame = player.rof;
				
				_explosionPixel = new FlxParticle();
				_explosionPixel.makeGraphic(2, 10, FlxColor.WHITE);
				_explosionPixel.visible = false;
				var shellRight = new FlxEmitter(player.x + 30, player.y + 5, 1);							
				shellRight.launchMode = FlxEmitterMode.SQUARE;
				shellRight.velocity.set(1000 + player.velocity.x, 300, 1000 + player.velocity.x, 300);				
				shellRight.angle.set(-90,90);	
				add(shellRight);
				shellRight.add(_explosionPixel);
				shellRight.start(true, 1);
				
				_explosionPixel = new FlxParticle();
				_explosionPixel.makeGraphic(2, 10, FlxColor.WHITE);
				_explosionPixel.visible = false;
				var shellLeft = new FlxEmitter(player.x + 26, player.y + 5, 1);								
				shellLeft.launchMode = FlxEmitterMode.SQUARE;
				shellLeft.velocity.set( -1000 + player.velocity.x, 300, -1000 + player.velocity.x, 300);
				shellLeft.angle.set(90,-90);
				add(shellLeft);
				shellLeft.add(_explosionPixel);
				shellLeft.start(true, 1);
			}
			countFrame--;
		}
		
		FlxG.overlap(grpBullet, grpEnemy, bulletHitEnemy);
		grpBullet.forEach(bulletTest);
		grpEnemy.forEach(hitTest);
	}
	
	private function hitTest(E:Enemy)
	{
		if (FlxG.pixelPerfectOverlap(E, player))
		{
			sndExplosion.play(true);
			player.killPlayer();
			player = FlxDestroyUtil.destroy(player);
			_health--;
			_hud.updateHUD(_health, _enemiesKilled);
			startPlayer();
		}
	}
	
	private function bulletTest(B:PBullet)
	{
		if (!B.isOnScreen(FlxG.camera)) destroyBullet(B);
		grpEnemy.forEach(function(E:Enemy) {
			if (FlxG.pixelPerfectOverlap(B, E))
			{
				bulletHitEnemy(B, E);
			}});
		trace('Objects: '+(grpEnemy.length+grpBullet.length+1)+' FPS: '+fps.currentFPS);
	}
	
	private function destroyBullet(B:PBullet)
	{
		B.kill();
		B.destroy();
		grpBullet.remove(B);
	}
	
	private function bulletHitEnemy(B:PBullet, E:Enemy)
	{
		if (E.alive && E.exists && B.alive && B.exists)
		{
			destroyBullet(B);
			E.kill();
			E.destroy();
			grpEnemy.remove(E);
			grpEnemy.add(new Enemy(FlxG.random.int(200, 1200), FlxG.random.int(0, 400))); // TEST
			if(Math.random() > .8) grpEnemy.add(new Enemy(FlxG.random.int(200, 1200), FlxG.random.int(0, 400))); // TEST
			
			sndExplosion.play(true);
			
			var fe = new FlxEmitter(B.x, B.y, 30);

			fe.launchMode = FlxEmitterMode.SQUARE;
			fe.velocity.set(-500, -200, 500, 50);
			fe.lifespan.set(0, 2);
			add(fe);
			
			for (i in 0...(Std.int(fe.maxSize / 3))) 
			{
				_explosionPixel = new FlxParticle();
				_explosionPixel.makeGraphic(2, 2, FlxColor.YELLOW);
				_explosionPixel.visible = false; 
				fe.add(_explosionPixel);
				_explosionPixel = new FlxParticle();
				_explosionPixel.makeGraphic(1, 1, FlxColor.RED);
				_explosionPixel.visible = false;
				fe.add(_explosionPixel);
				_explosionPixel = new FlxParticle();
				_explosionPixel.makeGraphic(1, 1, FlxColor.WHITE);
				_explosionPixel.visible = false;
				fe.add(_explosionPixel);
			}
			fe.start(true, 3);
			
			
			_enemiesKilled++;
			_hud.updateHUD(_health,_enemiesKilled);
		}
	}
}

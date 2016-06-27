package playStateFolder ;

import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.input.gamepad.id.XInputID;
import flixel.math.FlxAngle;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.util.FlxSpriteUtil;
import haxe.Log;
import model.Ship;
/**
 * ...
 * @author ...
 */
class Player extends Ship
{
	public var gamePad:FlxGamepad;
	public var controlSpeed:Float;
	private var firing:Float = 0;
	
	public function new(?X:Float = 0, ?Y:Float = 0) 
	{
		super();
		
		controlSpeed = speed = 10;
		rateOfFire = .1;
		
		sprite = new FlxSprite();
		sprite.loadGraphic(AssetPaths.RedShipSprite__png, true, 60, 62);
		sprite.x = X - sprite.width * .5;
		sprite.y = Y - sprite.height * .5;
		sprite.setFacingFlip(FlxObject.LEFT, false, false);
		sprite.setFacingFlip(FlxObject.RIGHT, true, false);
		sprite.animation.add("lr", [1]);
		sprite.animation.add("ud", [0]);
		sprite.animation.add("destroy", [2,3,4,5,6,7,8,9], 10, false);
		add(sprite);
		
		gamePad = FlxG.gamepads.lastActive;
		if (gamePad != null) gamePad.deadZone = 0.2;
	}
	
	//private function movement():Void
	//{
		//var _up:Bool = false;
		//var _down:Bool = false;
		//var _left:Bool = false;
		//var _right:Bool = false;
		//
		//#if !FLX_NO_KEYBOARD
		////_up = FlxG.keys.anyPressed(["UP", "W"]);
		////_down = FlxG.keys.anyPressed(["DOWN", "S"]);
		////_left = FlxG.keys.anyPressed(["LEFT", "A"]);
		////_right = FlxG.keys.anyPressed(["RIGHT", "D"]);
		//_up = (gamePad != null && ((gamePad.anyPressed([FlxGamepadInputID.DPAD_UP])) || gamePad.getYAxis(1) < 0)) ? true : FlxG.keys.anyPressed(["UP", "W"]);
		//_down = (gamePad != null && ((gamePad.anyPressed([FlxGamepadInputID.DPAD_DOWN])) || gamePad.getYAxis(1) > 0)) ? true : FlxG.keys.anyPressed(["DOWN", "S"]);
		//_left = (gamePad != null && ((gamePad.anyPressed([FlxGamepadInputID.DPAD_LEFT])) || gamePad.getXAxis(0) < 0))  ? true : FlxG.keys.anyPressed(["LEFT", "A"]);
		//_right = (gamePad != null && ((gamePad.anyPressed([FlxGamepadInputID.DPAD_RIGHT])) || gamePad.getXAxis(0) > 0)) ? true : FlxG.keys.anyPressed(["RIGHT", "D"]);
		//if (gamePad != null)
		//{
			//trace('trace', gamePad.getXAxis(0), gamePad.getYAxis(1));
			////_up = gamePad.pressed(XboxButtonID.DPAD_UP);
			////_down = gamePad.pressed(XboxButtonID.DPAD_DOWN);
			////_left = gamePad.pressed(XboxButtonID.DPAD_LEFT);
			////_right = gamePad.pressed(XboxButtonID.DPAD_RIGHT);
		//}
		//#end
		//#if mobile
		//_up = playStateFolder.PlayState.virtualPad.buttonUp.status == FlxButton.PRESSED;
		//_down = playStateFolder.PlayState.virtualPad.buttonDown.status == FlxButton.PRESSED;
		//_left = playStateFolder.PlayState.virtualPad.buttonLeft.status == FlxButton.PRESSED;
		//_right = playStateFolder.PlayState.virtualPad.buttonRight.status == FlxButton.PRESSED;
		//#end
		//if (_up && _down) _up = _down = false;
		//if (_left && _right) _left = _right = false;
		//
		//if (_up || _down || _left || _right)
		//{
			//var mA:Float = 0;
			//if (_up)
			//{
				//mA = -90;
				//if (_left) mA -= 45;
				//else if (_right) mA += 45;
				//facing = FlxObject.UP;
			//}
			//else if (_down)
			//{
				//mA = 90;
				//if (_left) mA += 45;
				//else if (_right) mA -= 45;
				//facing = FlxObject.DOWN;
			//}
			//else if (_left)
			//{
				//mA = 180;
				//facing = FlxObject.LEFT;
			//}
			//else if (_right)
			//{
				//mA = 0;
				//facing = FlxObject.RIGHT;
			//}
			//
			////FlxAngle.rotatePoint(speed, 0, 0, 0, mA, velocity);
			//velocity.set(speed, 0);
			//velocity.rotate(FlxPoint.weak(0, 0), mA);
			//
			//if ((velocity.x != 0 || velocity.y != 0) && touching == FlxObject.NONE)
			//{
				//switch(facing)
				//{
					//case FlxObject.UP, FlxObject.DOWN:
						//animation.play("ud");
					//case FlxObject.LEFT, FlxObject.RIGHT:
						//animation.play("lr");
				//}
			//}
		//}else {
			//animation.play("ud");
			////FlxAngle.rotatePoint(0, 0, 0, 0, 0, velocity);
			//velocity.set(0, 0);
			//velocity.rotate(FlxPoint.weak(0, 0), 0);
		//}
	//}
	
	override public function kill():Void 
	{
		killPlayer();
		super.kill();
	}
	
	public function killPlayer():Void
	{
		sprite.alive = false;
		sprite.animation.play("destroy");
	}
	
	override public function destroy():Void
	{
		
	}
	
	override public function update(elapsed:Float):Void
	{
		if (sprite.alive)
		{
			//movement();	
			controla(elapsed);
			FlxSpriteUtil.bound(sprite, Registry.minXShip, Registry.maxXShip, Registry.minYShip, Registry.maxYShip);
		}
		super.update(elapsed);
	}
	
	private function controla(elapsed:Float)
	{
		//Controls here
		if (FlxG.keys.pressed.SPACE)
		{
			firing += elapsed;
			if (firing >= rateOfFire)
			{
				fire(500);
				firing = 0;
			}
		}else if (FlxG.keys.justReleased.SPACE) firing = 0;
		if (FlxG.keys.pressed.SHIFT) controlSpeed = speed * .5;
		else controlSpeed = speed;
		if (FlxG.keys.pressed.LEFT) sprite.x -= controlSpeed;
		if (FlxG.keys.pressed.RIGHT) sprite.x += controlSpeed;
		if (FlxG.keys.pressed.UP) sprite.y -= controlSpeed;
		if (FlxG.keys.pressed.DOWN) sprite.y += controlSpeed;
		
		if (sprite.x < 0) sprite.x = 0;
		if (sprite.x + sprite.width > FlxG.width) sprite.x = FlxG.width - sprite.width;
		if (sprite.y < 0) sprite.y = 0;
		if (sprite.y + sprite.height > FlxG.height) sprite.y = FlxG.height - sprite.height;
	}

}
package playStateFolder ;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxAngle;
import flixel.math.FlxPoint;
import flixel.util.FlxDestroyUtil;
/**
 * ...
 * @author ...
 */
class Bullet extends FlxSprite
{
	public var speed(default, set):Float = 2000;
	
	public function new(X:Float=0, Y:Float=0, rotation:Float = 0, speed:Float = 2000) 
	{
		super(X, Y);
		this.speed = speed;
		
		loadGraphic(AssetPaths.Bullet1__png, true, 15, 20);
		animation.add("fire", [0]);
		animation.add("fly", [1]);
		//animation.play("fire");
		animation.play("fly");
		
		//setRotation(rotation);
	}
	
	public function setRotation(rotation:Float) 
	{
		angle = rotation;
		trace('setRotation', rotation);
		//velocity.rotate(FlxPoint.weak(0, 0), rotation);
	}
	
	private function movement()
	{
		animation.play("fly");
		//FlxAngle.rotatePoint(0, speed, 0, 0, 0, velocity);
		velocity.set(Math.cos(angle) * speed, Math.sin(angle) * speed);
	}
	
	override public function destroy():Void
	{
		
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (!isOnScreen()) kill();
		//movement();
	}
	
	function set_speed(value:Float):Float 
	{
		return speed = value;
	}
}
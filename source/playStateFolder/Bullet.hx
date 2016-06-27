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
	
	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		this.speed = speed;
		
		loadGraphic(AssetPaths.Bullet1__png, true, 15, 20);
		animation.add("fire", [0]);
		animation.add("fly", [1]);
		//animation.play("fire");
		animation.play("fly");
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (!isOnScreen()) kill();
	}
	
	function set_speed(value:Float):Float 
	{
		return speed = value;
	}
}
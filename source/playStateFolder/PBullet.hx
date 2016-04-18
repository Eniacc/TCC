package playStateFolder ;
import flixel.FlxSprite;
import flixel.math.FlxAngle;
import flixel.math.FlxPoint;
import flixel.util.FlxDestroyUtil;
/**
 * ...
 * @author ...
 */
class PBullet extends FlxSprite
{
	private var speed:Float = 2000;
	
	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		loadGraphic(AssetPaths.Bullet1__png, true, 15, 20);
		animation.add("fire", [0]);
		animation.add("fly", [1]);
		animation.play("fire");
	}
	
	private function movement()
	{
		animation.play("fly");
		//FlxAngle.rotatePoint(0, speed, 0, 0, 0, velocity);
		velocity.set(0,-speed);
		velocity.rotate(FlxPoint.weak(0, 0), 0);
	}
	
	override public function destroy():Void
	{
		
	}
	
	override public function update(elapsed:Float):Void
	{
		movement();
		super.update(elapsed);
	}
}
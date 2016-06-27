package;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import model.Wave;
import playStateFolder.Bullet;

/**
 * ...
 * @author Oelson TCS
 */
class Registry
{
	public static var gameWidth = 616;
	public static var gameHeight = 720;
	public static var minXShip = 332;
	public static var maxXShip = minXShip + gameWidth;
	public static var minYShip = 0;
	public static var maxYShip = 720;
	public static var stage:FlxTypedGroup<Wave>;
	public static var bulletPool:FlxTypedSpriteGroup<Bullet> = new FlxTypedSpriteGroup<Bullet>();
	public static var inEditor:Bool = false;

	public function new() 
	{
		
	}
	
}
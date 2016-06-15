package playStateFolder ;

import flixel.FlxSprite;

/**
 * ...
 * @author ...
 */
class Enemy extends FlxSprite
{
	private static var ENEMY_SPEED:Float = 250;

	public function new(X:Float=0, Y:Float=0, type:Int = 1) 
	{
		super(X, Y);
		loadGraphic("assets/images/Enemy"+type+".png", true, 59, 100);
	}
	
	/*
	override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
        velocity.y = 0;
        if (active){
            velocity.y = ENEMY_SPEED;
        }
    }
	*/
}
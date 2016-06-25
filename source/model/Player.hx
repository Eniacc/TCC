package model;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author Oelson TCS
 */
class Player extends Ship
{
	
	public var controlSpeed:Float;
	
	public function new(?X:Float = 0, ?Y:Float = 0) 
	{
		super();
		
		sprite = new FlxSprite();
		sprite.loadGraphic(AssetPaths.ShipSpritesheet__png, true, 100, 62);
		sprite.x = X - sprite.width * .5;
		sprite.y = Y - sprite.height * .5;
		add(sprite);
		
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		controla();
	}
	
	private function controla()
	{
		//Controls here
		firing = FlxG.keys.pressed.SPACE;
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
package gameView;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxRect;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

/**
 * ...
 * @author Oelson TCS
 */
class GameStageView extends FlxSpriteGroup
{
	private var gameArea:FlxSprite;
	//private var offscreen:FlxSprite;
	
	public function new(scale:Float = 1) 
	{
		super();
		
		//offscreen = new FlxSprite();
		//offscreen.makeGraphic(Std.int(Registry.gameWidth), Std.int(Registry.gameHeight), 0xFF000022);
		//add(offscreen);
		
		gameArea = new FlxSprite();
		gameArea.makeGraphic(Std.int(Registry.gameWidth * scale), Std.int(Registry.gameHeight * scale), 0xFF000055);
		gameArea.updateHitbox();
		add(gameArea);
	}
	
	public function showHelp() 
	{
		var text:FlxText = new FlxText(0, 0, 0, "Game Area");
		text.color = FlxColor.GRAY;
		text.x = gameArea.width / 2 - text.width / 2;
		text.y = gameArea.height - text.height;
		add(text);
	}
}
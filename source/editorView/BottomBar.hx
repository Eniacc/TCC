package editorView;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import haxe.Constraints.Function;

/**
 * ...
 * @author Oelson TCS
 */
class BottomBar extends FlxSpriteGroup
{
	var btPlay:FlxButton;
	var playing:Bool = false;
	public var callbackPlayStop:Function;
	
	public function new(?X:Float = 0, ?Y:Float = 0) 
	{
		super();
		
		this.x = X;
		this.y = Y;
		
		var background:FlxSprite = new FlxSprite();
		background.makeGraphic(1280, 40);
		FlxSpriteUtil.drawRect(background, 0, 0, 1280, 40, FlxColor.TRANSPARENT, {thickness:5});
		add(background);
		
		btPlay = new FlxButton(0, 0, "", playStopHandler);
		btPlay.loadGraphic(AssetPaths.btplay__png);
		btPlay.setPosition(background.width - btPlay.width, 0);
		add(btPlay);
	}
	
	function playStopHandler() 
	{
		if (!playing)
		{
			playing = true;
			btPlay.loadGraphic(AssetPaths.btsop__png);
			callbackPlayStop(true);
		}else{
			playing = false;
			btPlay.loadGraphic(AssetPaths.btplay__png);
			callbackPlayStop(false);
		}
	}
	
	public function setPlay(play:Bool = false)
	{
		playing = !play;
		playStopHandler();
	}
}
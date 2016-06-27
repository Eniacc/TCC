package editorView;

import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import model.Path;
import model.Waypoint;

/**
 * ...
 * @author Oelson TCS
 */
class Box extends FlxSpriteGroup
{
	public var background:FlxSprite;
	public var stage:FlxSprite;
	public var selection:FlxSprite;
	
	public var paths:FlxTypedGroup<Path>;
	private var waypoints:FlxSprite;

	public function new()
	{
		super();
		
		background = new FlxSprite();
		background.makeGraphic(166, 166);
		FlxSpriteUtil.drawRect(background, 0, 0, 166, 166, FlxColor.TRANSPARENT, {thickness:5});
		add(background);
		
		stage = new FlxSprite();
		stage.makeGraphic(166, 166, 0xFF000055);
		stage.scale.set(.9, .9);
		add(stage);
		
		waypoints = new FlxSprite();
		waypoints.makeGraphic(166, 166,FlxColor.TRANSPARENT,true);
		add(waypoints);
		
		selection = new FlxSprite();
		selection.makeGraphic(166, 166, 0x22FFFFFF);
		add(selection);
		selection.visible = false;
		
		paths = new FlxTypedGroup<Path>();
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		FlxSpriteUtil.fill(waypoints, FlxColor.TRANSPARENT);
		for (i in 0...paths.length)
		{
			var path:Path = paths.members[i];
			//trace(path.length);
			//for (j in 0...path.length)
			var prevWp:Waypoint = null;
			path.forEachAlive(function(wp:Waypoint)
			{
				FlxSpriteUtil.drawCircle(waypoints, wp.xPer * background.width, wp.yPer * background.height, 5, FlxColor.RED);
				
				if (prevWp != null)
				{
					FlxSpriteUtil.drawLine(waypoints, prevWp.xPer * background.width, prevWp.yPer * background.height, wp.xPer * background.width, wp.yPer * background.height);
				}
				
				prevWp = wp;
			});
		}
		
		//waypoints.pixels = paths.members[0].members[0].pixels;
	}
}
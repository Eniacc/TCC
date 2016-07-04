package editorView;

import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import model.Pathway;
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
	
	public var paths:FlxTypedGroup<Pathway>;
	private var waypoints:FlxSprite;

	public function new()
	{
		super();
		
		background = new FlxSprite();
		background.makeGraphic(166, 160);
		FlxSpriteUtil.drawRect(background, 0, 0, 166, 160, FlxColor.TRANSPARENT, {thickness:5});
		add(background);
		
		stage = new FlxSprite();
		stage.makeGraphic(166, 160, 0xFF000055);
		stage.scale.set(.9, .9);
		add(stage);
		
		waypoints = new FlxSprite();
		waypoints.makeGraphic(166, 160,FlxColor.TRANSPARENT,true);
		add(waypoints);
		
		selection = new FlxSprite();
		selection.makeGraphic(166, 160, 0x22FFFFFF);
		add(selection);
		selection.visible = false;
		
		paths = new FlxTypedGroup<Pathway>();
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		FlxSpriteUtil.fill(waypoints, FlxColor.TRANSPARENT);
		paths.forEachAlive(function(path:Pathway)
		{
			//trace(path.length);
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
		});
		
		//waypoints.pixels = paths.members[0].members[0].pixels;
	}
}
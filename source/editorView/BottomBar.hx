package editorView;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

/**
 * ...
 * @author Oelson TCS
 */
class BottomBar extends FlxSpriteGroup
{
	public function new(?X:Float = 0, ?Y:Float = 0) 
	{
		super();
		
		this.x = X;
		this.y = Y;
		
		var background:FlxSprite = new FlxSprite();
		background.makeGraphic(1280, 40);
		FlxSpriteUtil.drawRect(background, 0, 0, 1280, 40, FlxColor.TRANSPARENT, {thickness:5});
		add(background);
		
		//var btUp:FlxButton = new FlxButton(0, 0, "NEW", selectUp);
		//btUp.makeGraphic(83, 40, 0xFF000055);
		//btUp.setPosition(0, background.height - btUp.height);
		//btUp.label = new FlxText(0, 0, btUp.width, "NEW", 20);
		//btUp.label.alignment = FlxTextAlign.CENTER;
		//FlxSpriteUtil.drawRect(btUp, 0, 0, btUp.width, btUp.height, FlxColor.TRANSPARENT, {thickness:5});
		//add(btUp);
		//
		//var btDown:FlxButton = new FlxButton(0, 0, "REMOVE", selectDown);
		//btDown.makeGraphic(83, 40, 0xFF000055);
		//btDown.setPosition(btUp.width, background.height - btDown.height);
		//btDown.label = new FlxText(0, 0, btUp.width, "REMOVE", 20);
		//btDown.label.alignment = FlxTextAlign.CENTER;
		//FlxSpriteUtil.drawRect(btDown, 0, 0, btDown.width, btDown.height, FlxColor.TRANSPARENT, {thickness:5});
		//add(btDown);
	}
}
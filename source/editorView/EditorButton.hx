package editorView;

import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

/**
 * ...
 * @author Oelson TCS
 */
class EditorButton extends FlxButton
{

	public function new(X:Float=0, Y:Float=0, ?Text:String, ?OnClick:Void->Void) 
	{
		super(X, Y, Text, OnClick);
		
		makeGraphic(Std.int(new FlxText(0, 0, 0, Text, 20).width + 10), 40, 0xFF000055);
		FlxSpriteUtil.drawRect(this, 0, 0, width, height, FlxColor.TRANSPARENT, {thickness:5});
		
		label = new FlxText(0, 0, width, Text, 20);
		label.alignment = FlxTextAlign.CENTER;
	}
	
}
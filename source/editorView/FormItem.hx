package editorView;

import flixel.addons.text.FlxTextField;
import flixel.addons.ui.FlxInputText;
import flixel.addons.ui.FlxUICheckBox;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxRect;
import flixel.text.FlxText;
import flixel.util.FlxColor;

/**
 * ...
 * @author Oelson TCS
 */
class FormItem extends FlxSpriteGroup
{

	var label:FlxText;
	var content:FlxInputText;
	@:isVar public var value(get, set):Float;
	
	public function new(fitRect:FlxRect, label:String)
	{
		super();
		
		this.label = new FlxText();
		this.label.size = 20;
		this.label.text = label;
		this.label.color = FlxColor.BLACK;
		this.label.alignment = FlxTextAlign.RIGHT;
		
		content = new FlxInputText(fitRect.width - fitRect.x - 100, 0, 100, "0", 20);
		//content.filterMode = FlxInputText.ONLY_ALPHANUMERIC;
		enable();
		
		add(this.label);
		add(content);
	}
	
	function get_value():Float 
	{
		value = Std.parseFloat(content.text);
		return value;
	}
	
	function set_value(value:Float):Float 
	{
		content.text = Std.string(value).substr(0, 4);
		return this.value = value;
	}
	
	public function enable()
	{
		content.backgroundColor = FlxColor.WHITE;
		content.maxLength = 4;
	}
	public function disable()
	{
		content.backgroundColor = FlxColor.GRAY;
		content.maxLength = 0;
	}
}
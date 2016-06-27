package editorView;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.text.FlxTextField;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import haxe.Constraints.Function;

/**
 * ...
 * @author Oelson TCS
 */
class WarningSubState extends FlxSubState
{
	var background:FlxSprite;
	var callbackYes:Void->Void;
	
	public function new(BGColor:FlxColor=0, message:String, callbackYes:Void->Void)
	{
		super(BGColor);
		
		this.callbackYes = callbackYes;
		
		background = new FlxSprite();
		background.makeGraphic(500, 200);
		background.setPosition(FlxG.width / 2 - background.width / 2, FlxG.height / 2 - background.height / 2);
		add(background);
		
		var message:FlxText = new FlxText(background.x, background.y, 0, message, 20);
		message.setPosition(background.x + background.width / 2 -message.width / 2, background.y+message.height);
		message.color = 0xFF000055;
		add(message);
		
		var btYes:EditorButton = new EditorButton(0, 0, "YES", pressYes);
		btYes.setPosition(background.x + background.width / 3 - btYes.width / 2, background.y + background.height - btYes.height*2);
		add(btYes);
		
		var btNo:EditorButton = new EditorButton(0, 0, "NO", close);
		btNo.setPosition(background.x + (background.width / 3) * 2 - btNo.width / 2, background.y + background.height - btNo.height*2);
		add(btNo);
	}
	
	public function pressYes()
	{
		callbackYes();
		close();
	}
}
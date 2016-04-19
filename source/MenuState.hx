package;

import editorFolder.EditorState;
import flixel.util.FlxColor;
import playStateFolder.PlayState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.input.gamepad.FlxGamepad;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import openfl.system.System;

class MenuState extends FlxState
{
	private var txtTitle:FlxText;
	private var btnPlay:FlxButton;
	private var btnEditor:FlxButton;
	private var btnOptions:FlxButton;
	#if desktop
	private var btnExit:FlxButton;
	#end
	
	override public function create():Void
	{
		txtTitle = new FlxText(0, 0, 0, "SHMUP\nSANDBOX", 100);
		txtTitle.alignment = CENTER;
		txtTitle.screenCenter(X);
		txtTitle.y = 80;
		add(txtTitle);
		
		#if desktop
		btnExit = new FlxButton(0, 0, "Exit", clickExit);
		btnExit.x = (FlxG.width / 2) - (btnExit.width / 2);
		btnExit.y = FlxG.height - btnExit.height - 20;
		//btnExit.loadGraphic(AssetPaths.button__png, true, 20, 20);
		add(btnExit);
		#end

		btnOptions = new FlxButton(0, 0, "Options", clickOptions);
		btnOptions.x = (FlxG.width / 2) - (btnOptions.width / 2);
		btnOptions.y = FlxG.height - btnOptions.height - 20;
		#if desktop
		btnOptions.y = btnExit.y - btnOptions.height - 10;
		#end
		//btnOptions.onUp.sound = FlxG.sound.load(AssetPaths.select__wav);
		add(btnOptions);
		
		btnEditor = new FlxButton(0, 0, "Editor", clickEditor);
		btnEditor.x = (FlxG.width / 2) - (btnEditor.width / 2);
		btnEditor.y = btnOptions.y - btnEditor.height - 10;
		//btnEditor.onUp.sound = FlxG.sound.load(AssetPaths.select__wav);
		add(btnEditor);

		btnPlay = new FlxButton(0, 0, "Play", clickPlay);
		btnPlay.x = (FlxG.width / 2) - (btnPlay.width / 2);
		btnPlay.y = btnEditor.y - btnPlay.height - 10;	
		//btnPlay.onUp.sound = FlxG.sound.load(AssetPaths.select__wav);
		add(btnPlay);
		
		FlxG.camera.fade(FlxColor.BLACK, .33, true);
		
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
	
	private function clickPlay():Void {
		FlxG.switchState(new PlayState());
	}
	
	private function clickEditor():Void {
		FlxG.switchState(new EditorState());
	}
	 
	private function clickOptions():Void {
		FlxG.switchState(new OptionsState());
	}
	
	#if desktop
	private function clickExit():Void {
		System.exit(0);
	}
	#end
}

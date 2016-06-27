package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.text.FlxText;
import flixel.ui.FlxBar;
import flixel.ui.FlxButton;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;
import flixel.util.FlxSave;

/**
 * ...
 * @author ...
 */
class ControlsState extends FlxState
{
	// define our screen elements
	private var backdrop:FlxBackdrop;
	private var logo:FlxSprite;
	private var txtTitle:FlxText;	
	private var txtMovement:FlxText;	
	private var keyboardArrows:FlxSprite;
	private var txtShoot:FlxText;
	private var keyboardSpace:FlxSprite;
	private var btnBack:FlxButton;

	override public function create():Void
	{
		
		add(backdrop = new FlxBackdrop(AssetPaths.BgMenu__jpg));
		
		logo = new FlxSprite();		
		logo.loadGraphic(AssetPaths.logo__png);
		logo.x = (FlxG.width / 2) - (logo.width / 2);
		logo.y = 120;
		logo.antialiasing = true;
		add(logo);
		
		// setup and add our objects to the screen
		txtTitle = new FlxText(0, logo.y + logo.height + 30, 0, "Controls", 40);
        txtTitle.setBorderStyle(SHADOW, FlxColor.GRAY, 1, 1);
		txtTitle.alignment = CENTER;
		txtTitle.screenCenter(FlxAxes.X);
		add(txtTitle);
		
		txtMovement = new FlxText(0, txtTitle.y + txtTitle.height + 40, 0, "Movement", 20);
        txtMovement.setBorderStyle(SHADOW, FlxColor.GRAY, 1, 1);
		txtMovement.x = (FlxG.width / 2) - txtMovement.width - 30;
		add(txtMovement);
		
		keyboardArrows = new FlxSprite();		
		keyboardArrows.loadGraphic(AssetPaths.KeyboardArrows__png);
		keyboardArrows.x = (FlxG.width / 2) - keyboardArrows.width - 20;
		keyboardArrows.y = txtMovement.y + txtMovement.height + 20;
		keyboardArrows.antialiasing = true;
		add(keyboardArrows);
		
		txtShoot = new FlxText(0, txtTitle.y + txtTitle.height + 40, 0, "Shoot", 20);
        txtShoot.setBorderStyle(SHADOW, FlxColor.GRAY, 1, 1);
		txtShoot.x = (FlxG.width / 2) + 136 - (txtShoot.width / 2) + 20;
		add(txtShoot);
		
		keyboardSpace = new FlxSprite();		
		keyboardSpace.loadGraphic(AssetPaths.KeyboardSpace__png);
		keyboardSpace.x = (FlxG.width / 2) + 20;
		keyboardSpace.y = txtShoot.y + txtShoot.height + 50;
		keyboardSpace.antialiasing = true;
		add(keyboardSpace);
		
		btnBack = new FlxButton(0, 0, "Back", clickBack);	
		btnBack.x = (FlxG.width / 2) - (btnBack.width / 2);
		btnBack.y = FlxG.height - btnBack.height - 20;
		btnBack.onUp.sound = FlxG.sound.load(AssetPaths.select__wav);
		add(btnBack);
		
		FlxG.camera.fade(FlxColor.BLACK, .33, true);
		
		super.create();		
	}
	
	private function clickBack():Void
	{
		FlxG.camera.fade(FlxColor.BLACK, .33, false, function()
		{
			FlxG.switchState(new states.OptionsState());
		});
	}
}
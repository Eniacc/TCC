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
class OptionsState extends FlxState
{
	// define our screen elements
	private var backdrop:FlxBackdrop;
	private var logo:FlxSprite;
	private var txtTitle:FlxText;
	private var barVolume:FlxBar;
	private var txtVolume:FlxText;
	private var txtVolumeAmp:FlxText;
	private var btnVolumeDown:FlxButton;
	private var btnVolumeUp:FlxButton;
	private var txtClearData:FlxText;
	private var btnClearData:FlxButton;
	private var btnBack:FlxButton;
	private var btnControls:FlxButton;
	#if (desktop || flash)
	private var txtFullscreen:FlxText;
	private var btnFullScreen:FlxButton;
	#end
	
	// a save object for saving settings
	private var _save:FlxSave;

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
		txtTitle = new FlxText(0, logo.y + logo.height + 30, 0, "Options", 40);
        txtTitle.setBorderStyle(SHADOW, FlxColor.GRAY, 1, 1);
		txtTitle.alignment = CENTER;
		txtTitle.screenCenter(FlxAxes.X);
		add(txtTitle);
		
		txtVolume = new FlxText(0, txtTitle.y + txtTitle.height + 20, 0, "Music Volume", 20);
        txtVolume.setBorderStyle(SHADOW, FlxColor.GRAY, 1, 1);
		txtVolume.alignment = CENTER;
		txtVolume.screenCenter(FlxAxes.X);
		add(txtVolume);
		
		// the volume buttons will be smaller than 'default' buttons
		btnVolumeDown = new FlxButton(366, txtVolume.y + txtVolume.height + 10, "-", clickVolumeDown);
		btnVolumeDown.label = new FlxText(0, 0, btnVolumeDown.width, "-");
		btnVolumeDown.label.setFormat(null,15,0x333333,"center");
		btnVolumeDown.loadGraphic(AssetPaths.button__png, true, 30,30);
		btnVolumeDown.onUp.sound = FlxG.sound.load(AssetPaths.select__wav);
		add(btnVolumeDown);
		
		btnVolumeUp = new FlxButton(FlxG.width - 396, btnVolumeDown.y, "+", clickVolumeUp);
		btnVolumeUp.label = new FlxText(0, 0, btnVolumeUp.width, "+");
		btnVolumeUp.label.setFormat(null,15,0x333333,"center");
		btnVolumeUp.loadGraphic(AssetPaths.button__png, true, 30,30);
		btnVolumeUp.onUp.sound = FlxG.sound.load(AssetPaths.select__wav);
		add(btnVolumeUp);
		
		barVolume = new FlxBar(btnVolumeDown.x + btnVolumeDown.width + 4, btnVolumeDown.y, LEFT_TO_RIGHT, Std.int(FlxG.width - 800), Std.int(btnVolumeUp.height));
		barVolume.createFilledBar(0xff464646, FlxColor.WHITE, true, FlxColor.WHITE);
		add(barVolume);
		
		txtVolumeAmp = new FlxText(0, 10, 200, (FlxG.sound.volume * 100) + "%", 15);
		txtVolumeAmp.alignment = CENTER;
		txtVolumeAmp.borderStyle = FlxTextBorderStyle.OUTLINE;
		txtVolumeAmp.borderColor = 0xff464646;
		txtVolumeAmp.y = barVolume.y + (barVolume.height / 2) - (txtVolumeAmp.height / 2);
		txtVolumeAmp.screenCenter(FlxAxes.X);
		add(txtVolumeAmp);
		
		txtClearData = new FlxText(0, barVolume.y + barVolume.height + 20, 0, "Clear Data", 20);
        txtClearData.setBorderStyle(SHADOW, FlxColor.GRAY, 1, 1);
		txtClearData.alignment = CENTER;
		txtClearData.screenCenter(FlxAxes.X);
		add(txtClearData);
		
		btnClearData = new FlxButton(0, txtClearData.y + txtClearData.height + 15, "Clear Data", clickClearData);
		btnClearData.x = FlxG.width / 2 - btnClearData.width / 2;
		btnClearData.onUp.sound = FlxG.sound.load(AssetPaths.select__wav);
		add(btnClearData);
		
		#if (desktop || flash)
		
		txtFullscreen = new FlxText(0, btnClearData.y + btnClearData.height + 20, 0, "Fullscreen", 20);
        txtFullscreen.setBorderStyle(SHADOW, FlxColor.GRAY, 1, 1);
		txtFullscreen.alignment = CENTER;
		txtFullscreen.screenCenter(FlxAxes.X);
		add(txtFullscreen);
		
		
		btnFullScreen = new FlxButton(0, txtFullscreen.y + txtFullscreen.height + 15, FlxG.fullscreen ? "No" : "Yes", clickFullscreen);
		btnFullScreen.x = FlxG.width / 2 - btnFullScreen.width / 2;
		btnFullScreen.onUp.sound = FlxG.sound.load(AssetPaths.select__wav);
		add(btnFullScreen);
		
		#end
		
		btnBack = new FlxButton(0, 0, "Back", clickBack);	
		btnBack.x = (FlxG.width / 2) - btnBack.width - 10;
		btnBack.y = FlxG.height - btnBack.height - 20;
		btnBack.onUp.sound = FlxG.sound.load(AssetPaths.select__wav);
		add(btnBack);
		
		btnControls = new FlxButton(0, 0, "Controls", clickControls);	
		btnControls.x = (FlxG.width / 2) + 10;
		btnControls.y = FlxG.height - btnControls.height - 20;
		btnControls.onUp.sound = FlxG.sound.load(AssetPaths.select__wav);
		add(btnControls);
		
		// create and bind our save object to "shmup-sandbox"
		_save = new FlxSave();
		_save.bind("shmup-sandbox");
		
		// update our bar to show the current volume level
		updateVolume();
		
		FlxG.camera.fade(FlxColor.BLACK, .33, true);
		
		super.create();		
	}
	
	/**
	 * The user clicked the down button for volume - we reduce the volume by 10% and update the bar
	 */
	private function clickVolumeDown():Void
	{
		FlxG.sound.volume -= 0.1;
		_save.data.volume = FlxG.sound.volume;
		updateVolume();
	}
	
	/**
	 * The user clicked the up button for volume - we increase the volume by 10% and update the bar
	 */
	private function clickVolumeUp():Void
	{
		FlxG.sound.volume += 0.1;
		_save.data.volume = FlxG.sound.volume;
		updateVolume();
	}
	
	/**
	 * Whenever we want to show the value of volume, we call this to change the bar and the amount text
	 */
	private function updateVolume():Void
	{
		var vol:Int = Math.round(FlxG.sound.volume * 100);
		barVolume.value = vol;
		txtVolumeAmp.text = vol + "%";
	}
	
	private function clickClearData():Void
	{
		_save.erase();
		FlxG.sound.volume = .5;
		updateVolume();
		FlxG.fullscreen = false;
	}
	
	#if (desktop || flash)
	private function clickFullscreen():Void
	{
		FlxG.fullscreen = !FlxG.fullscreen;
		btnFullScreen.text = FlxG.fullscreen ? "No" : "Yes";
		_save.data.fullscreen = FlxG.fullscreen;
	}
	#end
	
	private function clickBack():Void
	{
		_save.close();
		FlxG.camera.fade(FlxColor.BLACK, .10, false, function()
		{
			FlxG.switchState(new states.MenuState());
		});
	}
	
	private function clickControls():Void
	{
		_save.close();
		FlxG.camera.fade(FlxColor.BLACK, .10, false, function()
		{
			FlxG.switchState(new ControlsState());
		});
	}
}
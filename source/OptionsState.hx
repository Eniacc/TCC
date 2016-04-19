package;

import flixel.FlxG;
import flixel.FlxState;
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
	private var txtTitle:FlxText;
	private var barMusicVolume:FlxBar;
	private var txtMusicVolume:FlxText;
	private var txtMusicVolumeAmt:FlxText;
	private var btnVolumeDown:FlxButton;
	private var btnVolumeUp:FlxButton;
	private var btnClearData:FlxButton;
	private var btnBack:FlxButton;
	private var btnResolution:FlxButton;
	#if desktop
	private var btnFullScreen:FlxButton;
	#end
	
	// a save object for saving settings
	private var _save:FlxSave;

	override public function create():Void
	{
		// setup and add our objects to the screen
		txtTitle = new FlxText(0, 20, 0, "Options", 40);
		txtTitle.alignment = CENTER;
		txtTitle.screenCenter(FlxAxes.X);
		add(txtTitle);
		
		txtMusicVolume = new FlxText(0, txtTitle.y + txtTitle.height + 10, 0, "Music Volume", 15);
		txtMusicVolume.alignment = CENTER;
		txtMusicVolume.screenCenter(FlxAxes.X);
		add(txtMusicVolume);
		
		// the volume buttons will be smaller than 'default' buttons
		btnVolumeDown = new FlxButton(8, txtMusicVolume.y + txtMusicVolume.height + 2, "-", clickVolumeDown);
		btnVolumeDown.loadGraphic(AssetPaths.button__png, true, 20,20);
		//btnVolumeDown.onUp.sound = FlxG.sound.load(AssetPaths.select__wav);
		add(btnVolumeDown);
		
		btnVolumeUp = new FlxButton(FlxG.width - 28, btnVolumeDown.y, "+", clickVolumeUp);
		btnVolumeUp.loadGraphic(AssetPaths.button__png, true, 20,20);
		//btnVolumeUp.onUp.sound = FlxG.sound.load(AssetPaths.select__wav);
		add(btnVolumeUp);
		
		barMusicVolume = new FlxBar(btnVolumeDown.x + btnVolumeDown.width + 4, btnVolumeDown.y, LEFT_TO_RIGHT, Std.int(FlxG.width - 64), Std.int(btnVolumeUp.height));
		barMusicVolume.createFilledBar(0xff464646, FlxColor.WHITE, true, FlxColor.WHITE);
		add(barMusicVolume);
		
		txtMusicVolumeAmt = new FlxText(0, 0, 200, (FlxG.sound.volume * 100) + "%", 8);
		txtMusicVolumeAmt.alignment = CENTER;
		txtMusicVolumeAmt.borderStyle = FlxTextBorderStyle.OUTLINE;
		txtMusicVolumeAmt.borderColor = 0xff464646;
		txtMusicVolumeAmt.y = barMusicVolume.y + (barMusicVolume.height / 2) - (txtMusicVolumeAmt.height / 2);
		txtMusicVolumeAmt.screenCenter(FlxAxes.X);
		add(txtMusicVolumeAmt);
		
		btnBack = new FlxButton(0, 0, "Back", clickBack);
		add(btnBack);
		btnResolution = new FlxButton(0, 20, "Res", clickChangeResolution);
		add(btnResolution);
		
		// create and bind our save object to "flixel-tutorial"
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
		barMusicVolume.value = vol;
		txtMusicVolumeAmt.text = vol + "%";
	}
	
	private function clickBack():Void
	{
		_save.close();
		FlxG.camera.fade(FlxColor.BLACK, .33, false, function()
		{
			FlxG.switchState(new MenuState());
		});
	}
	
	private function clickChangeResolution():Void
	{
		//FlxG.fullscreen = true;
		FlxG.resizeGame(1600, 900);
	}
}
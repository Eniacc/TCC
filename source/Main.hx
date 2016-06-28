package;

import flixel.FlxG;
import flixel.FlxGame;
import flixel.util.FlxSave;
import openfl.display.Sprite;
import states.PlayState;
import states.EditorState;
import states.MenuState;
import states.StageSelectState;

class Main extends Sprite
{
	public function new()
	{
		var startFullscreen:Bool = false;
		var skipSplash:Bool = true;
		var _save:FlxSave = new FlxSave();
		_save.bind("shmup-sandbox");
		
		super();
		
		Registry.init();
		
		addChild(new FlxGame(1280, 720, MenuState));
		
		FlxG.sound.muteKeys = FlxG.sound.volumeDownKeys = FlxG.sound.volumeUpKeys = null;
		
		if (_save.data.volume != null) {
			FlxG.sound.volume = _save.data.volume;
		}
		_save.close();
	}
}
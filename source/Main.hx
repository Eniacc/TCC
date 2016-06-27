package;

import flixel.FlxG;
import flixel.FlxGame;
import flixel.util.FlxSave;
import openfl.display.Sprite;
import playStateFolder.PlayState;
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
		
		if (_save.data.volume != null) {
			FlxG.sound.volume = _save.data.volume;
		}

		//FlxG.sound.playMusic(AssetPaths.Battle_Normal__ogg, 1, true);

		_save.close();
	}
}
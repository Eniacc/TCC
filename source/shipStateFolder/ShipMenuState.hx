package shipStateFolder;
import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;
import states.MenuState;

/**
 * ...
 * @author ...
 */
class ShipMenuState extends FlxState
{
	// define our screen elements
	private var txtTitle:FlxText;
	private var btnBack:FlxButton;

	override public function create():Void
	{
		// setup and add our objects to the screen
		txtTitle = new FlxText(0, 20, 0, "Ship Editor", 40);
		txtTitle.alignment = CENTER;
		txtTitle.screenCenter(FlxAxes.X);
		add(txtTitle);
		
		btnBack = new FlxButton(0, 0, "Back", clickBack);	
		btnBack.x = (FlxG.width / 2) - (btnBack.width / 2);
		btnBack.y = FlxG.height - btnBack.height - 20;
		add(btnBack);
		
		FlxG.camera.fade(FlxColor.BLACK, .33, true);
		
		super.create();
	}
	
	override public function destroy():Void
	{
		super.destroy();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
	
	private function clickBack():Void
	{
		FlxG.camera.fade(FlxColor.BLACK, .33, false, function()
		{
			FlxG.switchState(new states.MenuState());
		});
	}
	
}
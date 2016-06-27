package playStateFolder;

import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;
import states.MenuState;

/**
 * ...
 * @author Sidarta
 */
class OverlayState extends FlxSubState
{	
	private var closeBtn:FlxButton;
	private var exitGameBtn:FlxButton;
	private var txtTitle:FlxText;
	private var txtScore:FlxText;	
	
	public var isPersistant:Bool = false;
	public var score:Int;	
	public var endGameStatus:Int; // 0 - Game Over, 1 - Stage Complete
	
	override public function create():Void 
	{
		super.create();
		
		
		if (endGameStatus == 0) {
			txtTitle = new FlxText(0, (FlxG.height * 0.5) - 70, 0, "GAME OVER", 40);
			txtTitle.setBorderStyle(SHADOW, FlxColor.BLACK, 2, 2);
			txtTitle.alignment = CENTER;
			txtTitle.screenCenter(FlxAxes.X);
			add(txtTitle);			
			
			txtScore = new FlxText(0, (FlxG.height * 0.5), 0, "Final Score: " + Std.string(score), 30);			
			txtScore.setBorderStyle(SHADOW, FlxColor.BLACK, 2, 2);
			txtScore.alignment = CENTER;
			txtScore.screenCenter(FlxAxes.X);
			add(txtScore);		
			
			exitGameBtn = new FlxButton(0, txtScore.y + 100, "Exit to menu", clickExitGame);			
			exitGameBtn.x = (FlxG.width / 2) - (exitGameBtn.width / 2);
			add(exitGameBtn);
		}
		else if (endGameStatus == 1) {			
			txtTitle = new FlxText(0, (FlxG.height * 0.5) - 50, 0, "CONGRATULATIONS", 40);
			txtTitle.setBorderStyle(SHADOW, FlxColor.BLACK, 2, 2);
			txtTitle.alignment = CENTER;
			txtTitle.screenCenter(FlxAxes.X);
			add(txtTitle);		
			
			txtScore = new FlxText(0, (FlxG.height * 0.5), 0, "Final Score: " + Std.string(score), 30);			
			txtScore.setBorderStyle(SHADOW, FlxColor.BLACK, 2, 2);
			txtScore.alignment = CENTER;
			txtScore.screenCenter(FlxAxes.X);
			add(txtScore);		
			
			exitGameBtn = new FlxButton(0, txtScore.y + 100, "Exit to menu", clickExitGame);			
			exitGameBtn.x = (FlxG.width / 2) - (exitGameBtn.width / 2);
			add(exitGameBtn);
		}
		else {
			
			txtTitle = new FlxText(0, (FlxG.height * 0.5) - 70, 0, "GAME PAUSED", 40);
			txtTitle.setBorderStyle(SHADOW, FlxColor.BLACK, 2, 2);
			txtTitle.alignment = CENTER;
			txtTitle.screenCenter(FlxAxes.X);
			add(txtTitle);	
		
			closeBtn = new FlxButton(FlxG.width * 0.5 - 40, txtTitle.y +  txtTitle.height + 40, "Close", clickCloseMenu);
			add(closeBtn);
			
			exitGameBtn = new FlxButton(closeBtn.x, closeBtn.y + 40, "Exit to menu", clickExitGame);
			add(exitGameBtn);
			
		}
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
	
	private function clickCloseMenu() 
	{
		// if you will pass 'true' (which is by default) into close() method then this substate will be destroyed
		// but when you'll pass 'false' then you should destroy it manually
		close();
	}
	
	// This function will be called by substate right after substate will be closed
	public static function onSubstateClose():Void
	{
		//FlxG.fade(FlxG.BLACK, 1, true);
	}
	
	private function clickExitGame():Void {
		FlxG.camera.fade(FlxColor.BLACK, .10, false, function()
		{
			FlxG.switchState(new states.MenuState());
		});
	}
}
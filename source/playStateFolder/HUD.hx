package playStateFolder;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
using flixel.util.FlxSpriteUtil;

class HUD extends FlxTypedGroup<FlxSprite> {
	private var sprBack:FlxSprite;
	private var txtHealth:FlxText;
	private var txtScore:FlxText;
	private var txtMoney:FlxText;
	private var sprHealth:FlxSprite;
	private var sprMoney:FlxSprite;

	public function new() {
		super();
		
		// Add Health number to the HUD
		txtHealth = new FlxText(0, 50, 0, "3 / 3", 30);
		txtHealth.setBorderStyle(SHADOW, FlxColor.GRAY, 1, 1);
		txtHealth.x = (332 / 2) - (txtHealth.width / 2);
		//add(txtHealth);
		
		// Add Score number to the HUD
		txtScore = new FlxText(0, 50, 0, "SCORE: 0", 30);
		txtScore.setBorderStyle(SHADOW, FlxColor.GRAY, 1, 1);
		txtScore.x = Registry.maxXShip + 20;
		add(txtScore);
	}

	public function updateHUD(health:Int, score:Int):Void {
		txtHealth.text = Std.string(health) + " / 3";
		txtScore.text = "SCORE: " + Std.string(score);
	}
}
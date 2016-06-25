package editorView;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

/**
 * ...
 * @author Oelson TCS
 */
class TopBar extends FlxSpriteGroup
{
	public function new(?X:Float = 0, ?Y:Float = 0) 
	{
		super();
		
		this.x = X;
		this.y = Y;
		
		var background:FlxSprite = new FlxSprite();
		background.makeGraphic(1280, 40);
		FlxSpriteUtil.drawRect(background, 0, 0, 1280, 40, FlxColor.TRANSPARENT, {thickness:5});
		add(background);
		
		var labelWave:FlxText = new FlxText(0, 0, 0, "WAVES", 20);
		add(labelWave);
		var labelPath:FlxText = new FlxText(166, 0, 0, "PATH", 20);
		add(labelPath);
		var labelSprite:FlxText = new FlxText(332, 0, 0, "PATH SPRITE", 20);
		add(labelSprite);
		var labelStage:FlxText = new FlxText(664, 0, 0, "GAME STAGE", 20);
		add(labelStage);
		
		labelWave.color = labelPath.color = labelSprite.color = labelStage.color = FlxColor.BLACK;
		
		var btHome:FlxButton = new FlxButton(0, 0, "Title", gotoTitle);
		btHome.makeGraphic(83, 40, 0xFF000055);
		btHome.setPosition(background.width - btHome.width, 0);
		btHome.label = new FlxText(0, 0, btHome.width, "Title", 20);
		btHome.label.alignment = FlxTextAlign.CENTER;
		add(btHome);
	}
	
	function gotoTitle() 
	{
		FlxG.switchState(new MenuState());
	}
}
package editorView;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import haxe.Constraints.Function;
import states.MenuState;

/**
 * ...
 * @author Oelson TCS
 */
class TopBar extends FlxSpriteGroup
{
	public var callbackNew:Function;
	public var callbackImport:Function;
	public var callbackExport:Function;
	
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
		btHome.makeGraphic(90, 40, 0xFF000055);
		btHome.setPosition(background.width - btHome.width, 0);
		btHome.label = new FlxText(0, 0, btHome.width, "Title", 20);
		btHome.label.alignment = FlxTextAlign.CENTER;
		FlxSpriteUtil.drawRect(btHome, 0, 0, btHome.width, btHome.height, FlxColor.TRANSPARENT, {thickness:5});
		add(btHome);
		
		var btImport:FlxButton = new FlxButton(0, 0, "", importJsonHandler);
		btImport.makeGraphic(90, 40, 0xFF000055);
		btImport.setPosition(btHome.x - btImport.width, 0);
		btImport.label = new FlxText(0, 0, btImport.width, "Import", 20);
		btImport.label.alignment = FlxTextAlign.CENTER;
		FlxSpriteUtil.drawRect(btImport, 0, 0, btImport.width, btImport.height, FlxColor.TRANSPARENT, {thickness:5});
		add(btImport);
		
		var btExport:FlxButton = new FlxButton(0, 0, "", exportJsonHandler);
		btExport.makeGraphic(90, 40, 0xFF000055);
		btExport.setPosition(btImport.x - btExport.width, 0);
		btExport.label = new FlxText(0, 0, btExport.width, "Export", 20);
		btExport.label.alignment = FlxTextAlign.CENTER;
		FlxSpriteUtil.drawRect(btExport, 0, 0, btExport.width, btExport.height, FlxColor.TRANSPARENT, {thickness:5});
		add(btExport);
		
		var btNew:FlxButton = new FlxButton(0, 0, "", newProjectHandle);
		btNew.makeGraphic(90, 40, 0xFF000055);
		btNew.setPosition(btExport.x - btNew.width, 0);
		btNew.label = new FlxText(0, 0, btNew.width, "New", 20);
		btNew.label.alignment = FlxTextAlign.CENTER;
		FlxSpriteUtil.drawRect(btNew, 0, 0, btNew.width, btNew.height, FlxColor.TRANSPARENT, {thickness:5});
		add(btNew);
	}
	
	function newProjectHandle() 
	{
		callbackNew();
	}
	
	function exportJsonHandler() 
	{
		callbackExport();
	}
	
	function importJsonHandler() 
	{
		callbackImport();
	}
	
	function gotoTitle() 
	{
		FlxG.switchState(new states.MenuState());
	}
}
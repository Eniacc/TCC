package editorView;
import fileIO.FileIO;
import flixel.FlxSprite;
import flixel.addons.ui.FlxButtonPlus;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import openfl.display.BitmapData;


/**
 * ...
 * @author Oelson TCS
 */
class SelectionView extends FlxSpriteGroup
{
	public var background:FlxSprite;
	public var spriteBox:FlxSprite;
	//public var urlBox:FlxText;
	public var btSelect:FlxButtonPlus;
	
	private var defaultSprite:FlxSprite;
	
	public var fileIO:FileIO;
	
	public function new(?X:Float = 0, ?Y:Float = 0)
	{
		super();
		
		this.x = X;
		this.y = Y;
		
		fileIO = new FileIO(setSprite);
		
		background = new FlxSprite();
		background.makeGraphic(332, 220);
		FlxSpriteUtil.drawRect(background, 0, 0, background.x + background.width, background.y + background.height, FlxColor.TRANSPARENT, {thickness:5});
		add(background);
		
		spriteBox = new FlxSprite();
		spriteBox.makeGraphic(Std.int(background.width), Std.int(background.height - 30),FlxColor.TRANSPARENT);
		//FlxSpriteUtil.drawRect(spriteBox, 0, 0, spriteBox.width, spriteBox.height, FlxColor.TRANSPARENT, {thickness:5, color: FlxColor.YELLOW});
		add(spriteBox);
		
		//urlBox = new FlxText(0, spriteBox.height, 0, "url", 20);
		//urlBox.color = FlxColor.BLUE;
		//urlBox.set_clipRect(new FlxRect(urlBox.x, urlBox.y, background.width, 30));
		//add(urlBox);

		btSelect = new FlxButtonPlus(3, spriteBox.height-3, fileIO.browseSprite, "Select", Std.int(background.width-6), 30);
		btSelect.borderColor = FlxColor.BLACK;
		btSelect.updateActiveButtonColors([0xFF000055, 0xFF000055]);
		btSelect.updateInactiveButtonColors([0xFF000022, 0xFF000022]);
		add(btSelect);
		trace('bt', btSelect.x, btSelect.y, btSelect.width, btSelect.height);
		
		defaultSprite = new FlxSprite(0, 0, AssetPaths.Bot__png);
		setSprite(defaultSprite.pixels);
	}
	
	function setSprite(bitmapData:BitmapData, url:String = "")
	{
		var imgWidth:Float = background.width / bitmapData.width;
		var imgHeight:Float = background.height / bitmapData.height;
		
		var scale:Float = imgWidth <= imgHeight ? imgWidth : imgHeight;
		
		if (scale > 1) scale = 1;
		
		spriteBox.scale = new FlxPoint(scale, scale);
		//urlBox.text = url;
		
		spriteBox.x = (background.x + background.width / 2) - bitmapData.width/2;
		spriteBox.y = (background.y + (background.height - btSelect.height) / 2) - bitmapData.height/2;
		
		spriteBox.pixels = bitmapData;
	}
}
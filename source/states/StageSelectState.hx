package states;

import editorView.EditorButton;
import fileIO.JsonIO;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import playStateFolder.PlayState;

/**
 * ...
 * @author Oelson TCS
 */
class StageSelectState extends FlxState
{
	override public function create():Void
	{
		super.create();
		
		var message:FlxText = new FlxText(0, 0, 0, "STAGE SELECT", 40);
		message.setPosition(FlxG.width / 2 -message.width / 2, message.height);
		//message.color = 0xFF000055;
		add(message);
		
		var listBG:FlxSprite = new FlxSprite();
		listBG.makeGraphic(800, 500);
		listBG.setPosition(FlxG.width / 2 - listBG.width / 2, message.y + message.height + 50);
		FlxSpriteUtil.drawRect(listBG, 0, 0, listBG.width, listBG.height, FlxColor.TRANSPARENT, {thickness:5});
		add(listBG);
		
		var btImport:EditorButton = new EditorButton(0, 0, "IMPORT", importStage);
		btImport.setPosition(FlxG.width / 2 - btImport.width / 2, FlxG.height - btImport.height);
		add(btImport);
		
		var btPlay:EditorButton = new EditorButton(0, 0, "PLAY", playStageHandler);
		btPlay.setPosition(FlxG.width - btPlay.width, FlxG.height - btPlay.height);
		add(btPlay);
		
		var btBack:EditorButton = new EditorButton(0, 0, "BACK", backToMenu);
		btBack.setPosition(0, FlxG.height - btBack.height);
		add(btBack);
		
		for (i in 0...6)
		{
			var fase:FlxText = new FlxText(0, 0, 0, "Fase " + i, 20);
			fase.setPosition(listBG.x + listBG.width / 2 - fase.width / 2, listBG.y + fase.height * i + 10);
			fase.color = FlxColor.BLACK;
			add(fase);
		}
	}
	
	function playStageHandler() 
	{
		
	}
	
	function backToMenu() 
	{
		FlxG.switchState(new MenuState());
	}
	
	function playStage(json:Dynamic) 
	{
		Registry.stage = JsonIO.gamify(json);
		FlxG.switchState(new PlayState());
	}
	
	function importStage() 
	{
		var jsonIO:JsonIO = new JsonIO(playStage);
		jsonIO.browse();
	}
	
}
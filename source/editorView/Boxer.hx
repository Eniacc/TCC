package editorView;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import haxe.Constraints.Function;
//import ibwwg.FlxScrollableArea;
import model.Pathway;
import model.Wave;
import model.Waypoint;
import openfl.Lib;

/**
 * ...
 * @author Oelson TCS
 */
class Boxer extends FlxSpriteGroup
{
	var boxes:FlxTypedSpriteGroup<Box>;
	var btNew:FlxButton;
	var btRemove:FlxButton;
	var background:FlxSprite;
	
	var callbackAdd:Function;
	var callbackRemove:Function;
	var callbackSelect:Function;
	var currentSelected:Int = 0;
	
	var btDrag:FlxSprite;
	var btRange:FlxRect;
	var dragging:Bool = false;
	
	//var scrollable:FlxScrollableArea;

	public function new(?X:Float = 0, ?Y:Float = 0)
	{
		super();
		
		this.x = X;
		this.y = Y;
		
		background = new FlxSprite();
		background.makeGraphic(166, 680);
		FlxSpriteUtil.drawRect(background, 0, 0, background.width, background.height, FlxColor.TRANSPARENT, {thickness:5});
		add(background);
		
		boxes = new FlxTypedSpriteGroup<Box>();
		add(boxes);
		
		btDrag = new FlxSprite();
		btDrag.makeGraphic(20, 40, FlxColor.YELLOW);
		btDrag.setPosition(background.width - btDrag.width, 0);
		add(btDrag);
		
		btNew = new FlxButton(0, 0, "NEW", addBoxHandler);
		btNew.makeGraphic(83, 40, 0xFF000055);
		btNew.setPosition(0, background.height - btNew.height);
		btNew.label = new FlxText(0, 0, btNew.width, "NEW", 20);
		btNew.label.alignment = FlxTextAlign.CENTER;
		FlxSpriteUtil.drawRect(btNew, 0, 0, btNew.width, btNew.height, FlxColor.TRANSPARENT, {thickness:5});
		add(btNew);
		
		btRemove = new FlxButton(0, 0, "REMOVE", removeBoxHandler);
		btRemove.makeGraphic(83, 40, 0xFF000055);
		btRemove.setPosition(btNew.width, background.height - btRemove.height);
		btRemove.label = new FlxText(0, 0, btNew.width, "REMOVE", 14);
		btRemove.label.alignment = FlxTextAlign.CENTER;
		FlxSpriteUtil.drawRect(btRemove, 0, 0, btRemove.width, btRemove.height, FlxColor.TRANSPARENT, {thickness:5});
		add(btRemove);
		
		btRange = new FlxRect(0, btDrag.y, 0, btDrag.y + background.height - btDrag.height - btNew.height);
	}
	
	function addBoxHandler() 
	{
		if(!dragging) callbackAdd();
	}
	
	function removeBoxHandler() 
	{
		if(!dragging) callbackRemove();
		//removeBox(boxes.members[currentSelected]);
	}
	
	//public function setSelected(box:Box) 
	public function setSelected(currentSelected:Int) 
	{
		//boxes.forEachExists(function(b:Box)
		//{
			//b.selection.visible = false;
		//});
		//
		//box.selection.visible = true;
		if (currentSelected < 0) currentSelected = 0;
		else if (currentSelected >= boxes.length) currentSelected = boxes.length - 1;
		this.currentSelected = currentSelected;
		for (i in 0...boxes.members.length)
		{
			boxes.members[i].selection.visible = i == this.currentSelected;
		}
	}
	
	public function addBox(box:Box)
	{
		box.y = boxes.length * box.background.height;
		//box.id = boxes.length;
		//box.clickCallback = callbackSelect;
		boxes.add(box);
	}
	
	public function removeBox(box:Box)
	{
		trace('boxes', boxes.length, boxes.members.length, boxes.members.indexOf(box));
		if(boxes.members.length > 1) boxes.remove(box, true);
		//boxes.remove(box);
	}
	
	public function clearBoxes() 
	{
		boxes.clear();
		//btDrag.y = btRange.y;
		//while(boxes.length > 0)
		//{
			//boxes.remove(boxes.members.pop());
		//}
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		if (FlxG.mouse.justPressed)
		{
			if (!FlxG.mouse.overlaps(btNew) && !FlxG.mouse.overlaps(btRemove))
			{
				if (FlxG.mouse.overlaps(btDrag))
				{
					dragging = true;
				}
				else if(FlxG.mouse.overlaps(boxes))
				{
					//boxes.forEachExists(function(box:Box)
					for (i in 0...boxes.members.length)
					{
						if (FlxG.mouse.overlaps(boxes.members[i]))
						{
							//setSelected(box);
							//callbackSelect(boxes.members.indexOf(box));
							//break;
							currentSelected = i;
							setSelected(currentSelected);
							callbackSelect(currentSelected);
							break;
						}
					}
					//);
				}
			}
		}
		
		if (dragging)
		{
			btDrag.y = FlxMath.maxAdd(0, Std.int(FlxG.mouse.y - btDrag.height * .5), Std.int(btRange.height), Std.int(btRange.y));
		}
		positionBoxes();
		if (FlxG.mouse.justReleased) dragging = false;
	}
	
	function positionBoxes() 
	{
		var contentRange:Float = background.height - boxes.height - btNew.height;
		if (contentRange >= 0)
		{
			boxes.y = btRange.y;
			btDrag.visible = false;
		}
		else
		{
			btDrag.visible = true;
			boxes.y = btRange.y + (((btDrag.y - 40) / (btRange.height - 40)) * contentRange);
		}
	}
}
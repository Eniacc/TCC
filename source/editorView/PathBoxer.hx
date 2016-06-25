package editorView;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import haxe.Constraints.Function;
import model.Path;
import model.Waypoint;

/**
 * ...
 * @author Oelson TCS
 */
class PathBoxer extends Boxer
{
	public function new(callbackAdd:Function, callbackRemove:Function, callbackSelect:Function, ?X:Float = 0, ?Y:Float = 0) 
	{
		super(X, Y);
		this.callbackAdd = callbackAdd;
		this.callbackRemove = callbackRemove;
		this.callbackSelect = callbackSelect;
	}
	
	public function loadPaths(paths:FlxTypedGroup<Path>)
	{
		clearBoxes();
		
		for (j in 0...paths.members.length)
		{
			var box:Box = new Box();
			//var path:Path = paths.members[j];
			//var boxPaths:FlxTypedGroup<Path> = new FlxTypedGroup<Path>();
			//boxPaths.add(paths.members[j]);
			box.paths.add(paths.members[j]);
			//for (k in 0...path.members.length)
			//{
				//var waypoint:Waypoint = path.members[k];
				//var wpPoint:FlxSprite = new FlxSprite(waypoint.xPer * box.width, waypoint.yPer * box.height);
				//wpPoint.makeGraphic(10, 10, FlxColor.RED);
				//box.waypoints.add(wpPoint);
			//}
			addBox(box);
		}
	}
}
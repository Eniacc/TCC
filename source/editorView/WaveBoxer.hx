package editorView;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import haxe.Constraints.Function;
import model.Path;
import model.Wave;
import model.Waypoint;

/**
 * ...
 * @author Oelson TCS
 */
class WaveBoxer extends Boxer
{
	public function new(callbackAdd:Function, callbackRemove:Function, callbackSelect:Function, ?X:Float = 0, ?Y:Float = 0) 
	{
		super(X, Y);
		this.callbackAdd = callbackAdd;
		this.callbackRemove = callbackRemove;
		this.callbackSelect = callbackSelect;
	}
	
	public function loadWaves(waves:FlxTypedGroup<Wave>)
	{
		clearBoxes();
		
		//for (i in 0...waves.members.length)
		waves.forEachExists(function(w:Wave)
		{
			var box:Box = new Box();
			//var paths:FlxTypedGroup<Path> = waves.members[i];
			var paths:FlxTypedGroup<Path> = w;
			//box.paths = waves.members[i];
			//for (j in 0...paths.members.length)
			paths.forEachExists(function(p:Path)
			{
				//var path:Path = paths.members[j];
				//box.paths.add(path);
				box.paths.add(p);
				//box.waypoints = path.members;
				//for (k in 0...path.members.length)
				//{
					//var waypoint:Waypoint = path.members[k];
					//var wpPoint:FlxSprite = new FlxSprite(waypoint.xPer * box.width, waypoint.yPer * box.height);
					//wpPoint.makeGraphic(10, 10, FlxColor.RED);
					//box.waypoints.add(wpPoint);
				//}
			});
			addBox(box);
		});
	}
}
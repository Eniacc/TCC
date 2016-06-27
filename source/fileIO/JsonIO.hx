package fileIO;
import editorView.PathBoxer;
import flash.net.URLRequest;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import haxe.Constraints.Function;
import haxe.Json;
import model.Path;
import model.Wave;
import model.Waypoint;
import openfl.display.Bitmap;
import openfl.display.Loader;
import openfl.display.LoaderInfo;
import openfl.events.Event;
import openfl.net.FileFilter;
import openfl.net.FileReference;
import openfl.net.URLLoader;

#if (cpp||neko)
import systools.Dialogs;
#end

/**
 * ...
 * @author Oelson
 */
class JsonIO
{
	private var callback:Function;

	public function new(callback:Function) 
	{
		this.callback = callback;
		
		#if sys
		trace("yup");
		#end
	}
	
	#if flash
	public function browse() 
	{
		var fr:FileReference = new FileReference();
		var filters:Array<FileFilter> = new Array<FileFilter>();
		filters.push(new FileFilter("JSON File", "*.json;"));
		fr.browse(filters);
		fr.addEventListener(Event.SELECT, onSelect);
	}
	
	private function onSelect(e:Event):Void 
	{
		var fr:FileReference = cast(e.target, FileReference);
		fr.addEventListener(Event.COMPLETE, onLoad);
		fr.load();
	}
	
	private function onLoad(e:Event):Void 
	{
		var fr:FileReference = e.target;
		fr.removeEventListener(Event.COMPLETE, onLoad);
		
		//var json:String = cast(loaderInfo.content, String);
		//trace('onLoad:',fr.data);
		var json:String = fr.data.toString();
		//trace('onLoad:',json);
		load(json);
	}
	
	#elseif(cpp || neko)
	public function browse() 
	{
		var filters:FILEFILTERS = {count:1, descriptions: ["JSON File"], extensions: ["*.json"]};
		var result:Array<String> = Dialogs.openFile("Select a stage!", "JSON File", filters);
		onSelect(result);
	}
	
	private function onSelect(arr:Array<String>):Void
	{
		trace("Enter Neko onSelect");
		trace(arr);
		//if (arr != null && arr.length > 0)
		//{
			//var img =
			//#if lime_legacy
				//BitmapData.load(arr[0]);
			//#else
				//BitmapData.fromFile(arr[0]);
			//#end
			//
			//if (img != null) 
			//{
				//callback(img, arr[0]);
			//}
		//}
	}
	#end
	
	public function save(waves:FlxTypedGroup<Wave>)
	{
		//var json:String = Json.stringify(waves);
		var json:String;
		json = "{\"waves\":[";
		for (i in 0...waves.members.length)
		{
			//json.waves[i] = "Wave" + i;
			json += "{\"wave\":[";
			var wave:Wave = waves.members[i];
			for (j in 0...wave.members.length)
			{
				json += "{\"path\":[";
				var path:Path = wave.members[j];
				for (k in 0...path.members.length)
				{
					var wp:Waypoint = path.members[k];
					json += "{\"waypoint\":{";
					json += "\"xPer\":" + wp.xPer;
					json += ",\"yPer\":" + wp.yPer;
					json += ",\"rotation\":" + wp.rotation;
					json += ",\"rateOfFire\":" + wp.rateOfFire;
					json += ",\"speed\":" + wp.speed;
					json += ",\"wait\":" + wp.wait;
					json += ",\"numShips\":" + wp.numShips;
					json += ",\"interval\":" + wp.interval;
					json += "}}";
					if (k < path.members.length - 1) json += ",";
				}
				json += "]}";
				if (j < wave.members.length - 1) json += ",";
			}
			json += "]}";
			if (i < waves.members.length - 1) json += ",";
		}
		json += "]}";
		
		var jsonDyn:Dynamic = Json.parse(json);
		var jsonCheck:String = Json.stringify(jsonDyn, null, "   ");
		//trace(jsonCheck);
		
		#if flash
		var fr:FileReference = new FileReference();
		fr.save(json, "fase.json");
		#end
	}
	
	public function load(json:String)
	{
		try
		{
			var jsond:Dynamic = Json.parse(json);
			//trace('load:', json);
			callback(jsond);
		}
		catch (msg:String)
		{
			FlxG.log.add("Error " + msg);
		}
	}
	
	private function replacer(key:Dynamic, value:Dynamic):Dynamic {
		FlxG.log.add("keyvalue: "+ key + " ----> " + value);
		if (key == "members" || key == "xPer" || key == "rotation") {
			return value;
		}
		return "";
	}
	
	static public function gamify(json:Dynamic):FlxTypedGroup<Wave>
	{
		var waves:FlxTypedGroup<Wave> = new FlxTypedGroup<Wave>();
		//trace(json);
		
		var jstage:{waves:Array<Dynamic>} = json;
		for (stage in jstage.waves)
		{
			//trace(stage);
			var realWave:Wave = new Wave();
			var jwaves:{wave:Array<Dynamic>} = stage;
			for (wave in jwaves.wave)
			{
				//trace(wave);
				var realPath:Path = new Path();
				var jpaths:{path:Array<Dynamic>} = wave;
				for (path in jpaths.path)
				{
					//trace(path);
					var jwaypoints:{waypoint:Dynamic} = path;
					var waypoint:{	xPer:Float,
									yPer:Float,
									rotation:Float,
									wait:Float,
									speed:Float,
									rateOfFire:Float,
									numShips:Int,
									interval:Float } = jwaypoints.waypoint;
					var wp:Waypoint = new Waypoint();
					wp.xPer = waypoint.xPer;
					wp.yPer = waypoint.yPer;
					wp.rotation = waypoint.rotation;
					wp.wait = waypoint.wait;
					wp.speed = waypoint.speed;
					wp.rateOfFire = waypoint.rateOfFire;
					wp.numShips = waypoint.numShips;
					wp.interval = waypoint.interval;
					realPath.add(wp);
				}
				realWave.add(realPath);
			}
			waves.add(realWave);
		}
		
		return waves;
	}
}
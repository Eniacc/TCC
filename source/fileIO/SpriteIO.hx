package fileIO;
import flixel.FlxG;
import haxe.Constraints.Function;
import openfl.display.BitmapData;
#if flash
import openfl.display.Bitmap;
import openfl.display.Loader;
import openfl.display.LoaderInfo;
import openfl.events.Event;
import openfl.net.FileReference;
#elseif (cpp || neko)
import systools.Dialogs;
#end
import openfl.net.FileFilter;
import openfl.net.URLRequest;

/**
 * ...
 * @author Oelson TCS
 */
class SpriteIO
{
	private var callback:Function;

	public function new(callback:Function) 
	{
		this.callback = callback;
	}
	
	
	public function browse() 
	{
		#if flash
			var fr:FileReference = new FileReference();
			var filters:Array<FileFilter> = new Array<FileFilter>();
			filters.push(new FileFilter("Image File", "*.png;*.jpg;*.jpeg;*.bmp"));
			fr.browse(filters);
			fr.addEventListener(Event.SELECT, onSelect);
		#elseif (cpp || neko)
			trace("Enter Neko");
			var filters: FILEFILTERS = {count:2, descriptions: ["Image files"], extensions: ["*.png;*.jpg;*.jpeg;"]};
			trace("Enter Neko2");
			var result:Array<String> = Dialogs.openFile("Select a sprite!", "Sprite Image", filters);
			trace("Enter Neko3");
			onSelect(result);
		#end
	}
	
	#if flash
	public function loadUrl(url:String)
	{
		var urlReq:URLRequest = new URLRequest(url);
		var loader:Loader = new Loader();
		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImgLoad);
		loader.load(urlReq);
	}
	
	private function onSelect(e:Event):Void 
	{
		var fr:FileReference = cast(e.target, FileReference);
		FlxG.log.add(fr.);
		fr.addEventListener(Event.COMPLETE, onLoad);
		fr.load();
	}
	
	private function onLoad(e:Event):Void 
	{
		var fr:FileReference = e.target;
		fr.removeEventListener(Event.COMPLETE, onLoad);
		
		var loader:Loader = new Loader();
		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImgLoad);
		loader.loadBytes(fr.data);
	}
	
	private function onImgLoad(e:Event):Void 
	{
		var loaderInfo:LoaderInfo = e.target;
		loaderInfo.removeEventListener(Event.COMPLETE, onImgLoad);
		var bmp:Bitmap = cast(loaderInfo.content, Bitmap);
		FlxG.log.add('img '+loaderInfo.url);
		callback(bmp.bitmapData, loaderInfo.url);
	}
	#elseif (cpp || neko)
	private function onSelect(arr:Array<String>):Void
	{
		trace("Enter Neko onSelect");
		if (arr != null && arr.length > 0)
		{
			var img =
			#if lime_legacy
				BitmapData.load(arr[0]);
			#else
				BitmapData.fromFile(arr[0]);
			#end
			
			if (img != null) 
			{
				callback(img, arr[0]);
			}
		}
	}
	#end
}
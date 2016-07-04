package states;

import editorView.BottomBar;
import editorView.PathBoxer;
import editorView.SelectionView;
import editorView.StageView;
import editorView.TopBar;
import editorView.WarningSubState;
import editorView.WaveBoxer;
import editorView.WaypointView;
import fileIO.JsonIO;
import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxRect;
import model.Bot;
import model.Pathway;
import model.Wave;
import model.Waypoint;

/**
 * ...
 * @author Oelson TCS
 */
class EditorState extends FlxState
{
	var stage:StageView;
	var waveBoxer:WaveBoxer;
	var pathBoxer:PathBoxer;
	var waypointView:WaypointView;
	var selectionView:SelectionView;
	var topBar:TopBar;
	var bottomBar:BottomBar;
	
	var waves:FlxTypedGroup<Wave>;
	var currentWave:Int = 0;
	var currentPath:Int = 0;

	override public function create():Void
	{
		Registry.inEditor = true;
		
		stage = new StageView(664, 40, .7);
		stage.callbackSelected = displayWaypointData;
		add(stage);
		
		bottomBar = new BottomBar(0, 680);
		bottomBar.callbackPlayStop = playStopPath;
		add(bottomBar);
		
		waveBoxer = new WaveBoxer(addWave, removeWave, selectWave, 0, 40);
		add(waveBoxer);
		
		pathBoxer = new PathBoxer(addPath, removePath, selectPath, waveBoxer.width, 40);
		add(pathBoxer);
		
		//waypointView = new WaypointView(25,41,32,25);
		//waypointView = new WaypointView(332/FlxG.width*100,340/FlxG.height*100,420/FlxG.height*100,332/FlxG.width*100);
		waypointView = new WaypointView(332, 260);
		add(waypointView);
		
		selectionView = new SelectionView(332, 40);
		#if (cpp || neko)
		selectionView.callbackSetPathURL = setPathURL;
		#end
		add(selectionView);
		
		topBar = new TopBar(0, 0);
		topBar.callbackExport = exportJson;
		topBar.callbackImport = function(){openSubState(new WarningSubState(0x99808080, "You'll lose any unsaved data!\nContinue?", importJson)); }
		topBar.callbackNew = function(){openSubState(new WarningSubState(0x99808080, "You'll lose any unsaved data!\nContinue?", newStage)); }
		topBar.callbackExit = function(){openSubState(new WarningSubState(0x99808080, "You'll lose any unsaved data!\nContinue?", gotoTitle)); }
		add(topBar);
		
		//testCreate();
		waves = new FlxTypedGroup<Wave>();
		addWave();
	}
	
	function gotoTitle() 
	{
		FlxG.switchState(new states.MenuState());
	}
	
	function setPathURL(url:String) 
	{
		var path:Pathway = waves.members[currentWave].members[currentPath];
		path.spriteURL = url;
	}
	
	function exportJson() 
	{
		var jsonIO:JsonIO = new JsonIO(null);
		jsonIO.save(waves);
	}
	
	function importJson() 
	{
		waveBoxer.clearBoxes();
		pathBoxer.clearBoxes();
		var jsonIO:JsonIO = new JsonIO(loadWaves);
		jsonIO.browse();
	}
	
	function loadWaves(json:Dynamic)
	{
		this.waves = JsonIO.gamify(json);
		waveBoxer.loadWaves(this.waves);
		selectWave(0);
		selectPath(0);
	}
	
	function newStage():Void
	{
		FlxG.switchState(new EditorState());
	}
	
	function displayWaypointData(waypoint:Waypoint, index:Int = 0) 
	{
		waypointView.loadWaypoint(waypoint, index);
	}
	
	function playStopPath(play:Bool = false)
	{
		stage.test(play);
	}
	
	function addWave()
	{
		var wave:Wave = new Wave();
		wave.add(new Pathway());
		waves.add(wave);
		
		currentWave = wave.length - 1;
		//waveBoxer.loadWaves(waves);
		selectWave(currentWave);
	}
	
	function addPath()
	{
		waves.members[currentWave].add(new Pathway());
		currentPath = waves.members[currentWave].members.length - 1;
		//pathBoxer.loadPaths(waves.members[currentWave]);
		selectPath(currentPath);
	}
	
	function removeWave()
	{
		waves.remove(waves.members[currentWave], true);
		if (currentWave > waves.members.length - 1) currentWave--;
		if (waves.members.length <= 0) addWave();
		else selectWave(currentWave);
	}
	
	function removePath()
	{
		var paths:FlxTypedGroup<Pathway> = waves.members[currentWave];
		trace(paths.length, paths.members.length);
		paths.remove(paths.members[currentPath], true);
		trace(paths.length, paths.members.length);
		if (currentPath > paths.members.length - 1) currentPath--;
		if (paths.members.length <= 0) addPath();
		else selectPath(currentPath);
	}
	
	function selectWave(index:Int) 
	{
		waveBoxer.loadWaves(waves);
		trace('SELECT WAVE', index);
		currentWave = index;
		waveBoxer.setSelected(currentWave);
		pathBoxer.loadPaths(waves.members[index]);
		selectPath(0);
	}
	
	function selectPath(index:Int)
	{
		pathBoxer.loadPaths(waves.members[currentWave]);
		trace('SELECT PATH', index);
		currentPath = index;
		pathBoxer.setSelected(currentPath);
		stage.loadPath(waves.members[currentWave].members[index]);
		//selectionView.fileIO.loadUrl(waves.members[currentWave].members[index].spriteURL);
		bottomBar.setPlay(false);
	}
	
	function testCreate() 
	{
		waves = new FlxTypedGroup<Wave>();
		for (i in 0...FlxG.random.int(1,5)) 
		{
			var wave:Wave = new Wave();
			for (i in 0...FlxG.random.int(5,10)) 
			{
				var path:Pathway = new Pathway();
				for (i in 0...FlxG.random.int(1,5))
				{
					var waypoint:Waypoint = new Waypoint();
					waypoint.xPer = FlxG.random.float(0, 1);
					waypoint.yPer = FlxG.random.float(0, 1);
					waypoint.rotation = FlxG.random.int(0, 360);
					waypoint.speed = FlxG.random.float(0.3,3);
					waypoint.wait = FlxG.random.int(0, 2);
					waypoint.rateOfFire = FlxG.random.float(0, 2);
					path.add(waypoint);
					//trace("Waypoints:" + path.length);
				}
				//path.spawnBots();
				wave.add(path);
				//trace("Paths:" + wave.length);
			}
			waves.add(wave);
			//trace("Waves:" + waves.length);
		}
		
		waveBoxer.loadWaves(waves);
		currentWave = 0;
		selectWave(currentWave);
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
	}
}
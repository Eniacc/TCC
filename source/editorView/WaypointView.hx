package editorView;
import flixel.FlxG;
import flixel.FlxG.FlxRenderMethod;
import flixel.FlxSprite;
import flixel.addons.ui.FlxInputText;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxRect;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import haxe.Constraints.Function;
import model.Waypoint;
import openfl.text.TextField;

/**
 * ...
 * @author Oelson TCS
 */
class WaypointView extends FlxSpriteGroup
{
	public var callback:Function;
	
	public var xField:FormItem;
	public var yField:FormItem;
	public var rotationField:FormItem;
	public var speedField:FormItem;
	public var waitField:FormItem;
	public var rateOfFireField:FormItem;
	public var numShipsField:FormItem;
	public var intervalField:FormItem;
	private var formGroup:FlxTypedSpriteGroup<FormItem>;
	
	public var background:FlxSprite;
	private var marginRect:FlxRect = new FlxRect(20, 20, 312);
	
	private var waypoint:Waypoint;

	//public function new(?Xp:Float = 0, ?Yp:Float = 0, ?Hp:Float = 100, ?Wp:Float = 100)
	public function new(?X:Float = 0, ?Y:Float = 0)
	{
		//super(Xp,Yp,Hp,Wp);
		super();
		
		this.x = X;
		this.y = Y;
		
		background = new FlxSprite();
		background.makeGraphic(332, 420);
		FlxSpriteUtil.drawRect(background, 0, 0, 332, 420, FlxColor.TRANSPARENT, {thickness:5});
		add(background);
		
		xField = new FormItem(marginRect, "Horizontal %");
		yField = new FormItem(marginRect, "Vertical %");
		rotationField = new FormItem(marginRect, "Rotation");
		speedField = new FormItem(marginRect, "Speed");
		waitField = new FormItem(marginRect, "Wait");
		rateOfFireField = new FormItem(marginRect, "Rate of Fire");
		numShipsField = new FormItem(marginRect, "Ships");
		intervalField = new FormItem(marginRect, "Interval");
		
		formGroup= new FlxTypedSpriteGroup();
		formGroup.add(xField);
		formGroup.add(yField);
		formGroup.add(rotationField);
		formGroup.add(speedField);
		formGroup.add(waitField);
		formGroup.add(rateOfFireField);
		formGroup.add(numShipsField);
		formGroup.add(intervalField);
		
		for (i in 0...formGroup.length)
		{
			formGroup.members[i].disable();
			formGroup.members[i].x = marginRect.x;
			formGroup.members[i].y = marginRect.y;
			if (i > 0) formGroup.members[i].y += formGroup.members[i - 1].y + formGroup.members[i - 1].height;
		}
		
		add(formGroup);
	}
	
	public function loadWaypoint(waypoint:Waypoint)
	{
		this.waypoint = waypoint;
		if (waypoint != null)
		{
			for (i in 0...formGroup.length) formGroup.members[i].enable();
			xField.value = waypoint.xPer * 100;
			yField.value = waypoint.yPer * 100;
			rotationField.value = waypoint.rotation;
			speedField.value = waypoint.speed;
			waitField.value = waypoint.wait;
			rateOfFireField.value = waypoint.rateOfFire;
			numShipsField.value = waypoint.numShips;
			intervalField.value = waypoint.interval;
		}else{
			for (i in 0...formGroup.length) formGroup.members[i].disable();
		}
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		if (waypoint != null)
		{
			waypoint.xPer = xField.value / 100;
			waypoint.yPer = yField.value / 100;
			waypoint.rotation = rotationField.value;
			waypoint.speed = speedField.value;
			waypoint.wait = waitField.value;
			waypoint.rateOfFire = rateOfFireField.value;
			waypoint.numShips = Std.int(numShipsField.value);
			waypoint.interval = intervalField.value;
			
			if (Math.isNaN(waypoint.xPer)) waypoint.xPer = Waypoint.defaultXPer; 
			if (Math.isNaN(waypoint.yPer)) waypoint.yPer= Waypoint.defaultYPer; 
			if (Math.isNaN(waypoint.rotation)) waypoint.rotation = Waypoint.defaultrotation; 
			if (Math.isNaN(waypoint.speed)) waypoint.speed = Waypoint.defaultSpeed; 
			if (Math.isNaN(waypoint.wait)) waypoint.wait = Waypoint.defaultWait; 
			//if (Math.isNaN(waypoint.numShips)) waypoint.numShips = Waypoint.defaultNumShip; 
			if (Math.isNaN(waypoint.interval)) waypoint.interval = Waypoint.defaultInterval; 
		}
	}
	
	//public function getWaypoint():Waypoint
	//{
		//var waypoint:Waypoint = new Waypoint();
		//waypoint.xPer = xField.value;
		//waypoint.yPer = yField.value;
		//waypoint.rotation = rotationField.value;
		//waypoint.speed = speedField.value;
		//waypoint.wait = waitField.value;
		//waypoint.rateOfFire = rateOfFireField.value;
		//waypoint.numShips = Std.int(numShipsField.value);
		//waypoint.interval = intervalField.value;
		//
		//return waypoint;
	//}
}
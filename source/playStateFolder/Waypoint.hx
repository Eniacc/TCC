package playStateFolder;

/**
 * ...
 * @author ...
 */
class Waypoint
{
	private var x(get, set):Int;
	private var y(get, set):Int;
	private var rotation(get, set):Int;
	private var rateOfFire(get, set):Float;
	private var fire(get, set):Bool;
	private var speed(get, set):Float;
	private var wait(get, set):Float;

	public function new() 
	{
		
	}
	
	function get_x():Int 
	{
		return x;
	}
	
	function set_x(value:Int):Int 
	{
		return x = value;
	}
	
	function get_y():Int 
	{
		return y;
	}
	
	function set_y(value:Int):Int 
	{
		return y = value;
	}
	
	function get_rotation():Int 
	{
		return rotation;
	}
	
	function set_rotation(value:Int):Int 
	{
		return rotation = value;
	}
	
	function get_rateOfFire():Float 
	{
		return rateOfFire;
	}
	
	function set_rateOfFire(value:Float):Float 
	{
		return rateOfFire = value;
	}
	
	function get_fire():Bool 
	{
		return fire;
	}
	
	function set_fire(value:Bool):Bool 
	{
		return fire = value;
	}
	
	function get_speed():Float 
	{
		return speed;
	}
	
	function set_speed(value:Float):Float 
	{
		return speed = value;
	}
	
	function get_wait():Float 
	{
		return wait;
	}
	
	function set_wait(value:Float):Float 
	{
		return wait = value;
	}
	
}
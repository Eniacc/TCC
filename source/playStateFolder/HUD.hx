package playStateFolder;

 import flixel.FlxBasic;
 import flixel.FlxG;
 import flixel.FlxSprite;
 import flixel.group.FlxGroup;
 import flixel.text.FlxText;
 import flixel.util.FlxColor;
 using flixel.util.FlxSpriteUtil;

 class HUD extends FlxTypedGroup<FlxSprite>
 {
     private var _sprBack:FlxSprite;
     private var _txtHealth:FlxText;
     private var _txtScore:FlxText;
     private var _txtMoney:FlxText;
     private var _sprHealth:FlxSprite;
     private var _sprMoney:FlxSprite;

     public function new()
     {
         super();
         //_sprBack = new FlxSprite().makeGraphic(FlxG.width, 20, FlxColor.BLACK);
         //_sprBack.drawRect(0, 19, FlxG.width, 1, FlxColor.WHITE);
         _txtHealth = new FlxText(20, 20, 0, "3 / 3", 30);
         _txtHealth.setBorderStyle(SHADOW, FlxColor.GRAY, 1, 1);
         //_txtMoney = new FlxText(0, 2, 0, "0", 8);
         //_txtMoney.setBorderStyle(SHADOW, FlxColor.GRAY, 1, 1);
         //_sprHealth = new FlxSprite(4, _txtHealth.y + (_txtHealth.height/2)  - 4, AssetPaths.health__png);
         //_sprMoney = new FlxSprite(FlxG.width - 12, _txtMoney.y + (_txtMoney.height/2)  - 4, AssetPaths.coin__png);
         //_txtMoney.alignment = RIGHT;
         //_txtMoney.x = _sprMoney.x - _txtMoney.width - 4;
		 _txtScore = new FlxText(FlxG.width - 300, 20, 0, "SCORE: 0", 30);
         _txtScore.setBorderStyle(SHADOW, FlxColor.GRAY, 1, 1);
         //add(_sprBack);
         //add(_sprHealth);
         //add(_sprMoney);
         add(_txtHealth);
         //add(_txtMoney);
		 add(_txtScore);
         
		 /*forEach(function(spr:FlxSprite)
         {
             spr.scrollFactor.set(0, 0);
         });*/
     }

     public function updateHUD(health:Int, score:Int):Void
     {
         _txtHealth.text = Std.string(health) + " / 3";
         //_txtMoney.text = Std.string(Money);
         //_txtMoney.x = _sprMoney.x - _txtMoney.width - 4;
		 _txtScore.text = "SCORE: " + Std.string(score);
     }
 }
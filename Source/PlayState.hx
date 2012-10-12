package;


import nme.Assets;
import nme.geom.Rectangle;
import nme.net.SharedObject;
import org.flixel.FlxButton;
import org.flixel.FlxGroup;
import org.flixel.FlxObject;
import org.flixel.FlxG;
import org.flixel.FlxPath;
import org.flixel.FlxPoint;
import org.flixel.FlxSave;
import org.flixel.FlxSprite;
import org.flixel.FlxState;
import org.flixel.FlxText;
import org.flixel.FlxTilemap;
import org.flixel.FlxU;
import org.flixel.FlxSound;

import org.flixel.FlxRect;

class PlayState extends FlxState
{
	private var bg:FlxSprite;
	private var map:FlxTilemap;
	private var player:FlxSprite;
	private var player_jumping:Bool;
	private var collectables_layer:FlxGroup;
	private var txtScore:FlxText;
	
	private var bgMusic:FlxSound;
	private var getSFX:FlxSound;
	
	private var enemyGroup:FlxGroup;
	
	private var healthBar:FlxSprite;
	private var bullets_layer:FlxGroup;
	private var bullet_delay:Int;
	
	override public function create():Void
	{
		#if !neko
		FlxG.bgColor = 0xff131c1b;
		#else
		FlxG.bgColor = {rgb: 0x131c1b, a: 0xff};
		#end		
		//FlxG.mouse.show();
		
		
		//background
		bg = new FlxSprite(0, 0, "assets/mountain.jpg");
		bg.scrollFactor = new FlxPoint(.6, .6);
		add(bg);
		
		//load up the map
		map = new FlxTilemap();
		map.loadMap(Assets.getText("assets/map.txt"), "assets/tiles.png");
		add(map);
		
		//add the player
		player = new Player();
		add(player);
		
		//setup collectables
		collectables_layer = new FlxGroup();
		add(collectables_layer);
		
		for (i in 1 ... 10) {
			var collectible:FlxSprite = new FlxSprite(Math.random() * map.width, Math.random() * map.height);
			collectible.loadGraphic("assets/collectible.png");
			collectables_layer.add(collectible);
		}
		
		//setup bullets layer
		bullets_layer = new FlxGroup();
		add(bullets_layer);
		
		//and bullet delay
		bullet_delay = 20;
		
		//add score text
		txtScore = new FlxText(0, 0, 50);
		txtScore.text = Std.string(FlxG.score);
		add(txtScore);
		txtScore.scrollFactor.x = 0;
		txtScore.scrollFactor.y = 0;
		
		//health bar
		healthBar = new FlxSprite(5, 5);
		healthBar.makeGraphic(1, 12, 0xffff0000);
		healthBar.scrollFactor.x = healthBar.scrollFactor.y = 0;
		healthBar.origin.x = healthBar.origin.y = 0; //Zero out the origin
		healthBar.scale.x = 48; //Fill up the health bar all the way
		healthBar.x = 30;
		add(healthBar);
		
		FlxG.playMusic("assets/Sycamore_Drive_-_01_-_Kicks.mp3");
		
		
		FlxG.camera.follow(player);
		FlxG.camera.bounds = new FlxRect(0, 0, map.width, map.height);
		FlxG.worldBounds = new FlxRect(0, 0, map.width, map.height);
		
		makeEnemies();
	}
	
	override public function destroy():Void
	{
		super.destroy();
	}
	
	private function makeEnemies():Void {
		
		//make the group for the enemies, add it to the game
		enemyGroup = new FlxGroup();
		add(enemyGroup);
		
		//make three enemies
		var enemy:Enemy = new Enemy();
		enemy.setTarget(player);
		enemy.x = 500;
		enemy.y = 100;
		enemyGroup.add(enemy);
		
		enemy = new Enemy();
		enemy.setTarget(player);
		enemy.x = 200;
		enemy.y = 500;
		enemyGroup.add(enemy);
		
		enemy = new Enemy();
		enemy.setTarget(player);
		enemy.x = 900;
		enemy.y = 300;
		enemyGroup.add(enemy);
		
	
	}

	override public function update():Void
	{
		super.update();
		FlxG.collide(map, player);
		FlxG.collide(map, enemyGroup);
		FlxG.overlap(player, enemyGroup, playerHitEnemy);
		FlxG.overlap(player, collectables_layer, playerHitCollectible, null);
		
		FlxG.overlap(bullets_layer, enemyGroup, bulletHitEnemy);
		FlxG.collide(bullets_layer, map, bulletHitMap);// bulletHitEnemy);
		//scale the bar
		healthBar.scale.x = (player.health / 100) * 48;
		
		bullet_delay --;
		if (FlxG.keys.SPACE && bullet_delay < 0) {
			//fiya!
			
			//resetdelay
			bullet_delay = 20;
			
			var bullet:FlxSprite = new FlxSprite();
			bullet.loadGraphic("assets/bullet.png", false, true);
			bullet.x = player.x;
			bullet.y = player.y;
			bullet.facing = player.facing;
			bullet.velocity.x = ((player.facing == FlxObject.LEFT) ? -1 : 1) * 150;
			bullets_layer.add(bullet);
		}
	}	
	
	function bulletHitMap(bulletRef:FlxObject, mapRef:FlxObject):Void {
		bullets_layer.remove(bulletRef);
	}
	
	function bulletHitEnemy(bulletRef:FlxObject, enemyRef:FlxObject):Void {
		bullets_layer.remove(bulletRef);
		enemyGroup.remove(enemyRef);
	}
	
	function playerHitEnemy(playerRef:FlxObject, enemyRef:FlxObject):Void {
		playerRef.health -= 10;
		playerRef.flicker();
		enemyGroup.remove(enemyRef);
	}
	
	function playerHitCollectible(playerRef:FlxObject, collectibleRef:FlxObject):Void {
		collectables_layer.remove(collectibleRef);
		FlxG.score ++;
		txtScore.text = Std.string( FlxG.score );
		FlxG.play("assets/get.wav");
	}
}
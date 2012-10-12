package ;

import org.flixel.FlxSprite;
import org.flixel.FlxG;
import org.flixel.FlxObject;


/**
 * ...
 * @author tf
 */

class Player extends FlxSprite
{

	public var _jumping:Bool;
	
	public function new() 
	{
		super();
		this.loadGraphic("assets/player.png", true, true, 25, 34);
		
		//customize the player
		this.x = 40;
		this.y = 70;
		this.acceleration.y = 200;
		this.drag.x = 100;
		this.health = 100;
				
		//add in the animation
		this.addAnimation("default", [0,1], 3);
		this.addAnimation("jump", [2]);
		this.play("default");
		_jumping = true;
	}
	
	override public function update() {
		super.update();
		
		if (FlxG.keys.LEFT) {
			this.velocity.x = -70;
			this.facing = FlxObject.LEFT;
		}
		
		if (FlxG.keys.RIGHT) {
			this.velocity.x = 70;
			this.facing = FlxObject.RIGHT;
		}
		
		if (this.velocity.y == 0 && FlxG.keys.UP) {
			this.velocity.y = -160;
			this.play('jump');
			_jumping = true;
		}
		
		if (_jumping && this.velocity.y == 0) {
			_jumping = false;
			this.play('default');
		}
	}
	
}
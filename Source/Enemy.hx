package ;

import org.flixel.FlxSprite;
import org.flixel.FlxG;
import org.flixel.FlxObject;


/**
 * ...
 * @author tf
 */

class Enemy extends FlxSprite
{

	public var _jumping:Bool;
	private var targ:FlxSprite;
	
	public function new() 
	{
		super();
		this.loadGraphic("assets/enemy.png", true, true, 25, 34);
		
		//customize the player
		this.x = 40;
		this.y = 70;
		this.acceleration.y = 200;
		this.drag.x = 100;
				
		//add in the animation
		this.addAnimation("default", [0,1], 3);
		this.addAnimation("jump", [2]);
		this.play("default");
		_jumping = true;
	}
	
	public function setTarget(t:FlxSprite) {
		targ = t;
	}
	
	override public function update() {
		super.update();
		
		var distX:Float = this.x - targ.x;
		var distY:Float = this.y - targ.y;
		
		if (distX > 0) {
			this.velocity.x = -50;
			this.facing = FlxObject.LEFT;
		} else {
			this.velocity.x = 50;
			this.facing = FlxObject.RIGHT;
		}
		
		if (distY > 0 && !_jumping) {
			this.velocity.y = - 150;
			this.play('jump');
			_jumping = true;
		}
		
		if (_jumping && this.velocity.y == 0) {
			_jumping = false;
			this.play('default');
		}
	}
	
}
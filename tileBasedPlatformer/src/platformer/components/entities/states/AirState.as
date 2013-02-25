package platformer.components.entities.states
{
	import platformer.components.entities.ProtagonistEntity;
	
	public class AirState extends State
	{
		public var speed			:Number = 1;
		public var resistance		:Number = 0.15;
		//public var gravity			:Number = 1;
			
		public function AirState(protagonist:ProtagonistEntity)
		{
			super(protagonist);
		}
		
		override public function enter():void
		{
			//if (protagonist.anim != "jump")
			//	protagonist.anim = "fall";
		}
		
		override public function preMove(dt:Number):void
		{
			// Reset forces
			var ax:Number = 0;
			var ay:Number = protagonist.gravity;
			
			// Apply movement force
			if (protagonist.leftIsDown) {			
				ax -= speed;
			}
			else if (protagonist.rightIsDown) {
				ax += speed;
			}
			
			// Apply forces
			protagonist.vx += ax * dt;
			protagonist.vy += ay * dt;
		}
		
		override public function postMove(dt:Number, collisionInfo:Object):void
		{
			// Have we hit ground?
			if (collisionInfo.bottomIsect > 0)
			{
				protagonist.state = protagonist.landState;
			}
			
			// Flip graphic based on direction
			//protagonist.mc._xscale = protagonist.direction * 100
			
			// Apply move resistance
			protagonist.vx -= protagonist.vx * resistance * dt
		}
		
		override public function onAnimEnd(anim:String):void
		{
			//if (anim == "jump") protagonist.anim = "fall";
		}
	}
}
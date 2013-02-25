package platformer.components.entities.states
{
	import platformer.components.entities.ProtagonistEntity;
	
	public class IdleState extends State
	{
		public var resistance		:Number = 0.4
			
		public function IdleState(protagonist:ProtagonistEntity)
		{
			super(protagonist);
		}
		
		
		override public function enter():void
		{
//			if (protagonist.anim != "land") {
//				protagonist.anim = "idle"
//			}
		}
		
		override public function leave():void
		{
			
		}
		
		override public function preMove(dt:Number):void
		{
			if (protagonist.leftIsDown || protagonist.rightIsDown) {
				protagonist.state = protagonist.walkState;
			}
			else if (protagonist.spaceIsDown) {
				if (!protagonist.jumpToggle) {
					protagonist.jumpToggle = true;
					protagonist.state = protagonist.jumpState;
				}
			}
			else {
				protagonist.jumpToggle = false;
			}
			
			// Reset forces
			var ax:Number = 0;
			var ay:Number = protagonist.gravity;
			
			// Apply forces
			protagonist.vx += ax * dt;
			protagonist.vy += ay * dt;
		}
		
		override public function postMove(dt:Number, collisionInfo:Object):void
		{
			// Are we no longer on ground?
			if (collisionInfo.bottomIsect == 0)
			{
				protagonist.state = protagonist.airState;
			}
			
			// Flip graphic based on direction
			//protagonist.mc._xscale = protagonist.direction * 100
			
			// Apply move resistance
			protagonist.vx -= protagonist.vx * resistance * dt;
		}
		
//		public function onKeyDown(event:InputEvent)
//		{
//			if (event.id == "action" && obj.hasAction)
//			{
//				obj.state = obj.actionState
//			}
//		}
		
		override public function onAnimEnd(anim:String):void
		{
		//	if (anim == "land") obj.anim = "idle"
		}	
	}
}
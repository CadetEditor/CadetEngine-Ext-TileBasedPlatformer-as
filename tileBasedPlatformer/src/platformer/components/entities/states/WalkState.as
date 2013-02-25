package platformer.components.entities.states
{
	import platformer.components.entities.ProtagonistEntity;
	
	public class WalkState extends State
	{
		public  var speed			:Number = 12;//2.5
		public  var resistance		:Number = 1;//0.2
		private var jumpToggle		:Boolean = false;
			
		public function WalkState(protagonist:ProtagonistEntity)
		{
			super(protagonist);
		}

		override public function enter():void
		{
			//protagonist.anim = "walk"
			
			//protagonist.engine.inputProvider.addEventListener(this, InputEvent.KEY_DOWN, onKeyDown)
		}
		
		override public function leave():void
		{
		//	protagonist.engine.inputProvider.removeEventListener(this, InputEvent.KEY_DOWN, onKeyDown)
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
			else {
				// If the player isn't moving the character left or right,
				// and we're slow enough, snap back to the idle state
				if (Math.abs(protagonist.vx) < 3) {
					//protagonist.state = protagonist.idleState
				}
				
			}
			
			// TODO: for testing
			if (protagonist.upIsDown) {
				ay -= speed;
			}
			else if (protagonist.downIsDown) {
				ay += speed;
			}
			
			// jumpIsDown
			if (protagonist.spaceIsDown) {
				if (!jumpToggle) {
					jumpToggle = true
					protagonist.state = protagonist.jumpState;
				}
			}
			else {
				jumpToggle = false
			}
			
			// Apply forces
			protagonist.vx += ax * dt;
			protagonist.vy += ay * dt;
		}
/*		
		public function onKeyDown(event:InputEvent)
		{
			if (event.id == "action" && protagonist.hasAction)
			{
				protagonist.state = protagonist.actionState
			}
		}
*/		
		override public function postMove(dt:Number, collisionInfo:Object):void
		{
			// Flip graphic based on direction
			//protagonist.mc._xscale = protagonist.direction * 100
			
			// Are we no longer on ground?
			if (collisionInfo.bottomIsect == 0)
			{
				protagonist.state = protagonist.airState;
			}
			// Apply move resistance
			protagonist.vx -= protagonist.vx * resistance * dt
		}		
	}
}
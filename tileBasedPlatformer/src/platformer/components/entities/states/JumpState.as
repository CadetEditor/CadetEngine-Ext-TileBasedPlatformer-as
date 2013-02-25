package platformer.components.entities.states
{
	import platformer.components.entities.ProtagonistEntity;
	
	public class JumpState extends State
	{
		public var jumpSpeed			:Number = 5;//13;
		
		public function JumpState(protagonist:ProtagonistEntity)
		{
			super(protagonist);
		}
		
		override public function enter():void
		{
			protagonist.vy = -jumpSpeed;
				
			//protagonist.anim = "jump"
			protagonist.state = protagonist.airState;
		}
	}
}
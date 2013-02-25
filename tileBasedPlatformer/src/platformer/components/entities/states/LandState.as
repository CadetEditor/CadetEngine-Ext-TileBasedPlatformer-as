package platformer.components.entities.states
{
	import platformer.components.entities.ProtagonistEntity;
	
	public class LandState extends State
	{
		public function LandState(protagonist:ProtagonistEntity)
		{
			super(protagonist);
		}
		
		override public function enter():void
		{
			//protagonist.anim = "land";
			protagonist.state = protagonist.idleState;
		}
	}
}
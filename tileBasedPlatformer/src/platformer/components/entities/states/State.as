package platformer.components.entities.states
{
	import platformer.components.entities.ProtagonistEntity;

	public class State
	{
		protected var protagonist		:ProtagonistEntity;
		private var collisionInfo	:Object;
		
		public function State(protagonist:ProtagonistEntity)
		{
			this.protagonist = protagonist
		}
		
		public function enter():void {}
		public function leave():void {}
		
		public function preMove(dt:Number):void {}
		public function postMove(dt:Number, collisionInfo:Object):void {}
		
		public function onAnimEnd(anim:String):void {}
	}
}
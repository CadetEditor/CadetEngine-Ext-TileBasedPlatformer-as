package platformer.components.entities
{
	import flash.geom.Rectangle;
	
	import cadet.components.behaviours.IEntityUserControlledBehaviour;
	import cadet.core.ISteppableComponent;
	
	import cadet2D.components.skins.ImageSkin;
	
	import platformer.components.entities.states.AirState;
	import platformer.components.entities.states.IdleState;
	import platformer.components.entities.states.JumpState;
	import platformer.components.entities.states.LandState;
	import platformer.components.entities.states.State;
	import platformer.components.entities.states.WalkState;
	
	public class ProtagonistEntity extends SolidEntity implements ISteppableComponent, IEntityUserControlledBehaviour
	{	
		private var _skin					:ImageSkin;
		
		// Attributes
		public var direction		:Number = 1;
		public var jumpToggle		:Boolean = false;
		public var vx				:Number = 0;
		public var vy				:Number = 0;
		
		// States
		private var stateToBecome	:State;
		private var _state			:State;
		public var idleState		:IdleState;
		public var walkState		:WalkState;
		public var jumpState		:JumpState;
		public var airState			:AirState;
		public var landState		:LandState;
//		public var actionState		:ActionState;
//		public var transformState	:TransformState;
//		public var dieState			:DieState;
//		public var celebrationState	:CelebrationState;
//		public var endLevelState	:EndLevelState;
		
		public var upIsDown 		:Boolean;
		public var downIsDown		:Boolean;
		public var leftIsDown		:Boolean;
		public var rightIsDown		:Boolean;
		public var spaceIsDown		:Boolean;
		
		private  var rect			:Rectangle;
		
		public var gravity			:Number = 10//1;
		
		public function ProtagonistEntity()
		{
			// Rect dimensions must be a multiple of gridSize
			// Perhaps should be specified in num grid cells and multiplied by gridSize?
			rect = new Rectangle(0, 0, 32, 64);
			
			// States
			idleState 			= new IdleState(this);
			walkState 			= new WalkState(this);
			jumpState 			= new JumpState(this);
			airState 			= new AirState(this);
			landState 			= new LandState(this);
//			actionState 		= new ActionState(this);
//			transformState 		= new TransformState(this);
//			dieState		 	= new DieState(this);
//			celebrationState 	= new CelebrationState(this);
//			endLevelState 		= new EndLevelState(this);
			
			state = idleState;
		}
		
		override protected function addedToScene():void
		{
			super.addedToScene();
			addSiblingReference(ImageSkin, "skin");
		}
		
		public function up():void {
			upIsDown = true;
		}
		public function down():void {
			downIsDown = true;
		}
		public function left():void {
			leftIsDown = true;	
		}
		public function right():void {
			rightIsDown = true;	
		}
		public function space():void {
			spaceIsDown = true;
		}
		
		public function step(dt:Number):void
		{
			// Perform animated entity super events
			//super.execute(event)
			
			//invulnerable = Math.max(0, invulnerable-1)
			
			
			// Flip direction based on velocity
			if 		(vx < 0.0) direction = -1;
			else if (vx > 0.1) direction =  1;
			
			// Call the state's premove function. This calculates the velocity, but doesn't actually move the entity.
			_state.preMove(dt);
			
			vy = Math.min(vy, 30);
			
			// Calculate a temporary entity's world rect after applying velocity (not taking into account collisions)
			var movedRect:Rectangle = rect.clone();
			movedRect.x += transform.x += vx;
			movedRect.y += transform.y += vy;
			
			occupyCells(movedRect);
			
			// Now pass these overlapping tiles to the state, so it can perform state specific collecting/destroying etc
			//parseOccupiedCells()
			
			// Finally correct the position of this entity so it doesn't overlap and 'solid' tiles.
			var collisionInfo:Object = getCollisions(movedRect, vx, vy, occupiedCells)
			
			// React to any collision info
			if (collisionInfo.bottomIsect > 0) {
				transform.y -= collisionInfo.bottomIsect;
				vy = 0;
			}
			else if (collisionInfo.topIsect > 0) {
				transform.y += collisionInfo.topIsect;
				vy = 0;
			}
			
			if (collisionInfo.rightIsect > 0) {
				transform.x -= collisionInfo.rightIsect;
				vx = 0;
			}
			else if (collisionInfo.leftIsect > 0) {
				transform.x += collisionInfo.leftIsect;
				vx = 0;
			}

			// The post move method looks at the collision info to determine what state to be in next
			_state.postMove(dt, collisionInfo);			
			
			/*
			// Transform back into Ben if transform time has run out
			if (transformTime != null)
			{
				transformTime -= dt / 30
				
				if (transformTime <= 0)
				{
					transform("BenEntity")
					return
				}
					// Start flashing
				else if (transformTime < 3)
				{
					var ratio:Number = ((transformTime % 1) / 1) * 0.7
					
					var ct:ColorTransform = new ColorTransform()
					ct.redMultiplier = (1-ratio)
					ct.greenMultiplier = (1-ratio)
					ct.blueMultiplier = (1-ratio)
					ct.redOffset = ratio * 255
					
					_mc.transform.colorTransform = ct
					
				}
				else
				{
					_mc.transform.colorTransform = new ColorTransform()
				}
			}
			
			if (invulnerable > 0) {
				
				var ct:ColorTransform = new ColorTransform()
				
				var ratio:Number = 0.25
				
				if (invulnerable < 30) {
					if (invulnerable % 2 == 0) {
						ratio = 0.0
					}
				}
				ct.redOffset = ratio * 255
				ct.greenOffset = ratio * 255
				ct.blueOffset = ratio * 255
				_mc.transform.colorTransform = ct
			}
			else if (transformTime == null) {
				_mc.transform.colorTransform = new ColorTransform()
			}
			*/
				
			upIsDown 		= false;
			downIsDown		= false;
			leftIsDown		= false;
			rightIsDown		= false;
			spaceIsDown		= false;
		}
		
		public function set state(value:State):void
		{
			if (value == _state) return;
				
			if (_state)	_state.leave();
			_state = value;
			_state.enter();
		}
		public function get state():State { return _state }
		
		
		public function set skin( value:ImageSkin ):void
		{
			_skin = value;
		}
		public function get skin():ImageSkin { return _skin; }
	}
}







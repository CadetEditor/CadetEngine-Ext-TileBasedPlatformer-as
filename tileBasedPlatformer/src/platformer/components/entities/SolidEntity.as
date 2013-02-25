package platformer.components.entities
{
	import cadet.core.Component;
	import cadet.events.InvalidationEvent;
	
	import cadet2D.components.transforms.Transform2D;
	
	import flash.geom.Rectangle;
	
	import platformer.components.behaviours.TileBehaviour;
	import platformer.components.processes.GridProcess;
	
	public class SolidEntity extends Component
	{
		private static const TRANSFORM	:String = "transform";
		
		private var _transform				:Transform2D;
		private var _gridProcess			:GridProcess;
		
		// old stuff
		private var occupiedIndices		:Array;
		protected var occupiedCells		:Array;
		private var leftI				:Number;
		private var rightI				:Number;
		private var topI				:Number;
		private var botI				:Number;
		
		// new stuff
		//private var occupiedTiles		:Array;
		
		public function SolidEntity()
		{
			super();
		}
		
		override protected function addedToScene():void
		{
			addSiblingReference(Transform2D, "transform");
			addSceneReference( GridProcess, "gridProcess" );
		}
		
		protected function occupyCells(r:Rectangle):void
		{
			// First unoccypy previous ones
//			for (var i:uint = 0; i < occupiedIndices.length; i+=2)
//			{
//				//if (grid[occupiedIndices[i]][occupiedIndices[i+1]] == true)
//				//	grid[occupiedIndices[i]][occupiedIndices[i+1]] = null
//			}
			occupiedIndices = new Array();
			occupiedCells = new Array();
				
			var gridShift:uint = 5;
			leftI 	= r.left 	>> gridShift;
			rightI	= r.right 	>> gridShift;
			topI 	= r.top 	>> gridShift;
			botI 	= r.bottom 	>> gridShift;
			
			var columnIndex:int = 0;
			for (var x:int = leftI; x <= rightI; x++)
			{
				//var cell_X:Array = grid[x]
				occupiedCells[columnIndex] = new Array();
				var rowIndex:Number = 0
				for (var y:Number = topI; y <= botI; y++)
				{
					occupiedIndices.push(x)
					occupiedIndices.push(y)
					
					//occupiedCells[columnIndex][rowIndex] = cell_X[y]
					var tile:TileBehaviour = occupiedCells[columnIndex][rowIndex] = gridProcess.getTileAtGridLoc( x, y);
//					if (cell_X[y] == null) {
//						cell_X[y] = true
//					}
					
					rowIndex++;
				}
				
				columnIndex++;
			}			
			
			/*
			// The rounded top left grid positions
			var xpos:int = Math.round(transform.x/gridProcess.gridSize);
			var ypos:int = Math.round(transform.y/gridProcess.gridSize);
			
			// How many tiles the entity occupies
			var entityWidth:int = Math.max(Math.floor( r.width / gridProcess.gridSize ), 1);
			var entityHeight:int = Math.max(Math.floor( r.height / gridProcess.gridSize ), 1);

			occupiedTiles = [];
			
			trace("xpos "+xpos+" ypos "+ypos+" entityWidth "+entityWidth+" entityHeight "+entityHeight);
			// Occupied Tiles
			for ( var i:uint = xpos; i < xpos + entityWidth; i ++ ) {
				for ( var j:uint = ypos; j < ypos + entityHeight; j ++ ) {
					trace("OCCUPY TILE X "+i+" Y "+j);
				}
			}
			*/
		}
		
		protected function getCollisions(r:Rectangle, vx:Number, vy:Number, cells:Array):Object
		{
			var collisionInfo:Object = new Object();
			collisionInfo.topIsect = 0;
			collisionInfo.bottomIsect = 0;
			collisionInfo.leftIsect = 0;
			collisionInfo.rightIsect = 0;
			
			var gridShift:uint = 5;
			
			// Cancel out x movement
			r.x -= vx;
			var leftIndex:int 	= (r.left  + 1) >> gridShift;
			var rightIndex:int 	= (r.right - 1) >> gridShift;
			
			var tile:TileBehaviour;
			
			var xIndex:int;
			var yIndex:int;
			
			// Find bottom intersection
			if (vy > 0) {
				var bottomIndex:int 	= (r.bottom >> gridShift);
				
				for (var i:int = leftIndex; i <= rightIndex; i++) {
					//trace("Find Bottom x "+(i-leftI)+" y "+(bottomIndex-topI));
					xIndex = i-leftI;
					var column:Array = cells[xIndex];
					yIndex = bottomIndex-topI;
					if (column)	tile = column[yIndex];
					
					if (tile && tile.solid) {
						r.y -= collisionInfo.bottomIsect = r.bottom - (bottomIndex << gridShift);
						break;
					}
				}
			}
			// Find top intersection
			else if (vy < 0) {
				var topIndex:int	= (r.top >> gridShift);
				
				for (i = leftIndex; i <= rightIndex; i++) {
					xIndex = i-leftI;
					column = cells[xIndex];
					yIndex = topIndex-topI;
					if (column)	tile = column[yIndex];
					
					if (tile && tile.solid) {
						r.y += collisionInfo.topIsect = ((topIndex+1) << gridShift) - r.top;
						break;
					}
				}
			}
			
			// Reapply x movement
			r.x += vx;
			topIndex 	= (r.top    + 1) >> gridShift;
			bottomIndex	= (r.bottom - 1) >> gridShift;
			
			// Find right intersection
			if (vx > 0) {
				rightIndex 	= (r.right >> gridShift)
				column = cells[rightIndex-leftI];
				
				for (i = topIndex; i <= bottomIndex; i++) {
					yIndex = i-topI;
					if (column)	tile = column[yIndex];
					
					if (tile && tile.solid) {
						collisionInfo.rightIsect = r.right - (rightIndex << gridShift);
					}
				}
			}
			// Find left intersection
			else if (vx < 0) {
				leftIndex 	= (r.left >> gridShift);
				column = cells[leftIndex-leftI];
				
				for (i = topIndex; i <= bottomIndex; i++) {
					yIndex = i-topI;
					if (column)	tile = column[yIndex];
					
					if (tile && tile.solid) {
						collisionInfo.leftIsect =  ((leftIndex+1) << gridShift) - r.left;
					}
				}
			}
			
			return collisionInfo;
		}

		public function set gridProcess( value:GridProcess ):void
		{
			_gridProcess = value;
		}
		public function get gridProcess():GridProcess { return _gridProcess; }
		
		public function set transform( value:Transform2D ):void
		{
			if ( _transform ) {
				_transform.removeEventListener(InvalidationEvent.INVALIDATE, invalidateTransformHandler);
			}
			
			_transform = value;
			
			if ( _transform ) {
				_transform.addEventListener(InvalidationEvent.INVALIDATE, invalidateTransformHandler);
			}
			
			invalidate(TRANSFORM);
		}
		public function get transform():Transform2D { return _transform; }
		
		protected function invalidateTransformHandler( event:InvalidationEvent ):void
		{
			invalidate(TRANSFORM);
		}
		
		override public function validateNow():void
		{
			if ( isInvalid( TRANSFORM ) )
			{
				validateTransform();
				validateSkin();
			}
			
			super.validateNow();
		}
		
		private function validateTransform():void
		{
			
		}
		
		public function validateSkin():void
		{
			
		}
	}
}













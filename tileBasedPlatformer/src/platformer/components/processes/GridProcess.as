package platformer.components.processes
{
	import cadet.core.Component;
	import cadet.core.IComponent;
	import cadet.events.ComponentEvent;
	import cadet.events.InvalidationEvent;
	import cadet.util.ComponentUtil;
	
	import flash.utils.Dictionary;
	
	import platformer.components.behaviours.TileBehaviour;
	
	public class GridProcess extends Component
	{
		private var _gridSize	:uint = 32;
		private var tileTable	:Dictionary;
		
		public function GridProcess()
		{
			tileTable = new Dictionary();
		}
		
		override protected function addedToScene():void
		{
			scene.addEventListener(ComponentEvent.ADDED_TO_SCENE, componentAddedToSceneHandler);
			scene.addEventListener(ComponentEvent.REMOVED_FROM_SCENE, componentRemovedFromSceneHandler);
			
			var allTiles:Vector.<IComponent> = ComponentUtil.getChildrenOfType( scene, TileBehaviour, true );
			for each ( var tile:TileBehaviour in allTiles )
			{
				addTile( tile );
			}
		}
		
		override protected function removedFromScene():void
		{
			super.removedFromScene();
			
			for each ( var tile:TileBehaviour in tileTable )
			{
				delete tileTable[tile];
			}
			
//			for each ( var layer:Sprite in worldContainerLayers )
//			{
//				while ( layer.numChildren > 0 )
//				{
//					var displayObject:DisplayObject = layer.getChildAt(0);
//					var skin:ISkin2D = tileTable[displayObject];
//					layer.removeChildAt(0);
//					delete tileTable[displayObject];
//				}
//			}
		}
		
		private function componentAddedToSceneHandler( event:ComponentEvent ):void
		{
			if ( event.component is TileBehaviour == false ) return;
			addTile( TileBehaviour( event.component ) );
		}
		
		private function componentRemovedFromSceneHandler( event:ComponentEvent ):void
		{
			if ( event.component is TileBehaviour == false ) return;
			removeTile( TileBehaviour( event.component ) );
		}
		
		public function addTile( tile:TileBehaviour ):void
		{			
//			addSkinToDisplayList(skin);
			if (!tile.transform) return;
			
			// Add tile in new position
			tile.gridX = Math.floor(tile.transform.x) / _gridSize;
			tile.gridY = Math.floor(tile.transform.y) / _gridSize;
			
			//trace("addTile "+tile.gridX+"_"+tile.gridY);
			tile.addEventListener(InvalidationEvent.INVALIDATE, invalidateTileHandler);
			tileTable[tile.gridX+"_"+tile.gridY] = tile;
//			displayObjectTable[AbstractSkin2D(skin).displayObject] = skin;
		}
		
		public function removeTile( tile:TileBehaviour ):void
		{
//			removeSkinFromDisplayList(skin);
			//trace("removeTile "+tile.gridX+"_"+tile.gridY);
			tile.removeEventListener(InvalidationEvent.INVALIDATE, invalidateTileHandler);
			delete tileTable[tile.gridX+"_"+tile.gridY];
//			delete displayObjectTable[AbstractSkin2D(skin).displayObject];
		}
		
		private function invalidateTileHandler( event:InvalidationEvent ):void
		{
			var tile:TileBehaviour = TileBehaviour(event.target);
			//trace("invalidateTile "+tile.gridX+"_"+tile.gridY);
			
			if (tile.gridPosSet) {
				removeTile(tile);
			}
			
			tile.gridPosSet = true;
			
			addTile( tile );
		}
		
		public function getTileAtPosition(x:int, y:int):TileBehaviour
		{
			if (!tileTable) return null;
			
			var xpos:int = Math.floor(x) / _gridSize;
			var ypos:int = Math.floor(y) / _gridSize;			
			
			var tile:TileBehaviour = getTileAtGridLoc(xpos, ypos);
			
			return tile;
		}
		public function getTileAtGridLoc(x:int, y:int):TileBehaviour
		{
			if (!tileTable) return null;
			
			var tile:TileBehaviour = tileTable[x+"_"+y];
			
			return tile;
		}
		
		[Serializable][Inspectable]
		public function set gridSize( value:uint ):void
		{
			_gridSize = value;
		}
		public function get gridSize():uint { return _gridSize; }
	}
}







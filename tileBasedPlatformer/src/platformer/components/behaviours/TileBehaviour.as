package platformer.components.behaviours
{
	import cadet.core.Component;
	import cadet.events.InvalidationEvent;
	
	import cadet2D.components.transforms.Transform2D;
	import cadet2D.components.skins.ImageSkin;

	import flox.app.FloxApp;
	
	import platformer.components.processes.GridProcess;
	
	public class TileBehaviour extends Component
	{
		private static const TRANSFORM	:String = "transform";
		
		private var _gridProcess			:GridProcess;
		private var _transform				:Transform2D;
		private var _skin					:ImageSkin;
		private var _skinName				:String;
		private var _brush					:XML;
		
		private var _solid					:Boolean;
		private var _ignoreNeighbours		:Boolean;
		public var linkage					:String;
		
		public var gridX					:int = -1;
		public var gridY					:int = -1;
		public var gridPosSet				:Boolean;
		
		public function TileBehaviour()
		{
			name = "Tile Behaviour";
		}
		
		override protected function addedToScene():void
		{
			addSiblingReference(Transform2D, "transform");
			addSiblingReference(ImageSkin, "skin");
			addSceneReference( GridProcess, "gridProcess" );
		}
		
		override protected function removedFromScene():void
		{
			//destroyBody();
		}
		
		[Serializable][Inspectable]
		public function set solid( value:Boolean ):void
		{
			_solid = value;
		}
		public function get solid():Boolean
		{
			return _solid;
		}
		
		[Serializable][Inspectable]
		public function set skinName( value:String ):void
		{
			_skinName = value;
		}
		public function get skinName():String
		{
			return _skinName;
		}
		
		public function set brush( value:XML ):void
		{
			_brush = value;
		}
		public function get brush():XML
		{
			return _brush;
		}
		
		[Serializable][Inspectable]
		public function set ignoreNeighbours( value:Boolean ):void
		{
			_ignoreNeighbours = value;
		}
		public function get ignoreNeighbours():Boolean
		{
			return _ignoreNeighbours;
		}
		
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
		
		public function set skin( value:ImageSkin ):void
		{
			_skin = value;
		}
		public function get skin():ImageSkin { return _skin; }
		
		public function set gridProcess( value:GridProcess ):void
		{
			_gridProcess = value;
		}
		public function get gridProcess():GridProcess { return _gridProcess; }
		
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
			var startLinkage:String = linkage;
			
			var neighbours:Array = getNeighbours();
			
			// Find the best suited graphic
			if (!ignoreNeighbours) {
				linkage = buildLinkageString(neighbours);
			} else {
				linkage = "0000";
			}
			
			//trace("tile "+gridX+"_"+gridY+" linkage = "+linkage+" neighbours = "+neighbours);
			
			if ( linkage == "" ) return;
			
			// touching: top, right, bottom, left
			if (brush) {
				var tileXMLList:XMLList = brush.tile.(@id==linkage);
				var tileXML:XML = tileXMLList[0];
				//trace("offsetXML "+offsetXML.toString());
				if (!tileXML) {
					tileXML = brush.tile[0];
				}
				//TODO
//				skin.fillXOffset = int(tileXML.@offsetX); 
//				skin.fillYOffset = int(tileXML.@offsetY);
			} else {
				//trace("BRUSH NOT SET!!!");
			}
			
			if (linkage != startLinkage) {
				var resourceID:String = _skinName + linkage + ".png";

				FloxApp.resourceManager.bindResource( resourceID, skin, "fillBitmap");
				
				if (!ignoreNeighbours) {
					updateNeighbours();
				}
			}
		}
		
		private function getNeighbours():Array
		{
			if (!_gridProcess) return [];
			
			var neighbours:Array = new Array();
			
			neighbours.push(_gridProcess.getTileAtGridLoc(gridX, gridY-1));
			neighbours.push(_gridProcess.getTileAtGridLoc(gridX+1, gridY));
			neighbours.push(_gridProcess.getTileAtGridLoc(gridX, gridY+1));
			neighbours.push(_gridProcess.getTileAtGridLoc(gridX-1, gridY));

			return neighbours;
		}
		
		private function buildLinkageString(neighbours:Array):String
		{
			var output:String = "";
			for (var i:uint = 0; i < neighbours.length; i++)
			{
				var neighbour:TileBehaviour = neighbours[i];
				
				if (neighbour && neighbour.skinName == _skinName) {
					output += "1";
				} else {
					output += "0";
				}
			}
			return output;
		}
		
		private function updateNeighbours():void
		{
			var neighbours:Array = getNeighbours()
			for (var i:Number = 0; i < neighbours.length; i++)
			{
				var neighbour:TileBehaviour = neighbours[i];
				if (neighbour)	neighbour.validateSkin();
			}
			
			validateSkin();
		}
	}
}












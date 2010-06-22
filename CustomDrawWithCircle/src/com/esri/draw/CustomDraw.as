package com.esri.draw
{
	
	import com.esri.ags.Graphic;
	import com.esri.ags.Map;
	import com.esri.ags.events.DrawEvent;
	import com.esri.ags.geometry.MapPoint;
	import com.esri.ags.geometry.Polygon;
	import com.esri.ags.symbol.Symbol;
	import com.esri.ags.symbol.TextSymbol;
	import com.esri.ags.toolbars.Draw;
//Mod 
	import com.esri.ags.layers.GraphicsLayer;
//end Mod	
	import flash.events.MouseEvent;
	
	import mx.formatters.NumberBaseRoundType;
	import mx.formatters.NumberFormatter;   

	public class CustomDraw extends Draw
	{
		public static const CIRCLE:String = "circle";     	 
        
	    //use to set the text symbol to display the radius (as a number) is desired
	    [Bindable]   
	    public var textSymbol : TextSymbol;    
//Mod Robert Scheitlin 28 Oct 2009
//use new textSymbol
	    private var ntextSymbol : TextSymbol;
//Mod End     
	    //use to set the symbol for the center of the circle as a point is desired
	    [Bindable]
	    public var centerPointSymbol: Symbol;        
	    //set this in the code using this component to specify 
	    //how manu points will be used to create the circle
	    //If not specified, the value is 100.      
	    private var _numberOfCirclePoints : int = 100;   
	    //set this to false if displaying the center of the cicle is not desired
	    public var displayCenter:Boolean = true;
	    //set this to false if displaying the radius as a number is not desired
	    public var displayRadius:Boolean = true;    
	    
	    private var m_center:MapPoint;        
	    private var m_radius:Number;   
	    private var m_graphic : Graphic; 
	    private var m_textGraphic : Graphic;       
	    private var m_circleGeometry : Polygon;  
		
		public function CustomDraw(map:Map=null)
		{
			super(map);
		}
		
		//limit the number of points to 1000				
		public function set numberOfCirlcePoints(value:int):void {
			if (value <= 1000) {
				_numberOfCirclePoints = value;
			} else {
				_numberOfCirclePoints = 1000;
			}
		}
		
		
		public function get numberOfCirclePoints():int {
			return _numberOfCirclePoints;
		}
		
		//activate cirlce drawing
        override public function activate(drawType:String, enableGraphicsLayerMouseEvents:Boolean = false) : void
        {
        	//if map is not specified
        	if (map == null) {
        		throw new Error("Map is not specified for CustomDraw component!");
        		//return;
        	}
        	if (graphicsLayer == null) {
        		throw new Error("Graphics Layer is not specified for CustomDraw component!");

        	}
        	
        	//deactivate();
        	if (drawType == CIRCLE) {
        		//--------- Bug Fix Darina --------------------
        		//November 3rd, 2009
        		//deactivate the tool that has been active before  
        		deactivate();  
        		//---------- End Bug Fix ----------------------     		
        		map.mapNavigationEnabled = false;        		
            	map.addEventListener(MouseEvent.MOUSE_DOWN, map_mouseDownHandler);
            	graphicsLayer.mouseEnabled = enableGraphicsLayerMouseEvents;            	
         	} else {
         		//-------- Bug Fix -------------------------
         		//added this line to remove the mouse down listener for the circle
         		//and to allow a different shape to be drawn if the user haven't called 
         		//deactivate() in between the tool changes
         		map.removeEventListener(MouseEvent.MOUSE_DOWN, map_mouseDownHandler);			
        		super.activate(drawType, enableGraphicsLayerMouseEvents);
        	}          	
        } 
        
        //use deactivate to do map navigation and clean up event listeners
        override public function deactivate():void {
        	//if map is not specified
        	if (map == null) {
        		throw new Error("Map is not specified for CustomDraw component!");
        		//return;
        	}
        	map.mapNavigationEnabled = true; 
        	//-------- Bug Fix --------------------
        	//added this line to remove the mouse down listener during deactivate   
        	map.removeEventListener(MouseEvent.MOUSE_DOWN, map_mouseDownHandler);			    	
        	super.deactivate();
        }  
        
        //handle the beginning of the drawing
        private function map_mouseDownHandler(event:MouseEvent) : void
        {    
        	//--------- Bug Fix -------------------- 
        	//commented this line, because if not listening to mouse down 
        	//a second circle cannot be drawn if the user decides to do this   	        	       
            //map.removeEventListener(MouseEvent.MOUSE_DOWN, map_mouseDownHandler);			
                      
            const mapPoint : MapPoint = map.toMapFromStage( event.stageX, event.stageY );
            //create the polygon for the circle 
            m_circleGeometry = new Polygon();
            
			//--------- Bug Fix - Robert ------------------   
			//Mod Robert Scheitlin 16 Oct 2009
			//Apply maps SpatialReference
            m_circleGeometry.spatialReference = map.spatialReference;
			//End Mod   
			//------------- End Bug Fix -------------------  
			       
            m_center = mapPoint;            
            m_radius = 1; 
            //dispatch the drawStart event to allow users to clear graphics, 
            //or just do whatever needs to be done
            //but do it after the m_center has been defined, because 
            //if done before, and the user clears graphics during the drawStart
            //a bogus center point is defined. 
            this.dispatchEvent(new DrawEvent("drawStart", m_graphic));                              
            m_graphic = new Graphic( m_circleGeometry, fillSymbol );
            graphicsLayer.add( m_graphic );
            
            if (displayRadius) {
	            //create the point for the text showing the radius
	            var textPoint:MapPoint = new MapPoint(m_center.x, m_center.y);
	            
	            //------------ Bug Fix - Robert -------------------
	            //if (textSymbol == null) {
	            //	textSymbol = new TextSymbol();
	            //}
				//Mod Robert Scheitlin 28 Oct 2009
				//use new textSymbol
	            ntextSymbol = new TextSymbol();
	            if (textSymbol != null) {
	            	ntextSymbol.alpha = textSymbol.alpha;
	            	ntextSymbol.background = textSymbol.background;
	            	ntextSymbol.backgroundColor = textSymbol.backgroundColor;
	            	ntextSymbol.border = textSymbol.border;
	            	ntextSymbol.borderColor= textSymbol.borderColor;
	            	ntextSymbol.color = textSymbol.color;
	            	ntextSymbol.placement = textSymbol.placement;
	            	ntextSymbol.xoffset= textSymbol.xoffset;
	            	ntextSymbol.yoffset = textSymbol.yoffset;
	            	ntextSymbol.textFormat = textSymbol.textFormat;
	            }
	            m_textGraphic = new Graphic( textPoint, ntextSymbol);
				//Mod End
	            //m_textGraphic = new Graphic( textPoint, textSymbol);
	            //----------- End Bug Fix --------------------------
	            
	            graphicsLayer.add( m_textGraphic);
            }
            
            //create the center graphic if user has provided centerPointSymbol
            if (displayCenter) {
            	var centerGraphic:Graphic = new Graphic(m_center, centerPointSymbol);
            	graphicsLayer.add(centerGraphic);
            }
            
            map.addEventListener(MouseEvent.MOUSE_MOVE, map_mouseMoveHandler);
            map.addEventListener(MouseEvent.MOUSE_UP, map_mouseUpHandler);
        }
        
        //draw the cirle while the user is dragging the mouse
        private function map_mouseMoveHandler( event : MouseEvent ) : void
        {           	     
            m_radius = calculateRadius(event.stageX, event.stageY); 
            updateCirclePolygon();
           	m_graphic.refresh();  
           	//add the text showing the radius 	
           	if (displayRadius) {           		
           		setRadiusText();   
           	}           	                     
        }
        
        private function map_mouseUpHandler(event:MouseEvent) : void
        {
        	//clean up the text to avoid showing the last radius 
            //at the beginning of a new cirle drawing
            if (displayRadius) {
            	            	
            	//------------- Bug Fix - Robert -------------
            	//textSymbol.text = "";
				//Mod Robert Scheitlin 28 Oct 2009
				//use new textSymbol
            	ntextSymbol.text = "";
				//Mod End
				//------------- End Bug Fix ------------------
				
            }
            if (Polygon(m_graphic.geometry).rings == null) {
            	m_graphic = null;
            }      
            
            map.removeEventListener(MouseEvent.MOUSE_MOVE, map_mouseMoveHandler);
            map.removeEventListener(MouseEvent.MOUSE_UP, map_mouseUpHandler);
                        
            //dispatch the drawEnd to allow handling of the event                        
            this.dispatchEvent(new DrawEvent("drawEnd", m_graphic));                          
        }
        
        private function setRadiusText():void {    
        	
        	//---------------Bug Fix - Robert -----------------------     	
			//set the text to show the circle radius + the appropriate units
        	//textSymbol.text = formatRaduisNumber() + " " + map.units.replace("esri", "");
			//Mod Robert Scheitlin 28 Oct 2009
			//use new textSymbol
        	ntextSymbol.text = formatRaduisNumber() + " " + map.units.replace("esri", "");
			//Mod End
			//----------- End Bug Fix -------------------------------
			
        	//change the geometry of the graphic to move it above the circle
        	MapPoint(m_textGraphic.geometry).y = m_center.y + m_radius;        	
        	m_textGraphic.refresh();
        }
        
        private function calculateRadius(stageX:Number, stageY:Number):Number {
        	//convert the current cursor point to MapPoint     	
        	const mapPoint : MapPoint = map.toMapFromStage( stageX, stageY );
        	//find the horizontal offset from the center in map units
          	const dx : Number = mapPoint.x - m_center.x;
          	//find the vertical offset from the center in map units
            const dy : Number = mapPoint.y - m_center.y;
            //find the radius of the circle using the Pythagorean Theoreme 
            return Math.sqrt( dx * dx + dy * dy );       
        }
        
        //format the radius to not display digits after the decimal point
        private function formatRaduisNumber():String {        	
        	var numberFormater:NumberFormatter = new NumberFormatter();
        	numberFormater.precision = 0;
        	numberFormater.rounding = NumberBaseRoundType.UP;
        	return numberFormater.format(m_radius);
        }
        
        private function updateCirclePolygon():void {
        	//if the cirlce geometry already exists, remove the first and only ring         
            if ((m_circleGeometry.rings != null) && (m_circleGeometry.rings.length > 0)) {
            	m_circleGeometry.removeRing(0);
            }     
            //create the circle points  		
			//add the array of poits as a ring to the circle polygon   
            m_circleGeometry.addRing(createCirclePoints()); 
        }
        
        //create the circle polygon
        private function createCirclePoints():Array {                       
            var cosinus:Number;
            var sinus:Number;
            var x:Number;
            var y:Number;
            var arrayOfPoints:Array = new Array();
            
            //create the array of points which will compose the circle
            for (var i:int = 0; i < numberOfCirclePoints; i++) {
            	sinus = Math.sin((Math.PI*2.0)*(i/numberOfCirclePoints));
            	cosinus = Math.cos((Math.PI*2.0)*(i/numberOfCirclePoints));
            	x = m_center.x + m_radius*cosinus;
            	y = m_center.y + m_radius*sinus; 
            	arrayOfPoints[i] = new MapPoint(x, y);            	        
            }
            
            //add the first point at the end of the array to close the polygon
            arrayOfPoints.push(arrayOfPoints[0]); 
            
            //------------- Bug Fix - Robert -----------------  
            //Mod Robert Scheitlin 16 Oct 2009
			// reverse the array so that the area of the circle is not negative
            arrayOfPoints.reverse();
			//End Mod    
			//------------- End Bug Fix ----------------------   
            return arrayOfPoints;
        } 		
	}
}
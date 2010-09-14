package qs.controls
{
	import flash.display.Shape;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import mx.containers.Canvas;
	import mx.controls.Button;
	import mx.controls.Label;
	import mx.controls.VScrollBar;
	import mx.core.ClassFactory;
	import mx.core.Container;
	import mx.core.EdgeMetrics;
	import mx.core.IDataRenderer;
	import mx.core.UIComponent;
	import mx.events.ScrollEvent;
	
	import qs.context.ContextData;
	import qs.context.ContextManager;
	import qs.controls.calendarDisplayClasses.CalendarDay;
	import qs.controls.calendarDisplayClasses.CalendarEventRenderer;
	import qs.controls.calendarDisplayClasses.CalendarHeader;
	import qs.controls.calendarDisplayClasses.ICalendarEventRenderer;
	import qs.calendar.CalendarSet;
	import qs.calendar.CalendarEvent;
	import qs.utils.DateRange;
	import qs.utils.DateUtils;
	import qs.utils.InstanceCache;
	import qs.utils.ReservationAgent;
	import qs.controls.calendarDisplayClasses.CalendarHours;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import qs.controls.calendarDisplayClasses.CalendarDisplayEvent;
	import flash.utils.getTimer;
	import mx.skins.RectangularBorder;
	import mx.skins.halo.HaloBorder;
	import mx.core.IFlexDisplayObject;
	import qs.controls.calendarDisplayClasses.CalendarAllDayRegion;
	import flash.filters.DropShadowFilter;
	import mx.core.DragSource;
	import mx.managers.DragManager;
	import mx.events.DragEvent;
	import qs.utils.TimeZone;
	
	
	[Event("change")]
	[Event(name="displayModeChange", type="qs.controls.calendarDisplayClasses.CalendarDisplayEvent")]
	[Event(name="headerClick",type="qs.controls.calendarDisplayClasses.CalendarDisplayEvent")]
	[Event(name="dayClick",type="qs.controls.calendarDisplayClasses.CalendarDisplayEvent")]
	[Event(name="itemClick",type="qs.controls.calendarDisplayClasses.CalendarDisplayEvent")]
	
	[Style(name="hourDividerColor", type="uint", format="Color", inherit="no")]
	[Style(name="hourDividerThickness", type="Number", format="Length", inherit="no")]
	[Style(name="allDayDividerColor", type="uint", format="Color", inherit="no")]
	[Style(name="allDayDividerThickness", type="Number", format="Length", inherit="no")]
	[Style(name="allDayColor", type="uint", format="Color", inherit="no")]
	[Style(name="hourColor", type="uint", format="Color", inherit="no")]
	[Style(name="hourThickness", type="Number", format="Length", inherit="no")]
	[Style(name="hourBackgroundColor", type="uint", format="Color", inherit="no")]
	[Style(name="hourStyleName", type="String", inherit="no")]
	[Style(name="dayStyleName", type="String", inherit="no")]
	[Style(name="dayHeaderStyleName", type="String", inherit="no")]
	[Style(name="eventStyleName", type="String", inherit="no")]
	
	public class CalendarDisplay extends UIComponent
	{
		private const ROW_LENGTH:int = 7;
		private const EVENT_INSET:int = 3;
		private const MIN_HOUR_HEIGHT:Number = 40;
		
		private var _animator:LayoutAnimator;
		private var _dayCache:InstanceCache;
		private var _headerCache:InstanceCache;
						
		private var _headerLayer:UIComponent;
		private var _dayLayer:UIComponent;
		private var _eventLayer:UIComponent;
		private var _allDayEventLayer:UIComponent;
		private var _allDayEventBorder:IFlexDisplayObject;
		private var _eventMask:Shape;
		private var _hourGrid:CalendarHours;
		private var _removeAllEventsOnUpdate:Boolean;
		
		private var _currentRange:DateRange;
		private var _pendingRange:DateRange;
		private var _displayMode:String = "month";
		private var _userDisplayMode:String = "month";
		private var _pendingDisplayMode:String;
		private var _removeAllEventData:Boolean;
		
		private var _animated:Boolean = false;
		
		private var _eventData:Dictionary;
		private var _dataProvider:CalendarSet;
		private var _allDayAreaHeight:Number;
		
		private var _visibleRange:DateRange;
		private var _computedRange:DateRange;
		private var _columnLength:int;
		private var _rowLength:int;
		private var _cellWidth:Number;
		private var _cellHeight:Number;
		private var _visibleEvents:Array;
		private var _hourHeight:Number;
		private var _dayAreaHeight:Number;
		private var _animateRemovingDays:Boolean = false;

		// state for drag operations
		private var _dragType:String;
		private var _dragEventData:EventData;
		private var _dragDownPt:Point;
		private var _dragRenderer:UIComponent;
		private var _dragOffset:Number;
		
		private var _border:EdgeMetrics = new EdgeMetrics();
		private var _scroller:VScrollBar;
		private var _scrollHour:Number;
		private var _dragFilter:DropShadowFilter = new DropShadowFilter();		

		private var _tz:TimeZone;

		public function CalendarDisplay():void
		{
			var dt:Date = new Date();
			_tz = TimeZone.localTimeZone;
			range = new DateRange(_tz.startOfMonth(dt),_tz.endOfMonth(dt));
			_animator = new LayoutAnimator();
			_animator.layoutFunction = generateLayout;
			_animator.animationSpeed = .5;
			
			_dayCache = new InstanceCache();
			_dayCache.destroyUnusedInstances = false;
			_dayCache.createCallback = dayChildCreated;
			_dayCache.assignCallback = InstanceCache.showInstance;
			_dayCache.releaseCallback = hideInstance;
			_dayCache.destroyCallback = InstanceCache.removeInstance;			
			_dayCache.factory = new ClassFactory(CalendarDay);

			_headerCache = new InstanceCache();
			_headerCache.destroyUnusedInstances = false;
			_headerCache.createCallback = headerChildCreated;
			_headerCache.assignCallback = InstanceCache.showInstance;
			_headerCache.releaseCallback = hideInstance;
			_headerCache.destroyCallback = InstanceCache.removeInstance;			
			_headerCache.factory = new ClassFactory(CalendarHeader);
			
			_dayLayer = new UIComponent();
			addChild(_dayLayer);
			_headerLayer = new UIComponent();
			addChild(_headerLayer);
			_eventLayer = new UIComponent();
			addChild(_eventLayer);
			_allDayEventLayer = new UIComponent();
			addChild(_allDayEventLayer);
			_allDayEventBorder = new CalendarAllDayRegion(this);
			_allDayEventLayer.addChild(DisplayObject(_allDayEventBorder));
			_eventMask = new Shape();
			_eventMask.visible = false;
			addChild(_eventMask);
			
			_hourGrid = new CalendarHours(this);
			_eventLayer.addChild(_hourGrid);
			_hourGrid.alpha = 0;
			
			_scroller = new VScrollBar();
			_scroller.addEventListener(ScrollEvent.SCROLL,scrollHandler);
			addChild(_scroller);
			_scroller.alpha = 0;
			
			_visibleRange = new DateRange();
			_eventData = new Dictionary();
			dataProvider = null;
			
			addEventListener(DragEvent.DRAG_ENTER,dragEnterHandler);
			addEventListener(DragEvent.DRAG_OVER,dragOverHandler);
			addEventListener(DragEvent.DRAG_EXIT,dragExitHandler);
			addEventListener(DragEvent.DRAG_DROP,dragDropHandler);		
		}
		
		public function set displayMode(value:String):void
		{
			_userDisplayMode = value;
			_pendingDisplayMode = value;
			range = _currentRange;
		}
		public function get displayMode():String
		{
			return (_pendingDisplayMode == null)? _displayMode:_pendingDisplayMode;
		}
		public function set animated(value:Boolean):void
		{
			_animated = value;
		}
		public function get animated():Boolean { return _animated; }
		
		

		[Bindable("change")] 
		public function get currentDate():Date
		{
			return range.start;
		}
		
		public function set range(value:DateRange):void
		{
			var dayCount:int = _tz.rangeDaySpan(value);
			
			if(_userDisplayMode == "auto")
			{
				if(dayCount <= 7)
					_pendingDisplayMode = "days";
				else
					_pendingDisplayMode = "weeks";
				dispatchEvent(new CalendarDisplayEvent(CalendarDisplayEvent.DISPLAY_MODE_CHANGE));
			}
			
			_pendingRange = value;

			// by resetting this to NaN, we'll force the layout to recompute an appropriate hour to
			// make sure values are visible.
			_scrollHour = NaN;
			dispatchEvent(new Event("change"));
			var dm:String = (_pendingDisplayMode == null)? _pendingDisplayMode:_displayMode;
			
			_removeAllEventData = (dm == "weeks" || dm == "week" || dm == "month");
			invalidateProperties();
		}

		[Bindable("change")] 
		public function get range():DateRange
		{
			var result:DateRange = _computedRange;
			var bRecompute:Boolean = false;
			var pr:DateRange = _currentRange;
			var mode:String = _displayMode;
			if(_pendingRange != null)
			{
				bRecompute = true;
				pr = _pendingRange;
			}
			if(_pendingDisplayMode != null)
			{
				bRecompute = true;
				mode = _pendingDisplayMode;
			}
			if(bRecompute)
			{
				var ranges:Object = computeRanges(pr,mode);
				result = ranges._computedRange;
			}
			return result;
		}
		
		public function set currentDate(value:Date):void
		{
			range = new DateRange(value,value);
		}

		
		private function hideInstance(child:UIComponent):void
		{
			if(_animated == false)
				child.visible = false;
			_animator.releaseTarget(child).animate = _animateRemovingDays;
		}
		public function set dataProvider(value:CalendarSet):void
		{
			if(_dataProvider != null)
				_dataProvider.removeEventListener("change",eventsChanged);
			if(value == null)
				value = new CalendarSet();
			if(_dataProvider == value)
				return;
			_dataProvider = value;			
			if(_dataProvider != null)
				_dataProvider.addEventListener("change",eventsChanged);
			_removeAllEventData = true;
			invalidateProperties();
		}
		public function get dataProvider():CalendarSet
		{
			return _dataProvider;
		}
		

		
		private function indexForDate(value:Date):int
		{
			return Math.floor((value.getTime() - _visibleRange.start.getTime())/DateUtils.MILLI_IN_DAY);
		}
		private function dateForIndex(index:int):Date
		{
			var result:Date = new Date(_visibleRange.start.getTime());
			result.date = result.date + index;
			return result;
		}
		
		private function eventsChanged(event:Event):void
		{
			_removeAllEventData = false;
			invalidateProperties();
		}
		
//----------------------------------------------------------------------------------------------------
// Navigation
//----------------------------------------------------------------------------------------------------

		public function next():void
		{
			var r:DateRange = _currentRange.clone();
			switch(_userDisplayMode)
			{
				case "day":
					r.start.date += 1;
					r.end.date += 1;
					break;
				case "week":
					r.start.date += 7;
					r.end.date += 7;
					break;
				case "auto":
					r = _currentRange.clone();
					r.start = r.end;
					r.start.date += 1;
					r.end = new Date(r.start);
					r.end.date += _tz.daySpan(_currentRange.start,_currentRange.end)-1;
					break;
				case "month":
				default:	
					r.start.month++;
					r.end.month++;
					break;
			}
			range = r;
		}

		public function previous():void
		{
			var r:DateRange = _currentRange.clone();
			switch(_userDisplayMode)
			{
				case "day":
					r.start.date -= 1;
					r.end.date -= 1;
					break;
				case "week":
					r.start.date -= 7;
					r.end.date -= 7;
					break;
				case "auto":
					r = _currentRange.clone();
					r.end = r.start;
					r.end.date -= 1;
					r.start = new Date(r.end);
					r.start.date += _tz.daySpan(_currentRange.start,_currentRange.end)-1;
					break;
				case "month":
				default:	
					r.start.month--;
					r.end.month--;
					break;
			}
			range = r;
		}

//----------------------------------------------------------------------------------------------------
// Property Management
//----------------------------------------------------------------------------------------------------

		override protected function commitProperties():void
		{
			var prevDM:String = _displayMode;
			var prevFirstDate:Date = new Date(_visibleRange.start);
			var startIndex:int;
			var endIndex:int;
			
			if(_pendingRange != null)
			{
				_currentRange = _pendingRange;
				_pendingRange = null;
			}
			
			var oldVisible:DateRange = _visibleRange.clone();

			if(_pendingDisplayMode != null)
			{
				_displayMode = _pendingDisplayMode;
				_pendingDisplayMode = null;
			}

			var ranges:Object = computeRanges(_currentRange,_displayMode);
			

			if(oldVisible.containsRange(ranges._visibleRange))
			{				
				// we're narrowing down
				_animateRemovingDays = true;
				startIndex = indexForDate(ranges._visibleRange.start);
				endIndex = indexForDate(ranges._visibleRange.end) + 1;
				_dayCache.slice(startIndex,endIndex);
				_headerCache.slice(startIndex,endIndex);
				_visibleRange = ranges._visibleRange;
				_computedRange = ranges._computedRange;
				updateDetails();
			}
			else if (ranges._visibleRange.containsRange(oldVisible))
			{
				// we're expanding up
				_animateRemovingDays = false;
				_visibleRange = ranges._visibleRange;
				_computedRange = ranges._computedRange;
				updateDetails();

				var dayCount:int = _tz.rangeDaySpan(_visibleRange);

				startIndex = indexForDate(oldVisible.start);
				_dayCache.unslice(dayCount,startIndex);
				_headerCache.unslice(dayCount,startIndex);
			}
			else
			{
				_animateRemovingDays = false;
				_visibleRange = ranges._visibleRange;
				_computedRange = ranges._computedRange;
				updateDetails();

				dayCount = _tz.rangeDaySpan(_visibleRange);
				_dayCache.count = dayCount;				
				_headerCache.count = dayCount;				
			}			

			
			var tmp:Date = new Date(_visibleRange.start);
			for(var cPos:int = 0;cPos<_columnLength;cPos++)
			{
				for(var rPos:int=0;rPos < _rowLength;rPos++)
				{
					var index:int = rPos + cPos*_rowLength;
					
					var inst:UIComponent = _dayCache.instances[index];
					var header:UIComponent = _headerCache.instances[index];
					if(_computedRange.contains(tmp) == false)//tmp.month != month && _displayMode == "month")
					{
						IDataRenderer(inst).data = null;
						IDataRenderer(header).data = null;
					}
					else
					{
						IDataRenderer(inst).data = new Date(tmp);
						IDataRenderer(header).data = new Date(tmp);
					}
					tmp.date++;					
					
				}
			}			
			
			updateEventData();
			

			
			invalidateDisplayList();
		}

		private function computeRanges(value:DateRange,displayMode:String):Object
		{
			var _visibleRange:DateRange;
			var _computedRange:DateRange;
			
			switch(displayMode)
			{
				case "day":
					_visibleRange = new DateRange(value.start);
					_tz.expandRangeToDays(_visibleRange,true);
					_computedRange = _visibleRange.clone();
					break;
				case "days":
					_visibleRange = value.clone();
					_tz.expandRangeToDays(_visibleRange,true);
					_computedRange = _visibleRange.clone();
					break;
				case "week":
					_visibleRange = new DateRange(value.start);
					_tz.expandRangeToWeeks(_visibleRange);
					_computedRange = _visibleRange.clone();
					break;
				case "weeks":
					_visibleRange = value.clone();
					_tz.expandRangeToDays(_visibleRange,true);
					_computedRange = _visibleRange.clone();
					_tz.expandRangeToWeeks(_visibleRange);
					break;
				case "month":
				default:
					_visibleRange = new DateRange(value.start);
					_tz.expandRangeToMonths(_visibleRange,true);
					_computedRange = _visibleRange.clone();
					_tz.expandRangeToWeeks(_visibleRange);
			}
			
			return {
				_visibleRange: _visibleRange,
				_computedRange: _computedRange				
			};
		}

		private function updateDetails():void
		{

			_border.left = 0;
			_border.right = 0;
			_border.top = 0;
			_border.bottom = 0;

			
			switch(_displayMode)
			{
				case "day":
					_border.left = _hourGrid.gutterWidth;
					_border.right = _scroller.measuredWidth;
					break;
				case "days":
					_border.left = _hourGrid.gutterWidth;
					_border.right = _scroller.measuredWidth;
					break;
				case "week":
				case "weeks":
				case "month":
				default:
					break;					
			}

			_rowLength = Math.min(ROW_LENGTH,_tz.rangeDaySpan(_visibleRange));
			_columnLength = Math.ceil(_tz.rangeDaySpan(_visibleRange)/_rowLength);
			
						 
			_cellWidth = (unscaledWidth - _border.left - _border.right)/_rowLength;
			_cellHeight = (unscaledHeight - _border.top - _border.bottom)/_columnLength;		

			_visibleEvents = _dataProvider.eventsInRange(_visibleRange.start,_visibleRange.end);
			
			_hourHeight = Math.max(MIN_HOUR_HEIGHT,_cellHeight / 24);
		}
		
//----------------------------------------------------------------------------------------------------
// Layout functions
//----------------------------------------------------------------------------------------------------

		private function generateLayout():void
		{								
			if( _displayMode == "day" || _displayMode == "days" )							
			{
				layoutDays();
			}
			else
			{
				layoutMonth();
			}
		}

		private function localToDateTime(pt:Point):Date
		{
			var result:Date = new Date(_visibleRange.start);
			if(_displayMode == "day" || _displayMode == "days")
			{
				var dayIndex:Number = (pt.x - _border.left)/_cellWidth;				
				dayIndex = Math.floor(Math.max(dayIndex,0));

				var hourCount:Number = (pt.y + _scroller.scrollPosition - _allDayAreaHeight)/_hourHeight;
				hourCount = Math.round(hourCount*2)/2;
				hourCount = Math.max(0,Math.min(24,hourCount));
				result.date += dayIndex;
				result.milliseconds = result.seconds = result.minutes = 0;
				result.hours = Math.floor(hourCount);
				result.minutes = (hourCount - result.hours)*60;
				if(result > _visibleRange.end)
				{
					result.fullYear = _visibleRange.end.fullYear;
					result.month = _visibleRange.end.month;
					result.date = _visibleRange.end.date;
				}
			}
			else
			{
				var rowPos:Number = Math.floor((pt.x - _border.left)/_cellWidth);
				var collPos:Number = Math.floor((pt.y - _border.top)/_cellHeight);
				
				dayIndex = collPos * _rowLength + rowPos;
				result.date += dayIndex;				
				if(result > _visibleRange.end)
				{
					result.fullYear = _visibleRange.end.fullYear;
					result.month = _visibleRange.end.month;
					result.date = _visibleRange.end.date;
				}
			}
			return result;
		}

		private function layoutCells():void
		{		
				for(var cPos:int = 0;cPos<_columnLength;cPos++)
				{
					for(var rPos:int=0;rPos < _rowLength;rPos++)
					{
						var index:int = rPos + cPos*_rowLength;
						var inst:UIComponent = _dayCache.instances[index];
						var header:UIComponent = _headerCache.instances[index];
	
						var target:LayoutTarget = _animator.targetFor(inst);
						target.unscaledHeight = _cellHeight;
						target.unscaledWidth = _cellWidth;
						target.x = _border.left + rPos * _cellWidth;
						target.y = _border.top + cPos * _cellHeight;
	
						target = _animator.targetFor(header);
						target.unscaledHeight = header.measuredHeight;
						target.unscaledWidth = _cellWidth;
						target.x = _border.left + rPos * _cellWidth;
						target.y = _border.top + cPos * _cellHeight;
					}
				}
		}
		

		private function layoutDays():void
		{
			var startOfDay:Date = dateForIndex(0);
			var endOfDay:Date = dateForIndex(1);
			var openEventsDict:Dictionary = new Dictionary();
			var reservations:ReservationAgent = new ReservationAgent();
			var events:Array = _visibleEvents.concat();
			var renderTop:int;
			var data:EventData;
			var renderer:UIComponent;
			var target:LayoutTarget;
			var rPos:int;
			var event:CalendarEvent;
			var header:UIComponent;
			var openingEvents:Array;
			var i:int;
			_allDayAreaHeight = 0;

			// lay out the days
			layoutCells();

			target = _animator.targetFor(_scroller);
			target.initializeFunction = setupScrollbar;
			target.x = unscaledWidth - _scroller.measuredWidth;
			target.y = _border.top;
			target.unscaledWidth = _scroller.measuredWidth;
			target.unscaledHeight = _cellHeight;
			target.alpha = 1;


			// first, extract all the all-day events
			var allDayEvents:Array = [];
			for(i=events.length-1;i>=0;i--)
			{
				event = events[i];
				if(event.allDay) // || event.range.daySpan > 1)
				{
					allDayEvents.unshift(events.splice(i,1)[0]);
				}
			}
			// now place them			
			for(rPos=0;rPos < _rowLength;rPos++)
			{
				var index:int = rPos;
				header = _headerCache.instances[index];

				for(var anEvent:* in openEventsDict)
				{
					if(anEvent.event.end < startOfDay)
					{
						delete openEventsDict[anEvent];
						reservations.release(anEvent);
					}
				}
				

				if(allDayEvents.length > 0)
				{
					openingEvents = [];
						
					while(allDayEvents.length > 0 && allDayEvents[0].start.getTime() < endOfDay.getTime())
					{
						data = _eventData[allDayEvents.shift()];
						openEventsDict[data] = true;
						openingEvents.push(data);
					}
					renderTop = header.measuredHeight;
					
					var allDayBorderThickness:Number = getStyle("allDayDividerThickness");
					if(isNaN(allDayBorderThickness))
						allDayBorderThickness = 0;
						
					for(i=0;i<openingEvents.length;i++)
					{
						data = openingEvents[i];
						var reservation:int = reservations.reserve(data);
						renderer = data.renderers[0];
						ICalendarEventRenderer(renderer).displayMode = "line";
						target = layoutSingleEvent(data,renderer,
							_border.left + rPos * _cellWidth + EVENT_INSET,
							_border.top + renderTop + renderer.measuredHeight * reservation,
							_cellWidth * Math.max(1,_tz.rangeDaySpan(data.range)) - 2*EVENT_INSET,
							renderer.measuredHeight
						);
						_allDayAreaHeight = Math.max(_allDayAreaHeight,target.y + target.unscaledHeight + 2 + allDayBorderThickness);
					}
				}				
				startOfDay.date = startOfDay.date+1;
				endOfDay.date = endOfDay.date+1;														
			}
			
			startOfDay = dateForIndex(0);
			endOfDay = dateForIndex(1);
			
			
			_allDayAreaHeight = Math.max(_allDayAreaHeight,_border.top + header.measuredHeight);
			
			_dayAreaHeight = unscaledHeight - _border.bottom - _allDayAreaHeight;
			_scroller.setScrollProperties(_dayAreaHeight,0,_hourHeight * 24 - _dayAreaHeight,1);
			if(isNaN(_scrollHour))
			{
				_scrollHour = computeScrollHourToDisplayEvents(_visibleEvents);
			}
			if(_scrollHour * _hourHeight > _hourHeight * 24 - _dayAreaHeight)
				_scrollHour = 24-_dayAreaHeight/_hourHeight;
				
			_scroller.scrollPosition = _scrollHour * _hourHeight;
			
			_eventLayer.mask = _eventMask; 
			_eventMask.graphics.clear();
			_eventMask.graphics.beginFill(0);
			_eventMask.graphics.drawRect(0, _allDayAreaHeight,unscaledWidth - _border.right,_dayAreaHeight+1);
			_eventMask.graphics.endFill();

			target = _animator.targetFor(_hourGrid);
			target.initializeFunction = setupScrollbar;
			target.releaseFunction = releaseGrid;
			target.x = 0;
			target.y = _allDayAreaHeight - _scroller.scrollPosition;
			target.unscaledWidth = unscaledWidth - _border.right;
			target.unscaledHeight = 24 * _hourHeight;
			target.alpha = 1;

			target = _animator.targetFor(_allDayEventBorder);
			target.x = _border.left+1;
			target.y = _border.top + header.measuredHeight+1;
			target.unscaledWidth = unscaledWidth - _border.left - _border.right - 1;
			target.unscaledHeight = _allDayAreaHeight - target.y - 1;

			

			var daysEvents:Array = null;
			for(rPos=0;rPos < _rowLength;rPos++)
			{
				daysEvents = null;
				for(i=0;i<events.length;i++)
				{
					if(events[i].start.getTime() >= endOfDay.getTime())
					{
						daysEvents = events.splice(0,i);
						break;
					}
				}
				if(daysEvents == null)
					daysEvents = events;
				layoutSingleDay(daysEvents,_border.left + rPos * _cellWidth,_allDayAreaHeight,_cellWidth,_cellHeight - header.measuredHeight);

				index = rPos;
				header = _headerCache.instances[index];

				for(anEvent in openEventsDict)
				{
					if(anEvent.event.end < startOfDay)
					{
						delete openEventsDict[anEvent];
						reservations.release(anEvent);
					}
				}

				startOfDay.date = startOfDay.date+1;
				endOfDay.date = endOfDay.date+1;														
			}
		}

		private function layoutSingleDay(events:Array, cellLeft:Number,cellTop:Number,_cellWidth:Number,_cellHeight:Number):void
		{
			var openEvents:Array = [];
			var data:EventData;
			var reservations:ReservationAgent = new ReservationAgent();
			var pendingEvents:Array = [];
			var maxOpenEvents:int = 0;
			var renderer:UIComponent;
			var i:int;
			var target:LayoutTarget;
			
			while(1)
			{
				if(events.length == 0 && openEvents.length == 0)
					break;
				
				while(events.length > 0 && (openEvents.length == 0 || events[0].start.getTime() <= openEvents[0].end.getTime()))
				{
					var nextEvent:CalendarEvent = events.shift();
					data = _eventData[nextEvent];
					data.lane = reservations.reserve(nextEvent);

					for(i=0;i<openEvents.length;i++)
					{
						if(nextEvent.end.getTime() < openEvents[i].end.getTime())
						{
							openEvents.splice(i,0,nextEvent);
							nextEvent = null;
							break;
						}
					}
					if(nextEvent != null)
						openEvents.push(nextEvent);
					maxOpenEvents = Math.max(maxOpenEvents,openEvents.length);
				}

				while(openEvents.length > 0 && (events.length == 0 || openEvents[0].end.getTime() < events[0].start.getTime()))
				{
					var closingEvent:CalendarEvent = openEvents.shift();
					pendingEvents.push(closingEvent);
					reservations.release(closingEvent);

					if(openEvents.length == 0)
					{
						var laneWidth:Number = _cellWidth/maxOpenEvents;
						for(i=0;i<pendingEvents.length;i++)
						{
							data = _eventData[pendingEvents[i]];
							renderer = data.renderers[0];
							ICalendarEventRenderer(renderer).displayMode = "box";
							target = layoutSingleEvent(data,renderer,
								cellLeft + EVENT_INSET + data.lane * laneWidth,
								-_scroller.scrollPosition + _hourHeight * ((data.range.start.getTime() - _tz.startOfDay(data.range.start).getTime()) / DateUtils.MILLI_IN_HOUR) + cellTop,
								laneWidth - 2*EVENT_INSET,
								_hourHeight * (data.range.end.getTime() - data.range.start.getTime()) / DateUtils.MILLI_IN_HOUR
							);
							target.animate = true;
							renderer.visible = true;					
						}
						maxOpenEvents = 0;
						pendingEvents = [];
					}
				}

			}

		}


		private function layoutMonth():void
		{
			var startOfDay:Date = dateForIndex(0);
			var endOfDay:Date = dateForIndex(1);
			var openEvents:Dictionary = new Dictionary();
			var reservations:ReservationAgent = new ReservationAgent();
			var events:Array = _visibleEvents.concat();
			var renderTop:int;
			var data:EventData;
			var renderer:UIComponent;
			var target:LayoutTarget;
			var rPos:int;
			var cPos:int;
			var i:int;
			var openingEvents:Array;
			var aboveBottom:Boolean;
			
			layoutCells();
			_eventLayer.mask = null; 
			_eventMask.visible = false;

			target = _animator.releaseTarget(_scroller);
			if(target != null)
				target.animate = false;
			
			target = _animator.releaseTarget(_hourGrid);
			if(target != null)
				target.animate = false;
			
			target = _animator.releaseTarget(_allDayEventBorder);
			if(target != null)
				target.animate = false;

			for(cPos = 0;cPos<_columnLength;cPos++)
			{
				for(rPos=0;rPos < _rowLength;rPos++)
				{
					var index:int = rPos + cPos*_rowLength;
					var header:UIComponent = _headerCache.instances[index];

					for(var anEvent:* in openEvents)
					{
						if(anEvent.event.end < startOfDay)
						{
							delete openEvents[anEvent];
							reservations.release(anEvent);
						}
					}
					

					if(events.length > 0)
					{
						openingEvents = [];
							
						while(events.length > 0 && events[0].start.getTime() < endOfDay.getTime())
						{
							data = _eventData[events.shift()];
							openEvents[data] = true;
							openingEvents.push(data);
						}
						renderTop = header.measuredHeight;
						
						for(i=0;i<openingEvents.length;i++)
						{
							data = openingEvents[i];
							var reservation:int = reservations.reserve(data);
							if(_tz.rangeWeekSpan(data.range) == 1)
							{
								renderer = data.renderers[0];
								ICalendarEventRenderer(renderer).displayMode = "line";
								target = layoutSingleEvent(data,renderer,
									_border.left + rPos * _cellWidth + EVENT_INSET,
									_border.top + cPos * _cellHeight + renderTop + renderer.measuredHeight * reservation,
									_cellWidth * Math.max(1,_tz.rangeDaySpan(data.range)) - 2*EVENT_INSET,
									renderer.measuredHeight
								);
								aboveBottom = (target.y + target.unscaledHeight <= _border.top + (cPos+1) * _cellHeight)
								target.animate = aboveBottom;
								renderer.visible = aboveBottom;
							}
							else
							{
								var weekSpan:int = _tz.rangeWeekSpan(data.range);
								var daysRemaining:int = _tz.rangeDaySpan(data.range);
								var rendererStart:int = rPos;
								for(var j:int = 0;j<weekSpan;j++)
								{
									renderer = data.renderers[j];
									ICalendarEventRenderer(renderer).displayMode = "line";
									var currentDaySpan:int = Math.min(daysRemaining, 7 - rendererStart);
									target = layoutSingleEvent(data,renderer,
										_border.left + rendererStart * _cellWidth + EVENT_INSET,
										_border.top + (cPos + j) * _cellHeight + renderTop + renderer.measuredHeight * reservation,
										_cellWidth * currentDaySpan - 2*EVENT_INSET,
										renderer.measuredHeight
									);
									aboveBottom = (target.y + target.unscaledHeight <= _border.top + (cPos+j+1) * _cellHeight)
									target.animate = aboveBottom;
									renderer.visible = aboveBottom;

									daysRemaining -= currentDaySpan;
									rendererStart  = 0;
								}
							}
							
						}
					}
					
					startOfDay.date = startOfDay.date+1;
					endOfDay.date = endOfDay.date+1;														
				}
			}
		}

		
		private function layoutSingleEvent(eventData:EventData, renderer:UIComponent,x:Number,y:Number,w:Number,h:Number):LayoutTarget
		{
			var target:LayoutTarget = _animator.targetFor(renderer);
			target.initializeFunction = setupNewEventTarget;
			target.alpha = 1;
						
			if(_dragEventData == eventData)
			{
				
				if (_dragType != "grow")
				{
					if(_displayMode == "day" || _displayMode == "days")
					{
						if(eventData.event.allDay)
						{
							target.x = x;							
							target.y = y;
						}
						else
						{
							var availableWidth:Number = unscaledWidth - _border.left - _border.right;
							target.x = x;							
							target.y = y;
						}
					}
					else
					{
						target.x = x;
						target.y = y;
					}
					target.alpha = .5;
				}
				else
				{
					target.x = x;
					target.y = y;
				}
			}
			else
			{
				target.x = x;
				target.y = y;
			}

			target.unscaledHeight = h;
			target.unscaledWidth = w
			return target;
		}




		
		
//----------------------------------------------------------------------------------------------------
// scrolling
//----------------------------------------------------------------------------------------------------

		private function scrollHandler(event:ScrollEvent):void
		{
			_scrollHour = _scroller.scrollPosition / _hourHeight;
			_animator.invalidateLayout(false);
			_animator.updateLayoutWithoutAnimation();
		}

		private function get lastVisibleHour():Number
		{
			return _scrollHour + Math.floor(_dayAreaHeight / _hourHeight*2)/2;
		}

		private function guaranteeEventsAreVisible(events:Array):void
		{
			
			if(events.length == 0)
				return;
				
			var sortedHours:Array = events.concat();
			sortedHours.sortOn("start",Array.NUMERIC);
			if(sortedHours[0].start.hours < _scrollHour)
			{
				_scrollHour = sortedHours[0].start.hours;
			}
			sortedHours.sortOn("end",Array.NUMERIC | Array.DESCENDING);

			if(sortedHours[0].end.hours + sortedHours[0].end.minutes/60 > lastVisibleHour)
			{
				_scrollHour = lastVisibleHour - sortedHours[0].range.milliSpan / DateUtils.MILLI_IN_HOUR;
			}
		}
		
		private function computeScrollHourToDisplayEvents(events:Array):Number
		{
			if(events.length == 0)
				return 8;
				
			var hoursSortedByStartTime:Array = events.concat();
			hoursSortedByStartTime.sort(function(lhs:CalendarEvent, rhs:CalendarEvent):Number
			{
				var ltime:Number = _tz.timeOnly(lhs.start);
				var rtime:Number = _tz.timeOnly(rhs.end);
				return (rhs.allDay || ltime < rtime)? -1:
					   (lhs.allDay || ltime > rtime)? 1:
					   					0;
			}
			);
			return hoursSortedByStartTime[0].allDay? 8:hoursSortedByStartTime[0].start.hours;
		}
		

//----------------------------------------------------------------------------------------------------
// animation callbacks
//----------------------------------------------------------------------------------------------------

		private function setupNewEventTarget(target:LayoutTarget):void
		{
			if(_dragEventData != null && IDataRenderer(target.item).data == _dragEventData.event)
			{
				target.item.setActualSize(target.unscaledWidth,target.unscaledHeight);
				target.item.x = target.x;
				target.item.y = target.y;
				var m:Matrix = DisplayObject(target.item).transform.matrix;
				m.a = m.d = 1;
				DisplayObject(target.item).transform.matrix = m;
			}
			else
			{
				target.item.setActualSize(target.unscaledWidth,target.unscaledHeight);
				target.item.x = target.x + target.unscaledWidth/2;
				target.item.y = target.y + target.unscaledHeight/2;
				var m:Matrix = DisplayObject(target.item).transform.matrix;
				m.a = m.d = 0;
				DisplayObject(target.item).transform.matrix = m;
			}
		}

		private function setupScrollbar(target:LayoutTarget):void
		{
			target.item.setActualSize(target.unscaledWidth,target.unscaledHeight);
			target.item.x = target.x;
			target.item.y = target.y;
			target.item.alpha = 0;
		}
		private function releaseGrid(target:LayoutTarget):void
		{
			target.alpha = 0;
			target.unscaledHeight = target.item.height;
			target.unscaledWidth  = target.item.width;
			target.x = target.item.x;
			target.y = target.item.y;						
		}
		
		
//----------------------------------------------------------------------------------------------------
// managing event data
//----------------------------------------------------------------------------------------------------

		private function updateEventData():void
		{
			if(false && _removeAllEventData)
			{
				removeAllEventData();
				for(var i:int = 0;i<_visibleEvents.length;i++)
				{
					var event:CalendarEvent = _visibleEvents[i];
					buildEventData(event);
				}
			}
			else
			{
				var oldEventData:Dictionary = _eventData;
				_eventData = new Dictionary();
				
				for(i = 0;i<_visibleEvents.length;i++)
				{
					event = _visibleEvents[i];
					var ed:EventData = oldEventData[event];
					if(ed == null)
					{
						buildEventData(event);
					}
					else
					{
						_eventData[event] = ed;
						validateEventData(ed);
						delete oldEventData[event];
					}
				}
				for(var anEvent:* in oldEventData)
				{
					removeEventData(oldEventData[anEvent]);
				}			
			}
			
		}
		private function removeAllEventData():void
		{
			for(var aKey:* in _eventData)
			{
				var data:EventData = _eventData[aKey];
				for(var i:int=0;i<data.renderers.length;i++)
				{
					var renderer:UIComponent = data.renderers[i];
					renderer.parent.removeChild(renderer);
					var target:LayoutTarget = _animator.releaseTarget(renderer);
					if(target != null)
						target.animate = false;										
				}
			}
			_eventData = new Dictionary();
		}
		private function removeEventData(data:EventData):void
		{
			for(var i:int=0;i<data.renderers.length;i++)
			{
				var renderer:UIComponent = data.renderers[i];
				renderer.parent.removeChild(renderer);
				var target:LayoutTarget = _animator.releaseTarget(renderer);
				if(target != null)
					target.animate = false;										
			}
		}
		
		private function buildEventData(event:CalendarEvent):EventData
		{
			var data:EventData = _eventData[event] = new EventData();
			data.renderers = [];
			data.event = event;
			validateEventData(data);
			return data;
		}

		private function validateEventData(data:EventData):void
		{
			var event:CalendarEvent = data.event;
			data.range = event.range.intersect(_visibleRange);
			
			var weekSpan:int = _tz.rangeWeekSpan(data.range);
			var parent:UIComponent = (event.allDay)? _allDayEventLayer:_eventLayer;
			var sn:String = getStyle("eventStyleName");
			var rendererCount:Number = data.renderers.length;
			
			if(weekSpan > rendererCount)
			{
				for(var i:int = rendererCount;i<weekSpan;i++)
				{				
					var renderer:CalendarEventRenderer = new CalendarEventRenderer();
					renderer.addEventListener(MouseEvent.MOUSE_DOWN,eventDownHandler);
					data.renderers.push(renderer);
					renderer.data = event;
					renderer.styleName = sn;
					parent.addChild(renderer);
					if(data == _dragEventData)
					{
						renderer.filters = [
							_dragFilter
						]									
					}
				}
			}
			else
			{
				for(var i:int = weekSpan;i<rendererCount;i++)
				{
					renderer = data.renderers[i];
					renderer.parent.removeChild(renderer);
				}
				data.renderers.splice(weekSpan,rendererCount-weekSpan);
			}
		}
		
//----------------------------------------------------------------------------------------------------
// click event handlers
//----------------------------------------------------------------------------------------------------

		private function headerClickHandler(e:MouseEvent):void
		{
			var d:Date = IDataRenderer(e.currentTarget).data as Date;
			if(d == null)
				return;
			var newEvent:CalendarDisplayEvent = new CalendarDisplayEvent(CalendarDisplayEvent.HEADER_CLICK);
			newEvent.dateTime = d;
			dispatchEvent(newEvent);
		}

		private function dayClickHandler(e:MouseEvent):void
		{
			var d:Date = IDataRenderer(e.currentTarget).data as Date;
			if(d == null)
				return;
			var newEvent:CalendarDisplayEvent = new CalendarDisplayEvent(CalendarDisplayEvent.DAY_CLICK);
			newEvent.dateTime = d;
			dispatchEvent(newEvent);
		}

//----------------------------------------------------------------------------------------------------
// event dragging behavior
//----------------------------------------------------------------------------------------------------

		private function eventDownHandler(e:MouseEvent):void
		{
			var tracking:Boolean = false;
			_dragRenderer = UIComponent(e.currentTarget);
			var event:CalendarEvent = CalendarEvent(IDataRenderer(_dragRenderer).data);
			_dragEventData = _eventData[event];			
			_dragDownPt = new Point(mouseX,mouseY);
			
			systemManager.addEventListener(MouseEvent.MOUSE_MOVE,eventOverHandler,true);
			systemManager.addEventListener(MouseEvent.MOUSE_UP,eventUpHandler,true);
		}

		private function eventOverHandler(mdEvent:MouseEvent):void
		{
			if(_dragType == null)
			{
			
				if(Math.abs(_dragDownPt.x - mouseX) <= 2 && Math.abs(_dragDownPt.y - mouseY) <= 2)
					return;						
				initDrag(_dragRenderer,mdEvent);
				return;
			}

			if(_dragType == "grow")
			{				
				dragOver(_dragEventData.event,_dragEventData,_dragOffset);
			}
		}
		
		private function eventUpHandler(e:MouseEvent):void
		{
			systemManager.removeEventListener(MouseEvent.MOUSE_MOVE,eventOverHandler,true);
			systemManager.removeEventListener(MouseEvent.MOUSE_UP,eventUpHandler,true);

			if(_dragType == "grow")
				dragUp(_dragEventData);
			else if (_dragType == null)
			{
				var ce:CalendarDisplayEvent = new CalendarDisplayEvent(CalendarDisplayEvent.ITEM_CLICK);
				ce.event = _dragEventData.event;
				dispatchEvent(ce);
			}
							
			_dragType = null;
			_dragEventData = null;
			_dragDownPt = null;
			_dragRenderer = null;
		}
		
		private function initDrag(renderer:UIComponent,mouseEvent:MouseEvent):void
		{
			var event:CalendarEvent = CalendarEvent(IDataRenderer(renderer).data);
			var data:EventData = _eventData[event];
			var changeDayOnly:Boolean = (_displayMode == "weeks" || _displayMode == "week" || _displayMode == "month" || event.allDay);
			_dragType = (changeDayOnly == false && (renderer.height - renderer.mouseY) < 10)?
							"grow":"move";
			var offset:Point = new Point(0,(_dragType == "grow")? (renderer.mouseY-renderer.height):renderer.mouseY);
			
			
			var newTime:Date = localToDateTime(new Point(mouseX,mouseY));

			var changeDayOnly:Boolean = (_displayMode == "weeks" || _displayMode == "week" || _displayMode == "month" || event.allDay);

			if(changeDayOnly)
				_dragOffset = (_tz.toDays(newTime) - _tz.toDays(event.start))*DateUtils.MILLI_IN_DAY;
			else
				_dragOffset = (_tz.toHours(newTime) - _tz.toHours(event.start))*DateUtils.MILLI_IN_HOUR;
			

			for(var i:int = 0;i<data.renderers.length;i++)
			{
				var r:UIComponent = data.renderers[i];
				r.parent.setChildIndex(r,r.parent.numChildren-1);
			}
			
			_dragEventData = data;
			
			if(_dragType == "move")
			{			
				var ds:DragSource = new DragSource();
				ds.addData(event,"event");
				ds.addData(data,"event.data");
				ds.addData(_dragOffset,"event.dragOffset");
				ds.addData(event.range.clone(),"event.originalRange");				
				var dragImageClass:Class = getStyle("eventDragSkin");
				var icon:IFlexDisplayObject = new dragImageClass();
				DragManager.doDrag(this,ds,mouseEvent, icon,-mouseX,-mouseY,.8);
			}

			for(var i:int = 0;i<data.renderers.length;i++)
			{
				var r:UIComponent = data.renderers[i];
				r.filters = [_dragFilter];						
			}
		}

		private function dragEnterHandler(e:DragEvent):void
		{
	    	DragManager.acceptDragDrop(this);
			e.action = DragManager.LINK;
			DragManager.showFeedback(DragManager.LINK);

			var data:EventData = EventData(e.dragSource.dataForFormat("event.data"));
			var dragOffset:Number = Number(e.dragSource.dataForFormat("event.dragOffset"));
			var event:CalendarEvent = CalendarEvent(e.dragSource.dataForFormat("event"));

			for(var i:int = 0;i<data.renderers.length;i++)
			{
				var r:UIComponent = data.renderers[i];
				r.filters = [_dragFilter];						
			}
			dragOver(event,data,dragOffset);
		}
		
		private function dragOver(event:CalendarEvent,data:EventData,dragOffset:Number):void
		{
			var changeDayOnly:Boolean = (_displayMode == "weeks" || _displayMode == "week" || _displayMode == "month" || event.allDay);
			
			var newTime:Date = localToDateTime(new Point(mouseX,mouseY));

			if(_dragType == "move")
				newTime.milliseconds -= dragOffset;
			
			var r:DateRange = event.range;
			if(changeDayOnly)
			{
				newTime.hours = r.start.hours;
				newTime.minutes = r.start.minutes;
				newTime.seconds = r.start.seconds;
				newTime.milliseconds = r.start.milliseconds;					
				r.moveTo(newTime);
			}
			else
			{
				if(_dragType == "grow")
				{
					newTime.setTime(Math.max(newTime.getTime(),r.start.getTime() + DateUtils.MILLI_IN_HOUR/2) - 1);
					r.end = newTime;
				}
				else
					r.moveTo(newTime);
			}
				
			event.range = r;
			data.range = r.intersect(_visibleRange);

			_animator.invalidateLayout();
		}

		private function dragOverHandler(e:DragEvent):void
		{
	    	DragManager.acceptDragDrop(this);
			e.action = DragManager.LINK;
			DragManager.showFeedback(DragManager.LINK);

			var dragOffset:Number = Number(e.dragSource.dataForFormat("event.dragOffset"));
			var event:CalendarEvent = CalendarEvent(e.dragSource.dataForFormat("event"));
			var data:EventData = EventData(e.dragSource.dataForFormat("event.data"));

			dragOver(event,data,dragOffset);
		}

		private function dragExitHandler(e:DragEvent):void
		{
	    	DragManager.acceptDragDrop(this);
			e.action = DragManager.LINK;
			DragManager.showFeedback(DragManager.LINK);

			var event:CalendarEvent = CalendarEvent(e.dragSource.dataForFormat("event"));
			var data:EventData = EventData(e.dragSource.dataForFormat("event.data"));
			var originalRange:DateRange = DateRange(e.dragSource.dataForFormat("event.originalRange"));
			
			dragUp(data);

			event.range = originalRange.clone();
			data.range = originalRange.intersect(_visibleRange);

			_animator.invalidateLayout();
		}

		private function dragUp(data:EventData):void
		{
			_dragEventData = null;
			_removeAllEventData = false;
			for(var i:int = 0;i<data.renderers.length;i++)
			{
				var r:UIComponent = data.renderers[i];
				r.filters = [];						
			}
			invalidateProperties();
		}
		private function dragDropHandler(e:DragEvent):void
		{
			var data:EventData = EventData(e.dragSource.dataForFormat("event.data"));

	    	DragManager.acceptDragDrop(this);
			e.action = DragManager.LINK;
			DragManager.showFeedback(DragManager.LINK);
			
			dragUp(data);

		}
		
//----------------------------------------------------------------------------------------------------
// child initialization callbacks
//----------------------------------------------------------------------------------------------------
		
		private function dayChildCreated(instance:UIComponent,idx:int):void
		{
			instance.styleName = getStyle("dayStyleName");
			_dayLayer.addChild(instance);
			instance.addEventListener(MouseEvent.CLICK,dayClickHandler);
		}
		private function headerChildCreated(instance:UIComponent,idx:int):void
		{
			instance.styleName = getStyle("dayHeaderStyleName");
			_headerLayer.addChild(instance);
			instance.addEventListener(MouseEvent.CLICK,headerClickHandler);
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			updateDetails();
			if(_animated)
				_animator.invalidateLayout(true);
			else
			{
				_animator.invalidateLayout();
				_animator.updateLayoutWithoutAnimation();
			}			
		}
		
		override public function styleChanged(styleProp:String):void
		{
			var sn:String;
			var len:Number;
			var i:Number;
			
			if(styleProp == "hourStyleName" || styleProp == null)
			{
				_hourGrid.styleName = getStyle("hourStyleName");
			}
			if(styleProp == "dayStyleName" || styleProp == null)
			{
				sn = getStyle("dayStyleName");
				len = _dayCache.instances.length;
				for(i = 0;i<len;i++)
				{
					_dayCache.instances[i].styleName = sn;
				}
			}
			if(styleProp == "dayHeaderStyleName" || styleProp == null)
			{
				sn = getStyle("dayHeaderStyleName");
				len = _headerCache.instances.length;
				for(i = 0;i<len;i++)
				{
					_headerCache.instances[i].styleName = sn;
				}
			}
			if(styleProp == "eventStyleName" || styleProp == null)
			{
				sn = getStyle("eventStyleName");
				for (var key:* in _eventData)
				{
					var data:EventData = _eventData[key];
					len = data.renderers.length;
					for(i=0;i<len;i++)
					{
						data.renderers[i].styleName = sn;
					}
				}
			}
		}
	}
}


import qs.calendar.CalendarEvent;
import mx.core.UIComponent;
import qs.utils.DateRange;
	

class EventData
{
	public var event:CalendarEvent;
	public var renderers:Array;
	public var range:DateRange;
	public var lane:int;
}

/*
Weather Station Construction Kit Version Zero

Copyright (c) 2009, Roger Webster

Last update: 2009-01-11

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/


package WeatherGadgets {
	import flash.events.TimerEvent;
	
	import mx.controls.Alert;
	import mx.core.IMXMLObject;
	import mx.events.PropertyChangeEvent;
	import mx.formatters.NumberFormatter;
	import mx.rpc.*;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.mxml.HTTPService;
			
	[PersistentProperties("label")]
	[DesignModeOnly]
	public class WeatherService implements IMXMLObject {
		
		private var numForm : NumberFormatter = null;;
		
		[Bindable]
		[Inspectable]
		public var id : String = null;
		
		public function initialized (doc : Object, theId : String) : void {
			id = theId;
		}		
		
		[Bindable]
		[AutoConnect(source)]
		public function get humidity () : Number {
			return _humidity;
		}
		private function set humidity (h : Number) : void {
			_humidity = h
		}
		[Bindable]
		private var _humidity : Number = 0;
		
		[Bindable]
		[AutoConnect(source)]
		public var barometer : Number = 0;
		
		[Bindable]
		[AutoConnect(source)]
		public var barometerTrend : String = "";
		
		[Bindable]
		[AutoConnect(source)]
		public var rainToday : Number = 0;
		
		[Bindable]
		[AutoConnect(source)]
		public var averageWindSpeed : Number = 0;
		
		[Bindable]
		[AutoConnect(source)]
		public var windGust : Number = 0;
		
		[Bindable]
		[AutoConnect(source)]
		public var windDirectionName : String = "";
		
		[Bindable]
		[AutoConnect(source)]
		public var cloudHeight : Number = 0;
		
		[Bindable]
		[AutoConnect(source)]
		public var apparentTemperature : Number = 0;
		
		[Bindable]
		[AutoConnect(source)]
		public var heatIndex : Number = 0;
		
		[Bindable]
		[AutoConnect(source)]
		public var dayHighTemperatureOutside : Number = 0;
		
		[Bindable]
		[AutoConnect(source)]
		public var dayLowTemperatureOutside : Number = 0;
		
		[Bindable]
		[AutoConnect(source)]
		public var yearRain : Number = 0;
		
		[Bindable]
		[AutoConnect(source)]
		public var rainRate : Number = 0;
		
		[Bindable]
		[AutoConnect(source)]
		public var dayHighRainRate : Number = 0;
		
		[Bindable]
		[AutoConnect(source)]
		public var dayHighRainRateTime : String = "";
		
		[Bindable]
		[AutoConnect(source)]
		public var dayLowTemperature : Number = 0;
		
		[Bindable]
		[AutoConnect(source)]
		public var temperatureInside : Number = 0;
		
		[Bindable]
		[AutoConnect(source)]
		public var humidityInside : Number = 0;
		
		[Bindable]
		[AutoConnect(source)]
		public var solarRadiation : Number = 0;
		
		[Bindable]
		[AutoConnect(source)]
		public var dayHighTemperature : Number = 0;
		
		[Bindable]
		[AutoConnect(source)]
		public var windChill : Number = 0;
		
		[Bindable]
		[AutoConnect(source)]
		public var dayHighWindSpeed : Number = 0;
		
		[Bindable]
		[AutoConnect(source)]
		public var dewPoint : Number = 0;
		
		[Bindable]
		[AutoConnect(source)]
		public var UV : Number = 0;
		
		[Bindable]
		[AutoConnect(source)]
		public var hours : Number = 0;
		
		[Bindable]
		[AutoConnect(source)]
		public var minutes : Number = 0;
		
		[Bindable]
		[AutoConnect(source)]
		public var seconds : Number = 0;
		
		[Bindable]
		[AutoConnect(source)]
		public var day : Number = 0;
		
		[Bindable]
		[AutoConnect(source)]
		public var month : Number = 0;
		
		[Bindable]
		[AutoConnect(source)]
		public var year : Number = 0;
		
		[Bindable]
		[AutoConnect(source)]
		public var THSW : Number = 0;
		
		[Bindable]
		[AutoConnect(source)]
		public var monthRain : Number = 0;
		
		[Bindable]
		[AutoConnect(source)]
		public var reportDate : String = "";
		
		[Bindable]
		[AutoConnect(source)]
		public var reportTime : String = "";
		
		[Bindable]
		[AutoConnect(source)]
		public var rawDateString : String = "";
		
		[Bindable]
		[AutoConnect(source)]
		public var stationSunrise : String = "";
		
		[Bindable]
		[AutoConnect(source)]
		public var stationSunset : String = "";
		
		[Bindable]
		[AutoConnect(source)]
		public var stationName : String = "";
		
		[Bindable]
		[AutoConnect(source)]
		public var dayWindHighTime : String = "";
		
		// Control dynamic reusability...
		private var r : Boolean = true;
		
		private var speed : Number;
		private var direction : Number;
		private var temp : Number;
		
		[Bindable]
		private var useMetric : Boolean = false;
		
		[Editable(type=Boolean, Name="Metric")]
		[Bindable]
		[Inspectable]
		public function set metric (b : Boolean) : void {
			useMetric = b;
			if (b) {
				windSuffix = " kph";
				rainSuffix = ' mm';
			}
			else {
				windSuffix = " mph";
				rainSuffix = '"';
			}
		}
		public function get metric () : Boolean {
			return useMetric;
		}
		
		[Bindable]
		private var _label : String = null;
		
		[Inspectable]
		public function set label (s : String) : void {
			_label = s;
		}
		public function get label () : String {
			return _label;
		}
		
		[Bindable]
		public var _windSuffix : String = " mph";
		
		[Bindable]
		public function set windSuffix (s : String) : void {
			_windSuffix = s;
		}
		public function get windSuffix () : String {
			return _windSuffix;
		}
		
		[Bindable]
		public var _rainSuffix : String = '"';
		
		[Bindable]
		public function set rainSuffix (s : String) : void {
			_rainSuffix = s;
		}
		public function get rainSuffix () : String {
			return _rainSuffix;
		}
		
		[Bindable]
		[AutoConnect(source, order=1)]
		public function get windSpeed () : Number {
			return _value1;
		}
		private function set windSpeed (v : Number) : void {
			_value1 = v;
		}
		
		[Bindable]
		[AutoConnect(source, order=2)]
		public function get windDirection () : Number {
			return _value2;
		}
		private function set windDirection (v : Number) : void {
			_value2 = v;
		}
		
		[Bindable]
		[AutoConnect(source, order=3)]
		public function get temperature () : Number {
			return temp;
		}
		private function set temperature (v : Number) : void {
			temp = v;
		}

		private var _value1 : Number = 0;
		private var _value2 : Number = 0;	
		
		private var weatherService : HTTPService = null;
		
		private var timer : MyTimer;

		private function gotFault (event : FaultEvent) : void {
			trace("FAULT");
		}
		
		private function forceUpdate (propertyName : String, property : String, newValue : String) : void {
			if (isNaN(Number(newValue)))
				property = "0";
			else {
				if (newValue == property) {
					var e : PropertyChangeEvent = PropertyChangeEvent.createUpdateEvent(this, propertyName, newValue, newValue);
					this.dispatchEvent(e);
				}
				this[propertyName] = newValue;
			}
		}
		
		private function forceUpdateNumber (propertyName : String, property : Number, newValue : Number) : void {
			if (isNaN(newValue))
				property = 0;
			else {
				if (newValue == property) {
					var e : PropertyChangeEvent = PropertyChangeEvent.createUpdateEvent(this, propertyName, newValue, newValue);
					this.dispatchEvent(e);
				}
				this[propertyName] = newValue;
			}
		}
		
		private var decoder : ClientRawDecoder = null;
		
		private function gotResult (event : ResultEvent) : void {
			if (event == null || event.result == null)
				return;
				
			if (usingRaw) {
				if (decoder == null)
					decoder = new ClientRawDecoder();
				
				var s : String = event.result as String;
				
				if (s.length < 5)
					return;
					
				if (decoder != null) {
					decoder.Decode((String) (event.result), metric, metric ? 2 : 1, metric);
					 
					forceUpdateNumber("temperature", temperature, decoder.TempOut); 
					// temperature 								= decoder.TempOut;
					humidity 										= decoder.HumOut;
					barometer 									= decoder.Baro;
					rainToday 									= decoder.DayRain;
					windGust 										= decoder.DayWindHi;
					averageWindSpeed 						= decoder.Wind10Avg;
					dayHighTemperatureOutside 	= decoder.DayHiTemp;
					dayLowTemperatureOutside 		= decoder.DayLowTemp;
					forceUpdateNumber("windSpeed", windSpeed, decoder.WindSpeed);
					// windSpeed 									= decoder.WindSpeed;
					forceUpdateNumber("windDirection", windDirection, decoder.WindDir);
					// windDirection 							= decoder.WindDir;
					dewPoint 										= decoder.DewOut;
					yearRain 										= decoder.YearRain;
					apparentTemperature 				= decoder.ApparentTemp;
					barometerTrend 							= decoder.BaroTrend;
					cloudHeight 								= decoder.CloudHeight;
					day													= decoder.Day;
					dayHighRainRate							= decoder.DayHiRainRate;
					dayHighRainRateTime					= decoder.DayHiRainRateTime();
					dayWindHighTime							= decoder.DayWindHiTime;
					reportDate									= decoder.FriendlyDate;
					reportTime									= decoder.FriendlyTime;
					heatIndex										= decoder.HeatIndex;
					hours												= decoder.Hours;
					humidityInside							= decoder.HumIn;
					minutes											= decoder.Minutes;
					month												= decoder.Month;
					monthRain										= decoder.MonthRain;
					rainRate										= decoder.RainRate;
					seconds											= decoder.Seconds;
					solarRadiation							= decoder.SolRad;
					stationName									= decoder.StationName;
					stationSunrise							= decoder.StationSunrise;
					stationSunset								= decoder.StationSunset;
					// decoder.StormRain;
					temperatureInside						= decoder.TempIn;
					rawDateString								= decoder.TheDate;
					THSW 												= decoder.THSW;
					UV													= decoder.UV;
					forceUpdateNumber("windChill", windChill, decoder.WindChill); 
					// windChill										= decoder.WindChill;
					windDirectionName						= decoder.WindDirection;
					year 												= decoder.Year;
				}
			}
		}
		
		private static var sequenceNumber : int = 0;

		private function startTimer () : void {
			if (timer == null) {
				timer = new MyTimer(2200, 0);
				timer.sequenceNumber = sequenceNumber++;
				timer.addEventListener(TimerEvent.TIMER, onTick);
				timer.start();
			}
		}

		private function stopTimer () : void {
			if (timer != null) {
				timer.removeEventListener(TimerEvent.TIMER, onTick);
				timer.stop();
				timer = null;
			}
		}


		private function onTick (event : TimerEvent) : void {
			var mt : MyTimer = MyTimer(event.target);
			if (mt.sequenceNumber != sequenceNumber - 1) {
				mt.stop();
			}
			else
				weatherService.send();
		}
		
		// private static const myRaw : String = "http://Rog-PC-VistaRC1/clientraw.txt";
		private static const myRaw : String = "http://63.197.233.9/clientraw.txt";
		private static const theirRaw : String = "http://weather.adobe.com/sanjose/clientraw.txt";
		
		private var clientRawURL 	: String = myRaw;
		private var usingRaw 			: Boolean = true;
		
		[Bindable]
		[Persistent]
		[Editable]
		public function set ClientRawURL (s : String) : void {
			stopTimer();
			clientRawURL = s;
			setupService();
		}
		
		public function get ClientRawURL () : String {
			return clientRawURL;
		}
		
		private function setupService () : void {			
			stopTimer();
			
			if (weatherService == null) {
				weatherService = new HTTPService();
				weatherService.url = clientRawURL;
				weatherService.useProxy = false;
				weatherService.method = "GET";
				weatherService.addEventListener(ResultEvent.RESULT, gotResult);
				weatherService.addEventListener(FaultEvent.FAULT, gotFault);
			}
			else
				weatherService.url = clientRawURL;
			
			weatherService.send();

			startTimer();
		}
		
		public function WeatherService () {
			super();
			
			setupService();
		}
		
		public function get reusable () : Boolean {
			return r;
		}
		
		public function set reusable (b : Boolean) : void {
			r = b;
		}
	}
}
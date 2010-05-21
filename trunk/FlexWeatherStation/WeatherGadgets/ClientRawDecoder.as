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
	import flash.events.EventDispatcher;
	
	import mx.controls.Alert;
	import mx.formatters.NumberFormatter;
	
	public class ClientRawDecoder extends EventDispatcher {
		private var elements : Array = [];
		private var extraElements : Array = [];
		private var windConversion : Number = 1.15077945;
		private var isValid : Boolean = false;
		private var metricConversion : Number = 1.0;
		private var baroConversion : Number = 1.0;
		private var useCelsius : Boolean = false;
		private var formatter : NumberFormatter = null;
		
		// "Bindable" items so updates will occur when values change.
		[Bindable]
		private var windSpeed : Number = 0;
		[Bindable]
		private var wind10Avg : Number = 0;
		[Bindable]
		private var windDir : Number = 0;
		[Bindable]
		private var windGust : Number = 0;
		[Bindable]
		private var windDirection : String = "";
		[Bindable]
		private var apparentTemp : Number = 0;
		[Bindable]
		private var heatIndex : Number = 0;
		[Bindable]
		private var dewOut : Number = 0;
		[Bindable]
		private var tempOut : Number = 0;
		[Bindable]
		private var thsw : Number = 0;
		[Bindable]
		private var dayHiTemp : Number = 0;
		[Bindable]
		private var dayLowTemp : Number = 0;
		[Bindable]
		private var humOut : Number = 0;
		[Bindable]
		private var baro : Number = 0;
		[Bindable]
		private var dayRain : Number = 0;
		[Bindable]
		private var stormRain : Number = 0;
		[Bindable]
		private var monthRain : Number = 0;
		[Bindable]
		private var yearRain : Number = 0;
		[Bindable]
		private var rainRate : Number = 0;
		[Bindable]
		private var dayHiRainRate : Number = 0;
		[Bindable]
		private var stationSunrise : String = "";
		[Bindable]
		private var stationSunset : String = "";
		[Bindable]
		private var dayWindHi : Number = 0;
		[Bindable]
		private var dayWindHiTime : String = "";
		[Bindable]
		private var baroTrend : String = "";
		
		private static var directions : Array = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE", "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW", "N"];
		
		private static var months : Array = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
		
		public function ClientRawDecoder () {
			formatter = new NumberFormatter();
			formatter.decimalSeparatorTo = ".";
			formatter.decimalSeparatorFrom = ".";
			formatter.rounding = "nearest";
			formatter.thousandsSeparatorTo = ",";
			formatter.thousandsSeparatorFrom = ",";
			formatter.useNegativeSign = true;
			formatter.useThousandsSeparator = true;
		}
		
		public function Decode (s : String, useC : Boolean, wind : int, useMetric : Boolean) : Boolean {
			formatter.precision = 1;
			
			switch (wind) {
				case 0: windConversion = 1.0;
									break;
				case 1: windConversion = 1.15077945;
									break;
				case 2: windConversion = 1.0 / 0.514444444;
									break;
			}
			
			useCelsius = useC;
				
			if (! useMetric) {
				metricConversion = 0.0393700787;
				baroConversion = 0.0295301;
			}
				
			var el : Array = s.split(" ");
			isValid = (el.length > 0);
			isValid = isValid && ((el[0] == "12345") || (el[0] == "Wind"));
			
			if (el[0] == "12345")
				elements = el;
				
			var ws : Number = Number(el[2]);
			ws = Number(formatter.format(ws * windConversion));
			WindSpeed = ws;
			
			WindDir = Number(el[3]);
			
			var n : Number = Number(elements[3]);
			n = (n + (22.5 / 2));
			n = n / (22.5);
			n = Math.round(n);
			windDirection = directions[n];
			WindDirection = directions[n];
			
			windGust = Number(elements[2]);
			WindGust = Number(formatter.format(windGust * windConversion));
			
			if (el[0] == "12345") {
				wind10Avg = Number(elements[158]);
				Wind10Avg =  Number(formatter.format(wind10Avg * windConversion));
				
				apparentTemp = Number(elements[130]);
				ApparentTemp = Number(formatter.format(ConvertTemperature(apparentTemp)));
				
				heatIndex = Number(elements[112]);
				HeatIndex = Number(formatter.format(ConvertTemperature(heatIndex)));
				
				tempOut = Number(elements[4]);
				var nnn : Number = ConvertTemperature(tempOut);
				var ss : String = formatter.format(nnn);
				TempOut = Number(ss);
				
				bogusBindableTHSW = tempOut;		// Any number would do.
				
				n = Number(elements[46]);
				n = Number(formatter.format(ConvertTemperature(n)));
				DayHiTemp = n;
				
				n = Number(elements[47]);
				n = Number(formatter.format(ConvertTemperature(n)));
				DayLowTemp = n;
				
				n = Number(elements[11]);
				if (!useMetric)
					n *= metricConversion;
				formatter.precision = 2;
				n = Number(formatter.format(n * 60));
				formatter.precision = 1;
				DayHiRainRate = n;
				
				if (extraElements.length > 556) {
					StationSunrise = fixTime(extraElements[556]);
				}
				
				if (extraElements.length > 557) {
					StationSunset = fixTime(extraElements[557]);
				}
				
				n = Number(elements[7]);
				if (!useMetric)
					n *= metricConversion;
				formatter.precision = 2;
				formatter.rounding = "nearest";
				n = Number(formatter.format(n));
				formatter.precision = 1;
				DayRain = n;
				// Alert.show(n + "");
				
				HumOut = Number(elements[5]);
				
				n = Number(elements[72]);
				DewOut = Number(formatter.format(ConvertTemperature(n)));
				
				n = Number(elements[71]);
				DayWindHi = Number(formatter.format(n * windConversion));
				
				var t : String = elements[135];
				if (t == null)
					DayWindHiTime = "";
				else
					DayWindHiTime = fixWDTimeString(t);
					
				n = Number(elements[6]);
				formatter.precision = 3;
				if (useMetric)
					Baro = n;
				else
					Baro = Number(formatter.format(n * baroConversion));
					
				formatter.precision = 1;
				
				n = Number(elements[10]);
				if (!useMetric)
					n *= metricConversion;
				formatter.precision = 2;
				n = Number(formatter.format(n * 60));
				RainRate = n;
				formatter.precision = 1;
				
				n = Number(elements[9]);
				if (!useMetric)
					n *= metricConversion;
				formatter.precision = 2;
				n = Number(formatter.format(n));
				YearRain = n;
				formatter.precision = 1;
				
				n = Number(elements[50]);
				if (n < 0)
					BaroTrend = "Falling";
				else
					if (n > 0)
						BaroTrend = "Rising";
					else
						BaroTrend = "Steady";
			}
			
			return isValid;
		}
		
		public function UseExtraString (s : String) : void {
			extraElements = s.split(" ");
		}
		
		static public function ConvertCelsiusToFahrenheit (c : Number) : Number {
			var f : Number = (9.0 / 5.0) * c + 32.0;
				
			return f;
		}
		
		public function ConvertTemperature (degreesC : Number) : Number {
			var f : Number = degreesC;
			
			if (! useCelsius)
				f = (9.0 / 5.0) * degreesC + 32.0;
				
			return f;
		}
		
		public function get IsValid () : Boolean {
			return isValid;
		}
		
		private function set WindSpeed (ws : Number) : void {
			windSpeed = ws;
		}
		
		[Bindable]
		public function get WindSpeed () : Number {
			return windSpeed;
		}
		
		[Bindable]
		public function get Wind10Avg () : Number {
			return wind10Avg;
		}
		private function set Wind10Avg (w : Number) : void {
			wind10Avg = w;
		}
		
		[Bindable]
		public function get WindGust () : Number {
			return windGust;
		}
		public function set WindGust (w : Number) : void {
			windGust = w;
		}
		
		[Bindable]
		public function get WindDir () : Number {
			return windDir;
		}
		public function set WindDir (w : Number) : void {
			windDir = w;
		}
		
		[Bindable]
		public function get WindDirection () : String {
			return windDirection;
		}
		public function set WindDirection (w : String) : void {
			windDirection = w;
		}
		
		[Bindable]
		public function get ApparentTemp () : Number {
			return apparentTemp;
		}
		public function set ApparentTemp (w : Number) : void {
			apparentTemp = w;
		}
		
		[Bindable]
		public function get HeatIndex () : Number {
			return heatIndex;
		}
		public function set HeatIndex (w : Number) : void {
			heatIndex = w;
		}
		
		[Bindable]
		public function get TempOut () : Number {
			return tempOut;
		}
		public function set TempOut (w : Number) : void {
			tempOut = w;
		}
		
		[Bindable]
		private var bogusBindableTHSW : Number = -1;
		
		[Bindable]
		public function get THSW () : Number {
			var n : Number = Number(elements[142]);
			return 0.0;		// Could be C or F, no way to tell.  Also, hugely unreliable.
			// return Number(formatter.format(ConvertTemperature(n)));
			// return n;		// Already in degrees F.  Sigh.
		}
		private function set THSW (v : Number) : void {
			bogusBindableTHSW = v;
		}
		
		[Bindable]
		public function get DayHiTemp () : Number {
			return dayHiTemp;
		}
		private function set DayHiTemp (n : Number) : void {
			dayHiTemp = n;
		}
		
		[Bindable]
		public function get DayLowTemp () : Number {
			return dayLowTemp;
		}
		private function set DayLowTemp (n : Number) : void {
			dayLowTemp = n;
		}
		
		[Bindable]
		public function get HumOut () : Number {
			return humOut;
		}
		private function set HumOut (n : Number) : void {
			humOut = n;
		}
		
		[Bindable]
		public function get Baro () : Number {
			return baro;
		}
		private function set Baro (n : Number) : void {
			baro = n;
		}
		
		[Bindable]
		public function get DayRain () : Number {
			return dayRain;
		}
		public function set DayRain (n : Number) : void {
			dayRain = n;
		}
		
		[Bindable]
		public function get StormRain () : Number {
			var n : Number = Number(elements[7]);
			// return (n * metricConversion);
			return 0;			// Not part of ClientRaw.txt, sadly.  One of the more interesting rain numbers, IMHO.
		}
		private function set StormRain (n : Number) : void {
		}
		
		public function get MonthRain () : Number {
			var n : Number = Number(elements[8]);
			formatter.precision = 2;
			n = Number(formatter.format(n * metricConversion));
			formatter.precision = 1;
			return n;
		}
		
		[Bindable]
		public function get YearRain () : Number {
			return yearRain;
		}
		private function set YearRain (n : Number) : void {
			yearRain = n;
		}
		
		[Bindable]
		public function get RainRate () : Number {
			return rainRate;
		}
		private function set RainRate (n : Number) : void {
			rainRate = n;
		}
		
		[Bindable]
		public function get DayHiRainRate () : Number {
			return dayHiRainRate;
		}
		private function set DayHiRainRate (n : Number) : void {
			dayHiRainRate = n;
		}
		
		public function DayHiRainRateTime () : String {
			return "";
		}
		
		public function get TempIn () : Number {
			var n : Number = Number(elements[12]);
			return Number(formatter.format(ConvertTemperature(n)));
		}
		
		public function get HumIn () : Number {
			var n : Number = Number(elements[13]);
			return n;
		}
		
		public function get Hours () : Number {
			var n : Number = Number(elements[29]);
			return n;
		}
		
		public function get Minutes () : Number {
			var n : Number = Number(elements[30]);
			return n;
		}
		
		public function get Seconds () : Number {
			var n : Number = Number(elements[31]);
			return n;
		}
		
		public function get StationName () : String {
			try {
				var s : String = elements[32];
				var a : Array = s.split("-");
				return a[0];
			} catch (error : *) {
				trace("Station Name null entry, ", error);
			}
			
			return "";
		}
		
		public function get SolRad () : Number {
			var n : Number = Number(elements[34]);
			return n;
		}
		
		public function get Day () : Number {
			var n : Number = Number(elements[35]);
			return n;
		}
		
		public function get Month () : Number {
			var n : Number = Number(elements[36]);
			return n;
		}
		
		public function get Year () : Number {
			var n : Number = Number(elements[141]);
			return n;
		}
		
		public function get WindChill () : Number {
			// Wind chill temperature = 35.74 + 0.6215T - 35.75V (**0.16) + 0.4275TV(**0.16) 
			// var n : Number = Number(elements[44]);
			var n : Number = Number(elements[4]);
			
			var f : Number = (9.0 / 5.0) * n + 32.0;
			var v : Number = Number(elements[2]) * 1.15077945;
			 
			var p : Number = Math.pow(v, 0.16);
			 
			var wc : Number = 35.74 + 0.6215 * f - 35.75 * p + 0.4275 * f * p;
			
			if (wc > f)
				wc = f;
			 
			n = (wc - 32) * 5 / 9;

			return Number(formatter.format(ConvertTemperature(n)));
		}
		
		public function get Description () : String {
			return elements[49];
		}
		
		[Bindable]
		public function get DayWindHi () : Number {
			return dayWindHi;
		}
		private function set DayWindHi (n : Number) : void {
			dayWindHi = n;
		}
		
		[Bindable]
		public function get DewOut () : Number {
			return dewOut;
		}
		private function set DewOut (n : Number) : void {
			dewOut = n;
		}
		
		public function get CloudHeight () : Number {
			var n : Number = Number(elements[73]);
			if (!useCelsius)
				n *= 3.2808399;
			return n;
		}
		
		[Bindable]
		public function get BaroTrend () : String {
			return baroTrend;
		}
		private function set BaroTrend (b : String) : void {
			baroTrend = b;
		}
		
		public function get FriendlyDate () : String {
			if (elements.length == 0)
				return "";
				
			var d : Number = elements[35];
			var m : Number = elements[36];
			var y : Number = elements[141];
			
			if (elements.length < 141) {
				var aDate : Date = new Date();
				y = aDate.fullYear;
			}
				
			return months[m - 1] + " " + d + ", " + y;
		}
		
		public function get FriendlyTime () : String {
			if (elements.length == 0)
				return "";
				
			var h : Number = elements[29];
			var m : Number = elements[30];
			var s : Number = elements[31];
			
			var a : String = " am";
			
			if (h > 12) {
				h -= 12;
				a = " pm";
			}
			
			if (h == 0) {
				h = 12;
			}
			
			if (h == 12)
				a = " pm";
			
			var ms : String = "" + m;
			if (m < 10)
				ms = "0" + ms;
			
			var ss : String = "" + s;
			if (s < 10)
				ss = "0" + ss;
				
			return h + ":" + ms + ":" + ss + a;
		}
		
		public function get TheDate () : String {
			return elements[74];
		}
		
		private function fixTime (s : String) : String {
			if (s.indexOf("am") >= 0) {
				s = s.replace("am", " am");
				return s;
			}
			else if (s.indexOf("pm") >= 0) {
				s = s.replace("pm", " pm");
			}

			var a : Array = s.split(":");
			var hours : Number = Number(a[0]);
			var suffix : String = " am";
			if (hours >= 12) {
				if (hours > 12)
					hours -= 12;
				suffix = "";
				if (s.indexOf("pm") < 0)
					suffix = " pm";
			}
			if (hours == 0)
				hours = 12;
				
			var ss : String = hours + ":" + a[1];
			if (s.lastIndexOf("pm") > 0)
				return ss;
			else
				return ss + suffix;
			
			return "";
		}
		
		[Bindable]
		public function get StationSunrise () : String {
			return stationSunrise;
		}
		private function set StationSunrise (s : String) : void {
			stationSunrise = s;
		}
		
		[Bindable]
		public function get StationSunset () : String {			
			return stationSunset;
		}
		public function set StationSunset (s : String) : void {
			stationSunset = s;
		}
		
		public function fixWDTimeString (s : String) : String {
			s = s.replace("_", "");
			s = s.toLowerCase();
			return fixTime(s);
		}
		
		[Bindable]
		public function get DayWindHiTime () : String {
			return dayWindHiTime;
		}
		private function set DayWindHiTime (s : String) : void {
			dayWindHiTime = s;
		}
		
		public function get UV () : Number {
			var n : Number = Number(elements[79]);
			return n;
		}
	}
}
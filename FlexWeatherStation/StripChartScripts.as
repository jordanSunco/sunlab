
import flash.filters.GlowFilter;

import mx.charts.LinearAxis;
import mx.collections.ArrayCollection;
import mx.events.CubeEvent;


private var maxValue : Number = Number.MIN_VALUE;
private var minValue : Number = Number.MAX_VALUE;
private var virgin : Boolean = true;

[Bindable]
private var chartData : ArrayCollection = new ArrayCollection([1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
																 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]);

private var currentIndex : int = 0;
private var glow : GlowFilter = new GlowFilter();
private var glowB : GlowFilter = new GlowFilter();

private var minIsZero : Boolean = false;

private var caption : String = "";

private function shiftLeft () : void {
	chartData.removeItemAt(0);
}

private function adjustAxis () : void {
	
	var i:uint;

	maxValue = Number.MIN_VALUE;
	minValue = Number.MAX_VALUE;
	for (i=0; i<chartData.length; i++) {
		if (i < currentIndex) {
			maxValue = Math.max(chartData[i], maxValue);
			minValue = minIsZero ? 0 : Math.min(chartData[i], minValue); 
		}
		else {
			chartData[i] = minIsZero ? 0 : (maxValue + minValue) / 2.0;
		}
	}
	if ( minValue == maxValue ) {
		minValue -= 1;
		maxValue += 1;
	}
	minValue = Math.floor( minValue );
	maxValue = Math.ceil( maxValue );

	if (stripChart != null) {
		(stripChart.verticalAxis as LinearAxis).maximum = maxValue;
		(stripChart.verticalAxis as LinearAxis).minimum = minValue;
	}
}


[Editable(type=Boolean)]
[Persistent]
public function set MinimumIsZero (b : Boolean) : void {
	if ( minIsZero != b ) {
		minIsZero = b;
		
		adjustAxis();
	}
}

public function get MinimumIsZero () : Boolean {
	return minIsZero;
}

private function setFilters () : void {
	glow.strength = 4;
	glow.blurX = 4;
	glow.blurY = 4;
	glow.inner = false;
	glow.color = 0xFFFFFF;
	glowB.strength = 2;
	glowB.inner = false;
	glowB.color = 0;
	glowB.blurX = 2;
	glowB.blurY = 2;
	
	captionLabel.filters = [glow, glowB];
	captionLabel.setStyle("fontSize", "20");
}


[Editable]
[Persistent(clearOnCopy)]
[Bindable]
public function set Caption (s : String) : void {
	glow.strength = 4;
	glow.blurX = 4;
	glow.blurY = 4;
	glow.inner = false;
	glow.color = 0xFFFFFF;
	glowB.strength = 2;
	glowB.inner = false;
	glowB.color = 0;
	glowB.blurX = 2;
	glowB.blurY = 2;
	caption = s;
			
	try {
		captionLabel.filters = [glow, glowB];
		captionLabel.setStyle("fontSize", "20");
		captionLabel.text = caption;
	} catch (e:*) {
		trace(e);
	}
}

public function get Caption () : String {
	return caption;
}
 
[AutoConnect(sink)]
public function get latestValue () : String {
	return (chartData[chartData.length - 1]).toString();
} 

public function set latestValue (n : String) : void {
	var i:uint;	

	var num : Number = 0;
	try {
		num = Number(n);
	} catch (e : *) {
		return;
	}
	
	if (isNaN(num)) {
		virgin = true;
		return;
	}
		
	if (virgin) {
		currentIndex = 0;
		
		for (i=0; i<chartData.length; i++) {
			chartData[i] = num;
		}
		virgin = false;
	}
	
	adjustAxis();

	if (currentIndex == chartData.length) {
		shiftLeft();
		chartData.addItem(num);
	}
	else {
		chartData[currentIndex++] = num;
	}
}
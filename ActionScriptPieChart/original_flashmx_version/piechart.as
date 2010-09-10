// Pie Chart
//
// Jim Bumgardner http:/www.krazydad.com/bestiary/


// Pie Chart is driven by the following array
//
piechart = new Array();
piechart.title = "How Flash gets Used, 2004";
piechart.items = [						// wedge definitions
                // title                              count      color
			  ["Portfolios for Flash Animators",   		100, 	0xFF0000],
			  ["Tutorials for Flash Animators",	   		50,  	0xFF00FF],
			  ["Expensive websites you visit once", 	35, 	0x0000FF],
			  ["Expensive yet annoying advertisements", 25,     0x00FFFF],
			  ["HomestarRunner.net (it's dot com)", 	20, 	0x00FF00],
			  ["Sarcastic Pie Charts",             		10, 	0xFFFF00]
			];					

piechart.kNormAlpha = 40;   // default alpha value for non-selected slices
piechart.explodeDist = 15;  // amount to expode selected slices (in pixels)

// Everything from here down is pretty much automatic
//
piechart.sum = 0;
piechart.lastActive = 0;
for (var i = 0; i < piechart.items.length; ++i) {
	piechart.sum += piechart.items[i][1];
	var item = piechart.items[i];
	piechart.items[i].explode = 0;
	piechart.items[i].texplode = 0;
	piechart.items[i].alpha = 100;
	piechart.items[i].talpha = piechart.kNormAlpha;
}


// Some useful constants
degToRad = Math.PI/180;
CX = Stage.width/2;
CY = Stage.height/2;

MovieClip.prototype.drawWedge = function(x,y,radius, bA,eA, explode)
{
	// trace("rad = " + radius);
	if (eA < bA)
		eA += 360;
	var r = radius;

	var n= Math.ceil((eA-bA)/45);
	// trace(n);
	
	var theta = ((eA-bA)/n)*degToRad;
	var cr = radius/Math.cos(theta/2);
	var angle = bA*degToRad;
	var cangle = angle-theta/2;
	if (explode > 1) 
	{
		var midAngle = (bA+(eA-bA)/2)*degToRad;
		x += explode*Math.cos(midAngle);
		y += explode*Math.sin(midAngle);
	}
	
	this.moveTo(x, y);
	this.lineTo(x+r*Math.cos(angle), y+r*Math.sin(angle));
	for (var i=0;i < n;i++) 
	{
		angle += theta;
		cangle += theta;
		var endX = r*Math.cos (angle);
		var endY = r*Math.sin (angle);
		var cX = cr*Math.cos (cangle);
		var cY = cr*Math.sin (cangle);
		this.curveTo(x+cX,y+cY, x+endX,y+endY);
	}
	this.lineTo(x, y);
}

Movieclip.prototype.drawPieChart = function()
{
	var title = piechart.title;
	var items = piechart.items;
	this.clear();
    var deg = 0;
	for (var i = 0; i < items.length; ++i) {
		var label = items[i][0];
		var ratio = items[i][1] / piechart.sum;
		var clr= items[i][2];
		this.lineStyle(2,0x000000,items[i].alpha);
		this.beginFill(clr, items[i].alpha);
		this.drawWedge(CX, CY, 100, deg, deg+ratio*360, items[i].explode);
		this.endFill();
		deg += ratio*360;
		items[i].explode += (items[i].texplode - items[i].explode)/3;
		items[i].alpha += (items[i].talpha - items[i].alpha)/3;
	}
}

this.onEnterFrame = function()
{
	this.drawPieChart();
}
function getPercentText(r)
{
	rStr = String(r*100);
	var p = rStr.indexOf(".");
	if (p != -1) {
		rStr = rStr.substr(0,p+2);
	}
	return rStr + " %";
}

this.onMouseMove = function()
{
	// figure out current angle using mouse coordinates...
	var dx = this._xmouse - CX;
	var dy = this._ymouse - CY;
	var dist = Math.sqrt(dx*dx+dy*dy);
	var ang;
	if (dy < 0)
		ang = Math.PI*2-Math.acos(dx/dist);
	else
		ang = Math.acos(dx/dist);

	ang *= 180/Math.PI;



	// Figure out which slice we're on...
	var deg = 0;
	var slice = 0;
	var items = piechart.items;
	for (var i = 0; i < items.length; ++i) {
		var ratio = items[i][1] / piechart.sum;
		if (ang >= deg && ang < deg+ratio*360)
		{
			slice = i;
			break;
		}
		deg += ratio*360;
	}

	// Deselect the previous slice
	piechart.items[piechart.lastSlice].texplode = 0;
	piechart.items[piechart.lastSlice].talpha = piechart.kNormAlpha;

	// select the slice we're on
	piechart.items[slice].texplode = piechart.explodeDist;
	piechart.items[slice].talpha = 100;
	
	piechart.lastSlice = slice;
	
	// And change the legend/label thing
	this.label_txt.text = piechart.items[slice][0] + "\r" + getPercentText(piechart.items[slice][1] / piechart.sum);
}

this.createTextField("label_txt", 1, 5, 5, 100, 100);
this.label_txt.autoSize = true;
tf = new TextFormat();
tf.size = 24;
this.label_txt.setNewTextFormat(tf);
this.label_txt.text = 'test\rtest\rtest2';

this.createTextField("label_txt", 1, 8, CX*1.7, 100, 100);
this.label_txt.autoSize = true;
var tf = new TextFormat();
tf.size = 18;
this.label_txt.setNewTextFormat(tf);
this.label_txt.text = '';

this.createTextField("title_txt", 2, 8, 8, 100, 100);
this.title_txt.autoSize = true;
var tf = new TextFormat();
tf.size = 24;
this.title_txt.setNewTextFormat(tf);
this.title_txt.text = piechart.title;
this.title_txt._x = CX - this.title_txt.textWidth/2;

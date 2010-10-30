	[Exclude(name = "backgroundColor", kind = "style")]
	
	/**
	 * Defines the type of the backgroun gradient. The gradient can be "linear" or "radial".
	 * 
	 * @ default "linear"
	 */
	[Style(name = "gradientType", type = "Array", format = "String", enumeration = "linear, radial", inherit = "no")]
	
	/**
	 * Defines the type of the border gradient. The gradient can be "linear" or "radial".
	 * 
	 * @ default "linear"
	 */
	[Style(name = "bordergradientType", type = "String", format = "String", enumeration = "linear, radial", inherit = "no")]
	
	/**
	 * An array of all colors defining the gradient for the background.
	 * 
	 * @default 0xFFFFFF 
	 */
	[Style(name = "fillColors", type = "Array", format = "Color", inherit = "no")]
	
	/**
	 * An array defining the number of colors in each gradient.
	 * 
	 * Example:
	 * [3,2] means 3 colors for the first gradient and 2 for the second one.
	 * 
	 * @default [1] 
	 */
	[Style(name = "colorsConfiguration", type = "Array", format = "Number", inherit = "no")]	
	
	/**
	 * An array of all colors defining the gradient for the border.
	 * 
	 * @default 0xFFFFFF 
	 */
	[Style(name = "borderColors", type = "Array", format = "Color", inherit = "no")]
	
	/**
	 * Bounding box thickness.
	 * 
	 * @default 0
	 */
	[Style(name = "borderThickness ", type = "Number", format = "Length", inherit = "no")]
	
	/**
	 * An array defining the alpha of each color in the background gradient. Values must be between 0 and 1.
	 * You must have the same number of alphas values than the number of colors in the gradient.
	 * 
	 * @default 1
	 */
	[Style(name = "fillAlphas", type = "Array", format = "Number", inherit = "no")]
	
	/**
	 * An array defining the alpha of each color in the gradient of the border. Values must be between 0 and 1.
	 * You must have the same number of alphas values than the number of colors in the gradient.
	 * 
	 * @default 1
	 */
	[Style(name = "borderAlphas", type = "Array", format = "Number", inherit = "no")]
	
	/**
	 * For the background : an array of color distribution ratios; valid values are 0 to 255. This value defines the percentage of the width where the color is sampled at 100%. The value 0 represents the left-hand position in the gradient box, and 255 represents the right-hand position in the gradient box.
	*
	* <b>Note</b>: This value represents positions in the gradient box, not the coordinate space of the final gradient, which might be wider or thinner than the gradient box. Specify a value for each value in the colors parameter.
	 * 
	 * The values in the array must increase sequentially; for example, [0, 63, 127, 190, 255]. 
	 */
	[Style(name = "gradientRatio", type = "Array", format = "Number", inherit = "no")]
	
	/**
	 * For the border : an array of color distribution ratios; valid values are 0 to 255. This value defines the percentage of the width where the color is sampled at 100%. The value 0 represents the left-hand position in the gradient box, and 255 represents the right-hand position in the gradient box.
	*
	* <b>Note</b>: This value represents positions in the gradient box, not the coordinate space of the final gradient, which might be wider or thinner than the gradient box. Specify a value for each value in the colors parameter.
	 * 
	 * The values in the array must increase sequentially; for example, [0, 63, 127, 190, 255]. 
	 */
	[Style(name = "bordergradientRatio", type = "Array", format = "Number", inherit = "no")]
	
	/**
	 * The value from the SpreadMethod class that specifies which spread method to use for the background gradient.
	 * Possible vaues are : "pad", "reflect", "repeat".
	 * 
	 * @default "pad"
	 */
	[Style(name = "spreadMethod", type = "Array", format = "String", enumeration = "pad, reflect, repeat", inherit = "no")]
	
	/**
	 * The value from the SpreadMethod class that specifies which spread method to use for the border gradient.
	 * Possible vaues are : "pad", "reflect", "repeat".
	 * 
	 * @default "pad"
	 */
	[Style(name = "borderSpreadMethod", type = "String", format = "String", enumeration = "pad, reflect, repeat", inherit = "no")]
	
	/**
	 * The value from the InterpolationMethod class that specifies which value to use for background gradient.
	 * Possible values are : "linearRGB" or "rgb".
	 * 
	 * @default "rgb"
	 */
	[Style(name = "interpolationMethod", type = "Array", format = "String", enumeration = "rgb, linearRGB", inherit = "no")]
	
	/**
	 * The value from the InterpolationMethod class that specifies which value to use for border gradient.
	 * Possible values are : "linearRGB" or "rgb".
	 * 
	 * @default "rgb"
	 */
	[Style(name = "borderInterpolationMethod", type = "String", format = "String", enumeration = "rgb, linearRGB", inherit = "no")]
	
	/**
	 * The number that controls the location of the focal point of the background gradient.
	 * 0 means that the focal point is in the center.
	 * 1 means that the focal point is at one border of the gradient circle.
	 * -1 means that the focal point is at the other border of the gradient circle.
	 * A value less than -1 or greater than 1 is rounded to -1 or 1.
	 * 
	 * @default 0
	 */
	[Style(name = "focalPointRatio", type = "Array", format = "Number", inherit = "no")]
	
	/**
	 * The number that controls the location of the focal point of the border gradient.
	 * 0 means that the focal point is in the center.
	 * 1 means that the focal point is at one border of the gradient circle.
	 * -1 means that the focal point is at the other border of the gradient circle.
	 * A value less than -1 or greater than 1 is rounded to -1 or 1.
	 * 
	 * @default 0
	 */
	[Style(name = "borderfocalPointRatio", type = "Number", format = "Number", inherit = "no")]
	
	/**
	 * Defines the rotation of the background gradient., in degree.
	 * This style has no visual result with a radial gradient excepted if the focal point ratio is different than 0.
	 * 
	 * @default 0
	 */
	[Style(name = "angle", type = "Array", format = "Number", inherit = "no")]
	
	/**
	 * Defines the rotation of the border gradient., in degree.
	 * This style has no visual result with a radial gradient excepted if the focal point ratio is different than 0.
	 * 
	 * @default 0
	 */
	[Style(name = "borderAngle", type = "Number", format = "Number", inherit = "no")]
	
	/**
	 * Defines how the offsets of the gradient are interpreted inside the canvas.
	 * "absolute" means that offsetX and offsetY are understood as absolute positions, independant of the size of the canvas
	 * "percentage" means that offsetX and offsetY are understood as percentages of the canvas size
	 * 
	 * @ default "absolute"
	 */
	[Style(name = "positioning", type = "String", format = "String", enumeration = "absolute, percentage", inherit = "no")]
	
	
	/**
	 * How far the background gradient is horizontally offset from the origin.
	 * 
	 * @default 0
	 */
	[Style(name = "offsetX", type = "Array", format = "Number", inherit = "no")]
	
	/**
	 * How far the border gradient is horizontally offset from the origin.
	 * 
	 * @default 0
	 */
	[Style(name = "borderOffsetX", type = "Number", format = "Number", inherit = "no")]
	
	/**
	 * How far the background gradient is vertically offset from the origin.
	 * 
	 * @default 0
	 */
	[Style(name = "offsetY", type = "Array", format = "Number", inherit = "no")]
	
	/**
	 * How far the border gradient is vertically offset from the origin.
	 * 
	 * @default 0
	 */
	[Style(name = "borderOffsetY", type = "Number", format = "Number", inherit = "no")]
	
	/**
	 * Radius 
	 */
	[Style(name = "cornerRadius", type = "Number", format = "Number", inherit = "no")]
	
	/**
	 * Radius of the upper-left corner of the canvas, in pixels
	 * 
	 * @default 0
	 */
	[Style(name = "topLeftRadius", type = "Number", format = "Number", inherit = "no")]
	
	/**
	 * Radius of the upper-right corner of the canvas, in pixels.
	 * 
	 * @default 0
	 */
	[Style(name = "topRightRadius", type = "Number", format = "Number", inherit = "no")]
	
	/**
	 * Radius of the bottom-left corner of the canvas, in pixels.
	 * 
	 * @default 0
	 */
	[Style(name = "bottomLeftRadius", type = "Number", format = "Number", inherit = "no")]
	
	/**
	 * Radius of the bottom-right corner of the canvas, in pixels.
	 * 
	 * @default 0
	 */
	[Style(name = "bottomRightRadius", type = "Number", format = "Number", inherit = "no")]
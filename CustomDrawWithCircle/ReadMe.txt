CustomDraw.as Component

Installation: 
	The CustomDrawWithCircle.zip file is an archived Flex project and can be imported in Flex Builder. 
	In Flex Builder, select File-->Import-->Flex Project. In the dialog select Archive File (it is the default), and browse to the CustomDrawWithCircle.zip file, and follow the wizard. 

The CustomDraw.as component is an action script file and is located in src\com\esri\draw folder. You can use it in any other application by simply copying the file into a desired folder. All you have to do is reference it in the Application tag as showin in the sample application. 
A CustomDrawWithCircle.mxml file is a simple test application showing the use of the component. 

-- Use the displayRadius property to show or not the radius while the cirlce is drawn (in current map units).
-- Use the displayCenter property to draw or not the center point of the circle on the map. 
-- If a map and graphicsLayer are not specified, an error is thrown. 

The code of the component is commented out to help you modify it if you wish to do so. 

The component has been tested, but not in every possible scenario. 

Good Luck!




Bug Fixes:

1. The ArcGIS Flex API library was not included in the project, and in order to run the project you had to add it yourself. It is now included and I believe the sample project should work after being imported.
2. Drawing of multiple circles without deactivating after every circle wasn't working. Now multiple shapes (any kind) can be drawn one after another. 
3. If deactivate() was not called after every drawn shape, none of the other (other than circle) were working. It is fixed now. 

If I keep playing with this tool, I will keep finding bugs. ;-)
I fixed 3 problems, and will let you find the rest. Hope, you can fix them yourself, but if not, please, let me know, and I will do my best to fix them. 


Bug Fixes - November 3rd, 2009
______________________________

After more people have been using the tool in different scenarios, some bugs became appearent. I am posting the fixes, which have been developed by Robert Scheitlin. Thanks Robert!


1. During Activate deactivate the tool that have been active before. This prevents drawing of circle and the shape that has been active at the same time.
2. Create a new text symbol for every new circle that has been drawn on the map. This prevents displaying the same radius for all drawn circles.
3. Spatial reference is added to the circle polygon. This would eliminate errors during queries, or other operations using th e circle polygon. 
4. Array of points, constructing the circle is rerversed to avoid negative area value. 

NOTE: 

I am not implementing all of the Robert's fixes, as they might be more appropriate for using this tool in the Sample Flex Fiewer widget. To see all of his fixes, and use the tool in the SFV, see the Enhanced Draw Widget in the gallery. 
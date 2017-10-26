

//////////////////////////////////////////////

How the inner structure works:

There are 2 objects: Placemark & Transit

PLACEMARK

Placemark stores each place where the user has stopped by. It Placemark contains a name (address), arrival & departure date as well as the actual location.


TRANSIT
A transit is the represented as the coordinates to get from Placemark A (through C,D,E) to B, it also contain every place we stopped by.


Following this, the class has an array of places we go through (A,C,D,E,B)

Then there is also a dictionary that stores locations to reach a new placemark. The key would be the index of the places array, and the value is the array of locations

So, for example, to access the coordinates we followed to get from A -> C we would access the key of the dictionary "0" (as A is the first index of the place marks array)



//////////////////////////////////////////////

Base of the algorithm to decide when we are on transit (walking) and when to create a place mark:

	1. If location coordinates are the same, we trigger a timer

	2. If location changes we invalidate the timer and come back to 1)

	3. If time elapsed (timer) when we update location is bigger than the constant
	'STOP_BY_SECONDS' then we add a place mark, geocode its address, and assign the array of locations which we have been stored

	4.We allocate a new array of locations to store the following ones.

	5.As soon as the next location we get changes from the previous one (that of the arrival of the place mark), (we are moving) we get its timestamp and set it to the 	departure time for the last place mark and begin to store all locations we get (if they are different). If locations are the same this case is covered by 1)
	

Basically we have 3 main events: 
-Moving (transit)
-location is the same but elapsed time is not enough to consider we are in a new place mark 
-same as before but time elapsed is enough to create a new place mark and await for the user to move again



Note: we don't store all locations that are the same, just different ones.

//////////////////////////////////////////////

Location accuracy has been set to: 
kCLLocationAccuracyBestForNavigation
(For testing purposes - but this does make an extensive use of the battery)

const int STOP_BY_SECONDS = 3; -> This is the time period (location being the same) required to creating a new landmark
const int MIN_ACCURACY = 160; -> minimum coordinate accuracy to take into account the location (160 for testing purposes)
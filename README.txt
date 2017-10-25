

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

Location accuracy has been set to: 
kCLLocationAccuracyBestForNavigation
(For testing purposes - but this does make an extensive use of the battery)


//////////////////////////////////////////////

The condition to determine if we should create a new place mark (the user has stopped somewhere) follows these conditions:

The coordinates should be the same for the constant value determined by STOP_BY_SECONDS

The coordinates should be the same but it would be a good thing to consider a radius (i.e the user is considered to be in the same place if the location does not change in a radius of more than half a meter)



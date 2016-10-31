# GoogleMapsPlacesWrapperSwift
A simple wrapper for the missing geocode function in Google Maps SDK. And for fetching a place from Google Places web API directly, allowing missing customization by SDK.

For some reason, the Google Maps SDK is missing a standard Geocode function (translate a textual address into physical coordinates).
They did include the [reverse Geocode function in GMSGeocoder class](https://developers.google.com/maps/documentation/ios-sdk/reference/interface_g_m_s_geocoder). Very annoying.
Yes, this can be done easily with Apple's CoreLocation, but I tend to trust Google's GIS a bit more.
Also I had to wrap the fetching of place details by ID, because Google Places SDK does not allow any customization upon
their [lookUpPlaceID fucntion in GMSPlacesClient class](https://developers.google.com/places/ios-api/reference/interface_g_m_s_places_client.html#a0858545fb8ff829594d01f5925381030). I needed the ability to pass the language code in order
for the results be generated in that language rather than the current active device one.

Notice I created a struct data model called APGooglePlace similar to [GMSPlace](https://developers.google.com/places/ios-api/reference/interface_g_m_s_place) of which Google did not provide an initializer for.

Download and run my humble demo project to see it in action.

### Install
- pod install
- Enter your Google Maps API key in APGoogleAPI.swift 
  
Have fun!

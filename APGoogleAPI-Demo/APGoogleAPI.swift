//
//  APGoogleAPI.swift
//  APGoogleAPI-Demo
//
//  Created by Amit Palomo on 31/10/2016.
//  Copyright © 2016 Amit Palomo.
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//  http://www.apache.org/licenses/LICENSE-2.0
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

import Foundation
import GoogleMaps
import Alamofire

typealias JSONObject = [String: AnyObject]
typealias APGooglePlaceResponse = (APGooglePlace?) -> ()

struct APGoogleAddressComponent {
    
    let name: String
    let type: String
    
    init?(json: JSONObject) {
        
        guard let name = json["short_name"] as? String,
            let types = json["types"] as? [String], types.count > 0
        else { return nil }
        
        self.name = name
        self.type = types[0] // Assuming first type is the best representation
    }
}

struct APGooglePlace {

    var placeID: String
    var coordinate: CLLocationCoordinate2D
    var types: [String]
    var addressComponents: [APGoogleAddressComponent] = []
    
    //    var formattedAddress: String?
    //    var viewport: GMSCoordinateBounds?
    
    init?(json: JSONObject) {
        
        guard let placeID = json["place_id"] as? String,
            let geometry = json["geometry"] as? JSONObject,
            let locationDict = geometry["location"] as? JSONObject,
            let lat = locationDict["lat"] as? Double,
            let lng = locationDict["lng"] as? Double,
            let types = json["types"] as? [String]
            else { return nil }
        
        self.placeID = placeID
        self.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        self.types = types
        
        if let addressComponentsList = json["address_components"] as? [JSONObject] {
            
            addressComponentsList.forEach({ componentJSON in
                
                if let addressComponent = APGoogleAddressComponent(json: componentJSON) {
                    self.addressComponents.append(addressComponent)
                }
            })
        }
    }
}

final class APGoogleAPI {
    
!error static let GoogleAPIKey = "YOUR-GOOGLE-MAPS-API-KEY"
    static let geocodeAPIRoute = "https://maps.googleapis.com/maps/api/geocode/json"
    static let placeDetailAPIRoute = "https://maps.googleapis.com/maps/api/place/details/json"
    
    func geocode(address: String, callback: @escaping APGooglePlaceResponse) {
        
        Alamofire.request(
            APGoogleAPI.geocodeAPIRoute,
            parameters: ["address": address, "key": APGoogleAPI.GoogleAPIKey])
            .responseJSON { response in
                
                if let JSON = response.result.value as? JSONObject,
                    let results = JSON["results"] as? [JSONObject], results.count > 0 {
                        // Assuming first result is the best match
                        let place = APGooglePlace(json: results[0])
                        callback(place)
                }
                else {
                    callback(nil)
                }
        }
    }
    
    func getPlaceDetails(id: String, language: String, callback: @escaping APGooglePlaceResponse) {

        Alamofire.request(
            APGoogleAPI.placeDetailAPIRoute,
            parameters: ["placeid":id,
                        "language":language,
                        "key": APGoogleAPI.GoogleAPIKey
                        ])
            .responseJSON { response in
                
                if let JSON = response.result.value as? JSONObject,
                    let result = JSON["result"] as? JSONObject {
                    let place = APGooglePlace(json: result)
                    callback(place)
                }
                else {
                    callback(nil)
                }
        }
    }
}

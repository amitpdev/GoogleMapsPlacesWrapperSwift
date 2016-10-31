//
//  ViewController.swift
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

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var resultsTextView: UITextView!
    
    static let preferredLanguage = "zh-cn"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField:UITextField) -> Bool {
        
        addressTextField.resignFirstResponder()
        
        guard let text = textField.text,
            text.characters.count > 0
        else { return true }
        
        resultsTextView.text = ""
        
        log("-> Trying to Geocode:\"\(text)\"")
        
        let googleAPI = APGoogleAPI()
        googleAPI.geocode(address: text) { place in
            
            if let place = place {
                self.log("== Google Geocoding found a Place with ID:\(place.placeID) at (Lat:\(place.coordinate.latitude), Long:\(place.coordinate.longitude))")
                
                
                self.log("-> Trying to fetch the Place details in preferred language:\(ViewController.preferredLanguage)")
                googleAPI.getPlaceDetails(id: place.placeID, language: ViewController.preferredLanguage) { place in
                    if let place = place {
                        self.log("== Place successfuly fetched from Google Places API")
                        place.addressComponents.forEach({ component in
                            self.log("Address component [type:\(component.type) name:\(component.name)]")
                        })
                    }
                    else {
                        self.log("Error: Place details fetch failed to complete")
                    }
                }
            }
            else {
                self.log("Error: Geocode failed to complete")
            }
            
        }
        return true
    }
}

extension ViewController  {
    
    func log(_ text: String) {
        debugPrint(text)
        resultsTextView.append(text: text)
    }
}

extension UITextView {
    
    func append(text: String) {
        let base = self.text ?? ""
        self.text = base + "\n" + text
    }
}


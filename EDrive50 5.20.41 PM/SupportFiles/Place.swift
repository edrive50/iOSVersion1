//
//  Place.swift
//  edrive50
//
//  Created by Suuba Magai on 2019-03-30.
//  Copyright © 2019 Suuba Magai. All rights reserved.
//

import Foundation
import GooglePlaces

class Place {
    
    var address : String?
    var addressComponents : [GMSAddressComponent]?
    var points : CLLocationCoordinate2D
    var street_number : String?
    var street_name : String?
    var city : String?
    var prov : String?
    var postal_code : String?
    var manual = false
    
    init(address: String, points: CLLocationCoordinate2D) {
        self.address = address
        self.points = points
    }
    
    convenience init(name: String, addressComponents: [GMSAddressComponent], points: CLLocationCoordinate2D) {
        self.init(address: name, points: points)
        self.addressComponents = addressComponents
        street_number = addressComponents.first(where: { $0.type == "street_number" })?.name
        street_name = addressComponents.first(where: { $0.type == "route" })?.name
        city = addressComponents.first(where: { $0.type == "locality" })?.name
        prov = addressComponents.first(where: { $0.type == "administrative_area_level_1" })?.shortName
        postal_code = addressComponents.first(where: { $0.type == "postal_code" })?.name
    }
    
    func toAddressString() -> String {
        if addressComponents != nil || manual == true {
            return "\(street_number!) \(street_name!), \(city!), \(prov!), \(postal_code!)"
        } else { return "n/a" }
    }
}

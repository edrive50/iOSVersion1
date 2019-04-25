//
//  RideInfo.swift
//  edrive50
//
//  Created by Oluwakemi Mafe on 2019-04-21.
//  Copyright © 2019 Suuba Magai. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class RideInfo: Object {
    @objc dynamic var notificationId = ""
    
    @objc dynamic var pickUpStreetNum = ""
    @objc dynamic var pickUpStreetName = ""
    @objc dynamic var pickUpCity = ""
    @objc dynamic var pickUpProvince = ""
    @objc dynamic var pickUpPostal = ""
    @objc dynamic var pickUplatitude = 0.00
    @objc dynamic var pickUpLogitude = 0.00
    
    @objc dynamic var destinationStreetNum = ""
    @objc dynamic var destinationStreetName = ""
    @objc dynamic var destinationCity = ""
    @objc dynamic var destinationProvince = ""
    @objc dynamic var destinationPostal = ""
    @objc dynamic var destinationlatitude = 0.00
    @objc dynamic var destinationLogitude = 0.00
    
    @objc dynamic var wheelchair = false
    @objc dynamic var physicalAssistance = false
    @objc dynamic var bigTrunk = false
    @objc dynamic var other = ""
    @objc dynamic var isNotified = 1

    func makeRideInfo(obj: [String:Any]?, notificationId: String) -> RideInfo {
        let rideInfo = RideInfo()
        let start = obj!["start_address"] as? [String:Any]
        let end = obj!["end_address"] as? [String:Any]
        let accessibility = obj!["accessibility_options"] as? [String:Any]
//        let city = start!["city"] as? String
//        print(city)

        rideInfo.notificationId = notificationId
        rideInfo.pickUpStreetNum = (start!["street_num"] as? String)!
        rideInfo.pickUpStreetName = (start!["street"] as? String)!
        rideInfo.pickUpCity = (start!["city"] as? String)!
        rideInfo.pickUpProvince = (start!["prov"] as? String)!
        rideInfo.pickUpPostal = (start!["postal_code"] as? String)!
        rideInfo.pickUplatitude = (start!["latitude"] as? Double)!
        rideInfo.pickUpLogitude = (start!["longitude"] as? Double)!

        rideInfo.destinationStreetNum = (end!["street_num"] as? String)!
        rideInfo.destinationStreetName = (end!["street"] as? String)!
        rideInfo.destinationCity = (end!["city"] as? String)!
        rideInfo.destinationProvince = (end!["prov"] as? String)!
        rideInfo.destinationPostal = (end!["postal_code"] as? String)!
        rideInfo.destinationlatitude = (end!["latitude"] as? Double)!
        rideInfo.destinationLogitude = (end!["longitude"] as? Double)!

        rideInfo.wheelchair = (accessibility!["wheelchair"] as? Bool)!
        rideInfo.physicalAssistance = (accessibility!["physical_assistance"] as? Bool)!
        rideInfo.bigTrunk = (accessibility!["big_trunk"] as? Bool)!
        rideInfo.other = (accessibility!["other_details"] as? String)!
        
        return rideInfo
    }
    
    func save(rideInfo : RideInfo) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(rideInfo)
        }
        print(realm.objects(RideInfo.self))
    }

    func delete(rideInfo : RideInfo) {
        let realm = try! Realm()
        
        if let ride = realm.objects(RideInfo.self).first {
            try! realm.write {
                realm.delete(ride)
            }
            print(realm.objects(RideInfo.self))
        }
    }
    
    func changeIsNotified(val: Int){
        self.isNotified = val
    }
}

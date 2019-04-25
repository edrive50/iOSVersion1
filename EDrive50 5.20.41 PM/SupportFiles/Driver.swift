//
//  Models.swift
//  edrive50
//
//  Created by Suuba Magai on 2019-04-03.
//  Copyright © 2019 Suuba Magai. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class Driver : Object {
    
    @objc dynamic var name = ""
    @objc dynamic var phone_number = ""
    @objc dynamic var is_available : Bool = false
    @objc dynamic var driver_id = ""
    @objc dynamic var rating = 0.0
    @objc dynamic var user_description = ""
    @objc dynamic var make = ""
    @objc dynamic var model = ""
    @objc dynamic var colour = ""
    @objc dynamic var car_type = ""
    @objc dynamic var year = ""
    @objc dynamic var wheelchair : Bool = false
    @objc dynamic var physical_assistance : Bool = false
    @objc dynamic var big_truck : Bool = false
    @objc dynamic var other_details : Bool = false
    @objc dynamic var registered_name = ""
    @objc dynamic var licence_plate = ""
    @objc dynamic var vin = ""
    @objc dynamic var token = ""
    @objc dynamic var language = "En"
    
    func makeDriver(obj: JSON, token: String, language:String) -> Driver {

        let driver = Driver()

        driver.name = obj["data"]["name"].string!
        driver.phone_number = obj["data"]["phone_number"].string!
        driver.is_available = obj["data"]["is_available"].bool!
        driver.rating = obj["data"]["rating"].double!
        driver.driver_id = obj["data"]["driver_id"].string!
        driver.user_description = obj["data"]["user_description"].string!
        driver.make = obj["data"]["car_details"]["make"].string!
        driver.model = obj["data"]["car_details"]["model"].string!
        driver.colour = obj["data"]["car_details"]["colour"].string!
        driver.car_type = obj["data"]["car_details"]["car_type"].string!
        driver.year = obj["data"]["car_details"]["year"].string!
        driver.wheelchair = obj["data"]["car_details"]["accessibility_options"]["wheelchair"].bool!
        driver.physical_assistance = obj["data"]["car_details"]["accessibility_options"]["physical_assistance"].bool!
        driver.big_truck = obj["data"]["car_details"]["accessibility_options"]["big_truck"].bool!
        driver.other_details = obj["data"]["car_details"]["accessibility_options"]["other_details"].bool!
        driver.registered_name = obj["data"]["car_details"]["registrations_details"]["registered_name"].string!
        driver.licence_plate = obj["data"]["car_details"]["registrations_details"]["licence_plate"].string!
        driver.vin = obj["data"]["car_details"]["registrations_details"]["vin"].string!
        driver.token = token
        driver.language = language
            
        return driver
    }
    
    func save(driver : Driver) {
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(driver)
        }
        

    }
    
    func delete(driver : Driver) {
        let realm = try! Realm()
        
        if let user = realm.objects(Driver.self).first {
            try! realm.write {
                realm.delete(user)
            }

            print(realm.objects(Driver.self))
        }
    }
    
    func getDriver() -> Driver? {
        let realm = try! Realm()
        return realm.objects(Driver.self).first
    }
    
    func changeLanguage(language : String) {
        self.language = language
    }
    
    func changeAvailability(val:Bool){
        
        self.is_available = val
    }
    
    func count() -> Int {
        let realm = try! Realm()
        return realm.objects(Driver.self).count
    }
}


//
//  Rider.swift
//  edrive50
//
//  Created by Suuba Magai on 2019-04-04.
//  Copyright © 2019 Suuba Magai. All rights reserved.
//


import Foundation
import RealmSwift
import SwiftyJSON

class Rider : Object {
    @objc dynamic var name = ""
    @objc dynamic var phone_number = ""
    @objc dynamic var image = ""
    @objc dynamic var rider_id = ""

    @objc dynamic var emergency_name = ""
    @objc dynamic var emergency_number = ""

    @objc dynamic var wheelchair : Bool = false
    @objc dynamic var physical_assistance : Bool = false
    @objc dynamic var big_truck : Bool = false
    @objc dynamic var other_details = ""
    @objc dynamic var language = "En"

    @objc dynamic var card_type = ""
    @objc dynamic var expiry_date = ""
    @objc dynamic var cvv = 0
    @objc dynamic var cardholder_name = ""
    

    func makeRider(obj: JSON, token: String, language: String) -> Rider {
        let rider = Rider()

        rider.name = obj["data"]["name"].string!
        rider.phone_number = obj["data"]["phone_number"].string!
        rider.image = obj["data"]["image"].string!
        rider.rider_id = obj["data"]["rider_id"].string!
        rider.emergency_name = obj["data"]["emergency_contact_details"]["emergency_name"].string!
        rider.emergency_number = obj["data"]["emergency_contact_details"]["emergency_number"].string!
        rider.wheelchair = obj["data"]["accessibility_options"]["wheelchair"].bool!
        rider.physical_assistance = obj["data"]["accessibility_options"]["physical_assistance"].bool!
        rider.big_truck = obj["data"]["accessibility_options"]["big_truck"].bool!
        rider.other_details = obj["data"]["accessibility_options"]["other_details"].string!
        rider.language = language
        
        //payment implementation in version 2 of edrive50
//        rider.card_type = obj["data"]["payment_info"]["card_type"].string!
//        rider.expiry_date = obj["data"]["payment_info"]["card_type"].string!
//        rider.cvv = obj["data"]["payment_info"]["cvv"].int!
//        rider.cardholder_name = obj["data"]["payment_info"]["cardholder_name"].string!

        return rider
    }

    func save(rider : Rider) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(rider)
        }

        print(realm.objects(Rider.self))
    }

    func delete(rider : Rider) {
        let realm = try! Realm()

        if let user = realm.objects(Rider.self).first {
            try! realm.write {
                realm.delete(user)
            }
            print(realm.objects(Rider.self))
        }
    }
    
    func changeLanguage(language : String) {
        self.language = language
    }

    func count() -> Int {
        let realm = try! Realm()
        return realm.objects(Rider.self).count
    }
    
}

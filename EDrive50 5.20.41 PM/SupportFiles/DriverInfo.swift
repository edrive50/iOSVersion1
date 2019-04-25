//
//  DriverInfo.swift
//  edrive50
//
//  Created by Suuba Magai on 2019-03-23.
//  Copyright © 2019 Suuba Magai. All rights reserved.
//

import Foundation

class DriverInfo {
    
    var driverProfile: String?
    
    var name: String?
    var password: String?
    var emailaddress: String?
    var phoneNumber: String?
    var emergencyName: String?
    var emergencyNumber: String?
    var wheelChair: Bool?
    var physicalAssistance: Bool?
    var bigTruck: Bool?
    var other: Bool?
    var vehicleMake: String?
    var vehicleModel: String?
    var vehicleType: String?
    var vehicleColour: String?
    var vehicleYear: String?
    
    var description: String?
    
    var registered_name: String?
    var licence_plate: String?
    var vin: String?
    
    init(name: String, password: String, email: String, phonenumber: String) {
        self.name = name
        self.password = password
        self.emailaddress = email
        self.phoneNumber = phonenumber
    }
    
    func addAccessibility(wheelChair: Bool, physicalAssistance: Bool, bigTruck: Bool, other: Bool) {
        self.wheelChair = wheelChair
        self.physicalAssistance = physicalAssistance
        self.bigTruck = bigTruck
        self.other = other
    }
    
    func addCarDetails(description: String, vehicleMake: String, vehicleModel: String, vehicleType: String, vehicleColour: String, vehicleYear: String) {
        self.description = description
        self.vehicleMake = vehicleMake
        self.vehicleModel = vehicleModel
        self.vehicleType  = vehicleType
        self.vehicleColour = vehicleColour
        self.vehicleYear = vehicleYear
    }
    
    
}

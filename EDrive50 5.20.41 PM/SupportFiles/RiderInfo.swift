//
//  RiderInfo.swift
//  edrive50
//
//  Created by Suuba Magai on 2019-03-20.
//  Copyright © 2019 Suuba Magai. All rights reserved.
//

import Foundation

class RiderInfo {
    
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
    
    var cardNumber: String?
    var expiryDate: String?
    var cvv: Int?
    var cardHolderName: String?
    
    init(name: String, password: String, email: String, phonenumber: String) {

        self.name = name
        self.password = password
        self.emailaddress = email
        self.phoneNumber = phonenumber
    }
    
    func addCardDetails(cardNumber: String, expiryDate: String, cvv: Int, cardHolderName: String) {
        self.cardNumber = cardNumber
        self.expiryDate = expiryDate
        self.cvv = cvv
        self.cardHolderName = cardHolderName
    }
    
    func addEmergencyContact(emergencyName: String, emergencyNumber: String){
        
        self.emergencyName = emergencyName
        self.emergencyNumber = emergencyNumber
        
    }
    
    func addAccessibility(wheelChair: Bool, physicalAssistance: Bool, bigTruck: Bool, other: Bool){
        
        self.wheelChair = wheelChair
        self.physicalAssistance = physicalAssistance
        self.bigTruck = bigTruck
        self.other = other
    }
    
}

//
//  Farm.swift
//  Agribusiness
//
//  Created by Aluno on 24/05/18.
//  Copyright © 2018 Quaini, Tiago. All rights reserved.
//

import Foundation

struct Farm: Codable{
    var name: String
    var address: String
    var milkBarrels: Int
    var startTime: Date
    var endTime: Date
    
    static let DocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("Farms").appendingPathExtension("plist")
    
    static func loadFarms() -> [Farm]?  {
        guard let codedFarms = try? Data(contentsOf: ArchiveURL) else {return nil}
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(Array<Farm>.self, from: codedFarms)
    }
    
    static func loadSampleFarms() -> [Farm] {
        let farm1 = Farm(name: "Farm One", address: "Address Farm One", milkBarrels: 1000,
                         startTime: Date(), endTime: Date())
        let farm2 = Farm(name: "Farm Two", address: "Address Farm Two", milkBarrels: 5000,
                         startTime: Date(), endTime: Date())
        let farm3 = Farm(name: "Farm Three", address: "Address Farm Three", milkBarrels: 6000,
                         startTime: Date(), endTime: Date())
        
        return [farm1, farm2, farm3]
    }
    
    static func saveFarms(_ farmList: [Farm]) {
        let propertyListEncoder = PropertyListEncoder()
        let codedFarms = try? propertyListEncoder.encode(farmList)
        try? codedFarms?.write(to: ArchiveURL, options: .noFileProtection)
    }
}

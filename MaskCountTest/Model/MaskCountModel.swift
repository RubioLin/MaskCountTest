//
//  MaskCountModel.swift
//  MaskCountTest
//
//  Created by 林俊緯 on 2022/7/8.
//

import Foundation

struct MaskCount: Codable {
    let type: String?
    let features: [MaskCount_Features]?
}

struct MaskCount_Features: Codable {
    let type: String?
    let properties: MaskCount_Features_Properties?
    let geometry: MaskCount_Features_Geometry?
}

struct MaskCount_Features_Properties: Codable {
    let id: String?
    let name: String?
    let phone: String?
    let address: String?
    let mask_adult: Int?
    let mask_child: Int?
    let updated: String?
    let available: String?
    let note: String?
    let custom_note: String?
    let website: String?
    let county: String?
    let town: String?
    let cunli: String?
    let service_periods: String?
}

struct MaskCount_Features_Geometry: Codable {
    let type: String?
    let coordinates: [Float]?
}

struct ClinicInfo {
    var name: String?
    var phone: String?
    var mask_adult: Int?
    var mask_child: Int?
    var address: String?
    var updated: String?
    var county: String?
    var town: String?
}

struct CountyTown {
    var county: String?
    var town: [String]
}

//
//  File.swift
//  grip
//
//  Created by Anthony J. Sherrill Jr. on 01.06.18.
//  Copyright © 2018 SherrillTrust. All rights reserved.
//

import Foundation

struct ProductStruct: Codable {
//    let product: Product?
    let gtin: String?
    let name: String?
    let producer: String?
    let concern: String?
    let pictureURL: String?
//    enum CodingKeys: String, CodingKey {
//        case product
//        case productGTIN = "code"
//        case producer
//        case productName = "product_name"
//    }
}

//struct Product: Codable {
//    let brand: String?
//}

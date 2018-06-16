//
//  File.swift
//  grip
//
//  Created by Anthony J. Sherrill Jr. on 01.06.18.
//  Copyright © 2018 SherrillTrust. All rights reserved.
//

import Foundation

struct Product: Codable {
    let gtin: String
    var producer: String
    var productName: String
}

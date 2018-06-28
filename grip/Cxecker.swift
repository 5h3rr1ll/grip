//
//  Cxecker.swift
//  grip
//
//  Created by Anthony J. Sherrill Jr. on 22.06.18.
//  Copyright © 2018 SherrillTrust. All rights reserved.
//

import Foundation

//protocol ratelyyDBDelegate {
//    func didFetch(productList: [String])
//    func didFailFetchingProduct(error: Error)
//}

/** Cxecker is a class whichs hast function to check is a product is already exisiting in the own ratelyyDB and also so to complete a incompleted product with the help of further databases like OpenFoodFacts, OpenGTINDatabase and OpenProductDatabse*/
class Cxecker {
    
    /** This function takes a GTIN-Code as a string and checks ratelyys own dabase if the product is already available. If so, it returns a complete product object and a emty list within a tupel, if not, it will give back a incomplete product object and a list with the missing attributes */
    func ratelyyDB(gtin: String) {
        // This Class hast funtions to check the own ratelyyDB if
        
        //    var delegate: ratelyyDBDelegate?
        
        let ratelyyDB = String("http://localhost:4000/product/\(gtin)")
        
        guard let url = URL(string: ratelyyDB) else {
            print("Error: cannot create URL")
            return
        }
        
        let urlRequest = URLRequest(url: url)
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        session.dataTask(with: urlRequest) { (data, _, error) in
            if let error = error {
                print(error)
                return
            }
            
            if let data = data {
                do {
                    var missingAttributes = [String]()
                    
                    let product = try JSONDecoder().decode([ProductStruct].self, from: data)
                    dump(product)
                    
                    if product[0].name! == "" {
                        missingAttributes.append("name")
                    }
                    if product[0].concern! == "" {
                        missingAttributes.append("concern")
                    }
                    if product[0].pictureURL! == "" {
                        missingAttributes.append("pictureULR")
                    }
                    if product[0].producer! == "" {
                        missingAttributes.append("producer")
                    }
                    if missingAttributes.count > 0 {
                        print("Es fehl(t/en) folgende(s) Attribut(e): ", missingAttributes)
                    }
                    
                } catch {
                    print("Error: Cxecker has a problem decoding the data")
                }
            }
        }.resume()
    }
}

//session.dataTask(with: urlRequest) {
//    (data, _, error) in
//    // check for any errors
//    if let error = error {
//        // Make sure UI stuff is run on the main thread
//        OperationQueue.main.addOperation {
//            delegate?.didFailFetchingProduct(error: error)
//        }
//        print("error calling GET on OptenGTINDatabase")
//        print(error)
//        return
//    }
//
//    if let data = data {
//        // parse the result, which is String. It willbecome split and placed in a dictionary
//        do {
//            let answer = try JSONDecoder().decode(ProductStruct, from: data)
//
//            OperationQueue.main.addOperation {
//                delegate?.didFetch(product: product)
//            }
//        }
//    }
//    }.resume()

//
//  OFFAPI.swift
//  grip
//
//  Created by Anthony J. Sherrill Jr. on 16.06.18.
//  Copyright © 2018 SherrillTrust. All rights reserved.
//

import UIKit

protocol OFFDelegate {
    func didFetch(product: ProductStruct)
    func didFailFetchingProduct(error: Error)
}

class OFF {
    
    var delegate: OFFDelegate?
    
    // Function that request the www.opengtindb.org API which returns a string with informations to a product
    func requestOFF(code gtin: String) {
        
        // Set up the URL request
        let offAPI = String("https://world.openfoodfacts.org/api/v0/product/\(gtin).json")
        guard let url = URL(string: offAPI) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = URLRequest(url: url)
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // make the request
        session.dataTask(with: urlRequest) { (data, _, error) in
            // check for any errors
            if let error = error {
                // Make sure UI stuff is run on the main thread
                OperationQueue.main.addOperation {
                    self.delegate?.didFailFetchingProduct(error: error)
                }
                return
            }
            
            if let data = data {
                do {
                    let product = try JSONDecoder().decode(ProductStruct.self, from: data)
                    
                    OperationQueue.main.addOperation {
                        self.delegate?.didFetch(product: product)
                    }
                } catch {
                    // Decode failed
                    OperationQueue.main.addOperation {
                        self.delegate?.didFailFetchingProduct(error: error)
                    }
                }
            }
            }.resume()
    }
}

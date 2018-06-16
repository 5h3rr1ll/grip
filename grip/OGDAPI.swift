//
//  ApiOGD.swift
//  grip
//
//  Created by Anthony J. Sherrill Jr. on 27.05.18.
//  Copyright © 2018 SherrillTrust. All rights reserved.
//
// This file connects to the http://opengtindb.org

import UIKit

protocol OGDStringDelegate {
    func didFetch(string: String)
    func didFailFetchingString(error: Error)
}


class OGD {
    var delegate: OGDStringDelegate?
    
    // Function that request the www.opengtindb.org API which returns a string with informations to a product
    func requestOGD(code gtin: String) {
        
        // MARK: Properties
        var answerList: [String.SubSequence] = []
        var answerDic: [String:String] = [:]
        var product_name: String = ""
        var producer: String = ""
        
        // Set up the URL request
        let ogdAPI = String("http://opengtindb.org/?ean=\(gtin)&cmd=query&queryid=400000000")
        guard let url = URL(string: ogdAPI) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = URLRequest(url: url)
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // make the request
        let task = session.dataTask(with: urlRequest) {
            (data, _, error) in
            // check for any errors
            guard error == nil else {
                OperationQueue.main.addOperation {
                    self.delegate?.didFailFetchingString(error: error!)
                }
                print("error calling GET on /todos/1")
                print(error!)
                return
            }
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            // parse the result, which is String. It willbecome split and placed in a dictionary
            do {
                let answer = (String(decoding: responseData, as: UTF8.self))
                
                answerList = answer.split(separator: "\n")
                
                for entry in answerList {
                    let entry1 = entry.split(separator: "=")
                    if entry1.count > 1 {
                        let foo = String(entry1[0])
                        let bar = String(entry1[1])
                        answerDic[foo] = "\(bar)"
                    }
                }
                
                if answerDic["error"] == "0" {
                    product_name = answerDic["detailname"]!
                    producer = answerDic["vendor"]!
                    
                    OperationQueue.main.addOperation {
                        self.delegate?.didFetch(string: product_name)
                    }
                    
                } else {
                    
                    print("Error-Code der Seite lautet: \(String(describing: answerDic["error"]))")
                    return
                    
                }
            }
        }
        task.resume()
    }
    
}

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
    func didFetch(answerList: [String])
    func didFailFetchingString(error: Error)
}


class OGD {
    
    var delegate: OGDStringDelegate?
    
    // MARK: Properties
    var answerList: [String.SubSequence] = []
    var stringAnswerList: [String] = []
    var answerDic: [String:String] = [:]
    var product_name: String = ""
    var producer: String = ""
    
    // Function that request the www.opengtindb.org API which returns a string with informations to a product
    func requestOGD(code gtin: String) {
        
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
        session.dataTask(with: urlRequest) {
            (data, _, error) in
            // check for any errors
            if let error = error {
                // Make sure UI stuff is run on the main thread
                OperationQueue.main.addOperation {
                    self.delegate?.didFailFetchingString(error: error)
                }
                print("error calling GET on /todos/1")
                print(error)
                return
            }
            
            if let data = data {
                // parse the result, which is String. It willbecome split and placed in a dictionary
                do {
                    let answer = String(decoding: data, as: UTF8.self)
                    
                    self.answerList = answer.split(separator: "\n")
                    
                    for entry in self.answerList {
                        let entry1 = entry.split(separator: "=")
                        if entry1.count > 1 {
                            let foo = String(entry1[0])
                            let bar = String(entry1[1])
                            self.answerDic[foo] = "\(bar)"
                            self.stringAnswerList.append(foo)
                            self.stringAnswerList.append(bar)
                        }
                    }
                    
                    OperationQueue.main.addOperation {
                        self.delegate?.didFetch(answerList: self.stringAnswerList)
                    }
                    
                    if self.answerDic["error"] == "0" {
                        self.product_name = self.answerDic["detailname"]!
                        self.producer = self.answerDic["vendor"]!
                        
                    } else {
                        
                        print("Error-Code der Seite lautet: \(String(describing: self.answerDic["error"]))")
                        return
                        
                    }
                }
            }
        }.resume()
    }
}

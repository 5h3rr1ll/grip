//
//  DetailsViewController.swift
//  grip
//
//  Created by Anthony J. Sherrill Jr. on 13.04.18.
//  Copyright © 2018 SherrillTrust. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productBrand: UILabel!
    
    //code ist der übergebene Wert aus TableViewController
    var code = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: Methods
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

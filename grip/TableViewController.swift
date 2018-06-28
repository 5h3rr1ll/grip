//
//  TableViewController.swift
//  grip
//
//  Created by Anthony J. Sherrill Jr. on 13.04.18.
//  Copyright © 2018 SherrillTrust. All rights reserved.
//

import UIKit
import os.log

class TableViewController: UITableViewController, OGDDelegate {
    
    //MARK: Properties
    var listOfCodes = [String]()
    
    let off = OFF()

    // MARK: -
    private let ogd = OGD()
    private var product: ProductStruct? {
        didSet {
            if product != nil {
                refreshControl?.endRefreshing()
                
                // Reload the first section (we only have one) animated.
                tableView.reloadSections([0], with: .automatic)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Übersicht"
                
        ogd.delegate = self
        
        ogd.requestOGD(code: listOfCodes[0])
        
        off.requestOFF(code: listOfCodes[0])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Outlets & Views
    
    func didFetch(product: ProductStruct) {
        self.product = product
    }
    
    func didFailFetchingProduct(error: Error) {
        return
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listOfCodes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NurCodeZelle", for: indexPath)

        // Configure the cell...
        if product != nil {
            cell.textLabel?.text = product!.productGTIN! + " " + product!.productName!
            return cell
        } else {
            print("Error: Product is empty!")
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegue(withIdentifier: "segueDetail", sender: nil)
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "AddCode":
            os_log("Adding a new code.", log: OSLog.default, type: .debug)
            
        case "ShowDetail":
            guard let codeDetailViewController = segue.destination as? DetailsViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedCodeCell = sender as? UITableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedCodeCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedCode = listOfCodes[indexPath.row]
            codeDetailViewController.code = selectedCode
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }

}

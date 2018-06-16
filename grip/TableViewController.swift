//
//  TableViewController.swift
//  grip
//
//  Created by Anthony J. Sherrill Jr. on 13.04.18.
//  Copyright © 2018 SherrillTrust. All rights reserved.
//

import UIKit
import os.log

class TableViewController: UITableViewController, OGDStringDelegate {

    //MARK: Properties
    var listOfCodes = [String]()

    // MARK: -
    private let ogd = OGD()
    private var answerList: [String]? {
        didSet {
            if answerList != nil {
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Outlets & Views
    
    func didFetch(answerList: [String]) {
        self.answerList = answerList
    }
    
    func didFailFetchingString(error: Error) {
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
        cell.textLabel?.text = answerList?[indexPath.row]

        return cell
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

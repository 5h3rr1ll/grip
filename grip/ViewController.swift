//
//  ViewController.swift
//  grip
//
//  Created by Anthony J. Sherrill Jr. on 13.04.18.
//  Copyright © 2018 SherrillTrust. All rights reserved.
//

import UIKit
import ScanditBarcodeScanner

class ViewController: UIViewController {
    
    //MARK: Properties
    var listOfCodes = [String]()
    let button = UIButton()
    let SCREEN_SIZE = UIScreen.main.bounds
    let cornerRadius : CGFloat = 5.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupScanner()
        
//        requestOGD(code: "4388844154636") {
//            (result: String) in
//            print("Was geht ab?", result)
//        }
        
        //MARK: Button Konfiguration
        let fertigButton = UIButton(frame: CGRect(x: 0, y: SCREEN_SIZE.height-50, width: SCREEN_SIZE.width, height: 50))
        fertigButton.backgroundColor = .lightGray
        fertigButton.setTitle("Fertig", for: .normal)
        fertigButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        fertigButton.layer.cornerRadius = cornerRadius
        
        
        self.view.addSubview(fertigButton)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tableViewController = segue.destination as? TableViewController {
            tableViewController.listOfCodes = listOfCodes
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        barcodePicker(<#T##picker: SBSBarcodePicker##SBSBarcodePicker#>, didScan: <#T##SBSScanSession#>)
    }
    
    //MARK: Scanner Setup
    private func setupScanner() {
        // Scandit Barcode Scanner Integration
        // The following method calls illustrate how the Scandit Barcode Scanner can be integrated
        // into your app.
        
        // Create the scan settings and enabling some symbologies
        let settings = SBSScanSettings.default()
        let symbologies: Set<SBSSymbology> = [.ean8, .ean13, .qr]
        for symbology in symbologies {
            settings.setSymbology(symbology, enabled: true)
            
            // Enable restrict area
            settings.setActiveScanningArea(CGRect(x: 0, y: 0.48, width: 1, height: 0.04))
        }
        
        // Create the barcode picker with the settings just created
        let barcodePicker = SBSBarcodePicker(settings:settings)
        
        // Add the barcode picker as a child view controller
        addChildViewController(barcodePicker)
        view.addSubview(barcodePicker.view)
        barcodePicker.didMove(toParentViewController: self)
        
        // Set the allowed interface orientations. The value UIInterfaceOrientationMaskAll is the
        // default and is only shown here for completeness.
        barcodePicker.allowedInterfaceOrientations = .all
        // Set the delegate to receive scan event callbacks
        barcodePicker.scanDelegate = self
        barcodePicker.startScanning()
    }
    
    //MARK: Actions
    @objc func buttonAction(sender: UIButton!) {
        //        print("Button pressed")
        performSegue(withIdentifier: "segue1", sender: button)
    }
    
    
}

extension ViewController: SBSScanDelegate {
    
    func barcodePicker(_ picker: SBSBarcodePicker, didScan session: SBSScanSession) {
        guard let code = session.newlyRecognizedCodes.first else { return }
        // Gescannten Code zum Array hinzufügen sofern nicht schon vorhanden
        if listOfCodes.contains(code.data!) {
            //            print("Schon gescannt!")
        } else {
            listOfCodes.append(code.data!)
            print("scanned \(code.symbologyName) barcode: \(String(describing: code.data))")
        }
    }
    func overlayController(_ overlayController: SBSOverlayController, didCancelWithStatus status: [AnyHashable : Any]?) {
        // Add your own code to handle the user canceling the barcode scan process
    }
}


//
//  ViewController.swift
//  APPropertyWrappers-Example
//
//  Created by Anton Plebanovich on 4/12/19.
//  Copyright © 2019 Anton Plebanovich. All rights reserved.
//

import APPropertyWrappers
import UIKit

final class ViewController: UIViewController {
    
    // ******************************* MARK: - @IBOutlets
    
    // ******************************* MARK: - Property Wrappers
    
    /// Allows to get rid of force unwrapping
    @LateInitialized var viewModel: String
    
    @UserDefaultCodable(key: "ViewController_runCounter", defaultValue: 0)
    var runCounter: Int
    
    @BoolPreserved(key: "ViewController_crashed")
    var crashed: Bool
    
    // ******************************* MARK: - Initialization and Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        runCounter += 1
        print("Run count: \(runCounter)")
        
        viewModel = "viewModel"
        print(viewModel)
        
        if crashed {
            print("The app crashed previously!")
            crashed = false
            
        } else {
            print("Crashing!")
            crashed = true
            exit(0)
        }
    }
}

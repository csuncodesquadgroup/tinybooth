//
//  HelpViewController.swift
//  tinybooth
//
//  Created by Camrynn Dilley on 6/18/20.
//  Copyright © 2020 codesquad. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {
    
    
    @IBOutlet weak var contactTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        // Do any additional setup after loading the view.
    }

    @IBAction func exitButton_TouchUpInside(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }    
    
    func contactTextLink() {

    }

}




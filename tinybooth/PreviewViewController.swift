//
//  PreviewViewController.swift
//  tinybooth
//
//  Created by Camrynn Dilley on 6/4/20.
//  Copyright © 2020 codesquad. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    // Linked to the "Redo" button on Preview screen of Main.storyboard
    @IBAction func redoButton_TouchUpInside(_ sender: Any) {
        
        // dismisses preview modal
        dismiss(animated: true, completion: nil)
        
    }

    // Linked to the "Print" button on Preview screen of Main.storyboard
    @IBAction func printButton_TouchUpInside(_ sender: Any) {
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

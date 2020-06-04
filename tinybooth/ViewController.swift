//
//  ViewController.swift
//  tinybooth
//
//  Created by Camrynn Dilley on 6/2/20.
//  Copyright © 2020 codesquad. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    // Linked to the camera/shutter button on maine view controller of Main.storyboard (like the initial screen you see when you open up the app
    @IBAction func cameraButton_TouchUpInside(_ sender: Any) {
        
        // this opens up the PreviewVieweController when the camera/shutter button is tapped
        performSegue(withIdentifier: "showPhotoSegue", sender: nil)
    }
    
}

